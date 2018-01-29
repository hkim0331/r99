#include <stdio.h>
#include <stdlib.h>

// リスト構造体を定義
struct mem {
  int value;
  struct mem * next;
};

// n をリスト m の先頭に挿入
struct mem * cons(int n, struct mem *m) {
  struct mem * mp;

  mp = (struct mem *)malloc(sizeof(struct mem));
  mp->value=n;
  mp->next=m;
  return mp;
}

// n は リスト m に含まれているか？
int can_find(int n, struct mem *m) {
  while (m->next != NULL) {
    if (m->value==n) {
      return 1;
    } else {
      m = m->next;
    }
  }
  return 0;
}

// 各桁の数を2乗して総和する
int sum_of_sq_digits(int n) {
  int ret = 0;
  int d;

  for ( ;n!=0;n /= 10) {
    d = n%10;
    ret += d*d;
  }
  return ret;
}

/*
void print(struct mem * m) {
  for (;;)  {
    printf("%i,",m->value);
    m = m->next;
    if (m==NULL) {
      break;
    }
  }
  printf("\n");
}
*/

// free?
int happy(int n, struct mem * m) {
  for (;;) {
    if (n==1) {
      return 1;
    }
    n = sum_of_sq_digits(n);
    if (can_find(n, m)) {
      return 0;
    } else {
      m = cons(n, m);
    }
  }
}

// リスト mem の最後は -1 でマーク
int main(int argc, char *argv[]) {
  int i;
  struct mem memory;
  memory.next = NULL;

  if (argc==1) {
    printf("usage: %s num\n",argv[0]);
    printf("find happy numbers from 1 to num.\n");
    exit(1);
  }
  for (i=1;i<atoi(argv[1]);i++) {
    if (happy(i, &memory)) {
      printf("%i ",i);
    }
  }
  printf("\n");
  return 0;
}
