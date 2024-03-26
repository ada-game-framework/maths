------------------------------------------------------------------------------------------------------------------------
--  This source code is subject to the BSD license, see the LICENCE file in the root of this directory.
------------------------------------------------------------------------------------------------------------------------
package body Maths.Vectors_4 is
   function "+" (Left, Right : Vector) return Vector is
   begin
      return V : Vector (Components) do
         V.Elements (X) := Left.Elements (X) + Right.Elements (X);
         V.Elements (Y) := Left.Elements (Y) + Right.Elements (Y);
         V.Elements (Z) := Left.Elements (Z) + Right.Elements (Z);
         V.Elements (W) := Left.Elements (W) + Right.Elements (W);
      end return;
   end "+";


   function "*" (Left : Vector; Scalar : Float) return Vector is
   begin
      return V : Vector (Components) do
         V.Elements (X) := Left.Elements (X) * Scalar;
         V.Elements (Y) := Left.Elements (Y) * Scalar;
         V.Elements (Z) := Left.Elements (Z) * Scalar;
         V.Elements (W) := Left.Elements (W) * Scalar;
      end return;
   end "*";
end Maths.Vectors_4;
