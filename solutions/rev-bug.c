#include <stdio.h>
#include <stdlib.h>

int rev(int n) {
  int rev = 0;
  while (n != 0) {
    rev = rev*10 + n %10;
    n = n/10;
  }
  return rev;
}

int main(int argc, char *argv[]) {
  printf("%i\n", rev(atoi(argv[1])));
  return 0;
}
