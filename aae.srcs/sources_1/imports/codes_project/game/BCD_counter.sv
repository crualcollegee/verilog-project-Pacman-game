module BCD_Counter(
	input eat,
	input Clk,	
	input Rst_n,	
	input Cin,
	input [1:0] state, 		
	output reg Cout,		
	output [3:0] q			
);

	reg [3:0] cnt;
	
	always @(posedge Clk) begin
		if (Rst_n) begin
			cnt <= 4'd0;
//			Cout <= 1'b0;
		end 
		else begin
			if(eat) begin
				if (Cin == 1'b1) begin
					if (cnt == 4'd9) begin
						cnt <= 4'd0;
					end 
					else begin
						cnt <= cnt + 1'b1;
					end
				end
				else begin
					cnt <= cnt;
				end
			end
		end
	end
	assign Cout = (Rst_n)?0:(cnt==4'd9&&Cin==1'b1);


	assign q = cnt;

endmodule