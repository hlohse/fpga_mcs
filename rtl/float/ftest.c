/*
  A program to generate an image of the Mandelbrot set. 

  Usage: ./mandelbrot > output
         where "output" will be a binary image, 1 byte per pixel
         The program will print instructions on stderr as to how to
         process the output to produce a JPG file.

  Michael Ashley / UNSW / 13-Mar-2003
*/

/*
const double xCentre = -0.75;
const double yCentre = +0.0;
const int    nx      = 640; // 400;
const int    ny      = 320; //400;

const double dxy     = 0.005;
*/


#include <stdio.h>
#include <limits.h>

// this is to test mandelbrot calculations

// input: float cx, cy as hex string. output cx*cy hex string

int main(int argc, char **argv) {

    double cx, cy;
    double zx, zy, new_zx;
    unsigned char n;
    int i, j;
    char scmd[1024];

    zx = 0.0; 
    zy = 0.0; 
    n = 0;
    while ((zx*zx + zy*zy < 4.0) && (n != UCHAR_MAX)) {
      new_zx = zx*zx - zy*zy + cx;
      zy = 2.0*zx*zy + cy;
      zx = new_zx;
      n++;
    }
  //fprintf(stderr,"%f,%x:%f\n",cx,cy,n);
    fprintf(stderr,"%8.8x %8.8x:%x\n",*((unsigned int*)&cx),*((unsigned int*)&cy),n);
    return 0;
}
 
