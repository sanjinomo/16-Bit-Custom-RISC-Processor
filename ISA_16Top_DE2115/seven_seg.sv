module seven_seg(
		
	input logic [3:0] HEX,
    output logic [6:0] segment
);
  
  always_comb
    case (HEX)
       0: segment = 7'b100_0000;
       1: segment = 7'b111_1001;
       2: segment = 7'b010_0100;
       3: segment = 7'b011_0000;
       4: segment = 7'b001_1001;
       5: segment = 7'b001_0010;
       6: segment = 7'b000_0010;
       7: segment = 7'b111_1000;
       8: segment = 7'b000_0000;
       9: segment = 7'b001_1000;
      10: segment = 7'b000_1000; // 'A'
      11: segment = 7'b000_0011; // 'b'
      12: segment = 7'b100_0110; // 'C'
      13: segment = 7'b010_0001; // 'd'
      14: segment = 7'b000_0110; // 'E'
      15: segment = 7'b000_1110; // 'F' 
     default: segment = 7'b111_1111;
   endcase
endmodule
