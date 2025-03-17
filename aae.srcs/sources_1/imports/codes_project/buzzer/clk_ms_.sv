module clk_ms_1( 
	input logic clk,
	output logic clk_ms
);

	logic [31:0] cnt;

	initial begin
		cnt <= 32'b0;
		clk_ms <= 0;
	end

	wire [31:0] cnt_next;
	assign cnt_next = cnt + 1'b1;

	always @(posedge clk) begin
		if(cnt<50_000)begin
			cnt <= cnt_next;
		end
		else begin
			cnt <= 0;
			clk_ms <= ~clk_ms;
		end
	end

endmodule

//module clkdiv(
//    input logic clk,
//    input logic rst,
//    output logic clk_out
//);

//    // 计数器的最大值
//    localparam int COUNTER_MAX = 50_000 - 1;

//    logic [15:0] counter; // 用于计数的寄存器，16位宽度足够容纳最大值50,000

//    always_ff @(posedge clk or posedge rst) begin
//        if (rst) begin
//            counter <= 16'b0;
//            clk_out <= 1'b0;
//        end else if (counter == COUNTER_MAX) begin
//            counter <= 16'b0;
//            clk_out <= ~clk_out; // 翻转输出时钟
//        end else begin
//            counter <= counter + 1;
//        end
//    end
// endmodule
