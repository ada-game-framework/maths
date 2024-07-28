------------------------------------------------------------------------------------------------------------------------
--  This source code is subject to the BSD license, see the LICENCE file in the root of this directory.
------------------------------------------------------------------------------------------------------------------------
with Ada.Numerics.Generic_Elementary_Functions;

package body Maths.Vector2s is
   package Trig is new Ada.Numerics.Generic_Elementary_Functions (Float);

   function "+" (Left, Right : Vector2) return Vector2 is
   begin
      return V : Vector2 (Components) do
         V.Elements (X) := Left.Elements (X) + Right.Elements (X);
         V.Elements (Y) := Left.Elements (Y) + Right.Elements (Y);
      end return;
   end "+";


   function "-" (Left, Right : Vector2) return Vector2 is
   begin
      return V : Vector2 (Components) do
         V.Elements (X) := Left.Elements (X) - Right.Elements (X);
         V.Elements (Y) := Left.Elements (Y) - Right.Elements (Y);
      end return;
   end "-";


   function "*" (Left : Vector2; Scalar : Float) return Vector2 is
   begin
      return V : Vector2 (Components) do
         V.Elements (X) := Left.Elements (X) * Scalar;
         V.Elements (Y) := Left.Elements (Y) * Scalar;
      end return;
   end "*";


   --  ||V|| = Sqrt(V.V)
   function Length (V : Vector2) return Float is
   begin
      return Trig.Sqrt ((V.Elements (X) * V.Elements (X)) +
                        (V.Elements (Y) * V.Elements (Y)));
   end Length;


   --              V
   --  Norm(V) = -----
   --            ||V||
   procedure Normalise (V : in out Vector2) is
      L : constant Float := Length (V);
   begin
      V.Elements :=  (X => V.Elements (X) / L,
                      Y => V.Elements (Y) / L);
   end Normalise;
end Maths.Vector2s;
