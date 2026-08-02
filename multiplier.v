module multiplier(
    input  signed [15:0] a,
    input  signed [15:0] b,
    output signed [31:0] p
);

assign p = a * b;
endmodule