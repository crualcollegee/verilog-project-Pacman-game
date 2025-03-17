module music(
    input rst, clk,
    input [2:0] music_select,
    input eat,
    output beep
);

wire clk_ms;
wire [5:0] note;

clk_ms_1 clk_ms_inst(
    .clk(clk),
    .clk_ms(clk_ms)
);

buzzer_sync buzzer_sync_inst(
    .clk_ms(clk_ms),
    .rst(rst),
    .eat_fruit(eat),
    .music_selection(music_select),
    .note(note)
);

buzzer_driver buzzer_driver_inst(
    .clk(clk),
    .rst(rst),
    .note(note),
    .beep(beep)
);

endmodule