module axi4_lite_slave #(
    parameter ADDRESS_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter DATA_DEPTH = 32
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

    // Write Address Channel
    input [ADDRESS_WIDTH - 1:0] S_AXI_AWADDR,
    input S_AXI_AWVALID,
    output S_AXI_AWREADY,

    // Write Data Channel
    input [DATA_WIDTH - 1:0] S_AXI_WDATA,
    input [DATA_WIDTH/8 - 1:0] S_AXI_WSTRB,

    // Write Response Channel
    output reg [1:0] S_AXI_BRESP,
    output reg S_AXI_BVALID,
    input S_AXI_BREADY
);
  localparam    IDLE = 3'b000,
                RADDR_CHANNEL = 3'b001,
                RDATA_CHANNEL = 3'b010,
                WRITE_CHANNEL = 3'b011,
                WRESP_CHANNEL = 3'b100;

  reg current_state, next_state;

  reg [DATA_WIDTH - 1:0] mem[DATA_DEPTH - 1:0];
  reg [ADDRESS_WIDTH - 1:0] address;

  integer i;

  always @(posedge ACLK or negedge ARESETN) begin
    if (!ARESETN) current_state <= IDLE;
    else current_state <= next_state;
  end

  always @(posedge ACLK or negedge ARESETN) begin
    if (!ARESETN) begin
      for (i = 0; i < DATA_DEPTH; i = i + 1) mem[i] <= 0;
    end else begin
      if (current_state == WRITE_CHANNEL) mem[S_AXI_AWADDR] <= S_AXI_WDATA;
      else if (current_state == RADDR_CHANNEL) address <= S_AXI_ARADDR;
    end
  end

endmodule