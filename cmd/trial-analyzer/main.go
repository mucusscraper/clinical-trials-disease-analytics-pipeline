package main

import (
	"fmt"

	api "github.com/mucusscraper/clinical-trials-disease-analytics-pipeline/internal/api"
	cli "github.com/mucusscraper/clinical-trials-disease-analytics-pipeline/internal/cli"
	database "github.com/mucusscraper/clinical-trials-disease-analytics-pipeline/internal/database"
)

func main() {
	db, err := database.Connect()
	if err != nil {
		panic(err)
	}
	defer db.Close()

	Conditions := cli.CLI()
	Results := api.FetchStudies(Conditions)
	// fmt.Printf("%v\n", Results)
	fmt.Printf("%v\n", len(Results))
	for key := range Results {
		for _, test := range Results[key] {
			// fmt.Printf(" How many studies: %v\n", test.Studies)
			for _, study := range test.Studies {
				fmt.Printf("STUDY: %v\n", study)
			}
		}
		fmt.Printf("Next condition\n")
	}
}
