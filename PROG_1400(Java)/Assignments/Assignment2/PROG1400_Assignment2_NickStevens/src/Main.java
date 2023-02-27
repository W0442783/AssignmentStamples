import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        //new scanner
        Scanner sc = new Scanner(System.in);
        //variables
        int       counter = 0; //Used to track which Course or Student is currently having info gathered
        String currentStudent; //Used to print the name of the student actively having data gathered
        double         grade1; //Used to hold the first grade of student actively having data gathered
        double         grade2; //Used to hold the second grade of student actively having data gathered

        //------------------------------GatherCourseData------------------------------//
        Course[] Courses = new Course[6]; //Create an array to hold the courses

        counter++;
        System.out.println("Please enter course #" + counter);
        Course firstCourse = new Course(sc.nextLine(), 0.0, 0.0); //Define first course name

        counter++;
        System.out.println("Please enter course #" + counter);
        Course secondCourse = new Course(sc.nextLine(), 0.0, 0.0); ////Define second course name

        //------------------------------GatherStudentData------------------------------//
        counter = 0; //Zero out counter used to count the courses, so it may count students

        //Banner
        System.out.println("Student Data");
        System.out.println("==============================\n");

        //First course array containing six students
        Student[] courseOne = new Student[6];

        for (int i = 0; i < courseOne.length; i++){
            counter++; //Count the students

            System.out.println("Enter name for student #" + counter);
            currentStudent = sc.nextLine(); //Container for current student's name

            do {
                System.out.println("Enter Assignment1 mark for " + currentStudent);
                grade1 = sc.nextInt(); //Container for current student's first grade
                if (grade1 > 20 || grade1 < 0){ //Validate input
                    System.out.println("Value out of range (Must be between 0.00 and 20.00");
                }
            }while (grade1 < 0 || grade1 > 20); //Continue until valid input is entered
            
            do {
                System.out.println("Enter Assignment2 mark for " + currentStudent);
                grade2 = sc.nextInt(); //Container for current student's second grade
                if (grade2 > 20 || grade2 < 0){ //Validate input
                    System.out.println("Value out of range (Must be between 0.00 and 20.00");
                }
            }while (grade2 > 20 || grade2 < 0); //Continue until valid input is entered

            sc.nextLine(); //Consumes the \n left over after nextInt() scanner is finished scanning grades

            //Catch which student is being worked on, pass variables containing their name, first grade, and second grade
            //Also assigns each student to it's appropriate position in the array
            if      (i == 0){Student student1 = new Student(currentStudent, grade1, grade2); courseOne[i] = student1;}
            else if (i == 1){Student student2 = new Student(currentStudent, grade1, grade2); courseOne[i] = student2;}
            else if (i == 2){Student student3 = new Student(currentStudent, grade1, grade2); courseOne[i] = student3;}
            else if (i == 3){Student student4 = new Student(currentStudent, grade1, grade2); courseOne[i] = student4;}
            else if (i == 4){Student student5 = new Student(currentStudent, grade1, grade2); courseOne[i] = student5;}
            else            {Student student6 = new Student(currentStudent, grade1, grade2); courseOne[i] = student6;}

            firstCourse.assignment1 += grade1;
            firstCourse.assignment2 += grade2;
        }

        counter = 0; //Zero out counter to be reused in counting course two's students

        //Second course array containing six students
        Student[] courseTwo = new Student[6];

        for (int i = 0; i < courseTwo.length; i++){
            counter++; //Count the students

            System.out.println("Enter name for student #" + counter);
            currentStudent = sc.nextLine(); //Container for current student's name

            do {
                System.out.println("Enter Assignment1 mark for " + currentStudent);
                grade1 = sc.nextInt(); //Container for current student's first grade
                if (grade1 > 20 || grade1 < 0){ //Validate input
                    System.out.println("Value out of range (Must be between 0.00 and 20.00");
                }
            }while (grade1 < 0 || grade1 > 20); //Continue until valid input is entered

            do {
                System.out.println("Enter Assignment2 mark for " + currentStudent);
                grade2 = sc.nextInt(); //Container for current student's second grade
                if (grade2 > 20 || grade2 < 0){ //Validate input
                    System.out.println("Value out of range (Must be between 0.00 and 20.00");
                }
            }while (grade2 > 20 || grade2 < 0); //Continue until valid input is entered

            sc.nextLine(); //Consumes the \n left over after nextInt() scanner is finished scanning grades

            //Catch which student is being worked on, pass variables containing name, first grade, and second grade
            //Also assigns each student to it's appropriate position in the array
            if      (i == 0){Student student1 = new Student(currentStudent, grade1, grade2); courseTwo[i] = student1;}
            else if (i == 1){Student student2 = new Student(currentStudent, grade1, grade2); courseTwo[i] = student2;}
            else if (i == 2){Student student3 = new Student(currentStudent, grade1, grade2); courseTwo[i] = student3;}
            else if (i == 3){Student student4 = new Student(currentStudent, grade1, grade2); courseTwo[i] = student4;}
            else if (i == 4){Student student5 = new Student(currentStudent, grade1, grade2); courseTwo[i] = student5;}
            else            {Student student6 = new Student(currentStudent, grade1, grade2); courseTwo[i] = student6;}

            secondCourse.assignment1 += grade1; //Add up the totals of first assignments
            secondCourse.assignment2 += grade2; //Add up the totals of second assignments
        }

        //------------------------------PrintSCourseReport------------------------------//
        System.out.println(firstCourse.courseReport()); //Frst course report
        System.out.println(secondCourse.courseReport()); //Second course report

        //------------------------------PrintStudentReport------------------------------//

        //Banner for first course
        System.out.println("\nReport: Stats per student");
        System.out.println("==============================");
        System.out.println(firstCourse.printCourse(firstCourse));

        //Print out the first course's students and their grades
        for (int i = 0; i < courseOne.length; i++) {
            Student average = courseOne[i];
            System.out.println(average.studentReport(courseOne[i]));
        }

        //Banner for second course
        System.out.println(secondCourse.printCourse(secondCourse));

        //Print out the second course's students and their grades
        for (int i = 0; i < courseTwo.length; i++) {
            Student average = courseTwo[i];
            System.out.println(average.studentReport(courseTwo[i]));
        }
    }
}