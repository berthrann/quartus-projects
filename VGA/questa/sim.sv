`timescale 1ns/1ns

module sim();

reg clk_sys = 1'b0;
reg v_sync, h_sync, vga_r, vga_g, vga_b;

VGA TEST(clk_sys, 
	 v_sync,
	 h_sync,
	 vga_r, 
	 vga_g,
	 vga_b);

always begin
	#1;
	clk_sys = !clk_sys;
end

endmodule