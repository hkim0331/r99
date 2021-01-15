#include <stdio.h>
#include <stdlib.h>

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

// 引数 s に応じてリターンする文字列を選ぶだけの問題。
// 定義済み関数の str_eql() を利用する。
char* p96(char* s) {
  if (str_eql(s, "コロナ")) {
    return "no thanks";
  } else if (str_eql(s, "ビール")) {
    return "乾杯！";
  } else if (str_eql(s, "単位")) {
    return "よかったね。";
  } else {
    return "なんくるないさ";
  }
}

int main(int argc, char *argv[]) {
  int i;

  for (i=1; i<argc; i++) {
    printf("%s\n", p96(argv[i]));
  }
  return 0;
}
