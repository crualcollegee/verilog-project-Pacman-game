module Pacman_TOP(
    input clk, sw, PS2_clk, PS2_data,
    output wire [3:0] AN,
    output wire beep,
    output wire [3:0] red, green, blue,
    output wire h_sync, v_sync
);

wire rst;

wire [1:0] direction;
wire space;

wire [2:0] music_select;
wire eat;
wire [1:0] map [0:20] [0:20];
wire [8:0] pacman_x, pacman_y, ghost_x, ghost_y;
wire [1:0] pacman_direction, ghost_direction;
wire [1:0] state, life_count;
wire [15:0] score;

sys_rst sys_rst_inst(
    .clk(clk),
    .sw(sw),
    .rst(rst)
);

PS2 PS2_inst(
    .ps2_clk(PS2_clk),
    .ps2_data(PS2_data),
    .rst(rst),
    .clk(clk),
    .direction(direction),
    .space(space)
);

game_interface game_interface_inst(
    // input
    .clk(clk),
    .rst(rst),
    .keyboard_input(direction),
    .space(space),
    // output
    .music_selection(music_select),
    .eat(eat),
    .map(map),
    .pacman_x(pacman_x),
    .pacman_y(pacman_y),
    .pacman_direction(pacman_direction),
    .devil_x(ghost_x),
    .devil_y(ghost_y),
    .ghost_direction(ghost_direction),
    .state(state),
    .life_count(life_count),
    .score(score)
);

music music_inst(
    .clk(clk),
    .rst(rst),
    .music_select(music_select),
    .eat(eat),
    .beep(beep)
);

display display_inst(
    .clk(clk),
    .rst(rst),
    .map(map),
    .pacman_x(pacman_x),
    .pacman_y(pacman_y),
    .pacman_direction(pacman_direction),
    .ghost_x(ghost_x),
    .ghost_y(ghost_y),
    .ghost_direction(ghost_direction),
    .state(state),
    .life_count(life_count),
    .score(score),
    .vga_red(red),
    .vga_green(green),
    .vga_blue(blue),
    .vga_hsync(h_sync),
    .vga_vsync(v_sync)
);

endmodule