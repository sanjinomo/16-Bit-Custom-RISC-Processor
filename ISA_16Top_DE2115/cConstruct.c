void main() {
    
    int a = 10;             // ADDI $a0, $zero, 10
    int b = 20;             // ADDI $s0, $zero, 20
    b = a + b;              // ADD (b becomes 30)
    b = b - a;              // SUB (b returns to 20)
    a = a & b;              // AND (a becomes 0)
    a = a | b;              // OR  (a becomes 20)
    a = 15;                 // ADDI  
    a = (a < b) ? 1 : 0;    // SLT (15 < 20 is True, so a becomes 1)
    b = 50;                 // LUI + ORI sequence
    memory[4] = b;          // SW (Store 50 to address 4)
    a = memory[4];          // LW (Load 50 from address 4 into a)
      
	if (a != b) {           
        b = b + 1;           // BEQ $a0, $s0, 1 
    }

    if (a == 0) {
        exit();              // BNE $a0, $zero, 1 
    }

    goto jump_target;       // J 0x12


jump_target:
    function_call();        // JAL 0x15
    return;                 // HALT (PC = 0x13)
}

void function_call() {
    return;                 // JR $ra
}