package probe

import (
	"encoding/json"
	"fmt"
)

func ToMap(proberes interface{}) (map[string]interface{}, error) {

	var probeFinalRes map[string]interface{}
	inrec, errMarsh := json.Marshal(proberes)
	if errMarsh != nil {
		return nil, fmt.Errorf("Error while ProbeRes convertion to map: %s", errMarsh)
	}
	errUnmarsh := json.Unmarshal(inrec, &probeFinalRes)
	if errUnmarsh != nil {
		return nil, fmt.Errorf("Error while ProbeRes convertion to map: %s", errUnmarsh)
	}

	return probeFinalRes, nil

}

// https://blog.gopheracademy.com/advent-2016/advanced-encoding-decoding/
//http://choly.ca/post/go-json-marshalling/
// https://stackoverflow.com/questions/48050945/how-to-unmarshal-json-into-durations
