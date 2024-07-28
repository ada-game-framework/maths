------------------------------------------------------------------------------------------------------------------------
--  This source code is subject to the BSD license, see the LICENCE file in the root of this directory.
------------------------------------------------------------------------------------------------------------------------
with Ada.Numerics.Generic_Elementary_Functions;

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
end Maths.Vector4s;
