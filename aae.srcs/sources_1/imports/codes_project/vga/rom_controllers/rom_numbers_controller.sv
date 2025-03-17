module rom_numbers_controller(
    input clk,
    input wire [3:0] number,
    input [4:0] row_addr, col_addr,
    output wire [11:0] data
);

wire [12:0] rom_addr;
assign rom_addr = number * 441 + row_addr * 21 + col_addr;

rom_numbers_12_10_21_21 inst(
    .clka(clk),
    .addra(rom_addr),
    .douta(data)
);

endmodule