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
    output S_AXI_ARREADY,

    // Read Data Channel
    output [DATA_WIDTH - 1:0] S_AXI_RDATA,
    output [1:0] S_AXI_RRESP,
    output S_AXI_RVALID,
    input S_AXI_RREADY,

    // Write Address Channel
    input [ADDRESS_WIDTH - 1:0] S_AXI_AWADDR,
    input S_AXI_AWVALID,
    output S_AXI_AWREADY,

    // Write Data Channel
    input [DATA_WIDTH - 1:0] S_AXI_WDATA,
    input [DATA_WIDTH/8 - 1:0] S_AXI_WSTRB,
    input S_AXI_WVALID,
    output S_AXI_WREADY,

    // Write Response Channel
    output [1:0] S_AXI_BRESP,
    output S_AXI_BVALID,
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

  wire write_addr, write_data;
  assign write_addr = (S_AXI_AWVALID && S_AXI_AWREADY);
  assign write_data = (S_AXI_WVALID && S_AXI_WREADY);

  integer i;

  always @(posedge ACLK or negedge ARESETN) begin
    if (!ARESETN) begin
      for (i = 0; i < DATA_DEPTH; i = i + 1) mem[i] <= 0;
    end else begin
      if (current_state == WRITE_CHANNEL) mem[S_AXI_AWADDR] <= S_AXI_WDATA;
      else if (current_state == RADDR_CHANNEL) address <= S_AXI_ARADDR;
    end
  end

  // State Memory
  always @(posedge ACLK or negedge ARESETN) begin
    if (!ARESETN) current_state <= IDLE;
    else current_state <= next_state;
  end

  // Next State Logic
  always @(*) begin
    case (current_state)
      IDLE: begin
        if (S_AXI_ARVALID) next_state = RADDR_CHANNEL;
        else if (S_AXI_AWVALID) next_state = WRITE_CHANNEL;
        else next_state = IDLE;
      end
      RADDR_CHANNEL: begin
        if (S_AXI_ARVALID && S_AXI_ARREADY) next_state = RDATA_CHANNEL;
        else next_state = RADDR_CHANNEL;
      end
      RDATA_CHANNEL: begin
        if (S_AXI_RVALID && S_AXI_RREADY) next_state = IDLE;
        else next_state = RDATA_CHANNEL;
      end
      WRITE_CHANNEL: begin
        if (write_addr && write_data) next_state = WRESP_CHANNEL;
        else next_state = WRITE_CHANNEL;
      end
      WRESP_CHANNEL: begin
        if (S_AXI_BVALID && S_AXI_BREADY) next_state = IDLE;
        else next_state = WRESP_CHANNEL;
      end
      default: next_state = IDLE;
    endcase
  end

  // Output Logic
  // Read Address Channel
  assign S_AXI_ARREADY = (current_state == RADDR_CHANNEL) ? 1 : 0;

  // Read Data Channel
  assign S_AXI_RDATA   = (current_state == RDATA_CHANNEL) ? mem[address] : 0;
  assign S_AXI_RRESP   = (current_state == RDATA_CHANNEL) ? 2'b00 : 0;
  assign S_AXI_RVALID  = (current_state == RDATA_CHANNEL) ? 1 : 0;

endmodule
