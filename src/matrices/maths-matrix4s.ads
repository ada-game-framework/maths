------------------------------------------------------------------------------------------------------------------------
--  This source code is subject to the BSD license, see the LICENCE file in the root of this directory.
------------------------------------------------------------------------------------------------------------------------
--  Maths.Matrix4s
------------------------------------------------------------------------------------------------------------------------
with Ada.Strings.Text_Buffers;
with GNAT.SSE.Vector_Types;  --  TODO: Create local versions for portability.
with Maths.Vector4s;

package Maths.Matrix4s is
   --  pragma Pure;

   package SIMDV renames GNAT.SSE.Vector_Types;

   --  Column Matrices.
   --
   --  X - Right vector.
   --  Y - Up vector.
   --  Z - Forward vector.
   --  T - Translation vector.
   --                                                Basis
   --                                                Axes
   --  Axis    Array             Matrix              R U F | T
   --  ----    -------------     ---------------     ------+--
   --  X   |   M0 M4 M8  M12     M11 M12 M13 M14     x x x | x
   --  Y   |   M1 M5 M9  M13 :-> M21 M22 M23 M24 :-> y y y | y
   --  Z   |   M2 M6 M10 M14     M31 M32 M33 M34     z z z | z
   --  W   |   M3 M7 M11 M15     M41 M42 M43 M44     0 0 0 | 1
   --
   --  In Ada, using Fortran convention, you still use M (Row, Column) to acess
   --  individual elements in a 2D matrix.

   type Matrix_Elements is (Right_Axis_X,   Right_Axis_Y,   Right_Axis_Z,   Right_Axis_W,
                            Up_Axis_X,      Up_Axis_Y,      Up_Axis_Z,      Up_Axis_W,
                            Forward_Axis_X, Forward_Axis_Y, Forward_Axis_Z, Forward_Axis_W,
                            Translation_X,  Translation_Y,  Translation_Z,  Translation_W);
   type Basis_Axes is
     (Right,   --  X
      Up,      --  Y
      Forward, --  Z
      Translation);

   --  Axes within the basis axes.
   type Axes is (X, Y, Z, W);

   type M128_Array is array (Basis_Axes) of SIMDV.m128;  --  The machine representation, 4 x floats.
   type Float_Array is array (Matrix_Elements) of Float;
   type Vector_Array is array (Basis_Axes) of Vector4s.Vector4 (Vector4s.Components);

   type Matrix_2D_Array is array (Axes, Basis_Axes) of Float with
     Convention => Fortran;

   type Matrix_Access_Type is (SIMD, Components, Matrix_2D, Vectors);

   type Matrix4 (Which : Matrix_Access_Type) is record
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
     Unchecked_Union,
     Put_Image => Matrix4_Image;

   Identity : constant Matrix4;

   --  Operators.
   function "+" (L, R : Matrix4) return Matrix4 with
     Inline;

   function "-" (L, R : Matrix4) return Matrix4 with
     Inline;

   function "*" (L : Matrix4; R : Vector4s.Vector4) return Vector4s.Vector4 with
     Inline;

   function "*" (L, R : Matrix4) return Matrix4 with
     Inline;

   function Translate (X, Y, Z : Float) return Matrix4;
   function Scale (X, Y, Z : Float) return Matrix4;
   function Rotate_Around_X (Angle : Float) return Matrix4;
   function Rotate_Around_Y (Angle : Float) return Matrix4;
   function Rotate_Around_Z (Angle : Float) return Matrix4;

   function Switch_Coordinate_Systems return Matrix4 is (Scale (1.0, 1.0, -1.0));

   function Perspective (Field_of_View, Aspect_Ratio, Near, Far : Float) return Matrix4;
   function Orthographic (Left, Right, Top, Bottom, Near, Far : Float) return Matrix4;

   function Look_At (Eye, Target, Initial_Up : Vector4s.Vector4) return Matrix4;

   procedure Matrix4_Image (Buffer : in out Ada.Strings.Text_Buffers.Root_Buffer_Type'Class; Arg : Matrix4);
private
   Identity : constant Matrix4 :=
     (Which       => Matrix_2D,
      Elements_2D => ((1.0, 0.0, 0.0, 0.0),     --  Right.
                      (0.0, 1.0, 0.0, 0.0),     --  Up.
                      (0.0, 0.0, 1.0, 0.0),     --  Forward.
                      (0.0, 0.0, 0.0, 1.0)));   --  Translation.
end Maths.Matrix4s;
