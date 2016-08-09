transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/aluno/rafael/VGA_2 {/home/aluno/rafael/VGA_2/symbol_top_inst.v}
vlog -vlog01compat -work work +incdir+/home/aluno/rafael/VGA_2 {/home/aluno/rafael/VGA_2/symbol_top.v}
vlog -vlog01compat -work work +incdir+/home/aluno/rafael/VGA_2 {/home/aluno/rafael/VGA_2/VGA_pixelLogic.v}
vlog -vlog01compat -work work +incdir+/home/aluno/rafael/VGA_2 {/home/aluno/rafael/VGA_2/VGA_fifo.v}
vlog -vlog01compat -work work +incdir+/home/aluno/rafael/VGA_2 {/home/aluno/rafael/VGA_2/VGA_controller.v}
vlog -vlog01compat -work work +incdir+/home/aluno/rafael/VGA_2 {/home/aluno/rafael/VGA_2/pll.v}
vlog -vlog01compat -work work +incdir+/home/aluno/rafael/VGA_2 {/home/aluno/rafael/VGA_2/sdram_sim.v}
vlog -vlog01compat -work work +incdir+/home/aluno/rafael/VGA_2/db {/home/aluno/rafael/VGA_2/db/pll_altpll.v}

