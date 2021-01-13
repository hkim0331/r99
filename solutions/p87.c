#include <stdio.h>
#include <stdlib.h>

int str_len(char* s) {
  int i;

  for (i=0; s[i]!='\0'; i++) {
    ;
  }
  return i;
}

void str_copy(char* s1, char* s2) {
  int i;

  for (i=0; s1[i]!='\0'; i++) {
    s2[i] = s1[i];
  }
  s2[i] = '\0'; // don't forget!
}

char* str_append(char* s1, char* s2) {
  int l1   = str_len(s1);          // p79
  int n    = l1 + str_len(s2) + 1; // +1 for '\0'
  char* s3 = (char*)malloc(sizeof(char) * n);

  str_copy(s1, s3);      // 83
  str_copy(s2, s3 + l1); // magick
  return s3;
}
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

// n + m が s1 の長さ以下であることを確認後、
// s1[n + m] から後ろの文字をs1[n]から前方にコピー。
char* str_remove_1(char* s1, int n, int m) {
  if (str_len(s1) < n+m) {
    printf("s1 is too short.\n");
    exit(1);
  }
  // これで膝を打てれば情報応用は A クラス。
  // 配列・文字列は十分に理解している。
  str_copy(s1 + n + m, s1 + n); // p83
  return s1;
}

// s1 を書き換えない安全なバージョン。
// hkimura はこっちが好きかな。安全で。
char* str_remove(char *s1, int n, int m) {
  char* s2=(char* )malloc(sizeof(char)*(str_len(s1) - m + 1));
  return str_append(str_take(s1, 0, n, s2), s1+n+m);
}


int main(void) {
  char s1[]="0123456789";

//  printf("%s\n", str_remove_1(s1, 5, 3));
  printf("%s\n", str_remove(s1, 5, 3));
  printf("%s\n", s1);
  printf("%s\n", str_remove(s1, 0, 3));
  return 0;
}

