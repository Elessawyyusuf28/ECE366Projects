`timescale 1ns/1ps

// ============================================================
// Testbench: Problem 1(a)-(e) and Problem 2(b)
// ============================================================

module testbench;

// 1-bit adder signals
reg A1, B1, Cin1;
wire S_behavioral, Cout_behavioral;
wire S_structural, Cout_structural;

// 4-bit RCA signals
reg [3:0] A_rca, B_rca;
reg Cin_rca;
wire [3:0] S_rca;
wire Cout_rca;

// 4-bit adder/subtractor signals
reg [3:0] A4, B4;
reg Cin4;
wire [3:0] S4;
wire Cout4;

// 32-bit CLA signals
reg [31:0] A32, B32;
reg Cin32;
wire [31:0] S32;
wire Cout32;

integer errors;
integer n;
reg [1:0] expected_one_bit;

one_bit_full_adder_behavioral DUT_A(
    .A(A1), .B(B1), .Cin(Cin1),
    .S(S_behavioral), .Cout(Cout_behavioral)
);

one_bit_full_adder DUT_B(
    .A(A1), .B(B1), .Cin(Cin1),
    .S(S_structural), .Cout(Cout_structural)
);

four_bit_RCA DUT_C(
    .A(A_rca), .B(B_rca), .Cin(Cin_rca),
    .S(S_rca), .Cout(Cout_rca)
);

four_bit_RCA_RCS DUT_D_E(
    .A(A4), .B(B4), .Cin(Cin4),
    .S(S4), .Cout(Cout4)
);

CLA DUT_CLA(
    .A(A32), .B(B32), .Cin(Cin32),
    .S(S32), .Cout(Cout32)
);


// Check the addition-only RCA
task check_rca;
    input [3:0] test_A;
    input [3:0] test_B;
    input test_Cin;
    input [3:0] expected_S;
    input expected_Cout;

    begin
        A_rca = test_A;
        B_rca = test_B;
        Cin_rca = test_Cin;
        #10;

        if ({Cout_rca, S_rca} !==
            {expected_Cout, expected_S}) begin
            errors = errors + 1;
            $display(
                "RCA FAIL: A=%b B=%b Cin=%b S=%b Cout=%b",
                A_rca, B_rca, Cin_rca, S_rca, Cout_rca
            );
        end
        else begin
            $display(
                "RCA PASS: A=%b B=%b Cin=%b S=%b Cout=%b",
                A_rca, B_rca, Cin_rca, S_rca, Cout_rca
            );
        end
    end
endtask


// Problem 1(e): Check the adder/subtractor
task check_four_bit;
    input [3:0] test_A;
    input [3:0] test_B;
    input test_Cin;
    input [3:0] expected_S;
    input expected_Cout;

    begin
        A4 = test_A;
        B4 = test_B;
        Cin4 = test_Cin;
        #10;

        if ({Cout4, S4} !== {expected_Cout, expected_S}) begin
            errors = errors + 1;
            $display(
                "RCA/RCS FAIL: A=%b B=%b Cin=%b S=%b Cout=%b",
                A4, B4, Cin4, S4, Cout4
            );
        end
        else begin
            $display(
                "RCA/RCS PASS: A=%b B=%b Cin=%b S=%b Cout=%b",
                A4, B4, Cin4, S4, Cout4
            );
        end
    end
endtask


// Problem 2(b): Check the CLA
task check_cla;
    input [31:0] test_A;
    input [31:0] test_B;
    input test_Cin;
    input [31:0] expected_S;
    input expected_Cout;

    begin
        A32 = test_A;
        B32 = test_B;
        Cin32 = test_Cin;
        #10;

        if ({Cout32, S32} !== {expected_Cout, expected_S}) begin
            errors = errors + 1;
            $display(
                "CLA FAIL: A=%h B=%h Cin=%b S=%h Cout=%b",
                A32, B32, Cin32, S32, Cout32
            );
        end
        else begin
            $display(
                "CLA PASS: A=%h B=%h Cin=%b S=%h Cout=%b",
                A32, B32, Cin32, S32, Cout32
            );
        end
    end
endtask


initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, testbench);

    errors = 0;

    A1 = 0;
    B1 = 0;
    Cin1 = 0;

    A_rca = 0;
    B_rca = 0;
    Cin_rca = 0;

    A4 = 0;
    B4 = 0;
    Cin4 = 0;

    A32 = 0;
    B32 = 0;
    Cin32 = 0;

    // --------------------------------------------------------
    // Problems 1(a) and 1(b)
    // --------------------------------------------------------

    $display("Testing both 1-bit full adders");

    for (n = 0; n < 8; n = n + 1) begin
        {A1, B1, Cin1} = n[2:0];

        expected_one_bit = {1'b0, A1}
                         + {1'b0, B1}
                         + {1'b0, Cin1};
        #10;

        if (({Cout_behavioral, S_behavioral} !==
             expected_one_bit) ||
            ({Cout_structural, S_structural} !==
             expected_one_bit)) begin
            errors = errors + 1;
            $display(
                "1-BIT FAIL: A=%b B=%b Cin=%b",
                A1, B1, Cin1
            );
        end
        else begin
            $display(
                "1-BIT PASS: A=%b B=%b Cin=%b S=%b Cout=%b",
                A1, B1, Cin1, S_structural, Cout_structural
            );
        end
    end

    // --------------------------------------------------------
    // Problem 1(c)
    // --------------------------------------------------------

    $display("Testing the 4-bit RCA");

    // 3 + 4 = 7
    check_rca(4'b0011, 4'b0100, 1'b0, 4'b0111, 1'b0);

    // 15 + 1 gives a carry
    check_rca(4'b1111, 4'b0001, 1'b0, 4'b0000, 1'b1);

    // 3 + 4 + carry-in = 8
    check_rca(4'b0011, 4'b0100, 1'b1, 4'b1000, 1'b0);

    // --------------------------------------------------------
    // Problem 1(d)
    // --------------------------------------------------------

    $display("Testing addition and subtraction");

    // 7 + 3 = 10
    check_four_bit(4'b0111, 4'b0011, 1'b0,
                   4'b1010, 1'b0);

    // 7 - 3 = 4
    check_four_bit(4'b0111, 4'b0011, 1'b1,
                   4'b0100, 1'b1);

    // 3 - 5, with a borrow
    check_four_bit(4'b0011, 4'b0101, 1'b1,
                   4'b1110, 1'b0);

    // --------------------------------------------------------
    // Problem 1(e)
    // --------------------------------------------------------

    $display("Testing the required RCA/RCS cases");

    // Unsigned addition: 3 + 4 = 7
    check_four_bit(4'b0011, 4'b0100, 1'b0,
                   4'b0111, 1'b0);

    // Unsigned subtraction: 7 - 3 = 4
    check_four_bit(4'b0111, 4'b0011, 1'b1,
                   4'b0100, 1'b1);

    // Signed addition: -3 + 5 = 2
    check_four_bit(4'b1101, 4'b0101, 1'b0,
                   4'b0010, 1'b1);

    // Signed subtraction: 2 - (-3) = 5
    check_four_bit(4'b0010, 4'b1101, 1'b1,
                   4'b0101, 1'b0);

    // Carry-out: 15 + 1
    check_four_bit(4'b1111, 4'b0001, 1'b0,
                   4'b0000, 1'b1);

    // Extra borrow test: 3 - 5
    check_four_bit(4'b0011, 4'b0101, 1'b1,
                   4'b1110, 1'b0);

    // --------------------------------------------------------
    // Problem 2(b)
    // --------------------------------------------------------

    $display("Testing the 32-bit CLA");

    // Unsigned addition: 3 + 4 = 7
    check_cla(32'h00000003, 32'h00000004, 1'b0,
              32'h00000007, 1'b0);

    // 7 - 3, entered as 7 + (~3) + 1
    check_cla(32'h00000007, 32'hFFFFFFFC, 1'b1,
              32'h00000004, 1'b1);

    // Signed addition: -3 + 5 = 2
    check_cla(32'hFFFFFFFD, 32'h00000005, 1'b0,
              32'h00000002, 1'b1);

    // 2 - (-3), entered as 2 + (~(-3)) + 1
    check_cla(32'h00000002, 32'h00000002, 1'b1,
              32'h00000005, 1'b0);

    // Carry out of bit 31
    check_cla(32'hFFFFFFFF, 32'h00000001, 1'b0,
              32'h00000000, 1'b1);

    // Carry across several 4-bit blocks
    check_cla(32'h0000FFFF, 32'h00000001, 1'b0,
              32'h00010000, 1'b0);

    // Carry-in passes through all eight blocks
    check_cla(32'hFFFFFFFF, 32'h00000000, 1'b1,
              32'h00000000, 1'b1);

    // 3 - 5, entered as 3 + (~5) + 1
    check_cla(32'h00000003, 32'hFFFFFFFA, 1'b1,
              32'hFFFFFFFE, 1'b0);

    if (errors == 0)
        $display("ALL TESTS PASSED");
    else
        $display("%0d TEST(S) FAILED", errors);

    $finish;
end

endmodule
