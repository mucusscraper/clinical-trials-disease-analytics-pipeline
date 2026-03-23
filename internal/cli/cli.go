package cli

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func CLI() string {
	scanner := bufio.NewScanner(os.Stdin)
	for {
		fmt.Printf("> ")
		if scanner.Scan() {
			all_string := scanner.Text()
			return strings.TrimSpace(strings.ToLower(all_string))
		}
	}
}
