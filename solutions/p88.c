#include <stdio.h>
#include <stdlib.h>

// p79
int str_len(char* s) {
  int i;

  for (i=0; s[i]!='\0'; i++) {
    ;
  }
  return i;
}

// p82
int str_eql_n(char* s1, char* s2, int n) {
  int i;

  for (i=0; i<n; i++) {
    if (s1[i]!=s2[i]) {
      return 0;
    }
    if (s1[i]=='\0' || s2[i]=='\0') {
      return 0;
    }
  }
  return 1;
}

// p83
void str_copy(char* s1, char* s2) {
  int i;

  for (i=0; s1[i]!='\0'; i++) {
    s2[i] = s1[i];
  }
  s2[i] = '\0'; // don't forget!
}

// p86
int str_search(char* s1, char* s2) {
  int len1 = str_len(s1); // p79
  int len2 = str_len(s2); //
  int i;

  // ループが突き抜けないように。
  for (i=0; i + len2 <= len1; i++) {
    // ここがキモ。
    if (str_eql_n(s1 + i, s2, len2)) { // p82
      return i;
    }
  }
  return -1;
}

// p87
char* str_remove(char* s1, int n, int m) {
  if (str_len(s1) < n+m) {
    printf("s1 is too short.\n");
    exit(1);
  }

  // これで膝を打てれば情報応用は A クラス。
  // 配列・文字列は十分に理解している。
  str_copy(s1 + n + m, s1 + n); // p83
  return s1;
}

// 定義済み関数を活用しよう。
char* str_remove_str(char* s1, char *s2) {
  int n = str_search(s1,s2); // p86

  if (n>=0) { // found!
    return str_remove(s1, n, str_len(s2)); // p79
  } else {
    return s1;
  }
}

int main(void) {
  char from[] = "0123456789";

  printf("%s\n",str_remove_str(from,"456"));
  printf("%s\n",str_remove_str(from,"012"));
  return 0;
}
