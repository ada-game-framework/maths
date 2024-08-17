------------------------------------------------------------------------------------------------------------------------
--  This source code is subject to the BSD license, see the LICENCE file in the root of this directory.
------------------------------------------------------------------------------------------------------------------------
with Ada.Numerics.Generic_Elementary_Functions;
with Ada.Strings.Fixed;
with Ada.Text_IO;

package body Maths.Matrix3s is
   use type Vector3s.Vector3;

   package Trig is new Ada.Numerics.Generic_Elementary_Functions (Float);
   use Trig;


   function "+" (L, R : Matrix3) return Matrix3 is
   begin
      return M : Matrix3 (Vectors) do
         M.Axes (Right)   := L.Axes (Right) + R.Axes (Right);
         M.Axes (Up)      := L.Axes (Up) + R.Axes (Up);
         M.Axes (Forward) := L.Axes (Forward) + R.Axes (Forward);
      end return;
   end "+";


   function "-" (L, R : Matrix3) return Matrix3 is
   begin
      return M : Matrix3 (Vectors) do
         M.Axes (Right)   := L.Axes (Right) - R.Axes (Right);
         M.Axes (Up)      := L.Axes (Up) - R.Axes (Up);
         M.Axes (Forward) := L.Axes (Forward) - R.Axes (Forward);
      end return;
   end "-";


   function "*" (L : Matrix3; R : Vector3s.Vector3) return Vector3s.Vector3 is
   begin
      return V : Vector3s.Vector3 (Vector3s.Components) do
         V.Elements := (Vector3s.X => L.Elements (Right_Axis_X) * R.Elements (Vector3s.X) +
                                      L.Elements (Right_Axis_Y) * R.Elements (Vector3s.Y) +
                                      L.Elements (Right_Axis_Z) * R.Elements (Vector3s.Z),

                        Vector3s.Y => L.Elements (Up_Axis_X) * R.Elements (Vector3s.X) +
                                      L.Elements (Up_Axis_Y) * R.Elements (Vector3s.Y) +
                                      L.Elements (Up_Axis_Z) * R.Elements (Vector3s.Z),

                        Vector3s.Z => L.Elements (Forward_Axis_X) * R.Elements (Vector3s.X) +
                                      L.Elements (Forward_Axis_Y) * R.Elements (Vector3s.Y) +
                                      L.Elements (Forward_Axis_Z) * R.Elements (Vector3s.Z));
      end return;
   end "*";


   --      Row      * column
   --      R  U  F     R  U  F
   ---------------------------
   --  X | Xx Yx Zx   Ax Bx Cx   XxAx+YxAy+ZxAz XxBx+YxBy+ZxBz XxCx+YxCy+ZxCz
   --  Y | Xy Yy Zy * Ay By Cy = XyAx+YyAy+ZyAz XyBx+YyBy+ZyBz XyCx+YyCy+ZyCz
   --  Z | Xz Yz Zz   Az Bz Cz   XzAx+YzAy+ZzAz XzBx+YzBy+ZzBz XzCx+YzCy+ZzCz
   function "*" (L, R : Matrix3) return Matrix3 is
      LE : Float_Array renames L.Elements;
      RE : Float_Array renames R.Elements;

      Xx : Float renames LE (Right_Axis_X);
      Yx : Float renames LE (Up_Axis_X);
      Zx : Float renames LE (Forward_Axis_X);

      Xy : Float renames LE (Right_Axis_Y);
      Yy : Float renames LE (Up_Axis_Y);
      Zy : Float renames LE (Forward_Axis_Y);

      Xz : Float renames LE (Right_Axis_Z);
      Yz : Float renames LE (Up_Axis_Z);
      Zz : Float renames LE (Forward_Axis_Z);

      Ax : Float renames RE (Right_Axis_X);
      Ay : Float renames RE (Right_Axis_Y);
      Az : Float renames RE (Right_Axis_Z);

      Bx : Float renames RE (Up_Axis_X);
      By : Float renames RE (Up_Axis_Y);
      Bz : Float renames RE (Up_Axis_Z);

      Cx : Float renames RE (Forward_Axis_X);
      Cy : Float renames RE (Forward_Axis_Y);
      Cz : Float renames RE (Forward_Axis_Z);
   begin
      return M : Matrix3 (Components) do
         M.Elements := (
            Right_Axis_X   => (Xx * Ax) + (Yx * Ay) + (Zx * Az),
            Up_Axis_X      => (Xx * Bx) + (Yx * By) + (Zx * Bz),
            Forward_Axis_X => (Xx * Cx) + (Yx * Cy) + (Zx * Cz),
            Right_Axis_Y   => (Xy * Ax) + (Yy * Ay) + (Zy * Az),
            Up_Axis_Y      => (Xy * Bx) + (Yy * By) + (Zy * Bz),
            Forward_Axis_Y => (Xy * Cx) + (Yy * Cy) + (Zy * Cz),
            Right_Axis_Z   => (Xz * Ax) + (Yz * Ay) + (Zz * Az),
            Up_Axis_Z      => (Xz * Bx) + (Yz * By) + (Zz * Bz),
            Forward_Axis_Z => (Xz * Cx) + (Yz * Cy) + (Zz * Cz)
         );
      end return;
   end "*";


   function Translate (X, Y : Float) return Matrix3 is
   begin
      return M : Matrix3 (Which => Components) do
         M.Elements := (Translation_X => X,
                        Translation_Y => Y,
                        Right_Axis_X | Up_Axis_Y | Translation_W => 1.0,
                        others => 0.0);
      end return;
   end Translate;


   function Scale (X, Y, Z : Float) return Matrix3 is
   begin
      return M : Matrix3 (Which => Components) do
         M.Elements := (Right_Axis_X   => X,
                        Up_Axis_Y      => Y,
                        Forward_Axis_Z => Z,
                        others         => 0.0);
      end return;
   end Scale;


   function Rotate_Around_X (Angle : Float) return Matrix3 is
      Cos_Theta : constant Float := Cos (Angle);
      Sin_Theta : constant Float := Sin (Angle);
   begin
      return M : Matrix3 (Which => Components) do
         M.Elements := (Right_Axis_X |
                        Up_Axis_Y      => Cos_Theta,
                        Up_Axis_Z      => Sin_Theta,
                        Forward_Axis_Y => -Sin_Theta,
                        Forward_Axis_Z => Cos_Theta,
                        others         => 0.0);
      end return;
   end Rotate_Around_X;


   function Rotate_Around_Y (Angle : Float) return Matrix3 is
      Cos_Theta : constant Float := Cos (Angle);
      Sin_Theta : constant Float := Sin (Angle);
   begin
      return M : Matrix3 (Which => Components) do
         M.Elements := (Up_Axis_Y |
                        Right_Axis_X   => Cos_Theta,
                        Right_Axis_Z   => -Sin_Theta,
                        Forward_Axis_X => Sin_Theta,
                        Forward_Axis_Z => Cos_Theta,
                        others         => 0.0);
      end return;
   end Rotate_Around_Y;


   function Rotate_Around_Z (Angle : Float) return Matrix3 is
      Cos_Theta : constant Float := Cos (Angle);
      Sin_Theta : constant Float := Sin (Angle);
   begin
      return M : Matrix3 (Which => Components) do
         M.Elements := (Forward_Axis_Z |
                        Right_Axis_X  => Cos_Theta,
                        Right_Axis_Y  => Sin_Theta,
                        Up_Axis_X     => -Sin_Theta,
                        Up_Axis_Y     => Cos_Theta,
                        others        => 0.0);
      end return;
   end Rotate_Around_Z;


   procedure Matrix3_Image (Buffer : in out Ada.Strings.Text_Buffers.Root_Buffer_Type'Class; Arg : Matrix3) is
      function Convert (F : Float) return String is
         use Ada.Strings;
         use Ada.Strings.Fixed;
         use Ada.Text_IO;

         package FIO is new Float_IO (Float);
         use FIO;

         Result : String (1 .. 20) := (others => ' ');
      begin
         Put (To   => Result,
              Item => F,
              Aft  => 4,
              Exp  => 0);

         return Trim (Result, Both);
      end Convert;
   begin
      Buffer.Put ("(Right => " & Arg.Axes (Right)'Image &
                  ", Up => " & Arg.Axes (Up)'Image &
                  ", Forward => " & Arg.Axes (Forward)'Image & ")");
   end Matrix3_Image;
end Maths.Matrix3s;
