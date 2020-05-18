package main

import (
	"bytes"
	"fmt"
	"io/ioutil"
	"math/big"
	"os"
	"strings"

	"util"
)

func splitValues(line string) (string, []string, *big.Rat) {
	// each line, split by tab
	vars := strings.Split(line, "\t")

	// get destination nodes and the page rank of the source node
	src_node := vars[0]

	dest_node_str := vars[1][1 : len(vars[1])-1] // remove []
	dest_nodes := strings.Split(dest_node_str, ",")
	num_of_node := len(dest_nodes)

	src_pagerank := util.ParseBigDecimal(vars[2])

	dest_pagerank := new(big.Rat)
	dest_pagerank.Quo(src_pagerank, big.NewRat(int64(num_of_node), 1))

	return src_node, dest_nodes, dest_pagerank
}

func main() {
	buf, _ := ioutil.ReadAll(os.Stdin)

	// for handling dangling node
	dangling_node_pr := new(big.Rat)
	emitted_node := make([]string, 0)

	for _, line := range bytes.Split(buf, []byte("\n")) {
		if line == nil || len(line) < 1 {
			continue
		}

		// split values and calcuate the dest pagerank
		src_node, dest_nodes, dest_pagerank := splitValues(string(line))

		// the pagerank for the dest nodes
		for _, node := range dest_nodes {
			if len(node) < 1 {
				// no subnodes, meaning that this is a dangling node
				// add its pagerank to the dangling_node_pr
				dangling_node_pr.Add(dangling_node_pr, dest_pagerank)
				continue
			}

			// emit the pagerank
			fmt.Printf("%s\t%s\n", node, util.FormatBigDecimal(dest_pagerank))

			emitted_node = append(emitted_node, node)
		}

		// emit the list
		fmt.Printf("%s\t[%s]\n", src_node, strings.Join(dest_nodes, ","))
	}

	// emit pagerank score for dangling_node
	num_of_em_node := len(emitted_node)

	// if there are nodes emitted before
	if num_of_em_node > 0 {
		// divide the total dangling node PageRank by number of emitted nodes
		num_of_em_node_r := big.NewRat(int64(num_of_em_node), 1)
		pr_for_each_em_node := dangling_node_pr.Quo(dangling_node_pr, num_of_em_node_r)

		// emit the additional pagerank for each emitted node
		for _, node := range emitted_node {
			fmt.Printf("%s\t%s\n", node, util.FormatBigDecimal(pr_for_each_em_node))
		}
	}
}
