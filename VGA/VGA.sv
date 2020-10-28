/*
Выводит на экран 8 полос разного цвета
Разрешение 800х600 60Hz

VGA Signal Timing
Pixel freq.	40.0 MHz

Horizontal
Whole line 1056 px
Visible area 800
Front porch	40
Sync pulse	128
Back porch	88

Vertical 
Whole frame	628 px
Visible area 600	
Front porch	1	
Sync pulse	4	
Back porch	23	
*/

module VGA(input clk, output reg v_sync, output reg h_sync, output reg vga_r, output reg vga_g, output reg vga_b);

logic clk_sys;
logic clk_la;

//генератор частоты 40MHz
pll PLL_40MHz(
	.inclk0(clk),
	.c0(clk_sys),
	.c1(clk_la));
	

reg [11:0] h_cnt; //счетчик пикселей по горизонтали
reg [10:0] v_cnt;	//счетчик пикселей по вертикали
reg h_en; //запрет/разрешение отрисовки по горизонтали
reg v_en; //запрет/разрешение отрисовки по вертикали

//блок синхронизации
always@(posedge clk_sys) begin

    if((h_cnt > 839) & (h_cnt < 968)) begin
        h_sync <= 0;
    end
    else begin
        h_sync <= 1;
    end
    
    if((v_cnt > 600) & (v_cnt < 605)) begin
        v_sync <= 0;
    end
    else begin
        v_sync <= 1;
    end
    
end

//увеличение счетчиков по горизонтали и вертикали 
always@(posedge clk_sys) begin

    if(h_cnt > 1055) begin
    
        h_cnt <= 0; 
        
        if(v_cnt > 627) begin
            v_cnt <= 0;
        end
        else begin
            v_cnt <= v_cnt + 1;
        end
    end    
    else begin
        h_cnt <= h_cnt + 1;
    end
        
end

//запрет отрисовки вне видимой зоны 
always@(posedge clk_sys) begin
	
    if(v_cnt < 599) begin
        v_en <= 1;
    end
    else begin
        v_en <= 0;
    end
    
    if(h_cnt < 799) begin
        h_en <= 1;
    end
    else begin
        h_en <= 0;
    end
        
end

//отрисовка линий
always@(posedge clk_sys) begin	
		
    if((v_en == 1) & (h_en == 1))  begin
    
        case(v_cnt)
        
            0: begin
                vga_r <= 0; //черный
                vga_g <= 0;
                vga_b <= 0;
            end
            
            75: begin
                vga_r <= 1; //красный
                vga_g <= 0;
                vga_b <= 0;
            end
            
            150: begin
                vga_r <= 1; //желтый
                vga_g <= 1;
                vga_b <= 0;
            end
            
            225: begin
                vga_r <= 0; //зеленый
                vga_g <= 1;
                vga_b <= 0;
            end
            
            300: begin
                vga_r <= 0; //голубой
                vga_g <= 1;
                vga_b <= 1;
            end
            
            375: begin
                vga_r <= 0; //синий
                vga_g <= 0;
                vga_b <= 1;
            end
            
            450: begin
                vga_r <= 1; //лиловый
                vga_g <= 0;
                vga_b <= 1;
            end
            
            525: begin
                vga_r <= 1; //белый
                vga_g <= 1;
                vga_b <= 1;
            end
            
        endcase
    end
    else  begin
        vga_r <= 0;
        vga_g <= 0;
        vga_b <= 0;
    end
    
end

endmodule