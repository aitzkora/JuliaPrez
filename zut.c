double f(double t[], int n){
   double x = 0;
   int i;
   for (i = 0; i < n; ++i) {
       x += t[i];
   }
   return x;
}
