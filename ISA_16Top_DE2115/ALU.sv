module ALU (
	input logic [15:0] operandA, //from readData1 
	input logic [15:0] operandB, //from readData2
	input logic [2:0] aluControl, //defines what operation
	output logic [15:0] AluResult, //Alu Result
	output logic zero					//zero flag for branch operation 
	

);


	always_comb begin
		case (aluControl)
			3'b000: AluResult = operandA + operandB; //add
			3'b001: AluResult = operandA - operandB; //sub
			3'b010: AluResult = operandA & operandB; //and
			3'b011: AluResult = operandA | operandB; //or
			//SLT will first check if A<B. If true resilt will be 1. Else result will be 0 
			3'b100: AluResult = ($signed(operandA) < $signed(operandB)? 16'h0001:16'h0000); //set less than. Instructed to use signed 16 bits
			3'b101: AluResult = {operandB[7:0], 8'h00}; //LUI load upper 8 bits immediate  
			default: AluResult = 16'h0000; 
		endcase 
	end 
	
	assign zero = (AluResult == 16'h0000);	//when aluResult is 0, we will get zero flag 1 

endmodule 	