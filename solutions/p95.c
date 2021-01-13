#include <stdio.h>
#include <stdlib.h>

//p79
int str_len(char* s) {
  int i;
  for (i = 0; s[i] != '\0'; i++) {
    ;
  }
  return i;
}

// UTF-8 を前提とする。日本語 1 文字は 3 バイト。
// 関数内部で malloc() した配列に 3 バイトずつ、順序を変えてコピーする。

// これがあると便利。
// s1 から s2 へ3バイトコピーする。
void cpy3(char* s1, char *s2) {
  s2[0] = s1[0];
  s2[1] = s1[1];
  s2[2] = s1[2];
}

char * jstr_reverse(char* s1) {
  int len  = str_len(s1);  // p79
  char* s2 = (char* )malloc(sizeof(char)*(len + 1));
  s2[len]  = '\0';
  int i;

  for (i=0; i<len; i+=3) {
    cpy3(s1 + i, s2 + len - 3 - i);
  }
  return s2;
}

int main(int argc, char* argv[]) {
  if (argc==2) {
    printf("%s\n", jstr_reverse(argv[1]));
  } else {
    printf("usage: ./a.out 日本語で文字列\n");
  }
  return 0;
}