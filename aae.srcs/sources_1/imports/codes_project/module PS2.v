//author£º ³Âð©Ìì
module PS2(
	input clk,
	input rst,
	input ps2_clk,
	input  ps2_data,
	output reg[1:0] direction,
	output reg space
	);
reg up;
reg down;
reg left;
reg right;
reg pre_up;
reg pre_down;
reg pre_left;
reg pre_right;
reg data_end;
reg data_expand;
reg ps2_clk_falg0, ps2_clk_falg1, ps2_clk_falg2;
wire negedge_ps2_clk = !ps2_clk_falg1 & ps2_clk_falg2;
reg negedge_ps2_clk_shift;
reg[7:0]temp_data;
reg [9:0] data;
reg[3:0]num;

always@(posedge clk or posedge rst)begin
	if(rst)begin
		ps2_clk_falg0<=1'b0;
		ps2_clk_falg1<=1'b0;
		ps2_clk_falg2<=1'b0;
	end
	else begin
		ps2_clk_falg0<=ps2_clk;
		ps2_clk_falg1<=ps2_clk_falg0;
		ps2_clk_falg2<=ps2_clk_falg1;
	end
end

always@(posedge clk or posedge rst)begin
	if(rst)
		num<=4'd0;
	else if (num==4'd11)
		num<=4'd0;
	else if (negedge_ps2_clk)
		num<=num+1'b1;
end

always@(posedge clk)begin
	negedge_ps2_clk_shift<=negedge_ps2_clk;
end


always@(posedge clk or posedge rst)begin
	if(rst)
		temp_data<=8'd0;
	else if (negedge_ps2_clk_shift)begin
		case(num)
			4'd2 : temp_data[0]<=ps2_data;
			4'd3 : temp_data[1]<=ps2_data;
			4'd4 : temp_data[2]<=ps2_data;
			4'd5 : temp_data[3]<=ps2_data;
			4'd6 : temp_data[4]<=ps2_data;
			4'd7 : temp_data[5]<=ps2_data;
			4'd8 : temp_data[6]<=ps2_data;
			4'd9 : temp_data[7]<=ps2_data;
			default: temp_data<=temp_data;
		endcase
	end
	else temp_data<=temp_data;
end

always@(posedge clk or posedge rst)begin
	if(rst)begin
		data_end<=1'b0;
		data<=10'd0;
		data_expand<=1'b0;
	end
	else if(num==4'd11)begin
		if(temp_data==8'hF0)
		begin
			data_end<=1'b1;
		end
		else if(temp_data==8'hE0)begin
			data_expand<=1'b1;
		end
		else begin
			data<={data_expand,data_end,temp_data};
			data_expand<=1'b0;
			data_end<=1'b0;
		end
	end
	else begin
		data<=data;
		data_expand<=data_expand;
		data_end<=data_end;
	end
end


always @(posedge clk) begin
    pre_up=up;
    pre_down=down;
    pre_left=left;
    pre_right=right;
	case (data)
        10'h272:down= 1;
        10'h372:down= 0;
        10'h29:space= 1;
        10'h129:space= 0;
        10'h275:up= 1;
        10'h375:up= 0;
        10'h26B:left= 1;
        10'h36B:left= 0;
        10'h274:right = 1;
        10'h374:right= 0;
    endcase
    if(pre_up==0&&up==1)begin
        direction=0;
    end
    if(pre_down==0&&down==1)begin
        direction=1;
    end
    if(pre_left==0&&left==1)begin
        direction=2;
    end
    if (pre_right==0&&right==1)begin
        direction=3;
    end
end

endmodule