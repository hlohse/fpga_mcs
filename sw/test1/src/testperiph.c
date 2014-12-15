/*
 *
 * Xilinx, Inc.
 * XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS" AS A 
 * COURTESY TO YOU.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
 * ONE POSSIBLE   IMPLEMENTATION OF THIS FEATURE, APPLICATION OR 
 * STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS IMPLEMENTATION 
 * IS FREE FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE RESPONSIBLE 
 * FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE FOR YOUR IMPLEMENTATION
 * XILINX EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH RESPECT TO 
 * THE ADEQUACY OF THE IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO 
 * ANY WARRANTIES OR REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE 
 * FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY 
 * AND FITNESS FOR A PARTICULAR PURPOSE.
 */

/*
 * 
 *
 * This file is a generated sample test application.
 *
 * This application is intended to test and/or illustrate some 
 * functionality of your system.  The contents of this file may
 * vary depending on the IP in your system and may use existing
 * IP driver functions.  These drivers will be generated in your
 * SDK application project when you run the "Generate Libraries" menu item.
 *
 */


#include <stdio.h>
#include "xparameters.h"
#include "xil_cache.h"
#include "xiomodule.h"
#include "iomodule_header.h"

int simulation = 0;

const int idReg = 0;
const int ctlReg = 1;
const int statReg = 2;
const int miscReg = 3;
const int cxReg = 4;
const int cyReg = 5;
const int cnReg = 6;
const int crReg = 7;
const int cxgenMinReg    = 8;
const int cxgenDxReg     = 9;
const int cxgenEnableReg = 10;
const int cxgenClearReg  = 11;
const int mbpipeClearReg = 12;
const int mbpipeCyReg    = 13;
const int startAddrReg   = 14;
const int validOutReg    = 15;

const int simStatBit = 31;

const int doneStatBit = 18;

void sprint(char* str) {if (!simulation) print(str);};

Xuint32 dbuf[16]; // dummy buffer

const int calibration_stat_bit = 28;

static int toggle = 0;

static int dramInitialized = 0;
const int xgaModeBit = 19;
static int xgaMode = 0;

const int vcntXga = 768;
const int vcnt720p = 720;
const int hcntXga = 1024;
const int hcnt720p = 1280;

static int xpos = 500, ypos = 500;
static int xdir = 1, ydir =1;

// const int MAXIT = 16; // 32; // 255;  4096;
const int MAXIT = 31; // 255;
void mbrotHwPipe (int x0, int y0, int nx, int ny);
void mbrot (int x0, int y, int nx, int ny, int dy, Xuint32 *p);
void mbrotHw1 (int x0, int y, int nx, int ny, int dy, Xuint32 *p);
void mbrotTest(void);
inline int mbColor(int n);

static u32 switches;

static int iomInitialized;
XIOModule iom;

int main() 
{


   // pointer to iobus area
   volatile Xuint32 *ioBase = (volatile Xuint32 *)XPAR_IOMODULE_0_IO_BASEADDR;
   // size of iobus area
   int ioSize = XPAR_IOMODULE_0_IO_HIGHADDR - XPAR_IOMODULE_0_IO_BASEADDR + 1;

   volatile Xuint32 *dramBase = (volatile Xuint32 *)(XPAR_IOMODULE_0_IO_BASEADDR + (1 << 29));

   static int loop = 0;

   static int vcnt;
   static int hcnt;

   // get simulation mode
   simulation = (ioBase[statReg] & (1 << simStatBit))?1:0;
   xgaMode = (ioBase[statReg] & (1 << xgaModeBit))?1:0;

   vcnt = xgaMode?vcntXga:vcnt720p;
   hcnt = xgaMode?hcntXga:hcnt720p;


   toggle = 0;
   dramInitialized = 0;

   xpos = 500;
   ypos = 500;
   xdir = 1;
   ydir =1;

   iomInitialized = 0;

   while(1){
	   sprint("---Entering main---\n\r");

	   // test iobus
	   {
		   if (!simulation){
			   print("---Design ID: ");
			   putnum(ioBase[idReg]);
			   print("\n\r");
			   print("---Testing IOBUS---\n\r");
			   putnum(loop++);
		   }


		   Xuint32 id =  ioBase[0];
		   ioBase[miscReg] = (ioBase[miscReg] ^ 1) << 1;

		   ioBase[ctlReg] = ~(ioBase[ctlReg]);

		   {
			   //mbrotTest();

		   }

		   {
			   // initialize iom
			   if (0 == iomInitialized) {
				   iomInitialized = 1;
				   XIOModule_Initialize(&iom , XPAR_IOMODULE_0_DEVICE_ID);
			   }
			   XIOModule_DiscreteWrite(&iom, 1, toggle? 0xf0 : 0x0f);
			   switches = XIOModule_DiscreteRead(&iom, 1);
		   }

		   {
			   int i,j;
			   int frameIdx = 0;
			   // const int blue = 0x11, red = 0x0, green = 0xf0;
			   // const int blue = 0xff, red = 0x0, green = 0x0;
			   // blue is lowest byte(0..7), green is miggle byte (8..15), red ist highest byte (16..23). MSB (23..31) is unused
			   // int blue = 0x0, red = 0x0, green = 0x0ff;
			   int blue = 0x45, red = 0x67, green = 0x89;

			   if (switches & 0x10) {
				   for (i = 0; i< vcnt * hcnt; i++) {
						  // dramBase[frameIdx + i] = toggle? (~i) & 0xff : i & 0xff;
						  dramBase[frameIdx + i] = toggle? 0xff00 | (~i) & 0xff : i & 0xff;
						  //putnum(i & 0xff);
				   }
			   }


			   if (0 == dramInitialized) {
				   while (0 == (ioBase[statReg] & (1 << calibration_stat_bit))){
					   sprint("---Wait for DRAM calibration---\n\r");
				   }
				   dramInitialized = 1;
				   sprint("---Init DRAM ---\n\r");
				   if (xgaMode)
					   sprint("XGA\r\n");
				   else
					   sprint("720p\r\n");

				   if (!simulation){
					   putnum(vcnt);
					   putnum(hcnt);
				   }

				    if (!simulation){
				    	xil_printf("base pointer: 0x%x\r\n",dramBase);
				    }

				   for (i = 0; i< vcnt * hcnt; i++) {
					  dramBase[frameIdx + i] = 0;
				   }
				   for (i = 0; i< vcnt * hcnt; i++) {
					  if (i < 20 * hcnt){
						  // this is the correct mapping of r,g,b
						  dramBase[frameIdx + i] = red << 16 | green << 8 | blue;
					  }  else if (i < 40 * hcnt)
						  dramBase[frameIdx + i] = green << 16 | blue << 8 | red;
					  	  else if (i < 60 * hcnt)
					  		  dramBase[frameIdx + i] = blue << 16 | red << 8 | green;
					  	  else if (i < 80 * hcnt)
					  		  dramBase[frameIdx + i] = ((i % hcnt)/ 4) << 16 | ((i % hcnt) / 4) << 8 | ((i % hcnt)/ 4);
					  	  else if (i < 100 * hcnt)
					  		  dramBase[frameIdx + i] = 0x0000ffff;
					  	  else if (i < 120 * hcnt)
					  		  dramBase[frameIdx + i] = 0x00ffffff;
					  	  else
					  		  dramBase[frameIdx + i] = (red | green | blue) << 16 | (red | green | blue) << 8 | (red | green | blue);

				   }
				   sprint("---DRAM mbrot ---\n\r");
				   // mandelbrot figure
				   // use switch 4 to select compute function
				   if (switches & 0x08) {
					   mbrot(80,80,512,320,hcnt,dramBase + frameIdx);
				   } else {
					   // mbrotHw1(80,80,512,320,hcnt,dramBase + frameIdx);
					   //mbrotHw1(80,80,800,600,hcnt,dramBase + frameIdx);
					   mbrotHwPipe(80,80,800,600);
				   }
				   sprint("---DRAM mbrot finished ---\n\r");
			   }

			   // revert old box
			   for (i = 0; i < 10; i++){
				   for (j = 0; j < 10; j++){
				   dramBase[frameIdx + ((ypos + i) * hcnt) + xpos + j] ^= 0xffffff;
				   }
			   }
			   // move box
			   if (xdir > 0) {
				   if (xpos < (hcnt - 10)) xpos++;
				   else {
					   xdir = 0;
					   xpos--;
				   }
			   } else {
				   if (xpos > 0) xpos--;
				   else {
					   xdir = 1;
					   xpos++;
				   }
			   }
			   /*
			   for (i = 0; i < 10; i++){
				   for (j = 0; j < 10; j++){
				   dramBase[frameIdx + ((ypos + i) * hcnt) + xpos + j] ^= 0xffffff;
				   }
			   }
			   */
			   // draw new box
			   for (i = 0; i < 10; i++){
				   for (j = 0; j < 10; j++){
				   dramBase[frameIdx + ((ypos + i) * hcnt) + xpos + j] ^= 0xffffff;
				   }
			   }

			   // don't test dram when using hdmi
			   /*
			   sprint("---Testing DRAM ---\n\r");
			   if (!simulation) {
				   putnum(toggle);
				   sprint("\n\r");
			   }
			   for (i=0;i<10;i++){
				   dramBase[i] = toggle?i:~i;
				   if (!simulation){
					   sprint("Write RAM @");
					   putnum(i);
					   sprint(": ");
					   putnum(toggle?i:~i);
					   sprint("\n\r");
				   }
			   }
			   for (i=0;i<10;i++){
				   volatile Xuint32 tmp;
				   tmp = dramBase[i];
				   if (!simulation){
					   sprint("Read RAM @");
					   putnum(i);
					   sprint(": ");
					   putnum(tmp);
					   sprint("\n\r");
				   }
			   }
			   */

			   toggle = ~toggle;
		   }

	   }

	   {
		  XStatus status;

		  sprint("\r\nRunning IOModuleSelfTestExample() for iomodule_0...\r\n");

		  status = IOModuleSelfTestExample(XPAR_IOMODULE_0_DEVICE_ID);

		  if (status == 0) {
			  sprint("IOModuleSelfTestExample PASSED\r\n");
		  }
		  else {
			  sprint("IOModuleSelfTestExample FAILED\r\n");
		  }
	   }

	   sprint("---Exiting main---\n\r");
   }


   return 0;
}

void mbrotHwPipe (int x0, int y0, int nx, int ny)
{
    volatile Xuint32 *ioBase = (volatile Xuint32 *)XPAR_IOMODULE_0_IO_BASEADDR;
	const float xCentre = -0.75;
	const float yCentre = +0.0;
	const float dxy     = 0.006;
    float cx = xCentre - nx/2 * dxy;
    float cy = xCentre - ny/2 * dxy;
    int address_start  = 0;
    int address_offset = 4*1024;
    int row;
    
    ioBase[cxgenMinReg] = *((int*) &cx);
    ioBase[cxgenDxReg]  = *((int*) &dxy);
    
    for (row = 0; row < ny; ++row) {
        ioBase[mbpipeClearReg] = 0;
        ioBase[cxgenClearReg]  = 0;
        ioBase[mbpipeCyReg]    = *((int*) &cy);
        ioBase[startAddrReg]   = address_start;
        ioBase[cxgenEnableReg] = 1;
        
        while (ioBase[validOutReg] == 0); // Wait until ColorConverter output is valid
        while (ioBase[validOutReg] != 0); // Wait until ColorConverter output is invalid again (finished)
        ioBase[cxgenEnableReg] = 0;
        ioBase[mbpipeClearReg] = 1;
        ioBase[cxgenClearReg]  = 1;
        
        cy += dxy;
        address_start += address_offset;
    }
}


// x0,y0: pixel offset. nx,ny: number in x,y. dy: line offset. p: pointer to frame base
void mbrot (int x0, int y0, int nx, int ny, int dy, Xuint32 *p){
	const double xCentre = -0.75;
	const double yCentre = +0.0;
	const double dxy     = 0.006;
	// const int MAXIT = 16; // 32; // 255;
	const int MAXVAL = 256;
    double cx, cy;
    double zx, zy, new_zx;
    unsigned char n;
    int i, j;
    int color;

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
		while ((zx*zx + zy*zy < 4.0) && (n != (MAXIT - 1))) {
		  new_zx = zx*zx - zy*zy + cx;
		  zy = 2.0*zx*zy + cy;
		  zx = new_zx;
		  n++;
		}
		color = mbColor(n);
		p[(y0 + j)*dy + (x0 + i)] = color;
		// p[(y0 + j)*dy + (x0 + i)] = n>MAXIT/2 ? 0xff0000 | ((n * MAXVAL)/MAXIT):((n * MAXVAL)/MAXIT); // write (1, &n, sizeof(n)); // Write the result to stdout
      }
	  sprint("m");

    }
    sprint("\n\r");

}

void mbrotHw1 (int x0, int y0, int nx, int ny, int dy, Xuint32 *p){
	const float xCentre = -0.75;
	const float yCentre = +0.0;
	const float dxy     = 0.006;
	// const int MAXIT = 16; // 4096; // 255;
    float cx, cy;
    unsigned int n;
    int i, j;
    int color;

    // pointer to iobus area
    volatile Xuint32 *ioBase = (volatile Xuint32 *)XPAR_IOMODULE_0_IO_BASEADDR;
    // need also float pointer for cx,cy!!!!
    volatile float *ioBaseReal = (volatile float *)XPAR_IOMODULE_0_IO_BASEADDR;

    // The Mandelbrot calculation is to iterate the equation
    // z = z*z + c, where z and c are complex numbers, z is initially
    // zero, and c is the coordinate of the point being tested. If
    // the magnitude of z remains less than 2 for ever, then the point
    // c is in the Mandelbrot set. We write out the number of iterations
    // before the magnitude of z exceeds 2, or UCHAR_MAX, whichever is
    // smaller.

    sprint("---FPGA mbrot ---\n\r");
    if (!simulation){
    	xil_printf("base pointer: 0x%x\r\n",p);
    }

    ioBase[cnReg] = MAXIT;

    for (j = 0; j < ny; j++) {
      cy = yCentre + (j - ny/2)*dxy;
      ioBaseReal[cyReg] = cy; // cy first
      for (i = 0; i < nx; i++) {
		cx = xCentre + (i - nx/2)*dxy;
		ioBaseReal[cxReg] = cx;
		while (0 == (ioBase[statReg] & (1 << doneStatBit))) ; // wait for done
		n = ioBase[crReg];
		// color = ((n * MAXVAL)/ MAXIT) | (((n >> 3) * MAXVAL) / (MAXIT >> 3)) << 8 | (((n >> 6) * MAXVAL) / (MAXIT >> 6)) << 16 ;
		// color = ((n * MAXVAL)/ MAXIT) | ((((n / 4) * MAXVAL) / (MAXIT / 4)) << 8) | ((((n >> 4) * MAXVAL) ) << 16) ;
		// color = ((n * MAXVAL)/ MAXIT) | ((((n / 4) * MAXVAL) / (MAXIT / 4)) << 8) | ((~((((n / 64 ) * MAXVAL) / (MAXIT / 64 ))) & 0xff) << 16) ;
		color = mbColor(n);
		// color =  ((((n / 4) * MAXVAL) / (MAXIT / 4)) << 8) | ((((n / 64 ) * MAXVAL) / (MAXIT / 64 )) << 16) ;
		// p[(y0 + j)*dy + (x0 + i)] = n>MAXIT/2 ? 0xff0000 | ((n * MAXVAL)/MAXIT):((n * MAXVAL)/MAXIT); // write (1, &n, sizeof(n)); // Write the result to stdout
		p[(y0 + j)*dy + (x0 + i)] = color;
      }
    }

}


void mbrotTest(void) {
	// do the same as in testbench
    /*
    --bddd2f18 bf743958 (-0.108000, -0.954000) :11
    --be1374bc bf75c290 (-0.144000, -0.960000) :b
    --bddd2f18 bf75c290 (-0.108000, -0.960000) :21
    --bd9fbe78 bf75c290 (-0.078000, -0.960000) :f
    --bde978d8 bf743958 (-0.114000, -0.954000) :e
    --bdd0e560 bf743958 (-0.102000, -0.954000) :26
    */
	const int MAXIT = 64; // 255;
    float cx[] = {-0.108000,-0.144000,-0.108000,-0.078000,-0.114000,-0.102000};
    float cy[] = {-0.954000,-0.960000,-0.960000,-0.960000,-0.954000,-0.954000};
    unsigned int n;
    int i;

    // pointer to iobus area. We need floats for cx,cy!!!!
    volatile Xuint32 *ioBase = (volatile Xuint32 *)XPAR_IOMODULE_0_IO_BASEADDR;
    volatile float *ioBaseReal = (volatile float *)XPAR_IOMODULE_0_IO_BASEADDR;
    sprint("---FPGA mbrot test ---\n\r");

    ioBase[cnReg] = MAXIT;
    for (i=0; i < sizeof(cx)/sizeof(float); i++ ){
    	//ioBase[cyReg] = *((unsigned int*)&(cy[i]));
    	//ioBase[cxReg] = *((unsigned int*)&(cx[i]));
    	ioBaseReal[cyReg] = cy[i];
    	ioBaseReal[cxReg] = cx[i];
    	while (0 == (ioBase[statReg] & (1 << doneStatBit))) ; // wait for done
    	n = ioBase[crReg];

    }


}

inline int mbColor(int n){
	const int MAXVAL = 256;
	return (((n * MAXVAL)/ MAXIT) | ((((n / 4) * MAXVAL) / (MAXIT / 4)) << 8) | (((((n / 64 ) * MAXVAL) / (MAXIT / 64 ))) << 16)) ;
}
