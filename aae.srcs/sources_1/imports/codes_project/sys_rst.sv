module sys_rst(
    input sw,
    input clk,
    output reg rst
);

logic [3:0] power_on_counter = 4'd0;
logic power_on_rst = 1'b1;

always @(posedge clk) begin
    // power on reset
    if (power_on_rst) begin
        if (power_on_counter < 4'd15) begin
            power_on_counter <= power_on_counter + 1'b1;
            rst <= 1'b1;
        end else begin
            power_on_rst <= 1'b0;
            rst <= sw;
        end
    end else begin
        // controlled by switch
        rst <= sw;
    end
end

endmodule