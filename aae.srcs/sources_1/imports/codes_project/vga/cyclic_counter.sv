`define interval 5 // 12 fps

module cyclic_4_counter( // 0 1 2 3 2 1,
    input v_sync, // frame by frame
    input rst,
    output wire [1:0] count
);

logic [1:0] array [0:5] = {
    2'b00, 2'b01, 2'b10, 2'b11, 2'b10, 2'b01
};

logic [3:0] interval_counter; // up to interval = 16
logic [2:0] count_value; // 0 to 5

assign count = array[count_value];

always @(negedge v_sync or posedge rst) begin
    if(rst) begin
        interval_counter <= 0;
        count_value <= 0;
    end else begin
        if(interval_counter == `interval - 1) begin
            interval_counter <= 0;
            count_value <= (count_value + 1) % 6;
        end else begin
            interval_counter <= interval_counter + 1;
        end
    end
end

endmodule

module cyclic_2_counter(
    input v_sync, // frame by frame
    input rst,
    output logic count
);

logic [2:0] inner_counter;

always @(posedge rst or negedge v_sync) begin
    if(rst) begin
        count <= 0;
        inner_counter <= 0;
    end else begin
        if(inner_counter == `interval - 1) begin
            inner_counter <= 0;
            count <= ~count;
        end else begin
            inner_counter <= inner_counter + 1;
        end 
    end
end

endmodule