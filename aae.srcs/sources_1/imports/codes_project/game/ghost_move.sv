// author: ³Âğ©Ìì
module GhostMovement(
    input clk_1ms,
    input rst,
    input [8:0] player_x,
    input [8:0] player_y,
    input [1:0] map[0:20][0:20],
    output reg[1:0] state,
    output reg[8:0] devil_x,
    output reg[8:0] devil_y,
    output  reg[2:0] music,
    output reg [1:0] direction_reg,
    output reg [1:0] life_count,
    input [15:0] score,
    output reg flag,
    output reg eat
);
reg [30:0]counter;
reg [15:0] score_last;
reg [15:0] score_last_last;
reg ghost_appear;
reg [20:0]cnt_count;
reg [1:0]direction;

reg cnt_mode;
reg [25:0]random;

reg[2:0]last_life_counter;
reg[2:0]last_last_life;


always @(posedge clk_1ms)begin
    if (state==3)begin
        music<=4;
        life_count<=0;
        devil_x<=200;
        devil_y<=220;
    end
    score_last_last<=score_last;
    score_last<=score;
    if (score_last_last==score_last-1) begin
        eat<=1;
    end
    else begin
        eat<=0;
    end
    if (rst)begin
        cnt_count<=0;
        score_last<=0;
        score_last_last<=0;
        music<=1;
        last_life_counter<=3;
        last_last_life<=3;
        state<=0;
        life_count<=3;
        flag<=0;
        devil_x<=200;
        devil_y<=220;
        ghost_appear<=0;
        counter<=0;
        direction_reg<=2;
        random<= 16'hACE1;
    end
    else if (clk_1ms)begin
    last_last_life<=last_life_counter; 
        last_life_counter<=life_count;
        if(last_last_life==last_life_counter+1)begin
            devil_y<=180;
            devil_x<=180;
            if (life_count==0)begin
                state<=3;
                music<=4;
            end
        end
        random<= random ^ (random << 5) ^ (random >> 12)+score+11;
        counter<=counter+1;
        if (counter>410&&!ghost_appear)begin
            state<=1;
            //devil_x<=220;
            //devil_y<=20;
            //devil_y<=180;
            devil_y<=60;
            devil_x<=180;
            ghost_appear<=1;
            music<=2;
        end

        if (ghost_appear==1)begin
            if (cnt_count<10)begin
                cnt_count<=cnt_count+2;
            end
            else begin
                cnt_count<=0;
            end
            if ((player_x-devil_x<20 && player_x-devil_x>0)|| (devil_x -player_x <20 &&devil_x -player_x >0))begin
                if (player_y-devil_y>0)begin
                    if (direction_reg==1)begin
                        if (cnt_count<10)begin
                            cnt_count<=cnt_count+2;
                        end
                        else begin
                            cnt_count<=0;
                        end
                        music<=3;
                    end
                    else begin
                        if (cnt_count<10)begin
                            cnt_count<=cnt_count+1;
                        end
                        else begin
                            cnt_count<=0;
                        end
                        music<=2;
                    end
                end
                else if (devil_y -player_y >0)begin
                    if (direction_reg==0)begin
                        if (cnt_count<10)begin
                            cnt_count<=cnt_count+2;
                        end
                        else begin
                            cnt_count<=0;
                        end
                        music<=3;
                    end
                    else begin
                        if (cnt_count<10)begin
                            cnt_count<=cnt_count+1;
                        end
                        else begin
                            cnt_count<=0;
                        end
                        music<=2;
                    end
                end
            end
            else if (player_y-devil_y<20 && player_y-devil_y>0|| devil_y -player_y <20 &&devil_y -player_y >0)begin
                if (player_x-devil_x>0)begin
                    if (direction_reg==3)begin
                        if (cnt_count<10)begin
                            cnt_count<=cnt_count+2;
                        end
                        else begin
                            cnt_count<=0;
                        end
                        music<=3;
                    end
                    else begin
                        if (cnt_count<10)begin
                            cnt_count<=cnt_count+1;
                        end
                        else begin
                            cnt_count<=0;
                        end
                        music<=2;
                    end
                end
                else if (player_x-devil_x<0)begin
                    if (direction_reg==2)begin
                        if (cnt_count<10)begin
                            cnt_count<=cnt_count+2;
                        end
                        else begin
                            cnt_count<=0;
                        end
                        music<=3;
                    end
                    else begin
                       if (cnt_count<10)begin
                            cnt_count<=cnt_count+1;
                        end
                        else begin
                            cnt_count<=0;
                        end
                        music<=2;
                    end
                end
            end
            if(1)begin
                if (direction_reg==0&&!(map[(devil_y+19)/20-1][devil_x/20]==1))begin
                    devil_y<=devil_y-1;
                end
                else if (direction_reg==1&&!(map[(devil_y/20)+1][devil_x/20]==1))begin
                    devil_y<=devil_y+1;
                end
                else if (direction_reg==2&&!(map[(devil_y/20)][(devil_x+19)/20-1]==1))begin
                    devil_x<=devil_x-1;
                end
                else if (direction_reg==3&&!(map[devil_y/20][(devil_x/20)+1]==1))begin
                    devil_x<=devil_x+1;
                end
                else begin
                    if (map[(devil_y+19)/20-1][devil_x/20]==1&&!(map[(devil_y/20)+1][devil_x/20]==1)&&!(map[(devil_y/20)][(devil_x+19)/20-1]==1)&&!(map[devil_y/20][(devil_x/20)+1]==1))begin
                        if(random%3==0)begin devil_y<=devil_y+1;direction_reg<=1; end 
                        if(random%3==1)begin devil_x<=devil_x+1;direction_reg<=3;end
                        if(random%3==2)begin devil_x<=devil_x-1;direction_reg<=2;end
                    end
                    else if (!(map[(devil_y+19)/20-1][devil_x/20]==1)&&map[(devil_y/20)+1][devil_x/20]==1&&!(map[(devil_y/20)][(devil_x+19)/20-1]==1)&&!(map[devil_y/20][(devil_x/20)+1]==1))begin
                        if(random%3==0)begin devil_y<=devil_y-1;direction_reg<=0;end 
                        if(random%3==1)begin devil_x<=devil_x+1;direction_reg<=3;end
                        if(random%3==2)begin devil_x<=devil_x-1;direction_reg<=2;end
                    end
                    else if(!(map[(devil_y+19)/20-1][devil_x/20]==1)&&!(map[(devil_y/20)+1][devil_x/20]==1)&&map[(devil_y/20)][(devil_x+19)/20-1]==1&&!(map[devil_y/20][(devil_x/20)+1]==1))begin
                        if(random%3==0)begin devil_y<=devil_y+1;direction_reg<=1;end 
                        if(random%3==1)begin devil_y<=devil_y-1;direction_reg<=0;end
                        if(random%3==2)begin devil_x<=devil_x+1;direction_reg<=3;end
                    end
                    else if(!(map[(devil_y+19)/20-1][devil_x/20]==1)&&!(map[(devil_y/20)+1][devil_x/20]==1)&&!(map[(devil_y/20)][(devil_x+19)/20-1]==1)&&map[devil_y/20][(devil_x/20)+1]==1)begin
                        if(random%3==0)begin devil_y<=devil_y+1;direction_reg<=1;end 
                        if(random%3==1)begin devil_y<=devil_y-1;direction_reg<=0;end
                        if(random%3==2)begin devil_x<=devil_x-1;direction_reg<=2;end
                    end
                    else if (map[(devil_y+19)/20-1][devil_x/20]==1&&!(map[(devil_y/20)+1][devil_x/20]==1)&&map[(devil_y/20)][(devil_x+19)/20-1]==1&&!(map[devil_y/20][(devil_x/20)+1]==1))begin
                        if(random%2==0)begin devil_y<=devil_y+1;direction_reg<=1;end 
                        if(random%2==1)begin devil_x<=devil_x+1;direction_reg<=3;end
                    end
                    else if (map[(devil_y+19)/20-1][devil_x/20]==1&&!(map[(devil_y/20)+1][devil_x/20]==1)&&!(map[(devil_y/20)][(devil_x+19)/20-1]==1)&&map[devil_y/20][(devil_x/20)+1]==1)begin
                        if(random%2==0)begin devil_y<=devil_y+1;direction_reg<=1;end 
                        if(random%2==1)begin devil_x<=devil_x-1;direction_reg<=2;end
                    end
                    else if (!(map[(devil_y+19)/20-1][devil_x/20]==1)&&map[(devil_y/20)+1][devil_x/20]==1&&map[(devil_y/20)][(devil_x+19)/20-1]==1&&!(map[devil_y/20][(devil_x/20)+1]==1))begin
                        if(random%2==0)begin devil_y<=devil_y-1;direction_reg<=0;end 
                        if(random%2==1)begin devil_x<=devil_x+1;direction_reg<=3;end
                    end
                    else if (!(map[(devil_y+19)/20-1][devil_x/20]==1)&&map[(devil_y/20)+1][devil_x/20]==1&&!(map[(devil_y/20)][(devil_x+19)/20-1]==1)&&map[devil_y/20][(devil_x/20)+1]==1)begin
                        if(random%2==0)begin devil_y<=devil_y-1;direction_reg<=0;end 
                        if(random%2==1)begin devil_x<=devil_x-1;direction_reg<=2;end
                    end
                end
            end
             if (1) begin
                if (player_x-devil_x<20 && player_x-devil_x>=0|| devil_x -player_x <20 &&devil_x -player_x >=0)begin
                    if (player_y-devil_y<20 && player_y-devil_y>=0|| devil_y -player_y <20 &&devil_y -player_y >=0)begin
                        life_count<=life_count-1; 
                        devil_y<=60;
                        devil_x<=180;
                        flag<=1;
                    end
                    else begin
                        flag<=0;
                    end
               end
               else begin
                    flag<=0;
               end
            end
        end
    end
end
endmodule