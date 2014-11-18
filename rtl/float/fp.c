main(){
  int i;
  float r = 2.5;
  unsigned short *p = (unsigned short*)&r;
  printf("Float size: %d\n",sizeof(r));
  for (i=0;i<10;i++, r -= .5)
    printf("%d: \t%f \t=> %8.8x\n",i,r,*((unsigned int*)&r));
  
}
