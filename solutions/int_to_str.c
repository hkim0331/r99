#include <stdio.h>
#include <stdlib.h>

int str_len(char *s) {
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

char* str_reverse(char *s) {
  int len = str_len(s);
  char* r = (char*)malloc(sizeof(char)*(len + 1));
  int i;

  r[len] = '\0';
  for (i=0; s[i]!='\0'; i++) {
    r[len-1-i] = s[i];
  }
  return r;
}

// まず、整数 n > 0 の時だけを考える。
// n が負の時は外でマイナスかけてから、この関数に持ち込む。
char* pos_to_str(int n) {
  // int は高々 10 桁。11 は '\0' の分。
  char *s =(char *)malloc(sizeof(char)* 11);
  int i= 0;
  int d;
  for (;;) {
    if (n==0) {
      s[i]='\0';
      break;
    }
    d = n %10;
    s[i] = '0'+d;
    i++;
    n /= 10;
  }
  return str_reverse(s);  //p94.
}

// n が 0、プラス、マイナスで場合分けする。
char* int_to_str(int n) {
  // n==0 の時、空文字列が返らないように。
  if (n==0) {
    return "0";
  // プラスだったら上で定義した補助関数で。
  } else if ( 0< n) {
    return pos_to_str(n);
  // マイナスでも丁寧にやればなんでもない。
  } else {
    // マイナス符号 '-' の分長くとる。
    char* r = (char*) malloc(sizeof(char)*12);
    // n をひっくり返してプラスにし、
    // 先頭に '-' コピーしといた文字列にアペンド。
    str_copy("-", r);              // p83.
    str_append(r, pos_to_str(-n)); // p84.
    return r;
  }
}

int main(int argc, char* argv[]) {
  printf("%s\n", int_to_str(atoi(argv[1])));
  return 0;
}
