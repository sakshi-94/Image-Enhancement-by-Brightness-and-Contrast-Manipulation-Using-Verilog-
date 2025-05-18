module top (
    input HCLK,
    input HRESETn,
    output [7:0] DATA_R0,
    output [7:0] DATA_G0,
    output [7:0] DATA_B0,
    output [7:0] DATA_R1,
    output [7:0] DATA_G1,
    output [7:0] DATA_B1,
    output HSYNC,
    output VSYNC
);

wire ctrl_done;

image_read u_image_read (
    .HCLK(HCLK),
    .HRESETn(HRESETn),
    .VSYNC(VSYNC),
    .HSYNC(HSYNC),
    .DATA_R0(DATA_R0),
    .DATA_G0(DATA_G0),
    .DATA_B0(DATA_B0),
    .DATA_R1(DATA_R1),
    .DATA_G1(DATA_G1),
    .DATA_B1(DATA_B1),
    .ctrl_done(ctrl_done)
);
endmodule

