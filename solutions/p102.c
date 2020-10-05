// 数学を使うと
// p^2+q^2=r^2 を満たす素数 p,q,r は存在しないことが
// 証明できる。
// p102では範囲を制限して全探索する。
// lisp でさらっと書きたいぞ。
#include <stdio.h>
#define MAX 200

int is_prime_odd(int n) {
  int i;

  for (i=3; i*i<=n; i+=2) {
    if (n%i==0) {
      return 0;
    }
  }
  return 1;
}

int is_prime(int n) {
  if (n<3) {
    return n==2;
  }
  if (n%2 == 0) {
    return 0;
  }
  return is_prime_odd(n);
}
// 1000以下の素数の2乗を配列 p2 に入れる。
// 戻り値は最大の素数が入った場所 + 1
int init_primes_sq(int p2[]) {
  int j=1;
  int i;

  p2[0] = 4;
  for (i=3; i<=1000; i+=2) {
    if (is_prime(i)) {
      p2[j] =i*i;
      j++;
      // need error check here.
      // but number of primes under 1000 is 168.
    }
  }
  return j;
}

int exists(int x, int p[], int n) {
  int i;

  for (i=0;i<n;i++) {
    if (x==p[i]) {
      return x;
    }
  }
  return 0;
}


void p102(void) {
  int p[MAX];
  int n = init_primes_sq(p);
  int i;
  int j;
  int r;

  for (i=0; i<n; i++) {
    for (j=0; j<=i; j++) {
      r = exists(p[i]+p[j], p, n);
      if (r) {
        printf("ウッソー、そんな数ねーはず？ %i+%i=%i\n",p[i],p[j],r);
      }
    }
  }
  printf("お疲れ様でした。\n");
}

int main(void) {
  p102();
}
