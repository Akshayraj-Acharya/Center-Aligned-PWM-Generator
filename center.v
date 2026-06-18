module pwm_center #(
    parameter WIDTH = 8
)(
    input clk,
    input reset,
    input [WIDTH-1:0] duty,
    input [15:0] div_value,
    output reg pwm_out
);

    reg [WIDTH-1:0] counter;
    reg [15:0] div_counter;
    reg direction; // 0 = up, 1 = down

    wire tick;

    // THIS BLOCK IS FOR CLOCK DIVIDER
    always @(posedge clk or posedge reset) begin
        if (reset)
            div_counter <= 0;
        else if (div_counter >= div_value)
            div_counter <= 0;
        else
            div_counter <= div_counter + 1;
    end

    assign tick = (div_counter == div_value);

    // THIS BLOCK IS FOR CENTER ALLIGNED, UP-DOWN COUNTER
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            direction <= 0;
        end
        else if (tick) begin
            if (direction == 0) begin
                if (counter == {WIDTH{1'b1}}) begin
                    direction <= 1;
                    counter <= counter - 1; 
                end else begin
                    counter <= counter + 1;
                end
            end
            else begin
                if (counter == 0) begin
                    direction <= 0;
                    counter <= counter + 1; 
                end else begin
                    counter <= counter - 1;
                end
            end
        end
    end

    // THIS BLOCK IS FOR PWM OUTPUT 
    always @(posedge clk or posedge reset) begin
        if (reset)
            pwm_out <= 0;
        else
            pwm_out <= (counter < duty);
    end

endmodule


