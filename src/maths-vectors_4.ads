with GNAT.SSE.Vector_Types;  --  TODO: Create local versions for portability.

package Maths.Vectors_4 is
   --  pragma Preelaborable_Initialization;

   package SIMDV renames GNAT.SSE.Vector_Types;

   type Axes is (X, Y, Z, W);

   type Float_Vector is array (Axes) of Float;

   type Vector_Access_Type is (SIMD, Components);

   --  Viewed as a column vector.
   type Vector (Which : Vector_Access_Type) is record
      case Which is
         when SIMD =>
            Register : SIMDV.m128;   --  The machine representation.

         when Components =>
            Elements : Float_Vector;

         --  when others =>
         --     null;
      end case;
   end record with
     Convention => C,
     Unchecked_Union;

   function "+" (Left, Right : Vector) return Vector;
end Maths.Vectors_4;
