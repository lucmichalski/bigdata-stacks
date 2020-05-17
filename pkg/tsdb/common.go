package tsdb

import (
	"encoding/json"
	"fmt"
	"github.com/vincoll/vigie/pkg/teststruct"
)

func msgtojson(vr teststruct.VigieResult) string {

	data, err := json.Marshal(vr)
	if err != nil {
		fmt.Printf("marshal failed: %s", err)
	}

	return string(data)
}
