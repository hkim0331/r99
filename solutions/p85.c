#include <stdio.h>

// これがあると便利と思う。
// s1 の先頭から n 文字を s2 にコピー。
char* str_copy_n(char*s1, int n, char *s2) {
  int i;
  for (i=0; i<n; i++) {
    s2[i] = s1[i];
  }
  s2[i] = '\0';
  return s2;
}

char* str_take(char* s1, int n, int m, char* s2) {
  return str_copy_n(s1 + n, m, s2);
}

int main(void) {
  char s2[100];

  printf("%s\n", str_take("0123456",1,3,s2));
  return 0;
}
