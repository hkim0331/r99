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

int prime_under(int n) {
  int i;

  for (i=n;i>1;i--) { // p39
    if (is_prime(i)) { //p23
      return i;
    }
  }
  return 0;
}

int sum_of_primes(int n) {
  int sum=2;
  int i;

  n-=1; // for prime 2
  for (i=3; n>0; i+=2) {
    if (is_prime(i)) {
      sum +=i;
      n--;
    }
  }
  return sum;
}

void prime_pythagoras(int n) {
  int primes[n];
  int i;
  int j;

  j=0;
  for (i=0; i<n; i++) {
    if (is_prime(i)) {
      primes[j]=i;
      j++;
    }
  }
  primes[j]=-1;// mark

  for (i=0;primes[i]!=-1;i++) {
    for (j=0; j<i; j++) {
      if (is_square(sq(primes[i])+sq(primes[j]))) {// p100
        printf("%i^2+%i^2 becomes square number\n",primes[i], primes[j]);
      }
    }
  }
}

int main(int argc, char *argv[]) {
  //  printf("%i\n", prime_under(power(2,16)));
  //printf("%i\n", prime_under(0x7fffffff));
  //printf("%i\n", sum_of_primes(10000));
  prime_pythagoras(10000);
  //printf("%i, %i\n",power(2,30),power(2,31));
  //  printf("%i\n",is_square(atoi(argv[1])));
  return 0;
}
