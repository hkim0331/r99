#include <stdio.h>

// str_eql よりも簡単か？
// n回ループを回るうちに s1[i]!=s2[i]になったら return 0
// 面倒なのは main() に書いた最後のケース。
// 比べようとする文字がないんだからエラーにしたい。少なくとも false.
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

/* これもサービスで main() 込みで。
int main(void) {
  printf("%i==1\n", str_eql_n("abc", "abc",3));
  printf("%i==1\n", str_eql_n("abcdef", "abcxyz",3));
  printf("%i==0\n", str_eql_n("abcdef", "abcxyz",4));
  printf("%i==1\n", str_eql_n("abcdef", "12345",0));
  printf("%i==0\n", str_eql_n("abcdef", "abcdef",10));
  return 0;
}
*/
