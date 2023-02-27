import java.util.Scanner;

public class Course {
    //attributes
    String course;

    double assignment1;

    double assignment2;

    //constructor
    public Course(String pCourse, double pAssignment1, double pAssignment2) {
        this.course = pCourse;
        this.assignment1 = pAssignment1;
        this.assignment2 = pAssignment2;
    }

    //Print name Method
    public String printCourse(Course currentCourse){
        return ("\n" + currentCourse.course);
    }

    public String courseReport(){
        double average = (assignment1 + assignment2)/2;
        String courseGrade = "";

        //Check course grade
        if      (average >= 100){courseGrade = "A";}
        else if  (average >= 70){courseGrade = "B";}
        else if  (average >= 50){courseGrade = "C";}
        else                    {courseGrade = "F";}

        //Return the results
        return ("Assignment1 - " + this.assignment1 + " Assignment2 - " + this.assignment2 + " Average - " + average + "\nCourse Grade - " + courseGrade);
    }

}
