#include <stdio.h>
#include <stdlib.h>

int is_prime(int n) {
  if (n<3) {
    return n==2;
  }
  if (n%2==0) {
    return 0;
  }
  int i;
  for (i=3; i*i<=n; i+=2) {
    if (n%i==0) {
      return 0;
    }
  }
  return 1;
}

int power(int b, int n) {
  if (n==0) {
    return 1;
  } else {
    return b * power(b, n-1);
  }
}

// 2^16 -1 から 2 ずつ下がりつつ、素数かどうかを見る。
// p16 の power(), p32 の is_prime() を利用する。
int p100(void) {
  int n;

  for (n = power(2,16)-1; ; n -= 2) {
    if (is_prime(n)) {
      return n;
    }
  }
}

int main(int argc, char *argv[]) {
  printf("%i\n", p100());
  return 0;
}
