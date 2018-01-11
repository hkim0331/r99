#include <stdio.h>
#include <stdlib.h>

int is_square(int n) {
  int i;

  for (i=1; i*i<n; i++) {
    ;
  }
  return i*i==n;
}

int is_prime(int n) {
  long int i;
  long int nn = n;

  if (n==0 || n==1) {
    return 0;
  } else if (n==2) {
    return 1;
  }
  if (n%2 == 0) {
    return 0;
  }
  for (i=3; i*i<=nn; i+=2) {
    if (n%i == 0) {
      return 0;
    }
  }
  return 1;
}

int even(int n) {
  return n%2==0;
}

#define sq(x) (x)*(x)
int power(int n, int m) {
  if (m==0) {
    return 1;
  } else if (even(m)) { //p 13
    return sq(power(n, m/2));
  } else {
    return n * power(n, m-1);
  }
}

int p101() {
  int i;

  for (i=power(2,16);i>1;i--) { // p39
    if (is_prime(i)) { //p23
      return i;
    }
  }
  return 0;
}

int main(int argc, char *argv[]) {
  printf("%i\n", p101()));
  //  printf("%i\n",is_square(atoi(argv[1])));
  return 0;
}
