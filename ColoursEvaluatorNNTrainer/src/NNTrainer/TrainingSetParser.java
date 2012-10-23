package NNTrainer;

import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.LinkedList;
import java.util.List;

public class TrainingSetParser {
	private List<TrainingData> list;
	
	public TrainingSetParser(String filename, int splitIndex) {
		try {
			list = parseContents(filename, splitIndex);
		} catch (IOException e) {
			list = new LinkedList<TrainingData>();
			System.err.println("Error while opening/reading file \"" + filename + "\"");
			e.printStackTrace();
		}
	}
	
	public List<TrainingData> getList() {
		return this.list;
	}
	
	private static List<TrainingData> parseContents(String filename, int splitIndex) throws IOException{
		File file = new File(filename);
		FileInputStream fstream = new FileInputStream(file);
		DataInputStream in = new DataInputStream(fstream);
		BufferedReader br = new BufferedReader(new InputStreamReader(in));
		
		LinkedList<TrainingData> list = new LinkedList<TrainingData>();
		
		String line;
		while((line = br.readLine())!= null){
			char[] inputSet = line.substring(0, splitIndex).toCharArray();
			char[] outputSet = line.substring(splitIndex).trim().toCharArray();
			
			list.push(new TrainingData(charArrToDoubleArr(inputSet), charArrToDoubleArr(outputSet)));
		}
		
		return list;
	}
	
	private static double[] charArrToDoubleArr(char[] c){
		double[] intA = new double[c.length];
		int i = 0;
		for(char ch : c){
			intA[i++] = charToDouble(ch);
		}
		return intA;
	}
	
	private static double charToDouble(char c) {
		return c == '1' ? 1 : 0;
	}
	
}
