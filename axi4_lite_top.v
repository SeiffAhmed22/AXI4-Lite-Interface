module axi4_lite_top #(
    parameter ADDRESS_WIDTH = 32,
    parameter DATA_WIDTH = 32
) (
    // Global Inputs
    input ACLK,
    input ARESETN, // Active low asynchronous reset

    // Inputs
    input START_READ,
    input START_WRITE,
    input [ADDRESS_WIDTH - 1:0] address,
    input [DATA_WIDTH - 1:0] data
);
  // Master AXI signals
  wire [ADDRESS_WIDTH-1:0] master_ARADDR;
  wire master_ARVALID;
  wire master_ARREADY;

  wire [DATA_WIDTH-1:0] master_RDATA;
  wire [1:0] master_RRESP;
  wire master_RVALID;
  wire master_RREADY;

  wire [ADDRESS_WIDTH-1:0] master_AWADDR;
  wire master_AWVALID;
  wire master_AWREADY;

  wire [DATA_WIDTH-1:0] master_WDATA;
  wire [DATA_WIDTH/8-1:0] master_WSTRB;
  wire master_WVALID;
  wire master_WREADY;

  wire [1:0] master_BRESP;
  wire master_BVALID;
  wire master_BREADY;

  // Slave AXI signals
  wire [ADDRESS_WIDTH-1:0] slave_ARADDR;
  wire slave_ARVALID;
  wire slave_ARREADY;

  wire [DATA_WIDTH-1:0] slave_RDATA;
  wire [1:0] slave_RRESP;
  wire slave_RVALID;
  wire slave_RREADY;

  wire [ADDRESS_WIDTH-1:0] slave_AWADDR;
  wire slave_AWVALID;
  wire slave_AWREADY;

  wire [DATA_WIDTH-1:0] slave_WDATA;
  wire [DATA_WIDTH/8-1:0] slave_WSTRB;
  wire slave_WVALID;
  wire slave_WREADY;

  wire [1:0] slave_BRESP;
  wire slave_BVALID;
  wire slave_BREADY;

  // Instantiate the AXI4-Lite Master
  axi4_lite_master #(
      .ADDRESS_WIDTH(ADDRESS_WIDTH),
      .DATA_WIDTH(DATA_WIDTH)
  ) master_inst (
      // Global Inputs
      .ACLK(ACLK),
      .ARESETN(ARESETN),
      .START_READ(START_READ),
      .START_WRITE(START_WRITE),
      .address(address),
      .data(data),

      // Read Address Channel
      .M_AXI_ARREADY(slave_ARREADY),
      .M_AXI_ARADDR (master_ARADDR),
      .M_AXI_ARVALID(master_ARVALID),

      // Read Data Channel
      .M_AXI_RDATA (slave_RDATA),
      .M_AXI_RRESP (slave_RRESP),
      .M_AXI_RVALID(slave_RVALID),
      .M_AXI_RREADY(master_RREADY),

      // Write Address Channel
      .M_AXI_AWADDR (master_AWADDR),
      .M_AXI_AWVALID(master_AWVALID),
      .M_AXI_AWREADY(slave_AWREADY),

      // Write Data Channel
      .M_AXI_WDATA (master_WDATA),
      .M_AXI_WSTRB (master_WSTRB),
      .M_AXI_WVALID(master_WVALID),
      .M_AXI_WREADY(slave_WREADY),

      // Write Response Channel
      .M_AXI_BRESP (slave_BRESP),
      .M_AXI_BVALID(slave_BVALID),
      .M_AXI_BREADY(master_BREADY)
  );

  // Instantiate the AXI4-Lite Slave
  axi4_lite_slave #(
      .ADDRESS_WIDTH(ADDRESS_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .DATA_DEPTH(32)  // Memory depth for the slave
  ) slave_inst (
      // Global Inputs
      .ACLK(ACLK),
      .ARESETN(ARESETN),

      // Read Address Channel
      .S_AXI_ARADDR (master_ARADDR),
      .S_AXI_ARVALID(master_ARVALID),
      .S_AXI_ARREADY(slave_ARREADY),

      // Read Data Channel
      .S_AXI_RDATA (slave_RDATA),
      .S_AXI_RRESP (slave_RRESP),
      .S_AXI_RVALID(slave_RVALID),
      .S_AXI_RREADY(master_RREADY),

      // Write Address Channel
      .S_AXI_AWADDR (master_AWADDR),
      .S_AXI_AWVALID(master_AWVALID),
      .S_AXI_AWREADY(slave_AWREADY),

      // Write Data Channel
      .S_AXI_WDATA (master_WDATA),
      .S_AXI_WSTRB (master_WSTRB),
      .S_AXI_WVALID(master_WVALID),
      .S_AXI_WREADY(slave_WREADY),

      // Write Response Channel
      .S_AXI_BRESP (slave_BRESP),
      .S_AXI_BVALID(slave_BVALID),
      .S_AXI_BREADY(master_BREADY)
  );

endmodule
