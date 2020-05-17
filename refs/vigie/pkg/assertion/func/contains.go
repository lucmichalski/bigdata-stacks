package assertion

import "fmt"

func Contains(actualValue interface{}, actualValues []string, expectValue interface{}, expectValues []string) (bool, string) {

	if actualValues != nil {
		return contains(actualValues, expectValue)
	} else {
		return false, fmt.Sprintf(shouldHaveContained, expectValues, actualValues)
	}
}

// Contains tells whether a contains x.
func contains(actualValues []string, expectValue interface{}) (bool, string) {

	str := fmt.Sprintf("%v", expectValue)

	for _, n := range actualValues {
		if str == n {
			return true, success
		}
	}
	return false, fmt.Sprintf(shouldHaveContained, expectValue, actualValues)
}
