`timescale 1ns/1ps
module tb_clean;
    parameter N = 4;
    reg clk = 0, rst_n = 0, shift_en = 0, sdi = 0, load = 0;
    wire pwm_out;
    wire [N-1:0] duty_dbg;

    pwm_shift_reg #(N) dut (.clk(clk), .rst_n(rst_n), .shift_en(shift_en),
                            .sdi(sdi), .load(load),
                            .pwm_out(pwm_out), .duty_dbg(duty_dbg));

    always #5 clk = ~clk;

    task set_duty(input [N-1:0] b);
        integer i;
        begin
            for (i = N-1; i >= 0; i = i-1) begin
                @(negedge clk);
                sdi = b[i];
                shift_en = 1;
            end
            @(negedge clk);
            shift_en = 0;
            sdi = 0;
            wait (dut.counter == {N{1'b1}});
            @(negedge clk) load = 1;
            @(negedge clk) load = 0;
            repeat (4 * (1 << N)) @(posedge clk);
        end
    endtask

    initial begin
        $dumpfile("pwm_clean.vcd");
        $dumpvars(0, tb_clean);
        #23 rst_n = 1;
        set_duty(4'd4);    // 25%
        set_duty(4'd8);    // 50%
        set_duty(4'd12);   // 75%
        $finish;
    end
endmodule