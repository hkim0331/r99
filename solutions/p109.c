#include <stdio.h>
#include <stdlib.h>

// is_prime() の引数を long に拡張したバージョン。
int is_prime_long(long n) {
  if (n<3) {
    return n==2;
  }
  if (n%2==0) {
    return 0;
  }
  long i;
  for (i=3; i*i<=n; i+=2) {
    if (n%i==0) {
      return 0;
    }
  }
  return 1;
}

// 引数の n を割り切る最小の整数。
// n が偶数であれば 2、
// n が奇数であれば 3 から 2 飛ばしで探す。
long first_divisor(long n) {
  long i;

  if (n%2==0) {
    return 2;
  }
  for (i=3; i*i<=n; i+=2) {
    if (n%i==0) {
      return i;
    }
  }
  return n; // error
}

// n が素数ならそれが答え、
// n が素数でない時は最初に見つかる素因数で割ったのでやり直し。
long p109(long n) {
  if (is_prime_long(n)) {
    return n;
  } else {
    return p109(n/first_divisor(n));
  }
}

int main(int argc, char *argv[]){
  if (argc!=2) {
    exit(1);
  }
  printf("%li\n", p109(atol(argv[1])));
  return 0;
}
