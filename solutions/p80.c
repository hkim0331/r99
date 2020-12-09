#include <stdio.h>

// s[i] が '\0' になるまでの間に、
// s[i]==c になる回数を count に数える。
int count_chars(char* s, char c) {
  int i;
  int count=0;

  for (i = 0; s[i] != '\0'; i++) {
    if (s[i]==c) {
      count++;
    }
  }
  return count;
}

int main(void) {
  printf("%i\n", count_chars("hello world!", 'o'));
  return 0;
}
