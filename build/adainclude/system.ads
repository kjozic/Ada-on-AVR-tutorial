--  Configuration pragmas
pragma Discard_Names;

--  Restriction pragmas
pragma Restrictions (No_Allocators);
pragma Restrictions (No_Anonymous_Allocators);
pragma Restrictions (No_Asynchronous_Control);
pragma Restrictions (No_Calendar);
pragma Restrictions (No_Exception_Propagation);
pragma Restrictions (No_Exception_Registration);
pragma Restrictions (No_Finalization);
pragma Restrictions (No_Floating_Point);
pragma Restrictions (No_Implicit_Dynamic_Code);
pragma Restrictions (No_Secondary_Stack);
pragma Restrictions (No_Tasking);

package System is
   --  Program unit level restrictions
   pragma Pure;

   --  We need this type to access the address of a variable
   type Address is mod 65_536;
private
   --  System private part
   Run_Time_Name             : constant String  := "Minimal AVR Runtime";
   Backend_Divide_Checks     : constant Boolean := False;
   Backend_Overflow_Checks   : constant Boolean := True;
   ZCX_By_Default            : constant Boolean := True;
   Configurable_Run_Time     : constant Boolean := True;
   Suppress_Standard_Library : constant Boolean := True;
   Preallocated_Stacks       : constant Boolean := False;
   Duration_32_Bits          : constant Boolean := True;
   Atomic_Sync_Default       : constant Boolean := False;
   Support_Aggregates        : constant Boolean := True;
   Support_Atomic_Primitives : constant Boolean := True;
   Support_Composite_Assign  : constant Boolean := True;
   Support_Composite_Compare : constant Boolean := True;
   Support_Long_Shifts       : constant Boolean := True;
   Support_Nondefault_SSO    : constant Boolean := True;
   Always_Compatible_Rep     : constant Boolean := True;
   Stack_Check_Probes        : constant Boolean := False;
   Stack_Check_Limits        : constant Boolean := False;
   Stack_Check               : constant Boolean := False;
   Command_Line_Args         : constant Boolean := False;
   Exit_Status_Supported     : constant Boolean := False;
   Use_Ada_Main_Program_Name : constant Boolean := False;
   Denorm                    : constant Boolean := True;
   Machine_Rounds            : constant Boolean := True;
   Machine_Overflows         : constant Boolean := False;
   Signed_Zeros              : constant Boolean := True;
end System;
