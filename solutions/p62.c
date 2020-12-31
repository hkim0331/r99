#include <stdio.h>

// fscanf()だと途中に空白があるとそこで読み込みが止まるので、
// fgets()を使う。授業資料 week-10 「ファイル」の下の方。
void cat(char* fname) {
  FILE* fp = fopen(fname, "r");
  char line[256];
  char* ret;
  for (;;) {
    ret = fgets(line, 256, fp);
    if (ret==NULL) {
      break;
    }
    // fgets() は "\n" まで line に読み込むので、
    // printf() 中で "\n" すると空行になってしまう。
    printf("%s", line);
  }
  fclose(fp);
}


// 前問 cat() ができてれば楽。
// 行を printf() する際に、行番号を示す整数をプリント。
// もちろん、整数はプリントする前か後に ++ する。
void n_cat(char* fname) {
  FILE* fp = fopen(fname, "r");
  char line[256];
  char* ret;
  int i = 1;
  for (;;) {
    ret = fgets(line, 256, fp);
    if (ret==NULL) {
      break;
    }
    // %03i は、3桁の幅をとり、12 を 012 のように印字する。
    printf("%03i: %s", i, line);
    i++;
  }
  fclose(fp);
}

int main(void) {
  n_cat("p62.c");
  return 0;
}
