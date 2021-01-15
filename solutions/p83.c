#include <stdio.h>

// 文字列s1を文字列s2にコピー。
// 文字列s2は十分な長さがあると仮定。
void str_copy(char* s1, char* s2) {
  int i;

  for (i=0; s1[i]!='\0'; i++) {
    s2[i] = s1[i];
  }
  s2[i] = '\0'; // don't forget!
}
