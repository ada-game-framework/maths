------------------------------------------------------------------------------------------------------------------------
--  This source code is subject to the BSD license, see the LICENCE file in the root of this directory.
------------------------------------------------------------------------------------------------------------------------
--  Maths.Matrices_4x4
------------------------------------------------------------------------------------------------------------------------
with GNAT.SSE.Vector_Types;  --  TODO: Create local versions for portability.
with Maths.Vectors_4;

package Maths.Matrices_4x4 is
   --  pragma Pure;

   package SIMDV renames GNAT.SSE.Vector_Types;

   --  Column Matrices.
   --                                                Basis
   --                                                Axes
   --  Axis    Array             Matrix              X Y Z | Translation
   --  ----    -------------     ---------------     ------+------------
   --  X   |   M0 M4 M8  M12     M11 M12 M13 M14     x x x | x
   --  Y   |   M1 M5 M9  M13 :-> M21 M22 M23 M24 :-> y y y | y
   --  Z   |   M2 M6 M10 M14     M31 M32 M33 M34     z z z | z
   --  W   |   M3 M7 M11 M15     M41 M42 M43 M44     0 0 0 | 1

   type Matrix_Elements is (X_Axis_X, X_Axis_Y, X_Axis_Z, X_Axis_W,
                            Y_Axis_X, Y_Axis_Y, Y_Axis_Z, Y_Axis_W,
                            Z_Axis_X, Z_Axis_Y, Z_Axis_Z, Z_Axis_W,
                            Translation_X, Translation_Y, Translation_Z, Translation_W);
   type Basis_Axes is (X, Y, Z, T);
   type Axes is (X, Y, Z, W);

   type M128_Array is array (Basis_Axes) of SIMDV.m128;  --  The machine representation.
   type Float_Array is array (Matrix_Elements) of Float;
   type Vector_Array is array (Axes) of Vectors_4.Vector (Vectors_4.Components);

   type Matrix_2D_Array is array (Axes, Basis_Axes) of Float with
     Convention => Fortran;

   type Matrix_Access_Type is (SIMD, Components, Matrix_2D, Vectors);

   type Matrix (Which : Matrix_Access_Type) is record
      case Which is
         when SIMD =>
            Registers : M128_Array;

         when Components =>
            Elements : Float_Array;

         when Matrix_2D =>
            Elements_2D : Matrix_2D_Array;

         when Vectors =>
            Axes : Vector_Array;
      end case;
   end record with
     Convention => C,
     Unchecked_Union;

   Identity : constant Matrix;

   --  Operators.
   function "+" (Left, Right : Matrix) return Matrix with
     Inline;

   function "*" (Left : Matrix; Right : Vectors_4.Vector) return Vectors_4.Vector with
     Inline;
private
   Identity : constant Matrix :=
     (Which       => Matrix_2D,
      Elements_2D => ((1.0, 0.0, 0.0, 0.0),
                      (0.0, 1.0, 0.0, 0.0),
                      (0.0, 0.0, 1.0, 0.0),
                      (0.0, 0.0, 0.0, 1.0)));
end Maths.Matrices_4x4;
