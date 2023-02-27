public class Student {
    //attributes
    String studentName;
    double studentFirstGrade;
    double studentSecondGrade;

    //construct
    public Student(String pStudentName, double pStudentFirstGrade, double pStudentSecondGrade){
        this.studentName = pStudentName;
        this.studentFirstGrade = pStudentFirstGrade;
        this.studentSecondGrade = pStudentSecondGrade;
    }

    //Report method

    public String studentReport(Student student){
        double total = 0;

        total = student.studentFirstGrade + student.studentSecondGrade; //Add up total grades

        //Return the results
        return (student.studentName + ": " + "Assignment1 - " + student.studentFirstGrade + " Assignment2 - " + student.studentSecondGrade + " Total - " + total);
    }

}