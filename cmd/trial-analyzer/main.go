package main

import (
	"fmt"

	api "github.com/mucusscraper/clinical-trials-disease-analytics-pipeline/internal/api"
	cli "github.com/mucusscraper/clinical-trials-disease-analytics-pipeline/internal/cli"
)

func main() {
	Conditions := cli.CLI()
	Results := api.FetchStudies(Conditions)
	// fmt.Printf("%v\n", Results)
	fmt.Printf("%v\n", len(Results))
	for key := range Results {
		for _, test := range Results[key] {
			fmt.Printf(" How many studies: %v\n", len(test.Studies))
		}
		fmt.Printf("Next condition\n")
	}
}
