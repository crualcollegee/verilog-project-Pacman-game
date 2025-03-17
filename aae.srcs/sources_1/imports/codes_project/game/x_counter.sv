module counter (
    input clk,
    input rst,
    input wire [7:0] x, //x used to define different speed
    output reg out,
    output reg [7:0] cnt
);
    logic clk_reg;
    // reg [7:0] cnt;
    always @(posedge clk) begin
        if(rst) begin cnt <= 0; end
            if (cnt == x) begin
                out <= 1;
                cnt <= 0;
            end
            else begin
                cnt <= cnt + 1;
                out <= 0;
            end
        end
endmodule