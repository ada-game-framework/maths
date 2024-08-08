------------------------------------------------------------------------------------------------------------------------
--  This source code is subject to the BSD license, see the LICENCE file in the root of this directory.
------------------------------------------------------------------------------------------------------------------------
package body Maths.Matrix3s is
   use type Vector3s.Vector3;

   function "+" (Left, Right : Matrix3) return Matrix3 is
   begin
      return M : Matrix3 (Vectors) do
         M.Axes (X) := Left.Axes (X) + Right.Axes (X);
         M.Axes (Y) := Left.Axes (Y) + Right.Axes (Y);
         M.Axes (Z) := Left.Axes (Z) + Right.Axes (Z);
      end return;
   end "+";


   function "-" (Left, Right : Matrix3) return Matrix3 is
   begin
      return M : Matrix3 (Vectors) do
         M.Axes (X) := Left.Axes (X) - Right.Axes (X);
         M.Axes (Y) := Left.Axes (Y) - Right.Axes (Y);
         M.Axes (Z) := Left.Axes (Z) - Right.Axes (Z);
      end return;
   end "-";


   function "*" (Left : Matrix3; Right : Vector3s.Vector3) return Vector3s.Vector3 is
   begin
      return V : Vector3s.Vector3 (Vector3s.Components) do
         V.Elements := (Vector3s.X => Left.Elements (X_Axis_X) * Right.Elements (Vector3s.X) +
                                      Left.Elements (X_Axis_Y) * Right.Elements (Vector3s.Y) +
                                      Left.Elements (X_Axis_Z) * Right.Elements (Vector3s.Z),

                        Vector3s.Y => Left.Elements (Y_Axis_X) * Right.Elements (Vector3s.X) +
                                      Left.Elements (Y_Axis_Y) * Right.Elements (Vector3s.Y) +
                                      Left.Elements (Y_Axis_Z) * Right.Elements (Vector3s.Z),

                        Vector3s.Z => Left.Elements (Z_Axis_X) * Right.Elements (Vector3s.X) +
                                      Left.Elements (Z_Axis_Y) * Right.Elements (Vector3s.Y) +
                                      Left.Elements (Z_Axis_Z) * Right.Elements (Vector3s.Z));
      end return;
   end "*";


   function Translation (X, Y : Float) return Matrix3 is
   begin
      return M : Matrix3 (Which => Components) do
         M.Elements := (Translation_X => X, Translation_Y => Y,
                        Translation_W | X_Axis_X | Y_Axis_Y => 1.0,
                        others => 0.0);
      end return;
   end Translation;
end Maths.Matrix3s;
