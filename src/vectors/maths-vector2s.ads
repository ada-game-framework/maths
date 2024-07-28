------------------------------------------------------------------------------------------------------------------------
--  This source code is subject to the BSD license, see the LICENCE file in the root of this directory.
------------------------------------------------------------------------------------------------------------------------
--  Maths.Vector2s
------------------------------------------------------------------------------------------------------------------------
--  with GNAT.SSE.Vector_Types;  --  TODO: Create local versions for portability.

package Maths.Vector2s is
   --  pragma Preelaborable_Initialization;

   --  package SIMDV renames GNAT.SSE.Vector_Types;

   type Axes2D is (X, Y);

   type Float_Vector2D is array (Axes2D) of Float;

   type Vector_Access_Type is (SIMD, Components);

   --  Viewed as a column vector.
   type Vector2 (Which : Vector_Access_Type) is record
      case Which is
         when SIMD =>
            --  Register : SIMDV.m128;   --  The machine representation.
            null;

         when Components =>
            Elements : Float_Vector2D;

         --  when others =>
         --     null;
      end case;
   end record with
     Convention => C,
     Unchecked_Union;

   --  Operators.
   function "+" (Left, Right : Vector2) return Vector2 with
     Inline;

   function "-" (Left, Right : Vector2) return Vector2 with
     Inline;

   function "*" (Left : Vector2; Scalar : Float) return Vector2 with
     Inline;

   function Length (V : Vector2) return Float with
     Inline;

   procedure Normalise (V : in out Vector2) with
     Inline;
end Maths.Vector2s;
