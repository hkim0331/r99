#include <stdio.h>
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

// p79 と p82 を利用する。
// s1 の i  番目から s2 の長さ分同じ文字だったら
// true の意味で i (>=0) を返す。
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

/* サービス main()
int main(void) {
  char from[] = "0123456789";

  printf("%i => 0\n", str_search(from, "012"));
  printf("%i => 1\n", str_search(from, "1234"));
  printf("%i => 5\n", str_search(from, "56789"));
  printf("%i => -1\n", str_search(from, "abc"));

  return 0;
}
*/
