module axi4_lite_master #(
    parameter ADDRESS_WIDTH = 32,
    parameter DATA_WIDTH = 32
) (
    // Global Inputs
    input ACLK,
    input ARESETN, // Active low reset

    // Start Signals
    input START_READ,
    input START_WRITE,

    // External ports
    input [ADDRESS_WIDTH - 1:0] address,
    input [DATA_WIDTH - 1:0] data,

    //Read Address Channel
    input M_AXI_ARREADY,
    output [ADDRESS_WIDTH - 1:0] M_AXI_ARADDR,
    output M_AXI_ARVALID,

    // Read Data Channel
    input [DATA_WIDTH - 1:0] M_AXI_RDATA,
    input [1:0] M_AXI_RRESP,
    input M_AXI_RVALID,
    output M_AXI_RREADY,

    // Write Address Channel
    output [ADDRESS_WIDTH - 1:0] M_AXI_AWADDR,
    output M_AXI_AWVALID,
    input M_AXI_AWREADY,

    // Write Data Channel
    output [DATA_WIDTH - 1:0] M_AXI_WDATA,
    output [DATA_WIDTH/8 - 1:0] M_AXI_WSTRB,
    output M_AXI_WVALID,
    input M_AXI_WREADY,

    // Write Response Channel
    input [1:0] M_AXI_BRESP,
    input M_AXI_BVALID,
    output M_AXI_BREADY
);
  localparam    IDLE = 3'b000,
                RADDR_CHANNEL = 3'b001,
                RDATA_CHANNEL = 3'b010,
                WRITE_CHANNEL = 3'b011,
                WRESP_CHANNEL = 3'b100;

  reg current_state, next_state;

  reg start_read, start_write;

  wire write_addr, write_data;
  assign write_addr = (M_AXI_AWVALID && M_AXI_AWREADY);
  assign write_data = (M_AXI_WVALID && M_AXI_WREADY);

  always @(posedge ACLK or negedge ARESETN) begin
    if (!ARESETN) begin
      start_read  <= 0;
      start_write <= 0;
    end else begin
      start_read  <= START_READ;
      start_write <= START_WRITE;
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
        if (start_read) next_state = RADDR_CHANNEL;
        else if (start_write) next_state = WRITE_CHANNEL;
        else next_state = IDLE;
      end
      RADDR_CHANNEL: begin
        if (M_AXI_ARREADY && M_AXI_ARVALID) next_state = RDATA_CHANNEL;
        else next_state = RADDR_CHANNEL;
      end
      RDATA_CHANNEL: begin
        if (M_AXI_RVALID && M_AXI_RREADY) next_state = IDLE;
        else next_state = RDATA_CHANNEL;
      end
      WRITE_CHANNEL: begin
        if (write_addr && write_data) next_state = WRESP_CHANNEL;
        else next_state = WRITE_CHANNEL;
      end
      WRESP_CHANNEL: begin
        if (M_AXI_BVALID && M_AXI_BREADY) next_state = IDLE;
        else next_state = WRESP_CHANNEL;
      end
      default: next_state = IDLE;
    endcase
  end

  // Output Logic
  // Read Address Channel
  assign M_AXI_ARADDR  = (current_state == RADDR_CHANNEL) ? address : 0;
  assign M_AXI_ARVALID = (current_state == RADDR_CHANNEL) ? 1 : 0;

  // Read Data Channel
  assign M_AXI_RREADY  = (current_state == RADDR_CHANNEL || current_state == RDATA_CHANNEL) ? 1 : 0;

endmodule
