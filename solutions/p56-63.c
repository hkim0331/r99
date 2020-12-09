#include <stdio.h>
#include <stdlib.h>


//p 56
int head(void) {
  FILE* fp;

  char fname[] = "/Users/hkim/Downloads/integers.txt";

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

// p57
// scanf()で読むのは本来、間違い。正しくは fgets()使うべき。
// ファイルが1行に一つの整数って条件なので。
// Cっぽく if の条件式中で代入と比較をしてみた。
int lines(void) {
  FILE *fp;

  char fname[] = "/Users/hkim/Downloads/integers.txt";

  if ((fp = fopen(fname,"r")) == NULL) {
    printf("%s が読めません。\n", fname);
    exit(1);
  }

  int line;
  int i = 0;
  for (;;) {
    if (fscanf(fp, "%i", &line)==1) {
      i++;
    } else {
      break;
    }
  }
  fclose(fp);
  return i;
}

// p58
// 1行（1整数）読むたび、カウンタアップし、
// カウンタが n に達したらその時読んだ整数を返す。
int nth(int n) {
  FILE *fp;
  char fname[] = "/Users/hkim/Downloads/integers.txt";
  if ((fp = fopen(fname,"r")) == NULL) {
    printf("%s が読めません。\n", fname);
    exit(1);
  }
  int i=0;
  int line;
  for (;;) {
    if (fscanf(fp, "%i", &line)==1) {
      i++;
    }
    if (i==n) {
      return line;
    }
  }
  return -1;
}

int main(void) {
  //printf("%i\n", lines());
  printf("%i\n", nth(10));
  return 0;
}
