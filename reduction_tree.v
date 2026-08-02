module reduction_tree(
    input signed [31:0] p0,
    input signed [31:0] p1,
    input signed [31:0] p2,
    input signed [31:0] p3,
    input signed [31:0] p4,
    input signed [31:0] p5,
    input signed [31:0] p6,
    input signed [31:0] p7,
    input signed [31:0] p8,
    input signed [31:0] p9,
    input signed [31:0] p10,
    input signed [31:0] p11,
    input signed [31:0] p12,
    input signed [31:0] p13,
    input signed [31:0] p14,
    input signed [31:0] p15,
    input clk,
    input reset,

    output reg signed [35:0] y
);

    wire signed [32:0] l1_0;
    wire signed [32:0] l1_1;
    wire signed [32:0] l1_2;
    wire signed [32:0] l1_3;
    wire signed [32:0] l1_4;
    wire signed [32:0] l1_5;
    wire signed [32:0] l1_6;
    wire signed [32:0] l1_7;

    reg signed [33:0] l2_0;
    reg signed [33:0] l2_1;
    reg signed [33:0] l2_2;
    reg signed [33:0] l2_3;

    wire signed [34:0] l3_0;
    wire signed [34:0] l3_1;

    assign l1_0 = p0 + p1;
    assign l1_1 = p2 + p3;
    assign l1_2 = p4 + p5;
    assign l1_3 = p6 + p7;
    assign l1_4 = p8 + p9;
    assign l1_5 = p10 + p11;
    assign l1_6 = p12 + p13;
    assign l1_7 = p14 + p15;

    always @(posedge clk) begin
        if(reset) begin
            l2_0 <= 0;
            l2_1 <= 0;
            l2_2 <= 0;
            l2_3 <= 0;
            y <= 0;
        end
        else begin
            l2_0 <= l1_0 + l1_1;
            l2_1 <= l1_2 + l1_3;
            l2_2 <= l1_4 + l1_5;
            l2_3 <= l1_6 + l1_7;
            y <= l3_0 + l3_1;
        end
    end

    assign l3_0 = l2_0 + l2_1;
    assign l3_1 = l2_2 + l2_3;

endmodule