------------------------------------------------------------------------------------------------------------------------
--  This source code is subject to the BSD license, see the LICENCE file in the root of this directory.
------------------------------------------------------------------------------------------------------------------------
package body Maths.Matrix4s is
   use type Vector4s.Vector4;

   function "+" (Left, Right : Matrix4) return Matrix4 is
   begin
      return M : Matrix4 (Vectors) do
         M.Axes (X) := Left.Axes (X) + Right.Axes (X);
         M.Axes (Y) := Left.Axes (Y) + Right.Axes (Y);
         M.Axes (Z) := Left.Axes (Z) + Right.Axes (Z);
         M.Axes (T) := Left.Axes (T) + Right.Axes (T);
      end return;
   end "+";


   function "-" (Left, Right : Matrix4) return Matrix4 is
   begin
      return M : Matrix4 (Vectors) do
         M.Axes (X) := Left.Axes (X) - Right.Axes (X);
         M.Axes (Y) := Left.Axes (Y) - Right.Axes (Y);
         M.Axes (Z) := Left.Axes (Z) - Right.Axes (Z);
         M.Axes (T) := Left.Axes (T) - Right.Axes (T);
      end return;
   end "-";


   function "*" (Left : Matrix4; Right : Vector4s.Vector4) return Vector4s.Vector4 is
   begin
      return V : Vector4s.Vector4 (Vector4s.SIMD) do
         V.Elements := (Vector4s.X => Left.Elements (X_Axis_X) * Right.Elements (Vector4s.X) +
                                      Left.Elements (X_Axis_Y) * Right.Elements (Vector4s.Y) +
                                      Left.Elements (X_Axis_Z) * Right.Elements (Vector4s.Z) +
                                      Left.Elements (X_Axis_W) * Right.Elements (Vector4s.W),

                        Vector4s.Y => Left.Elements (Y_Axis_X) * Right.Elements (Vector4s.X) +
                                      Left.Elements (Y_Axis_Y) * Right.Elements (Vector4s.Y) +
                                      Left.Elements (Y_Axis_Z) * Right.Elements (Vector4s.Z) +
                                      Left.Elements (Y_Axis_W) * Right.Elements (Vector4s.W),

                        Vector4s.Z => Left.Elements (Z_Axis_X) * Right.Elements (Vector4s.X) +
                                      Left.Elements (Z_Axis_Y) * Right.Elements (Vector4s.Y) +
                                      Left.Elements (Z_Axis_Z) * Right.Elements (Vector4s.Z) +
                                      Left.Elements (Z_Axis_W) * Right.Elements (Vector4s.W),

                        Vector4s.W => Left.Elements (Translation_X) * Right.Elements (Vector4s.X) +
                                      Left.Elements (Translation_Y) * Right.Elements (Vector4s.Y) +
                                      Left.Elements (Translation_Z) * Right.Elements (Vector4s.Z) +
                                      Left.Elements (Translation_W) * Right.Elements (Vector4s.W));
      end return;
   end "*";


   function Translation (X, Y, Z : Float) return Matrix4 is
   begin
      return M : Matrix4 (Which => Components) do
         M.Elements := (Translation_X => X, Translation_Y => Y, Translation_Z => Z,
                        X_Axis_X | Y_Axis_Y | Z_Axis_Z => 1.0,
                        others => 0.0);
      end return;
   end Translation;
end Maths.Matrix4s;
