module something(
Clock,
reset,
switch,
bcd0,
bcd1,
bcd2,
bcd3,
led,
button

);


 //-------------Input Ports-----------------------------
  input   Clock,reset,button;
  input [9:0]switch;
  
  //-------------Output Ports----------------------------
  output reg [9:0]led;
  
   output reg [6:0]bcd0;  //-> modulede olsa daha iyi datalar
   output reg [6:0]bcd1;
   output reg [6:0]bcd2; // -> 
   output reg [6:0]bcd3; 
	
	parameter 	state_start 	= 5'b00000;
	parameter	state_LEVEL1	= 5'b00001;
	parameter	state_LEVEL1_Out_Soru = 5'b00010;
	parameter	state_LEVEL1_Out_TruWait = 5'b00011;
	parameter	state_LEVEL1_Out_FalWait = 5'b00100;
	parameter	state_LEVEL2	= 5'b00101;
	parameter	state_LEVEL2_Out_Soru = 5'b00110;
	parameter	state_LEVEL2_Out_TruWait = 5'b00111;
	parameter	state_LEVEL2_Out_FalWait = 5'b01000;
	parameter	state_LEVEL3	= 5'b01001;
	parameter	state_LEVEL3_Out_Soru = 5'b01010;
	parameter	state_LEVEL3_Out_TruWait = 5'b01011;
	parameter	state_LEVEL3_Out_FalWait = 5'b01100;
	parameter	state_LEVEL4	= 5'b01101;
	parameter	state_LEVEL4_Out_Soru = 5'b01110;
	parameter	state_LEVEL4_Out_TruWait = 5'b01111;
	parameter	state_LEVEL4_Out_FalWait = 5'b10000;
	parameter	state_LEVEL5	= 5'b10001;
	parameter	state_LEVEL5_Out_Soru = 5'b10010;
	parameter	state_LEVEL5_Out_TruWait = 5'b10011;
	parameter	state_LEVEL5_Out_FalWait = 5'b10100;
	parameter	state_LEVEL6	= 5'b10101;
	parameter	state_LEVEL6_Out_Soru = 5'b10110;
	parameter	state_LEVEL6_Out_TruWait = 5'b10111;
	parameter	state_LEVEL6_Out_FalWait = 5'b11000;
	parameter	state_FINISH = 5'b11001;
	parameter	state_FINISH2 = 5'b11010;

	// led logic icin parametreler
	
	
	parameter 	state_zero 	= 4'b0000;
	parameter 	state_one 	= 4'b0001;
	parameter 	state_two 	= 4'b0010;
	parameter 	state_three = 4'b0011;
	parameter 	state_four 	= 4'b0100;
	parameter 	state_five 	= 4'b0101;
	parameter 	state_six 	= 4'b0110;
	parameter 	state_seven = 4'b0111;
	parameter 	state_eight = 4'b1000;
	parameter 	state_nine 	= 4'b1001;



	
	
	parameter	DONE	= 2'b10;
	//local variable
	integer levelNumber; //first two of BCD 7 seg   *DECPRTD* level 6 110
	integer points; // latter two of BCD 7 seg 4 bit 1234567910 2 uzerı 7
	integer tens;
	integer ones;
	reg [25:0] count;
	wire pulse; //fastest aslinda
	wire pulsefast; 
	wire pulsemid; // middle aslinda
	wire pulselow;
	assign pulse = count[25]; // NEED TO DRIVE PULSE  burasi high olunca ucucak yani 
	assign pulselow = pulse;
	assign pulsemid = count[24];
	assign pulsefast = count[23];
	reg out;
	reg waitSig;
	reg [4:0] state;
	reg [4:0] next_state; //bununs ebebine bak

	reg[3:0] currentstatelevel1;
	reg[3:0] currentstatelevel2;
	reg[3:0] currentstatelevel3;
	reg[3:0] currentstatelevel4;
	reg[3:0] currentstatelevel5;
	reg[3:0] currentstatelevel6;
	
	reg[3:0] nexstatelevel1;
	reg[3:0] nexstatelevel2;
	reg[3:0] nexstatelevel3;
	reg[3:0] nexstatelevel4;
	reg[3:0] nexstatelevel5;
	reg[3:0] nexstatelevel6;

//----------Seq Logic-----------------------------
// always gets next state in posedge clock
//though if NEXT __ STT not changed it may stay in same
//if reset baslangic state git isikli olan
  always @ (posedge Clock , posedge reset)
  begin	// : NEXT_STATELOGIC
    if (reset == 1'b1) begin
      state <=    state_start; // burda ve altta #1 vardi
		currentstatelevel1 <= state_zero;
		currentstatelevel2 <= state_zero;
		currentstatelevel3 <= state_zero;
		currentstatelevel4 <= state_zero;
		currentstatelevel5 <= state_zero;
		currentstatelevel6 <= state_zero;


    end
	 else begin
      state <=    next_state;
		currentstatelevel1 <= nexstatelevel1;
		currentstatelevel2 <= nexstatelevel2;
		currentstatelevel3 <= nexstatelevel3;
		currentstatelevel4 <= nexstatelevel4;
		currentstatelevel5 <= nexstatelevel5;
		currentstatelevel6 <= nexstatelevel6;


    end
  end
  // COUNTER  IMPLEMENTATION
  // burda pulse input olarak alinmalimi acaba?
  
  always @ (posedge Clock, posedge reset) begin
    if (reset) count <= 26'b0;
	 else if (pulse) count <= 26'b0; 
	 else count <= count + 26'b1; 
  end
				  
				  
  
  // level statelerini degistirmek
always@(*) begin 	//: LEVEL_STATES
	  next_state <= state_start;
  case(state)
	 state_start : begin
	 //clock falan set edilcek
	 bcd0 <= 7'b0011100; // u harf TEMP
    bcd1 <= 7'b0000101; // r harf TEMP
	 bcd2 <= 7'b0001111; // t harf TEMP
    bcd3 <= 7'b1111111; // blank  TEMP
	 if(button) begin
	 next_state <= state_LEVEL1;
	 end
	 end
    state_LEVEL1 : begin
        if (out) begin  next_state <= state_LEVEL1_Out_Soru; end //out = 0; end
        else begin next_state <= state_LEVEL1; end//out = 0; end// its same level 
    end
	 state_LEVEL1_Out_Soru: begin 
	 // 12+34  = 1 2 3 4  =  46
	 next_state <= state; // bu sayede out 0 olunca tekrar clockta oraya buraya gitmesin
	 bcd0 <= 7'b1001111;
    bcd1 <= 7'b0110000;
	 bcd2 <= 7'b0000110;
    bcd3 <= 7'b1001100;
	 if(button) begin
	  if(switch[5] && !switch[4] && switch[3] && switch[2] && switch[1] && !switch[0])begin
			//true
			next_state <= state_LEVEL1_Out_TruWait;
			end
			
		else begin
		 //false
			next_state <= state_LEVEL1_Out_FalWait;
		 end
		 
		 end
		 end
	state_LEVEL1_Out_TruWait:begin 
	 bcd0 <= 7'b0011100; // u harf
    bcd1 <= 7'b0000101; // r harf
	 bcd2 <= 7'b0001111; // t harf
    bcd3 <= 7'b1111111; // blank
	 if(waitSig) begin 
		next_state <= state_LEVEL1_Out_TruWait; end
	 else begin 
		next_state <= state_LEVEL2;
	// show tru on bcd , go next level state
	// Wait for all switches turn 0 again.
	end
	end
	state_LEVEL1_Out_FalWait:begin 
	 bcd0 <= 7'b1011011; // S harf
    bcd1 <= 7'b0001110	; // L harf
	 bcd2 <= 7'b1110111; // A harf
    bcd3 <= 7'b1000111; // F
	 
	  if(waitSig) begin 
		next_state <= state_LEVEL1_Out_FalWait; end
	 else begin 
		next_state <= state_LEVEL1;
	// show fal on bcd go back level state
	// Wait for all switches turn 0 again.
	end
    end
    state_LEVEL2 : begin
        if (out) begin  next_state <= state_LEVEL2_Out_Soru;end //out = 0; end
        else begin next_state <= state_LEVEL2; end // out = 0; end// its same level 
    end
	 state_LEVEL2_Out_Soru: begin 
	 // 42-15  = 4 2 1 5   =  27
	 next_state <= state; // bu sayede out 0 olunca tekrar clockta oraya buraya gitmesin
	 bcd0 <= 7'b0100100;
    bcd1 <= 7'b1001111;
	 bcd2 <= 7'b0010010;
    bcd3 <= 7'b1001100;
	 if(button) begin
	  if(switch[4] && switch[3] && !switch[2] && switch[1] && !switch[0])begin
			//true
			next_state <= state_LEVEL2_Out_TruWait;
			end
		else begin
		 //false
			next_state <= state_LEVEL2_Out_FalWait;
		 end
		 
		 end
		 end
	state_LEVEL2_Out_TruWait:begin 
	 bcd0 <= 7'b0011100; // u harf
    bcd1 <= 7'b0000101; // r harf
	 bcd2 <= 7'b0001111; // t harf
    bcd3 <= 7'b1111111; // blank
	 if(waitSig) begin 
		next_state <= state_LEVEL2_Out_TruWait; end
	 else begin 
		next_state <= state_LEVEL3;
	// show tru on bcd , go next level state
	// Wait for all switches turn 0 again.
	end
	end
	state_LEVEL2_Out_FalWait:begin 
	 bcd0 <= 7'b1011011; // S harf
    bcd1 <= 7'b0001110	; // L harf
	 bcd2 <= 7'b1110111; // A harf
    bcd3 <= 7'b1000111; // F
	 
	  if(waitSig) begin 
		next_state <= state_LEVEL2_Out_FalWait; end
	 else begin 
		next_state <= state_LEVEL2;
	// show fal on bcd go back level state
	// Wait for all switches turn 0 again.
	end
    end
    state_LEVEL3 : begin
        if (out) begin  next_state <= state_LEVEL3_Out_Soru;end //out = 0; end
        else begin next_state <= state_LEVEL3; end //out = 0; end// its same level 
    end
	 state_LEVEL3_Out_Soru: begin 
	 // 12*11  = 1 2 1 1  =  132
	 next_state <= state; // bu sayede out 0 olunca tekrar clockta oraya buraya gitmesin
	 bcd0 <= 7'b1001111;
    bcd1 <= 7'b0010010;
	 bcd2 <= 7'b1001111;
    bcd3 <= 7'b1001111;
	 if(button) begin
	  if(switch[7] && !switch[6] && !switch[5] && !switch[4] && !switch[3] && switch[2] && !switch[1] && !switch[0])begin
			//true
			next_state <= state_LEVEL3_Out_TruWait;
			end
		else begin
		 //false
			next_state <= state_LEVEL3_Out_FalWait;
		 end
		 
		 end
		 end
	state_LEVEL3_Out_TruWait:begin 
	 bcd0 <= 7'b0011100; // u harf
    bcd1 <= 7'b0000101; // r harf
	 bcd2 <= 7'b0001111; // t harf
    bcd3 <= 7'b1111111; // blank
	 if(waitSig) begin 
		next_state <= state_LEVEL3_Out_TruWait; end
	 else begin 
		next_state <= state_LEVEL4;
	// show tru on bcd , go next level state
	// Wait for all switches turn 0 again.
	end
	end
	state_LEVEL3_Out_FalWait:begin 
	 bcd0 <= 7'b1011011; // S harf
    bcd1 <= 7'b0001110	; // L harf
	 bcd2 <= 7'b1110111; // A harf
    bcd3 <= 7'b1000111; // F
	 
	  if(waitSig) begin 
		next_state <= state_LEVEL3_Out_FalWait; end
	 else begin 
		next_state <= state_LEVEL3;
	// show fal on bcd go back level state
	// Wait for all switches turn 0 again.
	end
    end
    state_LEVEL4 : begin
        if (out) begin  next_state <= state_LEVEL4_Out_Soru; end// out = 0; end
        else begin next_state <= state_LEVEL4; end// out = 0; end// its same level 
    end
	 state_LEVEL4_Out_Soru: begin 
	 // 98 0 7  = 9 8 ' 7   =  14
	 next_state <= state; // bu sayede out 0 olunca tekrar clockta oraya buraya gitmesin
	 bcd0 <= 7'b0001111;
    bcd1 <= 7'b1111111;
	 bcd2 <= 7'b0000000;
    bcd3 <= 7'b0000100;
	 if(button) begin
	  if(switch[3] && switch[2] && switch[1] && !switch[0])begin
			//true
			next_state <= state_LEVEL4_Out_TruWait;
			end
		else begin
		 //false
			next_state <= state_LEVEL4_Out_FalWait;
		 end
		 
		 end
		 end
	state_LEVEL4_Out_TruWait:begin 
	 bcd0 <= 7'b0011100; // u harf
    bcd1 <= 7'b0000101; // r harf
	 bcd2 <= 7'b0001111; // t harf
    bcd3 <= 7'b1111111; // blank
	 if(waitSig) begin 
		next_state <= state_LEVEL4_Out_TruWait; end
	 else begin 
		next_state <= state_LEVEL5;
	// show tru on bcd , go next level state
	// Wait for all switches turn 0 again.
	end
	end
	state_LEVEL4_Out_FalWait:begin 
	 bcd0 <= 7'b1011011; // S harf
    bcd1 <= 7'b0001110	; // L harf
	 bcd2 <= 7'b1110111; // A harf
    bcd3 <= 7'b1000111; // F
	 
	  if(waitSig) begin 
		next_state <= state_LEVEL4_Out_FalWait; end
	 else begin 
		next_state <= state_LEVEL4;
	// show fal on bcd go back level state
	// Wait for all switches turn 0 again.
	end
    end
    state_LEVEL5 : begin
        if (out) begin  next_state <= state_LEVEL5_Out_Soru; end// out = 0; end
        else begin next_state <= state_LEVEL1; end //out = 0; end// its same level 
    end
	 state_LEVEL5_Out_Soru: begin 
	 // 12+34  = 1 2 3 4  =  46
	 next_state <= state; // bu sayede out 0 olunca tekrar clockta oraya buraya gitmesin
	 bcd0 <= 7'b1001111;
    bcd1 <= 7'b0110000;
	 bcd2 <= 7'b0000110;
    bcd3 <= 7'b1001100;
	 if(button) begin
	  if(switch[5] && !switch[4] && switch[3] && switch[2] && switch[1] && !switch)begin
			//true
			next_state <= state_LEVEL5_Out_TruWait;
			end
		else begin
		 //false
			next_state <= state_LEVEL5_Out_FalWait;
		 end
		 
		 end
		 end
	state_LEVEL5_Out_TruWait:begin 
	 bcd0 <= 7'b0011100; // u harf
    bcd1 <= 7'b0000101; // r harf
	 bcd2 <= 7'b0001111; // t harf
    bcd3 <= 7'b1111111; // blank
	 if(waitSig) begin 
		next_state <= state_LEVEL5_Out_TruWait; end
	 else begin 
		next_state <= state_LEVEL6;
	// show tru on bcd , go next level state
	// Wait for all switches turn 0 again.
	end
	end
	state_LEVEL5_Out_FalWait:begin 
	 bcd0 <= 7'b1011011; // S harf
    bcd1 <= 7'b0001110	; // L harf
	 bcd2 <= 7'b1110111; // A harf
    bcd3 <= 7'b1000111; // F
	 
	  if(waitSig) begin 
		next_state <= state_LEVEL5_Out_FalWait; end
	 else begin 
		next_state <= state_LEVEL5;
	// show fal on bcd go back level state
	// Wait for all switches turn 0 again.
	end
    end
    state_LEVEL6 : begin
        if (out) begin next_state <= state_LEVEL6_Out_Soru;end //out = 0; end
        else begin next_state <= state_LEVEL6; end // out = 0; end// its same level 
    end
	 state_LEVEL6_Out_Soru: begin 
	 // 12+34  = 1 2 3 4  =  46
	 next_state <= state; // bu sayede out 0 olunca tekrar clockta oraya buraya gitmesin
	 bcd0 <= 7'b1001111;
    bcd1 <= 7'b0110000;
	 bcd2 <= 7'b0000110;
    bcd3 <= 7'b1001100;
	 if(button) begin
	  if(switch[5] && !switch[4] && switch[3] && switch[2] && switch[1] && !switch)begin
			//true
			next_state <= state_LEVEL6_Out_TruWait;
			end
		else begin
		 //false
			next_state <= state_LEVEL6_Out_FalWait;
		 end
		 
		 end
		 end
	state_LEVEL6_Out_TruWait:begin 
	 bcd0 <= 7'b0011100; // u harf
    bcd1 <= 7'b0000101; // r harf
	 bcd2 <= 7'b0001111; // t harf
    bcd3 <= 7'b1111111; // blank
	 if(waitSig) begin 
		next_state <= state_LEVEL1_Out_TruWait; end
	 else begin 
		next_state <= state_FINISH;
	// show tru on bcd , go next level state
	// Wait for all switches turn 0 again.
	end
	end
	state_LEVEL6_Out_FalWait:begin 
	 bcd0 <= 7'b1011011; // S harf
    bcd1 <= 7'b0001110	; // L harf
	 bcd2 <= 7'b1110111; // A harf
    bcd3 <= 7'b1000111; // F
	 
	  if(waitSig) begin 
		next_state <= state_LEVEL6_Out_FalWait; end
	 else begin 
		next_state <= state_LEVEL6;
	// show fal on bcd go back level state
	// Wait for all switches turn 0 again.
	end
    end
	 state_FINISH: begin
	 //clock rate slowRate
	 bcd0 <= 7'b0111101; // d harf
    bcd1 <= 7'b0010101	; // n harf
	 bcd2 <= 7'b1001111; // E harf
    bcd3 <= 7'b1111111; // 
	 next_state  <= state_FINISH2;
	 end
	 state_FINISH2 : begin
	 // pointsleri BCD goster
	 next_state <= state_start;
	 bcd3 <= 7'b1111111;
	 bcd2 <= 7'b1111111; // 
	 
	 if (points >= 10) begin
    tens <= 1;
    ones <= points - 10;
	 end else begin
	 tens <= 0;
	 ones <= points; 
	 end
	 case (tens) //case statement
            0 : bcd1 = 7'b0000001;
            1 : bcd1 = 7'b1001111;
            2 : bcd1 = 7'b0010010;
            3 : bcd1 = 7'b0000110;
            4 : bcd1 = 7'b1001100;
            5 : bcd1 = 7'b0100100;
            6 : bcd1 = 7'b0100000;
            7 : bcd1 = 7'b0001111;
            8 : bcd1 <= 7'b0000000;
            9 : bcd1 <= 7'b0000100;
            //switch off 7 segment character when the bcd digit is not a decimal number.
            default : bcd1 <= 7'b1111111; 
        endcase
		  case (ones) //case statement
            0 : bcd0 = 7'b0000001;
            1 : bcd0 = 7'b1001111;
            2 : bcd0 = 7'b0010010;
            3 : bcd0 = 7'b0000110;
            4 : bcd0 = 7'b1001100;
            5 : bcd0 = 7'b0100100;
            6 : bcd0 = 7'b0100000;
            7 : bcd0 = 7'b0001111;
            8 : bcd0 = 7'b0000000;
            9 : bcd0 = 7'b0000100;
            //switch off 7 segment character when the bcd digit is not a decimal number.
            default : bcd0 <= 7'b1111111; 
        endcase
	 
	 // binary to DEC  then to sayi
	
	 
	 end

		endcase
		end
		
	 
	 // oyun bitti burdan idle state don



// TUM SWITCHLER offsa  sinyal verir
always@(*) begin : SWITCH_OFF
integer j;
integer sayim ;

	sayim = 0;

for( j = 0 ; j < 10 ; j=j+1)begin
	if(switch[j])begin
		sayim = sayim+1; end
	end
	if(sayim != 0) begin
		waitSig <= 1; end // waitlesin
	else begin
		waitSig <= 0; end // beklemesin
 end 
  // Switchlerin degismesi 
  
  // buna gore out sinyalleri geliyor
always@(*) begin  : SWITCH_CONTROL
		integer i;
	integer sayi ;
	sayi = 0;
for( i = 0 ; i < 10 ; i=i+1)begin
    if( switch[i] && led[i]) begin
				sayi  = sayi + 1;
            //out = true olsun ki state seyi degissin outa gore degisen leveller olcak LEVEL1 ise LEVEL1_OUT'a gelicek -> burdan geridonerse seyleri 0'lamak lazim.
            //point = gecen zaman ekle . min puan kazanir 
		end
	end
	if(sayi == 3 && (state == state_LEVEL1 || state == state_LEVEL2))begin	
			out  <= 1 ;
	end
	else if(sayi == 2 && (state == state_LEVEL3 || state == state_LEVEL4))begin	
			out  <= 1 ;
	end
	else if(sayi == 1 && (state == state_LEVEL5 || state == state_LEVEL6))begin	
			out  <= 1 ;
	end
	else begin
	out  <= 0;
	end
	
end
  

  
  // LED loop logic
  //level1 1,3,5 starting all right  low hız
  //level2 2,6,9  r l l low hız
  // level3 4,8 l l sola mid hız
  //level 4  9,5 1 sag 1 sol
  
  integer sifir;
  always @(pulselow) begin : LED_LOGICLOW

  case(currentstatelevel1)
  state_zero: begin
				for(sifir = 0;sifir<10;sifir=sifir+1)
					led[sifir] = 0;
				if(state == state_LEVEL1)begin	
				led[1] <= 1;
            led[5] <= 1;
            led[3] <= 1;
				nexstatelevel1 = state_one;
				end
				 else if(state == state_LEVEL2) begin
				led[2] <= 1;
            led[6] <= 1;
            led[9] <= 1;
				nexstatelevel2 = state_one;

				end
				else if(state == state_LEVEL3) begin
				led[4] <= 1;
            led[8] <= 1;
          
				nexstatelevel3 = state_one;

				end
				else if(state == state_LEVEL4) begin
				led[9] <= 1;
            led[5] <= 1;
          
				nexstatelevel4 = state_one;

				end
				else if(state == state_LEVEL5) begin
            led[5] <= 1;
				nexstatelevel5 = state_one;

				end
				else if(state == state_LEVEL6) begin
            led[5] <= 1;
				nexstatelevel6 = state_one;

				end
				
  end
  state_one: begin
				for(sifir = 0;sifir<10;sifir=sifir+1)
					led[sifir] = 0;
				if(state == state_LEVEL1)begin	
				led[2] <= 1;
            led[6] <= 1;
            led[4] <= 1;
				nexstatelevel1 = state_two;

				end	 else if(state == state_LEVEL2) begin
				led[3] <= 1;
            led[5] <= 1;
            led[8] <= 1;
				nexstatelevel2 = state_two;

				end
				 else if(state == state_LEVEL3) begin
				led[3] <= 1;
            led[7] <= 1;
				nexstatelevel3 = state_two;

				end
				else if(state == state_LEVEL4) begin
				led[0] <= 1;
            led[4] <= 1;
          
				nexstatelevel4 = state_two;

				end
				
					else if(state == state_LEVEL5) begin
            led[6] <= 1;
				nexstatelevel5 = state_two;

				end
				else if(state == state_LEVEL6) begin
            led[4] <= 1;
				nexstatelevel5 = state_two;

				end
				
  end
  state_two: begin
				for(sifir = 0;sifir<10;sifir=sifir+1)
					led[sifir] = 0;
				if(state == state_LEVEL1)begin	
				led[3] <= 1;
            led[7] <= 1;
            led[5] <= 1;
								nexstatelevel1 = state_three;

				end
						 else if(state == state_LEVEL2) begin
				led[4] <= 1;
            led[4] <= 1;
            led[7] <= 1;
				nexstatelevel2 = state_three;
				end
				 else if(state == state_LEVEL3) begin
				led[2] <= 1;
            led[6] <= 1;
				nexstatelevel3 = state_three;

				end
				else if(state == state_LEVEL4) begin
				led[1] <= 1;
            led[3] <= 1;
          
				nexstatelevel4 = state_three;

				end
				
					else if(state == state_LEVEL5) begin
            led[7] <= 1;
				nexstatelevel5 = state_three;

				end
					else if(state == state_LEVEL6) begin
            led[3] <= 1;
				nexstatelevel6 = state_two;

				end
				
  end
  state_three: begin
				for(sifir = 0;sifir<10;sifir=sifir+1)
					led[sifir] = 0;
				if(state == state_LEVEL1)begin	
				led[4] <= 1;
            led[8] <= 1;
            led[6] <= 1;
				nexstatelevel1 = state_four;
				end
						 else if(state == state_LEVEL2)begin
				led[5] <= 1;
            led[3] <= 1;
            led[6] <= 1;
				nexstatelevel2 = state_four;
				end
				 else if(state == state_LEVEL3) begin
				led[1] <= 1;
            led[5] <= 1;
				nexstatelevel3 = state_four;

				end
				else if(state == state_LEVEL4) begin
				led[2] <= 1;
            led[2] <= 1;
          
				nexstatelevel4 = state_four;

				end
					else if(state == state_LEVEL5) begin
            led[8] <= 1;
				nexstatelevel5 = state_four;

				end
					else if(state == state_LEVEL6) begin
            led[2] <= 1;
				nexstatelevel6 = state_three;

				end
				
  end
  state_four: begin
				for(sifir = 0;sifir<10;sifir=sifir+1)
					led[sifir] = 0;
				if(state == state_LEVEL1)begin	
				led[5] <= 1;
            led[9] <= 1;
            led[7] <= 1;
				nexstatelevel1 = state_five;

				end
				 else if(state == state_LEVEL2) begin
				led[6] <= 1;
            led[2] <= 1;
            led[5] <= 1;
				nexstatelevel2 = state_five;

				end
				 else if(state == state_LEVEL3) begin
				led[0] <= 1;
            led[4] <= 1;
				nexstatelevel3 = state_five;

				end
				else if(state == state_LEVEL4) begin
				led[3] <= 1;
            led[1] <= 1;
          
				nexstatelevel4 = state_five;

				end
					else if(state == state_LEVEL5) begin
            led[9] <= 1;
				nexstatelevel5 = state_five;

				end
					else if(state == state_LEVEL6) begin
            led[1] <= 1;
				nexstatelevel6 = state_five;

				end
				
  end
  state_five: begin
				for(sifir = 0;sifir<10;sifir=sifir+1)
					led[sifir] = 0;
				if(state == state_LEVEL1)begin	
				led[6] <= 1;
            led[0] <= 1;
            led[8] <= 1;
				nexstatelevel1 = state_six;

				
				end
				 else if(state == state_LEVEL2) begin
				led[7] <= 1;
            led[1] <= 1;
            led[4] <= 1;
				nexstatelevel2 = state_six;

				end
				 else if(state == state_LEVEL3) begin
				led[9] <= 1;
            led[3] <= 1;
				nexstatelevel3 = state_six;

				end
				else if(state == state_LEVEL4) begin
				led[4] <= 1;
            led[0] <= 1;
          
				nexstatelevel4 = state_six;

				end
					else if(state == state_LEVEL5) begin
            led[0] <= 1;
				nexstatelevel5 = state_six;

				end
					else if(state == state_LEVEL6) begin
            led[0] <= 1;
				nexstatelevel6 = state_six;

				end
				
  end
  state_six: begin
				for(sifir = 0;sifir<10;sifir=sifir+1)
					led[sifir] = 0;
				if(state == state_LEVEL1)begin	
				led[7] <= 1;
            led[1] <= 1;
            led[9] <= 1;
				nexstatelevel1 = state_seven;

				end
				 else if(state == state_LEVEL2) begin
				led[8] <= 1;
            led[0] <= 1;
            led[3] <= 1;
				nexstatelevel2 = state_seven;

				end
				 else if(state == state_LEVEL3) begin
				led[8] <= 1;
            led[2] <= 1;
				nexstatelevel3 = state_seven;

				end
				else if(state == state_LEVEL4) begin
				led[5] <= 1;
            led[9] <= 1;
          
				nexstatelevel4 = state_seven;

				end
				else if(state == state_LEVEL5) begin
            led[1] <= 1;
				nexstatelevel5 = state_seven;

				end
					else if(state == state_LEVEL6) begin
            led[9] <= 1;
				nexstatelevel6 = state_seven;

				end
  end
  state_seven: begin
				for(sifir = 0;sifir<10;sifir=sifir+1)
					led[sifir] = 0;
				if(state == state_LEVEL1)begin	
				led[8] <= 1;
            led[2] <= 1;
            led[0] <= 1;
				nexstatelevel1 = state_eight;

				end
				 else if(state == state_LEVEL2) begin
				led[8] <= 1;
            led[9] <= 1;
            led[2] <= 1;
				nexstatelevel2 = state_eight;

				end
				 else if(state == state_LEVEL3) begin
				led[7] <= 1;
            led[1] <= 1;
				nexstatelevel3 = state_eight;

				end
				else if(state == state_LEVEL4) begin
				led[6] <= 1;
            led[8] <= 1;
          
				nexstatelevel4 = state_eight;

				end
				else if(state == state_LEVEL5) begin
            led[2] <= 1;
				nexstatelevel5 = state_eight;

				end
					else if(state == state_LEVEL6) begin
            led[8] <= 1;
				nexstatelevel6 = state_eight;

				end
  end
  state_eight: begin
  for(sifir = 0;sifir<10;sifir=sifir+1)
					led[sifir] = 0;
				if(state == state_LEVEL1)begin	
				led[9] <= 1;
            led[3] <= 1;
            led[1] <= 1;
				nexstatelevel1 = state_nine;
				end
				 else if(state == state_LEVEL2) begin
				led[9] <= 1;
            led[8] <= 1;
            led[1] <= 1;
				nexstatelevel2 = state_nine;

				end
				 else if(state == state_LEVEL3) begin
				led[6] <= 1;
            led[0] <= 1;
				nexstatelevel3 = state_nine;

				end
				else if(state == state_LEVEL4) begin
				led[7] <= 1;
            led[7] <= 1;
          
				nexstatelevel4 = state_nine;

				end
				else if(state == state_LEVEL5) begin
            led[3] <= 1;
				nexstatelevel5 = state_nine;

				end
					else if(state == state_LEVEL6) begin
            led[7] <= 1;
				nexstatelevel6 = state_nine;

				end
  end
  state_nine: begin
  for(sifir = 0;sifir<10;sifir=sifir+1)
					led[sifir] = 0;
				if(state == state_LEVEL1)begin	
				led[0] <= 1;
            led[4] <= 1;
            led[2] <= 1;
				nexstatelevel1 = state_zero;
				end
				 else if(state == state_LEVEL2) begin
				led[0] <= 1;
            led[7] <= 1;
            led[0] <= 1;
				nexstatelevel2 = state_zero;

				end
				 else if(state == state_LEVEL3) begin
				led[5] <= 1;
            led[9] <= 1;
				nexstatelevel3 = state_zero;

				end
				else if(state == state_LEVEL4) begin
				led[8] <= 1;
            led[6] <= 1;
          
				nexstatelevel4 = state_zero;

				end
				else if(state == state_LEVEL5) begin
            led[4] <= 1;
				nexstatelevel5 = state_zero;

				end
					else if(state == state_LEVEL6) begin
            led[6] <= 1;
				nexstatelevel6 = state_zero;

				end
  end
  default: begin
        for(sifir = 0;sifir<10;sifir=sifir+1)
				led[sifir] = 0;
				end

  endcase
  end
  endmodule