#include <stdio.h>
#include <stdlib.h>

int str_len(char *s) {
  int i;
  for (i=0; s[i]!='\0'; i++) {
    ;
  }
  return i;
}

// 引数の s を破壊することなく、
// s と同サイズのメモリを malloc() し、
// 文字を逆順に詰め、最後は '\0' でふたをして戻す。
char* str_reverse(char* s) {
  int len = str_len(s); //p79
  printf("%s, %i\n", s, len);
  char* ret = (char*)malloc(sizeof(char) * (len + 1));
  int i;
  for (i=0; s[i] != '\0'; i++) {
    ret[len - 1 - i] = s[i];
  }
  ret[len] = '\0';
  return ret;
}

int main(int argc, char* argv[]) {
  if (argc==2) {
    printf("%s\n", str_reverse(argv[1]));
  }
  return 0;
}
