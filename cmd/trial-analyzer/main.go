package main

import (
	"context"
	"fmt"

	api "github.com/mucusscraper/clinical-trials-disease-analytics-pipeline/internal/api"
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
	Conditions := cli.CLI()
	Results := api.FetchStudies(Conditions)
	err = state.Run(ctx, Results)
	if err != nil {
		panic(err)
	}
	fmt.Println("Executed pipeline")
}
