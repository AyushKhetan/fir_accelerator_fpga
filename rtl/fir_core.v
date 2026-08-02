// NOTE:
// Current implementation stores coefficients as constant parameters.
// Future versions may replace this with:
//   - ROM ($readmemh)
//   - RAM
//   - AXI-programmable register bank
// without requiring changes to the product engine.

module fir_core(
    input clk,
    input reset,
    input valid_in,
    input signed [15:0] sample_in,

    output reg valid_out,
    output signed [35:0] y
);

    reg [4:0] sample_count;
    reg valid_out_int;

    always @(posedge clk) begin
        if (reset) begin
            sample_count  <= 5'd0;
            valid_out_int <= 1'b0;
            valid_out     <= 1'b0;
        end
        else begin

            // Sample counter
            if (valid_in && (sample_count < 5'd16))
                sample_count <= sample_count + 1'b1;

            // Pipeline the valid signal
            valid_out_int <= valid_in && (sample_count >= 5'd16);
            valid_out     <= valid_out_int;
        end
    end


    wire signed [15:0] s0;
    wire signed [15:0] s1;
    wire signed [15:0] s2;
    wire signed [15:0] s3;
    wire signed [15:0] s4;
    wire signed [15:0] s5;
    wire signed [15:0] s6;
    wire signed [15:0] s7;
    wire signed [15:0] s8;
    wire signed [15:0] s9;
    wire signed [15:0] s10;
    wire signed [15:0] s11;
    wire signed [15:0] s12;
    wire signed [15:0] s13;
    wire signed [15:0] s14;
    wire signed [15:0] s15;

    wire signed [31:0] p0;
    wire signed [31:0] p1;
    wire signed [31:0] p2;
    wire signed [31:0] p3;
    wire signed [31:0] p4;
    wire signed [31:0] p5;
    wire signed [31:0] p6;
    wire signed [31:0] p7;
    wire signed [31:0] p8;
    wire signed [31:0] p9;
    wire signed [31:0] p10;
    wire signed [31:0] p11;
    wire signed [31:0] p12;
    wire signed [31:0] p13;
    wire signed [31:0] p14;
    wire signed [31:0] p15;

    wire signed [15:0] h0;
    wire signed [15:0] h1;
    wire signed [15:0] h2;
    wire signed [15:0] h3;
    wire signed [15:0] h4;
    wire signed [15:0] h5;
    wire signed [15:0] h6;
    wire signed [15:0] h7;
    wire signed [15:0] h8;
    wire signed [15:0] h9;
    wire signed [15:0] h10;
    wire signed [15:0] h11;
    wire signed [15:0] h12;
    wire signed [15:0] h13;
    wire signed [15:0] h14;
    wire signed [15:0] h15;

    window_buffer wb(
        .clk(clk),
        .reset(reset),
        .sample_in(sample_in),
        .valid_in(valid_in),
        .s0(s0),
        .s1(s1),
        .s2(s2),
        .s3(s3),
        .s4(s4),
        .s5(s5),
        .s6(s6),
        .s7(s7),
        .s8(s8),
        .s9(s9),
        .s10(s10),
        .s11(s11),
        .s12(s12),
        .s13(s13),
        .s14(s14),
        .s15(s15)
        );

    coefficient_bank coeff_bank (
        .h0(h0),
        .h1(h1),
        .h2(h2),
        .h3(h3),
        .h4(h4),
        .h5(h5),
        .h6(h6),
        .h7(h7),
        .h8(h8),
        .h9(h9),
        .h10(h10),
        .h11(h11),
        .h12(h12),
        .h13(h13),
        .h14(h14),
        .h15(h15)
    );

    product_engine pe16(
        .s0(s0),
        .s1(s1),
        .s2(s2),
        .s3(s3),
        .s4(s4),
        .s5(s5),
        .s6(s6),
        .s7(s7),
        .s8(s8),
        .s9(s9),
        .s10(s10),
        .s11(s11),
        .s12(s12),
        .s13(s13),
        .s14(s14),
        .s15(s15),
        .h0(h0),
        .h1(h1),
        .h2(h2),
        .h3(h3),
        .h4(h4),
        .h5(h5),
        .h6(h6),
        .h7(h7),
        .h8(h8),
        .h9(h9),
        .h10(h10),
        .h11(h11),
        .h12(h12),
        .h13(h13),
        .h14(h14),
        .h15(h15),
        .p0(p0),
        .p1(p1),
        .p2(p2),
        .p3(p3),
        .p4(p4),
        .p5(p5),
        .p6(p6),
        .p7(p7),
        .p8(p8),
        .p9(p9),
        .p10(p10),
        .p11(p11),
        .p12(p12),
        .p13(p13),
        .p14(p14),
        .p15(p15)
    );

    reduction_tree rt16(
        .p0(p0),
        .p1(p1),
        .p2(p2),
        .p3(p3),
        .p4(p4),
        .p5(p5),
        .p6(p6),
        .p7(p7),
        .p8(p8),
        .p9(p9),
        .p10(p10),
        .p11(p11),
        .p12(p12),
        .p13(p13),
        .p14(p14),
        .p15(p15),
        .clk(clk),
        .reset(reset),
        .y(y)
    );

endmodule


