package System.Machine_Code is
   pragma Pure;

   type Asm_Input_Operand is private;
   type Asm_Output_Operand is private;
   type Asm_Insn is private;

   procedure Asm (
      Template : String;
      Outputs : Asm_Output_Operand;
      Inputs   : Asm_Input_Operand;
      Clobber : String := "";
      Volatile : Boolean := False
    );

   pragma Import (Intrinsic, Asm);

private
   type Asm_Input_Operand is new Integer;
   type Asm_Output_Operand is new Integer;
   type Asm_Insn           is new Integer;
end System.Machine_Code;
