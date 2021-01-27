// このプログラムは power(2,31)-1 が素数であることを見逃している
// 間違いプログラムです。間違いはどこに？
// サービスで、プログラム全体を載せます。
// エラーをフィックスしてください。

#include <stdio.h>

// p16
int power(int b, int n) {
  if (n==0) {
    return 1;
  } else {
    return b * power(b, n-1);
  }
}

// p32
int is_prime(int n) {
  if (n<3) {
    return n==2;
  }
  if (n%2==0) {
    return 0;
  }
  long i;
  for (i=3; i*i <= n; i+=2) {
    if (n%i == 0) {
      return 0;
    }
  }
  return 1;
}

int p101(void) {
  int n;

  for (n=power(2,31)-1; ; n -= 2) {
    if (is_prime(n)) {
      return n;
    }
  }
  return -1;
}

int main(void) {
  printf("%i\n", p101()); // no. 2147483647 is prime.
  return 0;
}
