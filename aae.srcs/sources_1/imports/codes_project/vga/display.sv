module display(
    //>>>>> input <<<<<//
    input rst, clk,
    input wire [1:0] map [0:20] [0:20],
    input wire [8:0] pacman_x, pacman_y, ghost_x, ghost_y,
    input wire [1:0] pacman_direction, ghost_direction, state, life_count,
    input wire [15:0] score,
    //>>>>> output <<<<<//
    output wire [3:0] vga_red, vga_green, vga_blue,
    output wire vga_hsync, vga_vsync
);

wire clrn, vga_clk, rdn;
wire [11:0] data;
wire [8:0] row_addr;
wire [9:0] col_addr;
assign clrn = ~rst; // active low

//clkx clkx_inst(
//    .clk(clk),
//    .vga_clk(vga_clk),
//    .reset(rst)
//);

wire [31:0] div_res;
assign vga_clk = div_res[1];

clkdiv clkdiv_inst(
    .clk(clk), .rst(rst), .div_res(div_res)
);

vga_driver vga_driver_inst(
    .vga_clk(vga_clk),
    .d_in(data),
    .clrn(clrn),
    .row_addr(row_addr),
    .col_addr(col_addr),
    .r(vga_red),
    .g(vga_green),
    .b(vga_blue),
    .rdn(rdn),
    .hs(vga_hsync),
    .vs(vga_vsync)
);

renderer renderer_inst(
    //>>>>> input <<<<<//
    .v_sync(vga_vsync),
    .clk(clk),
    .rst(rst),
    .rdn(rdn),
    .row_addr(row_addr),
    .col_addr(col_addr),
    .map(map),
    .pacman_x(pacman_x),
    .pacman_y(pacman_y),
    .ghost_x(ghost_x),
    .ghost_y(ghost_y),
    .pacman_direction(pacman_direction),
    .ghost_direction(ghost_direction),
    .state(state),
    .life_count(life_count),
    .score(score),
    //>>>>> output <<<<<//
    .data_out(data)
);

endmodule

