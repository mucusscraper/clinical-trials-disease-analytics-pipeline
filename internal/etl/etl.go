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
	DB *database.Queries
}

func (state *State) InsertBronze(ctx context.Context, study api.Studies, condition string) error {
	now := time.Now()
	JSONStudy, err := json.Marshal(study)
	if err != nil {
		return fmt.Errorf("Error marshaling the study: %w", err)
	}
	_, err = state.DB.CreateRowBronze(ctx, database.CreateRowBronzeParams{
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
	Title := study.ProtocolSection.IdentificationModule.OfficialTitle
	StudyType := study.ProtocolSection.DesignModule.StudyType
	Phase := strings.Join(study.ProtocolSection.DesignModule.Phases, "|")
	Enrollment := study.ProtocolSection.DesignModule.EnrollmentInfo.Count
	startDate, startPrecision, startValid := normalizeDate(
		study.ProtocolSection.StatusModule.StartDateStruct.Date,
	)
	primaryDate, primaryPrecision, primaryValid := normalizeDate(
		study.ProtocolSection.StatusModule.PrimaryCompletionDateStruct.Date,
	)
	completionDate, completionPrecision, completionValid := normalizeDate(
		study.ProtocolSection.StatusModule.CompletionDateStruct.Date,
	)
	firstSubmitDate, firstSubmitPrecision, firstSubmitValid := normalizeDate(
		study.ProtocolSection.StatusModule.StudyFirstSubmitDate,
	)
	lastUpdateDate, lastUpdatePrecision, lastUpdateValid := normalizeDate(
		study.ProtocolSection.StatusModule.LastUpdateSubmitDate,
	)
	HasResults := study.HasResults
	SilverStudyRow, err := state.DB.CreateRowSilverUpsertStudies(ctx, database.CreateRowSilverUpsertStudiesParams{
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
	if err != nil {
		return fmt.Errorf("Error : %w", err)
	}
	LeadSponsor := study.ProtocolSection.SponsorCollaboratorsModule.LeadSponsor
	if LeadSponsor.Name != "" {
		_, err = state.DB.CreateRowSilverSponsors(ctx, database.CreateRowSilverSponsorsParams{
			StudyID: SilverStudyRow.ID,
			Name:    LeadSponsor.Name,
			Class: sql.NullString{
				String: LeadSponsor.Class,
				Valid:  LeadSponsor.Class != "",
			},
			CreatedAt: now,
			UpdatedAt: now,
		})
		if err != nil {
			return fmt.Errorf("Error creating lead sponsors: %w", err)
		}
	}
	for _, Collaborator := range study.ProtocolSection.SponsorCollaboratorsModule.Collaborators {
		if Collaborator.Name != "" {
			_, err = state.DB.CreateRowSilverCollaborators(ctx, database.CreateRowSilverCollaboratorsParams{
				ID:      uuid.New(),
				StudyID: SilverStudyRow.ID,
				Name:    Collaborator.Name,
				Class: sql.NullString{
					String: Collaborator.Class,
					Valid:  Collaborator.Class != "",
				},
				CreatedAt: now,
				UpdatedAt: now,
			})
			if err != nil {
				return fmt.Errorf("Error creating collaborators: %w", err)
			}
		}
	}
	for _, Location := range study.ProtocolSection.ContactsLocationsModule.Locations {
		_, err = state.DB.CreateRowSilverLocations(ctx, database.CreateRowSilverLocationsParams{
			ID:      uuid.New(),
			StudyID: SilverStudyRow.ID,
			City: sql.NullString{
				String: Location.City,
				Valid:  Location.City != "",
			},
			State: sql.NullString{
				String: Location.State,
				Valid:  Location.State != "",
			},
			Country: sql.NullString{
				String: Location.Country,
				Valid:  Location.Country != "",
			},
			Latitude: sql.NullFloat64{
				Float64: Location.GeoPoint.Latitude,
				Valid:   Location.GeoPoint.Latitude != 0.0,
			},
			Longitude: sql.NullFloat64{
				Float64: Location.GeoPoint.Longitude,
				Valid:   Location.GeoPoint.Longitude != 0.0,
			},
			CreatedAt: now,
			UpdatedAt: now,
		})
		if err != nil {
			return fmt.Errorf("Error creating locations: %w", err)
		}
	}
	for _, Intervention := range study.ProtocolSection.ArmsInterventionsModule.Interventions {
		_, err = state.DB.CreateRowSilverInterventions(ctx, database.CreateRowSilverInterventionsParams{
			ID:      uuid.New(),
			StudyID: SilverStudyRow.ID,
			Type:    Intervention.Type,
			Name:    Intervention.Name,
			Description: sql.NullString{
				String: Intervention.Description,
				Valid:  Intervention.Description != "",
			},
			CreatedAt: now,
			UpdatedAt: now,
		})
		if err != nil {
			return fmt.Errorf("Error creating interventions: %w", err)
		}
	}
	for _, PrimaryOutcome := range study.ProtocolSection.OutcomesModule.PrimaryOutcomes {
		_, err = state.DB.CreateRowSilverOutcomes(ctx, database.CreateRowSilverOutcomesParams{
			ID:      uuid.New(),
			StudyID: SilverStudyRow.ID,
			Type:    "Primary",
			Measure: PrimaryOutcome.Measure,
			Timeframe: sql.NullString{
				String: PrimaryOutcome.TimeFrame,
				Valid:  PrimaryOutcome.TimeFrame != "",
			},
			CreatedAt: now,
			UpdatedAt: now,
		})
		if err != nil {
			return fmt.Errorf("Error creating outcomes: %w", err)
		}
	}
	for _, SecondaryOutcome := range study.ProtocolSection.OutcomesModule.SecondaryOutcomes {
		_, err = state.DB.CreateRowSilverOutcomes(ctx, database.CreateRowSilverOutcomesParams{
			ID:      uuid.New(),
			StudyID: SilverStudyRow.ID,
			Type:    "Secondary",
			Measure: SecondaryOutcome.Measure,
			Timeframe: sql.NullString{
				String: SecondaryOutcome.TimeFrame,
				Valid:  SecondaryOutcome.TimeFrame != "",
			},
			CreatedAt: now,
			UpdatedAt: now,
		})
		if err != nil {
			return fmt.Errorf("Error creating outcomes: %w", err)
		}
	}
	for _, Reference := range study.ProtocolSection.ReferencesModule.References {
		_, err := state.DB.CreateRowSilverReferences(ctx, database.CreateRowSilverReferencesParams{
			ID:      uuid.New(),
			StudyID: SilverStudyRow.ID,
			Pmid: sql.NullString{
				String: Reference.Pmid,
				Valid:  Reference.Pmid != "",
			},
			Type: sql.NullString{
				String: Reference.Type,
				Valid:  Reference.Type != "",
			},
			Citation: sql.NullString{
				String: Reference.Citation,
				Valid:  Reference.Citation != "",
			},
			CreatedAt: now,
			UpdatedAt: now,
		})
		if err != nil {
			return fmt.Errorf("Error creating references: %w", err)
		}
	}
	_, err = state.DB.CreateRowSilverEligibility(ctx, database.CreateRowSilverEligibilityParams{
		StudyID: SilverStudyRow.ID,
		Sex: sql.NullString{
			String: study.ProtocolSection.EligibilityModule.Sex,
			Valid:  study.ProtocolSection.EligibilityModule.Sex != "",
		},
		StdAges: sql.NullString{
			String: strings.Join(study.ProtocolSection.EligibilityModule.StdAges, "|"),
			Valid:  strings.Join(study.ProtocolSection.EligibilityModule.StdAges, "|") != "",
		},
		CreatedAt: now,
		UpdatedAt: now,
	})
	if err != nil {
		return fmt.Errorf("Error creating eligibility: %w", err)
	}
	_, err = state.DB.CreateRowSilverDesignDetails(ctx, database.CreateRowSilverDesignDetailsParams{
		StudyID: SilverStudyRow.ID,
		Allocation: sql.NullString{
			String: study.ProtocolSection.DesignModule.DesignInfo.Allocation,
			Valid:  study.ProtocolSection.DesignModule.DesignInfo.Allocation != "",
		},
		InterventionModel: sql.NullString{
			String: study.ProtocolSection.DesignModule.DesignInfo.InterventionModel,
			Valid:  study.ProtocolSection.DesignModule.DesignInfo.InterventionModel != "",
		},
		PrimaryPurpose: sql.NullString{
			String: study.ProtocolSection.DesignModule.DesignInfo.PrimaryPurpose,
			Valid:  study.ProtocolSection.DesignModule.DesignInfo.PrimaryPurpose != "",
		},
		Masking: sql.NullString{
			String: study.ProtocolSection.DesignModule.DesignInfo.MaskingInfo.Masking,
			Valid:  study.ProtocolSection.DesignModule.DesignInfo.MaskingInfo.Masking != "",
		},
		CreatedAt: now,
		UpdatedAt: now,
	})
	if err != nil {
		return fmt.Errorf("Error creating design details: %w", err)
	}
	_, err = state.DB.CreateRowSilverResponsibleParties(ctx, database.CreateRowSilverResponsiblePartiesParams{
		StudyID: SilverStudyRow.ID,
		Type: sql.NullString{
			String: study.ProtocolSection.SponsorCollaboratorsModule.ResponsibleParty.Type,
			Valid:  study.ProtocolSection.SponsorCollaboratorsModule.ResponsibleParty.Type != "",
		},
		InvestigatorName: sql.NullString{
			String: study.ProtocolSection.SponsorCollaboratorsModule.ResponsibleParty.InvestigatorFullName,
			Valid:  study.ProtocolSection.SponsorCollaboratorsModule.ResponsibleParty.InvestigatorFullName != "",
		},
		InvestigatorTitle: sql.NullString{
			String: study.ProtocolSection.SponsorCollaboratorsModule.ResponsibleParty.InvestigatorTitle,
			Valid:  study.ProtocolSection.SponsorCollaboratorsModule.ResponsibleParty.InvestigatorTitle != "",
		},
		InvestigatorAffiliation: sql.NullString{
			String: study.ProtocolSection.SponsorCollaboratorsModule.ResponsibleParty.InvestigatorAffiliation,
			Valid:  study.ProtocolSection.SponsorCollaboratorsModule.ResponsibleParty.InvestigatorAffiliation != "",
		},
		CreatedAt: now,
		UpdatedAt: now,
	})
	if err != nil {
		return fmt.Errorf("Error creating responsible party: %w", err)
	}
	statusVerifiedDate, statusVerifiedDatePrecision, statusVerifiedDateValid := normalizeDate(
		study.ProtocolSection.StatusModule.StatusVerifiedDate,
	)
	_, err = state.DB.CreateRowSilverStudyStatus(ctx, database.CreateRowSilverStudyStatusParams{
		StudyID: SilverStudyRow.ID,
		OverallStatus: sql.NullString{
			String: study.ProtocolSection.StatusModule.OverAllStatus,
			Valid:  study.ProtocolSection.StatusModule.OverAllStatus != "",
		},
		WhyStopped: sql.NullString{
			String: study.ProtocolSection.StatusModule.WhyStopped,
			Valid:  study.ProtocolSection.StatusModule.WhyStopped != "",
		},
		StatusVerifiedDate: sql.NullTime{
			Time:  statusVerifiedDate,
			Valid: statusVerifiedDateValid,
		},
		StatusVerifiedDatePrecision: sql.NullString{
			String: statusVerifiedDatePrecision,
			Valid:  statusVerifiedDatePrecision != "",
		},
		CreatedAt: now,
		UpdatedAt: now,
	})
	return nil
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
		return t, "year", true

	default:
		return time.Time{}, "", false
	}
}

func (state *State) Run(ctx context.Context, results map[string][]api.ApiResponseClinicalTrials) error {
	for condition, responses := range results {
		fmt.Printf("PosgreSQL: Bronze and Silver Layers and Gold Views for %s: processing\n", condition)
		for _, response := range responses {
			for _, study := range response.Studies {
				err := state.InsertBronze(ctx, study, condition)
				if err != nil {
					return err
				}
				err = state.InsertSilver(ctx, study, condition)
				if err != nil {
					return err
				}
			}
		}
		fmt.Printf("PostgreSQL: Bronze and Silver Layers and Gold Views for %s: done\n", condition)
	}
	return nil
}
