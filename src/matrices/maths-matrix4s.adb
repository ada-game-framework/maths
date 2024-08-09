------------------------------------------------------------------------------------------------------------------------
--  This source code is subject to the BSD license, see the LICENCE file in the root of this directory.
------------------------------------------------------------------------------------------------------------------------
with Ada.Numerics.Generic_Elementary_Functions;

package body Maths.Matrix4s is
   use type Vector4s.Vector4;

   package Trig is new Ada.Numerics.Generic_Elementary_Functions (Float);
   use Trig;


   function "+" (Left, Right : Matrix4) return Matrix4 is
   begin
      return M : Matrix4 (Vectors) do
         M.Axes (X) := Left.Axes (X) + Right.Axes (X);
         M.Axes (Y) := Left.Axes (Y) + Right.Axes (Y);
         M.Axes (Z) := Left.Axes (Z) + Right.Axes (Z);
         M.Axes (T) := Left.Axes (T) + Right.Axes (T);
      end return;
   end "+";


   function "-" (Left, Right : Matrix4) return Matrix4 is
   begin
      return M : Matrix4 (Vectors) do
         M.Axes (X) := Left.Axes (X) - Right.Axes (X);
         M.Axes (Y) := Left.Axes (Y) - Right.Axes (Y);
         M.Axes (Z) := Left.Axes (Z) - Right.Axes (Z);
         M.Axes (T) := Left.Axes (T) - Right.Axes (T);
      end return;
   end "-";


   function "*" (Left : Matrix4; Right : Vector4s.Vector4) return Vector4s.Vector4 is
   begin
      return V : Vector4s.Vector4 (Vector4s.SIMD) do
         V.Elements := (Vector4s.X => Left.Elements (X_Axis_X) * Right.Elements (Vector4s.X) +
                                      Left.Elements (X_Axis_Y) * Right.Elements (Vector4s.Y) +
                                      Left.Elements (X_Axis_Z) * Right.Elements (Vector4s.Z) +
                                      Left.Elements (X_Axis_W) * Right.Elements (Vector4s.W),

                        Vector4s.Y => Left.Elements (Y_Axis_X) * Right.Elements (Vector4s.X) +
                                      Left.Elements (Y_Axis_Y) * Right.Elements (Vector4s.Y) +
                                      Left.Elements (Y_Axis_Z) * Right.Elements (Vector4s.Z) +
                                      Left.Elements (Y_Axis_W) * Right.Elements (Vector4s.W),

                        Vector4s.Z => Left.Elements (Z_Axis_X) * Right.Elements (Vector4s.X) +
                                      Left.Elements (Z_Axis_Y) * Right.Elements (Vector4s.Y) +
                                      Left.Elements (Z_Axis_Z) * Right.Elements (Vector4s.Z) +
                                      Left.Elements (Z_Axis_W) * Right.Elements (Vector4s.W),

                        Vector4s.W => Left.Elements (Translation_X) * Right.Elements (Vector4s.X) +
                                      Left.Elements (Translation_Y) * Right.Elements (Vector4s.Y) +
                                      Left.Elements (Translation_Z) * Right.Elements (Vector4s.Z) +
                                      Left.Elements (Translation_W) * Right.Elements (Vector4s.W));
      end return;
   end "*";


   --      Row         * column
   --      X  Y  Z  T    X  Y  Z  T
   -------------------------------
   --  X | Xx Yx Zx Tx   Ax Bx Cx Dx   XxAx+YxAy+ZxAz+TxAw XxBx+YxBy+ZxBz+TxBw XxCx+YxCy+ZxCz+TxCw XxDx+YxDy+ZxDz+TxDw
   --  Y | Xy Yy Zy Ty * Ay By Cy Dy = XyAx+YyAy+ZyAz+TyAw XyBx+YyBy+ZyBz+TyBw XyCx+YyCy+ZyCz+TyCw XyDx+YyDy+ZyDz+TyDw
   --  Z | Xz Yz Zz Tz   Az Bz Cz Dz   XzAx+YzAy+ZzAz+TzAw XzBx+YzBy+ZzBz+TzBw XzCx+YzCy+ZzCz+TzCw XzDx+YzDy+ZzDz+TzDw
   --  W | Xw Yw Zw Tw   Aw Bw Cw Dw   XwAx+YwAy+ZwAz+TwAw XwBx+YwBy+ZwBz+TwBw XwCx+YwCy+ZwCz+TwCw XwDx+YwDy+ZwDz+TwDw
   function "*" (Left, Right : Matrix4) return Matrix4 is
      LE : Float_Array renames Left.Elements;
      RE : Matrix_2D_Array renames Right.Elements_2D;

      Xx : Float renames LE (X_Axis_X);
      Yx : Float renames LE (Y_Axis_X);
      Zx : Float renames LE (Z_Axis_X);
      Tx : Float renames LE (Translation_X);

      Xy : Float renames LE (X_Axis_Y);
      Yy : Float renames LE (Y_Axis_Y);
      Zy : Float renames LE (Z_Axis_Y);
      Ty : Float renames LE (Translation_Y);

      Xz : Float renames LE (X_Axis_Z);
      Yz : Float renames LE (Y_Axis_Z);
      Zz : Float renames LE (Z_Axis_Z);
      Tz : Float renames LE (Translation_W);

      Xw : Float renames LE (X_Axis_W);
      Yw : Float renames LE (Y_Axis_W);
      Zw : Float renames LE (Z_Axis_W);
      Tw : Float renames LE (Translation_W);

      Ax : Float renames RE (X, X);
      Ay : Float renames RE (Y, X);
      Az : Float renames RE (Z, X);
      Aw : Float renames RE (W, X);

      Bx : Float renames RE (X, Y);
      By : Float renames RE (Y, Y);
      Bz : Float renames RE (Z, Y);
      Bw : Float renames RE (W, Y);

      Cx : Float renames RE (X, Z);
      Cy : Float renames RE (Y, Z);
      Cz : Float renames RE (Z, Z);
      Cw : Float renames RE (W, Z);

      Dx : Float renames RE (X, T);
      Dy : Float renames RE (Y, T);
      Dz : Float renames RE (Z, T);
      Dw : Float renames RE (W, T);
   begin
      return M : Matrix4 (Components) do
         M.Elements := (
            X_Axis_X      => (Xx * Ax) + (Yx * Ay) + (Zx * Az) + (Tx * Aw),
            Y_Axis_X      => (Xx * Bx) + (Yx * By) + (Zx * Bz) + (Tx * Bw),
            Z_Axis_X      => (Xx * Cx) + (Yx * Cy) + (Zx * Cz) + (Tx * Cw),
            Translation_X => (Xx * Dx) + (Yx * Dy) + (Zx * Dz) + (Tx * Dw),
            X_Axis_Y      => (Xy * Ax) + (Yy * Ay) + (Zy * Az) + (Ty * Aw),
            Y_Axis_Y      => (Xy * Bx) + (Yy * By) + (Zy * Bz) + (Ty * Bw),
            Z_Axis_Y      => (Xy * Cx) + (Yy * Cy) + (Zy * Cz) + (Ty * Cw),
            Translation_Y => (Xy * Dx) + (Yy * Dy) + (Zy * Dz) + (Ty * Dw),
            X_Axis_Z      => (Xz * Ax) + (Yz * Ay) + (Zz * Az) + (Tz * Aw),
            Y_Axis_Z      => (Xz * Bx) + (Yz * By) + (Zz * Bz) + (Tz * Bw),
            Z_Axis_Z      => (Xz * Cx) + (Yz * Cy) + (Zz * Cz) + (Tz * Cw),
            Translation_Z => (Xz * Dx) + (Yz * Dy) + (Zz * Dz) + (Tz * Dw),
            X_Axis_W      => (Xw * Ax) + (Yw * Ay) + (Zw * Az) + (Tw * Aw),
            Y_Axis_W      => (Xw * Bx) + (Yw * By) + (Zw * Bz) + (Tw * Bw),
            Z_Axis_W      => (Xw * Cx) + (Yw * Cy) + (Zw * Cz) + (Tw * Cw),
            Translation_W => (Xw * Dx) + (Yw * Dy) + (Zw * Dz) + (Tw * Dw)
         );
      end return;
   end "*";


   function Translate (X, Y, Z : Float) return Matrix4 is
   begin
      return M : Matrix4 (Which => Components) do
         M.Elements := (Translation_X => X, Translation_Y => Y, Translation_Z => Z,
                        X_Axis_X | Y_Axis_Y | Z_Axis_Z => 1.0,
                        others => 0.0);
      end return;
   end Translate;


   function Scale (X, Y, Z : Float) return Matrix4 is
   begin
      return M : Matrix4 (Which => Components) do
         M.Elements := (X_Axis_X => X,
                        Y_Axis_Y => Y,
                        Z_Axis_Z => Z,
                        Translation_W => 1.0,
                        others => 0.0);
      end return;
   end Scale;


   function Rotate_Around_X (Angle : Float) return Matrix4 is
      Cos_Theta : constant Float := Cos (Angle);
      Sin_Theta : constant Float := Sin (Angle);
   begin
      return M : Matrix4 (Which => Components) do
         M.Elements := (X_Axis_X | Translation_W => 1.0,
                        Y_Axis_Y => Cos_Theta,
                        Y_Axis_Z => Sin_Theta,
                        Z_Axis_Y => -Sin_Theta,
                        Z_Axis_Z => Cos_Theta,
                        others => 0.0);
      end return;
   end Rotate_Around_X;


   function Rotate_Around_Y (Angle : Float) return Matrix4 is
      Cos_Theta : constant Float := Cos (Angle);
      Sin_Theta : constant Float := Sin (Angle);
   begin
      return M : Matrix4 (Which => Components) do
         M.Elements := (Y_Axis_Y | Translation_W => 1.0,
                        X_Axis_X => Cos_Theta,
                        X_Axis_Z => -Sin_Theta,
                        Z_Axis_X => Sin_Theta,
                        Z_Axis_Z => Cos_Theta,
                        others => 0.0);
      end return;
   end Rotate_Around_Y;


   function Rotate_Around_Z (Angle : Float) return Matrix4 is
      Cos_Theta : constant Float := Cos (Angle);
      Sin_Theta : constant Float := Sin (Angle);
   begin
      return M : Matrix4 (Which => Components) do
         M.Elements := (Z_Axis_Z | Translation_W => 1.0,
                        X_Axis_X => Cos_Theta,
                        X_Axis_Y => Sin_Theta,
                        Y_Axis_X => -Sin_Theta,
                        Y_Axis_Y => Cos_Theta,
                        others => 0.0);
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
         M.Elements := (X_Axis_X      => A,
                        Y_Axis_Y      => Q,
                        Z_Axis_Z      => B,
                        Z_Axis_W      => -1.0,
                        Translation_Z => C,
                        others        => 0.0);
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
         M.Elements := (X_Axis_X      => 2.0 / R_Sub_L,
                        Y_Axis_Y      => 2.0 / T_Sub_B,
                        Z_Axis_Z      => -2.0 / Far_Sub_Near,
                        Translation_X => R_Add_L / R_Sub_L,
                        Translation_Y => T_Add_B / T_Sub_B,
                        Translation_Z => Far_Add_Near / Far_Sub_Near,
                        Translation_W => 1.0,
                        others        => 0.0);
      end return;
   end Orthographic;
end Maths.Matrix4s;
