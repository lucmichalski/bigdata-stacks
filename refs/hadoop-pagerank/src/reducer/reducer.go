package main

import (
	"bytes"
	"fmt"
	"io/ioutil"
	"log"
	"math/big"
	"net/http"
	"os"
	"strings"

	"util"
)

const DAMPING_FACTOR = "0.85"

var curKey, curNode string
var curRank *big.Rat

func readNumOfPageToHDFS() string {
	// to avoid conflict, instead of using cmd.StdoutPipe(),
	// TODO: the namenode address should be read from core-site.xml in $HADOOP_PREFIX/conf/

	resp, err := http.Get("http://namenode:50070/webhdfs/v1/num_of_page?op=OPEN")
	defer resp.Body.Close()

	if err != nil {
		return "-1"
	}

	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return "-1"
	}

	return string(body)
}

func splitKeyValue(line string) (string, string) {
	// each line, split by tab
	vars := strings.Split(line, "\t")
	return vars[0], vars[1]
}

func main() {
	// return 0.15 and 0.85
	df_a, df_b := util.DampingFactor(DAMPING_FACTOR)

	// get num of page
	num_of_page_str := readNumOfPageToHDFS()
	log.Println("number of page:", num_of_page_str)
	if len(num_of_page_str) < 1 {
		log.Fatal("cannot read num of page from HDFS")
	}

	num_of_page := util.ParseBigDecimal(num_of_page_str)

	// start to prcess stdin
	buf, _ := ioutil.ReadAll(os.Stdin)
	for _, line := range bytes.Split(buf, []byte("\n")) {
		if line == nil || len(line) < 1 {
			continue
		}

		key, value := splitKeyValue(string(line))

		if key == curKey {
			if value[0] == '[' {
				curNode = value[1 : len(value)-1]
			} else {
				curRank.Add(curRank, util.ParseBigDecimal(value))
			}
		} else {
			// key changed, i.e., next item, then emit
			if len(curKey) > 0 {
				pagerank := util.CalcPagerank(df_a, df_b, num_of_page, curRank)
				fmt.Printf("%s\t[%s]\t%s\n", curKey, curNode, util.FormatBigDecimal(pagerank))
			}
			curKey = key
			curRank = util.ParseBigDecimal(value)
			curNode = value[1 : len(value)-1]
		}
	}

	// emit the last
	if len(curKey) > 0 {
		pagerank := util.CalcPagerank(df_a, df_b, num_of_page, curRank)
		fmt.Printf("%s\t[%s]\t%s\n", curKey, curNode, util.FormatBigDecimal(pagerank))
	}
}
