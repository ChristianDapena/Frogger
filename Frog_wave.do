onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /Frog_Testbench/up
add wave -noupdate /Frog_Testbench/right
add wave -noupdate /Frog_Testbench/left
add wave -noupdate /Frog_Testbench/reset
add wave -noupdate /Frog_Testbench/y
add wave -noupdate /Frog_Testbench/x
add wave -noupdate /Frog_Testbench/game_over
add wave -noupdate /Frog_Testbench/down
add wave -noupdate /Frog_Testbench/CLOCK_PERIOD
add wave -noupdate /Frog_Testbench/CLK
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {6200 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 125
configure wave -valuecolwidth 40
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
WaveRestoreZoom {0 ps} {9923 ps}
