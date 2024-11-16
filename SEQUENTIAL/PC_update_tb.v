`include "fetch.v"
`include "decode_writeback.v"
`include "execute.v"
`include "PC_update.v"
`include "memory.v"
module PC_update;
    //inputs
    reg clk;
    reg [63:0]PC;
    //outputs
    wire [3:0] icode,ifun,rA,rB;
    wire signed[63:0] valc;
    wire  [63:0]valP,PC_new;
    wire mem_error,invalid_instr;
    reg [7:0] instr_memory[0:255];//memory that contains all the instructions
    reg [0:79] instr; //instruction with 10bytes
    wire signed [63:0]valA,valB,valE;
    wire signed [63:0]valM=34;
    wire[2:0]cc_out;
    wire cnd;
    reg [2:0]cc_in;
    wire signed[63:0] reg_f0,reg_f1,reg_f2,reg_f3,reg_f4,reg_f5,reg_f6,reg_f7,reg_f8,reg_f9,reg_f10,reg_f11,reg_f12,reg_f13,reg_f14;

    

/////////////////////////////////////////////////////////////////////////////////////////
fetch fetch_call(clk,icode,ifun,rA,rB,valc,valP,PC,invalid_instr,mem_error,halt,instr);
/////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
decode decode_call(clk, icode, rA, rB,
              reg_f0,reg_f1,reg_f2,reg_f3,reg_f4,reg_f5,reg_f6,reg_f7,reg_f8,reg_f9,reg_f10,reg_f11,reg_f12,reg_f13,reg_f14,
              valA,valB,cnd,valM,valE);
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////




//////////////////////////////////////////////////////////////
execute execute_call(clk,icode,ifun,valA,valB,valc,valE,cnd,cc_out,cc_in);
/////////////////////////////////////////////////////////////


always @(posedge clk)begin 
    if(icode == 4'h6)begin cc_in <= cc_out;end
end

//////////////////////////////////////////////////////////////////
memory memory_call(clk,icode,valA,valP,valE,valM,m_module_error);
/////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////
pc_update pc_update_call(clk,icode,cnd,valc,valM,valP,PC_new);
//////////////////////////////////////////////////////////////

always @(PC) begin
    instr = {instr_memory[PC],instr_memory[PC+1],instr_memory[PC+2],
            instr_memory[PC+3],instr_memory[PC+4],instr_memory[PC+5],
            instr_memory[PC+6],instr_memory[PC+7],instr_memory[PC+8],
            instr_memory[PC+9]};  
end

always@(icode) begin 
    if(halt == 1)begin
        $finish; //stops the program if halt is encountered
    end
end
always@(mem_error) begin 
    if(mem_error == 1)begin
        $display("memory full...so halting the program\n");
        $finish;
    end
end
always@(invalid_instr) begin 
    if(invalid_instr == 1)begin
        $display("warning you have given an invald instruction so we will move to the next instruction now automatically pc is updated\nnow PC = %d",PC+1,"\n");
        PC = PC +1;
    end
end
always #10 begin clk = ~clk; end //updating clk for 10ns
always @(*) begin PC<=PC_new; end // updating PC so that new pc value is updated

initial begin//first initialisations
    $dumpfile("PC_update.vcd");
    $dumpvars(0, PC_update);
    clk = 0;
    PC = 64'd0;

end

always @(posedge clk)begin $display("PC = %d clk=%d icode=%h ifun=%h rA=%d rB=%d,valc=%d,valP=%d,valA = %d and valB = %d\nvalE = %d valM = %d\nccodes OF,SF,ZF cc_in = %b || cc_out=%b and cnd = %b\n",PC,clk,icode,ifun,rA,rB,valc,valP,valA,valB,valE,valM,cc_in,cc_out,cnd); end
// always @(posedge clk)begin $display( "ccodes ZF,SF,OF cc_in = %b || cc_out=%b and cnd = %b\n",cc_in,cc_out,cnd );end
initial begin
    cc_in = 3'd0;
   instr_memory[0]  = 8'h10; //nop pc = 1

    instr_memory[1] = 8'h20; //rrmovq
    instr_memory[2]  = 8'h01; //ra = 0 and rb =1 and pc = pc + 2 = 3

    instr_memory[3]  = 8'h30; //irmovq
    instr_memory[4]  = 8'h02; //F and rb = 2
    instr_memory[5]  = 8'hFF; //8bytes
    instr_memory[6]  = 8'hFF;
    instr_memory[7]  = 8'hFF;
    instr_memory[8]  = 8'hFF;
    instr_memory[9]  = 8'hFF;
    instr_memory[10]  = 8'hFF;
    instr_memory[11]  = 8'hFF;
    instr_memory[12]  = 8'hFF; //pc = pc +10 = 13

    instr_memory[13]  = 8'h61; //opq add
    instr_memory[14]  = 8'h23; //ra and rb pc = pc +2  = 15   

    instr_memory[15]  = 8'h70; //jmp
    instr_memory[16]  = 8'h00; //8bytes address
    instr_memory[17]  = 8'h00;
    instr_memory[18]  = 8'h00;
    instr_memory[19]  = 8'h00;
    instr_memory[20]  = 8'h00;
    instr_memory[21]  = 8'h00;
    instr_memory[22]  = 8'h11;
    instr_memory[23]  = 8'h10; //pc = pc+9 = 24

    instr_memory[24]  = 8'h80; //call
    instr_memory[25]  = 8'h00;//8byte destination
    instr_memory[26]  = 8'h00;
    instr_memory[27]  = 8'h00;
    instr_memory[28]  = 8'h10;
    instr_memory[29]  = 8'h00;
    instr_memory[30]  = 8'h00;
    instr_memory[31]  = 8'h00;
    instr_memory[32]  = 8'h01; //pc = pc+9 = 33
    
    instr_memory[33]  = 8'h90;//return and pc = pc+1 = 34; 
    
    instr_memory[34]  = 8'hA0; //pushq
    instr_memory[35]  = 8'h30; //ra and rb pc = pc+2 = 36

    instr_memory[36]  = 8'hB0; //popq
    instr_memory[37]  = 8'h30; //ra and rb pc = pc+2 = 38

    instr_memory[38]  = 8'hC0; //invalid instruction

    instr_memory[39]  = 8'hB0; //popq
    instr_memory[40]  = 8'h30; //ra and rb pc = pc+2 = 38

    
    
    instr_memory[41]  = 8'h60; //opq sub
    instr_memory[42]  = 8'h9A; //ra and rb pc = pc +2  = 15

    instr_memory[43] = 8'h10; //nop

    instr_memory[44] = 8'h10; //nop
    instr_memory[45] = 8'h10; //nop

    // instr_memory[44]  = 8'h63; //opq add
    // instr_memory[45]  = 8'h56;

    instr_memory[46]  = 8'h00; //halt
    
    
end
    
endmodule   