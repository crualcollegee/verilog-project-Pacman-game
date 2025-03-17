module buzzer_driver(
    input logic clk,
    input logic [5:0] note, // ref to note_freq[]
    input logic rst,
    output logic beep
);

// register and param
logic [31:0] counter;
integer threshold;

parameter CLK_FREQ = 100_000_000;

integer note_freq [0:47] = {
  // C,   C#,  D,   D#,  E,   F,   F#,  G,   G#,  A,   A#,  B
    131, 139, 147, 156, 165, 175, 185, 196, 208, 220, 233, 247, // C3 - B3
    262, 277, 294, 311, 330, 349, 370, 392, 415, 440, 466, 494, // C4 - B4
    523, 554, 587, 622, 659, 698, 740, 784, 831, 880, 932, 988, // C5 - B5
    1047, 1109, 1175, 1245, 1319, 1397, 1480, 1568, 1661, 1760, 1865, 1976  // C6 - B6
};


always @(posedge clk or posedge rst) begin
    if(rst) begin
        counter <= 0;
        beep <= 0;
    end else begin
        if(note < 48) begin // valid note
            threshold <= CLK_FREQ / (2 * note_freq[note]);
            // counter imp
            if(counter >= threshold) begin
                counter <= 0;
                beep = ~beep;
            end else begin
                counter <= counter + 1;
            end
        end else begin // invalid note, or stop
            threshold <= 0; // stop buzzer
            beep <= 0;
        end
    end
end

endmodule