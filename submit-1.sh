#!/bin/bash
i=0
while true; do
    if [ $i -eq 0 ]; then
        INPUT="/input"
    else
        INPUT="/output_$i"
    fi
    OUTPUT="/output_$(($i+1))"
    echo "[$i] input: $INPUT, output: $OUTPUT"
    hadoop jar /opt/hadoop/contrib/streaming/hadoop-streaming-1.2.1.jar ­D mapred.reduce.tasks=2 -mapper mapper -reducer reducer -file bin/mapper -file bin/reducer -input $INPUT -output $OUTPUT

    # compare the result with the previous run
    # the first output is output_1 and we assume it is different from input,
    # so start do the comparison when i > 0, i.e., compare start with output_1 and output_2
    if [ $i -gt 0 ]; then
        IN=`hadoop dfs -cat $INPUT/part-* | awk '{print $1"\t"$3}' | sort -k2 -rn | head -n 100 | awk '{print $1}'`
        OUT=`hadoop dfs -cat $OUTPUT/part-* | awk '{print $1"\t"$3}' | sort -k2 -rn | head -n 100 | awk '{print $1}'`
        if [ "$IN" == "$OUT" ]; then
            echo "top-100 nodes do not change"
            break
        else
            echo "top-100 nodes changed"
        fi
        echo "[$i] remove $INPUT"
        hadoop dfs -rmr $INPUT
    fi
    i=$(($i+1))
done
