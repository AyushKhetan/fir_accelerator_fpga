module product_engine(
    input signed [15:0] s0,
    input signed [15:0] s1,
    input signed [15:0] s2,
    input signed [15:0] s3,
    input signed [15:0] s4,
    input signed [15:0] s5,
    input signed [15:0] s6,
    input signed [15:0] s7,
    input signed [15:0] s8,
    input signed [15:0] s9,
    input signed [15:0] s10,
    input signed [15:0] s11,
    input signed [15:0] s12,
    input signed [15:0] s13,
    input signed [15:0] s14,
    input signed [15:0] s15,
    input signed [15:0] h0,
    input signed [15:0] h1,
    input signed [15:0] h2,
    input signed [15:0] h3,
    input signed [15:0] h4,
    input signed [15:0] h5,
    input signed [15:0] h6,
    input signed [15:0] h7,
    input signed [15:0] h8,
    input signed [15:0] h9,
    input signed [15:0] h10,
    input signed [15:0] h11,
    input signed [15:0] h12,
    input signed [15:0] h13,
    input signed [15:0] h14,
    input signed [15:0] h15,
    
    output signed [31:0] p0,
    output signed [31:0] p1,
    output signed [31:0] p2,
    output signed [31:0] p3,
    output signed [31:0] p4,
    output signed [31:0] p5,
    output signed [31:0] p6,
    output signed [31:0] p7,
    output signed [31:0] p8,
    output signed [31:0] p9,
    output signed [31:0] p10,
    output signed [31:0] p11,
    output signed [31:0] p12,
    output signed [31:0] p13,
    output signed [31:0] p14,
    output signed [31:0] p15
);

   

    multiplier m0(s0,h0,p0);
    multiplier m1(s1,h1,p1);
    multiplier m2(s2,h2,p2);
    multiplier m3(s3,h3,p3);
    multiplier m4(s4,h4,p4);
    multiplier m5(s5,h5,p5);
    multiplier m6(s6,h6,p6);
    multiplier m7(s7,h7,p7);
    multiplier m8(s8,h8,p8);
    multiplier m9(s9,h9,p9);
    multiplier m10(s10,h10,p10);
    multiplier m11(s11,h11,p11);
    multiplier m12(s12,h12,p12);
    multiplier m13(s13,h13,p13);
    multiplier m14(s14,h14,p14);
    multiplier m15(s15,h15,p15);

endmodule