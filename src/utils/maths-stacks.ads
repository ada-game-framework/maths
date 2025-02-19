------------------------------------------------------------------------------------------------------------------------
--  This source code is subject to the BSD license, see the LICENCE file in the root of this directory.
------------------------------------------------------------------------------------------------------------------------
--  Maths.Stacks
------------------------------------------------------------------------------------------------------------------------
generic
   type Element_Type is private;

   Capacity : Positive := 10;

   --  with function "=" (Left, Right : Element_Type)
   --     return Boolean is <>;
package Maths.Stacks is
   type Stack is limited private;

   type Reference_Type (Data : not null access Element_Type) is limited private with
     Implicit_Dereference => Data;

   procedure Init (Self : in out Stack; Size : Natural := Capacity);

   --  Push a copy of the top onto the top.
   procedure Push_Top (Self : in out Stack) with
     Inline;

   procedure Push (Self : in out Stack; New_Element : Element_Type);

   --  procedure Push (Self : in out Stack; New_Top : Reference_Type);

   function Pop (Self : in out Stack) return Element_Type;

   function Top (Self : aliased in out Stack) return Reference_Type with
     Inline;

   function Is_Empty (Self : Stack) return Boolean with
     Inline;
private
   type Element_Array is array (Positive range <>) of aliased Element_Type;
   type Element_Access is access all Element_Array;

   type Stack is limited record
      Elements         : Element_Access := null;
      Current_Capacity : Natural        := Natural'First;
      Current_Top      : Natural        := Natural'First; --  When 0, stack = empty.
   end record;

   procedure Resize (Self : in out Stack; Increase_By : Natural := Capacity);

   type Reference_Type (Data : not null access Element_Type) is limited null record;
end Maths.Stacks;
