------------------------------------------------------------------------------------------------------------------------
--  This source code is subject to the BSD license, see the LICENCE file in the root of this directory.
------------------------------------------------------------------------------------------------------------------------
--  Maths.Vector3s
------------------------------------------------------------------------------------------------------------------------
--  with GNAT.SSE.Vector_Types;  --  TODO: Create local versions for portability.

package Maths.Vector3s is
   --  pragma Preelaborable_Initialization;

   --   package SIMDV renames GNAT.SSE.Vector_Types;

   type Axes3D is (X, Y, Z);

   type Float_Vector3D is array (Axes3D) of Float;

   type Vector_Access_Type is (SIMD, Components);

   --  Viewed as a column vector.
   type Vector3 (Which : Vector_Access_Type) is record
      case Which is
         when SIMD =>
            --  Register : SIMDV.m128;   --  The machine representation.
            null;

         when Components =>
            Elements : Float_Vector3D;

         --  when others =>
         --     null;
      end case;
   end record with
     Convention => C,
     Unchecked_Union;

   --  Operators.
   function "+" (Left, Right : Vector3) return Vector3 with
     Inline;

   function "-" (Left, Right : Vector3) return Vector3 with
     Inline;

   function "*" (Left : Vector3; Scalar : Float) return Vector3 with
     Inline;

   function Length (V : Vector3) return Float with
     Inline;

   procedure Normalise (V : in out Vector3) with
     Inline;
end Maths.Vector3s;
