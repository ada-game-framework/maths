------------------------------------------------------------------------------------------------------------------------
--  This source code is subject to the BSD license, see the LICENCE file in the root of this directory.
------------------------------------------------------------------------------------------------------------------------
package body Maths.Stacks is
   procedure Init (Self : in out Stack) is
   begin
      Self.Elements := new Element_Array (1 .. Capacity);
   end Init;


   function Top (Self : aliased in out Stack) return Reference_Type is
   begin
      return R : Reference_Type (Data => Self.Elements (Self.Current_Top)'Access) do
         null;
      end return;
   end Top;


   function Is_Empty (Self : Stack) return Boolean is
   begin
      return Self.Current_Top = Natural'First;
   end Is_Empty;
end Maths.Stacks;
