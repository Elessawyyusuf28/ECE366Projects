`timescale 1ns/1ps
module testbench;
    reg [15:0] A, B;
    reg Cin;
    wire [15:0] S;
    wire Cout;
    reg [16:0] expected;
    integer errors;
    KS_16bit DUT(.A(A), .B(B), .Cin(Cin), .S(S), .Cout(Cout));
    task check;
        input [15:0] a, b;
        input cin;
        begin
            A = a;
            B = b;
            Cin = cin;
            #10;
            expected = {1'b0, a} + {1'b0, b} + cin;
            if ({Cout, S} === expected) begin
                $display("PASS: A=%h B=%h Cin=%b Result=%h", a, b, cin, {Cout, S});
            end else begin
                $display("FAIL: A=%h B=%h Cin=%b Expected=%h Got=%h",
                         a, b, cin, expected, {Cout, S});
                errors = errors + 1;
            end
        end
    endtask
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, testbench);
        errors = 0;
        check(16'h0003, 16'h0004, 1'b0);
        check(16'h0003, 16'h0004, 1'b1);
        check(16'h0FFF, 16'h0001, 1'b0);
        check(16'h00FF, 16'h0001, 1'b0);
        check(16'h7FFF, 16'h0001, 1'b0);
        check(16'hFFFF, 16'h0001, 1'b0);
        check(16'hFFFF, 16'h0000, 1'b1);
        check(16'h0009, 16'hFFF7, 1'b1);
        check(16'h0003, 16'hFFFA, 1'b1);
        check(16'hFFFB, 16'h0003, 1'b0);
        check(16'hFFFB, 16'hFFFC, 1'b1);
        check(16'hA55A, 16'h5AA5, 1'b0);
        check(16'h0000, 16'h0000, 1'b0);
        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TESTS FAILED: %0d errors", errors);
        $finish;
    end
endmodule
