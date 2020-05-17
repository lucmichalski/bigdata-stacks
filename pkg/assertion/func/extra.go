package assertion

import (
	"fmt"
	"time"
)

func getFloat(num interface{}) (float64, error) {
	switch val := num.(type) {
	case time.Duration:
		return float64(val), nil
	case float64:
		return val, nil
	case float32:
		return float64(val), nil
	case int64:
		return float64(val), nil
	case int32:
		return float64(val), nil
	case int16:
		return float64(val), nil
	case int8:
		return float64(val), nil
	case uint64:
		return float64(val), nil
	case uint32:
		return float64(val), nil
	case uint16:
		return float64(val), nil
	case uint8:
		return float64(val), nil
	case int:
		return float64(val), nil
	case uint:
		return float64(val), nil
	case string:
		dur, err := time.ParseDuration(val)
		if err != nil {
			return -1, fmt.Errorf("cannot convert %q to float64", num)
		}
		return float64(dur), nil

	default:
		return -1, fmt.Errorf("cannot convert %q to float64", num)
	}
}
