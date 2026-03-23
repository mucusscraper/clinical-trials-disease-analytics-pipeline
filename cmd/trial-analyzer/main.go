package main

import (
	"context"
	"fmt"

	cli "github.com/mucusscraper/clinical-trials-disease-analytics-pipeline/internal/cli"
	database "github.com/mucusscraper/clinical-trials-disease-analytics-pipeline/internal/database"
	etl "github.com/mucusscraper/clinical-trials-disease-analytics-pipeline/internal/etl"
)

func main() {
	ctx := context.Background()
	db, err := database.Connect()
	if err != nil {
		panic(err)
	}
	defer db.Close()
	queries := database.New(db)
	state := &etl.State{
		DB: queries,
	}
	fmt.Printf("########### Clinical Trials Analyzer ###########\n")
	fmt.Printf("Commands: 'fetch' , 'report' , 'list' , 'quit' , 'help'\n")
	for {
		Mode := cli.CLI()
		if Mode == "fetch" {
			cli.RunFetchMode(ctx, state)
			continue
		} else if Mode == "list" {
			ConditionsSaved, err := state.DB.GetFetchedConditions(ctx)
			if err != nil {
				panic(err)
			}
			for _, ConditionSaved := range ConditionsSaved {
				fmt.Printf("%v\n", ConditionSaved)
			}
		} else if Mode == "report" {
			cli.RunReportMode(ctx, state)
			continue
		} else if Mode == "quit" {
			fmt.Println("Exiting...")
			break
		}
	}
}
