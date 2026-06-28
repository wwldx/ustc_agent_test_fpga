`timescale 1ns/1ps

module tb_mux2;
    reg a;
    reg b;
    reg sel;
    wire y;
    integer errors;
    integer i;
    reg expected;

    mux2 dut(
        .a(a),
        .b(b),
        .sel(sel),
        .y(y)
    );

    initial begin
        errors = 0;

        for (i = 0; i < 8; i = i + 1) begin
            a = i[0];
            b = i[1];
            sel = i[2];
            expected = sel ? b : a;
            #1;

            if (y !== expected) begin
                $display("FAIL mux2 a=%0b b=%0b sel=%0b y=%0b expected=%0b", a, b, sel, y, expected);
                errors = errors + 1;
            end
        end

        if (errors == 0) begin
            $display("PASS mux2");
            $finish;
        end

        $display("FAIL mux2 errors=%0d", errors);
        $finish;
    end
endmodule
