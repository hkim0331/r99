#include <stdio.h>
float root2(void) {
   float g=2;
   float s=1;
   float m,n;

   for(m=0.1; m>0.000001; m=m/10){
       for(;s<g;s = s + m){
           if (s*s > 2){
               s=s-m;
               break;
           }
       }
   }
   return s;
}

int main(){
    printf("%10.7f\n", root2());
}
