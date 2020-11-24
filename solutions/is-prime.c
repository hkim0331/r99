int is_prime(int n) {
  if (n<3) {
    return n==2;
  }
  if (n%2==0) {
    return 0;
  }
  int i;
  for (i=3; i*i<=n; i+=2) {
    if (n%i==0) {
      return 0;
    }
  }
  return 1;
}
