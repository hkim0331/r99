// 数学を使うと n=3 が唯一の解であることを証明できる。
// ここでは C の int の範囲で全探索する。n=3 しか見つからんのだけどね。
// is_cubic()書いてもいいんだけど、スピードアップのために、
// 2^31-1 以下の立方数を配列にメモっておく方法を採る。
// 2^31-1 を超えない立方数の最大は 1290^3 = 2146689000.

#include <stdio.h>

int factorial(int n) {
    if (n==0) {
      return 1;
    } else {
      return n*factorial(n-1);
    }
}

#define MAX 1291

void init_array(int a[],int n) {
  int i;

  for (i=0; i<n; i++) {
    a[i] = i*i*i;
  }
}

int find(int x, int a[], int n) {
  int i;

  for (i=0; i<n; i++) {
    if (x == a[i]) {
      return 1;
    }
  }
  return 0;
}

void p103(void) {
  int cubics[MAX];
  int i;
  init_array(cubics, MAX);
  int f;

  for (i=0;i<MAX;i++) {
    f =factorial(i);
    if (f < 0) { // overflow
      break;
    }
    if (find(f+2, cubics, MAX)) {
      printf("%i!+2 is a cubic number\n",i);
    }
  }
}

int main(void) {
  p103();
  return 0;
}
