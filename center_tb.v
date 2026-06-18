module pwm_center_tb;

    parameter WIDTH = 8;

    reg clk;
    reg reset;
    reg [WIDTH-1:0] duty;
    reg [15:0] div_value;

    wire pwm_out;

    pwm_center #(.WIDTH(WIDTH)) uut (
        .clk(clk),
        .reset(reset),
        .duty(duty),
        .div_value(div_value),
        .pwm_out(pwm_out)
    );

    wire [WIDTH-1:0] counter_tb;
    wire direction_tb;
    wire [15:0] div_counter_tb;

    assign counter_tb     = uut.counter;
    assign direction_tb   = uut.direction;
    assign div_counter_tb = uut.div_counter;

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        duty = 0;
        div_value = 1;

        #20;
        reset = 0;

        duty = 8'd128;    // 50% duty
        #40000;

        duty = 8'd192;    // 75% duty
        #40000;

        duty = 8'd64;     // 25% duty
        #40000;

        $finish;
    end

    initial begin
        $monitor("T=%0t | cnt=%d | dir=%b | div=%d | pwm=%b",
                  $time, counter_tb, direction_tb, div_counter_tb, pwm_out);
    end

endmodule


