#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char *reverse(char *s) {
  int i;
  int len = strlen(s);
  char* ret;

  ret = malloc(sizeof(char)*len);
  len--;
  for (i=0; i<=len; i++,len--) {
    *(ret + i) = s[len];
  }
  *(ret + i)='\0';
  return ret;
}

char *num_to_s(int n) {
  static char ret[20];
  int i;

  for (i=0; n!=0; i++,n /=10) {
    ret[i] = n%10+'0';
  }
  ret[i]='\0';
  printf("num_to_s: %s\n", reverse(ret));
  return reverse(ret);
}

int p(char *s) {
  printf("%s:%s\n",s,reverse(s));
  return strcmp(s, reverse(s))==0;
}

void palindrome6(void) {
  int x;
  int y;

  for (x=999; 0<x; x--) {
    for (y=999; x<=y; y--) {
      if (p(num_to_s(x*y))) {
        printf("%i * %i = %i\n",x,y,x*y);
        return;
      }
    }
  }
}

int main(void) {
  palindrome6();
  return 0;
}
