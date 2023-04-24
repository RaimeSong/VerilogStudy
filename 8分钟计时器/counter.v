//主模块
module counter
(
  input clk,rst,start,
  output	wire  [8:0] led_1,led_2,
  output	reg   [7:0] LED  
);

wire  [7:0]	cnt_Mcarry;
wire	[3:0]	cnt_mcarry;
//例化时钟
devide #
(
	.CNT_MAX(24'd12_000_000)
)
dev(
  .clk(clk), 
  .rst_n(rst), 
  .start(start),
  .cnt_M(cnt_Mcarry) ,
  .cnt_m(cnt_mcarry)
);
//例化数码管
segment seg
(
 .data_in_1(cnt_Mcarry[7:4]),
 .data_in_2(cnt_Mcarry[3:0]),
 .led_1(led_1),
 .led_2(led_2),
);

//LED点亮，亮一个代表一分钟
always @(posedge clk) begin
  case (cnt_mcarry)
    4'b0000 : LED[7:0] <= 8'b11111111;
    4'b0001 : LED[7:0] <= 8'b11111110;
    4'b0010 : LED[7:0] <= 8'b11111100;
    4'b0011 : LED[7:0] <= 8'b11111000;
    4'b0100 : LED[7:0] <= 8'b11110000;
    4'b0101 : LED[7:0] <= 8'b11100000;
    4'b0110 : LED[7:0] <= 8'b11000000;
    4'b0111 : LED[7:0] <= 8'b10000000;
    4'b1000 : LED[7:0] <= 8'b00000000; 
	   default: LED[7:0] <= 8'b11111111;
  endcase
end

endmodule

//分频+计时
module devide #
(
  parameter CNT_MAX = 24'd12_000_000
)
( 
  clk, 
  rst_n, 
  start,
  cnt_M,
  cnt_m
);
  input             clk;
  input             rst_n;
  input			        start;
  output  reg [7:0] cnt_M;   //时间计数器，高4位分，低4位秒
  output  reg	[3:0]	cnt_m;  //分钟计数器，用于控制LED
  
  reg         clk_1hz;
  reg [23:0]  cnt;    //用于计数分频
  reg 				flag;


 //分频 
  always @( posedge clk or negedge rst_n ) 
  begin 
    if ( ~rst_n ) 
      cnt  <=  24'b0;  
    else if ( cnt == ( CNT_MAX-1 ) ) 
            cnt   <= 24'b0;
         else 
            cnt   <=  cnt + 24'b1;   
  end
  
  always @( posedge clk or negedge rst_n ) 
  begin 
    if ( ~rst_n ) 
      clk_1hz <=  1'b0;    
       else if ( cnt == ( CNT_MAX/2 - 1 ) ) 
				    clk_1hz <= 1'b1;
				    else if( cnt == ( CNT_MAX - 1 ) )
					        clk_1hz <= 1'b0;    
  end

 //标志信号
always @(posedge clk or negedge rst_n) 
begin
  if(~rst_n) 
  flag = 1'b0;
  else if(~start) 
	flag = 1'b1;
  else 
   flag = 1'b0;
end
 
//60进制计数
always @(posedge clk_1hz or negedge rst_n) 
begin
  if(~rst_n) 
    begin
    cnt_M     <=   8'b0;
    cnt_m     <=   4'b0;
    end
  else if (flag) 
    begin
     if(cnt_M[3:0]  ==  4'd9) 
      begin 
      cnt_M[3:0]  <=  4'd0;   //个位为9，个位清0
      if(cnt_M[7:4]  ==  4'd5) 
      begin
        cnt_M[7:4]  <=  4'd0;    //十位为5，十位清0
        cnt_m = cnt_m + 1'b1;     //LED多亮一个
      end
      else 
      begin
        cnt_M[7:4] <= cnt_M[7:4] + 1'b1; //十位加一
        cnt_m <= cnt_m;     //LED不变
      end
      end
      else cnt_M[3:0] = cnt_M[3:0] + 1'b1;    //个位加1 
    end
  else cnt_M = cnt_M;
end
  

endmodule

//数码管
module segment(
input   [3:0]   data_in_1,  //十位
input   [3:0]   data_in_2,  //个位
output  [8:0]   led_1,
output  [8:0]   led_2
);

reg   [8:0] seg [9:0] ;

initial 
begin
  seg[0] = 9'b000111111; 	// 0
  seg[1] = 9'b000000110; 	// 1
  seg[2] = 9'b001011011; 	// 2
  seg[3] = 9'b001001111; 	// 3
  seg[4] = 9'b001100110; 	// 4
  seg[5] = 9'b001101101; 	// 5
  seg[6] = 9'b001111101; 	// 6
  seg[7] = 9'b000000111; 	// 7
  seg[8] = 9'b001111111; 	// 8
  seg[9] = 9'b001101111; 	// 9

end

assign led_1 = seg[data_in_1];	//十位
assign led_2 = seg[data_in_2];	//个位


endmodule


