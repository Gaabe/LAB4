module sram_control (
	// Inputs
	clk,
	reset,

	addrChange,
	address,
	byteenable,
	read,
	write,
	writedata,

	// Bi-Directional
	SRAM_DQ,

	// Outputs
	readdata,
	readdatavalid,

	SRAM_ADDR,
	SRAM_LB_N,
	SRAM_UB_N,
	SRAM_CE_N,
	SRAM_OE_N,
	SRAM_WE_N	
);


/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/


/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/
// Inputs
input						clk;
input						reset;
input						addrChange;
input			[19: 0]	address;

input			[ 1: 0]	byteenable;
input						read;
input						write;
input			[15: 0]	writedata;

// Bi-Directional
inout			[15: 0]	SRAM_DQ;		// SRAM Data bus 16 Bits

// Outputs
output reg	[15: 0]	readdata;
output reg				readdatavalid;

output reg	[19: 0]	SRAM_ADDR;		// SRAM Address bus 18 Bits
output reg				SRAM_LB_N;		// SRAM Low-byte Data Mask 
output reg				SRAM_UB_N;		// SRAM High-byte Data Mask 
output reg				SRAM_CE_N;		// SRAM Chip chipselect
output reg				SRAM_OE_N;		// SRAM Output chipselect
output reg				SRAM_WE_N;		// SRAM Write chipselect

/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/

// Internal Registers
reg						is_read;
reg						is_write;
reg			[15: 0]	writedata_reg;
reg						validatingData_aux;

/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/

// Output Registers
always @(posedge clk)
begin
	readdata			<= SRAM_DQ;
	readdatavalid	<= (is_read && addrChange);
	
	SRAM_ADDR 		<= address;
	SRAM_LB_N		<= ~(byteenable[0] & (read | write));
	SRAM_UB_N		<= ~(byteenable[1] & (read | write));
	SRAM_CE_N		<= ~(read | write);
	SRAM_OE_N		<= ~read;
	SRAM_WE_N		<= ~write;
	
end

// Internal Registers
always @(posedge clk)
begin
	if (reset)
		is_read		<= 1'b0;
	else
		is_read		<= read;
end

always @(posedge clk)
begin
	if (reset)
		is_write		<= 1'b0;
	else
		is_write		<= write;
end

always @(posedge clk)
begin
	writedata_reg	<= writedata;
end

/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/

// Output Assignments
assign SRAM_DQ	= (is_write) ? writedata_reg : 16'hzzzz;

// Internal Assignments

/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/


endmodule
