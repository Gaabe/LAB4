transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/Rafael\ Ferrari/Documents/Quartus/PARTE2_ALPHA {C:/Users/Rafael Ferrari/Documents/Quartus/PARTE2_ALPHA/interfaceTesterFSM.v}

