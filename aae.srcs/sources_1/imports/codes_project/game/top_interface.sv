module game_interface (
    input clk,rst,
    input reg [1:0] keyboard_input,
    input space,
    output logic [8:0] pacman_x,
    output logic [8:0] pacman_y,
    output logic [1:0] state, //00: before start; 01:game start; 10:eat dot; 11: game over
    output logic [15:0] score,
    output logic [8:0] devil_x,
    output logic [8:0] devil_y,
   output reg [1:0] map[0:20][0:20],
    output reg eat,
    output reg [2:0] music_selection,
    output reg [1:0] life_count,
    output reg [1:0] pacman_direction,
    output reg [1:0] ghost_direction
);
    //  reg [1:0] map[20:0][20:0]; 
    wire clk_1ms;
//    reg [1:0] map1[20:0][20:0];
    clk_1ms clk_inst (.clk(clk),.clk_1ms(clk_1ms));
    // Map Map_inst (.reset(rst),.map_node(map));
    pacman_move pacman (.clk(clk_1ms),.rst(rst),.state(state),.keyboard_input(keyboard_input),.pacman_x(pacman_x),.pacman_y(pacman_y),.count(score),.map(map),.eat(eat),.pacman_direction(pacman_direction));
    GhostMovement GhostMovement (.clk_1ms(clk_1ms),.rst(rst),.player_x(pacman_x),.player_y(pacman_y),.map(map),.state(state),.devil_x(devil_x),.devil_y(devil_y),.music(music_selection),.direction_reg(ghost_direction),.life_count(life_count),.score(score));
endmodule