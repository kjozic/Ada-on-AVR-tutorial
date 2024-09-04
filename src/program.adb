with System;              use System;
with System.Machine_Code; use System.Machine_Code;

package body Program is
   function Get_Byte (Addr : Program_Address) return Unsigned_8 is
      Result : Unsigned_8;
   begin
      Asm
        ("lpm %0, Z", Outputs => Unsigned_8'Asm_Output ("=r", Result),
         Inputs               => Program_Address'Asm_Input ("z", Addr));
      return Result;
   end Get_Byte;

   procedure Receive_Handler is
   begin
      null;
   end Receive_Handler;

   procedure Main is
   begin
      DDRB  := 255;
      PORTB := Get_Byte (ProgmemVar'Address);

      sei;

      loop
         null;
      end loop;
   end Main;
end Program;
