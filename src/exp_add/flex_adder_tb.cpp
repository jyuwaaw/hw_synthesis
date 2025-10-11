#include "Vflex_adder.h"       // Include the generated module header
#include "verilated.h"         // Include Verilator's common routines
#include <iostream>

int main(int argc, char **argv) {
    // Initialize Verilator and command-line arguments
    Verilated::commandArgs(argc, argv);

    // Instantiate the module
    Vflex_adder* flex_adder = new Vflex_adder;

    // Set inputs for testing
    flex_adder->p_exp_a = 4;                          // Set precision for act_exp_vector
    flex_adder->p_exp_w = 4;                          // Set precision for weight_exp_vector
    flex_adder->weight_exp_set = 0b000100010010;      // Example value for weight_exp_set
    flex_adder->act_exp_set = 0b000110010100;         // Example value for act_exp_set

    // Evaluate the module to calculate the results
    flex_adder->eval();

    // Print the result for verification
    std::cout << "Exponent Addition Vector: " << std::hex << flex_adder->exponent_addition_vector << std::endl;

    // Clean up
    delete flex_adder;
    return 0;
}