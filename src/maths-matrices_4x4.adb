------------------------------------------------------------------------------------------------------------------------
--  This source code is subject to the BSD license, see the LICENCE file in the root of this directory.
------------------------------------------------------------------------------------------------------------------------
package body Maths.Matrices_4x4 is
   use type Vectors_4.Vector;

   function "+" (Left, Right : Matrix) return Matrix is
   begin
      --  return M : Matrix (Components) do
         --  for I in Matrix_Elements loop
         --     M.Elements (I) := Left.Elements (I) + Right.Elements (I);
         --  end loop;
         --  M.Elements (X_Axis_X) := Left.Elements (X_Axis_X) + Right.Elements (X_Axis_X);
         --  M.Elements (X_Axis_Y) := Left.Elements (X_Axis_Y) + Right.Elements (X_Axis_Y);
         --  M.Elements (X_Axis_Z) := Left.Elements (X_Axis_Z) + Right.Elements (X_Axis_Z);
         --  M.Elements (X_Axis_W) := Left.Elements (X_Axis_W) + Right.Elements (X_Axis_W);

         --  M.Elements (Y_Axis_X) := Left.Elements (Y_Axis_X) + Right.Elements (Y_Axis_X);
         --  M.Elements (Y_Axis_Y) := Left.Elements (Y_Axis_Y) + Right.Elements (Y_Axis_Y);
         --  M.Elements (Y_Axis_Z) := Left.Elements (Y_Axis_Z) + Right.Elements (Y_Axis_Z);
         --  M.Elements (Y_Axis_W) := Left.Elements (Y_Axis_W) + Right.Elements (Y_Axis_W);

         --  M.Elements (Z_Axis_X) := Left.Elements (Z_Axis_X) + Right.Elements (Z_Axis_X);
         --  M.Elements (Z_Axis_Y) := Left.Elements (Z_Axis_Y) + Right.Elements (Z_Axis_Y);
         --  M.Elements (Z_Axis_Z) := Left.Elements (Z_Axis_Z) + Right.Elements (Z_Axis_Z);
         --  M.Elements (Z_Axis_W) := Left.Elements (Z_Axis_W) + Right.Elements (Z_Axis_W);

         --  M.Elements (W_Axis_X) := Left.Elements (W_Axis_X) + Right.Elements (W_Axis_X);
         --  M.Elements (W_Axis_Y) := Left.Elements (W_Axis_Y) + Right.Elements (W_Axis_Y);
         --  M.Elements (W_Axis_Z) := Left.Elements (W_Axis_Z) + Right.Elements (W_Axis_Z);
         --  M.Elements (W_Axis_W) := Left.Elements (W_Axis_W) + Right.Elements (W_Axis_W);

      return M : Matrix (Vectors) do
         M.Axes (X) := Left.Axes (X) + Right.Axes (X);
         M.Axes (Y) := Left.Axes (Y) + Right.Axes (Y);
         M.Axes (Z) := Left.Axes (Z) + Right.Axes (Z);
         M.Axes (W) := Left.Axes (W) + Right.Axes (W);
      end return;
   end "+";


   function "*" (Left : Matrix; Right : Vectors_4.Vector) return Vectors_4.Vector is
   begin
      return V : Vectors_4.Vector (Vectors_4.SIMD) do
         --  V.Elements (Vectors_4.X) := Left.Elements (X_Axis_X) * Right.Elements (Vectors_4.X) +
         --                              Left.Elements (X_Axis_Y) * Right.Elements (Vectors_4.Y) +
         --                              Left.Elements (X_Axis_Z) * Right.Elements (Vectors_4.Z) +
         --                              Left.Elements (X_Axis_W) * Right.Elements (Vectors_4.W);
         --  V.Elements (Vectors_4.Y) := Left.Elements (Y_Axis_X) * Right.Elements (Vectors_4.X) +
         --                              Left.Elements (Y_Axis_Y) * Right.Elements (Vectors_4.Y) +
         --                              Left.Elements (Y_Axis_Z) * Right.Elements (Vectors_4.Z) +
         --                              Left.Elements (Y_Axis_W) * Right.Elements (Vectors_4.W);
         --  V.Elements (Vectors_4.Z) := Left.Elements (Z_Axis_X) * Right.Elements (Vectors_4.X) +
         --                              Left.Elements (Z_Axis_Y) * Right.Elements (Vectors_4.Y) +
         --                              Left.Elements (Z_Axis_Z) * Right.Elements (Vectors_4.Z) +
         --                              Left.Elements (Z_Axis_W) * Right.Elements (Vectors_4.W);
         --  V.Elements (Vectors_4.W) := Left.Elements (W_Axis_X) * Right.Elements (Vectors_4.X) +
         --                              Left.Elements (W_Axis_Y) * Right.Elements (Vectors_4.Y) +
         --                              Left.Elements (W_Axis_Z) * Right.Elements (Vectors_4.Z) +
         --                              Left.Elements (W_Axis_W) * Right.Elements (Vectors_4.W);
         V.Elements := (Left.Elements (X_Axis_X) * Right.Elements (Vectors_4.X) +
                        Left.Elements (X_Axis_Y) * Right.Elements (Vectors_4.Y) +
                        Left.Elements (X_Axis_Z) * Right.Elements (Vectors_4.Z) +
                        Left.Elements (X_Axis_W) * Right.Elements (Vectors_4.W),

                        Left.Elements (Y_Axis_X) * Right.Elements (Vectors_4.X) +
                        Left.Elements (Y_Axis_Y) * Right.Elements (Vectors_4.Y) +
                        Left.Elements (Y_Axis_Z) * Right.Elements (Vectors_4.Z) +
                        Left.Elements (Y_Axis_W) * Right.Elements (Vectors_4.W),

                        Left.Elements (Z_Axis_X) * Right.Elements (Vectors_4.X) +
                        Left.Elements (Z_Axis_Y) * Right.Elements (Vectors_4.Y) +
                        Left.Elements (Z_Axis_Z) * Right.Elements (Vectors_4.Z) +
                        Left.Elements (Z_Axis_W) * Right.Elements (Vectors_4.W),

                        Left.Elements (Translation_X) * Right.Elements (Vectors_4.X) +
                        Left.Elements (Translation_Y) * Right.Elements (Vectors_4.Y) +
                        Left.Elements (Translation_Z) * Right.Elements (Vectors_4.Z) +
                        Left.Elements (Translation_W) * Right.Elements (Vectors_4.W));
      end return;
   end "*";
end Maths.Matrices_4x4;
