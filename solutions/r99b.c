#include <stdio.h>
#include <stdlib.h>

int is_prime_ng(int n) {
  int i;
  int nn = n;

  if (n==0 || n==1) {
    return 0;
  } else if (n==2) {
    return 1;
  }
  if (n%2 == 0) {
    return 0;
  }
  for (i=3; i*i<=nn; i+=2) {
    if (n%i == 0) {
      return 0;
    }
  }
  return 1;
}

int is_prime(int n) {
  long int i;
  long int nn = n;

  if (n==0 || n==1) {
    return 0;
  } else if (n==2) {
    return 1;
  }
  if (n%2 == 0) {
    return 0;
  }
  for (i=3; i*i<=nn; i+=2) {
    if (n%i == 0) {
      return 0;
    }
  }
  return 1;
}

int lcm_under_20(void) {
  int primes[] = {2,3,5,7,11,13,17,19,23};
  int i;
  int p;
  int factors[20];

  for (i=0; primes[i]<=20; i++) {
    p = primes[i];
    while (p <= 20) {
      factors[i] = p;
      p *= p;
    }
  }

  int ret = 1;
  for (i--; 0 <= i; i--) {
    ret *= factors[i];
  }
  return ret;
}

void str_reverse(char in[], char out[]){
  int i;
  int j=0;
  for (i=0; in[i]!='\0';i++) {
    ;
  }
  for (i--; 0<=i; i--) {
    out[j]=in[i];
    j++;
  }
  out[j]='\0';
}

void int_to_str(int n, char s[]) {
  int i;
  char out[30];

  for (i=0; 0<n; i++) {
    out[i] = '0' + n % 10;
    n /= 10;
  }
  out[i] = '\0';
  str_reverse(out, s); // 95
}

int str_eql(char s1[], char s2[]) {
  int i;

  for (i=0; s1[i]!='\0'; i++) {
    if (s1[i]!=s2[i]) {
      return 0;
    }
  }
  return s2[i]=='\0';
}

int is_palindrome_number(int n) {
  char s1[30];
  char s2[30];

  int_to_str(n, s1);
  str_reverse(s1,s2);
  return str_eql(s1,s2); // 問題 83
}

int find_palindrome_products_max(void) {
  int x;
  int y;
  int p;
  int max=0;

  for (x=100; x<=999; x++) {
    for (y=100; y<=x; y++) {
      p = x * y;
      if (is_palindrome_number(p)) {
        if (p > max) {
          max = p;
        }
      }
    }
  }
  return max;
}
//600851475143
int even(int n) {
  return n%2==0;
}

// nよりも大きい素数
int next_prime(int n) {
  n++;
  if (even(n)) { // 問題 13
    n++;
  }
  for (; ! is_prime(n); n+=2) {
    ;
  }
  return n;
}

int max_a(int a[], int n) {
  int i;
  int max = a[0];

  for (i=1; i<n; i++) {
    if (a[i] > max) {
      max = a[i];
    }
  }
  return max;
}

int factor_integer_max(long int n) {
  int p = 2;
  int factors[100];
  int i = 0;

  for (;;) {
    if (n % p == 0) {
      factors[i] = p;
      n /= p;
      i++;
      if (n == 1) {
        break;
      }
    }
    p = next_prime(p);
  }
  return max_a(factors, i);
}

int main(int argc, char *argv[]) {
  //printf("%i,%i\n",is_prime_ng(0x7fffffff),is_prime(0x7fffffff));
  //printf("%i\n",lcm_under_20());
  /* char s[20]; */
  /* int_to_str(1234,s); */
  /* printf("%s\n",s); */
  //printf("%i\n",find_palindrome_products_max());
  //printf("%i\n",next_prime(atoi(argv[1])));
  printf("%i\n", factor_integer_max(600851475143));
  return 0;
}
