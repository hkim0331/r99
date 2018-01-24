#include <stdio.h>
#include <stdlib.h>

// 途中経過を記録する配列の長さ。
// happy 数の判定に以上かかるときはお手上げ。
#define MAX 1000

// 各桁の数を2乗して総和する
int sum_of_sq_digits(int n) {
  int ret = 0;
  int d;

  for ( ;n!=0;n /= 10) {
    d = n%10;
    ret += d*d;
  }
  return ret;
}

// 配列 m[] に整数 n が含まれているか？
int find_p(int n, int m[]) {
  int i;

  for (i=0; i<MAX-1; i++) {
    if (m[i]==n) {
      return 1;
    }
    if (m[i]==-1) {
      return 0;
    }
  }
  return 0;
}

// n を配列 m[] の最後に追加
void push(int n, int m[]) {
  int i;

  for (i=0; i<MAX-1; i++) {
    if (m[i]==-1) {
      m[i] = n;
      m[i+1] = -1;
      return;
    }
  }
  printf("error: overflow\n");
  exit(1);
}

// 配列 mem[] の最後は -1 でマーク
int happy(int n) {
  int mem[MAX] = {-1};

  for (;;) {
    if (n==1) {
      return 1;
    }
    n = sum_of_sq_digits(n);
    if (find_p(n, mem)) {
      return 0;
    } else {
      push(n, mem);
    }
  }
}

int main(int argc, char *argv[]) {
  int i;

  for (i=1;i<atoi(argv[1]);i++) {
    if (happy(i)) {
      printf("%i, ",i);
    }
  }
  printf("\n");
  return 0;
}


（96 と被ったので新しいのと入れ替え）整数 n がハッピー数かどうかを判定する関数 int happy(int n). 2018 はハッピー数ではない。2019 はハッピー数。ハッピー数についてはネットで調べること。
