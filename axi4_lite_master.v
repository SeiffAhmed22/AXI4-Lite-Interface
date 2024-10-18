module axi4_lite_master #(
    parameter ADDRESS_WIDTH = 32,
    parameter DATA_WIDTH = 32
) (
    // Global Inputs
    input ACLK,
    input ARESETN, // Active low reset

    //Read Address Channel inputs
    input M_ARREADY,

    //Read Address Channel outputs
    output [ADDRESS_WIDTH - 1:0] M_ARADDR,
    output M_ARVALID
);
    
endmodule