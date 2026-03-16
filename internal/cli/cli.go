package cli

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func CLI() []string {
	fmt.Printf("Clinical Trials Analyzer\n\n")
	fmt.Printf("Type the desired conditions to analyse\n")
	scanner := bufio.NewScanner(os.Stdin)
	var Conditions []string
	for {
		fmt.Printf("> ")
		if scanner.Scan() {
			all_string := scanner.Text()
			if strings.TrimSpace(strings.ToLower(all_string)) == "done" {
				return Conditions
			}
			strings.TrimSpace(strings.ToLower(all_string))
			Conditions = append(Conditions, all_string)
		}
	}
}
