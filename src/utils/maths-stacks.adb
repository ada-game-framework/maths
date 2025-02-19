------------------------------------------------------------------------------------------------------------------------
--  This source code is subject to the BSD license, see the LICENCE file in the root of this directory.
------------------------------------------------------------------------------------------------------------------------
with Ada.Unchecked_Deallocation;

package body Maths.Stacks is
   procedure Init (Self : in out Stack; Size : Natural := Capacity) is
   begin
      Self.Elements         := new Element_Array (1 .. Size);
      Self.Current_Capacity := Size;
   end Init;


   procedure Push_Top (Self : in out Stack) is
      S : constant not null access constant Element_Array := Self.Elements;
   begin
      Push (Self, S (Self.Current_Top));
   end Push_Top;


   procedure Push (Self : in out Stack; New_Element : Element_Type) is
      S       : not null access Element_Array := Self.Elements;
      New_Top : constant Natural := Self.Current_Top + 1;
   begin
      --  Are we about to exceed the size?
      if New_Top > Self.Current_Capacity then
         Resize (Self);

         S := Self.Elements;
      end if;

      S (New_Top) := New_Element;

      Self.Current_Top := New_Top;
   end Push;


   --  procedure Push (Self : in out Stack; New_Top : Reference_Type) is
   --  begin
   --     Push (Self, )
   --  end Push;


   function Pop (Self : in out Stack) return Element_Type is
      Result : Element_Type;
   begin
      if Self.Current_Top > Natural'First then
         Result := Self.Elements (Self.Current_Top);

         Self.Current_Top := @ - 1;
      end if;

      return Result;
   end Pop;


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


   procedure Resize (Self : in out Stack; Increase_By : Natural := Capacity) is
      procedure Free is new Ada.Unchecked_Deallocation (Object => Element_Array, Name => Element_Access);

      Temp     : Element_Access := Self.Elements;
      Temp_Top : Natural        := Self.Current_Top;
   begin
      if Self.Elements /= null then
         Init (Self, Self.Elements'Length + Increase_By);

         Self.Elements (Temp'Range) := Temp.all;
         Self.Current_Top           := Temp_Top;

         Free (Temp);
      end if;
   end Resize;
end Maths.Stacks;
