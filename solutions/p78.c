#include <stdio.h>
#include <stdlib.h>

// 文字列 s が空文字列であるとは、
// sの先頭にNULL('\0') があるってこと。
// is_empty("") が 1 を返せば正しい。
int is_empty(char* s) {
  return s[0]=='\0';
}

int main(int argc, char* argv[]) {
  if (argc!=2) {
    exit(1);
}
  printf("%i\n", is_empty(argv[1]));
  return 0;
}
