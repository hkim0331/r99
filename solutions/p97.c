#include <stdio.h>
#include <stdlib.h>

int is_square(int n){
  int i;

  for (i=0; i*i<n; i++) {
    ;
  }
  return i*i == n;
}

// n を超えない三乗数 i*i*i のうち、
// 平方数となるものを cubic にメモする。
// ループ中 i*i*i を3回計算するのは効率的じゃない。
// 直してみよ。
int p97(int n) {
  int i = 1;
  int cubic = 0;

  for (i=1; i*i*i < n; i++) {
    if (is_square(i*i*i)) { // p33
      cubic = i*i*i;
    }
  }
  return cubic;
}

int main(int argc, char *argv[]) {
  if (argc != 2) {
    printf("usage: ./a.out <num>\n");
    exit(1);
  }
  printf("%i\n", p97(atoi(argv[1])));
  return 0;
}

