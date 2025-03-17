module Map (
    input reset,
    output [1:0] map_node [20:0][20:0]
);
/*
	0:blank(door opened or dot is eaten)
	1:edges
	2:door(when game begin,door open and change to 0)
	3:dot
*/
    reg [1:0] map[20:0][20:0] ;
    integer i,j;
    always @(posedge reset) begin
        // if(reset) begin
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
            map[8][19]<=1;map[8][1]<=1;map[8][15]<=1;map[8][13]<=1;map[8][14]<=1;
            //11
            map[10][2]<=1;map[10][5]<=1;map[10][8]<=1;map[10][9]<=1;
            map[10][10]<=0;
            map[10][18]<=1;map[10][15]<=1;map[10][12]<=1;map[10][11]<=1;
            //12
            map[11][5]<=1;map[11][8]<=1;map[11][15]<=1;map[11][12]<=1;
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
//        end
    end
 genvar k, l;
 generate
     for(k=0;k<21;k=k+1) for(l=0;l<21;l=l+1) assign map_node[k][l]=map[k][l];
 endgenerate
endmodule