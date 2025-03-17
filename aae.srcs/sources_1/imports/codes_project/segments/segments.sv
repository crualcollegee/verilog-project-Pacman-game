module segments(
    input clk, rst,
    input wire [15:0] hexs,
    output wire [7:0] SEGMENT,
    output wire [3:0] AN
);

wire [31:0] div_res;
wire [3:0] HEX;
wire point, LE;

clkdiv clk_div_inst(
    .clk(clk),
    .rst(rst),
    .div_res(div_res)
);

DisplaySync DisplaySync_inst(
    .scan(div_res[18:17]),
    .hexs(hexs),
    .points(4'b0000),
    .LEs(4'b1111),
    .HEX(HEX),
    .point(point),
    .LE(LE),
    .AN(AN)
);

MyMC14495 MyMC14495_inst(
    .D0(HEX[0]),
    .D1(HEX[1]),
    .D2(HEX[2]),
    .D3(HEX[3]),
    .point(point),
    .LE(LE),
    .a(SEGMENT[0]),
    .b(SEGMENT[1]),
    .c(SEGMENT[2]),
    .d(SEGMENT[3]),
    .e(SEGMENT[4]),
    .f(SEGMENT[5]),
    .g(SEGMENT[6]),
    .p(SEGMENT[7])
);

endmodule