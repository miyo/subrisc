set project_dir    "./prj"
set project_name   "subrisc_exstickge"
set project_target "xc7a200tsbg484-1"
set source_files { \
		       ../hdl/ApplyStage.v \
		       ../hdl/alu.v \
		       ../hdl/memory_45nm.v \
		       ../hdl/ComputeStage.v \
		       ../hdl/main.v \
		       ../hdl/registerfile.v \
		       ../hdl/FetchStage.v \
		       ../hdl/memory.v \
		       ./top.v }
set constraint_files { \
			   ./top.xdc \
		       }

set simulation_files { \
			   ../hdl/testbench.v \
		       }

create_project -force $project_name $project_dir -part $project_target
add_files -norecurse $source_files
add_files -fileset constrs_1 -norecurse $constraint_files

update_ip_catalog

import_ip -files ./clk_wiz_0.xci

set_property top top [current_fileset]
set_property target_constrs_file ./top.xdc [current_fileset -constrset]

update_compile_order -fileset sources_1

#add_files -fileset sim_1 -norecurse $simulation_files

update_compile_order -fileset sim_1

reset_project

set_property strategy Flow_PerfOptimized_high [get_runs synth_1]
set_property strategy Performance_ExplorePostRoutePhysOpt [get_runs impl_1]

launch_runs synth_1 -jobs 4
wait_on_run synth_1

launch_runs impl_1 -jobs 4
wait_on_run impl_1
open_run impl_1
report_utilization -file [file join $project_dir "project.rpt"]
report_timing -file [file join $project_dir "project.rpt"] -append
 
launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1
close_project

quit
