#include <stdio.h>
#include <stdlib.h>

#define PI 3.14

void hello_p(void) {
  puts("hello, robocar!");
}

int add1(int x) {
  return x+1;
}

void add1_p(void) {
  int x;

  scanf("%i", &x);
  printf("%i\n",add1(x));
}

#define PI 3.14
float en(int r) {
  return r*r*PI;
}

//5
void en_p(void) {
  int r;

  scanf("%i", &r);
  printf("%f\n", en(r));
}

int even(int x) {
  return x%2==0;
}

void even_p(void) {
  int n;

  scanf("%i", &n);
  if (even(n)) {
    printf("偶数です\n");
  } else {
    printf("奇数です\n");
  }
}

int add2(int x, int y) {
  return x+y;
}

void add2_p(int x, int y) {
  printf("%i\n",add2(x,y));
}

//10
void wa_sa_seki_sho_p(int x, int y) {
  printf("%i, %i, %i, %i\n", x+y, x-y, x*y, x/y);
}

int divide(int x, int y) {
  return x%y == 0;
}

void divide_p(void) {
  int x;
  int y;

  scanf("%i%i", &x, &y);
  if (divide(x,y)) {
    printf("割り切る");
  } else {
    printf("割り切れない");
  }
}

int abs(int n) {
  if (0<n) {
    return n;
  } else {
    return -n;
  }
}

//15
int square(int n) {
  return n*n;
}

int triple(int n) {
  return n*n*n;
}

// ループで書いたら間違ったい。
int power(int n, int m) {
  if (m==0) {
    return 1;
  } else {
    return n*power(n,m-1);
  }
}

// 13~20
int teenage(int y) {
  return (13<=y && y <=19);
}

int max2(int x, int y) {
  if (x<y) {
    return y;
  } else {
    return x;
  }
}

void max_p(int x, int y) {
  printf("%i\n", max2(x,y));
}

int max3(int x, int y, int z) {
  return max2(x, max2(y,z));
}

int max4(int x, int y, int z, int w) {
  return max2(max2(x,y), max2(z,w));
}

int triangle(int x, int y, int z) {
  return x < y+z && y < z+x && z < x+y;
}

int right_angle(int x, int y, int z) {
  int x2 = x*x;
  int y2 = y*y;
  int z2 = z*y;

  return x2==y2+z2 || y2==z2+x2 || z2 ==x2+y2;
}

int sum(int n, int m) {
  int s=0;
  int i;

  for (i=n; i<=m; i++) {
    s += i;
  }
  return s;
}

int product(int n, int m) {
  int p=1;
  int i;

  for (i=n; i<=m; i++) {
    p *= i;
  }
  return p;
}

int sum_of_digits(int n) {
  int d = 0;

  for (;;) {
    if (n==0) {
      break;
    } else {
      d += n % 10;
      n /= 10;
    }
  }
  return d;
}

int fz(int n) {
  if (n%15 == 0) {
    return 3;
  }  else if (n%5 == 0) {
    return 2;
  } else if (n%3 ==0) {
    return 1;
  } else {
    return 0;
  }
}

void divisors_p(int n) {
  int i;

  for (i=1; i<=n; i++) {
    if (n%i==0) {
      printf("%i ",i);
    }
  }
  printf("\n");
}

int sum_of_divisors(int n){
  int i;
  int s=0;

  for (i=1; i<=n; i++) {
    if (n%i==0) {
      s+=i;
    }
  }
  return s;
}

int is_perfect(int n) {
  return 2*n == sum_of_divisors(n);
}

//31

int num_of_divisors(int n) {
  int c=0;
  int i;

  for (i=1;i<=n;i++) {
    if (n%i==0) {
      c++;
    }
  }
  return c;
}

int most_divisors(int n) {
  int max = 0;
  int max_at = 0;
  int i;

  for (i=1;i<=n;i++) {
    int nod = num_of_divisors(i);
    if (max < nod) {
      max = nod;
      max_at = i;
    }
  }
  return max_at;
}

int is_prime_odd(odd) {
  int n;

  for (n=3; n*n<=odd; n+=2) {
    if (odd % n ==0) {
      return 0;
    }
  }
  return 1;
}

int is_prime(int n) {
  if (n==1) {
    return 0;
  } else if (n==2) {
    return 1;
  } else if (n%2==0) {
    return 0;
  } else {
    return is_prime_odd(n);
  }
}

int primes(int n) {
  int c=0;
  int i;

  for (i=1; i<=n; i++) {
    if (is_prime(i)) {
      c++;
    }
  }
  return c;
}

int is_square(int n) {
  int i;

  for (i=0;i*i<=n;i++) {
    if (i*i==n) {
      return i;
    }
  }
  return 0;
}

int is_cubic(int n) {
  int i;

  for (i=0;i*i*i<=n;i++) {
    if (i*i*i==n) {
      return i;
    }
  }
  return 0;
}

int is_squeare_sum(int n) {
  int i;

  for (i=1; i*i<=n; i++) {
    if (is_square(n - i*i)) {
      return 1;
    }
  }
  return 0;
}


// 37
// char * は 2019-11-20 までの授業ではやってない。
void j_era_aux(char *era, int j) {
  printf("%s %i 年\n", era, j);
}

void j_era(int year)
{
  if (year > 2018) {
    j_era_aux("令和", year-2018);
  } else if (year > 1988) {
    j_era_aux("平成", year-1988);
  } else if (year > 1925) {
    j_era_aux("昭和", year-1925);
  } else {
    printf("long ago\n");
  }
}

// 授業でやった
int leap(int year) {
  if (year%400 == 0) {
    return 1;
  } else if (year%100 == 0) {
    return 0;
  } else if (year%4 == 0) {
    return 1;
  } else {
    return 0;
  }
}

int time_to_int(int hh, int mm, int ss) {
  return hh*3600 + mm*60 +ss;
}

int sec_between(int h1, int m1, int s1, int h2, int m2, int s2){
  int time1 = time_to_int(h1,m1,s1);
  int time2 = time_to_int(h2,m2,s2);

  return time2-time1;
}
int main(void) {

//  hello_p();
//  add1_p();
//  en_p();
//  even_p();
//  divide_p();
//  printf("%i\n",power(2,10));
//  printf("%i, %i, %i\n",is_perfect(6), is_perfect(28),is_perfect(100));
//  printf("%i, %i\n", is_prime(2038074743), is_prime(2038074747));
//  printf("%i\n", primes(10000));
//  printf("%i\n", is_square(237169));
//  printf("%i\n", is_cubic(9663597));
//    printf("%i\n", is_squeare_sum(452));
  j_era(2019);
  j_era(1962);
  j_era(2000);
  return 0;
}
