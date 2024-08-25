with System;              use System;
with Other;               use Other;
with System.Machine_Code; use System.Machine_Code;

package body Program is
   function Get_Byte (Addr : Program_Address) return Unsigned_8 is
      Result : Unsigned_8;
   begin
      Asm
        ("lpm" & ASCII.LF & "mov %0, r0",
         Outputs => Unsigned_8'Asm_Output ("=r", Result),
         Inputs  => Program_Address'Asm_Input ("z", Addr), Clobber => "r0");
      return Result;
   end Get_Byte;

   procedure Receive_Handler is
   begin
      null;
   end Receive_Handler;

   procedure Main is
   begin
      DDRB  := 255;
      PORTB := Get_Byte (State1'Address);

      Other.sei;

      loop
         null;
      end loop;
   end Main;
end Program;
