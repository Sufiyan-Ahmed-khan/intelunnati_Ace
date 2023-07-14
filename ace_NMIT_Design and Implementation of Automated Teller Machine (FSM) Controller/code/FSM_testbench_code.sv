module FSM_tb;
    reg clk,reset;
    reg insert_card,transac_mode,face_recog,deposit_withdraw,PIN;
	 reg [3:0] Amount;
	 wire [3:1] a;
	 wire pin_locked,transaction,above_10k,attempt;
    wire [2:0] o;
	 wire [3:0] new_balance,b;
	 FSM dut(.clk(clk),.reset(reset),.PIN(PIN),
	 .pin_locked(pin_locked),.transaction(transaction),.insert_card(insert_card),
	 .transac_mode(transac_mode),.a(a),.b(b),.above_10k(above_10k),.face_recog(face_recog),
	 .deposit_withdraw(deposit_withdraw),.Amount(Amount),.o(o),.attempt(attempt),.new_balance(new_balance));
	 initial begin
	 clk=0;
	 insert_card=1;Amount=2;
	 PIN=1;
	
	$display("--------------------------");
	$display("Test_case one");
	$display("--------------------------");
{transac_mode,face_recog,deposit_withdraw} =3'b000;
#179 reset=0;insert_card=0;
#30   insert_card=1;reset=1;
{transac_mode,face_recog,deposit_withdraw} =3'b001;
  
   $display("--------------------------");
	$display("Test_case two");
	$display("--------------------------");
#179 reset=0;insert_card=0;
#30   insert_card=1;reset=1;Amount=1;
{transac_mode,face_recog,deposit_withdraw} =3'b010;

   $display("--------------------------");
   $display("Test_case three");
   $display("--------------------------");
#179 reset=0;insert_card=0;
#30   insert_card=1;reset=1;Amount=11;
{transac_mode,face_recog,deposit_withdraw} =3'b011;

  $display("--------------------------");
  $display("Test_case four");
  $display("--------------------------");
#179 reset=0;insert_card=0;
#30   insert_card=1;reset=1;Amount=1;
{transac_mode,face_recog,deposit_withdraw} =3'b100;

  $display("--------------------------");
  $display("Test_case five");
  $display("--------------------------");
#179 reset=0;insert_card=0;
#30   insert_card=1;reset=1;{transac_mode,face_recog,deposit_withdraw} =3'b101;
  
  $display("--------------------------");
  $display("Test_case six");
  $display("--------------------------");
#179 reset=0;insert_card=0;
#30   insert_card=1;reset=1;{transac_mode,face_recog,deposit_withdraw} =3'b110;

  $display("--------------------------");
  $display("Test_case seven");
  $display("--------------------------");
#179 reset=0;insert_card=0;
#30   insert_card=1;reset=1;{transac_mode,face_recog,deposit_withdraw} =3'b111;

#29 reset=0;insert_card=0;
#29  reset=1;insert_card=1;PIN=0;
 $display("--------------------------");
 $display("Test_case ");
  $display("--------------------------");
#30 {transac_mode,face_recog,deposit_withdraw} =3'b111;
	 
	 
	 
	 end
	 always begin
	 #15 clk=~clk;
	 end
	 always begin
	 #5 reset=1;
	 #1690 reset=0;
	 end
	 initial begin
	 #1690 $finish;
	 end
endmodule



  

  