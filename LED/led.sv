///
///



module led(input logic clk, btn, reset, output logic led1);

typedef enum {INIT, BTN_WAIT, LED_BLINK} e_state;

e_state state; //текущее состояние
logic [27:0] counter  = 0; //счетчик секунд
logic [23:0] blink_counter  = 0; //счетчик секунд

logic clk_sys, clk_la;

pl pll_inst (
	.inclk0(clk),
	.c0(clk_sys),
	.c1(clk_la));



always@(posedge clk_sys)
begin
	if(reset)
		begin
		counter <= 0;
		led1 <= 1;
		state <= INIT;
		end
	else
		begin
		case(state)
			INIT:
				begin
				led1 <= 1;
				if (counter >= 250_000_000)
					begin
					counter <= 0;
					state <= BTN_WAIT;
					end
				else
					begin
						counter <= counter + 1;
					end
				end
			BTN_WAIT:
				if(!btn)
					begin
					state <= LED_BLINK;
					end
					
			LED_BLINK:
				begin
				if (counter >= 250_000_000)
					begin
					led1 <= 1;
					counter <= 0;
					state <= BTN_WAIT;
					end
				else
					begin
						if(blink_counter >= 16_666_666) begin
							led1 <= ~led1;
							blink_counter <= 0;
						end
						else begin
							blink_counter <= blink_counter + 1;
						end
						counter <= counter + 1;
					end
				end
		endcase
		end
end
endmodule
