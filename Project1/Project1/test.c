#define EPSILON 0.00001  // 0,1 og kod.
#include <stdio.h>

double func(double x) 
{ 
    return x*x*x - x*x + 2; 
} 

void bisection(int a, int b) 
{ 
    double a1 = a;
    double b1 = b;
    if (func(a1) * func(b1) >= 0) 
    { 
        printf("You have not assumed right a and b\n"); 
        return; 
    } 
  
    double c = a1;  // floating
    while ((b1-a1) >= EPSILON) 
    { 
        // Find middle point 
        c = (a1+b1)/2; 
  
        // Check if middle point is root 
        if (func(c) == 0.0) 
            break; 
  
        // Decide the side to repeat the steps 
        else if (func(c)*func(a1) < 0) 
            b1 = c; 
        else
            a1 = c; 
    } 
    printf("The value of root is : %f\n",c); 
} 
int main() 
{ 
    // Initial values assumed 
    int a =-200, b = 300; 
    bisection(a, b); 
    return 0; 
} 
