package cli

import (
	"bufio"
	"fmt"
	"io"
	"strings"
)

func CLI(input io.Reader) string {
	scanner := bufio.NewScanner(input)
	for {
		fmt.Printf("> ")
		if scanner.Scan() {
			all_string := scanner.Text()
			if all_string == "" {
				continue
			}
			return strings.ToLower(strings.TrimSpace(all_string))
		}
	}
}
