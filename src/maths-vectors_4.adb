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
end Maths.Vectors_4;
