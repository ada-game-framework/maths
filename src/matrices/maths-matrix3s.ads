------------------------------------------------------------------------------------------------------------------------
--  This source code is subject to the BSD license, see the LICENCE file in the root of this directory.
------------------------------------------------------------------------------------------------------------------------
--  Maths.Matrix3s
------------------------------------------------------------------------------------------------------------------------
--  with GNAT.SSE.Vector_Types;  --  TODO: Create local versions for portability.
with Maths.Vector3s;

package Maths.Matrix3s is
   --  pragma Pure;

   --  package SIMDV renames GNAT.SSE.Vector_Types;

   --  Column Matrices.
   --                                        Basis
   --                                        Axes
   --  Axis    Array             Matrix      X Y Z
   --  ----    ----------    -----------     -----
   --  X   |   M0 M3 M6      M11 M12 M13     x x x
   --  Y   |   M1 M4 M7  :-> M21 M22 M23 :-> y y y
   --  Z   |   M2 M5 M8      M31 M32 M33     z z z

   type Matrix_Elements is (X_Axis_X, X_Axis_Y, X_Axis_Z,
                            Y_Axis_X, Y_Axis_Y, Y_Axis_Z,
                            Z_Axis_X, Z_Axis_Y, Z_Axis_Z);

   Translation_X renames X_Axis_Z;
   Translation_Y renames Y_Axis_Z;
   Translation_W renames Z_Axis_Z;

   type Basis_Axes is (X, Y, Z);
   type Axes is (X, Y, Z);

   --  type M128_Array is array (Basis_Axes) of SIMDV.m128;  --  The machine representation.
   type Float_Array is array (Matrix_Elements) of Float;
   type Vector_Array is array (Basis_Axes) of Vector3s.Vector3 (Vector3s.Components);

   type Matrix_2D_Array is array (Axes, Basis_Axes) of Float with
     Convention => Fortran;

   type Matrix_Access_Type is (SIMD, Components, Matrix_2D, Vectors);

   type Matrix3 (Which : Matrix_Access_Type) is record
      case Which is
         when SIMD =>
            --  Registers : M128_Array;
            null;

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

   Identity : constant Matrix3;

   --  Operators.
   function "+" (Left, Right : Matrix3) return Matrix3 with
     Inline;

   function "-" (Left, Right : Matrix3) return Matrix3 with
     Inline;

   function "*" (Left : Matrix3; Right : Vector3s.Vector3) return Vector3s.Vector3 with
     Inline;

   --  A 3x3 matrix can be used to translate a 2D vector.
   function Translation (X, Y : Float) return Matrix3;
private
   Identity : constant Matrix3 :=
     (Which       => Matrix_2D,
      Elements_2D => ((1.0, 0.0, 0.0),
                      (0.0, 1.0, 0.0),
                      (0.0, 0.0, 1.0)));
end Maths.Matrix3s;
