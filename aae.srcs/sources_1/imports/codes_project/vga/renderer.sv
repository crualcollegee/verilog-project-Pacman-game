// for every grid in input minimap
`define grid_have_dot 2'b11
`define grid_is_empty 2'b00
`define grid_have_wall 2'b01
`define state_ready 2'b00
`define state_gameover 2'b11
`define state_idle 2'b01

module renderer(
    // clock
    input v_sync, // v_sync is used to track the frame
    input clk, rst,
    // from vga_driver
    input rdn,
    input wire [8:0] row_addr,
    input wire [9:0] col_addr,
    // from game
    input wire [1:0] map [0:20] [0:20],
    input wire [8:0] pacman_x, pacman_y, ghost_x, ghost_y,
    input wire [1:0] pacman_direction, ghost_direction,
    input wire [1:0] state,
    input wire [1:0] life_count,
    input wire [15:0] score, // BCD 4 digit game score
    // to vga_driver
    output logic [11:0] data_out
);

//>>>>>>>>>>>>>>>>>>>> ROM SETTING <<<<<<<<<<<<<<<<<<<<//
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> background
// logic [8:0] background_row_addr; // no need for address
// logic [9:0] background_col_addr; // no need for address
wire [11:0] rom_background_data;
rom_background_controller rom_background_controller_inst(
    .clk(clk),
    .row_addr(row_addr),
    .col_addr(col_addr),
    .data(rom_background_data)
);
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> pacman
wire [1:0] pacman_number; // 0 1 2 3 2 1 for a period
cyclic_4_counter c4c_inst(
    .v_sync(v_sync),
    .rst(rst),
    .count(pacman_number)
);
logic [4:0] rom_pacman_row_addr, rom_pacman_col_addr;
wire [11:0] rom_pacman_data;
rom_pacman_controller rom_pacman_controller_inst(
    .clk(clk),
    .direction(pacman_direction),
    .number(pacman_number),
    .row_addr(rom_pacman_row_addr),
    .col_addr(rom_pacman_col_addr),
    .data(rom_pacman_data)
);
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> life icon
logic [4:0] rom_life_row_addr, rom_life_col_addr;
wire [11:0] rom_life_data;
rom_pacman_controller life_icon_inst(
    .clk(clk),
    .direction(2'b11),
    .number(2'b10),
    .row_addr(rom_life_row_addr),
    .col_addr(rom_life_col_addr),
    .data(rom_life_data)
);
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ghost
wire ghost_number;
cyclic_2_counter c2c_inst(
    .v_sync(v_sync),
    .rst(rst),
    .count(ghost_number)
);
logic [4:0] rom_ghost_row_addr, rom_ghost_col_addr; // no need for address
wire [11:0] rom_ghost_data; // no need for address
rom_ghost_controller rom_ghost_controller_inst(
    .clk(clk),
    .direction(ghost_direction),
    .number(ghost_number),
    .row_addr(rom_ghost_row_addr),
    .col_addr(rom_ghost_col_addr),
    .data(rom_ghost_data)
);
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> numbers
wire [11:0] rom_numbers_data;
logic [4:0] rom_numbers_row_addr, rom_numbers_col_addr;
logic [3:0] rom_numbers_number; // 0 to 9
rom_numbers_controller rom_numbers_controller_inst(
    .clk(clk),
    .number(rom_numbers_number),
    .row_addr(rom_numbers_row_addr),
    .col_addr(rom_numbers_col_addr),
    .data(rom_numbers_data)
);
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> dots
logic [4:0] rom_dot_row_addr, rom_dot_col_addr;
wire [11:0] rom_dot_data;
rom_dot_controller rom_dot_controller_inst(
    .clk(clk),
    .row_addr(rom_dot_row_addr),
    .col_addr(rom_dot_col_addr),
    .data(rom_dot_data)
);
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> state
logic [5:0] rom_state_row_addr;
logic [7:0] rom_state_col_addr;
logic rom_state_state; // 0 for ready, 1 for gamover
wire [11:0] rom_state_data;
rom_state_controller rom_state_controller_inst(
    .clk(clk),
    .state(rom_state_state),
    .row_addr(rom_state_row_addr),
    .col_addr(rom_state_col_addr),
    .data(rom_state_data)
);


//>>>>>>>>>>>>>>>>>>>> RENDERING <<<<<<<<<<<<<<<<<<<<//
always @(*) begin
    if(rst) begin
        rom_pacman_col_addr <= 0;
        rom_pacman_row_addr <= 0;
        rom_ghost_col_addr <= 0;
        rom_ghost_row_addr <= 0;
        rom_numbers_col_addr <= 0;
        rom_numbers_row_addr <= 0;
        rom_state_row_addr <= 0;
        rom_state_col_addr <= 0;
        rom_state_state <= 0;
        rom_dot_col_addr <= 0;
        rom_dot_row_addr <= 0;
        data_out <= 0;
    end else
    if(!rdn) begin
        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> is ghost
        if(
            row_addr > 29 &&
            col_addr > 29 &&
            row_addr - 30 > ghost_y - 1 &&
            row_addr - 30 < ghost_y + 20 &&
            col_addr - 30 > ghost_x - 1 &&
            col_addr - 30 < ghost_x + 20 
        ) begin
            rom_ghost_row_addr <= (row_addr - 30) - ghost_y;
            rom_ghost_col_addr <= (col_addr - 30) - ghost_x;
            data_out <= rom_ghost_data;
        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> is pacman
        end else if(
            row_addr > 29 &&
            col_addr > 29 &&
            row_addr - 30 > pacman_y - 1 &&
            row_addr - 30 < pacman_y + 20 &&
            col_addr - 30 > pacman_x - 1 &&
            col_addr - 30 < pacman_x + 20
        ) begin
            rom_pacman_row_addr <= (row_addr - 30) - pacman_y;
            rom_pacman_col_addr <= (col_addr - 30) - pacman_x;
            data_out <= rom_pacman_data;
        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> is dot
        end else if(
            row_addr > 29 &&
            row_addr < 450 &&
            col_addr > 29 &&
            col_addr < 450 && // in map
            map[(row_addr - 30) / 20][(col_addr - 30) / 20] == `grid_have_dot // have dot
        ) begin
            rom_dot_row_addr <= (row_addr - 30) % 20;
            rom_dot_col_addr <= (col_addr - 30) % 20;
            data_out <= rom_dot_data;
        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> is state and have to display
        end else if(
            row_addr > 219 &&
            row_addr < 280 &&
            col_addr > 459 &&
            col_addr < 600 && // in state bar
            state != `state_idle // have to display
        ) begin
            rom_state_row_addr <= row_addr - 220;
            rom_state_col_addr <= col_addr - 460;
            data_out <= rom_state_data;
            if(state == `state_ready) rom_state_state <= 0; // show ready
            else rom_state_state <= 1; // show gameover
        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> is number 
        end else if(
            row_addr > 103 &&
            row_addr < 125 &&
            col_addr > 459 &&
            col_addr < 553 // in number bar
        ) begin
            if(col_addr > 459 && col_addr < 481) begin // first digit
                rom_numbers_row_addr <= row_addr - 104;
                rom_numbers_col_addr <= col_addr - 460;
                rom_numbers_number <= score[11:8];
                data_out <= rom_numbers_data;
            end else if(col_addr > 483 && col_addr < 505) begin // second digit
                rom_numbers_row_addr <= row_addr - 104;
                rom_numbers_col_addr <= col_addr - 484;
                rom_numbers_number <= score[7:4];
                data_out <= rom_numbers_data;
            end else if(col_addr > 507 && col_addr < 529) begin // third dight
                rom_numbers_row_addr <= row_addr - 104;
                rom_numbers_col_addr <= col_addr - 508;
                rom_numbers_number <= score[3:0];
                data_out <= rom_numbers_data;
            end else if(col_addr > 531 && col_addr < 553) begin // fourth digit
                rom_numbers_row_addr <= row_addr - 104;
                rom_numbers_col_addr <= col_addr - 532;
                rom_numbers_number <= 4'b0;
                data_out <= rom_numbers_data;
            end else begin
                data_out <= 12'b0;
            end
        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> is life
        end else if(
            row_addr > 163 &&
            row_addr < 184 &&
            col_addr > 459 &&
            col_addr < 529 // in life bar
        ) begin
            if(col_addr > 459 && col_addr < 480 && life_count > 0) begin // first life
                rom_life_col_addr <= col_addr - 460;
                rom_life_row_addr <= row_addr - 164;
                data_out <= rom_life_data;
            end else if(col_addr > 483 && col_addr < 504 && life_count > 1) begin // second life
                rom_life_col_addr <= col_addr - 484;
                rom_life_row_addr <= row_addr - 164;
                data_out <= rom_life_data;
            end else if(col_addr > 507 && col_addr < 528 && life_count > 2) begin // third life
                rom_life_col_addr <= col_addr - 508;
                rom_life_row_addr <= row_addr - 164;
                data_out <= rom_life_data;
            end else begin
                data_out <= 12'b0;
            end
        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> just show background
        end else begin
            data_out <= rom_background_data;
        end
    end
end


endmodule