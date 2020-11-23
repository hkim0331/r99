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

void check1(void) {
  int x[4]= {1,2,3,4};
  int y[4]= {2,3,4,5};
  int z[5];

  plus(4, x, y, z);
  print(5, z); // 3579 がプリントされるはず。
}

void check2(void) {
  int x[]  = {4,5,6};
  int y[]  = {8,9,0};
  int z[4] = {};

  plus(3, x, y, z);
  print(4, z); // 1346 がプリントされるはず。
}

void check3(){
  int x[] = {6,2,3,4,5,6,7,8,9,0,1,2,3};
  int y[] = {5,4,3,2,1,0,5,4,3,2,1,0,5};
  int z[14];

  plus(13, x, y, z);
  print(14, z); // 11666673322228 がプリントされるはず。
}

int main(void) {
  check1();
  check2();
  check3();
  return 0;
}

