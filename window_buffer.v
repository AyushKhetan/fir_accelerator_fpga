module window_buffer(
    input clk,
    input reset,
    input signed [15:0] sample_in,
    input valid_in,

    output reg signed [15:0] s0,
    output reg signed [15:0] s1,
    output reg signed [15:0] s2,
    output reg signed [15:0] s3,
    output reg signed [15:0] s4,
    output reg signed [15:0] s5,
    output reg signed [15:0] s6,
    output reg signed [15:0] s7,
    output reg signed [15:0] s8,
    output reg signed [15:0] s9,
    output reg signed [15:0] s10,
    output reg signed [15:0] s11,
    output reg signed [15:0] s12,
    output reg signed [15:0] s13,
    output reg signed [15:0] s14,
    output reg signed [15:0] s15
);

    always @(posedge clk) begin
        if (reset) begin
            s0 <= 16'b0;
            s1 <= 16'b0;
            s2 <= 16'b0;
            s3 <= 16'b0;
            s4 <= 16'b0;
            s5 <= 16'b0;
            s6 <= 16'b0;
            s7 <= 16'b0;
            s8 <= 16'b0;
            s9 <= 16'b0;
            s10 <= 16'b0;
            s11 <= 16'b0;
            s12 <= 16'b0;
            s13 <= 16'b0;
            s14 <= 16'b0;
            s15 <= 16'b0;
        end

        else if(valid_in) begin
            s0 <= sample_in;
            s1 <= s0;
            s2 <= s1;
            s3 <= s2;
            s4 <= s3;
            s5 <= s4;
            s6 <= s5;
            s7 <= s6;
            s8 <= s7;
            s9 <= s8;
            s10 <= s9;
            s11 <= s10;
            s12 <= s11;
            s13 <= s12;
            s14 <= s13;
            s15 <= s14;
        end
    end
endmodule