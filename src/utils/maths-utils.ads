------------------------------------------------------------------------------------------------------------------------
--  This source code is subject to the BSD license, see the LICENCE file in the root of this directory.
------------------------------------------------------------------------------------------------------------------------
--  Maths.Utils
------------------------------------------------------------------------------------------------------------------------
with Ada.Numerics.Generic_Elementary_Functions;

package Maths.Utils is
   package Trig is new Ada.Numerics.Generic_Elementary_Functions (Float);

   --  TODO: Should Radians be a type?
   --  TODO: Will Degrees cause an exception? For rotations which increase over 360°?
   --  type Degrees is digits 3 range 0.0 .. 360.0;

   function To_Radians (Angle_Degrees : Float) return Float is (Angle_Degrees * (Ada.Numerics.Pi / 180.0));
   function To_Degrees (Angle_Radians : Float) return Float is (Angle_Radians * (180.0 / Ada.Numerics.Pi));
end Maths.Utils;

