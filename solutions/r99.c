#include <stdio.h>
#include <stdlib.h>

void hello_p(int n) {
	int i;

	for (i=0; i<n; i++) {
		printf("hello, robocar!\n");
	}
}

void add_p(void) {
    int n;
    scanf("%i", &n);
    printf("%i + 1 becomes %i\n", n, n+1);
}

void add1_p(int x) {
  printf("%i +1 becomes %i\n",x,x+1);
}

int add1(int x) {
   return x+1;
}

//5
int add2(int x, int y) {
  return x+y;
}

void wa_sa_seki_sho_p(int x, int y) {
  printf("x=%i,y=%i\n", x, y);
  printf("x+y=%i, x-y= %i, x*y= %i, x/y = %i\n", x+y, x-y, x*y, x/y);
}

int max2(int x, int y) {
  if (x > y) {
    return x;
  } else {
    return y;
  }
}

void max_p(int x, int y) {
    printf("max of %i and %i is %i\n", x, y, max2(x,y));
}

int max3(int x, int y, int z) {
  return max2(max2(x, y), z);
}

//10
int max4(int x, int y, int z, int w) {
  return max2(max2(x, y), max2(z, w));
}

void even_p(void) {
  int x;

  scanf("%i", &x);
  if (x%2==0) {
    printf("偶数です。\n");
  } else {
    printf("奇数です。\n");
  }
}

void even1_p(int x) {
  if (x%2==0) {
    printf("偶数です。\n");
  } else {
    printf("奇数です。\n");
  }
}

int even(int x) {
  return x%2==0;
}

void evens_p(int x, int y) {
  if (even(x)) {
    printf("%i\n", x);
  } else if (even(y)) {
    printf("%i\n", y);;
  } else {
    printf("見つかりません。\n");
  }
}

//15
int evens2(int x, int y) {
  if (even(x)) {
    return x;
  } else if (even(y)) {
    return y;
  }
  return -1;
}

int evens3(int x, int y, int z) {
  if (even(x)) {
    return x;
  } else if (even(y)) {
    return y;
  } else if (even(z)) {
    return z;
  } else {
    return -1;
  }
}

void divide_p(void) {
  int x;
  int y;

  scanf("%i", &x);
  scanf("%i", &y);
  if (x%y==0) {
    printf("%i は %i で割り切れる。\n", x, y);
  } else {
    printf("%i は %i で割り切れない。\n", x, y);
  }
}

int divide(int x, int y) {
  return x%y==0;
}

void divisors_p(int n) {
  int i;

  for (i=1; i<=n; i++) {
    if (divide(n,i)) {
      printf("%i ",i);
    }
  }
  printf("\n");
}

//20
int sum_of_divisors(int n) {
  int i;
  int sum = 0;

  for (i=1; i<=n; i++) {
    if (divide(n,i)) {
      sum += i;
    }
  }
  return sum;
}

int is_perfect(int n) {
  return n == sum_of_divisors(n)-n;
}

int is_prime(int n) {
  // return n!=1 && sum_of_divisors(n)==1;
  //
  // 上は手抜き。
  // 手抜きしないでやってみる。この新しい is_prime() は速いよ。
  // 次の log int の理由がわかる受講生は情報応用(hkimura)のレベルを超えている。
  // さらに精進すべし。
  long int i;
  long int nn = n;

  if (n<2) {
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

long int sum_of_primes(void) {
  long int sum=2;
  int i;

  for (i=3;i<=2147483647;i+=2) {
    if (is_prime(i)) {
      sum+=i;
    }
  }
  return sum;
}

void is_prime_p(int n) {
  if (is_prime(n)) {
    printf("%i は素数です。\n",n);
  }
}

void primes_p(void) {
  int i;
  int count = 0;

  for (i=1;i<=10;i++) {
    if (is_prime(i)) {
      count+=1;
    }
  }
  printf("10以下の素数は %i 個あります。\n", count);
}

//25
int prime100(void) {
  int i;
  int count = 0;

  for (i=1;i<=100;i++) {
    if (is_prime(i)) {
      count+=1;
    }
  }
  return count;
}

int prime(int n) {
  int i;
  int count = 0;

  for (i=1;i<=n;i++) {
    if (is_prime(i)) {
      count+=1;
    }
  }
  return count;
}

void zorome_p(int x) {
  if (x/10 == x%10) {
    printf("%i はゾロ目です\n", x);
  }
}

int zorome2(void) {
  int i;
  int count = 0;
  for (i=10;i<100;i++) {
    if (i/10==i%10) {
      count += 1;
    }
  }
  return count;
}

int zoro(int n) {
  int d = n%10;
  for (n /= 10; n>0; n /= 10) {
    if (n%10 != d) {
      return 0;
    }
  }
  return 1;
}

int zorome(int from, int to) {
  int i;
  int count = 0;
  for (i=from; i<=to; i++) {
    if (zoro(i)) {
      count += 1;
    }
  }
  return count;
}

//30
int rev3(int n) {
  int h = n/100;
  int t = (n%100)/10;
  int d = n%10;
  return d*100+t*10+h;
}

int how_many_rev3(void) {
  int i;
  int count = 0;

  for (i=100;i<1000;i++) {
    if (rev3(i)==i) {
      count += 1;
    }
  }
  return count;
}

int max_rev3_and_prime(void) {
  int i;
  int n;

  for (i=100;i<1000;i++) {
    if (rev3(i)==i && is_prime(i)) {
      n = i;
    }
  }
  return n;
}

void sevens_100_p(void) {
  int i;

  for (i=0; i<=100; i += 7) {
    printf("%i\n",i);
  }
}

void sevens_p(int n) {
  int i;

  for (i=0; i<=n; i += 7) {
    printf("%i\n",i);
  }

}

//35
void sevens_between_p(int m, int n) {
  int i;

  for (i=m; i<i+7; i++) {
    if (i%7==0) {
      break;
    }
  }
  for ( ; i<=n; i += 7) {
    printf("%i\n",i);
  }
}

void between_p(int m, int n, int k) {
  int i;

  for (i=m; i<i+k; i++) {
    if (i%k==0) {
      break;
    }
  }
  for ( ; i<=n; i += k) {
    printf("%i\n",i);
  }
}

int square(int n) {
  return n*n;
}

int triple(int n) {
  return n*n*n;
}

int power(int n, int m) {
  if (m==0) {
    return 1;
  } else {
    return n * power(n, m-1);
  }
}

//40
void squares_p(void) {
  int i;

  for (i=1;i<=20;i++) {
    printf("%i の2乗は %i\n", i, square(i));
  }
}

int root(int n) {
  int i;

  for (i=0;square(i)<n;i++) {
    ;
  }
  return i-1;
}

int triangle(int x, int y, int z) {
  return x+y > z && y+z > x && z+x >y;
}

int normal(int x, int y, int z) {
  return square(x) + square(y) == square(z) ||
         square(y) + square(z) == square(x) ||
         square(z) + square(x) == square(y);
}

int fz(int n) {
  if (n%5==0 && n%3==0) {
    return 3;
  } else if (n%5==0) {
    return 2;
  } else if (n%3==0) {
    return 1;
  } else {
    return 0;
  }
}

//45
int number_of_divisors(int n) {
  int i;
  int num = 0;

  for (i=1; i<n; i++) {
    if (divide(n,i)) {
      num +=1;
    }
  }
  return num;
}

int most_divisors10(void) {
  int i;
  int max = 0;

  for (i=1; i<=10; i++) {
    if (number_of_divisors(i)> max) {
      max = i;
    }
  }
  return max;
}

int most_divisors(int n) {
  int i;
  int max = 0;

  for (i=1; i<=n; i++) {
    if (number_of_divisors(i)> max) {
      max = i;
    }
  }
  return max;
}

int sum_of_digits3(int n) {
  int d = n % 10;
  int t = (n/10)%10;
  int h = (n/100);
  return d+t+h;
}

int sum_of_digits(int n) {
  int s;

  for (s=0; n>0; n /= 10) {
    s += n%10;
  }
  return s;
}

int sum(int n, int m) {
  int i;
  int s=0;

  for (i=n;i<=m;i++) {
    s+=i;
  }
  return s;
}

int product(int n, int m) {
  int i;
  int p=1;

  for (i=n;i<=m;i++) {
    p *= i;
  }
  return p;
}

int abs(int n) {
  if (n<0) {
    return -n;
  } else {
    return n;
  }
}

int zero(int n) {
  return n==0;
}

int teenage(int y) {
  return 13<=y && y<20;
}

int f_to_i(float x) {
  int xx = x * 10;

  if (xx%10 < 5) {
    return xx/10;
  } else {
    return xx/10+1;
  }
}

//55
float f_to_f1(float x) {
  return 1.0*f_to_i(x*10)/10;
}

float f_to_f(float x, int n) {
  int pow = power(10,n);
  return 1.0*f_to_i(x*pow)/pow;
}

void rand10_p(void) {
  int i;

  for (i=0;i<10;i++) {
    printf("%li ", random()%10);
  }
  printf("\n");
}

int rand_n(int n) {
  return random()%n;
}

int rand10(void) {
  return random()%20-10;
}

//60
int rand_between(int n, int m) {
  return n + random()%(m-n);
}

float randf(void) {
  return 1.0*(random()%100000)/100000;
}

void randf_p(int n) {
  int i;

  for (i=0; i<n; i++) {
    printf("[%f, %f]\n", randf(),randf());
  }
}

float pi(int n) {
  int i;
  int count = 0;
  float x;
  float y;

  for (i=0; i<n; i++) {
    x = randf();
    y = randf();
    if (x*x +y*y <= 1.0) {
      count ++;
    }
  }
  return (4.0*count)/n;
}

//71
int next_perfect(int n) {
  int i;

  for (i=n+1; ; i++) {
    if (is_perfect(i)) {
      return i;
    }
  }
}

int sum_odds(int n, int m) {
  int i=n;
  int sum=0;

  if (i%2==0) {
    i++;
  }
  for ( ; i<m; i+=2) {
    sum += i;
  }
  return sum;
}

int sum_primes_under(int n) {
  int i;
  int sum=2;
  for (i=3; i<n; i+=2) {
    if (is_prime(i)) {
      sum+=i;
    }
  }
  return sum;
}

int sum_primes_beween(int n, int m) {
  return sum_primes_under(n) - sum_primes_under(m);
}

//75
int factorial(int n) {
  int i;
  int ret=1;

  for (i=1; i<=n; i++) {
    ret *= i;
  }
  return ret;
}

int factorial_overflow(void) {
  int i;

  for (i=0;;i++) {
    if (factorial(i)<0) {
      break;
    }
  }
  return i;
}

int fibo(n) {
  if (n<2) {
    return n;
  } else {
    return fibo(n-1)+fibo(n-2);
  }
}

int fibo_over1000(void) {
  int i;

  for (i=0; ;i++) {
    if (fibo(i)>1000) {
      return i;
    }
  }
}

int fibo_over(int m){
  int i;

  for (i=0; ;i++) {
    if (fibo(i)>m) {
      return i;
    }
  }
}

int sum_of_fibo_between(int n, int m) {
  int from = fibo_over(n);
  int to = fibo_over(m);
  int i;
  int sum=0;

  for (i=from; i<to; i++) {
    sum += fibo(i);
  }
  return sum;
}

//81
int str_len(char s[]) {
  int i;

  for (i=0; s[i]!='\0'; i++) {
    ;
  }
  return i;
}

int count_chars(char s[], char c) {
  int i;
  int n=0;

  for (i=0; s[i]!='\0'; i++) {
    if (s[i]==c) {
      n++;
    }
  }
  return n;
}

int str_eql(char s1[], char s2[]) {
  int i;

  for (i=0; s1[i]!='\0'; i++) {
    if (s2[i]=='\0') {
      return 0;
    } else if (s1[i]!=s2[i]) {
      return 0;
    }
  }
  return s1[i]==s2[i];
}

int str_eql_n(char s1[], char s2[], int n) {
  int i;

  for (i=0; i<n; i++) {
    if (s1[i]=='\0' || s2[i]=='\0') {
      return 0;
    } else if (s1[i]!=s2[i]) {
      return 0;
    }
  }
  return 1;
}

void str_copy(char s1[], char s2[]) {
  int i;

  for (i=0; s1[i]!='\0'; i++) {
    s2[i]=s1[i];
  }
  s2[i]='\0';
}

void str_append(char s1[], char s2[]) {
  int i = str_len(s1);
  int j;

  for (j=0; s2[j]!='\0'; j++) {
    s1[i] = s2[j];
    i++;
  }
  s1[i]='\0';
}

void str_take(char s1[], int n, int m, char s2[]) {
  int i,j;

  j=0;
  for (i=n;i<n+m;i++) {
    s2[j]=s1[i];
    j++;
  }
  s2[j]='\0';
}

int str_search(char s1[], char s2[]) {
  int len1= str_len(s1);
  int len2= str_len(s2);
  char s3[len2 + 1]; // 1 for '\0'
  int i;

  for (i=0; i+len2<len1; i++) {
    str_take(s1,i,len2,s3);
    if (str_eql(s2,s3)) {
      return i;
    }
  }
  return -1;
}

void str_remove(char s1[], int n, int m) {

  int i;

  for (i=n; s1[i]!='\0';i++) {
    s1[i] = s1[i+m];
  }
  s1[i]='\0';
}

//90
void str_remove_str(char s1[], char s2[]) {
  int i;

  i = str_search(s1, s2);
  if (i>0) {
    str_remove(s1, i, str_len(s2));
  }
}

void str_insert(char s1[], int n, char s2[]) {
  int len1 = str_len(s1);
  char s3[len1+1]; // 1 for '\0'

  str_take(s1,n,len1-n, s3);
  s1[n] = '\0';
  str_append(s1,s2);
  str_append(s1,s3);
}
//92
void str_subst(char s1[], char s2[], char s3[]) {
  int found = str_search(s1,s2);
  int len = str_len(s2);

  if (found != -1) {
    str_remove(s1, found, len);
    str_insert(s1, found, s3);
  }
}

void str_reverse(char s1[], char s2[]) {
  int i=str_len(s1)-1; // 1 for '\0'
  int j;

  for (j=0; 0<=i ;j++) {
    s2[j] = s1[i];
    i--;
  }
  s2[j] = '\0';
}

void toUpper(char s1[], char s2[]) {
  int d = 'A'-'a';
  int i;

  for (i=0; s1[i]!='\0'; i++) {
    if ('a'<= s1[i] && s1[i]<='z') {
      s2[i] = s1[i]+d;
    } else {
      s2[i] = s1[i];
    }
  }
}

int str_to_int(char s1[]) {
  int i = 0;
  int n = 0;

  for (i=0; s1[i]!='\0'; i++) {
    n = (n*10 + s1[i]-'0');
    printf("%i\n", n);
  }
  return n;
}

void int_to_str(int n, char s[]) {
  int len = str_len(s);
  char s2[len+1];
  int i=0;

  for (; n>0; n/=10) {
    printf("%i\n",n);
    s2[i] = '0' + n%10;
    i++;
  }
  s2[i]='\0';
  str_reverse(s2,s);
}

//97
void init_randoms_99(int a[], int n) {
    int i;

    for (i=0; i<n; i++) {
        a[i] = rand_between(0,100); // 問題60
    }
}

void sort(int a[], int b[], int n) {
    int i;
    int j;
    int k=0;

    for (i=0; i<100; i++) {
        for (j=0; j<n; j++) {
            if (a[j]==i) {
                b[k] = a[j];
                k++;
            }
        }
    }
}

int is_sorted(int b[], int n) {
    int i;

    for (i=0;i<n-1;i++) {
        if (b[i]>b[i+1]) {
            return 0;
        }
    }
    return 1;
}
int main(void) {
  /* int p = 2147483647; */
  /* printf("%i, %i\n",is_prime(p),is_prime(p-1)); */
  /* printf("%li\n",sum_of_primes()); */
  char s1[20]="abcdef";
  char s2[]="12345";
  printf("%s %s\n",s1,s2);
  str_append(s1,s2);
  printf("%s %s\n",s1,s2);
    /* int a[100]; */
    /* int b[100]; */

    /* init_randoms_99(a, 100); */
    /* sort(a,b,100); */
    /* printf("%i\n",is_sorted(b,100)); */

    //  char x[100] = "123789abc123456789";
    //char y[100] = "abc";

  //str_subst(x, "abc", "012340");
  //printf("%s\n", x);

  //toUpper(y,x);
  /* char x[]="12345"; */
  /* char y[10]; */
  /*   str_reverse(x,y); */
  /*   printf("x:%s, y:%s\n", x, y); */
  //str_insert(x,3,y);
  //  str_remove_str(x,y);
  //printf("%s\n",x);

  //printf("%i\n", str_search(x,y));

  //  str_take(x,3,4,y);
  //  printf("%s\n",y);

  //  printf("%i %i %i\n", str_eql_n("abc", "abc",3), str_eql_n("ab", "abc",3), str_eql_n("abc", "ab",3));
  //printf("%s contains %i %c\n", "apple pinapple", count_chars("apple pinapple",'p'), 'p');
  //printf("%i\n", str_len("1234567"));

  //  printf("pi=%f\n", pi(10000));
//  randf_p(10);
//  inti;
//  for (i=0;i<10;i++) {
//    printf("%f\n",randf());
//  }
//  rand10_p();
//  printf("%f\n", f_to_f(3.14159265,4));
//  printf("%i,%i\n", f_to_i(3.4), f_to_i(3.5));
//  printf("%i\n", product(1,6));
//  printf("%i\n", sum_of_digits(12345));
//  printf("%i\n", sum_of_digits3(345));
//  hello_p(10);
//  add_p();
//  add1_p(10);
//  int x = 10;
//  printf("%i +1 becomes %i\n", x, add1(x));
//  int x=25;
//  int y=13;
//  printf("%i + %i becomes %i\n", x, y, add2(x,y));
 //  wa_sa_seki_sho_p(30,40);
   //    max_p(3,4);
  //  printf("max2(%i, %i) => %i\n",x,y,max2(x,y));
  //  evens_p(33,45);
  //printf("even? %i\n", evens2(x,y));
  //divisors_p(128);
  //printf("is_perfect(28)? %i\n",is_perfect(28));
  /* for (int i=1; i<10; i++) { */
    /*   is_prime_p(i); */
  /* } */
  /* primes_p(); */
  //printf("primes100 retuns %i, prime(100) returns %i\n", prime100(),prime(100));
  /* zorome_p(33); */
  /* zorome_p(34); */
  /* zorome_p(99); */
  /* zorome(1,500); */
  //  printf("rev3(314) returns %i\n",rev3(314));
  //  printf("max_rev3_and_prime() returns %i\n", max_rev3_and_prime());
  //sevens_between_p(100,200);
  //printf("root(2000) is %i\n",root(2000));
  //printf("m10:%i",most_divisors10());
  return 0;
}
