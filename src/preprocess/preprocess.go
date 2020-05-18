package main

import (
	"bufio"
	"flag"
	"fmt"
	"io/ioutil"
	"log"
	"math/big"
	"os"
	"os/exec"
	"strconv"
	"strings"

	"util"
)

func saveNumOfPageToHDFS(num_of_page int) error {
	// to avoid conflict, instead of using cmd.StdinPipe(),
	// we save the file to local temp file
	ioutil.WriteFile(util.TMP_NUM_OF_PAGE, []byte(strconv.Itoa(num_of_page)), 0644)
	defer os.Remove(util.TMP_NUM_OF_PAGE)

	// delete it otherwise put will fail
	exec.Command("hadoop", "dfs", "-rm", util.HDFS_NUM_OF_PAGE).Run()
	exec.Command("hadoop", "dfs", "-put", util.TMP_NUM_OF_PAGE, util.HDFS_NUM_OF_PAGE).Run()

	log.Println("saved num of pages in HDFS")
	return nil
}

func main() {
	var fileName string
	flag.StringVar(&fileName, "file", "", "file name")
	flag.Parse()

	if len(fileName) < 1 {
		log.Fatal("./preprocess -file=<filename>")
		// Fatal will cause program exit
	}

	inputFile, err := os.Open(fileName)
	if err != nil {
		log.Fatal("open file ", fileName, " failed:", err)
	}
	defer inputFile.Close()

	data := make(map[string][]string)
	pages := make(map[string]int8)
	scanner := bufio.NewScanner(inputFile)

	// read the file line-by-line
	for scanner.Scan() {
		// split the values
		line := strings.Split(scanner.Text(), " ")
		key := line[0]
		val := line[1]

		// append the nodes
		data[key] = append(data[key], val)

		// for courting page number
		pages[key] = 1
		pages[val] = 1
	}

	num_of_page := len(pages)
	init_pagerank := big.NewRat(1, int64(num_of_page))
	log.Println("num of pages:", num_of_page, " initial pagerank:", util.FormatBigDecimal(init_pagerank))

	// save the num of pages to HDFS
	//	err = saveNumOfPageToHDFS(num_of_page)
	//	if err != nil {
	//		log.Fatal("cannot save number of page to HDFS:", err)
	//	}

	// loop the pages and generate the initial pagerank
	for k := range pages {
		v := data[k]
		fmt.Printf("%s\t[%s]\t%s\n", k, strings.Join(v, ","), util.FormatBigDecimal(init_pagerank))
	}
}
