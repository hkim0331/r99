#include <stdio.h>
#include <stdlib.h>

// 矩形積分と台形積分を比較してみるか。
// 本当ならば、関数引数でプログラムしたいが、
// 授業してない。わかったフリせんでいこ。

// 被積分関数
double f(double x) {
  return 4.0/(1+x*x);
}

// 矩形積分
double rectangle(double dt) {
  double s = 0.0;
  double x;

  for (x = 0.0; x <= 1.0 - dt; x += dt) {
    s += f(x)*dt; // ここで dt をかけなくても。。。
  }
  return s;
}

// 台形積分、ほとんど矩形積分と同じ。
double trapzoid(double dt) {
  double s = 0.0;
  double x;

  for (x=0.0; x<=1.0-dt; x+=dt) {
    s += (f(x)+f(x+dt))*dt/2; // (上底+下底)*高さ/2
  }
  return s;
}

/*
int main(int argc, char* argv[]) {
  if (argc!=2) {
    printf("usage: a.out <n>\n");
    return 1;
  }
  double dt = 1.0/atoi(argv[1]);
  printf("pi=%lf\n",rectangle(dt));
  printf("pi=%lf\n",trapzoid(dt));
  return 0;
}
*/

// コンパイル実行はこのように。
// $ cc p107.c && ./a.out 1000000
// pi=3.141592
// pi=3.141591


