package assertion

import (
	"fmt"
	"time"
)

func GreaterThan(actualValue interface{}, actualValues []string, expectValue interface{}, expectValues []string) (bool, string) {

	_, isTime := expectValue.(time.Duration)

	if expectValue != nil {

		numActualVal, err := getFloat(actualValue)
		if err != nil {
			return false, err.Error()
		}
		numExpectValue, err2 := getFloat(expectValue)
		if err2 != nil {
			return false, err2.Error()
		}
		return superior(numActualVal, numExpectValue, isTime)
	} else {
		return false, fmt.Sprintf(shouldHaveBeenGreater, actualValue, expectValues)
	}

}

// Contains tells whether a contains x.
func superior(actual float64, expected float64, isTime bool) (bool, string) {

	if actual > expected {

		if isTime {
			return true, success
		} else {
			return true, success
		}

	} else {

		if isTime {
			return false, fmt.Sprintf(shouldHaveBeenGreater, time.Duration(actual), time.Duration(expected))
		} else {
			return false, fmt.Sprintf(shouldHaveBeenGreater, actual, expected)
		}
	}

}

func GreaterThanOrEq(actualValue interface{}, actualValues []string, expectValue interface{}, expectValues []string) (bool, string) {

	_, isTime := expectValue.(time.Duration)

	if expectValue != nil {

		numActualVal, err := getFloat(actualValue)
		if err != nil {
			return false, err.Error()
		}
		numExpectValue, err2 := getFloat(expectValue)
		if err2 != nil {
			return false, err2.Error()
		}
		return superiorEq(numActualVal, numExpectValue, isTime)
	} else {
		return false, fmt.Sprintf(shouldHaveBeenGreaterOrEqual, actualValue, expectValues)
	}

}

func superiorEq(actual float64, expected float64, isTime bool) (bool, string) {

	if actual >= expected {
		return true, success
	}
	return false, fmt.Sprintf(shouldHaveBeenGreaterOrEqual, actual, expected)
}

func LessThanOrEq(actualValue interface{}, actualValues []string, expectValue interface{}, expectValues []string) (bool, string) {

	_, isTime := expectValue.(time.Duration)

	if expectValue != nil {

		numActualVal, err := getFloat(actualValue)
		if err != nil {
			return false, err.Error()
		}
		numExpectValue, err2 := getFloat(expectValue)
		if err2 != nil {
			return false, err2.Error()
		}
		return inferioreq(numActualVal, numExpectValue, isTime)
	} else {
		return false, fmt.Sprintf(shouldHaveBeenLessOrEqual, actualValue, expectValues)
	}

}

func inferioreq(actual float64, expected float64, isTime bool) (bool, string) {

	if actual < expected {
		return true, success

	} else {

		if isTime {
			return false, fmt.Sprintf(shouldHaveBeenLessOrEqual, time.Duration(actual), time.Duration(expected))
		} else {
			return false, fmt.Sprintf(shouldHaveBeenLessOrEqual, actual, expected)
		}
	}

}

func LessThan(actualValue interface{}, actualValues []string, expectValue interface{}, expectValues []string) (bool, string) {

	_, isTime := expectValue.(time.Duration)

	if expectValue != nil {

		numActualVal, err := getFloat(actualValue)
		if err != nil {
			return false, err.Error()
		}

		numExpectValue, err2 := getFloat(expectValue)
		if err2 != nil {
			return false, err2.Error()
		}
		return inferior(numActualVal, numExpectValue, isTime)
	} else {
		return false, fmt.Sprintf(shouldHaveBeenLess, actualValue, expectValue)
	}

}

func inferior(actual float64, expected float64, isTime bool) (bool, string) {

	if actual < expected {
		return true, success

	} else {

		if isTime {
			return false, fmt.Sprintf(shouldHaveBeenLess, time.Duration(actual), time.Duration(expected))
		} else {
			return false, fmt.Sprintf(shouldHaveBeenLess, actual, expected)
		}
	}

}
