package api

import (
	"encoding/json"
	"fmt"
	"net/http"
	"net/url"
)

const BaseURL = "https://clinicaltrials.gov/api/v2/studies"

func FetchStudies(Conditions []string) map[string][]ApiResponseClinicalTrials {
	ClinicalTrialsMap := make(map[string][]ApiResponseClinicalTrials)
	for _, Condition := range Conditions {
		u, err := url.Parse(BaseURL)
		if err != nil {
			fmt.Printf("Not possible to parse the base URL")
			fmt.Printf("%v\n", err)
			return nil
		}
		params := url.Values{}
		params.Add("query.cond", Condition)
		params.Add("fields", "NCTId,OverallStatus,StartDate,StdAge,LocationCountry,LocationCity,BriefSummary,ResultsSection,Intervention,OutcomeMeasuresModule,OtherOutcome,SponsorCollaboratorsModule,Sex,StdAge,Phase,EnrollmentCount,Collaborator,DesignModule,OfficialTitle,StartDate,PrimaryCompletionDateStruct,CompletionDateStruct,StudyFirstPostDateStruct,ResultsFirstPostDateStruct,LastUpdatePostDateStruct,DocumentSection,ReferencesModule,StatusModule,LocationState,HasResults,InterventionType,InterventionName,PrimaryOutcome,SecondaryOutcome,OtherOutcome,Collaborator,ResultsFirstPostDate,LocationGeoPoint")
		u.RawQuery = params.Encode()
		res, err := http.Get(u.String())
		if err != nil {
			fmt.Printf("Not possible to use http GET\n")
			fmt.Printf("%v\n", err)
		}
		defer res.Body.Close()
		var ClinicalTrialsList []ApiResponseClinicalTrials
		var ClinicalTrials ApiResponseClinicalTrials
		decoder := json.NewDecoder(res.Body)
		err = decoder.Decode(&ClinicalTrials)
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
			defer res.Body.Close()
			var ClinicalTrials ApiResponseClinicalTrials
			decoder := json.NewDecoder(res.Body)
			err = decoder.Decode(&ClinicalTrials)
			if err != nil {
				fmt.Printf("Not possible to decode JSON\n")
				fmt.Printf("%v\n", err)
				return nil
			}
			ClinicalTrialsList = append(ClinicalTrialsList, ClinicalTrials)
			if ClinicalTrials.NextPageToken == "" {
				break
			}
			NextPageToken = ClinicalTrials.NextPageToken
		}
		ClinicalTrialsMap[Condition] = ClinicalTrialsList
	}
	return ClinicalTrialsMap
}
