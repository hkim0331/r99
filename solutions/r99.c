#include <stdio.h>
#include <stdlib.h>

void hello_p(void) {
  printf("hello, robocar!\n");
}

void hellos_p(int n) {
  int i;

  for (i = 0; i < n; i++) {
    printf("hello, robocar!\n");
  }
}

void add1_p(void) {
  int n;

  scanf("%i", &n);
  printf("%i\n",n+1);
}

int add1(int x) {
  return x + 1;
}

void en_p(void) {
  float r;

  scanf("%f", &r);
  printf("%f\n", r*r*3.14);
}

int is_square_sum(int n) {
  int i;
  int j;

  for (i = 1; i*i <= n; i++) {
    for (j = 1; j*j <= n-i*i; j++) {
      if (j*j == n-i*i) {
        return 1;
      }
    }
  }
  return 0;
}

int square_cubic(int n)  {
  
}

int main(void) {
  printf("%i\n", is_square_sum(452));
  printf("%i\n", is_square_sum(453));
  //en_p();
  //add1_p();
  //hellos_p(10);
  //  hello_p();
  return 0;
}

