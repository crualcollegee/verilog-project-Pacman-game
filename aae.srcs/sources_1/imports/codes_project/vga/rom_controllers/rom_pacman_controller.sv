module rom_pacman_controller(
    input clk,
    input wire [1:0] direction, number,
    input wire [4:0] row_addr, col_addr,
    output wire [11:0] data
);

wire [12:0] rom_addr;
assign rom_addr = direction * 1600 + number * 400 + row_addr * 20 + col_addr;

rom_pacman_12_16_20_20 inst(
    .clka(clk),
    .addra(rom_addr),
    .douta(data)
);

endmodule