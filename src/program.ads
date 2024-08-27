with System;

package Program is
  pragma Preelaborate;
  subtype Unsigned_8 is Integer range 0 .. 255;
  subtype Program_Address is System.Address;

  PORTB : Unsigned_8 with
   Address => 16#38#, Size => 8, Volatile => True;

  DDRB : Integer range 0 .. 255 with
   Address => 16#37#, Size => 8, Volatile => True;

  State1 : Unsigned_8 := 171 with
   Linker_Section => ".progmem.data";

  function Get_Byte (Addr : Program_Address) return Unsigned_8;
  procedure Receive_Handler;
  pragma Machine_Attribute
   (Entity => Receive_Handler, Attribute_Name => "signal");
  pragma Export (C, Receive_Handler, "__vector_11");

  procedure Main;
end Program;
