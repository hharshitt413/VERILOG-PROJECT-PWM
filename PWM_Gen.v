module pwm_shift_reg #(parameter N = 8)(
    input              clk,
    input              rst_n,
    input              shift_en,   // shift one bit per clk when high
    input              sdi,        // serial data in (MSB first)
    input              load,       // copy shift reg -> duty reg
    output             pwm_out,
    output [N-1:0]     duty_dbg
);
    reg [N-1:0] shift_reg, duty_reg, counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 0;
            duty_reg  <= 0;
            counter   <= 0;
        end else begin
            counter <= counter + 1'b1;               // free-running PWM counter
            if (shift_en) shift_reg <= {shift_reg[N-2:0], sdi};
            if (load)     duty_reg  <= shift_reg;
        end
    end

    assign pwm_out  = (counter < duty_reg);          // duty = duty_reg / 2^N
    assign duty_dbg = duty_reg;
endmodule