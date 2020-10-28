`timescale 1ns/1ps

module sim();

reg btn, reset, led1;
reg clk = 1'b0;

led TEST(clk, btn, reset, led1);

initial begin
	reset = 0;
	btn = 0;
	#250_000_001
	btn = 1;
	#10_000;
	btn = 0;
	#300_000_000;
end

always begin
	#0.5;
	clk = !clk;
end
 
endmodule
