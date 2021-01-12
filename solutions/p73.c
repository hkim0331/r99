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


// 補助関数：サイズ n の配列 a[] 中に x が見つかるか？
int find_one(int a[], int n, int x) {
  int i;
  for (i=0; i<n; i++) {
    if (a[i] == x) {
      return 1;
    }
  }
  return 0;
}

// 0 <= i < 100 の i が配列 a[] 中に見つかるか？
// ループが二重になりそうな時は別関数がいい。
void find_not(int a[], int n) {
  int i;
  for (i=0; i<100; i++) {
    if (! find_one(a, n, i)) {
      printf("%i ", i);
    }
  }
  printf("\n");
}


void p74(int n) {
  int a[n];
  init_random(a,n);
  find_not(a, n);
}

/* サービスで main もコメントで提出。
int main(void) {
  srandom(getpid());
  p74(90);
  return 0;
}
*/
