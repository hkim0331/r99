#include <stdio.h>
#include <stdlib.h>

int is_prime2(int n) {
  int i;
  int nn = n;

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

int main(int argc, char *argv[]) {
  printf("%i,%i\n",is_prime2(0x7fffffff),is_prime(0x7fffffff));
  return 0;
}
