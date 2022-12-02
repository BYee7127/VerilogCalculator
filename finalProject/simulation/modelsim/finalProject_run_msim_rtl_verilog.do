transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+A:/BeverlyPC/Documents/SetsunaFolder/School/CS5710/VerilogCalculator/finalProject {A:/BeverlyPC/Documents/SetsunaFolder/School/CS5710/VerilogCalculator/finalProject/finalProject.v}
vlog -vlog01compat -work work +incdir+A:/BeverlyPC/Documents/SetsunaFolder/School/CS5710/VerilogCalculator/finalProject {A:/BeverlyPC/Documents/SetsunaFolder/School/CS5710/VerilogCalculator/finalProject/memory.v}
vlog -vlog01compat -work work +incdir+A:/BeverlyPC/Documents/SetsunaFolder/School/CS5710/VerilogCalculator/finalProject {A:/BeverlyPC/Documents/SetsunaFolder/School/CS5710/VerilogCalculator/finalProject/alu.v}
vlog -vlog01compat -work work +incdir+A:/BeverlyPC/Documents/SetsunaFolder/School/CS5710/VerilogCalculator/finalProject {A:/BeverlyPC/Documents/SetsunaFolder/School/CS5710/VerilogCalculator/finalProject/regfile.v}
vlog -vlog01compat -work work +incdir+A:/BeverlyPC/Documents/SetsunaFolder/School/CS5710/VerilogCalculator/finalProject {A:/BeverlyPC/Documents/SetsunaFolder/School/CS5710/VerilogCalculator/finalProject/datapath.v}

