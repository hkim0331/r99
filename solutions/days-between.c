#include <stdio.h>
#include <stdlib.h>

// p38
int leap(int year) {
  if (year%400 == 0) {
    return 1;
  }
  if (year%100 == 0) {
    return 0;
  }
  if (year%4 ==0) {
    return 1;
  }
  return 0;
}

// p41
int days(int mm, int dd) {
  int month[] = {0,31,28,31,30,31,30,31,31,30,31,30,31};
  int days    = 0;

  int i;
  for (i=1; i<mm; i++) {
    days += month[i];
  }
  return days + dd;
}

// y1-1-1 から y2-m2-d2 までの日数から、
// y1-1-1 から y1-m1-d1 までの日数を引く。

// 西暦y年の日数を返す補助関数。
int days_year(int y) {
  if (leap(y)) {
    return 366;
  } else {
    return 365;
  }
}

// y0-1-1 からの日数を返す補助関数。
int days_from(int y0, int yy, int mm, int dd) {
  int d= 0;
  int y;
  for (y=y0; y<yy; y++) {
    d += days_year(y);
  }
  return d + days(mm, dd);
}

// スタートが閏年で 2/29 以前の時、+1 する。
// 終わりが閏年で 2/29 以降時、+1 する。
int days_between(int y1, int m1, int d1, int y2, int m2, int d2) {
  int d = days_from(y1, y2, m2, d2) - days_from(y1, y1, m1, d1);
  int d229 = days(2,29);
  if (leap(y1) && days(m1,d1)<=d229) {
    d+=1;
  }
  if (leap(y2) && days(m2,d2)>d229) {
    d+=1;
  }
  return d;
}

int main(int argc, char* argv[]) {
  printf("%i\n",
         days_between(atoi(argv[1]),
                      atoi(argv[2]),
                      atoi(argv[3]),
                      atoi(argv[4]),
                      atoi(argv[5]),
                      atoi(argv[6])));
  return 0;
}
