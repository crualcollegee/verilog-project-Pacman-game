module clkdiv(
    input wire clk, rst,
    output reg [31:0] div_res
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        div_res <= 32'b0;
    end else begin
        div_res <= div_res + 1'b1;
    end
end

endmodule


module DisplaySync(
    input [ 1:0] scan,
    input [15:0] hexs,
    input [ 3:0] points,
    input [ 3:0] LEs,
    output[ 3:0] HEX,
    output[ 3:0] AN,
    output       point,
    output       LE
);

    reg [3:0] c0 = 4'b1110;
    reg [3:0] c1 = 4'b1101;
    reg [3:0] c2 = 4'b1011;
    reg [3:0] c3 = 4'b0111;

    Mux4to1b4 mux_hexs(
        .S(scan),
        .D0(hexs[3:0]),
        .D1(hexs[7:4]),
        .D2(hexs[11:8]),
        .D3(hexs[15:12]),
        .Y(HEX)
    );

    Mux4to1 mux_points(
        .S(scan),
        .D0(points[0]),
        .D1(points[1]),
        .D2(points[2]),
        .D3(points[3]),
        .Y(point)
    );

    Mux4to1 mux_LE(
        .S(scan),
        .D0(LEs[0]),
        .D1(LEs[1]),
        .D2(LEs[2]),
        .D3(LEs[3]),
        .Y(LE)
    );

    Mux4to1b4 mux_AN(
        .S(scan),
        .D0(c0),
        .D1(c1),
        .D2(c2),
        .D3(c3),
        .Y(AN)
    );

endmodule


module Mux4to1(
    input  [1:0] S,
    input  D0,
    input  D1,
    input  D2,
    input  D3,
    output reg Y
);

    always @* begin
        case(S)
            2'b00: Y <= D0;
            2'b01: Y <= D1;
            2'b10: Y <= D2;
            2'b11: Y <= D3;
        endcase
    end

endmodule


module Mux4to1b4(
    input  [1:0] S,
    input  [3:0] D0,
    input  [3:0] D1,
    input  [3:0] D2,
    input  [3:0] D3,
    output reg [3:0] Y
);

    always @* begin
    case(S)
        2'b00: Y <= D0;
        2'b01: Y <= D1;
        2'b10: Y <= D2;
        2'b11: Y <= D3;
    endcase
    end

endmodule


module MyMC14495(
    input D0, D1, D2, D3,
    input LE,
    input point,
    output reg p,
    output reg a, b, c, d, e, f, g
);
    
    always @*
        begin
            if(LE == 1'b0) begin
                case ({D3, D2, D1, D0})
                    4'b0000: {a, b, c, d, e, f, g} <= 7'b0000001;      // 0
                    4'b0001: {a, b, c, d, e, f, g} <= 7'b1001111;      // 1
                    4'b0010: {a, b, c, d, e, f, g} <= 7'b0010010;      // 2
                    4'b0011: {a, b, c, d, e, f, g} <= 7'b0000110;      // 3
                    4'b0100: {a, b, c, d, e, f, g} <= 7'b1001100;      // 4
                    4'b0101: {a, b, c, d, e, f, g} <= 7'b0100100;      // 5
                    4'b0110: {a, b, c, d, e, f, g} <= 7'b0100000;      // 6
                    4'b0111: {a, b, c, d, e, f, g} <= 7'b0001111;      // 7
                    4'b1000: {a, b, c, d, e, f, g} <= 7'b0000000;      // 8
                    4'b1001: {a, b, c, d, e, f, g} <= 7'b0000100;      // 9
                    4'b1010: {a, b, c, d, e, f, g} <= 7'b0001000;      // a
                    4'b1011: {a, b, c, d, e, f, g} <= 7'b1100000;      // b
                    4'b1100: {a, b, c, d, e, f, g} <= 7'b0110001;      // c
                    4'b1101: {a, b, c, d, e, f, g} <= 7'b1000010;      // d
                    4'b1110: {a, b, c, d, e, f, g} <= 7'b0110000;      // e
                    4'b1111: {a, b, c, d, e, f, g} <= 7'b0111000;      // f
                endcase
                p = ~point;      // output point
            end else begin
                {a, b, c, d, e, f, g, p} = 8'b11111111;     // unable, all high
            end
        end

endmodule