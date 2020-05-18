#!/bin/bash
BIN="./bin"

if [ -d "$BIN" ]; then
  rm -rf $BIN/* || true
else
  mkdir -p $BIN
fi

GOPATH=$(pwd) go build -o $BIN/preprocess src/preprocess/preprocess.go
GOPATH=$(pwd) go build -o $BIN/mapper src/mapper/mapper.go
GOPATH=$(pwd) go build -o $BIN/reducer src/reducer/reducer.go
