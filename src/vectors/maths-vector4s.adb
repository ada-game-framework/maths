------------------------------------------------------------------------------------------------------------------------
--  This source code is subject to the BSD license, see the LICENCE file in the root of this directory.
------------------------------------------------------------------------------------------------------------------------
with Ada.Numerics.Generic_Elementary_Functions;
with Ada.Strings.Fixed;
with Ada.Text_IO;

package body Maths.Vector4s is
   package Trig is new Ada.Numerics.Generic_Elementary_Functions (Float);

   function "+" (Left, Right : Vector4) return Vector4 is
   begin
      return V : Vector4 (Components) do
         V.Elements (X) := Left.Elements (X) + Right.Elements (X);
         V.Elements (Y) := Left.Elements (Y) + Right.Elements (Y);
         V.Elements (Z) := Left.Elements (Z) + Right.Elements (Z);
         V.Elements (W) := Left.Elements (W) + Right.Elements (W);
      end return;
   end "+";


   function "-" (Left, Right : Vector4) return Vector4 is
   begin
      return V : Vector4 (Components) do
         V.Elements (X) := Left.Elements (X) - Right.Elements (X);
         V.Elements (Y) := Left.Elements (Y) - Right.Elements (Y);
         V.Elements (Z) := Left.Elements (Z) - Right.Elements (Z);
         V.Elements (W) := Left.Elements (W) - Right.Elements (W);
      end return;
   end "-";


   function "*" (Left : Vector4; Scalar : Float) return Vector4 is
   begin
      return V : Vector4 (Components) do
         V.Elements (X) := Left.Elements (X) * Scalar;
         V.Elements (Y) := Left.Elements (Y) * Scalar;
         V.Elements (Z) := Left.Elements (Z) * Scalar;
         V.Elements (W) := Left.Elements (W) * Scalar;
      end return;
   end "*";


   --  ||V|| = Sqrt(V.V)
   function Length (V : Vector4) return Float is
   begin
      return Trig.Sqrt ((V.Elements (X) * V.Elements (X)) +
                        (V.Elements (Y) * V.Elements (Y)) +
                        (V.Elements (Z) * V.Elements (Z)) +
                        (V.Elements (W) * V.Elements (W)));
   end Length;


   --              V
   --  Norm(V) = -----
   --            ||V||
   procedure Normalise (V : in out Vector4) is
      L : constant Float := Length (V);
   begin
      V.Elements :=  (X => V.Elements (X) / L,
                      Y => V.Elements (Y) / L,
                      Z => V.Elements (Z) / L,
                      W => V.Elements (W) / L);
   end Normalise;


   procedure Vector4_Image (Buffer : in out Ada.Strings.Text_Buffers.Root_Buffer_Type'Class; Arg : in Vector4) is
      function Convert (F : Float) return String is
         use Ada.Strings;
         use Ada.Strings.Fixed;
         use Ada.Text_IO;

         package FIO is new Float_IO (Float);
         use FIO;

         Result : String (1 .. 20) := (others => ' ');
      begin
         Put (To   => Result,
              Item => F,
              Aft  => 4,
              Exp  => 0);

         return Trim (Result, Both);
      end Convert;
   begin
      Buffer.Put ("(X => " & Convert (Arg.Elements (X)) &
                  ", Y => " & Convert (Arg.Elements (Y)) &
                  ", Z => " & Convert (Arg.Elements (Z)) &
                  ", W => " & Convert (Arg.Elements (W)) & ")");
   end Vector4_Image;
end Maths.Vector4s;
