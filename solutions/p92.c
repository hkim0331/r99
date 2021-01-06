#include <stdio.h>
#include <stdlib.h>

// 授業を聞いていればできるインチキ
/*
int str_to_int(char* s1) {
  return atoi(s1);
}
*/

// 上がふしだらと思うなら、きちんとやる。
// '1' を 1 に変換するには '0' を引けばいい。
int str_to_int(char* s1) {
  int sum = 0;
  int i;
  for (i=0; s1[i]!=0; i++) {
    sum = sum*10 + (s1[i] - '0');
  }
  return sum;
}

int main(int argc, char *argv[]) {
  printf("%i\n", str_to_int(argv[1]));
  return 0;
}
