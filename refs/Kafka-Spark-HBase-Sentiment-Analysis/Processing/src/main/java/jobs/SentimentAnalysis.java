package jobs;

import Utils.SentimentAnalysisUtil;
import org.apache.phoenix.util.PropertiesUtil;
import org.apache.spark.broadcast.Broadcast;
import org.apache.spark.streaming.api.java.JavaDStream;
import org.apache.spark.streaming.api.java.JavaPairDStream;
import org.apache.spark.streaming.api.java.JavaStreamingContext;
import java.io.Serializable;
import java.util.*;
import java.util.stream.Collectors;

public class SentimentAnalysis implements Serializable {

    //    Load Files
    private Broadcast<Set<String>> uselessWords;
    private Broadcast<Set<String>> positiveWords;
    private Broadcast<Set<String>> negativeWords;
    private ClassLoader classLoader;

    public SentimentAnalysis(JavaStreamingContext jssc) {
        classLoader = PropertiesUtil.class.getClassLoader();
        uselessWords = jssc.sparkContext().broadcast(SentimentAnalysisUtil.loadFile(classLoader.getResource("stop-words.dat").getPath()));
        positiveWords = jssc.sparkContext().broadcast(SentimentAnalysisUtil.loadFile(classLoader.getResource("pos-words.dat").getPath()));
        negativeWords = jssc.sparkContext().broadcast(SentimentAnalysisUtil.loadFile(classLoader.getResource("neg-words.dat").getPath()));
    }

    public JavaDStream<String> applySentimentAnalysis(JavaPairDStream<String, List<String>> stream){
        JavaPairDStream<String, List<String>> textUsefullWordsPair = stream
                .mapValues(wordsArray -> wordsArray.stream().map(elem -> elem.toLowerCase()))
                .mapValues(lowerStream -> lowerStream.filter(elem -> elem.matches("[a-z]+")).filter(word -> !uselessWords.value().contains(word)))
                .mapValues(significantStream -> significantStream.collect(Collectors.toList()));

        JavaPairDStream<String, Integer> textScoreTuple = textUsefullWordsPair
                .mapValues(words -> SentimentAnalysisUtil.computeScore(words, positiveWords.value(), negativeWords.value()))
                .filter(textScore -> textScore._2 != 0);

        JavaDStream<String> formattedResult = textScoreTuple.map(textScore -> Double.toString(Math.random()).replace("0.", "") + ":text:" + textScore._1.replace(':', ',')+ ":score:" + textScore._2);
        return formattedResult;
    }
}
