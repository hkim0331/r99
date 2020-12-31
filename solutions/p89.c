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
  int i;
  int j;

  // s1 の '\0' まで i を進める。
  for (i=0; s1[i]!='\0'; i++) {
    ;
  }
  // s2 の '\0' まで s1 にコピー。
  for (j=0; s2[j]!='\0'; j++) {
    s1[i+j] = s2[j];
  }
  s1[i+j] = '\0'; // don't forget!
  return s1;
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

char * str_insert(char *s1, int n, char *s2) {
  int l1 = str_len(s1);    // p79
  int l2 = str_len(s2);    // p79
  char* ret = (char* )malloc(sizeof(char) * (l1 + l2 + 1));
  char* tmp = (char* )malloc(sizeof(char) * (l1 - n + 1));

  
int main(void) {
  printf("%s\n", str_insert("012345", 3, "abc"));
  return 0;
}
