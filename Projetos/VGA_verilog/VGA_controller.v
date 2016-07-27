module ControladorSDRAM_VGA(datain, red, green, blue, full, empty, clk);

input full, empty, clk;
input [23:0] datain;
output [7:0] blue, green, red;

endmodule
