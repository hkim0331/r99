#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

// p51.
int my_rand(int n) {
  return (int)(random() % n);
}

void init_random(int a[], int n) {
  int i;

  for (i=0;i<n;i++) {
    a[i] = my_rand(100); // p51
  }
}

// 並べ替えの一般解書いてもいいけど、
// ここは「配列の要素は 0~99」の前提を利用しちゃえ。
void sort(int a[], int b[], int n) {
  int m;
  int i;
  int j=0;
  for (m=0; m<100; m++) {
    for (i=0; i<n; i++) {
      if (a[i] == m) {
        b[j] = m;
        j++;
      }
    }
  }
}

// 配列をプリントする。
void print(int x[], int n) {
  int i;
  for (i=0; i<n; i++) {
    printf("%i ", x[i]);
  }
  printf("\n");
}

// 左の要素は右の要素よりも小さいか？
// ループの終わりが n-1 になることに注意。
int is_sorted(int b[], int n) {
  int i;
  for (i=0; i<n-1; i++) {
    if (b[i] > b[i+1]) {
      return 0;
    }
  }
  return 1;
}

int main(void) {
  int n=30;
  int a[n];
  int b[n];

  srandom(getpid());
  init_random(a,n);
  sort(a, b, n);
  print(a, n);
  printf("%i\n", is_sorted(a,n));
  print(b, n);
  printf("%i\n", is_sorted(b,n));
  return 0;
}
