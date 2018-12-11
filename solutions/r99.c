#include <stdio.h>
#include <stdlib.h>

void hello_p(void) {
  printf("hello, robocar!\n");
}

void hellos_p(int n) {
  int i;

  for (i = 0; i < n; i++) {
    printf("hello, robocar!\n");
  }
}

void add1_p(void) {
  int n;

  scanf("%i", &n);
  printf("%i\n",n+1);
}

int add1(int x) {
  return x + 1;
}

void en_p(void) {
  float r;

  scanf("%f", &r);
  printf("%f\n", r*r*3.14);
}

//7
void even_p(void) {
  int n;

  scanf("%i", &n);
  // 真似すんな！
  if (n % 2) {
    printf("奇数です\n");
  } else {
    printf("偶数です\n");
  }
}

//8
int even(int x) {
  return x % 2 == 0;
}

//9
void add2_p(int x, int y) {
  printf("%i+%i=%i\n", x, y, x + y);
}

//10
int add2(int x, int y) {
  return x + y;
}

//11
void wa_sa_seki_sho_p(int x, int y) {
  printf("%i + %i = %i\n", x, y, x + y);
  printf("%i - %i = %i\n", x, y, x - y);
  printf("%i * %i = %i\n", x, y, x * y);
  printf("%i / %i = %i\n", x, y, x / y);
}

//12
void max_p(int x, int y) {
  int larger;
  if (x > y) {
    larger = x;
  } else {
    larger = y;
  }
  printf("%i と %i, 大きいのは %i ざんす。\n", x, y, larger);
}

//13
int max2(int x, int y) {
  if (x > y) {
    return x;
  } else {
    return y;
  }
}

//14
int max3(int x, int y, int z) {
  return max2(x, max2(y, z));
}

//15
int max4(int x, int y, int z, int w) {
  return max2(x, max3(y, z, w));
}

//16
void divide_p(void) {
  int x;
  int y;

  scanf("%i%i", &x, &y);
  if (x % y ==0) {
    printf("割り切る\n");
  } else {
    printf("割り切れない\n");
  }
}

//17
int divide(int x, int y) {
  return x % y == 0;
}

//18
void sevens_under_1000_p(void) {
  int n;

  for (n = 0; n < 1001; n += 7) {
    printf("%i ", n);
  }
  printf("\n");
}

void sevens_under_p(int n) {
  int i;
  for (i = 0; i <= n; i += 7) {
    printf("%i ", n);
  }
  printf("\n");
}

//20
void sevens_between_p(int m, int n) {
  int i;
  for (i = m; i<=n; i++) {
    if (i % 7 == 0) {
      printf("%i ", i);
    }
  }
  printf("\n");
}

//28
int is_square(int n) {
  int i;
  for (i=0; i*i<n; i++) {
    ;
  }
  return i*i==n;
}

int is_cubic(int n) {
  int i;
  for (i=0; i*i*i<n; i++) {
    ;
  }
  return i*i*i==n;
}

int is_square_sum(int n) {
  int i;
  int j;

  for (i = 1; i*i <= n; i++) {
    for (j = 1; j*j <= n-i*i; j++) {
      if (j*j == n-i*i) {
        return 1;
      }
    }
  }
  return 0;
}


int main(void) {
  printf("%i\n", is_cubic(9663597));
  //even_p();
  //printf("%i\n", is_square_sum(452));
  //printf("%i\n", is_square_sum(453));
  //en_p();
  //add1_p();
  //hellos_p(10);
  //  hello_p();
  return 0;
}

