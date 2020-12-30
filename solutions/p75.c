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


// あると便利な補助関数。
// e が配列 a[] 中に何個あるかを返す。
int find_dupli(int e, int a[], int n) {
  int c=0;
  int i;
  for (i=0; i<n; i++) {
    if (a[i]==e) {
      c++;
    }
  }
  return c;
}

// 配列 c[] 中の最大値はどの index で現れるか？
int find_max_at(int c[], int n) {
  int max = c[0];
  int max_at = 0;
  int i;
  for (i=0; i<n; i++) {
    if (c[i] > max) {
      max = c[i];
      max_at = i;
    }
  }
  return max_at;
}

// 配列の要素は 0~99 であることを利用する。
// 配列 a[] 中に数 i は何回出現するかを c[i] にカウント。
// 定義した補助関数 find_dupli() を利用する。
int find_max_dupli(int a[], int n) {
  int i;
  int c[100] = {};

  for (i=0; i<100; i++) {
    c[i] = find_dupli(i, a, n);
    printf("%i %i\n", i, c[i]);
  }
  return find_max_at(c, 100);
}

/* main() はこんな感じ。
int main(void) {
  int n=200;
  int a[n];

  srandom(getpid());
  init_random(a,n);
  printf("max dupli = %i\n",find_max_dupli(a,n));
  return 0;
}
*/
