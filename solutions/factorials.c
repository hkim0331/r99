#include <stdio.h>
#include <stdlib.h>

//p67
int factorial(int n) {
  if (n==0) {
    return 1;
  } else {
    return n*factorial(n-1);
  }
}

// 題意に沿ってループする。
// p67で定義した factorial() を利用する。
int factorial_over(int m) {
  int i;

  for (i=0; factorial(i) <= m; i++) {
    ;
  }
  return i;
}

int factorial_overflow(void) {
  int i;
  for (i=0; factorial(i) >0; i++) {
    ;
  }
  return i;
}

int main(void) {
  printf("%i\n", factorial_over(2000000));
  printf("%i\n", factorial_overflow());
  return 0;
}
