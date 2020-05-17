package assertion

import "testing"

func TestEqual(t *testing.T) {
	type args struct {
		actualValue  interface{}
		actualValues []string
		expectValue  interface{}
		expectValues []string
	}

	// TestsArrays
	/*
		taStrC3 := []interface{}{"c", "a", "t"}
		taStrD3 := []interface{}{"d", "o", "g"}

		taIntD3 := []interface{}{"1", "2", "3"}

		taEmpty := []interface{}{}
	*/

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
			got, got1 := Equal(tt.args.actualValue, tt.args.actualValues, tt.args.expectValue, tt.args.expectValues)
			if got != tt.want {
				t.Errorf("Equal() got = %v, want %v", got, tt.want)
			}
			if got1 != tt.want1 {
				t.Errorf("Equal() got1 = %v, want %v", got1, tt.want1)
			}
		})
	}
}
