// define the notes and their index
`define C3 0
`define C_3 1
`define D3 2
`define D_3 3
`define E3 4
`define F3 5
`define F_3 6
`define G3 7
`define G_3 8
`define A3 9
`define A_3 10
`define B3 11
`define C4 12
`define C_4 13
`define D4 14
`define D_4 15
`define E4 16
`define F4 17
`define F_4 18
`define G4 19
`define G_4 20
`define A4 21
`define A_4 22
`define B4 23
`define C5 24
`define C_5 25
`define D5 26
`define D_5 27
`define E5 28
`define F5 29
`define F_5 30
`define G5 31
`define G_5 32
`define A5 33
`define A_5 34
`define B5 35
`define C6 36
`define C_6 37
`define D6 38
`define D_6 39
`define E6 40
`define F6 41
`define F_6 42
`define G6 43
`define G_6 44
`define A6 45
`define A_6 46
`define B6 47
`define empty 48 // rest note

/***********
* About music selection:
* 0: idle
* 1: startup music
* 2: slow music
* 3: fast music
* 4: gameover music
*/

`define IDLE 3'b000
`define STARTUP 3'b001
`define SLOW 3'b010
`define FAST 3'b011
`define GAMEOVER 3'b100

module buzzer_sync(
    input logic [2:0] music_selection,
    input logic eat_fruit,
    input logic rst,
    input logic clk_ms,
    output logic [5:0] note
);

// start up music
integer startup_time = 4352; // ms
integer startup_note_time = 68; // ms
integer startup [0:63] = {
    `C5, `empty,  `C6, `empty, `G5, `empty, `E5, `empty, `C6, `G5, `E5, `empty, `E5, `E5, `E5, `empty,
    `C_5, `empty, `C_6, `empty, `G_5, `empty, `F5, `empty, `C_6, `G_5, `F5, `empty, `F5, `F5, `F5, `empty,
    `C5, `empty, `C_6, `empty, `G5, `empty, `E5, `empty, `C6, `G5, `E5, `empty, `E5, `E5, `E5, `empty,
    `D_5, `E5, `F5, `empty, `F5, `F_5, `G5, `empty, `G5, `G_5, `A5, `empty, `C6, `empty, `empty, `empty
};

// gameover music
integer gameover_time = 2176; // ms
integer gameover_note_time = 136; // ms
integer gameover [0:15] = {
    `D6, `empty, `C_6, `empty, `C6, `empty, `B5, `empty, `A_5, `empty, `D_3, `empty, `D_3, `empty, `empty, `empty
};

// slow music
integer slow_time = 374; // ms
integer slow_note_time = 17; // ms
integer fast_time = 220; // ms
integer fast_note_time = 10; // ms
integer slow_and_fast [0:21] = {
    `B4, `C5, `C_5, `D5, `D_5, `E5, `F5, `F_5, `G5, `G_5, `A5,
    `A_5, `A5, `G_5, `G5, `F_5, `F5, `E5, `D_5, `D5, `C_5, `C5
};

// eat music
integer eat_time = 200; // ms
integer eat_note_time = 25; // ms
integer eat [0:7] = {
    `C_5, `F_5, `A5, `empty, `B5, `F5, `A_4, `empty
};

logic [2:0] music_state;
integer counter;
logic eat_state;
logic eat_state_reg;
integer eat_counter;

always @(posedge clk_ms or posedge rst) begin
    // reset
    if(rst) begin
        music_state <= `IDLE; // set idle
        counter <= 0;
        eat_state <= 0; // not eating
        note <= `empty; // no sound
        eat_state_reg <= 0;
    // other
    end else if(eat_fruit) begin
        eat_state <= 1;
    end else begin
        // eat
        if(eat_state) begin // Eating state
            if(eat_counter < eat_time) begin
                note <= eat[eat_counter / eat_note_time]; // play the note for this ms
                eat_counter <= eat_counter + 1;
            end else begin
                eat_state <= 0; // stop eating
                eat_counter <= 0;
            end
        // else
        end else begin // Music state
            if(music_state != music_selection) begin
                music_state <= music_selection;
                counter <= 0;
            end else begin
                counter <= counter + 1;
                case(music_state)
                    `IDLE: note <= `empty; // idle, no sound
                    `STARTUP: begin
                        if(counter < startup_time) begin
                            note <= startup[counter / startup_note_time]; // play the note for this ms
                        end else begin
                            music_state <= `IDLE; // set idle
                            counter <= 0; // reset counter
                        end
                    end
                    `GAMEOVER: begin
                        if(counter < gameover_time) begin
                            note <= gameover[counter / gameover_note_time]; // play the note for this ms
                        end else begin
                            music_state <= `IDLE; // set idle
                            counter <= 0;
                        end
                    end
                    `SLOW: begin
                        if(counter >= slow_time) counter <= 0;
                        note <= slow_and_fast[counter / slow_note_time]; // play the note for this ms
                    end
                    `FAST: begin
                        if(counter >= fast_time) counter <= 0;
                        note <= slow_and_fast[counter / fast_note_time]; // play the note for this ms
                    end
                    default: begin
                        music_state <= `IDLE; // set idle if invalid input
                        counter <= 0;
                    end
                endcase
            end
        end
    end
end

endmodule