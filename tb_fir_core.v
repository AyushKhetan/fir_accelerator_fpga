`timescale 1ns/1ps

module tb_fir_core;

    reg clk;
    reg reset;
    reg valid_in;
    reg signed [15:0] sample_in;

    wire valid_out;
    wire signed [35:0] y;

    integer i;
    integer errors;


    // ============================================================
    // DUT INSTANTIATION
    // ============================================================

    fir_core dut (
        .clk(clk),
        .reset(reset),
        .valid_in(valid_in),
        .sample_in(sample_in),
        .valid_out(valid_out),
        .y(y)
    );


    // ============================================================
    // CLOCK GENERATION
    //
    // Period = 10 ns
    // Frequency = 100 MHz
    // ============================================================

    initial begin
        clk = 1'b0;
    end

    always #5 clk = ~clk;


    // ============================================================
    // TASK: SEND ONE VALID SAMPLE
    //
    // The sample is presented before a rising edge.
    // It is accepted by the DUT at the next rising edge.
    // valid_in is then deasserted at the following falling edge.
    // ============================================================

    task send_sample;

        input signed [15:0] sample;

        begin

            @(negedge clk);

            valid_in  = 1'b1;
            sample_in = sample;


            // DUT accepts sample here

            @(posedge clk);


            // Allow combinational FIR datapath to settle

            #1;


            @(negedge clk);

            valid_in = 1'b0;

        end

    endtask


    // ============================================================
    // TASK: INSERT INVALID CYCLES / BUBBLES
    //
    // sample_in deliberately changes during bubbles.
    //
    // The DUT must ignore these values because valid_in = 0.
    // ============================================================

    task send_bubbles;

        input integer cycles;

        integer j;

        begin

            for (j = 0; j < cycles; j = j + 1) begin

                @(negedge clk);

                valid_in = 1'b0;

                sample_in = 16'sd1000 + j;


                // Wait for the invalid cycle to pass

                @(posedge clk);

            end

        end

    endtask


    // ============================================================
    // MAIN TEST SEQUENCE
    // ============================================================

    initial begin


        // --------------------------------------------------------
        // VCD GENERATION
        // --------------------------------------------------------

        $dumpfile("fir_core.vcd");

        $dumpvars(0, tb_fir_core);


        // --------------------------------------------------------
        // INITIALIZATION
        // --------------------------------------------------------

        reset     = 1'b1;
        valid_in  = 1'b0;
        sample_in = 16'sd0;

        errors = 0;


        // --------------------------------------------------------
        // RESET SEQUENCE
        // --------------------------------------------------------

        repeat (3)
            @(posedge clk);


        @(negedge clk);

        reset = 1'b0;


        // ========================================================
        // TEST 1
        //
        // SEND FIRST 8 VALID SAMPLES
        // ========================================================

        $display("\nSending samples 1 to 8...\n");


        for (i = 1; i <= 8; i = i + 1) begin

            send_sample(i);

        end


        // Window is not yet full.

        if (valid_out !== 1'b0) begin

            $display(
                "ERROR: valid_out asserted before window was full."
            );

            errors = errors + 1;

        end


        // ========================================================
        // TEST 2
        //
        // INSERT BUBBLES BEFORE WINDOW FILL
        //
        // sample_count must not increment.
        //
        // Window must not shift.
        // ========================================================

        $display("\nInserting 4 invalid cycles...\n");


        send_bubbles(4);


        if (valid_out !== 1'b0) begin

            $display(
                "ERROR: valid_out asserted during invalid cycles."
            );

            errors = errors + 1;

        end


        // ========================================================
        // TEST 3
        //
        // SEND SAMPLES 9 TO 15
        //
        // Total valid samples after this = 15.
        // ========================================================

        $display("\nSending samples 9 to 15...\n");


        for (i = 9; i <= 15; i = i + 1) begin

            send_sample(i);

        end


        if (valid_out !== 1'b0) begin

            $display(
                "ERROR: valid_out asserted before 16th valid sample."
            );

            errors = errors + 1;

        end


        // ========================================================
        // TEST 4
        //
        // SEND 16TH SAMPLE EXPLICITLY.
        //
        // This is the first transaction that produces
        // a complete FIR output.
        //
        //
        // Window:
        //
        // s0  = 16
        // s1  = 15
        // s2  = 14
        // ...
        // s15 = 1
        //
        //
        // Coefficients:
        //
        // h0  = 1
        // h1  = 2
        // ...
        // h15 = 16
        //
        //
        // Expected:
        //
        // 16*1 + 15*2 + ... + 1*16
        //
        // = 816
        //
        // ========================================================

        $display("\nSending sample 16...\n");


        @(negedge clk);

        valid_in  = 1'b1;
        sample_in = 16'sd16;


        // Sample 16 accepted here.

        @(posedge clk);


        // Allow combinational datapath to settle.

        #1;


        // --------------------------------------------------------
        // CHECK VALID_OUT
        // --------------------------------------------------------

        if (valid_out !== 1'b1) begin

            $display(
                "ERROR: valid_out not asserted for first complete FIR output."
            );

            errors = errors + 1;

        end

        else begin

            $display(
                "PASS: valid_out asserted for first complete FIR output."
            );

        end


        // --------------------------------------------------------
        // CHECK FIR OUTPUT
        // --------------------------------------------------------

        if (y !== 36'sd816) begin

            $display(
                "ERROR: FIR output incorrect. Expected 816, got %0d",
                y
            );

            errors = errors + 1;

        end

        else begin

            $display(
                "PASS: FIR output correct after window fill. y = %0d",
                y
            );

        end


        // End transaction.

        @(negedge clk);

        valid_in = 1'b0;


        // ========================================================
        // TEST 5
        //
        // INSERT BUBBLES AFTER WINDOW IS FULL.
        //
        // Window must hold its contents.
        //
        // y must remain 816.
        //
        // valid_out must remain LOW because no new output
        // transaction is occurring.
        // ========================================================

        $display("\nTesting bubbles after window fill...\n");


        send_bubbles(3);


        #1;


        if (valid_out !== 1'b0) begin

            $display(
                "ERROR: valid_out asserted during bubbles."
            );

            errors = errors + 1;

        end


        if (y !== 36'sd816) begin

            $display(
                "ERROR: FIR output changed during bubbles. Got %0d",
                y
            );

            errors = errors + 1;

        end

        else begin

            $display(
                "PASS: FIR output held during invalid cycles."
            );

        end


        // ========================================================
        // TEST 6
        //
        // SEND SAMPLE 17.
        //
        // New window:
        //
        // s0  = 17
        // s1  = 16
        // ...
        // s15 = 2
        //
        //
        // Expected:
        //
        // 17*1 + 16*2 + ... + 2*16
        //
        // = 952
        //
        // ========================================================

        $display("\nSending sample 17...\n");


        @(negedge clk);

        valid_in  = 1'b1;
        sample_in = 16'sd17;


        // Sample 17 accepted.

        @(posedge clk);


        // Allow combinational datapath to settle.

        #1;


        // --------------------------------------------------------
        // CHECK VALID_OUT
        // --------------------------------------------------------

        if (valid_out !== 1'b1) begin

            $display(
                "ERROR: valid_out not asserted for sample 17."
            );

            errors = errors + 1;

        end

        else begin

            $display(
                "PASS: valid_out asserted for sample 17."
            );

        end


        // --------------------------------------------------------
        // CHECK FIR OUTPUT
        // --------------------------------------------------------

        if (y !== 36'sd952) begin

            $display(
                "ERROR: FIR output incorrect after sample 17. Expected 952, got %0d",
                y
            );

            errors = errors + 1;

        end

        else begin

            $display(
                "PASS: FIR output correct after sample 17. y = %0d",
                y
            );

        end


        @(negedge clk);

        valid_in = 1'b0;


        // ========================================================
        // TEST 7
        //
        // RESET AFTER NORMAL OPERATION.
        //
        // Verify:
        //
        // valid_out becomes LOW.
        // FIR window clears.
        // y becomes zero.
        // sample counter clears.
        // ========================================================

        $display("\nTesting reset after normal operation...\n");


        @(negedge clk);

        reset = 1'b1;


        @(posedge clk);

        #1;


        if (valid_out !== 1'b0) begin

            $display(
                "ERROR: valid_out not cleared by reset."
            );

            errors = errors + 1;

        end


        if (y !== 36'sd0) begin

            $display(
                "ERROR: FIR output not cleared by reset. y = %0d",
                y
            );

            errors = errors + 1;

        end

        else begin

            $display(
                "PASS: FIR datapath correctly cleared by reset."
            );

        end


        @(negedge clk);

        reset = 1'b0;


        // ========================================================
        // FINAL RESULT
        // ========================================================

        if (errors == 0) begin

            $display(
                "\n============================================"
            );

            $display(
                "ALL FIR STREAMING TESTS PASSED"
            );

            $display(
                "============================================\n"
            );

        end

        else begin

            $display(
                "\n============================================"
            );

            $display(
                "TEST FAILED WITH %0d ERROR(S)",
                errors
            );

            $display(
                "============================================\n"
            );

        end


        $finish;

    end

endmodule