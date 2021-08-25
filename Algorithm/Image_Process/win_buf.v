/*============================================
#
# Author: Wcc - 1530604142@qq.com
#
# QQ : 1530604142
#
# Last modified: 2020-07-08 20:02
#
# Filename: win_buffer.v
#
# Description: 
#
============================================*/
`timescale 1ns / 1ps
module win_buf #(
	//==========================================
	//parameter define
	//==========================================
	parameter	KSZ 		= 3			,//卷积核大小
	parameter	IMG_WIDTH 	= 128		,//图像宽度,每个Line_buffer需要缓存的数据量
	parameter	IMG_HEIGHT	= 128		 //图像高度
	)(
	input 	wire 				clk 		,
	input	wire				rst 		,
	input	wire				pi_hs		,
	input	wire				pi_vs		,
	input	wire				pi_de		,
	input	wire				pi_dv		,
	input	wire	[7: 0]		pi_data		,
	//输出图像新有效信号
	output 	wire				po_dv		,
	input	wire				po_hs		,
	input	wire				po_vs		,
	input	wire				po_de		,
	//输出3X3图像矩阵
	output	wire	[8*KSZ*KSZ - 1: 0]		image_matrix			
    );
//==========================================
//internal signals
//==========================================
reg 							frame_flag		;//当前处于一帧图像所在位置

//==========================================
//linebuffer 缓存数据
//==========================================
//KSZ * KSZ 大小的卷积窗口,需要缓存(KSZ - 1行)
wire 	[7:0]	wr_buf_data	[KSZ-2: 0]	;//写入每个buffer的数据
wire 			wr_buf_en  	[KSZ-2: 0]	;//写每个buffer的使能
wire 			full 		[KSZ-2: 0]	;//每个buffer的空满信号
wire 			empty 		[KSZ-2: 0]	;	
wire 	[11:0]	rd_data_cnt [KSZ-2: 0]	;//每个bufeer的内存数据个数
wire			rd_buf_en	[KSZ-2: 0]	;//读出每个buffer的使能信号
wire 	[7:0]	rd_buf_data	[KSZ-2: 0]	;//读出每个buffer的数据
reg 			pop_en 		[KSZ-2: 0]	;//每个buffer可以读出数据信号

reg 			pi_dv_dd [KSZ-2 : 0]	;//输入有效数据延时
wire			line_vld				;//行图像数据有效信号
wire 	[7:0]	in_line_data			;
reg 	[7:0]	pi_data_dd [KSZ-2 : 0]	;
reg 	[1:0]	pi_vs_dd				;
			
reg 	[KSZ-2 : 0]		po_dv_dd				;
reg 	[KSZ-2 : 0]		po_de_dd				;
reg 	[KSZ-2 : 0]		po_hs_dd				;
reg 	[KSZ-2 : 0]		po_vs_dd				;

reg 	[0 : 0]			po_dv_r				;
reg 	[0 : 0]			po_de_r				;
reg 	[0 : 0]			po_hs_r				;
reg 	[0 : 0]			po_vs_r				;

reg 	[12:0]	cnt_col 	;//行列计数器
wire			add_cnt_col	;
wire			end_cnt_col	;
reg 	[12:0]	cnt_row 	;
wire			add_cnt_row	;
wire			end_cnt_row ;

localparam	MATRIX_SIZE = KSZ * KSZ;

//输出列数据延时，形成矩阵
reg		[7:0]	matrix_data	[MATRIX_SIZE - 1: 0];
reg 	[8*KSZ*KSZ - 1: 0]		image_matrix_r	;


assign  image_matrix = image_matrix_r;
assign 	po_dv = po_dv_r;
assign 	po_hs = po_hs_r;
assign 	po_vs = po_vs_r;
assign 	po_de = po_de_r;


//----------------pi_vs_dd------------------
always @(posedge clk) begin
	if (rst==1'b1) begin
		pi_vs_dd <= 'd0;
	end
	else begin
		pi_vs_dd <= {pi_vs_dd[0], pi_vs};
	end
end

//----------------frame_flag------------------
always @(posedge clk) begin
	if (rst==1'b1) begin
		frame_flag <= 1'b0;
	end
	//检测到上升沿，结束上一帧
	else if (pi_vs_dd[0] == 1'b1 && pi_vs_dd[1] == 1'b0) begin
		frame_flag <= 1'b0;
	end
	//检测到下降沿，开始本帧
	else if(pi_vs_dd[0] == 1'b0 && pi_vs_dd[1] == 1'b1) begin
		frame_flag <= 1'b1;
	end
end

//==========================================
//pi_dv_dd
//进行边界的扩充，以3X3的窗口为例,需要在图像的
//外围各边添加一行一列的的空白像素
//若是5X5的窗口，需要在图像的外围各边，添加2行2列
//==========================================
generate
	genvar i;
	//对于KSZ*KSZ的卷积核，每一行需要延时(KSZ-1)拍
	for (i = 0; i < KSZ-1; i = i + 1)
	begin:Expand_the_boundary_dv
		if (i == 0) begin
			always @(posedge clk) begin
				if (rst==1'b1) begin
					pi_dv_dd[i] <= 1'b0;
					pi_data_dd[i] <= 'd0;
				end
				else begin
					pi_dv_dd[i] <= pi_dv;
					pi_data_dd[i] <= pi_data;				
				end
			end
		end
		else begin
			always @(posedge clk) begin
				if (rst==1'b1) begin
					pi_dv_dd[i] <= 1'b0;
					pi_data_dd[i] <= 'd0;
				end
				else begin
					pi_dv_dd[i] <= pi_dv_dd[i - 1];
					pi_data_dd[i] <= pi_data_dd[i - 1];
				end
			end
		end
	end
endgenerate

assign line_vld = pi_dv_dd[KSZ-2] | pi_dv;
assign in_line_data = pi_data_dd[(KSZ>>1) - 1];

//==========================================
//行列计数器
//==========================================
//----------------cnt_col------------------
always @(posedge clk) begin
	if (rst == 1'b1) begin
		cnt_col <= 'd0;
	end
	else if (add_cnt_col) begin
		if(end_cnt_col)
			cnt_col <= 'd0;
		else
			cnt_col <= cnt_col + 1'b1;
	end
	else begin
		cnt_col <= 'd0;
	end
end

assign add_cnt_col = frame_flag == 1'b1 && line_vld == 1'b1;
assign end_cnt_col = add_cnt_col &&	cnt_col == (IMG_WIDTH + KSZ-1) - 1;

//----------------cnt_row------------------
always @(posedge clk) begin
	if (rst == 1'b1) begin
		cnt_row <= 'd0;
	end
	else if (add_cnt_row) begin
		if(end_cnt_row)
			cnt_row <= 'd0;
		else
			cnt_row <= cnt_row + 1'b1;
	end
end

assign add_cnt_row = end_cnt_col == 1'b1 ;
assign end_cnt_row = add_cnt_row &&	cnt_row == IMG_HEIGHT - 1;

//==========================================
//输入到line_buffer,构成对齐的列
//通过例化FIFO的方式,来完成行缓存
//当FIFO缓存有一行数据时，将数据读出，并填充到下一个FIFO中
//==========================================
generate
	genvar j;
	for (j = 0; j < KSZ - 1; j = j + 1)
	begin:multi_line_buffer
		//第一个 line_buffer
		if (j == 0) begin : first_buffer
			//写入第一个line_buffer的数据是从外部输入的数据
			assign wr_buf_data[j] = in_line_data;
			assign wr_buf_en[j] = line_vld;
		end
		//其他line_buffer
		else begin : other_buffer
			//写入其他line_buffer的数据是上一个line_buffer中输出的数据
			assign wr_buf_en[j] = rd_buf_en[j - 1] ;
			assign wr_buf_data[j] = rd_buf_data[j - 1] ;
		end

		//----------------rd_buf_en------------------	
		//从buffer中读出数据
		//pop_en是当前FIFO中已经缓存了一行的图像数据的指示信号
		//wr_buf_en是当前新一行写入的有效数据指示信号
		assign rd_buf_en[j] = pop_en[j] & wr_buf_en[j];

		always @(posedge clk) begin
			if (rst==1'b1) begin
				pop_en[j] <= 0;
			end
			//当前不处于图像有效数据区域
			else if (frame_flag == 1'b0) begin
				pop_en[j] <= 1'b0;
			end
			//当buffer中缓存有一行图像数据时(扩充的图像行)
			else if (rd_data_cnt[j] >= IMG_WIDTH+2) begin
				pop_en[j] <= 1'b1;
			end
		end

		line_buf line_buffer (
		  	.wr_clk(clk),                // input wire wr_clk
		  	.rd_clk(clk),                // input wire rd_clk
		  	.din(wr_buf_data[j]),        // input wire [7 : 0] din
		  	.wr_en(wr_buf_en[j]),        // input wire wr_en
		  	.rd_en(rd_buf_en[j]),                  // input wire rd_en
		  	.dout(rd_buf_data[j]),                    // output wire [7 : 0] dout
		  	.full(full[j]),                    // output wire full
		  	.empty(empty[j]),                  // output wire empty
		  	.rd_data_count(rd_data_cnt[j])  // output wire [11 : 0] rd_data_count
		);	
	end
endgenerate

//==========================================
//得到矩阵中的每一行的第一个数据
//==========================================
generate
	genvar k;
	for (k = 0; k < KSZ; k = k + 1)
	begin:matrix_data_first_col
		if (k == KSZ -1) begin
			//最后一行数据为刚输入的数据
			always @(*) begin
				matrix_data[KSZ * k] = in_line_data;
			end
		end
		else begin
			//从buffer中读取出来的图像书籍
			//以3X3为例，buffer是菊花链的结果
			//最开始输入的数据，在最后一个buffer中被读出
			//最后输入的数据，在第一个buffer中被读出
			always @(*) begin
			 	matrix_data[KSZ * k] = rd_buf_data[(KSZ -2) - k];
			end	
		end
	end
endgenerate
//==========================================
//延时得到矩阵数据
//以3X3为例
//matrix[0]~[2] ==>p13,p12,p11
//matrix[3]~[5] ==>p23,p22,p21
//matrix[6]~[8] ==>p33,p32,p31
//KSZ-1 clk
//==========================================
generate
	genvar r,c;
	for (r = 0; r < KSZ; r = r + 1)
	begin:row
		for (c = 1; c < KSZ; c = c + 1)
		begin:col
			always @(posedge clk) begin
				if (rst==1'b1) begin
					matrix_data[r*KSZ + c] <= 'd0;
				end
				else begin
					matrix_data[r*KSZ + c] <= matrix_data[r*KSZ + (c-1)];
				end
			end
		end
	end
endgenerate

//==========================================
//输出图像矩阵
//以3X3为例
//image_matrix [7:0] ==> p13
//image_matrix [15:8] ==> p12
//image_matrix [23:16] ==> p11
//1 clk
//==========================================
generate
	genvar idx;
	for (idx = 0; idx < KSZ*KSZ; idx = idx + 1)
	begin:out_put_data
		always @(posedge clk) begin
			if (rst==1'b1) begin
				po_dv_r <= 1'b0;
				po_de_r <= 1'b0;
				po_hs_r <= 1'b0;
				po_vs_r <= 1'b0;
				image_matrix_r[8*(idx+1) -1 : 8*(idx)] <= 'd0;
			end
			else begin
				po_dv_r <= po_dv_dd[KSZ-2] & line_vld;
				po_de_r <= po_de_dd[KSZ-2] & line_vld;
				po_hs_r <= po_hs_dd[KSZ-2] ;
				po_vs_r <= po_vs_dd[KSZ-2] ;
				if (po_dv_dd[KSZ-2] & line_vld == 1'b1) begin
					image_matrix_r[8*(idx+1) -1 : 8*(idx)] <= matrix_data[idx];
				end
				else begin
					image_matrix_r[8*(idx+1) -1 : 8*(idx)] <= 'd0;
				end
			end
		end 
	end
endgenerate
//==========================================
//(KSZ-1) clk
//==========================================

always @(posedge clk) begin
	if (rst==1'b1) begin
		po_vs_dd <= 'd0;
		po_hs_dd <= 'd0;
		po_de_dd <= 'd0;
		po_dv_dd <= 'd0;
	end
	else begin
		po_vs_dd <= {po_vs_dd[KSZ-3:0], pi_vs};
		po_hs_dd <= {po_hs_dd[KSZ-3:0], pi_hs};
		po_de_dd <= {po_de_dd[KSZ-3:0], pi_de};
		po_dv_dd <= {po_dv_dd[KSZ-3:0], pi_dv};
	end
end
endmodule
