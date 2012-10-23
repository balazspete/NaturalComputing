package NNTrainer;

public class TrainingData<T> {

	private double[] inputs;
	private double[] output;
	
	public TrainingData(double[] inputs, double[] output) {
		this.inputs = inputs;
		this.output = output;
	}
	
	public double[] inputs() {
		return this.inputs;
	}
	
	public double[] output() {
		return this.output;
	}
	
}
