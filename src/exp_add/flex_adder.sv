`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/17/2024 11:06:36 PM
// Design Name: 
// Module Name: FlexAdder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "/users/ugrad/yuhuah2/hw_synthesis/src/exp_add/input_organizer.sv"
`include "/users/ugrad/yuhuah2/hw_synthesis/src/exp_add/exp_add_output_organizer.sv"
//// Modify the path to the above two files according to your directory structure

module flex_adder #(
    parameter EXPONENT_REGISTER_WIDTH = 16,
    parameter PRIMITIVE_LENGTH = 128                // modified for module area simulation
)(
input logic            clk,
input logic            reset,
//input logic     [3:0]  p_exp_a,
//input logic     [3:0]  p_exp_w,
input logic [$clog2(EXPONENT_REGISTER_WIDTH) - 1:0] act_switch [PRIMITIVE_LENGTH - 1:0],
input logic [$clog2(EXPONENT_REGISTER_WIDTH) - 1:0] weight_switch [PRIMITIVE_LENGTH - 1:0],
input logic     [EXPONENT_REGISTER_WIDTH - 1:0]  weight_exp_set,
input logic     [EXPONENT_REGISTER_WIDTH - 1:0]  act_exp_set,
input logic     [PRIMITIVE_LENGTH - 1 : 0] precision_break,
output logic    [PRIMITIVE_LENGTH - 1:0]  exponent_addition_vector

    );
    
 // input organizer module   

logic [PRIMITIVE_LENGTH - 1 : 0] primitive_weights_reg, primitive_weights_wire;
logic [PRIMITIVE_LENGTH - 1 : 0] primitive_acts_reg, primitive_acts_wire;
//logic [3:0] p_exp_max;
//assign p_exp_max = (p_exp_a > p_exp_w)? (p_exp_a):(p_exp_w);


input_organizer #(
        .EXPONENT_REGISTER_WIDTH(EXPONENT_REGISTER_WIDTH),
        .PRIMITIVE_LENGTH(PRIMITIVE_LENGTH)
    ) u_input_organizer (
        .act_switch(act_switch),
        .weight_switch(weight_switch),
        .weight_exp_set(weight_exp_set),
        .act_exp_set(act_exp_set),
        .primitive_weights(primitive_weights_wire),
        .primitive_acts(primitive_acts_wire)
    );

always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        primitive_weights_reg <= '0;
        primitive_acts_reg <= '0;
    end else begin
        primitive_weights_reg <= primitive_weights_wire;
        primitive_acts_reg <= primitive_acts_wire;
    end
end

/* verilator lint_off UNOPTFLAT */
logic [PRIMITIVE_LENGTH - 1:0] s;
logic [PRIMITIVE_LENGTH - 1:0] cout;   
assign s[0] = primitive_weights_reg[0] | primitive_acts_reg[0];
assign cout[0] = primitive_weights_reg[0] & primitive_acts_reg[0];
/* verilator lint_on UNOPTFLAT */

initial begin
    cout = '0;
end
generate
    genvar i;
    for (i = 1; i < PRIMITIVE_LENGTH; i++) begin: full_adder
        logic cin;
        assign cin = (precision_break[i] == 0)? (1'b0):(cout[i - 1]);
        logic a_b_and;
        logic a_b_xor;
        assign a_b_xor = (primitive_weights_reg[i] ^ primitive_acts_reg[i]);
        assign a_b_and = primitive_weights_reg[i] & primitive_acts_reg[i];
        assign s[i] = a_b_xor ^ cin;
        assign cout[i] = (a_b_xor & cin) | a_b_and;
        
    end

endgenerate
//Output Organizer Module

exp_add_output_organizer #(.PRIMITIVE_LENGTH(PRIMITIVE_LENGTH))
            add_output_organizer (
            .s(s), 
            .cout(cout), 
            //.p_exp(p_exp_max), 
            .output_set(exponent_addition_vector)
            );




endmodule
