package NNTrainer;
import java.util.Arrays;

import org.neuroph.core.NeuralNetwork;
import org.neuroph.core.learning.SupervisedTrainingElement;
import org.neuroph.core.learning.TrainingSet;
import org.neuroph.nnet.CompetitiveNetwork;
import org.neuroph.nnet.MultiLayerPerceptron;
import org.neuroph.nnet.Perceptron;
import org.neuroph.nnet.SupervisedHebbianNetwork;
import org.neuroph.nnet.UnsupervisedHebbianNetwork;
import org.neuroph.nnet.learning.DynamicBackPropagation;
import org.neuroph.nnet.learning.MomentumBackpropagation;
import org.neuroph.nnet.learning.ResilientPropagation;
import org.neuroph.nnet.learning.SimulatedAnnealingLearning;
import org.neuroph.nnet.learning.SupervisedHebbianLearning;
import org.neuroph.nnet.learning.UnsupervisedHebbianLearning;
import org.neuroph.util.TransferFunctionType;

/**
 * This sample shows how to create, train, save and load simple Multi Layer Perceptron for the XOR problem.
 * This sample shows basics of Neuroph API.
 * @author Zoran Sevarac <sevarac@gmail.com>
 */
public class ColoursNeuralNetwork {

    /**
     * Runs this sample
     */
	public static void main(String[] args){
        // create training set (logical XOR function)
    	int inputs = 96;
    	int outputs = 1;
        TrainingSet<SupervisedTrainingElement> trainingSet = new TrainingSet<SupervisedTrainingElement>(inputs, outputs);
        TrainingSetParser parser = new TrainingSetParser("input", inputs);
        
        int index = 0;
        for(TrainingData<Double> td : parser.getList()){
        	trainingSet.addElement(new SupervisedTrainingElement(td.inputs(), td.output()));
        	index++;
        	if(index> 100) break;
        }
        
        
//        trainingSet.addElement(new SupervisedTrainingElement(new double[]{0, 0}, new double[]{0}));
//        trainingSet.addElement(new SupervisedTrainingElement(new double[]{0, 1}, new double[]{1}));
//        trainingSet.addElement(new SupervisedTrainingElement(new double[]{1, 0}, new double[]{1}));
//        trainingSet.addElement(new SupervisedTrainingElement(new double[]{1, 1}, new double[]{0}));

        // create multi layer perceptron
        MultiLayerPerceptron myMlPerceptron = new MultiLayerPerceptron(TransferFunctionType.SIGMOID, inputs, inputs, 1);
        myMlPerceptron.setLearningRule(new SupervisedHebbianLearning());

        // enable batch if using MomentumBackpropagation
//        if( myMlPerceptron.getLearningRule() instanceof MomentumBackpropagation )
//        	((MomentumBackpropagation)myMlPerceptron.getLearningRule()).setBatchMode(true);

        // learn the training set
        System.out.println("Training neural network...");
        myMlPerceptron.learn(trainingSet);

        // test perceptron
        System.out.println("Testing trained neural network");
        testNeuralNetwork(myMlPerceptron, trainingSet);

        // save trained neural network
        myMlPerceptron.save("myMlPerceptron.nnet");

        // load saved neural network
        NeuralNetwork loadedMlPerceptron = NeuralNetwork.load("myMlPerceptron.nnet");

        // test loaded neural network
        System.out.println("Testing loaded neural network");
        testNeuralNetwork(loadedMlPerceptron, trainingSet);
    }

    /**
     * Prints network output for the each element from the specified training set.
     * @param neuralNet neural network
     * @param trainingSet training set
     */
    public static void testNeuralNetwork(NeuralNetwork neuralNet, TrainingSet<SupervisedTrainingElement> trainingSet) {

        for(SupervisedTrainingElement trainingElement : trainingSet.elements()) {
            neuralNet.setInput(trainingElement.getInput());
            neuralNet.calculate();
            double[] networkOutput = neuralNet.getOutput();

            System.out.print("Input: " + Arrays.toString( trainingElement.getInput() ) );
            System.out.println(" Output: " + Arrays.toString( networkOutput) );
        }
    }

}