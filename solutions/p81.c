//文字列 s1 と文字列 s2 が等しいかどうかを判定する関数 int str_eql(char* s1, char* s2).
#include <stdio.h>
#include <stdlib.h>

// s1 と s2、先に '\0' が見つかるまでループ、
// ループ中、s1[i] != s2[i] があったら false。
// どっちかが s*[i]=='\0' でループを抜けたら、
// もう片方も s#[i]=='\0' であれば true。
int str_eql(char* s1, char* s2) {
  int i;

  for (i=0; s1[i] != '\0' || (s2[i] != '\0'); i++) {
    if (s1[i] != s2[i]) {
      return 0;
    }
  }
  return s1[i]==s2[i];
}

int main(void) {
  char s1[100];
  char s2[100];

  for (;;) {
    scanf("%s", s1);
    scanf("%s", s2);
    printf("%i\n", str_eql(s1,s2));
  }
  return 0;
}
