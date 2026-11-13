onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /DE1_SoC_Testbench/CLOCK_50
add wave -noupdate /DE1_SoC_Testbench/CLOCK_PERIOD
add wave -noupdate /DE1_SoC_Testbench/GPIO_1
add wave -noupdate -expand /DE1_SoC_Testbench/SW
add wave -noupdate /DE1_SoC_Testbench/KEY
add wave -noupdate /DE1_SoC_Testbench/dut/RedPixels
add wave -noupdate /DE1_SoC_Testbench/dut/GrnPixels
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 152
configure wave -valuecolwidth 202
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 50
configure wave -gridperiod 100
configure wave -griddelta 2
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {1623 ps} {11231 ps}
