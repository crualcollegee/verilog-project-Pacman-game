module pacman_move (
    input clk,
    input rst,
    input [1:0] state,
    input logic [1:0] keyboard_input,
    input flag,
    output logic [8:0] pacman_x,
    output logic [8:0] pacman_y,
    output logic [15:0] count,
    output logic [1:0] map[0:20][0:20],
    output reg eat,
    output logic [1:0] pacman_direction
);
    
    wire Cout0;
	wire Cout1;
	wire Cout2;
    wire Cout3;
	
	wire [3:0]q0;
	wire [3:0]q1;
	wire [3:0]q2;
    wire [3:0]q3;
 
    reg [7:0] cnt;
    reg out;
    wire [4:0] map_x,map_y;
    wire [4:0] counter_x,counter_y;

    reg [1:0] reg_direction;
    logic [1:0] direction_choice;

    counter x_counter (.clk(clk),.rst(rst),.x(8'b0000001),.out(out),.cnt(cnt));
    BCD_Counter BCD_Counter0(.eat(eat),.Clk(clk),.Rst_n(rst),.Cin(1'b1),.state(state),.Cout(Cout0),.q(q0));
    BCD_Counter BCD_Counter1(.eat(eat),.Clk(clk),.Rst_n(rst),.Cin(Cout0),.state(state),.Cout(Cout1),.q(q1));
    BCD_Counter BCD_Counter2(.eat(eat),.Clk(clk),.Rst_n(rst),.Cin(Cout1),.state(state),.Cout(Cout2),.q(q2));
    BCD_Counter BCD_Counter3(.eat(eat),.Clk(clk),.Rst_n(rst),.Cin(Cout2),.state(state),.Cout(Cout3),.q(q3));

    integer i,j,k,s;
    assign counter_x = (pacman_x + 18)/20;
    assign counter_y = (pacman_y + 18)/20;
    assign map_x = (1+pacman_x)/20;
    assign map_y = (pacman_y+1)/20;
    always @(posedge clk) begin
        if(rst||state==2'b11) begin
            pacman_x <= 9'b000010100; //initial location is (1,1), before mapped is(20,20)
            pacman_y <= 9'b000010100;
            eat <= 0;
            for(i=0;i<21;i=i+1) begin
                for(j=0;j<21;j=j+1) begin
                    map[i][j] <= 2'b11;
                end
            end
            for(i=0;i<21;i=i+1) begin
                map[0][i] <= 1;
                map[20][i] <= 1;
            end
            
            for(i=0;i<21;i=i+1) begin
                map[i][0]<=1;map[i][20]<=1;
            end

            map[1][1]<=0; //initial location of pac man
            //2 5 6 17
            map[1][10]<=1;map[4][10]<=1;map[5][10]<=1;map[16][10]<=1;
            //3
            map[2][2]<=1;map[2][3]<=1;map[2][5]<=1;map[2][6]<=1;map[2][7]<=1;
            map[2][13]<=1;map[2][14]<=1;map[2][15]<=1;map[2][17]<=1;map[2][18]<=1;
            //4
            map[3][2]<=1;map[3][3]<=1;map[3][5]<=1;map[3][6]<=1;map[3][7]<=1;
            map[3][13]<=1;map[3][14]<=1;map[3][15]<=1;map[3][17]<=1;map[3][18]<=1;
            //7
            map[6][2]<=1;map[6][3]<=1;map[6][5]<=1;map[6][8]<=1;map[6][9]<=1;map[6][10]<=1;
            map[6][18]<=1;map[6][17]<=1;map[6][15]<=1;map[6][12]<=1;map[6][11]<=1;
            //8
            map[7][5]<=1;map[7][10]<=1;map[7][15]<=1;
            //9
            map[8][2]<=1;map[8][1]<=1;map[8][5]<=1;map[8][6]<=1;map[8][7]<=1;map[8][10]<=1;
            map[8][19]<=1;map[8][1]<=1;map[8][15]<=1;map[8][13]<=1;map[8][14]<=1; map[8][18]<=1;
            //11
            map[10][2]<=1;map[10][5]<=1;map[10][8]<=1;map[10][9]<=1;
            map[10][10]<=0;
            map[10][18]<=1;map[10][15]<=1;map[10][12]<=1;map[10][11]<=1;
            //12
            map[11][5]<=1;map[11][8]<=1;map[11][15]<=1;map[11][12]<=1;
            map[11][9]<=0;map[11][10]<=0;map[11][11]<=0;
            //13
            map[12][1]<=1;map[12][2]<=1;map[12][5]<=1;map[12][8]<=1;map[12][9]<=1;map[12][10]<=1;
            map[12][19]<=1;map[12][18]<=1;map[12][15]<=1;map[12][12]<=1;map[12][11]<=1;
            //14
            map[13][5]<=1;map[13][15]<=1;
            //15
            map[14][2]<=1;map[14][3]<=1;map[14][8]<=1;map[14][7]<=1;
            map[14][18]<=1;map[14][17]<=1;map[14][12]<=1;map[14][13]<=1;
            //16
            map[15][3]<=1;map[15][5]<=1;map[15][7]<=1;map[15][8]<=1;map[15][10]<=1;
            map[15][17]<=1;map[15][15]<=1;map[15][13]<=1;map[15][12]<=1;
            //18
            map[17][1]<=1;map[17][2]<=1;map[17][5]<=1;map[17][8]<=1;map[17][9]<=1;map[17][10]<=1;
            map[17][19]<=1;map[17][18]<=1;map[17][15]<=1;map[17][12]<=1;map[17][11]<=1;
            //19
            map[18][4]<=1;map[18][5]<=1;map[18][10]<=1;
            map[18][16]<=1;map[18][15]<=1;

        end
        else begin //not reset
            if(flag) begin
                pacman_x <= 9'b000010100; //initial location is (1,1), before mapped is(20,20)
                pacman_y <= 9'b000010100;
            end
            else if(state!=2'b00&&state!=2'b11) begin
                eat <= 0;
                if(out==1) begin
                    direction_choice <= keyboard_input;
                    // map_x <= pacman_x/20;
                    // map_y <= pacman_y/20; //mapping from big one to the 21*21 map
                    // counter_x <= (pacman_x+19)/20;
                    // counter_y <= (pacman_y+19)/20;
                    case(direction_choice) 
                            2'b00 : begin //up
                                if(map[counter_y-1][map_x]==2'b01||map[counter_y-1][counter_x]==2'b01) begin //hit
                                    pacman_x <= pacman_x;
                                    pacman_y <= pacman_y; //don't change the x and y
                                    eat <= 0;
                                    // reg_direction <= 2'b00;
                                end
                                else begin
                                    if(map[counter_y-1][map_x]==2'b11&&map[counter_y-1][counter_x]==2'b00) begin
                                        map[map_y-1][map_x]=2'b00;
                                        eat <= 1;
                                    end
                                    else if(map[counter_y-1][map_x]==2'b00&&map[counter_y-1][counter_x]==2'b11) begin
                                        map[counter_y-1][counter_x]=2'b00;
                                        eat <= 1;
                                    end
                                    else if(map[counter_y-1][map_x]==2'b11&&map[counter_y-1][counter_x]==2'b11) begin
                                        map[counter_y-1][map_x]=2'b00;
                                        map[counter_y-1][counter_x]=2'b00;
                                        eat <= 1;
                                        // pacman_direction <= 2'b00;
                                    end
                                    pacman_x <= pacman_x;
                                    pacman_y <= pacman_y - 1; 
                                    pacman_direction <= 2'b00;
                                end
                                // pacman_direction <= 2'b00;
                            end
                            2'b01 : begin //down
                                if(map[map_y+1][map_x]==2'b01||map[map_y+1][counter_x]==2'b01) begin //hit
                                    pacman_x <= pacman_x;
                                    pacman_y <= pacman_y; //don't change the x and y
                                    eat <= 0;
                                    // reg_direction <= 2'b01;
                                end
                                else begin
                                    if(map[map_y+1][map_x]==2'b11&&map[map_y+1][counter_x]==2'b00) begin
                                        map[map_y+1][map_x]=2'b00;
                                        eat <= 1;
                                    end
                                    else if(map[map_y+1][map_x]==2'b00&&map[map_y+1][counter_x]==2'b11) begin
                                        map[map_y+1][counter_x]=2'b00;
                                        eat <= 1;
                                    end
                                    else if(map[map_y+1][map_x]==2'b11&&map[map_y+1][counter_x]==2'b11) begin
                                        map[map_y+1][map_x]=2'b00;
                                        map[map_y+1][counter_x]=2'b00;
                                        eat <= 1;
                                    end
                                    pacman_x <= pacman_x;
                                    pacman_y <= pacman_y + 1; 
                                    pacman_direction <= 2'b01;
                                end
                                
                            end
                            2'b10 : begin //left
                                if(map[map_y][counter_x-1]==2'b01||map[counter_y][counter_x-1]==2'b01) begin //hit
                                    pacman_x <= pacman_x;
                                    pacman_y <= pacman_y; //don't change the x and y
                                    eat <= 0;
                                    // reg_direction <= 2'b10;
                                end
                                else begin
                                    if(map[map_y][counter_x-1]==2'b11&&map[counter_y][counter_x-1]==2'b00) begin
                                        map[map_y][counter_x-1]=2'b00;
                                        eat <= 1;
                                    end
                                    else if(map[map_y][counter_x-1]==2'b00&&map[counter_y][counter_x-1]==2'b11) begin
                                        map[counter_y][counter_x-1]=2'b00;
                                        eat <= 1;
                                    end
                                    else if(map[map_y][counter_x-1]==2'b11&&map[counter_y][counter_x-1]==2'b11) begin
                                        map[map_y][counter_x-1]=2'b00;
                                        map[counter_y][counter_x-1]=2'b00;
                                        eat <= 1;
                                    end
                                    pacman_x <= pacman_x - 1;
                                    pacman_y <= pacman_y; 
                                    pacman_direction <= 2'b10;
                                end
                                
                            end
                            2'b11 : begin //right
                                if(map[map_y][map_x+1]==2'b01||map[counter_y][map_x+1]==2'b01) begin //hit
                                    pacman_x <= pacman_x;
                                    pacman_y <= pacman_y; //don't change the x and y
                                    eat <= 0;
                                    // reg_direction <= 2'b11;
                                end
                                else begin
                                    if(map[map_y][map_x+1]==2'b11&&map[counter_y][map_x+1]==2'b00) begin
                                        map[map_y][map_x+1]=2'b00;
                                        eat <= 1;
                                    end
                                    else if(map[map_y][map_x+1]==2'b00&&map[counter_y][map_x+1]==2'b11) begin
                                        map[counter_y][map_x+1]=2'b00;
                                        eat <= 1;
                                    end
                                    else if(map[map_y][map_x+1]==2'b11&&map[counter_y][map_x+1]==2'b11) begin
                                        map[map_y][map_x+1]=2'b00;
                                        map[counter_y][map_x+1]=2'b00;
                                        eat <= 1;
                                    end
                                    pacman_x <= pacman_x + 1;
                                    pacman_y <= pacman_y; 
                                    pacman_direction <= 2'b11;
                                end
                                
                            end
                        endcase
                end
            end
        end
    end
    
    assign count = {q3,q2,q1,q0};
endmodule