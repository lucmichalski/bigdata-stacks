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
    hadoop jar /opt/hadoop/share/hadoop/tools/lib/hadoop-streaming-2.5.1.jar ­D mapreduce.job.reduces=2 -mapper mapper -reducer reducer -file bin/mapper -file bin/reducer -input $INPUT -output $OUTPUT

    # compare the result with the previous run
    # the first output is output_1 and we assume it is different from input,
    # so start do the comparison when i > 0, i.e., compare start with output_1 and output_2
    if [ $i -gt 0 ]; then
        IN=`hdfs dfs -cat $INPUT/part-* | awk '{print $1"\t"$3}' | sort -k2 -rn | head -n 100 | awk '{print $1}'`
        OUT=`hdfs dfs -cat $OUTPUT/part-* | awk '{print $1"\t"$3}' | sort -k2 -rn | head -n 100 | awk '{print $1}'`
        if [ "$IN" == "$OUT" ]; then
            echo "top-100 nodes do not change"
            break
        else
            echo "top-100 nodes changed"
        fi
        echo "[$i] remove $INPUT"
        hdfs dfs -rm -r $INPUT
    fi
    i=$(($i+1))
done
