package assertion

import "testing"

func TestContains(t *testing.T) {
	type args struct {
		actualValue  interface{}
		actualValues []string
		expectValue  interface{}
		expectValues []string
	}

	taStr3 := []string{"c", "a", "t"}

	tests := []struct {
		name string
		args args
		want bool
	}{
		{name: "OK Cat", args: args{actualValue: nil, actualValues: taStr3, expectValue: "a", expectValues: nil}, want: true},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, _ := Contains(tt.args.actualValue, tt.args.actualValues, tt.args.expectValue, tt.args.expectValues)
			if got != tt.want {
				t.Errorf("Contains() got = %v, want %v", got, tt.want)
			}

		})
	}
}

func Test_contains(t *testing.T) {
	type args struct {
		actualValues []string
		expectValue  interface{}
	}
	tests := []struct {
		name  string
		args  args
		want  bool
		want1 string
	}{
		// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, got1 := contains(tt.args.actualValues, tt.args.expectValue)
			if got != tt.want {
				t.Errorf("contains() got = %v, want %v", got, tt.want)
			}
			if got1 != tt.want1 {
				t.Errorf("contains() got1 = %v, want %v", got1, tt.want1)
			}
		})
	}
}
