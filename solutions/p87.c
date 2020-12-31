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

// n + m が s1 の長さ以下であることを確認後、
// s1[n + m] から後ろの文字をs1[n]から前方にコピー。
char *str_remove(char* s1, int n, int m) {
  if (str_len(s1) < n+m) {
    printf("s1 is too short.\n");
    exit(1);
  }

  // これで膝を打てれば情報応用は A クラス。
  // 配列・文字列は十分に理解している。
  str_copy(s1 + n + m, s1 + n); // p83
  return s1;

  /* 普通はこっちか。
  int i = n;
  int j = n + m;
  for (;;) {
    s1[i] = s1[j];
    if (s1[i] == '\0') {
      return s1;
    }
    i++;
    j++;
  }
  */
}

/* またもや main() つきで。
int main(void) {
  char s1[]="0123456789";

  printf("%s\n", str_remove(s1, 5, 3));
  return 0;
}
*/
