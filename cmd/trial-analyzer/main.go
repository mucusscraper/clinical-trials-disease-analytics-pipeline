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
		} else if Mode == "help" {
			fmt.Println("\n########### HELP - Clinical Trials Analyzer ###########\n")
			fmt.Print("Available commands:\n")
			fmt.Println("fetch")
			fmt.Println("  -> Fetch clinical trials data from the API and store it in the database.")
			fmt.Println("  -> You will be prompted to enter a condition (e.g., 'Trachoma').")
			fmt.Println("  -> Type 'done' when finished selecting conditions.\n")

			fmt.Println("list")
			fmt.Println("  -> List all conditions that have already been fetched and stored.\n")

			fmt.Println("report")
			fmt.Println("  -> Generate an interactive HTML report based on selected conditions.")
			fmt.Println("  -> You can input up to 2 conditions.")
			fmt.Println("  -> Type 'done' when finished selecting conditions.\n")

			fmt.Println("help")
			fmt.Println("  -> Display this help message.\n")

			fmt.Println("quit")
			fmt.Println("  -> Exit the application.\n")

			fmt.Println("#######################################################\n")
		} else {
			fmt.Println("Command not found")
		}
	}
}
