------------------------------------------------------------------------------------------------------------------------
--  This source code is subject to the BSD license, see the LICENCE file in the root of this directory.
------------------------------------------------------------------------------------------------------------------------
with Ada.Numerics.Generic_Elementary_Functions;
with Ada.Strings.Fixed;
with Ada.Text_IO;

package body Maths.Matrix4s is
   use type Vector4s.Vector4;

   package Trig is new Ada.Numerics.Generic_Elementary_Functions (Float);
   use Trig;


   function "+" (L, R : Matrix4) return Matrix4 is
   begin
      return M : Matrix4 (Vectors) do
         M.Axes (Right)       := L.Axes (Right) + R.Axes (Right);
         M.Axes (Up)          := L.Axes (Up) + R.Axes (Up);
         M.Axes (Forward)     := L.Axes (Forward) + R.Axes (Forward);
         M.Axes (Translation) := L.Axes (Translation) + R.Axes (Translation);
      end return;
   end "+";


   function "-" (L, R : Matrix4) return Matrix4 is
   begin
      return M : Matrix4 (Vectors) do
         M.Axes (Right)       := L.Axes (Right) - R.Axes (Right);
         M.Axes (Up)          := L.Axes (Up) - R.Axes (Up);
         M.Axes (Forward)     := L.Axes (Forward) - R.Axes (Forward);
         M.Axes (Translation) := L.Axes (Translation) - R.Axes (Translation);
      end return;
   end "-";


   function "*" (L : Matrix4; R : Vector4s.Vector4) return Vector4s.Vector4 is
   begin
      return V : Vector4s.Vector4 (Vector4s.SIMD) do
         V.Elements := (Vector4s.X => L.Elements (Right_Axis_X) * R.Elements (Vector4s.X) +
                                      L.Elements (Right_Axis_Y) * R.Elements (Vector4s.Y) +
                                      L.Elements (Right_Axis_Z) * R.Elements (Vector4s.Z) +
                                      L.Elements (Right_Axis_W) * R.Elements (Vector4s.W),

                        Vector4s.Y => L.Elements (Up_Axis_X) * R.Elements (Vector4s.X) +
                                      L.Elements (Up_Axis_Y) * R.Elements (Vector4s.Y) +
                                      L.Elements (Up_Axis_Z) * R.Elements (Vector4s.Z) +
                                      L.Elements (Up_Axis_W) * R.Elements (Vector4s.W),

                        Vector4s.Z => L.Elements (Forward_Axis_X) * R.Elements (Vector4s.X) +
                                      L.Elements (Forward_Axis_Y) * R.Elements (Vector4s.Y) +
                                      L.Elements (Forward_Axis_Z) * R.Elements (Vector4s.Z) +
                                      L.Elements (Forward_Axis_W) * R.Elements (Vector4s.W),

                        Vector4s.W => L.Elements (Translation_X) * R.Elements (Vector4s.X) +
                                      L.Elements (Translation_Y) * R.Elements (Vector4s.Y) +
                                      L.Elements (Translation_Z) * R.Elements (Vector4s.Z) +
                                      L.Elements (Translation_W) * R.Elements (Vector4s.W));
      end return;
   end "*";


   --      Row         * column
   --      R  U  F  T    R  U  F  T
   -------------------------------
   --  X | Xx Yx Zx Tx   Ax Bx Cx Dx   XxAx+YxAy+ZxAz+TxAw XxBx+YxBy+ZxBz+TxBw XxCx+YxCy+ZxCz+TxCw XxDx+YxDy+ZxDz+TxDw
   --  Y | Xy Yy Zy Ty * Ay By Cy Dy = XyAx+YyAy+ZyAz+TyAw XyBx+YyBy+ZyBz+TyBw XyCx+YyCy+ZyCz+TyCw XyDx+YyDy+ZyDz+TyDw
   --  Z | Xz Yz Zz Tz   Az Bz Cz Dz   XzAx+YzAy+ZzAz+TzAw XzBx+YzBy+ZzBz+TzBw XzCx+YzCy+ZzCz+TzCw XzDx+YzDy+ZzDz+TzDw
   --  W | Xw Yw Zw Tw   Aw Bw Cw Dw   XwAx+YwAy+ZwAz+TwAw XwBx+YwBy+ZwBz+TwBw XwCx+YwCy+ZwCz+TwCw XwDx+YwDy+ZwDz+TwDw
   function "*" (L, R : Matrix4) return Matrix4 is
      LE : Float_Array renames L.Elements;
      RE : Float_Array renames R.Elements;

      Xx : Float renames LE (Right_Axis_X);
      Yx : Float renames LE (Up_Axis_X);
      Zx : Float renames LE (Forward_Axis_X);
      Tx : Float renames LE (Translation_X);

      Xy : Float renames LE (Right_Axis_Y);
      Yy : Float renames LE (Up_Axis_Y);
      Zy : Float renames LE (Forward_Axis_Y);
      Ty : Float renames LE (Translation_Y);

      Xz : Float renames LE (Right_Axis_Z);
      Yz : Float renames LE (Up_Axis_Z);
      Zz : Float renames LE (Forward_Axis_Z);
      Tz : Float renames LE (Translation_Z);

      Xw : Float renames LE (Right_Axis_W);
      Yw : Float renames LE (Up_Axis_W);
      Zw : Float renames LE (Forward_Axis_W);
      Tw : Float renames LE (Translation_W);

      Ax : Float renames RE (Right_Axis_X);
      Ay : Float renames RE (Right_Axis_Y);
      Az : Float renames RE (Right_Axis_Z);
      Aw : Float renames RE (Right_Axis_W);

      Bx : Float renames RE (Up_Axis_X);
      By : Float renames RE (Up_Axis_Y);
      Bz : Float renames RE (Up_Axis_Z);
      Bw : Float renames RE (Up_Axis_W);

      Cx : Float renames RE (Forward_Axis_X);
      Cy : Float renames RE (Forward_Axis_Y);
      Cz : Float renames RE (Forward_Axis_Z);
      Cw : Float renames RE (Forward_Axis_W);

      Dx : Float renames RE (Translation_X);
      Dy : Float renames RE (Translation_Y);
      Dz : Float renames RE (Translation_Z);
      Dw : Float renames RE (Translation_W);
   begin
      return M : Matrix4 (Components) do
         M.Elements := (
            Right_Axis_X   => (Xx * Ax) + (Yx * Ay) + (Zx * Az) + (Tx * Aw),
            Up_Axis_X      => (Xx * Bx) + (Yx * By) + (Zx * Bz) + (Tx * Bw),
            Forward_Axis_X => (Xx * Cx) + (Yx * Cy) + (Zx * Cz) + (Tx * Cw),
            Translation_X  => (Xx * Dx) + (Yx * Dy) + (Zx * Dz) + (Tx * Dw),
            Right_Axis_Y   => (Xy * Ax) + (Yy * Ay) + (Zy * Az) + (Ty * Aw),
            Up_Axis_Y      => (Xy * Bx) + (Yy * By) + (Zy * Bz) + (Ty * Bw),
            Forward_Axis_Y => (Xy * Cx) + (Yy * Cy) + (Zy * Cz) + (Ty * Cw),
            Translation_Y  => (Xy * Dx) + (Yy * Dy) + (Zy * Dz) + (Ty * Dw),
            Right_Axis_Z   => (Xz * Ax) + (Yz * Ay) + (Zz * Az) + (Tz * Aw),
            Up_Axis_Z      => (Xz * Bx) + (Yz * By) + (Zz * Bz) + (Tz * Bw),
            Forward_Axis_Z => (Xz * Cx) + (Yz * Cy) + (Zz * Cz) + (Tz * Cw),
            Translation_Z  => (Xz * Dx) + (Yz * Dy) + (Zz * Dz) + (Tz * Dw),
            Right_Axis_W   => (Xw * Ax) + (Yw * Ay) + (Zw * Az) + (Tw * Aw),
            Up_Axis_W      => (Xw * Bx) + (Yw * By) + (Zw * Bz) + (Tw * Bw),
            Forward_Axis_W => (Xw * Cx) + (Yw * Cy) + (Zw * Cz) + (Tw * Cw),
            Translation_W  => (Xw * Dx) + (Yw * Dy) + (Zw * Dz) + (Tw * Dw)
         );
      end return;
   end "*";


   function Translate (X, Y, Z : Float) return Matrix4 is
   begin
      return M : Matrix4 (Which => Components) do
         M.Elements := (Translation_X => X,
                        Translation_Y => Y,
                        Translation_Z => Z,
                        Right_Axis_X | Up_Axis_Y | Forward_Axis_Z | Translation_W => 1.0,
                        others => 0.0);
      end return;
   end Translate;


   function Scale (X, Y, Z : Float) return Matrix4 is
   begin
      return M : Matrix4 (Which => Components) do
         M.Elements := (Right_Axis_X   => X,
                        Up_Axis_Y      => Y,
                        Forward_Axis_Z => Z,
                        Translation_W  => 1.0,
                        others         => 0.0);
      end return;
   end Scale;


   function Rotate_Around_X (Angle : Float) return Matrix4 is
      Cos_Theta : constant Float := Cos (Angle);
      Sin_Theta : constant Float := Sin (Angle);
   begin
      return M : Matrix4 (Which => Components) do
         M.Elements := (Right_Axis_X |
                        Translation_W  => 1.0,
                        Up_Axis_Y      => Cos_Theta,
                        Up_Axis_Z      => Sin_Theta,
                        Forward_Axis_Y => -Sin_Theta,
                        Forward_Axis_Z => Cos_Theta,
                        others         => 0.0);
      end return;
   end Rotate_Around_X;


   function Rotate_Around_Y (Angle : Float) return Matrix4 is
      Cos_Theta : constant Float := Cos (Angle);
      Sin_Theta : constant Float := Sin (Angle);
   begin
      return M : Matrix4 (Which => Components) do
         M.Elements := (Up_Axis_Y |
                        Translation_W  => 1.0,
                        Right_Axis_X   => Cos_Theta,
                        Right_Axis_Z   => -Sin_Theta,
                        Forward_Axis_X => Sin_Theta,
                        Forward_Axis_Z => Cos_Theta,
                        others         => 0.0);
      end return;
   end Rotate_Around_Y;


   function Rotate_Around_Z (Angle : Float) return Matrix4 is
      Cos_Theta : constant Float := Cos (Angle);
      Sin_Theta : constant Float := Sin (Angle);
   begin
      return M : Matrix4 (Which => Components) do
         M.Elements := (Forward_Axis_Z |
                        Translation_W => 1.0,
                        Right_Axis_X  => Cos_Theta,
                        Right_Axis_Y  => Sin_Theta,
                        Up_Axis_X     => -Sin_Theta,
                        Up_Axis_Y     => Cos_Theta,
                        others        => 0.0);
      end return;
   end Rotate_Around_Z;


   function Perspective (Field_of_View, Aspect_Ratio, Near, Far : Float) return Matrix4 is
      Q            : constant Float := 1.0 / (Trig.Tan (Field_of_View / 2.0));
      A            : constant Float := Q / Aspect_Ratio;
      Near_Sub_Far : constant Float := Near - Far;
      B            : constant Float := (Near + Far) / Near_Sub_Far;
      C            : constant Float := (2.0 * (Near * Far)) / Near_Sub_Far;
   begin
      return M : Matrix4 (Which => Components) do
         M.Elements := (Right_Axis_X   => A,
                        Up_Axis_Y      => Q,
                        Forward_Axis_Z => B,
                        Forward_Axis_W => -1.0,
                        Translation_Z  => C,
                        others         => 0.0);
      end return;
   end Perspective;


   function Orthographic (Left, Right, Top, Bottom, Near, Far : Float) return Matrix4 is
      R_Sub_L      : constant Float := Right - Left;
      R_Add_L      : constant Float := Right + Left;
      T_Sub_B      : constant Float := Top - Bottom;
      T_Add_B      : constant Float := Top + Bottom;
      Far_Sub_Near : constant Float := Far - Near;
      Far_Add_Near : constant Float := Far + Near;
   begin
      return M : Matrix4 (Which => Components) do
         M.Elements := (Right_Axis_X   => 2.0 / R_Sub_L,
                        Up_Axis_Y      => 2.0 / T_Sub_B,
                        Forward_Axis_Z => -2.0 / Far_Sub_Near,
                        Translation_X  => -(R_Add_L / R_Sub_L),
                        Translation_Y  => -(T_Add_B / T_Sub_B),
                        Translation_Z  => -(Far_Add_Near / Far_Sub_Near),
                        Translation_W  => 1.0,
                        others         => 0.0);
      end return;
   end Orthographic;


   function Look_At (Eye, Target, Initial_Up : Vector4s.Vector4) return Matrix4 is
      New_Forward : constant Vector4s.Vector4 := Vector4s.Normalise (Eye - Target);
      Minus_Fwd   : constant Vector4s.Vector4 := -New_Forward;
      Side        : constant Vector4s.Vector4 := Vector4s.Normalise (Vector4s.Cross (Minus_Fwd, Initial_Up));
      New_Up      : constant Vector4s.Vector4 := Vector4s.Normalise (Vector4s.Cross (Side, Minus_Fwd));
   begin
      --  TODO: Is this right??
      return M : Matrix4 (Which => Vectors) do
         M.Axes := (Right       => Vector4s.To_Vector (Side.Elements (Vector4s.X),
                                                       New_Up.Elements (Vector4s.X),
                                                       Minus_Fwd.Elements (Vector4s.X),
                                                       0.0),
                    Up          => Vector4s.To_Vector (Side.Elements (Vector4s.Y),
                                                       New_Up.Elements (Vector4s.Y),
                                                       Minus_Fwd.Elements (Vector4s.Y),
                                                       0.0),
                    Forward     => Vector4s.To_Vector (Side.Elements (Vector4s.Z),
                                                       New_Up.Elements (Vector4s.Z),
                                                       Minus_Fwd.Elements (Vector4s.Z),
                                                       0.0),
                    Translation => Vector4s.To_Vector (-(Vector4s.Dot (Side, Eye)),
                                                       -(Vector4s.Dot (New_Up, Eye)),
                                                       -(Vector4s.Dot (Minus_Fwd, Eye)),
                                                       1.0));
      end return;
   end Look_At;


   procedure Matrix4_Image (Buffer : in out Ada.Strings.Text_Buffers.Root_Buffer_Type'Class; Arg : Matrix4) is
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
                  ", Forward => " & Arg.Axes (Forward)'Image &
                  ", Translation => " & Arg.Axes (Translation)'Image & ")");
   end Matrix4_Image;
end Maths.Matrix4s;
