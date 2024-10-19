module axi4_lite_slave #(
    parameter ADDRESS_WIDTH = 32,
    parameter DATA_WIDTH = 32
) (
    // Global Inputs
    input ACLK,
    input ARESETN, // Active low reset

    //Read Address Channel
    input [ADDRESS_WIDTH - 1:0] S_AXI_ARADDR,
    input S_AXI_ARVALID,
    output reg S_AXI_ARREADY,

    // Read Data Channel
    output reg [DATA_WIDTH - 1:0] S_AXI_RDATA,
    output reg [1:0] S_AXI_RRESP,
    output reg S_AXI_RVALID,
    input S_AXI_RREADY,

    // Write Data Channel
    input [DATA_WIDTH - 1:0] S_AXI_WDATA,
    input [DATA_WIDTH/8 - 1:0] S_AXI_WSTRB,

    // Write Response Channel
    output reg [1:0] S_AXI_BRESP,
    output reg S_AXI_BVALID,
    input S_AXI_BREADY
);
    
endmodule