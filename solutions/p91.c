#include <stdio.h>
#include <stdlib.h>

int str_len(char *s) {
  int i=0;
  for (i=0; s[i] != '\0'; i++) {
    ;
  }
  return i;
}

int is_small(char c) {
  return 'a'<=c && c <= 'z';
}

char* toUpper(char* s) {
  char *s2 = (char*)malloc(sizeof(char)+(str_len(s)+1)); //p79
  int offset='A'-'a';
  int i;
  char c;

  for (i=0; s[i]!='\0'; i++) {
    c = s[i];
    if (is_small(c)) {
      s2[i] = c + offset;
    } else {
      s2[i] = c;
    }
  }
  s2[i] = '\0';
  return s2;
}

/* free() 見せるため main() も
int main(void) {
  char s[] ="I am small letters, ain't I?";
  char* s2 = toUpper(s);
  printf("%s\n", s2);
  free(s2);
  return 0;
}
*/
