module rom_ghost_controller(
    input clk, number,
    input wire [1:0] direction,
    input wire [4:0] row_addr, col_addr,
    output wire [11:0] data
);

wire [11:0] rom_addr;
assign rom_addr = direction * 800 + number * 400 + row_addr * 20 + col_addr;

rom_ghost_12_8_20_20 inst(
    .clka(clk),
    .addra(rom_addr),
    .douta(data)
);

endmodule