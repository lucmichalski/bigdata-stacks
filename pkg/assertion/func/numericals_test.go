package assertion

import "testing"

func TestInferior(t *testing.T) {
	type args struct {
		actualValue  interface{}
		actualValues []string
		expectValue  interface{}
		expectValues []string
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
			got, got1 := LessThan(tt.args.actualValue, tt.args.actualValues, tt.args.expectValue, tt.args.expectValues)
			if got != tt.want {
				t.Errorf("LessThan() got = %v, want %v", got, tt.want)
			}
			if got1 != tt.want1 {
				t.Errorf("LessThan() got1 = %v, want %v", got1, tt.want1)
			}
		})
	}
}

func TestInferiorEq(t *testing.T) {
	type args struct {
		actualValue  interface{}
		actualValues []string
		expectValue  interface{}
		expectValues []string
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
			got, got1 := LessThanOrEq(tt.args.actualValue, tt.args.actualValues, tt.args.expectValue, tt.args.expectValues)
			if got != tt.want {
				t.Errorf("LessThanOrEq() got = %v, want %v", got, tt.want)
			}
			if got1 != tt.want1 {
				t.Errorf("LessThanOrEq() got1 = %v, want %v", got1, tt.want1)
			}
		})
	}
}

func TestSuperior(t *testing.T) {
	type args struct {
		actualValue  interface{}
		actualValues []string
		expectValue  interface{}
		expectValues []string
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
			got, got1 := GreaterThan(tt.args.actualValue, tt.args.actualValues, tt.args.expectValue, tt.args.expectValues)
			if got != tt.want {
				t.Errorf("GreaterThan() got = %v, want %v", got, tt.want)
			}
			if got1 != tt.want1 {
				t.Errorf("GreaterThan() got1 = %v, want %v", got1, tt.want1)
			}
		})
	}
}

func TestSuperiorEq(t *testing.T) {
	type args struct {
		actualValue  interface{}
		actualValues []string
		expectValue  interface{}
		expectValues []string
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
			got, got1 := GreaterThanOrEq(tt.args.actualValue, tt.args.actualValues, tt.args.expectValue, tt.args.expectValues)
			if got != tt.want {
				t.Errorf("GreaterThanOrEq() got = %v, want %v", got, tt.want)
			}
			if got1 != tt.want1 {
				t.Errorf("GreaterThanOrEq() got1 = %v, want %v", got1, tt.want1)
			}
		})
	}
}

func Test_inferior(t *testing.T) {
	type args struct {
		actual   float64
		expected float64
		isTime   bool
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
			got, got1 := inferior(tt.args.actual, tt.args.expected, tt.args.isTime)
			if got != tt.want {
				t.Errorf("inferior() got = %v, want %v", got, tt.want)
			}
			if got1 != tt.want1 {
				t.Errorf("inferior() got1 = %v, want %v", got1, tt.want1)
			}
		})
	}
}

func Test_inferioreq(t *testing.T) {
	type args struct {
		actual   float64
		expected float64
		isTime   bool
	}
	tests := []struct {
		name  string
		args  args
		want  bool
		want1 string
	}{
		{name: "1 < 1", args: args{actual: 1, expected: 1, isTime: false}, want: false},
		{name: "9 < 1", args: args{actual: 9, expected: 1, isTime: false}, want: false},
		{name: "2 < 8", args: args{actual: 2, expected: 8, isTime: false}, want: true},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, _ := inferioreq(tt.args.actual, tt.args.expected, false)
			if got != tt.want {
				t.Errorf("inferioreq() got = %v, want %v", got, tt.want)
			}

		})
	}
}

func Test_superior(t *testing.T) {
	type args struct {
		actual   float64
		expected float64
		isTime   bool
	}
	tests := []struct {
		name  string
		args  args
		want  bool
		want1 string
	}{
		{name: "1 > 1", args: args{actual: 1, expected: 1, isTime: false}, want: false},
		{name: "9 > 1", args: args{actual: 9, expected: 1, isTime: false}, want: true},
		{name: "2 > 8", args: args{actual: 2, expected: 8, isTime: false}, want: false},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, _ := superior(tt.args.actual, tt.args.expected, tt.args.isTime)
			if got != tt.want {
				t.Errorf("superior() got = %v, want %v", got, tt.want)
			}

		})
	}
}

func Test_superiorEq(t *testing.T) {
	type args struct {
		actual   float64
		expected float64
		isTime   bool
	}
	tests := []struct {
		name  string
		args  args
		want  bool
		want1 string
	}{
		{name: "1 >= 1", args: args{actual: 1, expected: 1}, want: true},
		{name: "2 > 1", args: args{actual: 2, expected: 1}, want: true},
		{name: "2 >= 1", args: args{actual: 2, expected: 1}, want: true},
		{name: "1 > 9", args: args{actual: 1, expected: 9}, want: false},
		{name: "1 >= 9", args: args{actual: 1, expected: 9}, want: false},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, _ := superiorEq(tt.args.actual, tt.args.expected, false)
			if got != tt.want {
				t.Errorf("superiorEq() got = %v, want %v", got, tt.want)
			}
		})
	}
}
