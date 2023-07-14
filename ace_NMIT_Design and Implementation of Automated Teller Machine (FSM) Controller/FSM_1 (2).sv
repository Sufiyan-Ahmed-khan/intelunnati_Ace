parameter [3:0] pin=1;
//parameter int min_balance=1000;
parameter bit [3:0] Balance=14;
//parameter int Deposit=1000;
//parameter int withdraw1=9000;
//parameter int withdraw2=12000;


module FSM(
    input clk,reset,
	 input  insert_card,transac_mode,face_recog,deposit_withdraw,PIN,
	 input  bit [3:0] Amount,
	 output bit [3:1] a,
	 output bit pin_locked,attempt,transaction,above_10k,
	 output bit [3:0] new_balance,b,
	 output bit [2:0] o);
	 
	 
	 initial begin a=3'b010;b=Balance; end
	 
	 enum bit [2:0] {S0 =3'b0, S1 =3'b01, S2 =3'b10,S3 =3'b011,S4 =3'b100,S5 =3'b101,S6 =3'b110,S7 =3'b111} state,next;
	 
	 always_ff@(posedge clk , negedge reset)
	 if(!reset) state<=S0;
	 else state<=next;
	 always_comb begin
	 unique case(state)
	 S0: begin o=S0; transaction=0;end
	 S1: begin o=S1; transaction=0;end
	 S2: begin o=S2; transaction=0;end
	 S3: begin o=S3; transaction=0;end
	 S4: begin o=S4; transaction=0;end
	 S5: begin o=S5; transaction=0;end
	 S6: begin o=S6; transaction=1;end
	 S7: begin o=S7; transaction=0;end
	 endcase
	 end
	
	always@(negedge clk) begin if(attempt==1&&a==1) a=3'b010;
	                            else if(attempt==1&&a==2) a=3'b011;
										else a=3'b001; end
										
	 always@(negedge clk) begin
	 unique case(state)
	 
	 S0: begin if(insert_card==0)$display("%0d welcome",$time);
	              attempt=0;
	           if(insert_card==1) begin $display("%0d Card Inserted",$time);//1
	                 if(pin_locked==1&&insert_card==1) 
	                 $display("%0d card locked for 24 hours duration",$time);
	           end//1
	          else $display("%0d Please insert card",$time);
	     end
	 
	 S1: begin
	     if(attempt==0) begin $display("%0d Enter Pin Attempt:1",$time);
	                          $display("%0d Pin entered is %0d",$time,PIN);
							  end
		  
		  if(PIN!=pin&&a==1) begin
		    attempt=1; pin_locked=1;
		    $display("%0d Pin invalid",$time);
		    $display("%0d Enter pin again. Attempt:2",$time);
		    $display("%0d Pin entered is %0d",$time,PIN); 
			 end
			 
		  else if(PIN!=pin&&a==2) begin attempt=1; pin_locked=1;
		    $display("%0d Pin invalid",$time);
		    $display("%0d Enter pin again. Attempt:3",$time);
		    $display("%0d Pin entered is %0d",$time,PIN); 
			 end

		  else if(PIN!=pin&&a==3) begin
		    $display("%0d Pin invalid 3 times",$time); 
		    pin_locked=1;attempt=0;
		  end
		 
		 else begin
		 $display("%0d PIN is valid",$time);
		 pin_locked =0;
		 end
		 end
	 
	 S2: begin 
	     $display("%0d Please state your mode of transaction",$time);
	     $display("%0d Press 0 for withdrawal and 1 for deposit",$time);
	 
	     if(transac_mode==0) $display("%0d U chose to withdraw",$time);
	     else $display("%0d U chose to deposit",$time);
	 
	     end
		 
	 S3: begin 
	     $display("%0d Your current balance is %0dk Ruppees",$time,b);
		  $display("%0d Enter amount to be withdrawn ",$time);
		  
		  if(Amount>10) begin above_10k=1; end
		  else begin above_10k=0; end
		     
			if(above_10k)$display("%0d Withdrawal Above 10k Ruppees",$time);
			else begin $display("%0d Amount to withdraw is %0dk",$time,Amount);end
		  end
		  
	 S4: begin 
	     $display("%0d Amount to be deposited in ur account %0dk Ruppees",$time,Amount);
		   if(Amount>=11) $display("%0d Maximum Amount deposition is 10k Ruppees",$time);//$display("%0d Your new balance is %0d",$time,new_balance);
		  end
		  
	 S5: begin 
	      if(face_recog) begin 
			   $display("%0d Face recognition success",$time);
		  //new_balance=Balance-withdraw2;
		   //if(new_balance<Balance)$display("%0d Insufficient balance",$time);
			//else $display("%0d Your new balance is %0d",$time,new_balance);
		   end
		   else $display("%0d Face recognition failed",$time); 
		  end
		 
	 S6: begin
	     if(transaction==1&&deposit_withdraw==0)$display("%0d Transaction has been terminated ,Balance is %0dk Ruppees",$time,b); 
		  else begin
		  if(transac_mode) new_balance=b+Amount;
		  else if(!transac_mode) new_balance=b-Amount;
		  
		  if(new_balance<0) $display("Please check Balance amount before withdrawal");
		  else begin
		  if(new_balance>=b) $display("%0d Transaction successful. Your new balance is %0dk Ruppees",$time,new_balance);
		  else if(new_balance<b) $display("%0d Transaction successful.Your new balance is %0dk Ruppees",$time,new_balance);  
		  else  $display("%0d Transaction failed",$time);
		  end
        end
		  end
		  
	  S7:begin 
		  $display("%0d Mini-Statement",$time);
		  $display("%0d Your Current transaction was successful and your current balance is %0dk Ruppees",$time,new_balance);
		  b=new_balance;
		  $display("%0d Remove card if no further transaction to be made",$time); 
		  end
		  
	endcase
	end
	  
	 always_comb begin
	 next=state;
	 unique case(state)
	 S0: begin if(insert_card) next=S1;
	     else next=S0; end
	 S1: begin if(pin_locked==1&&attempt==1)next=S1;
	 else if(pin_locked==0)next=S2;
	     else next=S0; end
	 S2:	 begin if(pin_locked) next=S1; 
	 else if(transac_mode==1)next=S4;
	     else if(transac_mode==0) next=S3; 
		  else next=S0;end  
    S3:	 begin if(above_10k==1)next=S5;
	     else if(above_10k==0)next=S6;
		 else next=S0; end 
    S4:	 begin if(Amount>=11)next=S2;
	     else if(Amount<11) next=S6; 
		  else next=S0; end 
    S5:	 begin if(face_recog==1)next=S6;
	     else if(face_recog==0) next=S3; 
		  else next=S0; end 
    S6:	 begin if(deposit_withdraw==1)next=S7;
	     else if(deposit_withdraw==0)next=S2; 
		  else next=S0; end 
    S7:	 begin if(insert_card==1)next=S2;
	     else next=S0; end 		  
	 endcase
	 end
endmodule
 

    