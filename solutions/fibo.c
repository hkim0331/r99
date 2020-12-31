#include <stdio.h>
#include <stdlib.h>

int fibo_aux(int n, int p1, int p2) {
  if (n==0) {
    return p1;
  } else {
    return fibo_aux(n-1, p2, p1+p2);
  }
}

int fibo(int n) {
  return fibo_aux(n, 0, 1);
}

// 前問で定義した fibo(i) の戻り値が 20000 を
// 超えるまで、i を 0 から +1 し続ける。
// 戻り値は超えたときの i.
int fibo_over(int n) {
  int i;

  for (i=0; ; i++) {
    if (n < fibo(i)) {
      return i;
    }
  }
  return -1;
}

// fibo()を計算するのは時間がかかるので
// (hkimura は高速 fibo を使ってるけどな)
// f に計算結果を記憶し、再計算せずに使い回す。
int sum_of_fibo_between(int n, int m) {
  int i;
  int sum=0;
  int f;

  for (i=0;;i++) {
    f = fibo(i);
    if (n <= f && f < m) {
      sum += f;
    }
    if (m < f) {
      return sum;
    }
  }
}

int main(void) {
  printf("%i\n", fibo_over(20000));
  printf("%i\n", sum_of_fibo_between(10000, 100000));
  return 0;
}
