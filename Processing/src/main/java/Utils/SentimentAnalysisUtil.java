package Utils;

import scala.reflect.internal.util.Collections;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

public class SentimentAnalysisUtil {
    public static Set<String> loadFile(String pathToFile){
        Set<String> fileContent = new HashSet<>();
        String line = null;
        try {
            BufferedReader reader = new BufferedReader(new FileReader(pathToFile));
            while ((line = reader.readLine()) != null){
                fileContent.add(line);
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e){
            e.printStackTrace();
        }
        finally {
            return fileContent;
        }
    }

     public static Integer computeScore(List<String> words, Set<String> positiveWords, Set<String> negativeWords){
        return words.stream().map(word -> computeWordScore(word, positiveWords, negativeWords)).reduce(0, Integer::sum);
     }

     public static Integer computeWordScore(String word,Set<String> positiveWords, Set<String> negativeWords){
        if(positiveWords.contains(word))
            return 1;
        else if(negativeWords.contains(word))
            return -1;
        else
            return 0;
     }
}

