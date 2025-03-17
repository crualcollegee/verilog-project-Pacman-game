module rom_dot_controller(
    input clk,
    input wire [4:0] row_addr, col_addr,
    output wire [11:0] data
);

wire [8:0] rom_addr;
assign rom_addr = row_addr * 20 + col_addr;

rom_dot_12_20_20 inst(
    .clka(clk),
    .addra(rom_addr),
    .douta(data)
);

endmodule