`timescale 1ns/1ps
module testbench;
    reg [15:0] A, B;
    reg Cin;
    wire [15:0] S;
    wire Cout;
    integer errors;
    PPA DUT(.A(A), .B(B), .Cin(Cin), .S(S), .Cout(Cout));
    task check;
        input [15:0] test_A, test_B;
        input test_Cin;
        input [15:0] expected_S;
        input expected_Cout;
        begin
            A = test_A;
            B = test_B;
            Cin = test_Cin;
            #10;
            if ({Cout, S} !== {expected_Cout, expected_S}) begin
                errors = errors + 1;
                $display("FAIL: A=%h B=%h Cin=%b | S=%h Cout=%b | expected_S=%h expected_Cout=%b",
                         A, B, Cin, S, Cout, expected_S, expected_Cout);
            end else begin
                $display("PASS: A=%h B=%h Cin=%b | S=%h Cout=%b", A, B, Cin, S, Cout);
            end
        end
    endtask
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, testbench);
        errors = 0;
        check(16'd3, 16'd4, 1'b0, 16'd7, 1'b0);
        check(16'd7, 16'hFFFC, 1'b1, 16'd4, 1'b1);
        check(16'hFFFD, 16'd5, 1'b0, 16'd2, 1'b1);
        check(16'd2, 16'd2, 1'b1, 16'd5, 1'b0);
        check(16'hFFFF, 16'd1, 1'b0, 16'd0, 1'b1);
        check(16'd3, 16'hFFFA, 1'b1, 16'hFFFE, 1'b0);
        check(16'h0FFF, 16'd1, 1'b0, 16'h1000, 1'b0);
        check(16'hFFFF, 16'd0, 1'b1, 16'd0, 1'b1);
        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("%0d TEST(S) FAILED", errors);
        $finish;
    end
endmodule
