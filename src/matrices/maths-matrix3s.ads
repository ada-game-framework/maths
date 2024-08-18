------------------------------------------------------------------------------------------------------------------------
--  This source code is subject to the BSD license, see the LICENCE file in the root of this directory.
------------------------------------------------------------------------------------------------------------------------
--  Maths.Matrix3s
------------------------------------------------------------------------------------------------------------------------
with Ada.Strings.Text_Buffers;
--  with GNAT.SSE.Vector_Types;  --  TODO: Create local versions for portability.
with Maths.Vector3s;

package Maths.Matrix3s is
   --  pragma Pure;

   --  package SIMDV renames GNAT.SSE.Vector_Types;

   --  Column Matrices.
   --
   --  X - Right vector.
   --  Y - Up vector.
   --  Z - Forward vector.
   --  T - Translation vector.
   --                                        Basis
   --                                        Axes
   --  Axis    Array         Matrix          R U F
   --  ----    --------      -----------     -----
   --  X   |   M0 M3 M6      M11 M12 M13     x x x
   --  Y   |   M1 M4 M7  :-> M21 M22 M23 :-> y y y
   --  Z   |   M2 M5 M8      M31 M32 M33     z z z
   --
   --  In Ada, using Fortran convention, you still use M (Row, Column) to acess
   --  individual elements in a 2D matrix.

   type Matrix_Elements is (Right_Axis_X,   Right_Axis_Y,   Right_Axis_Z,
                            Up_Axis_X,      Up_Axis_Y,      Up_Axis_Z,
                            Forward_Axis_X, Forward_Axis_Y, Forward_Axis_Z);

   Translation_X renames Right_Axis_Z;
   Translation_Y renames Up_Axis_Z;
   Translation_W renames Forward_Axis_Z;

   type Basis_Axes is
     (Right,    --  X
      Up,       --  Y
      Forward); --  Z

   --  Axes within the basis axes.
   type Axes is (X, Y, Z);

   --  type M128_Array is array (Basis_Axes) of SIMDV.m128;  --  The machine representation, 4 x floats.
   type Float_Array is array (Matrix_Elements) of Float;
   type Vector_Array is array (Basis_Axes) of Vector3s.Vector3 (Vector3s.Components);

   type Matrix_2D_Array is array (Axes, Basis_Axes) of Float with
     Convention => Fortran;

   type Row_Major_Matrix is new Matrix_2D_Array with
     Convention => Ada;

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
     Unchecked_Union,
     Put_Image => Matrix3_Image;

   Identity : constant Matrix3;

   --  Operators.
   function "+" (L, R : Matrix3) return Matrix3 with
     Inline;

   function "-" (L, R : Matrix3) return Matrix3 with
     Inline;

   function "*" (L : Matrix3; R : Vector3s.Vector3) return Vector3s.Vector3 with
     Inline;

   function "*" (L, R : Matrix3) return Matrix3 with
     Inline;

   function Translate (X, Y : Float) return Matrix3;
   function Scale (X, Y, Z : Float) return Matrix3;
   function Rotate_Around_X (Angle : Float) return Matrix3;
   function Rotate_Around_Y (Angle : Float) return Matrix3;
   function Rotate_Around_Z (Angle : Float) return Matrix3;

   function Switch_Coordinate_Systems return Matrix3 is (Scale (1.0, 1.0, -1.0));

   procedure Matrix3_Image (Buffer : in out Ada.Strings.Text_Buffers.Root_Buffer_Type'Class; Arg : Matrix3);
private
   Identity : constant Matrix3 :=
     (Which       => Matrix_2D,
      Elements_2D => ((1.0, 0.0, 0.0),     --  Right.
                      (0.0, 1.0, 0.0),     --  Up.
                      (0.0, 0.0, 1.0)));   --  Forward.
end Maths.Matrix3s;
