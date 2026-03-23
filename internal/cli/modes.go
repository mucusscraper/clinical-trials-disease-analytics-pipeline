package cli

import (
	"bufio"
	"context"
	"fmt"
	"os"
	"os/exec"
	"strings"

	"github.com/mucusscraper/clinical-trials-disease-analytics-pipeline/internal/api"
	"github.com/mucusscraper/clinical-trials-disease-analytics-pipeline/internal/etl"
	"golang.org/x/text/cases"
	"golang.org/x/text/language"
)

func RunFetchMode(ctx context.Context, state *etl.State) {
	fmt.Println("Entering FETCH mode -> type 'done' to leave)")
	var Conditions []string
	scanner := bufio.NewScanner(os.Stdin)
	for {
		fmt.Print("fetch> ")
		if scanner.Scan() {
			all_string := scanner.Text()
			caser := cases.Title(language.English)
			clean_string := caser.String((strings.TrimSpace(strings.ToLower(all_string))))
			if clean_string == "Done" {
				Results := api.FetchStudies(Conditions)
				err := state.Run(ctx, Results)
				if err != nil {
					fmt.Printf("Error: %v\n", err)
					panic(err)
				}
				break
			}
			Conditions = append(Conditions, clean_string)
		}
	}
}

func RunListMode(ctx context.Context, state *etl.State) {
	fmt.Println("List of conditions already fetched:")
	Conditions, err := state.DB.GetFetchedConditions(ctx)
	if err != nil {
		panic(err)
	}
	for _, Condition := range Conditions {
		fmt.Printf("%v\n", Condition)
	}
}

func RunReportMode(ctx context.Context, state *etl.State) {
	fmt.Println("Entering REPORT mode -> type 'done' to leave -> (MAX OF 2 CONDITIONS FOR REPORT)")
	var Conditions []string
	scanner := bufio.NewScanner(os.Stdin)
	for {
		fmt.Print("report> ")
		if scanner.Scan() {
			all_string := scanner.Text()
			caser := cases.Title(language.English)
			clean_string := caser.String((strings.TrimSpace(strings.ToLower(all_string))))
			if strings.ToLower(all_string) == "done" {
				if len(Conditions) == 0 {
					fmt.Println("No conditions provided")
					continue
				}
				if len(Conditions) > 2 {
					fmt.Println("You can only add up to 2 conditions")
				} else {
					cmd := exec.Command("python3", "reports/scripts/generate_reports.py", "--conditions", strings.Join(Conditions, "|||"))
					output, err := cmd.CombinedOutput()
					fmt.Println(string(output))
					if err != nil {
						fmt.Printf("Error: %v\n", err)
						break
					}
					fmt.Println("New report created")
					break
				}
			} else {
				Conditions = append(Conditions, clean_string)
			}
		}
	}
}
