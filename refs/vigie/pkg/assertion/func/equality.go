package assertion

import "fmt"

func NotEqual(actualValue interface{}, actualValues []string, expectValue interface{}, expectValues []string) (bool, string) {

	if actualValue != nil {
		// String
		if expectValue != nil {
			return notEqualVal(actualValue, expectValue)
		} else {
			return false, fmt.Sprintf(shouldNotHaveBeenEqual, actualValue, expectValues)
		}
	} else {
		// Array
		if expectValues != nil {
			return notEqualSlice(actualValues, expectValues)

		} else {
			return false, fmt.Sprintf(shouldNotHaveBeenEqual, actualValues, expectValue)
		}

	}

}

// Contains tells whether a contains x.
func notEqualSlice(actual []string, expected []string) (bool, string) {

	for i := range expected {
		if actual[i] == expected[i] {
			return false, fmt.Sprintf(shouldNotHaveBeenEqual, actual, expected)
		}
	}

	return true, success
}

// Contains tells whether a contains x.
func notEqualVal(actual interface{}, expected interface{}) (bool, string) {

	if actual == expected {
		return false, fmt.Sprintf(shouldNotHaveBeenEqual, actual, expected)
	}

	return true, success
}

func Equal(actualValue interface{}, actualValues []string, expectValue interface{}, expectValues []string) (bool, string) {

	if actualValue != nil {
		// String
		if expectValue != nil {
			return equalVal(actualValue, expectValue)
		} else {
			return false, fmt.Sprintf(shouldHaveBeenEqual, actualValue, expectValues)
		}
	} else {
		// Array
		if expectValues != nil {
			return equalSlice(actualValues, expectValues)

		} else {
			return false, fmt.Sprintf(shouldHaveBeenEqual, actualValues, expectValue)
		}

	}

}

// Contains tells whether a contains x.
func equalSlice(actual []string, expected []string) (bool, string) {

	for i := range expected {
		if actual[i] != expected[i] {
			return false, fmt.Sprintf(shouldHaveBeenEqual, actual, expected)
		}
	}

	return true, success
}

// Contains tells whether a contains x.
func equalVal(actual interface{}, expected interface{}) (bool, string) {

	if actual != expected {
		return false, fmt.Sprintf(shouldHaveBeenEqual, actual, expected)
	}

	return true, success
}
