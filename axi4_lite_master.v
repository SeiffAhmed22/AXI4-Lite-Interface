module axi4_lite_master #(
    parameter ADDRESS_WIDTH = 32,
    parameter DATA_WIDTH = 32
) (
    // Global Inputs
    input ACLK,
    input ARESETN, // Active low reset

    //Read Address Channel
    input M_AXI_ARREADY,
    output reg [ADDRESS_WIDTH - 1:0] M_AXI_ARADDR,
    output reg M_AXI_ARVALID,

    // Read Data Channel
    input [DATA_WIDTH - 1:0] M_AXI_RDATA,
    input [1:0] M_AXI_RRESP,
    input M_AXI_RVALID,
    output reg M_AXI_RREADY,

    // Write Data Channel
    output reg [DATA_WIDTH - 1:0] M_AXI_WDATA,
    output reg [DATA_WIDTH/8 - 1:0] M_AXI_WSTRB,

    // Write Response Channel
    input [1:0] M_AXI_BRESP,
    input M_AXI_BVALID,
    output reg M_AXI_BREADY
);
    
endmodule