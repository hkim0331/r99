#include <stdio.h>
#include <stdlib.h>

// p78 
int is_empty(char* s) {
  return s[0]=='\0';
}

// p79
int str_len(char* s) {
  int i;

  for (i=0; s[i]!='\0'; i++) {
    ;
  }
  return i;
}

// p81
int str_eql(char* s1, char* s2) {
  int i;

  for (i=0; (s1[i] != '\0') && (s2[i] != '\0'); i++) {
    if (s1[i] != s2[i]) {
      return 0;
    }
  }
  return s1[i]==s2[i];
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

// p83, s1 -> s2
void str_copy(char* s1, char* s2) {
  int i;

  for (i=0; s1[i]!='\0'; i++) {
    s2[i] = s1[i];
  }
  s2[i] = '\0'; // don't forget!
}

// p84
char* str_append(char* s1, char* s2) {
  int l1   = str_len(s1);          // p79
  int n    = l1 + str_len(s2) + 1; // +1 for '\0'
  char* s3 = (char*)malloc(sizeof(char) * n);

  str_copy(s1, s3);      // 83
  str_copy(s2, s3 + l1); // magick
  return s3;
}

// p85
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
  if (str_len(s1) < n + m) {
    printf("s1 is too short.\n");
    exit(1);
  }
  str_copy(s1 + n + m, s1 + n); // p83
  return s1;
}

// p88
char* str_remove_str(char* s1, char *s2) {
  int n = str_search(s1,s2); // p86

  if (n>=0) { // found!
    return str_remove(s1, n, str_len(s2)); // p79
  } else {
    return s1;
  }
}

// 89
char * str_insert(char *s1, int n, char *s2) {
  int l1 = str_len(s1);    // p79
  int l2 = str_len(s2);    // p79
  char* ret = (char* )malloc(sizeof(char) * (l1 + l2 + 1));
  char* tmp = (char* )malloc(sizeof(char) * (l1 - n + 1));

  //BUG FIXED
  str_take(s1, 0, n, ret);  // p85 
  //BUG FIXED
  str_copy(s1 + n, tmp);     // p83
  return str_append(str_append(ret, s2), tmp); // p84
}

char* str_subst(char* s1, char* s2, char* s3) {
  int n = str_search(s1, s2);
  if (n == -1) {
    return s1;
  }
  return str_insert(str_remove(s1, n, str_len(s2)), n, s3);
 }

int main(int argc, char* argv []) {
  char s[100] = "The long and winding road 123 123 123.";

  printf("%s\n", str_subst(s, "nothing", "changes"));
  printf("%s\n", str_subst(s, "The long", "The most shortest"));
  printf("s:%s\n", s);
  printf("%s\n", str_subst(s, "winding", "straight"));   
  printf("%s\n", str_subst(s, "123", "456"));   

  return 0;
}