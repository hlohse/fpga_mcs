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

const double xCentre = -0.75;
const double yCentre = +0.0;
const int    nx      = 512; // 400;
const int    ny      = 320; //400;

const double dxy     = 0.006;


#include <stdio.h>
#include <limits.h>

int main(int argc, char **argv) {

    double cx, cy;
    float rcx, rcy;
    double zx, zy, new_zx;
    unsigned char n;
    int i, j;
    char scmd[1024];

    // The Mandelbrot calculation is to iterate the equation
    // z = z*z + c, where z and c are complex numbers, z is initially
    // zero, and c is the coordinate of the point being tested. If
    // the magnitude of z remains less than 2 for ever, then the point
    // c is in the Mandelbrot set. We write out the number of iterations
    // before the magnitude of z exceeds 2, or UCHAR_MAX, whichever is
    // smaller.

    for (j = 0; j < ny; j++) {
      cy = yCentre + (j - ny/2)*dxy;
      for (i = 0; i < nx; i++) {
	cx = xCentre + (i - nx/2)*dxy;
	zx = 0.0; 
	zy = 0.0; 
	n = 0;
	while ((zx*zx + zy*zy < 4.0) && (n != UCHAR_MAX)) {
	  new_zx = zx*zx - zy*zy + cx;
	  zy = 2.0*zx*zy + cy;
	  zx = new_zx;
	  n++;
	}
	write (1, &n, sizeof(n)); // Write the result to stdout
	// dump float representation of some values
	if (n > 20) {
	  rcx = (float)cx;
	  rcy = (float)cy;
	  //fprintf(stderr,"%f,%x:%f\n",rcx,rcy,n);
	  fprintf(stderr,"%8.8x %8.8x:%x\n",*((unsigned int*)&rcx),*((unsigned int*)&rcy),n);
	}
      }
    }

    fprintf (stderr, "To process the image: convert -depth 8 -size %dx%d gray:output out.jpg\n",
	     nx, ny);
    fprintf(stderr, "UCHAR max: %d\n",UCHAR_MAX);
    sprintf (scmd, "convert -depth 8 -size %dx%d gray:%s.out %s.jpg\n", nx, ny, argv[0],argv[0]);
    fprintf(stderr,"Command: %s\n",scmd);
    system(scmd);
    return 0;
}
 
/*
2.4 Coloring the image

How do we get those fancy colors around the set?

In fact, there are many ways of getting colors outside (and even inside) the set. 
If you have used fractal drawing programs you have probably seen more than one way of coloring.

The classical way and also perhaps the most useful way of coloring the exterior of the set 
is to use the value of 'n' after the inner loop has ended. That is, using the number of 
iterations that was needed for Z to get larger than 2.

In practice, after the inner loop has ended (the one with n being the loop index) we get 
a value for n that is between 0 and the maximum number of iterations. If n is the maximum 
number of iterations then we know that Z did not get larger than 2 and the current c is 
(most probably) part of the set and we can color that with black (or whatever color we want).

If, however, n is smaller than the maximum number of iterations then we know that this c does 
not belong to the set and then we can map the value of n to a color and draw the point with that color.  

The colors are not only visually appealing, but they also give us a lot of extra information 
that didn't show up in the colorless version. The shapes formed by the colors are not coincidence, 
but they are closely related to the set itself.

The Mandelbrot set has the property that for a value which is close to the border of the set 
it will take longer (that is, more iterations) to escape to infinity than for a value which is 
farther away from the border of the set. This means that our colors are actually saying to 
us where the border of the set is: The brighter the color, the closer the border of the set is.

This is very useful. Looking at the colors we can see where the "hidden" part of the set is 
(although it's not really hidden, it's so small that the resolution of the image can't show it). 
That is, the colors bring up the shape of the set a lot more clearly.

The importance of the colors become more clear when we zoom into the set (that is, we 
calculate a part of the set with higher resolution). For example:

Mandel image 4

Without the colors we would get just few black pixels here and there which don't say 
anything to us. The colors, however, show us where the border of the set is.

You can easily experiment with other coloring methods (such as coloring according to 
the distance of the last value of Z, or only the real or the imaginary part of this value, and so on). 
Very interesting images can be achieved this way. However, those are seldom so useful as the 
classical way (but they can have a strong artistic meaning). 
*/
