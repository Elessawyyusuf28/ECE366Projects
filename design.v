`timescale 1ns/1ps

// ============================================================
// Problem 1(a): Behavioral 1-bit full adder
// ============================================================

module one_bit_full_adder_behavioral(A, B, Cin, S, Cout);

input A, B, Cin;
output S, Cout;
reg S, Cout;

always @(*) begin
    S = A ^ B ^ Cin;
    Cout = (A & B) | (A & Cin) | (B & Cin);
end

endmodule


// ============================================================
// Problem 1(b): Structural 1-bit full adder
// ============================================================

module one_bit_full_adder(A, B, Cin, S, Cout);

input A, B, Cin;
output S, Cout;

wire X;
wire carry_generate, carry_propagate;

xor g1(X, A, B);
xor g2(S, X, Cin);

and g3(carry_generate, A, B);
and g4(carry_propagate, X, Cin);

or g5(Cout, carry_generate, carry_propagate);

endmodule


// ============================================================
// Problem 1(c): 4-bit ripple-carry adder
// ============================================================

module four_bit_RCA(A, B, Cin, S, Cout);

input [3:0] A, B;
input Cin;
output [3:0] S;
output Cout;

wire c1, c2, c3;

// Connect the carry from each stage to the next one
one_bit_full_adder FA0(
    .A(A[0]), .B(B[0]), .Cin(Cin),
    .S(S[0]), .Cout(c1)
);

one_bit_full_adder FA1(
    .A(A[1]), .B(B[1]), .Cin(c1),
    .S(S[1]), .Cout(c2)
);

one_bit_full_adder FA2(
    .A(A[2]), .B(B[2]), .Cin(c2),
    .S(S[2]), .Cout(c3)
);

one_bit_full_adder FA3(
    .A(A[3]), .B(B[3]), .Cin(c3),
    .S(S[3]), .Cout(Cout)
);

endmodule


// ============================================================
// Problem 1(d): 4-bit adder/subtractor
// ============================================================

module four_bit_RCA_RCS(A, B, Cin, S, Cout);

input [3:0] A, B;
input Cin;
output [3:0] S;
output Cout;

wire [3:0] B_modified;
wire c1, c2, c3;

// Cin = 0 adds, Cin = 1 subtracts
xor g0(B_modified[0], B[0], Cin);
xor g1(B_modified[1], B[1], Cin);
xor g2(B_modified[2], B[2], Cin);
xor g3(B_modified[3], B[3], Cin);

one_bit_full_adder FA0(
    .A(A[0]), .B(B_modified[0]), .Cin(Cin),
    .S(S[0]), .Cout(c1)
);

one_bit_full_adder FA1(
    .A(A[1]), .B(B_modified[1]), .Cin(c1),
    .S(S[1]), .Cout(c2)
);

one_bit_full_adder FA2(
    .A(A[2]), .B(B_modified[2]), .Cin(c2),
    .S(S[2]), .Cout(c3)
);

one_bit_full_adder FA3(
    .A(A[3]), .B(B_modified[3]), .Cin(c3),
    .S(S[3]), .Cout(Cout)
);

endmodule


// ============================================================
// Problem 2(a): 32-bit CLA using 4-bit RCA blocks
// ============================================================

module CLA(A, B, Cin, S, Cout);

input [31:0] A, B;
input Cin;
output [31:0] S;
output Cout;

wire [31:0] P, G;
wire [7:0] block_P, block_G;
wire [8:0] C;
wire [7:0] unused_Cout;

assign C[0] = Cin;
assign Cout = C[8];

genvar i;

generate
    // Propagate and generate for each bit
    for (i = 0; i < 32; i = i + 1) begin : bit_logic
        or p_gate(P[i], A[i], B[i]);
        and g_gate(G[i], A[i], B[i]);
    end

    // Carry logic for each group of four bits
    for (i = 0; i < 8; i = i + 1) begin : block_logic
        wire p32, p321;
        wire t1, t2, t3;
        wire g32, g321;
        wire carry_term;

        and p1(p32, P[4*i+3], P[4*i+2]);
        and p2(p321, p32, P[4*i+1]);
        and p3(block_P[i], p321, P[4*i]);

        and g1(t1, P[4*i+3], G[4*i+2]);
        or g2(g32, G[4*i+3], t1);

        and g3(t2, p32, G[4*i+1]);
        or g4(g321, g32, t2);

        and g5(t3, p321, G[4*i]);
        or g6(block_G[i], g321, t3);

        and c1(carry_term, block_P[i], C[i]);
        or c2(C[i+1], block_G[i], carry_term);

        // The RCA calculates the four sum bits
        four_bit_RCA RCA(
            .A(A[4*i+3:4*i]),
            .B(B[4*i+3:4*i]),
            .Cin(C[i]),
            .S(S[4*i+3:4*i]),
            .Cout(unused_Cout[i])
        );
    end
endgenerate

endmodule

// ============================================================
// Problem 3(a): 16-bit Parallel Prefix Adder
// ============================================================

module black_box (
    input Pik, Gik, Pk1j, Gk1j,
    output Pij, Gij
);
    wire term;
    and a1 (Pij, Pik, Pk1j);
    and a2 (term, Pik, Gk1j);
    or o1 (Gij, Gik, term);
endmodule

module PPA(A, B, Cin, S, Cout);
    input [15:0] A, B;
    input Cin;
    output [15:0] S;
    output Cout;
    wire [15:0] p_i_i, g_i_i;
    wire p_m1_m1 = 1'b0;
    wire g_m1_m1 = Cin;
    genvar i;
    // Pre-computation propagate and generate
    generate
        for (i = 0; i < 16; i = i + 1) begin : PRE_COMPUTE
            or o1 (p_i_i[i], A[i], B[i]);
            and a1 (g_i_i[i], A[i], B[i]);
        end
    endgenerate
    // Figure 3, Row 1
    wire p_14_13, g_14_13; black_box b1_14 (p_i_i[14], g_i_i[14], p_i_i[13], g_i_i[13], p_14_13, g_14_13);
    wire p_12_11, g_12_11; black_box b1_12 (p_i_i[12], g_i_i[12], p_i_i[11], g_i_i[11], p_12_11, g_12_11);
    wire p_10_9, g_10_9; black_box b1_10 (p_i_i[10], g_i_i[10], p_i_i[9], g_i_i[9], p_10_9, g_10_9);
    wire p_8_7, g_8_7; black_box b1_8 (p_i_i[8], g_i_i[8], p_i_i[7], g_i_i[7], p_8_7, g_8_7);
    wire p_6_5, g_6_5; black_box b1_6 (p_i_i[6], g_i_i[6], p_i_i[5], g_i_i[5], p_6_5, g_6_5);
    wire p_4_3, g_4_3; black_box b1_4 (p_i_i[4], g_i_i[4], p_i_i[3], g_i_i[3], p_4_3, g_4_3);
    wire p_2_1, g_2_1; black_box b1_2 (p_i_i[2], g_i_i[2], p_i_i[1], g_i_i[1], p_2_1, g_2_1);
    wire p_0_m1, g_0_m1; black_box b1_0 (p_i_i[0], g_i_i[0], p_m1_m1, g_m1_m1, p_0_m1, g_0_m1);
    // Row 2
    wire p_14_11, g_14_11; black_box b2_14 (p_14_13, g_14_13, p_12_11, g_12_11, p_14_11, g_14_11);
    wire p_10_7, g_10_7; black_box b2_10 (p_10_9, g_10_9, p_8_7, g_8_7, p_10_7, g_10_7);
    wire p_6_3, g_6_3; black_box b2_6 (p_6_5, g_6_5, p_4_3, g_4_3, p_6_3, g_6_3);
    wire p_2_m1, g_2_m1; black_box b2_2 (p_2_1, g_2_1, p_0_m1, g_0_m1, p_2_m1, g_2_m1);
    // Row 3
    wire p_14_7, g_14_7; black_box b3_14 (p_14_11, g_14_11, p_10_7, g_10_7, p_14_7, g_14_7);
    wire p_6_m1, g_6_m1; black_box b3_6 (p_6_3, g_6_3, p_2_m1, g_2_m1, p_6_m1, g_6_m1);
    // Row 4
    wire p_14_m1, g_14_m1; black_box b4_14 (p_14_7, g_14_7, p_6_m1, g_6_m1, p_14_m1, g_14_m1);
    // Row 5
    wire p_13_11, g_13_11; black_box b5_13 (p_i_i[13], g_i_i[13], p_12_11, g_12_11, p_13_11, g_13_11);
    wire p_9_7, g_9_7; black_box b5_9 (p_i_i[9], g_i_i[9], p_8_7, g_8_7, p_9_7, g_9_7);
    wire p_5_3, g_5_3; black_box b5_5 (p_i_i[5], g_i_i[5], p_4_3, g_4_3, p_5_3, g_5_3);
    wire p_1_m1, g_1_m1; black_box b5_1 (p_i_i[1], g_i_i[1], p_0_m1, g_0_m1, p_1_m1, g_1_m1);
    // Row 6 and remaining distribution
    wire p_3_m1, g_3_m1; black_box b6_3 (p_i_i[3], g_i_i[3], p_2_m1, g_2_m1, p_3_m1, g_3_m1);
    wire p_4_m1, g_4_m1; black_box b6_4 (p_4_3, g_4_3, p_2_m1, g_2_m1, p_4_m1, g_4_m1);
    wire p_5_m1, g_5_m1; black_box b6_5 (p_5_3, g_5_3, p_2_m1, g_2_m1, p_5_m1, g_5_m1);
    wire p_7_m1, g_7_m1; black_box b6_7 (p_i_i[7], g_i_i[7], p_6_m1, g_6_m1, p_7_m1, g_7_m1);
    wire p_8_m1, g_8_m1; black_box b6_8 (p_8_7, g_8_7, p_6_m1, g_6_m1, p_8_m1, g_8_m1);
    wire p_9_m1, g_9_m1; black_box b6_9 (p_9_7, g_9_7, p_6_m1, g_6_m1, p_9_m1, g_9_m1);
    wire p_10_m1, g_10_m1; black_box b6_10 (p_10_7, g_10_7, p_6_m1, g_6_m1, p_10_m1, g_10_m1);
    wire p_11_m1, g_11_m1; black_box b6_11 (p_i_i[11], g_i_i[11], p_10_m1, g_10_m1, p_11_m1, g_11_m1);
    wire p_12_m1, g_12_m1; black_box b6_12 (p_12_11, g_12_11, p_10_m1, g_10_m1, p_12_m1, g_12_m1);
    wire p_13_m1, g_13_m1; black_box b6_13 (p_13_11, g_13_11, p_10_m1, g_10_m1, p_13_m1, g_13_m1);
    wire p_15_m1, g_15_m1; black_box b6_15 (p_i_i[15], g_i_i[15], p_14_m1, g_14_m1, p_15_m1, g_15_m1);
    // Grouping all final carry generates
    wire [15:0] G_out;
    assign G_out[0] = g_0_m1;
    assign G_out[1] = g_1_m1;
    assign G_out[2] = g_2_m1;
    assign G_out[3] = g_3_m1;
    assign G_out[4] = g_4_m1;
    assign G_out[5] = g_5_m1;
    assign G_out[6] = g_6_m1;
    assign G_out[7] = g_7_m1;
    assign G_out[8] = g_8_m1;
    assign G_out[9] = g_9_m1;
    assign G_out[10] = g_10_m1;
    assign G_out[11] = g_11_m1;
    assign G_out[12] = g_12_m1;
    assign G_out[13] = g_13_m1;
    assign G_out[14] = g_14_m1;
    assign G_out[15] = g_15_m1;
    assign Cout = G_out[15];
    wire [15:0] AxorB;
    genvar j;
    generate
        for (j = 0; j < 16; j = j + 1) begin : SUM_COMPUTE
            xor x1 (AxorB[j], A[j], B[j]);
            if (j == 0) begin
                xor x2 (S[0], Cin, AxorB[0]);
            end else begin
                xor x2 (S[j], G_out[j-1], AxorB[j]);
            end
        end
    endgenerate
endmodule

// ============================================================
// Problem 4(a): 16-bit Kogge-Stone Adder (Bonus)
// ============================================================

module KS_16bit(A, B, Cin, S, Cout);
    input [15:0] A, B;
    input Cin;
    output [15:0] S;
    output Cout;
    wire [15:0] P, G;
    wire [15:0] P1, G1;
    wire [15:0] P2, G2;
    wire [15:0] P3, G3;
    wire [15:0] P4, G4;
    wire [16:0] C;
    assign C[0] = Cin;
    assign Cout = C[16];
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin: bit_logic
            xor (P[i], A[i], B[i]);
            and (G[i], A[i], B[i]);
        end
        for (i = 0; i < 16; i = i + 1) begin: stage1
            if (i >= 1) begin
                wire t;
                and (P1[i], P[i], P[i-1]);
                and (t, P[i], G[i-1]);
                or (G1[i], G[i], t);
            end
            else begin
                assign P1[i] = P[i];
                assign G1[i] = G[i];
            end
        end
        for (i = 0; i < 16; i = i + 1) begin: stage2
            if (i >= 2) begin
                wire t;
                and (P2[i], P1[i], P1[i-2]);
                and (t, P1[i], G1[i-2]);
                or (G2[i], G1[i], t);
            end
            else begin
                assign P2[i] = P1[i];
                assign G2[i] = G1[i];
            end
        end
        for (i = 0; i < 16; i = i + 1) begin: stage3
            if (i >= 4) begin
                wire t;
                and (P3[i], P2[i], P2[i-4]);
                and (t, P2[i], G2[i-4]);
                or (G3[i], G2[i], t);
            end
            else begin
                assign P3[i] = P2[i];
                assign G3[i] = G2[i];
            end
        end
        for (i = 0; i < 16; i = i + 1) begin: stage4
            if (i >= 8) begin
                wire t;
                and (P4[i], P3[i], P3[i-8]);
                and (t, P3[i], G3[i-8]);
                or (G4[i], G3[i], t);
            end
            else begin
                assign P4[i] = P3[i];
                assign G4[i] = G3[i];
            end
        end
        for (i = 0; i < 16; i = i + 1) begin: output_logic
            wire carry_term;
            and (carry_term, P4[i], Cin);
            or (C[i+1], G4[i], carry_term);
            xor (S[i], P[i], C[i]);
        end
    endgenerate
endmodule
