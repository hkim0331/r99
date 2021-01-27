#include <stdio.h>
#include <stdlib.h>

int my_rand(int n) {
  return (int)(random() % n);
}

// 関数内部に要素が 0~n-1 となる配列 a を作る。
// p51 の my_rand(n) で 0~n-1 の範囲の乱数を得て、
// その乱数をインデックスとする配列要素を入れ替える。
// この操作を 2*n 繰り返せば、
// 配列 a はじゅうぶんにシャッフルできるだろう。
int* shuffle(int n) {
  int* a = (int*)malloc(sizeof(int)*n);
  int i;

  // 初期化。このループの i は配列のインデックス
  for (i = 0; i < n; i++) {
    a[i] = i;
  }
  // シャッフル。このループの i はシャッフルの回数。
  // サービスで 2n 回シャフルした。
  for (i = 0; i < 2*n; i++) {
    int x = my_rand(n); // p51
    int y = my_rand(n); // p51
    int temp = a[x];    // a[x] と a[y] を入れ替える。
    a[x] = a[y];
    a[y] = temp;
  }
  return a;
}

/* またもやサービスで main も。
int main(int argc, char* argv[]) {
  int n = 10;
  if (argc==2) {
    n = atoi(argv[1]);
  }
  int* ns = shuffle(n);
  int i;
  for (i=0;i<n;i++) {
    printf("%i %i\n", i, ns[i]);
  }
  return 0;
}
*/

// コンパイルできたら、次で実行。
//
// $ ./a.out (0~9の整数がランダムな順番に)
// $ ./a.out 100 (0~99 の整数がランダムな順番に)
