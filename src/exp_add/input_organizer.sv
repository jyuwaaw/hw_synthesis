`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/17/2024 11:05:42 PM
// Design Name: 
// Module Name: lln_mapping_generator
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


module input_organizer #(
    parameter   EXPONENT_REGISTER_WIDTH = 12, parameter PRIMITIVE_LENGTH = 72   
)(
    input logic [$clog2(EXPONENT_REGISTER_WIDTH) - 1:0] act_switch [PRIMITIVE_LENGTH - 1:0],
    input logic [$clog2(EXPONENT_REGISTER_WIDTH) - 1:0] weight_switch [PRIMITIVE_LENGTH - 1:0],
    input logic [EXPONENT_REGISTER_WIDTH - 1:0]    weight_exp_set,
    input logic [EXPONENT_REGISTER_WIDTH - 1:0]    act_exp_set,
    output logic [PRIMITIVE_LENGTH - 1 :0]    primitive_acts,
    output logic [PRIMITIVE_LENGTH - 1 :0]    primitive_weights
    );

    

    generate
        genvar primitive_index;
        for (primitive_index = 0; primitive_index < PRIMITIVE_LENGTH; primitive_index++)begin
            assign primitive_acts[primitive_index] = act_exp_set[act_switch[primitive_index]];
            assign primitive_weights[primitive_index] = weight_exp_set[weight_switch[primitive_index]];
        end
    endgenerate

    

endmodule

