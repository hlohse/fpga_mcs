
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name mcs -dir "/home/kugel/daten/work/verwalt/heidelberg/lectures/2014/copro/exercises/3/fpga_mcs/planAhead_run_1" -part xc6slx45csg324-2
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "/home/kugel/daten/work/verwalt/heidelberg/lectures/2014/copro/exercises/3/fpga_mcs/mcs_top.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {/home/kugel/daten/work/verwalt/heidelberg/lectures/2014/copro/exercises/3/fpga_mcs} {ipcore_dir} }
add_files [list {/home/kugel/daten/work/verwalt/heidelberg/lectures/2014/copro/exercises/3/fpga_mcs/mblaze.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/fmul_l3_4dsp.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/fadd_l3.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/fsub.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/fmul_l3.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/fcmpless.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/fadd.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/itof_l3.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/fmul.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/cx_shift_3.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/fsub_l3.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/c_counter_binary_v11_0.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/fmul_nd_l3.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/cx_shift_6.ncf}] -fileset [get_property constrset [current_run]]
set_property target_constrs_file "/home/kugel/daten/work/verwalt/heidelberg/lectures/2014/copro/exercises/3/fpga_mcs/mcs_top.ucf" [current_fileset -constrset]
add_files [list {mcs_top.ucf}] -fileset [get_property constrset [current_run]]
add_files [list {dp_dram.ucf}] -fileset [get_property constrset [current_run]]
add_files [list {hdmi.ucf}] -fileset [get_property constrset [current_run]]
link_design
