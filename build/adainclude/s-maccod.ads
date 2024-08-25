package System.Machine_Code is
   pragma Pure;

   type Asm_Input_Operand  is private;
   type Asm_Output_Operand is private;
   --  These types are never used directly, they are declared only so that
   --  the calls to Asm are type correct according to Ada semantic rules.

   No_Input_Operands  : constant Asm_Input_Operand;
   No_Output_Operands : constant Asm_Output_Operand;

   type Asm_Input_Operand_List  is
     array (Integer range <>) of Asm_Input_Operand;

   type Asm_Output_Operand_List is
     array (Integer range <>) of Asm_Output_Operand;

   type Asm_Insn is private;
   --  This type is not used directly. It is declared only so that the
   --  aggregates used in code statements are type correct by Ada rules.

   --   procedure Asm (
   --     Template : String;
   --     Outputs  : Asm_Output_Operand_List;
   --     Inputs   : Asm_Input_Operand_List;
   --     Clobber  : String  := "";
   --     Volatile : Boolean := False);

   procedure Asm (
                  Template : String;
                  Outputs  : Asm_Output_Operand;
                  Inputs   : Asm_Input_Operand;
                  Clobber  : String  := "";
                  Volatile : Boolean := False
                 );

   --   procedure Asm (
   --     Template : String;
   --     Outputs  : Asm_Output_Operand := No_Output_Operands;
   --     Inputs   : Asm_Input_Operand_List;
   --     Clobber  : String  := "";
   --     Volatile : Boolean := False);

   --   procedure Asm (
   --     Template : String;
   --     Outputs  : Asm_Output_Operand_List;
   --     Inputs   : Asm_Input_Operand := No_Input_Operands;
   --     Clobber  : String  := "";
   --     Volatile : Boolean := False);

   --   procedure Asm (
   --     Template : String;
   --     Outputs  : Asm_Output_Operand := No_Output_Operands;
   --     Inputs   : Asm_Input_Operand  := No_Input_Operands;
   --     Clobber  : String  := "";
   --     Volatile : Boolean := False);

   --   function Asm (
   --     Template : String;
   --     Outputs  : Asm_Output_Operand_List;
   --     Inputs   : Asm_Input_Operand_List;
   --     Clobber  : String  := "";
   --     Volatile : Boolean := False) return Asm_Insn;

   --   function Asm (
   --     Template : String;
   --     Outputs  : Asm_Output_Operand := No_Output_Operands;
   --     Inputs   : Asm_Input_Operand_List;
   --     Clobber  : String  := "";
   --     Volatile : Boolean := False) return Asm_Insn;

   --   function Asm (
   --     Template : String;
   --     Outputs  : Asm_Output_Operand_List;
   --     Inputs   : Asm_Input_Operand := No_Input_Operands;
   --     Clobber  : String  := "";
   --     Volatile : Boolean := False) return Asm_Insn;

   --   function Asm (
   --     Template : String;
   --     Outputs  : Asm_Output_Operand := No_Output_Operands;
   --     Inputs   : Asm_Input_Operand  := No_Input_Operands;
   --     Clobber  : String  := "";
   --     Volatile : Boolean := False) return Asm_Insn;

   pragma Import (Intrinsic, Asm);

private

   type Asm_Input_Operand  is new Integer;
   type Asm_Output_Operand is new Integer;
   type Asm_Insn           is new Integer;
   --  All three of these types are dummy types, to meet the requirements of
   --  type consistency. No values of these types are ever referenced.

   No_Input_Operands  : constant Asm_Input_Operand  := 0;
   No_Output_Operands : constant Asm_Output_Operand := 0;

end System.Machine_Code;
