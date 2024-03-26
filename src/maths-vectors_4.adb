------------------------------------------------------------------------------------------------------------------------
--  This source code is subject to the BSD license, see the LICENCE file in the root of this directory.
------------------------------------------------------------------------------------------------------------------------
with Ada.Numerics.Generic_Elementary_Functions;

package body Maths.Vectors_4 is
   package Trig is new Ada.Numerics.Generic_Elementary_Functions (Float);

   function "+" (Left, Right : Vector) return Vector is
   begin
      return V : Vector (Components) do
         V.Elements (X) := Left.Elements (X) + Right.Elements (X);
         V.Elements (Y) := Left.Elements (Y) + Right.Elements (Y);
         V.Elements (Z) := Left.Elements (Z) + Right.Elements (Z);
         V.Elements (W) := Left.Elements (W) + Right.Elements (W);
      end return;
   end "+";


   function "-" (Left, Right : Vector) return Vector is
   begin
      return V : Vector (Components) do
         V.Elements (X) := Left.Elements (X) - Right.Elements (X);
         V.Elements (Y) := Left.Elements (Y) - Right.Elements (Y);
         V.Elements (Z) := Left.Elements (Z) - Right.Elements (Z);
         V.Elements (W) := Left.Elements (W) - Right.Elements (W);
      end return;
   end "-";


   function "*" (Left : Vector; Scalar : Float) return Vector is
   begin
      return V : Vector (Components) do
         V.Elements (X) := Left.Elements (X) * Scalar;
         V.Elements (Y) := Left.Elements (Y) * Scalar;
         V.Elements (Z) := Left.Elements (Z) * Scalar;
         V.Elements (W) := Left.Elements (W) * Scalar;
      end return;
   end "*";


   --  ||V|| = Sqrt(V.V)
   function Length (V : Vector) return Float is
   begin
      return Trig.Sqrt ((V.Elements (X) * V.Elements (X)) +
                        (V.Elements (Y) * V.Elements (Y)) +
                        (V.Elements (Z) * V.Elements (Z)) +
                        (V.Elements (W) * V.Elements (W)));
   end Length;
end Maths.Vectors_4;
