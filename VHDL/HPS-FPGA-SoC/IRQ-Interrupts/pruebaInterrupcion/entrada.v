module entrada (
    input FPGA_CLK1_50,
    input reset,
    input [3:0] switches,
    output avl_irq,
    input  avl_read,
    output [3:0] avl_readdata
);

reg [3:0] cur_inputs;
reg [3:0] last_inputs;
wire [3:0] changed_inputs = cur_inputs ^ last_inputs;

reg irq;

assign avl_irq = irq;
assign avl_readdata = last_inputs;

always @(posedge FPGA_CLK1_50) begin
    if (reset) begin
        cur_inputs <= 4'd0;
        last_inputs <= 4'd0;
        irq <= 1'b0;
    end else begin
        cur_inputs <= switches;
        last_inputs <= cur_inputs;
        if (changed_inputs != 4'd0)
            irq <= 1'b1;
        else if (avl_read)
            irq <= 1'b0;
    end
end

endmodule