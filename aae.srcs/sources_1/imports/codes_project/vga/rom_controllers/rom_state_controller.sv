module rom_state_controller(
    input clk,
    input state, // 0 ready, 1 gameover, only calleed when needed
    input wire [5:0] row_addr,
    input wire [7:0] col_addr,
    output wire [11:0] data
);

wire [14:0] rom_addr;
assign rom_addr = state * 8400 + row_addr * 140 + col_addr;

rom_state_12_2_60_140 inst(
    .clka(clk),
    .addra(rom_addr),
    .douta(data)
);

endmodule