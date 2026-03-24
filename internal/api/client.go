package api

import (
	"encoding/json"
	"fmt"
	"net/http"
	"net/url"

	"github.com/schollz/progressbar/v3"
)

const BaseURL = "https://clinicaltrials.gov/api/v2/studies"

func FetchStudies(Conditions []string) map[string][]ApiResponseClinicalTrials {
	ClinicalTrialsMap := make(map[string][]ApiResponseClinicalTrials)
	bar := progressbar.Default(-1, "Fetching Pages")
	for i, Condition := range Conditions {
		u, err := url.Parse(BaseURL)
		if err != nil {
			fmt.Printf("Not possible to parse the base URL")
			fmt.Printf("%v\n", err)
			return nil
		}
		fmt.Printf("\n[%d-%d] Fetching condition: %v\n", i+1, len(Conditions), Condition)
		params := url.Values{}
		params.Add("query.cond", Condition)
		params.Add("fields", "NCTId,OverallStatus,StartDate,StdAge,LocationCountry,LocationCity,BriefSummary,ResultsSection,Intervention,OutcomeMeasuresModule,OtherOutcome,SponsorCollaboratorsModule,Sex,StdAge,Phase,EnrollmentCount,Collaborator,DesignModule,OfficialTitle,StartDate,PrimaryCompletionDateStruct,CompletionDateStruct,StudyFirstPostDateStruct,ResultsFirstPostDateStruct,LastUpdatePostDateStruct,DocumentSection,ReferencesModule,StatusModule,LocationState,HasResults,InterventionType,InterventionName,PrimaryOutcome,SecondaryOutcome,OtherOutcome,Collaborator,ResultsFirstPostDate,LocationGeoPoint")
		u.RawQuery = params.Encode()
		res, err := http.Get(u.String())
		if err != nil {
			fmt.Printf("Not possible to use http GET\n")
			fmt.Printf("%v\n", err)
		}
		bar.Add(1)
		var ClinicalTrialsList []ApiResponseClinicalTrials
		var ClinicalTrials ApiResponseClinicalTrials
		decoder := json.NewDecoder(res.Body)
		err = decoder.Decode(&ClinicalTrials)
		res.Body.Close()
		if err != nil {
			fmt.Printf("Not possible to decode JSON\n")
			fmt.Printf("%v\n", err)
			return nil
		}
		ClinicalTrialsList = append(ClinicalTrialsList, ClinicalTrials)
		NextPageToken := ClinicalTrials.NextPageToken
		for {
			params := url.Values{}
			params.Add("query.cond", Condition)
			params.Add("fields", "NCTId,OverallStatus,StartDate,StdAge,LocationCountry,LocationCity,BriefSummary,ResultsSection,Intervention,OutcomeMeasuresModule,OtherOutcome,SponsorCollaboratorsModule,Sex,StdAge,Phase,EnrollmentCount,Collaborator,DesignModule,OfficialTitle,StartDate,PrimaryCompletionDateStruct,CompletionDateStruct,StudyFirstPostDateStruct,ResultsFirstPostDateStruct,LastUpdatePostDateStruct,DocumentSection,ReferencesModule,StatusModule,LocationState,HasResults,InterventionType,InterventionName,PrimaryOutcome,SecondaryOutcome,OtherOutcome,Collaborator,ResultsFirstPostDate,LocationGeoPoint")
			params.Add("pageToken", NextPageToken)
			u.RawQuery = params.Encode()
			res, err := http.Get(u.String())
			if err != nil {
				fmt.Printf("Not possible to use http GET\n")
				fmt.Printf("%v\n", err)
			}
			var ClinicalTrials ApiResponseClinicalTrials
			decoder := json.NewDecoder(res.Body)
			err = decoder.Decode(&ClinicalTrials)
			res.Body.Close()
			if err != nil {
				fmt.Printf("Not possible to decode JSON\n")
				fmt.Printf("%v\n", err)
				return nil
			}
			bar.Add(1)
			ClinicalTrialsList = append(ClinicalTrialsList, ClinicalTrials)
			if ClinicalTrials.NextPageToken == "" {
				break
			}
			NextPageToken = ClinicalTrials.NextPageToken
		}
		ClinicalTrialsMap[Condition] = ClinicalTrialsList
	}
	bar.Finish()
	return ClinicalTrialsMap
}
