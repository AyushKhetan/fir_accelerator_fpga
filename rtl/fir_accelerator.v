module fir_accelerator (
    input clk,
    input reset,
    input valid_in,
    input signed [15:0] sample_in,

    output reg valid_out,
    output reg signed [35:0] sample_out
);

    wire core_valid_out;
    wire signed [35:0] core_y;

    fir_core core (
        .clk(clk),
        .reset(reset),
        .valid_in(valid_in),
        .sample_in(sample_in),
        .valid_out(core_valid_out),
        .y(core_y)
    );

    always @(posedge clk) begin
        if (reset) begin
            sample_out <= 36'sd0;
            valid_out  <= 1'b0;
        end
        else begin
            valid_out <= core_valid_out;

            if (core_valid_out)
                sample_out <= core_y;
        end
    end

endmodule
