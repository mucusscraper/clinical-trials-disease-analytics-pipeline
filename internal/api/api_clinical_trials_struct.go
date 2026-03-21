package api

type ApiResponseClinicalTrials struct {
	Studies       []Studies `json:"studies"`
	NextPageToken string    `json:"nextPageToken"`
}

type Studies struct {
	ProtocolSection ProtocolSection `json:"protocolSection"`
	HasResults      bool            `json:"hasResults"`
}

type ProtocolSection struct {
	IdentificationModule       IdentificationModule       `json:"identificationModule"`
	StatusModule               StatusModule               `json:"statusModule"`
	SponsorCollaboratorsModule SponsorCollaboratorsModule `json:"sponsorCollaboratorsModule"`
	DescriptionModule          DescriptionModule          `json:"descriptionModule"`
	DesignModule               DesignModule               `json:"designModule"`
	ArmsInterventionsModule    ArmsInterventionsModule    `json:"armsInterventionsModule"`
	OutcomesModule             OutcomesModule             `json:"outcomesModule"`
	EligibilityModule          EligibilityModule          `json:"eligibilityModule"`
	ContactsLocationsModule    ContactsLocationsModule    `json:"contactsLocationsModule"`
	ReferencesModule           ReferencesModule           `json:"referencesModule"`
}

type IdentificationModule struct {
	NctId         string `json:"nctId"`
	OfficialTitle string `json:"officialTitle"`
}

type StatusModule struct {
	StatusVerifiedDate          string                      `json:"statusVerifiedDate"`
	OverAllStatus               string                      `json:"overallStatus"`
	WhyStopped                  string                      `json:"whyStopped"`
	StartDateStruct             StartDateStruct             `json:"startDateStruct"`
	PrimaryCompletionDateStruct PrimaryCompletionDateStruct `json:"primaryCompletionDateStruct"`
	CompletionDateStruct        CompletionDateStruct        `json:"completionDateStruct"`
	StudyFirstSubmitDate        string                      `json:"studyFirstSubmitDate"`
	StudyFirstPostDateStruct    StudyFirstPostDateStruct    `json:"studyFirstPostDateStruct"`
	LastUpdateSubmitDate        string                      `json:"lastUpdateSubmitDate"`
	LastUpdatePostDateStruct    LastUpdatePostDateStruct    `json:"lastUpdatePostDateStruct"`
}

type StartDateStruct struct {
	Date string `json:"date"`
}

type PrimaryCompletionDateStruct struct {
	Date string `json:"date"`
}

type CompletionDateStruct struct {
	Date string `json:"date"`
}

type StudyFirstPostDateStruct struct {
	Date string `json:"date"`
}

type LastUpdatePostDateStruct struct {
	Date string `json:"date"`
}

type SponsorCollaboratorsModule struct {
	ResponsibleParty ResponsibleParty `json:"responsibleParty"`
	LeadSponsor      LeadSponsor      `json:"leadSponsor"`
	Collaborators    []Collaborators  `json:"collaborators"`
}

type ResponsibleParty struct {
	Type                    string `json:"type"`
	InvestigatorFullName    string `json:"investigatorFullName"`
	InvestigatorTitle       string `json:"investigatorTitle"`
	InvestigatorAffiliation string `json:"investigatorAffiliation"`
}

type LeadSponsor struct {
	Name  string `json:"name"`
	Class string `json:"class"`
}

type Collaborators struct {
	Name  string `json:"name"`
	Class string `json:"class"`
}

type DescriptionModule struct {
	BriefSummary string `json:"briefSummary"`
}

type DesignModule struct {
	StudyType      string         `json:"studyType"`
	Phases         []string       `json:"phases"`
	DesignInfo     DesignInfo     `json:"designInfo"`
	EnrollmentInfo EnrollmentInfo `json:"enrollmentInfo"`
}

type DesignInfo struct {
	Allocation        string      `json:"allocation"`
	InterventionModel string      `json:"interventionModel"`
	PrimaryPurpose    string      `json:"primaryPurpose"`
	MaskingInfo       MaskingInfo `json:"maskingInfo"`
}

type MaskingInfo struct {
	Masking string `json:"masking"`
}

type EnrollmentInfo struct {
	Count int `json:"count"`
}

type ArmsInterventionsModule struct {
	Interventions []Intervention `json:"interventions"`
}

type Intervention struct {
	Type           string   `json:"type"`
	Name           string   `json:"name"`
	Description    string   `json:"description"`
	ArmGroupLables []string `json:"armGroupLabels"`
}

type OutcomesModule struct {
	PrimaryOutcomes   []PrimaryOutcome   `json:"primaryOutcomes"`
	SecondaryOutcomes []SecondaryOutcome `json:"secondaryOutcomes"`
}

type PrimaryOutcome struct {
	Measure   string `json:"measure"`
	TimeFrame string `json:"timeFrame"`
}

type SecondaryOutcome struct {
	Measure   string `json:"measure"`
	TimeFrame string `json:"timeFrame"`
}

type EligibilityModule struct {
	Sex     string   `json:"sex"`
	StdAges []string `json:"stdAges"`
}

type ContactsLocationsModule struct {
	Locations []Location `json:"locations"`
}

type Location struct {
	City     string   `json:"city"`
	State    string   `json:"state"`
	Country  string   `json:"country"`
	GeoPoint GeoPoint `json:"geoPoint"`
}

type GeoPoint struct {
	Latitude  float64 `json:"lat"`
	Longitude float64 `json:"lon"`
}

type ReferencesModule struct {
	References []Reference `json:"references"`
}

type Reference struct {
	Pmid     string `json:"pmid"`
	Type     string `json:"type"`
	Citation string `json:"citation"`
}
