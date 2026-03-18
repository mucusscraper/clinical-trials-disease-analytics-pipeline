package etl

import (
	"context"
	"database/sql"
	"encoding/json"
	"fmt"
	"strings"
	"time"

	"github.com/google/uuid"
	"github.com/mucusscraper/clinical-trials-disease-analytics-pipeline/internal/api"
	"github.com/mucusscraper/clinical-trials-disease-analytics-pipeline/internal/database"
	"github.com/sqlc-dev/pqtype"
)

type State struct {
	db *database.Queries
}

func (state *State) InsertBronze(ctx context.Context, study api.Studies, condition string) error {
	now := time.Now()
	JSONStudy, err := json.Marshal(study)
	if err != nil {
		return fmt.Errorf("Error marshaling the study: %w", err)
	}
	_, err = state.db.CreateRowBronze(ctx, database.CreateRowBronzeParams{
		ID:        uuid.New(),
		NctID:     study.ProtocolSection.IdentificationModule.NctId,
		Condition: condition,
		RawJson: pqtype.NullRawMessage{
			RawMessage: JSONStudy,
			Valid:      true,
		},
		CreatedAt: now,
		UpdatedAt: now,
	})
	return err
}

func (state *State) InsertSilver(ctx context.Context, study api.Studies, condition string) error {
	now := time.Now()
	NCTID := study.ProtocolSection.IdentificationModule.NctId
	Condition := condition
	Title := study.ProtocolSection.IdentificationModule.OfficialTitle
	StudyType := study.ProtocolSection.DesignModule.StudyType
	Phase := strings.Join(study.ProtocolSection.DesignModule.Phases, "|")
	Enrollment := study.ProtocolSection.DesignModule.EnrollmentInfo.Count
	OverallStatus := study.ProtocolSection.StatusModule.OverAllStatus
	startDate, startPrecision, startValid := normalizeDate(
		study.ProtocolSection.StatusModule.ExpandedAcessInfo.StartDateStruct.Date,
	)
	primaryDate, primaryPrecision, primaryValid := normalizeDate(
		study.ProtocolSection.StatusModule.ExpandedAcessInfo.PrimaryCompletionDateStruct.Date,
	)
	completionDate, completionPrecision, completionValid := normalizeDate(
		study.ProtocolSection.StatusModule.ExpandedAcessInfo.CompletionDateStruct.Date,
	)
	firstSubmitDate, firstSubmitPrecision, firstSubmitValid := normalizeDate(
		study.ProtocolSection.StatusModule.ExpandedAcessInfo.StudyFirstSubmitDate,
	)
	lastUpdateDate, lastUpdatePrecision, lastUpdateValid := normalizeDate(
		study.ProtocolSection.StatusModule.ExpandedAcessInfo.LastUpdateSubmitDate,
	)
	HasResults := study.HasResults
	_, err := state.db.CreateRowSilverUpsertStudies(ctx, database.CreateRowSilverUpsertStudiesParams{
		ID:        uuid.New(),
		NctID:     NCTID,
		Condition: condition,
		Title: sql.NullString{
			String: Title,
			Valid:  Title != "",
		},
		StudyType: sql.NullString{
			String: StudyType,
			Valid:  StudyType != "",
		},
		Phase: sql.NullString{
			String: Phase,
			Valid:  Phase != "",
		},
		Enrollment: sql.NullInt32{
			Int32: int32(Enrollment),
			Valid: Enrollment != 0,
		},
		OverallStatus: sql.NullString{
			String: OverallStatus,
			Valid:  OverallStatus != "",
		},
		StartDate: sql.NullTime{
			Time:  startDate,
			Valid: startValid,
		},
		StartDatePrecision: sql.NullString{
			String: startPrecision,
			Valid:  startPrecision != "",
		},
		PrimaryCompletionDate: sql.NullTime{
			Time:  primaryDate,
			Valid: primaryValid,
		},
		PrimaryCompletionDatePrecision: sql.NullString{
			String: primaryPrecision,
			Valid:  primaryPrecision != "",
		},
		CompletionDate: sql.NullTime{
			Time:  completionDate,
			Valid: completionValid,
		},
		CompletionDatePrecision: sql.NullString{
			String: completionPrecision,
			Valid:  completionPrecision != "",
		},
		FirstSubmitDate: sql.NullTime{
			Time:  firstSubmitDate,
			Valid: firstSubmitValid,
		},
		FirstSubmitDatePrecision: sql.NullString{
			String: firstSubmitPrecision,
			Valid:  firstSubmitPrecision != "",
		},
		LastUpdateSubmitDate: sql.NullTime{
			Time:  lastUpdateDate,
			Valid: lastUpdateValid,
		},
		LastUpdateSubmitDatePrecision: sql.NullString{
			String: lastUpdatePrecision,
			Valid:  lastUpdatePrecision != "",
		},
		HasResults: sql.NullBool{
			Bool:  HasResults,
			Valid: true,
		},
		CreatedAt: now,
		UpdatedAt: now,
	})
}

func normalizeDate(input string) (time.Time, string, bool) {
	if input == "" {
		return time.Time{}, "", false
	}

	dashes := strings.Count(input, "-")

	switch dashes {
	case 1: // YYYY-MM
		t, err := time.Parse("2006-01-02", input+"-01")
		if err != nil {
			return time.Time{}, "", false
		}
		return t, "month", true

	case 2: // YYYY-MM-DD
		t, err := time.Parse("2006-01-02", input)
		if err != nil {
			return time.Time{}, "", false
		}
		return t, "day", true

	default:
		return time.Time{}, "", false
	}
}
