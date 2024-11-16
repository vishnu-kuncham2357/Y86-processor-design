`include "ALU_module.v"
`timescale 1ns / 1ps
module ALU_test;
    reg signed [63:0]a;
    reg signed [63:0]b;
    wire signed [63:0]ans;
    wire overflow;
    reg [1:0]control;
    ALU call(control,a,b,ans,overflow);
    initial begin
        $dumpfile("ALU.vcd");
        $dumpvars(0,ALU_test);
        a=64'b0;
		b=64'b0;
        control = 2'b0;
    end
    initial begin
        $monitor("control = %d a=%d b=%d  out=%d  overflow=%b\n",control,a,b,ans,overflow);
        #10 control=2'b00;a=64'b1011;b=64'b0100;
        #10 control=2'b01;a=64'b1011;b=64'b0100;
        #10 control=2'b10;a=64'b1011;b=64'b0100;
        #10 control=2'b11;a=64'b1011;b=64'b0100;
        #10 control=2'b00;a=-64'b1011;b=64'b0100;
        #10 control=2'b01;a=-64'b1011;b=64'b0100;
        #10 control=2'b10;a=-64'b1011;b=64'b0100;
        #10 control=2'b11;a=-64'b1011;b=64'b0100;
        #10 control=2'b00;a=64'b1011;b=-64'b0100;
        #10 control=2'b01;a=64'b1011;b=-64'b0100;
        #10 control=2'b10;a=64'b1011;b=-64'b0100;
        #10 control=2'b11;a=64'b1011;b=-64'b0100;
        #10 control=2'b00;a=-64'b1011;b=-64'b0100;
        #10 control=2'b01;a=-64'b1011;b=-64'b0100;
        #10 control=2'b10;a=-64'b1011;b=-64'b0100;
        #10 control=2'b11;a=-64'b1011;b=-64'b0100;
        #10 control=2'b00;a=64'd2147483647;b=64'd1;
        
        #10 control=2'b01;a=64'd2147483647;b=-64'd1;
        #10 control=2'b01;a=64'b1000000000000000000000000000000000000000000000000000000000000000;b=64'b1000000000000000000000000000000000000000000000000000000000000000;
        #10 control = 2'b01; a = 64'd9223372036854775807; b = -64'd9223372036854775808;

        #10
        control = 2'b01;
        a = 64'b0111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111;
        b = 64'b0111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111;

        #10
        control = 2'b01;
        a = 64'b1000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000;
        b = 64'b1000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000;

        #10
        control = 2'b01;
        a = 64'b0111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111;
        b = 64'b1000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000;

        #10
        control = 2'b01;
        a = 64'b1000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000;
        b = 64'b0111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111;

        #10
        control = 2'b01;
        a = 64'b0101;
        b = 64'b1110;

        
    end
endmodule