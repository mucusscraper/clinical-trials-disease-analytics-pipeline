package cli

import (
	"reflect"
	"strings"
	"testing"
)

func TestCLI(t *testing.T) {
	tests := []struct {
		name  string
		input string
		want  string
	}{
		{"basic case", "Hello World", "hello world"},
		{"trimming one side case", "\n     HELLO World", "hello world"},
		{"trimming both sides case", "\n HELLO WORLd \n", "hello world"},
	}
	for _, tc := range tests {
		got := CLI(strings.NewReader(tc.input))
		if !reflect.DeepEqual(got, tc.want) {
			t.Fatalf("%s - expected: %s, got: %s", tc.name, tc.want, got)
		}
	}
}
