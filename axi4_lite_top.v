module axi4_lite_top #(
    parameter ADDRESS_WIDTH = 32,
    parameter DATA_WIDTH = 32
) (
    // Global Inputs
    input ACLK,
    input ARESETN, // Active low asynchronous reset

    // Inputs
    input start_read,
    input start_write,
    input [ADDRESS_WIDTH - 1:0] address,
    input [DATA_WIDTH - 1:0] data
);
    
endmodule