module axi4_lite_master #(
    parameter ADDRESS_WIDTH = 32,
    parameter DATA_WIDTH = 32
) (
    // Global Inputs
    input ACLK,
    input ARESETN, // Active low reset

    // Start Signals
    input start_read,
    input start_write,

    // External ports
    input [ADDRESS_WIDTH - 1:0] address,
    input [DATA_WIDTH - 1:0] data,

    //Read Address Channel
    input M_AXI_ARREADY,
    output reg [ADDRESS_WIDTH - 1:0] M_AXI_ARADDR,
    output reg M_AXI_ARVALID,

    // Read Data Channel
    input [DATA_WIDTH - 1:0] M_AXI_RDATA,
    input [1:0] M_AXI_RRESP,
    input M_AXI_RVALID,
    output reg M_AXI_RREADY,

    // Write Address Channel
    output [ADDRESS_WIDTH - 1:0] M_AXI_AWADDR,
    output M_AXI_AWVALID,
    input M_AXI_AWREADY,

    // Write Data Channel
    output reg [DATA_WIDTH - 1:0] M_AXI_WDATA,
    output reg [DATA_WIDTH/8 - 1:0] M_AXI_WSTRB,

    // Write Response Channel
    input [1:0] M_AXI_BRESP,
    input M_AXI_BVALID,
    output reg M_AXI_BREADY
);
  localparam    IDLE = 3'b000,
                RADDR_CHANNEL = 3'b001,
                RDATA_CHANNEL = 3'b010,
                WRITE_CHANNEL = 3'b011,
                WRESP__CHANNEL = 3'b100;

  reg current_state, next_state;

  always @(posedge ACLK or negedge ARESETN) begin
    if (!ARESETN) current_state <= IDLE;
    else current_state <= next_state;
  end

endmodule