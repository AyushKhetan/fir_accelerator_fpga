//=============================================================
// Module      : coefficient_bank
// Description : Stores FIR filter coefficients.
//               Currently implemented using constant parameters.
//               Can later be replaced with ROM/RAM without
//               modifying the product engine.
//=============================================================

module coefficient_bank #(

    parameter signed [15:0] H0  = 16'sd1,
    parameter signed [15:0] H1  = 16'sd2,
    parameter signed [15:0] H2  = 16'sd3,
    parameter signed [15:0] H3  = 16'sd4,
    parameter signed [15:0] H4  = 16'sd5,
    parameter signed [15:0] H5  = 16'sd6,
    parameter signed [15:0] H6  = 16'sd7,
    parameter signed [15:0] H7  = 16'sd8,
    parameter signed [15:0] H8  = 16'sd9,
    parameter signed [15:0] H9  = 16'sd10,
    parameter signed [15:0] H10 = 16'sd11,
    parameter signed [15:0] H11 = 16'sd12,
    parameter signed [15:0] H12 = 16'sd13,
    parameter signed [15:0] H13 = 16'sd14,
    parameter signed [15:0] H14 = 16'sd15,
    parameter signed [15:0] H15 = 16'sd16

)(

    output wire signed [15:0] h0,
    output wire signed [15:0] h1,
    output wire signed [15:0] h2,
    output wire signed [15:0] h3,
    output wire signed [15:0] h4,
    output wire signed [15:0] h5,
    output wire signed [15:0] h6,
    output wire signed [15:0] h7,
    output wire signed [15:0] h8,
    output wire signed [15:0] h9,
    output wire signed [15:0] h10,
    output wire signed [15:0] h11,
    output wire signed [15:0] h12,
    output wire signed [15:0] h13,
    output wire signed [15:0] h14,
    output wire signed [15:0] h15

);

    assign h0  = H0;
    assign h1  = H1;
    assign h2  = H2;
    assign h3  = H3;
    assign h4  = H4;
    assign h5  = H5;
    assign h6  = H6;
    assign h7  = H7;
    assign h8  = H8;
    assign h9  = H9;
    assign h10 = H10;
    assign h11 = H11;
    assign h12 = H12;
    assign h13 = H13;
    assign h14 = H14;
    assign h15 = H15;

endmodule