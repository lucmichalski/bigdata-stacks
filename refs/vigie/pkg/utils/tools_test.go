package utils

import (
	"testing"
	"time"
)

func TestIsJSONString(t *testing.T) {
	type args struct {
		s string
	}
	tests := []struct {
		name string
		args args
		want bool
	}{
		// OK
		{name: "string with double quote", args: args{s: "\"foo\""}, want: true},
		{name: "quoted number", args: args{s: "\"6\""}, want: true},
		// FAIL
		{name: "number", args: args{s: "3"}, want: false},
		{name: "string without double quote", args: args{s: "foo"}, want: false},
		{name: "array", args: args{s: "[array]"}, want: false},
		{name: "\"array\"", args: args{s: "[\"array\"]"}, want: false},
		{name: "array like with double quote", args: args{s: "\"[\"array\"]\""}, want: false},
		{name: "array like with double quote x2", args: args{s: "\"\"[\"array\"]\"\""}, want: false},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := IsJSONString(tt.args.s); got != tt.want {
				t.Errorf("IsJSONString() = %v, want %v", got, tt.want)
			}
		})
	}
}

func TestIsArray(t *testing.T) {
	type args struct {
		s string
	}
	tests := []struct {
		name string
		args args
		want bool
	}{
		// OK
		{name: "Array one string value", args: args{s: "[\"array\"]"}, want: true},
		{name: "Array multiples string values", args: args{s: "[\"d\",\"o\",\"g\"]"}, want: true},
		{name: "Array one numeric value", args: args{s: "[1]"}, want: true},
		{name: "Array multiples numeric values", args: args{s: "[1,2,3]"}, want: true},
		// FAIL
		{name: "bad array", args: args{s: "[array]"}, want: false},
		{name: "string with double quote", args: args{s: "\"foo\""}, want: false},
		{name: "quoted number", args: args{s: "\"6\""}, want: false},
		{name: "number", args: args{s: "3"}, want: false},
		{name: "string without double quote", args: args{s: "foo"}, want: false},
		{name: "array like with double quote", args: args{s: "\"[\"array\"]\""}, want: false},
		{name: "array like with double quote x2", args: args{s: "\"\"[\"array\"]\"\""}, want: false},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := IsArray(tt.args.s); got != tt.want {
				t.Errorf("IsArray() = %v, want %v", got, tt.want)
			}
		})
	}
}
func TestParseDuration(t *testing.T) {
	var cases = []struct {
		in  string
		out time.Duration
	}{
		{
			in:  "0s",
			out: 0,
		}, {
			in:  "324ms",
			out: 324 * time.Millisecond,
		}, {
			in:  "3s",
			out: 3 * time.Second,
		}, {
			in:  "5m",
			out: 5 * time.Minute,
		}, {
			in:  "1h",
			out: time.Hour,
		}, {
			in:  "4d",
			out: 4 * 24 * time.Hour,
		}, {
			in:  "3w",
			out: 3 * 7 * 24 * time.Hour,
		}, {
			in:  "10y",
			out: 10 * 365 * 24 * time.Hour,
		},
	}

	for _, c := range cases {
		d, err := ParseDuration(c.in)
		if err != nil {
			t.Errorf("Unexpected error on input %q", c.in)
		}
		if d != c.out {
			t.Errorf("Expected %v but got %v", c.out, d)
		}
	}
}
