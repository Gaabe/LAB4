transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/Rafael\ Ferrari/Documents/Quartus/VGA_2 {C:/Users/Rafael Ferrari/Documents/Quartus/VGA_2/symbol_top_inst.v}
vlog -vlog01compat -work work +incdir+C:/Users/Rafael\ Ferrari/Documents/Quartus/VGA_2 {C:/Users/Rafael Ferrari/Documents/Quartus/VGA_2/symbol_top.v}
vlog -vlog01compat -work work +incdir+C:/Users/Rafael\ Ferrari/Documents/Quartus/VGA_2 {C:/Users/Rafael Ferrari/Documents/Quartus/VGA_2/VGA_pixelLogic.v}
vlog -vlog01compat -work work +incdir+C:/Users/Rafael\ Ferrari/Documents/Quartus/VGA_2 {C:/Users/Rafael Ferrari/Documents/Quartus/VGA_2/VGA_fifo.v}
vlog -vlog01compat -work work +incdir+C:/Users/Rafael\ Ferrari/Documents/Quartus/VGA_2 {C:/Users/Rafael Ferrari/Documents/Quartus/VGA_2/VGA_controller.v}
vlog -vlog01compat -work work +incdir+C:/Users/Rafael\ Ferrari/Documents/Quartus/VGA_2 {C:/Users/Rafael Ferrari/Documents/Quartus/VGA_2/pll.v}
vlog -vlog01compat -work work +incdir+C:/Users/Rafael\ Ferrari/Documents/Quartus/VGA_2 {C:/Users/Rafael Ferrari/Documents/Quartus/VGA_2/resetLogic.v}
vlog -vlog01compat -work work +incdir+C:/Users/Rafael\ Ferrari/Documents/Quartus/VGA_2 {C:/Users/Rafael Ferrari/Documents/Quartus/VGA_2/sdram_sim.v}
vlog -vlog01compat -work work +incdir+C:/Users/Rafael\ Ferrari/Documents/Quartus/VGA_2/db {C:/Users/Rafael Ferrari/Documents/Quartus/VGA_2/db/pll_altpll.v}

