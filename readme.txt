
first, source the tcl script 
source ./microblaze_mcs_setup.tcl

# if not found, directory structure might be different. Check!

This makes the two procedures available and call the first one (setup) already

Command>
source ./microblaze_mcs_setup.tcl

microblaze_mcs_setup: Found 1 MicroBlaze MCS core.
microblaze_mcs_setup: Existing ngdbuild "-bm" option unchanged.
microblaze_mcs_setup: Done.

The second procedure is now available as a command:
microblaze_mcs_data2mem ./sw/test1/Debug/test1.elf

Command>
microblaze_mcs_data2mem ./sw/test1/Debug/test1.elf

microblaze_mcs_data2mem: Found 1 MicroBlaze MCS core.
microblaze_mcs_data2mem: Using "test1.elf" for mblaze
microblaze_mcs_data2mem: Added "-bd" options to bitgen command line.
microblaze_mcs_data2mem: Running "data2mem" to create simulation files.
microblaze_mcs_data2mem: Running "data2mem" to update bitstream with software.
microblaze_mcs_data2mem: Done.

The .mem files are generated

-----------------------------------------------------------------
data2mem arguments from "ise" subdirectory:

# you have to adjust the directoy, probably 
data2mem -p xc6slx45csg324-2 -bm "./mblaze_bd.bmm" -bd "./sw/test1/Debug/test1.elf" tag mblaze -bt "mcs_top.bit" -o b "mcs_top_out.bit"
 

-----------------------------------------------------------------
V I D E O   T I M I N Gs
XGA
Screen refresh rate	60 Hz
Vertical refresh	48.363095238095 kHz
Pixel freq.	65.0 MHz
Horizontal timing (line)
Polarity of horizontal sync pulse is negative.

Scanline part	Pixels	Time [µs]
Visible area	1024	15.753846153846
Front porch	24	0.36923076923077
Sync pulse	136	2.0923076923077
Back porch	160	2.4615384615385
Whole line	1344	20.676923076923
Vertical timing (frame)
Polarity of vertical sync pulse is negative.

Frame part	Lines	Time [ms]
Visible area	768	15.879876923077
Front porch	3	0.062030769230769
Sync pulse	6	0.12406153846154
Back porch	29	0.59963076923077
Whole frame	806	16.6656

-----------------------------------------------------------------
DRAM runs at 300MHz

