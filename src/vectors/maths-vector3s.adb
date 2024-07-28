------------------------------------------------------------------------------------------------------------------------
--  This source code is subject to the BSD license, see the LICENCE file in the root of this directory.
------------------------------------------------------------------------------------------------------------------------
with Ada.Numerics.Generic_Elementary_Functions;

package body Maths.Vector3s is
   package Trig is new Ada.Numerics.Generic_Elementary_Functions (Float);

   function "+" (Left, Right : Vector3) return Vector3 is
   begin
      return V : Vector3 (Components) do
         V.Elements (X) := Left.Elements (X) + Right.Elements (X);
         V.Elements (Y) := Left.Elements (Y) + Right.Elements (Y);
         V.Elements (Z) := Left.Elements (Z) + Right.Elements (Z);
      end return;
   end "+";


   function "-" (Left, Right : Vector3) return Vector3 is
   begin
      return V : Vector3 (Components) do
         V.Elements (X) := Left.Elements (X) - Right.Elements (X);
         V.Elements (Y) := Left.Elements (Y) - Right.Elements (Y);
         V.Elements (Z) := Left.Elements (Z) - Right.Elements (Z);
      end return;
   end "-";


   function "*" (Left : Vector3; Scalar : Float) return Vector3 is
   begin
      return V : Vector3 (Components) do
         V.Elements (X) := Left.Elements (X) * Scalar;
         V.Elements (Y) := Left.Elements (Y) * Scalar;
         V.Elements (Z) := Left.Elements (Z) * Scalar;
      end return;
   end "*";


   --  ||V|| = Sqrt(V.V)
   function Length (V : Vector3) return Float is
   begin
      return Trig.Sqrt ((V.Elements (X) * V.Elements (X)) +
                        (V.Elements (Y) * V.Elements (Y)) +
                        (V.Elements (Z) * V.Elements (Z)));
   end Length;


   --              V
   --  Norm(V) = -----
   --            ||V||
   procedure Normalise (V : in out Vector3) is
      L : constant Float := Length (V);
   begin
      V.Elements :=  (X => V.Elements (X) / L,
                      Y => V.Elements (Y) / L,
                      Z => V.Elements (Z) / L);
   end Normalise;
end Maths.Vector3s;
