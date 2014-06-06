package stemmer;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.*;

public class PorterCheck {
    private static final String DEFAULT_TEST_FILE = "C:/Users/vaibhav/Desktop/rev.txt";
    public static void main(String args[]) throws IOException{
        PorterAlgo pa = new PorterAlgo();

        //checks for vowels in a given string
        System.out.println(pa.containsVowel("vaibhav"));

        //removes special characters
        System.out.println(pa.Clean("vaibhav's book"));

        //check for a given suffix
        NewString stem = new NewString();
        System.out.println(pa.hasSuffix("corresponding","ing",stem));

        //stemming the words
        ArrayList<String> tok = new ArrayList<String>();
        String[] tokens = {"normalize","technical","education"};
        for (String x: tokens){
            tok.add(x);
        }
        System.out.println(completeStem(tok));

        String fileName = ((args.length > 0) ? args[0] : DEFAULT_TEST_FILE);
        FileReader fileReader = new FileReader(new File(fileName));
        FileTokenizer fileTokenizer = new FileTokenizer();
        List<String> tokens1 = fileTokenizer.tokenize(fileReader);

        System.out.println("Tokenizing the input file:");
        System.out.print(completeStem(tokens1));
    }

    //method to completely stem the words in an array list
    public static ArrayList<String> completeStem(List<String> tokens1){
        PorterAlgo pa = new PorterAlgo();
        ArrayList<String> arrstr = new ArrayList<String>();
        for (String i : tokens1){
            String s1 = pa.step1(i);
            String s2 = pa.step2(s1);
            String s3= pa.step3(s2);
            String s4= pa.step4(s3);
            String s5= pa.step5(s4);
            arrstr.add(s5);
        }
        return arrstr;
    }

    //method to tokenize a file
    public static ArrayList<String> fileTokenizer(){
        StringTokenizer strtoken = new StringTokenizer("this is a book");
        ArrayList<String> filetoken = new ArrayList<String>();
        while(strtoken.hasMoreElements()){
            filetoken.add(strtoken.nextToken());
        }
        return filetoken;
    }
}