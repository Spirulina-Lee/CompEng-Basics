transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+E:/Belis/homework/NAU/EE310/exam1 {E:/Belis/homework/NAU/EE310/exam1/mux8to1.sv}

