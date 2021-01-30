#include <stdio.h>
#include <stdlib.h>

// p79
int str_len(char* s) {
  int i;

  for (i=0; s[i]!='\0'; i++) {
    ;
  }
  return i;
}

// p81
int str_eql(char* s1, char* s2) {
  int i;

  for (i=0; ; i++) {
    if (s1[i] != s2[i]) {
      return 0;
    }
    if (s1[i]=='\0' || s2[i]=='\0') {
      break;
    }
  }
  return s1[i] == s2[i];
}

// p83
void str_copy(char* s1, char* s2) {
  int i;

  for (i=0; s1[i]!='\0'; i++) {
    s2[i] = s1[i];
  }
  s2[i] = '\0'; // don't forget!
}


// p84
char* str_append(char* s1, char* s2) {
  int l1   = str_len(s1);          // p79
  int n    = l1 + str_len(s2) + 1; // +1 for '\0'
  char* s3 = (char*)malloc(sizeof(char) * n);

  str_copy(s1, s3);      // 83
  str_copy(s2, s3 + l1); // magick
  return s3;
}

// p94
char* str_reverse(char* s) {
  int len = str_len(s); //p79
  char* ret = (char*)malloc(sizeof(char) * (len + 1));
  int i;

  for (i=0; s[i] != '\0'; i++) {
    ret[len - 1 - i] = s[i];
  }
  ret[len] = '\0';
  return ret;
}

// p93
char* pos_to_str(int n) {
  char *s =(char *)malloc(sizeof(char)* 11);
  int i= 0;
  int d;
  for (;;) {
    if (n==0) {
      s[i]='\0';
      break;
    }
    d = n %10;
    s[i] = '0'+d;
    i++;
    n /= 10;
  }
  return str_reverse(s);  //p94.
}

char* int_to_str(int n) {
  if (n==0) {
    return "0";
  } else if ( 0< n) {
    return pos_to_str(n);
  } else {
    char* r = (char*) malloc(sizeof(char)*12);
    str_copy("-", r);              // p83.
    str_append(r, pos_to_str(-n)); // p84.
    return r;
  }
}

// p108
// まず、補助関数、整数 n は回文数か？を定義する。
int is_palindrome_number(int n) {
  char* s = int_to_str(n); // p93
  return str_eql(s, str_reverse(s)); // p81, p94
}

// from <= i,j < to を満たす i,j で、
// i*j が回文数となるものの最大値を返す。
int p108(int from, int to) {
  int i, j, ij;
  int max = 0;

  for (i = from; i < to; i++) {
    for (j = from; j < i; j++) {
      ij = i*j;
      if (is_palindrome_number(ij)) {
        // printf("%i*%i=%i\n", i, j, ij);
        if (max < ij) {
          max = ij;
        }
      }
    }
  }
  return max;
}

/* サービスで main( ) も見せようかな。
int main(int argc, char* argv[]) {
  if (argc == 3) {
    printf("%i\n", p108(atoi(argv[1]), atoi(argv[2])));
    return 0;
  } else { // error
    printf("usage: a.out <from> <to>\n");
    return 1;
  }
}
*/

// コンパイルできたら、実行は、
//
// $ a.out 10 100
// $ a.out 100 1000
//
// のように。
