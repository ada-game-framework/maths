------------------------------------------------------------------------------------------------------------------------
--  This source code is subject to the BSD license, see the LICENCE file in the root of this directory.
------------------------------------------------------------------------------------------------------------------------
--  Maths.Vector4s
------------------------------------------------------------------------------------------------------------------------
with Ada.Strings.Text_Buffers;
with GNAT.SSE.Vector_Types;  --  TODO: Create local versions for portability.

package Maths.Vector4s is
   --  pragma Preelaborable_Initialization;

   package SIMDV renames GNAT.SSE.Vector_Types;

   type Axes4D is (X, Y, Z, W);

   type Float_Vector4D is array (Axes4D) of Float;

   type Vector_Access_Type is (SIMD, Components);

   --  Viewed as a column vector.
   type Vector4 (Which : Vector_Access_Type) is record
      case Which is
         when SIMD =>
            Register : SIMDV.m128;   --  The machine representation.

         when Components =>
            Elements : Float_Vector4D;

         --  when others =>
         --     null;
      end case;
   end record with
     Convention => C,
     Unchecked_Union,
     Put_Image => Vector4_Image;

   --  Operators.
   function "+" (Left, Right : Vector4) return Vector4 with
     Inline;

   function "-" (Left, Right : Vector4) return Vector4 with
     Inline;

   function "*" (Left : Vector4; Scalar : Float) return Vector4 with
     Inline;

   function Dot (Left, Right : Vector4) return Float is
     ((Left.Elements (X) * Right.Elements (X)) +
      (Left.Elements (Y) * Right.Elements (Y)) +
      (Left.Elements (Z) * Right.Elements (Z)));

   function Cross (Left, Right : Vector4) return Vector4 is
     (Which    => Components,
      Elements => (X => (Left.Elements (Y) * Right.Elements (Z)) - (Left.Elements (Z) * Right.Elements (Y)),
                   Y => (Left.Elements (Z) * Right.Elements (X)) - (Left.Elements (Y) * Right.Elements (Z)),
                   Z => (Left.Elements (X) * Right.Elements (Y)) - (Left.Elements (Y) * Right.Elements (X)),
                   W => 1.0));

   function Length (V : Vector4) return Float with
     Inline;

   function Magnitude (V : Vector4) return Float renames Length;

   procedure Normalise (V : in out Vector4) with
     Inline;

   procedure Vector4_Image (Buffer : in out Ada.Strings.Text_Buffers.Root_Buffer_Type'Class; Arg : Vector4);
end Maths.Vector4s;
