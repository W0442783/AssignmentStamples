//Author: Nick Stevens (W0442783)
//Date: 02/05/2023
//Description: PROG1400 Assignment 1


import java.util.Arrays;
import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        //------------------------------Part 1------------------------------//

        //banner
        System.out.println("Welcome to Part 1!");

        //get the number of asterisks desired
        System.out.println("Enter number of asterisks: ");

        //first arrayLength variable will be used for the first half
        int arrayLength = sc.nextInt();

        //second array length variable will be used for the second half
        int arrayLengthLoopTwo = arrayLength;

        //set the array length to the value entered (desired number of asterisks)
        String[] asteriskArray = new String[arrayLength];

        //outer loop controls the number of lines printed
        for (int i = 0; i < arrayLength; ) {
            //first nested loop fills the array with the desired number of asterisks
            for (int j = 0; j < arrayLength; j++) {
                asteriskArray[j] = "*";
            }

            //print the current array
            System.out.println(Arrays.toString(asteriskArray));

            //second nested loop replaces the furthest asterisk element in the array with a blank line
            for (int k = 0; k < arrayLength; k++) {
                asteriskArray[k] = " ";
            }

            //decrement the array length to control the number of lines printed
            //and control which asterisk element gets replaced with a blank character
            //in the next round of the second nested loop
            arrayLength--;
        }

        //refill the array with asterisks
        for (int j = 0; j < arrayLengthLoopTwo; j++) {
            asteriskArray[j] = "*";
        }

        //set a counter to be used to control which asterisk element gets replaced with
        //a blank line
        int counter = 0;

        //first loop controls number of lines printed
        for (int i = 0; i < arrayLengthLoopTwo; ) {

            //print the array
            System.out.println(Arrays.toString(asteriskArray));

            //nested loop to replace the earliest asterisk element with a blank line
            for (int k = 0; k < arrayLengthLoopTwo; k++) {
                asteriskArray[counter] = " ";
            }

            //increment the counter to control which asterisk element gets replaced by a blank line
            //in the next round of the nested loop
            counter++;

            //decrement the array length to control the number of lines printed
            arrayLengthLoopTwo--;
        }


        //------------------------------Part 2------------------------------//

        //banner
        System.out.println();
        System.out.println("Welcome to Part 2!");

        int[] studentMarks = new int[10];

        //counter to print which element is being input
        counter = 0;

        for (int i = 0; i < studentMarks.length; i++) {
            counter++;
            System.out.println("Enter mark #" + counter + ":");
            studentMarks[i] = sc.nextInt();
        }

        //seed values for highest/lowest mark
        int lowestMark = studentMarks[0];
        int highestMark = studentMarks[0];

        //declaration and initialization of average mark variables
        int addAverageMark = 0;
        int averageMark = 0;

        //loop for finding min, max, and average mark
        for (int i = 0; i < studentMarks.length; i++) {

            //find the highest and lowest mark
            if (studentMarks[i] < lowestMark) {
                lowestMark = studentMarks[i];
            }
            if (studentMarks[i] > highestMark) {
                highestMark = studentMarks[i];
            }

            //add up the average
            addAverageMark += studentMarks[i];

            //divide added up marks by number of marks (length of array)
            //in order to find the average mark
            averageMark = addAverageMark / studentMarks.length;
        }

        //print the min, max, and average mark
        System.out.println();
        System.out.println("Final Report");
        System.out.println("Total marks: " + addAverageMark);
        System.out.println("Mark average: " + averageMark);
        System.out.println("Maximum mark: " + highestMark);
        System.out.println("Minimum mark: " + lowestMark);


        //------------------------------Part 3------------------------------//

        //banner
        System.out.println();
        System.out.println("Welcome to Part 3!");
        System.out.println();
        System.out.println("The array elements are:");
        System.out.println();

        //define rows and columns length as variables in order to more easily iterate
        //through nested loops later
        int rows = 3;
        int cols = 4;

        //counter used to fill matrix with data
        int inputData = 0;

        //create 2D array with hard coded rows and columns taken from instruction example
        int[][] matrix = new int[rows][cols];

        //create simple array with 12 element spaces to fit the 2D matrix array elements
        int[] simpleArray = new int[12];

        //space added for sake of formatting
        System.out.print(" ");

        //fill 2D array with values and print the matrix
        for (int i = 0; i < rows; i++){
            for (int j = 0; j < cols; j++){
                inputData += 5;
                matrix[i][j] = inputData;
                System.out.print(matrix[i][j] + " ");
            }
            System.out.print("\n");
        }


        //declare and initialize variables used for summation and averaging of matrix
        int arrayCounter = 0;
        int arrayDividend = 0;
        int arrayDivisor = rows * cols;
        counter = 0;

        //outer loop controls which row will be summed in the nested loop
        //inner loop iterates through each element in the given row and sums them
        //after breaking out back into the outer loop, the summation of each row is stored and also summed per row
        // counter is used to print the sum of each row
        for (int i = 0; i < rows; i++){
            for (int j = 0; j < cols; j++){
                arrayCounter += matrix[i][j];
            }

            counter++;
            System.out.println("The sum of row #" + counter + " is " + arrayCounter);
            arrayDividend += arrayCounter;
            arrayCounter = 0;
        }

        //average the matrix
        int arrayAverage = arrayDividend / arrayDivisor;

        //print the average
        System.out.println();
        System.out.println("Grade average is: " + arrayAverage);

        //counter to track which simple array element is being written to
        counter = 0;

        //nested loop which iterates though the rows and columns of the 2D array and assigns each value
        //to consecutive simple array
        for(int j = 0; j < cols; j++) {
            for (int i = 0; i < rows; i++) {
                simpleArray[counter] = matrix[i][j];
                counter++;
            }
        }

        //print banner for converted array
        System.out.println();
        System.out.println("Converted array elements are:");

        //pint simple array
        for (int i = 0; i < simpleArray.length; i++){
            System.out.println(simpleArray[i]);
        }

        //bubble sort and print the simple array

        //========================================IMPORTANT!========================================//
        //Bubble sort algorithm sourced from: https://www.geeksforgeeks.org/bubble-sort/
        //Contributed by: Rajat Mishra
        int n = simpleArray.length;
        for (int i = 0; i < n - 1; i++)
            for (int j = 0; j < n - i - 1; j++)
                if (simpleArray[j] > simpleArray[j + 1]) {
                    // swap arr[j+1] and arr[j]
                    int temp = simpleArray[j];
                    simpleArray[j] = simpleArray[j + 1];
                    simpleArray[j + 1] = temp;
                }


         /* Prints the array */
        System.out.println();
        System.out.println("Sorted array elements:");

        for (int i = 0; i < n; ++i)
            System.out.print(simpleArray[i] + " ");
        System.out.println();

        //========================================IMPORTANT!========================================//
        //Bubble sort algorithm sourced from: https://www.geeksforgeeks.org/bubble-sort/
        //Contributed by: Rajat Mishra
    }

}