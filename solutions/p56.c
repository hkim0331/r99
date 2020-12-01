#include <stdio.h>
#include <stdlib.h>

// ファイルをプログラムで読む例題。
// FILE* 型の変数を用意し、
// fopen(ファイル, モード) でプログラムとファイルを結びつける。
// ファイルはファイルを表す文字列、
// ファイルを読むモードは "r"、ファイルに書くなら"w"。
// printf()/scanf()を使う場所で fprintf()/fscanf() を使う。
// fprintf()/fscanf() に代えて fputs()/fgets() 使うケースも多々ある。

int head(void) {
  char fname[] = "/Users/hkim/Downloads/integers.txt";
  FILE* fp;

  fp = fopen(fname, "r");
  if (fp == NULL) {
    printf("can not open %s\n",fname);
    exit(1);
  }

  int i;
  fscanf(fp, "%i", &i);
  fclose(fp);
  return i;
}

int main(void) {
  printf("%i\n", head());
  return 0;
}
