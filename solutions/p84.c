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


// s1 の'\0' の場所から s2 をコピーする。
// s1 に十分な長さがないとエラーになる。
char* str_append_1(char* s1, char* s2) {
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

// s1 を書き換えるではなく、新たな文字列作るのバージョン。
// s1 が短くてもアペンドできる（だって新たな文字列作るんだから）。
// str_len(s1) は magick の場所で使うので変数 l1 にとっておく。
char* str_append(char* s1, char* s2) {
  int l1   = str_len(s1);          // p79
  int n    = l1 + str_len(s2) + 1; // +1 for '\0'
  char* s3 = (char*)malloc(sizeof(char) * n);

  str_copy(s1, s3);      // 83
  str_copy(s2, s3 + l1); // magick
  return s3;
}
// もう寝るぞ。
/*
int main(void) {
  char s1[] = "abc";
  char s2[]   = "def. long string after s1. ";
  printf("%s\n", str_append(s1, s2));
  printf("%s\n", str_append(s2, s1));
  printf("%s\n", str_append(str_append(s1,s2),"are you OK?"));
  return 0;
}
*/
