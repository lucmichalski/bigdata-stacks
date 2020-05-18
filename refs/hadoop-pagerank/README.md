# Hadoop PageRank with Go
[![Build Status](https://travis-ci.org/carlostse/hadoop-pagerank.svg?branch=master)](https://travis-ci.org/carlostse/hadoop-pagerank)

An implementation of using Hadoop with Google Go (golang) to calculate the PageRank for demo purpose

## Sample Source File
There are two sample input files provided
 * sample_with_dead_node.tsv
 * sample_without_dead_node.tsv

## Requirements
 * Hadoop (tested 1.2.1 and 2.5.1)
 * Google Go (tested 1.3)

## Quick Start
For Hadoop 1.2.1
```
./build.sh
bin/preprocess -file sample_without_dead_node.tsv > input_data
hadoop dfs -mkdir /input
hadoop dfs -put input_data /input
./submit-1.sh
```

