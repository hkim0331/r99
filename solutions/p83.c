#include <stdio.h>

// p81.
int str_eql(char* s1, char* s2) {
  int i;

  for (i=0; (s1[i] != '\0') || (s2[i] != '\0'); i++) {
    if (s1[i] != s2[i]) {
      return 0;
    }
  }
  return s1[i]==s2[i];
}

// 文字列s1を文字列s2にコピー。
// 文字列s2は十分な長さがあると仮定。
void str_copy(char* s1, char* s2) {
  int i;

  for (i=0; s1[i]!='\0'; i++) {
    s2[i] = s1[i];
  }
  s2[i] = '\0'; // don't forget!
}

/* またまたサービス
int main(void) {
  char s1[] = "短い";
  char s2[] = "s2がs1よりも長いとき大丈夫";

  printf("%i\n", str_eql(s1,s2)); // 0
  str_copy(s1, s2);
  printf("%i\n", str_eql(s1,s2)); // 1
  printf("%s\n", s2);             // "短い" をプリント。
  return 0;
}
*/
