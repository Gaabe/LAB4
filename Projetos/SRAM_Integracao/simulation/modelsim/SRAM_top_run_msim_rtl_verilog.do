transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/Rafael\ Ferrari/Documents/Quartus/SRAM {C:/Users/Rafael Ferrari/Documents/Quartus/SRAM/ram_megafunction.v}
vlog -vlog01compat -work work +incdir+C:/Users/Rafael\ Ferrari/Documents/Quartus/SRAM {C:/Users/Rafael Ferrari/Documents/Quartus/SRAM/sram_addr_decoder.v}
vlog -vlog01compat -work work +incdir+C:/Users/Rafael\ Ferrari/Documents/Quartus/SRAM {C:/Users/Rafael Ferrari/Documents/Quartus/SRAM/SRAM_fsm_quartus.v}
vlog -vlog01compat -work work +incdir+C:/Users/Rafael\ Ferrari/Documents/Quartus/SRAM {C:/Users/Rafael Ferrari/Documents/Quartus/SRAM/S2_module.v}
vlog -vlog01compat -work work +incdir+C:/Users/Rafael\ Ferrari/Documents/Quartus/SRAM {C:/Users/Rafael Ferrari/Documents/Quartus/SRAM/mux_ip.v}
vlog -vlog01compat -work work +incdir+C:/Users/Rafael\ Ferrari/Documents/Quartus/SRAM {C:/Users/Rafael Ferrari/Documents/Quartus/SRAM/mux_ip4.v}
vlog -vlog01compat -work work +incdir+C:/Users/Rafael\ Ferrari/Documents/Quartus/SRAM {C:/Users/Rafael Ferrari/Documents/Quartus/SRAM/splitter.v}
vlog -vlog01compat -work work +incdir+C:/Users/Rafael\ Ferrari/Documents/Quartus/SRAM {C:/Users/Rafael Ferrari/Documents/Quartus/SRAM/demux_shapes.v}
vlog -vlog01compat -work work +incdir+C:/Users/Rafael\ Ferrari/Documents/Quartus/SRAM {C:/Users/Rafael Ferrari/Documents/Quartus/SRAM/SRAM_module2.v}
vlog -vlog01compat -work work +incdir+C:/Users/Rafael\ Ferrari/Documents/Quartus/SRAM {C:/Users/Rafael Ferrari/Documents/Quartus/SRAM/s2_pipeline_buffer.v}
vlog -vlog01compat -work work +incdir+C:/Users/Rafael\ Ferrari/Documents/Quartus/SRAM {C:/Users/Rafael Ferrari/Documents/Quartus/SRAM/dataShifter.v}
vlog -vlog01compat -work work +incdir+C:/Users/Rafael\ Ferrari/Documents/Quartus/SRAM {C:/Users/Rafael Ferrari/Documents/Quartus/SRAM/mux_offset.v}
vlog -vlog01compat -work work +incdir+C:/Users/Rafael\ Ferrari/Documents/Quartus/SRAM {C:/Users/Rafael Ferrari/Documents/Quartus/SRAM/S2_interno.v}
vlog -vlog01compat -work work +incdir+C:/Users/Rafael\ Ferrari/Documents/Quartus/SRAM {C:/Users/Rafael Ferrari/Documents/Quartus/SRAM/t5_t6.v}
vlog -vlog01compat -work work +incdir+C:/Users/Rafael\ Ferrari/Documents/Quartus/SRAM {C:/Users/Rafael Ferrari/Documents/Quartus/SRAM/t7.v}
vlog -vlog01compat -work work +incdir+C:/Users/Rafael\ Ferrari/Documents/Quartus/SRAM {C:/Users/Rafael Ferrari/Documents/Quartus/SRAM/S2plusS3.v}
vlog -vlog01compat -work work +incdir+C:/Users/Rafael\ Ferrari/Documents/Quartus/SRAM {C:/Users/Rafael Ferrari/Documents/Quartus/SRAM/s2_controller.v}

