#include <stdio.h>
#include <stdlib.h>

// 1~20 の最小公倍数を求めることと同値。
// lcm(x,y) = x*y/gcd(x,y) なので、補助関数 gcd() を作る。
// 数学の知識使えば、答えは 2520 * 11 * 13 * 17* 19 * 2 のはず。
int gcd(int x, int y) {
  if (y==0) {
    return x;
  } else {
    return gcd(y, x % y);
  }
}

// 素朴にやると、ここで int がオーバフローする。
// で、答えは誤った18044195 になる。
// フィックスしてみよ。
int lcm(int x, int y) {
  return (x*y)/gcd(x, y);
}

int p106(int n) {
  int ret = 1;
  int i;
  for (i = 1; i <= n; i++) {
    ret = lcm(ret, i);
  }
  return ret;
}

int main(void) {
  for (int i=1; i<=20;i++) {
    printf("%i %i\n", i, p106(i));
  }
  return 0;
}
