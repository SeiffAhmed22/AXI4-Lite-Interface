module axi4_lite_slave #(
    parameter ADDRESS_WIDTH = 32,
    parameter DATA_WIDTH = 32
) (
    // Global Inputs
    input ACLK,
    input ARESETN, // Active low reset

    //Read Address Channel inputs
    input [ADDRESS_WIDTH - 1:0] S_ARADDR,
    input S_ARVALID,

    //Read Address Channel outputs
    output S_ARREADY
);
    
endmodule