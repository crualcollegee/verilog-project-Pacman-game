module rom_background_controller(
    input clk,
    input wire [8:0] row_addr,
    input wire [9:0] col_addr,
    output wire [11:0] data
);

wire [18:0] rom_addr;
assign rom_addr = row_addr * 640 + col_addr;

rom_background_12_480_640 inst(
    .clka(clk),
    .addra(rom_addr),
    .douta(data)
);

endmodule