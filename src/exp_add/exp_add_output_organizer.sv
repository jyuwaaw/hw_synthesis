`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2024 03:18:28 PM
// Design Name: 
// Module Name: add_output_organizer
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


module exp_add_output_organizer #(PRIMITIVE_LENGTH = 72)(
        input logic [PRIMITIVE_LENGTH - 1:0] s, 
        input logic [PRIMITIVE_LENGTH - 1:0] cout, 
        //input logic [3:0] p_exp, 
        output logic [PRIMITIVE_LENGTH - 1:0] output_set

    );
    
    logic [PRIMITIVE_LENGTH - 1:0] overflow_mask;
    assign overflow_mask = ~cout;
    //TODO: Just propagate last cout bits for the remaining bits

    assign output_set = s | overflow_mask;

    /*
    logic [6:0] i;
    
    always_comb begin
        case (p_exp)
            default: output_set = {{(PRIMITIVE_LENGTH - 1){1'b0}}, cout[7],s};
            4'b0001: begin
                for(i = 0; i < PRIMITIVE_LENGTH; i++)begin
                    output_set[2*i +: 2] = {cout[i],s[i]};
                end
            end
            4'b0010: begin
                for(i = 0; i < 2*PRIMITIVE_LENGTH/3; i++)begin
                    output_set[3*i +: 3] = {cout[i+1],s[i+1], s[i]};
                end
            end
            4'b00011: begin
                for(i = 0; i < 2*PRIMITIVE_LENGTH/4; i++)begin
                    output_set[4*i +: 4] = {cout[i+2], s[i+2] ,s[i+1], s[i]};
                end
            end
            4'b0100: begin
                for(i = 0; i < 2*PRIMITIVE_LENGTH/5; i++)begin
                    output_set[5*i +: 5] = {cout[i+3], s[i+3], s[i+2] ,s[i+1], s[i]};
                end
            end
            4'b0101: begin
                for(i = 0; i < 2*PRIMITIVE_LENGTH/6; i++)begin
                    output_set[6*i +: 6] = {cout[i+4], s[i+4], s[i+3], s[i+2] ,s[i+1], s[i]};
                end
            end
            4'b0110: begin
                for(i = 0; i < 2*PRIMITIVE_LENGTH/7; i++)begin
                    output_set[7*i +: 7] = {cout[i+5], s[i+5], s[i+4], s[i+3], s[i+2] ,s[i+1], s[i]};
                end
            end
            4'b0111: begin
                for(i = 0; i < 2*PRIMITIVE_LENGTH/8; i++)begin
                    output_set[8*i +: 8] = {cout[i+6], s[i+6], s[i+5], s[i+4], s[i+3], s[i+2] ,s[i+1], s[i]};
                end
            end
            4'b1000: begin
                for(i = 0; i < 2*PRIMITIVE_LENGTH/9; i++)begin
                    output_set[9*i +: 9] = {cout[i+7], s[i+7], s[i+6], s[i+5], s[i+4], s[i+3], s[i+2] ,s[i+1], s[i]};
                end
            end
            4'b1001: begin
                for(i = 0; i < 2*PRIMITIVE_LENGTH/10; i++)begin
                    output_set[10*i +: 10] = {cout[i+8], s[i+8], s[i+7], s[i+6], s[i+5], s[i+4], s[i+3], s[i+2] ,s[i+1], s[i]};
                end
            end
            4'b1010: begin
                for(i = 0; i < 2*PRIMITIVE_LENGTH/11; i++)begin
                    output_set[11*i +: 11] = {cout[i+9], s[i+9], s[i+8], s[i+7], s[i+6], s[i+5], s[i+4], s[i+3], s[i+2] ,s[i+1], s[i]};
                end
            end
            
        endcase
    
        
    end
    */

    
    
endmodule
