//Author: Nick Stevens (W0442783)
//Date: 01/18/2023
//Description: PROG2007 Assignment 1

#include <stdio.h>

int main(void)
{
    //Declaration
    int addSub, bodyVal, topVal, count;
    char charN;
    _Bool flag;

    //Initialization
    addSub = 0;
    bodyVal = 0;
    topVal = 0;
    flag = 0;
    charN = 'N';
    count = 0;


    //Print the banner and the top row
    do {
        //banner + the "N"
        printf("TABLE OF PRODUCTS\n");
        printf("\n");
        printf("%3C", charN);
        flag = 1;

        //top row
        for (int i = 1; i <= 10; ++i) {
            ++topVal;
            printf("%7i", topVal);
        }

        printf("\n");
    }
    while (flag != 1);

    //Table body loop
    for (count = 1; count <= 10; ++count) {
        ++addSub;
        bodyVal = 0;


        printf("%3i", addSub);

        for (int i = 1; i <= 10; ++i) {
            bodyVal += addSub;
            printf("%7i", bodyVal);
        }
        printf("\n");

        }

    //space out the tables
    printf("\n");

    //Re-initialize values to be re-used in constructing the second table
    addSub = 11;
    topVal = 11;
    flag = 0;
    charN = 'N';
    count = 0;


    //Print the banner and the top row
    do {
        //Banner + the "N"
        printf("REVERSED TABLE OF PRODUCTS\n");
        printf("\n");
        printf("%4C", charN);
        flag = 1;

        //top row
        for (int i = 1; i <= 10; ++i) {
            --topVal;
            printf("%7i", topVal);
        }

        printf("\n");
    }
    while (flag != 1);

    //Table body loop
    for (count = 1; count <= 10; ++count) {
        --addSub;
        bodyVal = addSub * 10;

        //Constructs the left side and the values in the first column
        printf("%5i ", addSub);
        printf("%5i", bodyVal);

        //Calculates and prints the rest of the table
        for (int i = 1; i <= 9; ++i) {
            bodyVal = bodyVal - addSub;
            printf("%7i", bodyVal);
        }
        printf("\n");

    }

    return 0;
}