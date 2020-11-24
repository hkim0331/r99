#include <stdio.h>

void scan(int n, int a[]) {
  int i;

  for (i = 0; i < n; i++) {
    scanf("%i", &a[n]);
  }
}

void reverse(int n, int a[]) {
  int i;
  int j = n-1;
  int temp;

  for (i = 0; i < j; i++) {
    temp = a[j];
    a[j] = a[i];
    a[i] = temp;
    j--;
  }
}

void plus(int n, int a[], int b[], int c[]) {
  int i;
  int s;
  int k = 0; // 繰り上がりに備えて

  reverse(n, a);
  reverse(n, b);
  for (i = 0; i < n; i++) {
    s = a[i] + b[i] + k;
    c[i] = s%10;
    k = s/10;
  }
  c[i] = k;
  reverse(n+1, c);
}

void print(int n, int a[]) {
  int i;

  if (a[0]!=0) {
    printf("%i", a[0]);
  }
  for (i = 1; i < n; i++) {
    printf("%i", a[i]);
  }
  printf("\n");
}

void check(int n, int x[], int y[]) {
  int z[n+1];

  plus(n, x, y, z);
  print(n+1, z); // 357 がプリントされるはず。
}


int main(void) {
  int a[]= {1,2,3};
  int b[]= {2,3,4};
  check(3, a, b);

  int c[]  = {4,5,6};
  int d[]  = {8,9,0};
  check(3, c, d);//1346

  int x[] = {6,2,3,4,5,6,7,8,9,0,1,2,3};
  int y[] = {5,4,3,2,1,0,5,4,3,2,1,0,5};
  check(13, x, y); // 11666673322228 がプリントされるはず。

  return 0;
}

