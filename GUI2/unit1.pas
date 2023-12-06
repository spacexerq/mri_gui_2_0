unit Unit1;

{$mode objfpc}{$H+}
//{$APPTYPE CONSOLE}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ComCtrls, Types, Unit2, process, math, LCLType, IniFiles;

type

  { TForm1 }


  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    ListBox3: TListBox;
    ListBox4: TListBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure Image2Click(Sender: TObject);
    procedure Image2DblClick(Sender: TObject);
    procedure Image2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image2MouseEnter(Sender: TObject);
    procedure Image2MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure Image2MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure Image2MouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure Image2MouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure Image2Paint(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image3DblClick(Sender: TObject);
    procedure Image3MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure Image3Paint(Sender: TObject);
    procedure Image3MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure Image3MouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure Image3MouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);

    procedure Image4Click(Sender: TObject);
    procedure Image4DblClick(Sender: TObject);
    procedure Image4MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image4MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure Image4MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image4MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure Image4MouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure Image4MouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure Image4Paint(Sender: TObject);

    procedure Label1Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ListBox1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ListBox1MouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure ListBox2Click(Sender: TObject);
    procedure ListBox3Click(Sender: TObject);
    procedure ListBox3DblClick(Sender: TObject);
    procedure ListBox4Click(Sender: TObject);
    procedure ListBox4DblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);


  private

  public

  end;

var
  i, j: Integer;
  Form1: TForm1;
  RunProgram: TProcess;
  slice_flag1,slice_flag2,slice_flag3:boolean; // Флаги для возможности выставления среза
  x_sw, y_sw, z_sw: Integer;                         // смещение при выставлении среза в трех проекциях
  angle1, angle2, angle3: Float;               // углы поворота при выставлении среза в трех проекциях, меняются при нажатии на cntrl на 10 градусов
  x_slice, y_slice, z_slice: Integer;
  angle_x, angle_y, angle_z: Float;
  Button:TMouseButton;                         // хранит нажатые на мыши клавиши(левая, правая кнопка, средняя кнопка)
  Slice_pos_file :TextFile;                    // файл со смещениями и углами поворота при выставлении срезов
  Slice_num_file:TextFile;                     // файл, который хранит количество срезов
  current_slice,num_of_slices: Integer;        // Номер текущего среза, общее число срезов
  Imagename : string;                          // Имя файла с необходимым фото
  rot_x, rot_y, rot_z : array [1..3] of array [1..3] of Float; //Rotation matrices
  x1, x2, x3, x4: Float;
  y1, y2, y3, y4: Float;
  z1, z2, z3, z4: Float;
  Normed_len, ratio_const: Float;
  FStartPointX, FStartPointY: Integer;
  FlagDragAngle: Integer;

  // отрисовка среза
  FStartPoint, FEndPoint, FLastPoint, MemoryPos4, MemoryPos2, MemoryPos3 : TPoint; // Координаты мышки на картинках
  imageNumber: Integer; //  Номер картинки, на которой мышка

const
  LocalImWidth = 306;
  LocalImHeght = 368;
  ImageWidth = 480;
  ImageHeight = 600;
  Const_sweepW =Round(LocalImWidth/2);
  Const_sweepH =Round(LocalImHeght/2);
  rotation_scale = 400;
implementation
type MatrType = array [1..3] of array [1..3] of Float;
type VectorType = array [1..3] of Float;
{$R *.lfm}
var
  xAxisSw, yAxisSw, zAxisSw, TempVec, ResVec: VectorType;
  Rotation: MatrType;
{ TForm1 }


//Next possible type of realisation to convert vectors and matrices to the most useful dType
//
//
//function matmul(var matrix: MatrType; var vector: VectorType): VectorType;
//var ResArr:VectorType;
//    begin
//      ResArr[1]:=matrix[1][1]*vector[1]+matrix[1][2]*vector[2]+matrix[1][3]*vector[3];
//      ResArr[2]:=matrix[2][1]*vector[1]+matrix[2][2]*vector[2]+matrix[2][3]*vector[3];
//      ResArr[3]:=matrix[3][1]*vector[1]+matrix[3][2]*vector[2]+matrix[3][3]*vector[3];
//      matmul:=ResArr;
//    end;
//
//function rotation_mat(var angle: Float; var vec: VectorType): MatrType;
//var ResMat:MatrType;
//  begin
//     ResMat[1][1]:=Cos(angle)+(1-cos(angle))*vec[1]*vec[1];
//     ResMat[2][1]:=(1-Cos(angle))*vec[2]*vec[3]+Sin(angle)*vec[3];
//     ResMat[3][1]:=(1-Cos(angle))*vec[3]*vec[1]-Sin(angle)*vec[2];
//     ResMat[1][2]:=(1-Cos(angle))*vec[1]*vec[2]-Sin(angle)*vec[3];
//     ResMat[2][2]:=Cos(angle)+(1-Cos(angle))*vec[2]*vec[2];
//     ResMat[3][2]:=(1-Cos(angle))*vec[3]*vec[2]+Sin(angle)*vec[1];
//     ResMat[1][3]:=(1-Cos(angle))*vec[1]*vec[3]+Sin(angle)*vec[2];
//     ResMat[1][3]:=(1-Cos(angle))*vec[2]*vec[3]-Sin(angle)*vec[1];
//     ResMat[3][3]:=Cos(angle)+(1-Cos(angle))*vec[3]*vec[3];
//     rotation_mat:=ResMat;
//  end;

procedure TForm1.ListBox4Click(Sender: TObject);
begin

end;

procedure TForm1.ListBox4DblClick(Sender: TObject);     // вызов подпрограммы по двойному щелчку элемента списка

begin
RunProgram := TProcess.Create(nil);
RunProgram.CommandLine := 'guiGRE.exe';
RunProgram.Execute;
RunProgram.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  inif: TIniFile;
  x_ini, y_ini, w_ini, h_ini : Integer;
begin
  inif := TIniFile.Create('conf.ini');
  x_ini := inif.ReadInteger('Position', 'X', 0);
  y_ini := inif.ReadInteger('Position', 'Y', 0);
  w_ini := inif.ReadInteger('Size', 'W', 0);
  h_ini := inif.ReadInteger('Size', 'H', 0);
  Form1.Left:=x_ini;
  Form1.Top:=y_ini;
  Form1.Width:=w_ini;
  Form1.Height:=h_ini;
  ratio_const:= 0.5;
  Normed_len:= LocalImWidth * ratio_const;
  x1:=Normed_len*Sqrt(2)/2;
  x2:=Normed_len*Sqrt(2)/2;
  x3:=-Normed_len*Sqrt(2)/2;
  x4:=-Normed_len*Sqrt(2)/2;
  y1:=Normed_len*Sqrt(2)/2;
  y2:=-Normed_len*Sqrt(2)/2;
  y3:=Normed_len*Sqrt(2)/2;
  y4:=-Normed_len*Sqrt(2)/2;
  z1:= 0;
  z2:= 0;
  z3:= 0;
  z4:= 0;
  FlagDragAngle := 0;
end;



procedure TForm1.Button7Click(Sender: TObject);            // Добавление нового протокола в текущее исследование
begin
     if  Listbox3.ItemIndex>-1  then
     Listbox4.Items.Add(Listbox3.Items.Strings[Listbox3.ItemIndex]);
end;

procedure TForm1.Button8Click(Sender: TObject);            // Удаление элемента из списка протоколов
begin
   if (ListBox4.ItemIndex > -1) then
        ListBox4.Items.Delete(ListBox4.ItemIndex);
end;

procedure TForm1.Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin

end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin

end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: char);
begin

end;

procedure TForm1.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin

end;

procedure TForm1.Image2Click(Sender: TObject);
begin

end;

procedure TForm1.Image2DblClick(Sender: TObject);
begin
  slice_flag2 := false;
end;

procedure TForm1.Image2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

end;

procedure TForm1.Image2MouseEnter(Sender: TObject);
begin


end;

procedure TForm1.Image2MouseMove(Sender: TObject; Shift: TShiftState; X,  // Выставление среза в первой плоскости при движении мыши по картинке
  Y: Integer);
begin
  FStartPoint := Point(X, Y);
  imageNumber := 2;
  if (slice_flag2) then begin

  Image2.Invalidate;
  Image3.Invalidate;
  Image4.Invalidate;
  //Memorize prev mouse position and compare to now
  //
  if (ssCtrl in Shift) then begin
  if(FStartPoint.Y > MemoryPos2.Y)or
  (FStartPoint.X < MemoryPos2.X) then begin
  angle_x := -3.14159/rotation_scale;
  end
  else
  begin
  angle_x := +3.14159/rotation_scale;
  end;
  rot_x[1][1] := Cos(angle_x);
  rot_x[3][3] := Cos(angle_x);
  rot_x[1][3] := Sin(angle_x);
  rot_x[3][1] := -Sin(angle_x);
  x1:= rot_x[1][1]*x1 - rot_x[1][3]*z1;
  z1:= rot_x[3][1]*x1 + rot_x[3][3]*z1;
  x2:= rot_x[1][1]*x2 - rot_x[1][3]*z2;
  z2:= rot_x[3][1]*x2 + rot_x[3][3]*z2;
  x3:= rot_x[1][1]*x3 - rot_x[1][3]*z3;
  z3:= rot_x[3][1]*x3 + rot_x[3][3]*z3;
  x4:= rot_x[1][1]*x4 - rot_x[1][3]*z4;
  z4:= rot_x[3][1]*x4 + rot_x[3][3]*z4;
  end;
  MemoryPos2:=FStartPoint;
  end;
end;

procedure TForm1.Image2MouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin




end;

procedure TForm1.Image2MouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  Image2.Invalidate;
  Image3.Invalidate;
  Image4.Invalidate;
  if (slice_flag2) then begin
  z1:=z1+5;
  z2:=z2+5;
  z3:=z3+5;
  z4:=z4+5;
end;
end;

procedure TForm1.Image2MouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  Image2.Invalidate;
  Image3.Invalidate;
  Image4.Invalidate;
  if (slice_flag1) then begin
  z1:=z1-5;
  z2:=z2-5;
  z3:=z3-5;
  z4:=z4-5;
end;
end;

procedure TForm1.Image2Paint(Sender: TObject);
begin
  // Draw the PNG file onto the TImage
  Image2.Canvas.Draw(0, 0, Image2.Picture.Graphic);

  // Draw the line
  Image2.Canvas.Pen.Color := clRed; // Set line color to red
  Image2.Canvas.Line(Round(y2+Const_sweepW), Round(z2+Const_sweepH), Round(y1+Const_sweepW), Round(z1+Const_sweepH));
  Image2.Canvas.Line(Round(y3+Const_sweepW), Round(z3+Const_sweepH), Round(y1+Const_sweepW), Round(z1+Const_sweepH));
  Image2.Canvas.Line(Round(y4+Const_sweepW), Round(z4+Const_sweepH), Round(y3+Const_sweepW), Round(z3+Const_sweepH));
  Image2.Canvas.Line(Round(y4+Const_sweepW), Round(z4+Const_sweepH), Round(y2+Const_sweepW), Round(z2+Const_sweepH));
  if (imageNumber = 2) then begin
  Image3.OnPaint(Sender);
  Image4.OnPaint(Sender);
  end;
end;

procedure TForm1.Image3Click(Sender: TObject);
begin

end;

procedure TForm1.Image3DblClick(Sender: TObject);
begin
  slice_flag3 := false;     // Блокирование выставления среза при двойном нажатии на картинку
end;

procedure TForm1.Image3MouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin

end;

procedure TForm1.Image3MouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  imageNumber := 3;
  Image2.Invalidate;
  Image3.Invalidate;
  Image4.Invalidate;
  if (slice_flag3) then begin
  x1:=x1-5;
  x2:=x2-5;
  x3:=x3-5;
  x4:=x4-5;
  writeln(x1);
end;
end;

procedure TForm1.Image3MouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  imageNumber := 3;
  Image2.Invalidate;
  Image3.Invalidate;
  Image4.Invalidate;
  if (slice_flag3) then begin
  x1:=x1+5;
  x2:=x2+5;
  x3:=x3+5;
  x4:=x4+5;
  writeln(x1);
end;

end;


procedure TForm1.Image3MouseMove(Sender: TObject; Shift: TShiftState; X,       // Выставление среза во второй плоскости при движении мыши по картинке
  Y: Integer);
begin
  imageNumber :=3;
  if (slice_flag3) then begin
  FStartPoint := Point(X, Y);

  // Forces a repaint
  Image2.Invalidate;
  Image3.Invalidate;
  Image4.Invalidate;
  if (ssCtrl in Shift) then begin

  if(FStartPoint.Y > MemoryPos3.Y) or
  (FStartPoint.X < MemoryPos3.X) then begin
  angle_z := -3.14159/rotation_scale;
  end
  else
  begin
  angle_z := +3.14159/rotation_scale;
  end;
  rot_z[1][1] := Cos(angle_z);
  rot_z[2][2] := Cos(angle_z);
  rot_z[1][2] := Sin(angle_z);
  rot_z[2][1] := -Sin(angle_z);
  x1:= rot_z[1][1]*x1 + rot_z[1][2]*y1;
  y1:= rot_z[2][1]*x1 + rot_z[2][2]*y1;
  x2:= rot_z[1][1]*x2 + rot_z[1][2]*y2;
  y2:= rot_z[2][1]*x2 + rot_z[2][2]*y2;
  x3:= rot_z[1][1]*x3 + rot_z[1][2]*y3;
  y3:= rot_z[2][1]*x3 + rot_z[2][2]*y3;
  x4:= rot_z[1][1]*x4 + rot_z[1][2]*y4;
  y4:= rot_z[2][1]*x4 + rot_z[2][2]*y4;
  end;
  MemoryPos3:=FStartPoint;
  end;
end;

procedure TForm1.Image3Paint(Sender: TObject);
begin
  // Draw the PNG file onto the TImage
  Image3.Canvas.Draw(0, 0, Image3.Picture.Graphic);
  // Set line color to red
  Image3.Canvas.Pen.Color := clRed;
  //drawing slice as rectangle
  Image3.Canvas.Line(Round(x3+Const_sweepW), Round(y3+Const_sweepH), Round(x4+Const_sweepW), Round(y4+Const_sweepH));
  Image3.Canvas.Line(Round(x2+Const_sweepW), Round(y2+Const_sweepH), Round(x1+Const_sweepW), Round(y1+Const_sweepH));
  Image3.Canvas.Line(Round(x3+Const_sweepW), Round(y3+Const_sweepH), Round(x1+Const_sweepW), Round(y1+Const_sweepH));
  Image3.Canvas.Line(Round(x4+Const_sweepW), Round(y4+Const_sweepH), Round(x2+Const_sweepW), Round(y2+Const_sweepH));
  if (imageNumber = 3) then begin
  Image2.OnPaint(Sender);
  Image4.OnPaint(Sender);
  end;

end;


procedure TForm1.Image4Click(Sender: TObject);
begin

end;

procedure TForm1.Image4DblClick(Sender: TObject);
begin
  slice_flag1:= false;
end;

procedure TForm1.Image4MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

end;

procedure TForm1.Image4MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin

  FStartPoint := Point(X, Y);
  imageNumber := 4;
  if (slice_flag1) then begin
  //Refresh
  Image2.Invalidate;
  Image3.Invalidate;
  Image4.Invalidate;

  if (ssCtrl in Shift) then begin
  if(FStartPoint.Y > MemoryPos4.Y)or
  (FStartPoint.X < MemoryPos4.X) then begin
  angle_y := -3.14159/rotation_scale;
  end
  else
  begin
  angle_y := +3.14159/rotation_scale;
  end;
  rot_y[2][2] := Cos(angle_y);
  rot_y[3][3] := Cos(angle_y);
  rot_y[2][3] := -Sin(angle_y);
  rot_y[3][2] := Sin(angle_y);
  y1:= rot_y[2][2]*y1 + rot_y[3][2]*z1;
  z1:= rot_y[2][3]*y1 + rot_y[3][3]*z1;
  y2:= rot_y[2][2]*y2 + rot_y[3][2]*z2;
  z2:= rot_y[2][3]*y2 + rot_y[3][3]*z2;
  y3:= rot_y[2][2]*y3 + rot_y[3][2]*z3;
  z3:= rot_y[2][3]*y3 + rot_y[3][3]*z3;
  y4:= rot_y[2][2]*y4 + rot_y[3][2]*z4;
  z4:= rot_y[2][3]*y4 + rot_y[3][3]*z4;
  end;
  MemoryPos4:=FStartPoint;
  end;
end;

procedure TForm1.Image4MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

end;

procedure TForm1.Image4MouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin

end;

procedure TForm1.Image4MouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  imageNumber := 4;
  Image2.Invalidate;
  Image3.Invalidate;
  Image4.Invalidate;
  if (slice_flag1) then begin
  z1:=z1+5;
  z2:=z2+5;
  z3:=z3+5;
  z4:=z4+5;
end;
end;

procedure TForm1.Image4MouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  imageNumber := 4;
  Image2.Invalidate;
  Image3.Invalidate;
  Image4.Invalidate;
  if (slice_flag1) then begin
  z1:=z1-5;
  z2:=z2-5;
  z3:=z3-5;
  z4:=z4-5;
end;
end;

procedure TForm1.Image4Paint(Sender: TObject);
begin
  // Draw the PNG file onto the TImage
  Image4.Canvas.Draw(0, 0, Image4.Picture.Graphic);
  // Set line color to red
  Image4.Canvas.Pen.Color := clRed;
  Image4.Canvas.Line(Round(x2+Const_sweepW), Round(z2+Const_sweepH), Round(x4+Const_sweepW), Round(z4+Const_sweepH));
  Image4.Canvas.Line(Round(x3+Const_sweepW), Round(z3+Const_sweepH), Round(x4+Const_sweepW), Round(z4+Const_sweepH));
  Image4.Canvas.Line(Round(x3+Const_sweepW), Round(z3+Const_sweepH), Round(x1+Const_sweepW), Round(z1+Const_sweepH));
  Image4.Canvas.Line(Round(x1+Const_sweepW), Round(z1+Const_sweepH), Round(x2+Const_sweepW), Round(z2+Const_sweepH));
  if (imageNumber = 4) then begin
  Image2.OnPaint(Sender);
  Image3.OnPaint(Sender);
end;
end;



procedure TForm1.Label1Click(Sender: TObject);
begin

end;

procedure TForm1.Label2Click(Sender: TObject);
begin

end;

procedure TForm1.ListBox1Click(Sender: TObject);
begin

end;

procedure TForm1.ListBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

end;

procedure TForm1.ListBox1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

end;

procedure TForm1.ListBox1MouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin

end;

procedure TForm1.ListBox2Click(Sender: TObject);
begin

end;

procedure TForm1.ListBox3Click(Sender: TObject);
begin

end;

procedure TForm1.ListBox3DblClick(Sender: TObject);
begin

end;

procedure TForm1.Button3Click(Sender: TObject);      // "Cancel" button
begin
  Listbox4.clear;
  Listbox1.ItemIndex:=0;
  Listbox2.ItemIndex:=0;
  x1:=Normed_len*Sqrt(2)/2;
  x2:=Normed_len*Sqrt(2)/2;
  x3:=-Normed_len*Sqrt(2)/2;
  x4:=-Normed_len*Sqrt(2)/2;
  y1:=Normed_len*Sqrt(2)/2;
  y2:=-Normed_len*Sqrt(2)/2;
  y3:=Normed_len*Sqrt(2)/2;
  y4:=-Normed_len*Sqrt(2)/2;
  z1:= 0;
  z2:= 0;
  z3:= 0;
  z4:= 0;
  angle_x:=0;
  angle_z:=0;
  angle_y:=0;
  for i := 1 to 3 do
      begin
      for j := 1 to 3 do
          if (i=j) then begin
             rot_x[i][j] := 1;
             rot_y[i][j] := 1;
             rot_z[i][j] := 1;
          end
          else
          begin
             rot_x[i][j] := 0;
             rot_y[i][j] := 0;
             rot_z[i][j] := 0;
          end;
          end;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  Listbox4.ItemIndex:=Listbox4.ItemIndex+1;
end;

procedure TForm1.Button1Click(Sender: TObject); //"Scan" button
var
  Picture2, Picture3, Picture4: TPicture;
begin
     Picture2 := TPicture.Create;
     Picture3 := TPicture.Create;
     Picture4 := TPicture.Create;
     rot_z[1][1]:=1;
     rot_x[1][1]:=1;
     rot_y[1][1]:=1;
     rot_x[2][2]:=1;
     rot_x[3][3]:=1;
     rot_y[2][2]:=1;
     rot_y[3][3]:=1;
     rot_z[2][2]:=1;
     rot_z[3][3]:=1;
     Imagename := 'MRI_test_' + IntToStr(current_slice)+'_'+'0'+'.png';
     image4.Picture.LoadFromFile(Imagename);
     Imagename := 'MRI_test_' + IntToStr(current_slice)+'_'+'1'+'.png';
     image2.Picture.LoadFromFile(Imagename);
     Imagename := 'MRI_test_' + IntToStr(current_slice)+'_'+'2'+'.png';
     image3.Picture.LoadFromFile(Imagename);
     slice_flag1 := true;
     slice_flag2 := true;
     slice_flag3 := true;
     imageNumber := 0;


     // Draw the picture on the TImage
     Image2.Canvas.Draw(0, 0, Picture2.Graphic);
     Image3.Canvas.Draw(0, 0, Picture3.Graphic);
     Image4.Canvas.Draw(0, 0, Picture4.Graphic);

     Assignfile(Slice_num_file,'Slice_num_file.txt');
     try
       reset(Slice_num_file);
       readln(Slice_num_file,num_of_slices);
     finally
            CloseFile(Slice_num_file);
end;

end;

procedure TForm1.Button2Click(Sender: TObject); //Rotation matrices output
begin
  Assignfile(Slice_pos_file,'Slice_pos_file.txt');
  try
    rewrite(Slice_pos_file);  // для бесконечной записи в файл используй reset
    append(Slice_pos_file);
    writeln(Slice_pos_file,'Номер среза' , ' ', 'Проекция',' ','Смещение по Y',' ', 'Градус поворота');
    writeln(Slice_pos_file,current_slice , '             ', '1', '            ',y1,'         ',-RadToDeg(angle1));
    writeln(Slice_pos_file,current_slice , '             ', '2', '            ', y2, '         ',-RadToDeg(angle2));
    writeln(Slice_pos_file,current_slice , '             ', '3', '            ',y3, '         ',-RadToDeg(angle3));
    writeln(Slice_pos_file,current_slice , ' X ', 'rotation');
    for i:=1 to 3 do
          writeln(Slice_pos_file, rot_x[i][1],rot_x[i][2],rot_x[i][3]);
    writeln(Slice_pos_file,current_slice , ' Y ', 'rotation');
    for i:=1 to 3 do
          writeln(Slice_pos_file, rot_y[i][1],rot_y[i][2],rot_y[i][3]);
    writeln(Slice_pos_file,current_slice , ' Z ', 'rotation');
    for i:=1 to 3 do
          writeln(Slice_pos_file, rot_z[i][1],rot_z[i][2],rot_z[i][3]);
  finally
    CloseFile(Slice_pos_file);
  end;
end;


end.

