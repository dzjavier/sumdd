unit Colocalization2D;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,ExtDlgs, Coloc2DView, Colocalization,
  ComCtrls,
  Math,
  Mask;

type
  TFColoc2D = class(TForm)
    OPDColoc2D: TOpenPictureDialog;
    PChs: TPanel;
    BLoadCH1: TButton;
    BuBloadCH2: TButton;
    CBCh1Red: TCheckBox;
    CBCh1Green: TCheckBox;
    CBCh1Blue: TCheckBox;
    CbCh2Red: TCheckBox;
    CBCh2Green: TCheckBox;
    CBCh2Blue: TCheckBox;
    LIntCh1: TLabel;
    EIntCh1: TEdit;
    LIntCh2: TLabel;
    EIntCh2: TEdit;
    LFileNameCh1: TLabel;
    LFileNameCh2: TLabel;
    BColoc: TButton;
    LMinIntensityCh1: TLabel;
    LMaxIntensityCh1: TLabel;
    MEMinIntensityCh1: TMaskEdit;
    MEMaxIntensityCh1: TMaskEdit;
    LMinIntensityCh2: TLabel;
    MEMinIntensityCh2: TMaskEdit;
    LMaxIntensityCh2: TLabel;
    MEMaxIntensityCh2: TMaskEdit;
    UDMinIntensityCh1: TUpDown;
    UDMaxIntensityCh1: TUpDown;
    UDMinIntensityCh2: TUpDown;
    UDMaxIntensityCh2: TUpDown;
    procedure FormCreate(Sender: TObject);
    procedure BLoadCH1Click(Sender: TObject);
    procedure BuBloadCH2Click(Sender: TObject);
    procedure CBCh1RedClick(Sender: TObject);
    procedure CBCh1GreenClick(Sender: TObject);
    procedure CBCh1BlueClick(Sender: TObject);
    procedure CbCh2RedClick(Sender: TObject);
    procedure CBCh2GreenClick(Sender: TObject);
    procedure CBCh2BlueClick(Sender: TObject);
    procedure BColocClick(Sender: TObject);
    procedure UDMinIntensityCh1Click(Sender: TObject; Button: TUDBtnType);
    procedure UDMaxIntensityCh1Click(Sender: TObject; Button: TUDBtnType);
    procedure UDMinIntensityCh2Click(Sender: TObject; Button: TUDBtnType);
    procedure UDMaxIntensityCh2Click(Sender: TObject; Button: TUDBtnType);
    procedure MEMinIntensityCh1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MEMaxIntensityCh1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MEMinIntensityCh2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MEMaxIntensityCh2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure UDMinIntensityCh1ChangingEx(Sender: TObject;
      var AllowChange: Boolean; NewValue: Smallint;
      Direction: TUpDownDirection);
    procedure UDMaxIntensityCh1ChangingEx(Sender: TObject;
      var AllowChange: Boolean; NewValue: Smallint;
      Direction: TUpDownDirection);
    procedure UDMinIntensityCh2ChangingEx(Sender: TObject;
      var AllowChange: Boolean; NewValue: Smallint;
      Direction: TUpDownDirection);
    procedure UDMaxIntensityCh2ChangingEx(Sender: TObject;
      var AllowChange: Boolean; NewValue: Smallint;
      Direction: TUpDownDirection);
  private
    { Private declarations }

  public
   FScale:Single; // Factor de escala
   MT:Double; // Magnificación
    { Public declarations }

  end;

var
 FColoc2D: TFColoc2D;
 Ch1,Ch2: array of double;

implementation
  {$R *.dfm}



procedure TFColoc2D.FormCreate(Sender: TObject);
 begin
  MT:=1;
  FScale:=1;
 end;

procedure TFColoc2D.BLoadCH1Click(Sender: TObject);
var
 Save_Cursor:TCursor;
 j,i,Counter:integer;
 Max,Min:Double;
begin
 CBCh1Red.Checked:=True;
 CBCh1Green.Checked:=True;
 CBCh1Blue.Checked:=True;
 Save_Cursor:=Screen.Cursor;
 Screen.Cursor:=crHourGlass;

 if OPDColoc2D.Execute then
  begin
//   ImViewLayerCH1.Bitmap.LoadFromFile(OPDColoc2D.FileName);
   LFileNameCh1.Caption:= 'Archivo Canal1: ' + ExtractFileName(OPDColoc2D.FileName);
//   SetLength(Ch1,ImViewLayerCH1.Bitmap.Height*ImViewLayerCH1.Bitmap.Width);
   counter:=0;
{   for i:=0 to ImViewLayerCH1.Bitmap.Height-1 do
    for j:=0 to ImViewLayerCH1.Bitmap.Width-1 do
     begin
      Ch1[Counter]:= Intensity(ImViewLayerCH1.Bitmap.PixelS[j,i]);
      inc(Counter);
     end;          }
   Max:=MaxValue(Ch1);
   Min:=MinValue(Ch1);
   counter:=0;
   for i:=0 to ImViewLayerCH1.Bitmap.Height-1 do
    for j:=0 to ImViewLayerCH1.Bitmap.Width-1 do
     begin
      Ch1[Counter]:= 255*(Ch1[Counter]-Min)/(Max-Min);
      ImViewLayerCH1.Bitmap.PixelS[j,i]:=Gray32(Trunc(Ch1[Counter]));
      inc(Counter);
     end;
   end;

  Screen.Cursor:=Save_Cursor;
end;

procedure TFColoc2D.BuBloadCH2Click(Sender: TObject);
var
 Save_Cursor:TCursor;
 j,i,Counter:integer;
 Max,Min:Double;
begin
 CBCh2Red.Checked:=True;
 CBCh2Green.Checked:=True;
 CBCh2Blue.Checked:=True;
 Save_Cursor:=Screen.Cursor;
 Screen.Cursor:=crHourGlass;

 if OPDColoc2D.Execute then
  begin
   ImViewLayerCH2.Bitmap.LoadFromFile(OPDColoc2D.FileName);
   LFileNameCh2.Caption:= 'Archivo Canal2: ' + ExtractFileName(OPDColoc2D.FileName);
   SetLength(Ch2,ImViewLayerCH2.Bitmap.Height*ImViewLayerCH2.Bitmap.Width);
   counter:=0;
   for i:=0 to ImViewLayerCH2.Bitmap.Height-1 do
    for j:=0 to ImViewLayerCH2.Bitmap.Width-1 do
     begin
      Ch2[Counter]:= intensity(ImViewLayerCH2.Bitmap.PixelS[j,i]);
      inc(Counter);
     end;
   Max:=MAxValue(Ch2);
   Min:=MinValue(Ch2);
   counter:=0;
   for i:=0 to ImViewLayerCH2.Bitmap.Height-1 do
    for j:=0 to ImViewLayerCH2.Bitmap.Width-1 do
     begin
      Ch2[Counter]:= 255*(Ch2[Counter]-Min)/(Max-Min);
      ImViewLayerCH2.Bitmap.PixelS[j,i]:=Gray32(Trunc(Ch2[Counter]));
      inc(Counter);
     end;

    end;
  Screen.Cursor:=Save_Cursor;
end;

procedure TFColoc2D.MaskRGBandIntensity(const Data: array of double;BM32:TBitmap32; R,G,B:Boolean;
                                                   MinIntensity,MaxIntensity:Double);
var
  Value,Red,Green,Blue:Byte;

  j,i,Counter:integer;
 begin
  if (not (BM32 = nil)) and (not (Length(Data) = 0)) then
   begin
    Counter:=0;
    for i:=0 to BM32.Height-1 do
     for j:=0 to BM32.Width-1 do
      begin

       if (Data[Counter]>MinIntensity) and  (Data[Counter]<=MaxIntensity) then
        begin
         Value:=Trunc(255*(Data[Counter]-MinIntensity)/(MaxIntensity-MinIntensity));
         if R then Red:= Value else Red:=$00;
         if G then Green:=Value else Green:=$00;
         if B then Blue:=Value else Blue:=$00;
         BM32[j,i]:=Color32(Red,Green,Blue);
        end
       else
        begin
         if R then Red:= 0 else Red:=$00;
         if G then Green:=0 else Green:=$00;
         if B then Blue:=0 else Blue:=$00;
         BM32[j,i]:=Color32(Red,Green,Blue);
        end;
       inc(Counter);
      end;
    end
 end;
procedure TFColoc2D.CBCh1RedClick(Sender: TObject);
begin
 MaskRGBandIntensity(CH1,ImViewLayerCH1.Bitmap,CBCh1Red.Checked,CBCh1Green.Checked,CBCh1Blue.Checked,
                              UDMinIntensityCh1.Position,UDMaxIntensityCh1.Position);
 ImViewLayerCH1.Repaint;
end;

procedure TFColoc2D.CBCh1GreenClick(Sender: TObject);
begin
 MaskRGBandIntensity(CH1,ImViewLayerCH1.Bitmap,CBCh1Red.Checked,CBCh1Green.Checked,CBCh1Blue.Checked,
                              UDMinIntensityCh1.Position,UDMaxIntensityCh1.Position);

 ImViewLayerCH1.Repaint;

end;

procedure TFColoc2D.CBCh1BlueClick(Sender: TObject);
begin
 MaskRGBandIntensity(CH1,ImViewLayerCH1.Bitmap,CBCh1Red.Checked,CBCh1Green.Checked,CBCh1Blue.Checked,
                              UDMinIntensityCh1.Position,UDMaxIntensityCh1.Position);

 ImViewLayerCH1.Repaint;

end;

procedure TFColoc2D.CbCh2RedClick(Sender: TObject);
begin
 MaskRGBandIntensity(CH2,ImViewLayerCH2.Bitmap,CBCh2Red.Checked,CBCh2Green.Checked,CBCh2Blue.Checked,
                      UDMinIntensityCh2.Position,UDMaxIntensityCh2.Position);
 ImViewLayerCH2.Repaint;

end;

procedure TFColoc2D.CBCh2GreenClick(Sender: TObject);
begin
 MaskRGBandIntensity(CH2,ImViewLayerCH2.Bitmap,CBCh2Red.Checked,CBCh2Green.Checked,CBCh2Blue.Checked,
                      UDMinIntensityCh2.Position,UDMaxIntensityCh2.Position);
 ImViewLayerCH2.Repaint;

end;

procedure TFColoc2D.CBCh2BlueClick(Sender: TObject);
begin
 MaskRGBandIntensity(CH2,ImViewLayerCH2.Bitmap,CBCh2Red.Checked,CBCh2Green.Checked,CBCh2Blue.Checked,
                      UDMinIntensityCh2.Position,UDMaxIntensityCh2.Position);
 ImViewLayerCH2.Repaint;

end;

procedure TFColoc2D.BColocClick(Sender: TObject);
 var
  i,j:Integer;
  Rr,R,K1,K2,Mm1,Mm2,M1,M2:Double;
begin

 if not (ImViewLayerCH1.Bitmap = nil) and not (ImViewLayerCH2.Bitmap = nil)
    and not (Length(Ch1)=0) and not (Length(Ch2)=0) then

   begin
    if BMColoc2D=nil then BMColoc2D:=TBitmap32.Create;
    BMColoc2D.SetSize(ImViewLayerCH1.Bitmap.Width,ImViewLayerCH1.Bitmap.Height);
    for i:=0 to BMColoc2D.Height-1 do
     for j:=0 to BMColoc2D.Width-1 do
      BMColoc2D[j,i]:=ColorAdd(ImViewLayerCH1.Bitmap[j,i],ImViewLayerCH2.Bitmap[j,i]);

    if FColoc2DView = nil then FColoc2DView:=TFColoc2DView.Create(Self);
    FColoc2DView.ImColocView.Bitmap.SetSize(BMColoc2D.Width,BMColoc2D.Height);

    BMColoc2D.DrawTo(FColoc2DView.ImColocView.Bitmap);
    PearsonCorrelationCoeficient(Ch1,Ch2,Rr);
    OverlapCoeficient(Ch1,Ch2,R);
    OverlapCoeficientK1(Ch1,Ch2,K1);
    OverlapCoeficientK2(Ch1,Ch2,K2);
    ColocalizationCoeficientsMm1Mm2(Ch1,Ch2,Mm1,Mm2);
    ColocalizationCoeficientsM1M2(Ch1,Ch2,M1,M2,UDMinIntensityCh1.Position,UDMaxIntensityCh1.Position,
                                   UDMinIntensityCh2.Position,UDMaxIntensityCh2.Position);

    with FColoc2DView do
     begin
      EPearsonCoef.Text:=FloatToStrF(Rr,ffGeneral,5,5);
      ECorrCoef.Text:=FloatToStrF(R,ffGeneral,5,5);
      EK1CorrCoef.Text:=FloatToStrF(K1,ffGeneral,5,5);
      EK2CorrCoef.Text:=FloatToStrF(K2,ffGeneral,5,5);
      EColocCoefMm1.Text:=FloatToStrF(Mm1,ffGeneral,5,5);
      EColocCoefMm2.Text:=FloatToStrF(Mm2,ffGeneral,5,5);
      EColocCoefM1.Text:=FloatToStrF(M1,ffGeneral,5,5);
      EColocCoefM2.Text:=FloatToStrF(M2,ffGeneral,5,5);
     end;

    FColoc2DView.Show;

   end;


end;

procedure TFColoc2D.UDMinIntensityCh1Click(Sender: TObject;
  Button: TUDBtnType);
begin
if UDMinIntensityCh1.Position < UDMaxIntensityCh1.Position then
 begin
  MaskRGBandIntensity(CH1,ImViewLayerCH1.Bitmap,CBCh1Red.Checked,CBCh1Green.Checked,CBCh1Blue.Checked,
                              UDMinIntensityCh1.Position,UDMaxIntensityCh1.Position);

  ImViewLayerCH1.Repaint;
 end
 else
  begin
   UDMinIntensityCh1.Position:=UDMaxIntensityCh1.Position-1;
   MaskRGBandIntensity(CH1,ImViewLayerCH1.Bitmap,CBCh1Red.Checked,CBCh1Green.Checked,CBCh1Blue.Checked,
                              UDMinIntensityCh1.Position,UDMaxIntensityCh1.Position);

   ImViewLayerCH1.Repaint;
  end;

end;

procedure TFColoc2D.UDMaxIntensityCh1Click(Sender: TObject;
  Button: TUDBtnType);
begin
if UDMaxIntensityCh1.Position > UDMinIntensityCh1.Position then
 begin
  MaskRGBandIntensity(CH1,ImViewLayerCH1.Bitmap,CBCh1Red.Checked,CBCh1Green.Checked,CBCh1Blue.Checked,
                              UDMinIntensityCh1.Position,UDMaxIntensityCh1.Position);

  ImViewLayerCH1.Repaint;
 end
 else
  begin
   UDMaxIntensityCh1.Position:=UDMinIntensityCh1.Position+1;
   MaskRGBandIntensity(CH1,ImViewLayerCH1.Bitmap,CBCh1Red.Checked,CBCh1Green.Checked,CBCh1Blue.Checked,
                              UDMinIntensityCh1.Position,UDMaxIntensityCh1.Position);

   ImViewLayerCH1.Repaint;
  end;

end;

procedure TFColoc2D.UDMinIntensityCh2Click(Sender: TObject;
  Button: TUDBtnType);
begin

if UDMinIntensityCh2.Position < UDMaxIntensityCh2.Position then
 begin
  MaskRGBandIntensity(CH2,ImViewLayerCH2.Bitmap,CBCh2Red.Checked,CBCh2Green.Checked,CBCh2Blue.Checked,
                      UDMinIntensityCh2.Position,UDMaxIntensityCh2.Position);
  ImViewLayerCH2.Repaint;
 end
else
 begin
  UDMinIntensityCh2.Position:= UDMaxIntensityCh2.Position-1;
  MaskRGBandIntensity(CH2,ImViewLayerCH2.Bitmap,CBCh2Red.Checked,CBCh2Green.Checked,CBCh2Blue.Checked,
                      UDMinIntensityCh2.Position,UDMaxIntensityCh2.Position);
  ImViewLayerCH2.Repaint;
 end;

end;

procedure TFColoc2D.UDMaxIntensityCh2Click(Sender: TObject;
  Button: TUDBtnType);
begin

if UDMaxIntensityCh2.Position > UDMinIntensityCh2.Position then
 begin
  MaskRGBandIntensity(CH2,ImViewLayerCH2.Bitmap,CBCh2Red.Checked,CBCh2Green.Checked,CBCh2Blue.Checked,
                      UDMinIntensityCh2.Position,UDMaxIntensityCh2.Position);
  ImViewLayerCH2.Repaint;
 end
else
 begin
  UDMaxIntensityCh2.Position:= UDMinIntensityCh2.Position+1;
  MaskRGBandIntensity(CH2,ImViewLayerCH2.Bitmap,CBCh2Red.Checked,CBCh2Green.Checked,CBCh2Blue.Checked,
                      UDMinIntensityCh2.Position,UDMaxIntensityCh2.Position);
  ImViewLayerCH2.Repaint;
 end;

end;

procedure TFColoc2D.MEMinIntensityCh1KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
if Key = VK_RETURN then
 begin
  UDMinIntensityCh1.Position:=StrToInt(MEMinIntensityCh1.Text);
  if UDMinIntensityCh1.Position < UDMaxIntensityCh1.Position then
  begin
  MaskRGBandIntensity(CH1,ImViewLayerCH1.Bitmap,CBCh1Red.Checked,CBCh1Green.Checked,CBCh1Blue.Checked,
                              UDMinIntensityCh1.Position,UDMaxIntensityCh1.Position);

  ImViewLayerCH1.Repaint;
 end
 else
  begin
   UDMinIntensityCh1.Position:=UDMaxIntensityCh1.Position-1;
   MaskRGBandIntensity(CH1,ImViewLayerCH1.Bitmap,CBCh1Red.Checked,CBCh1Green.Checked,CBCh1Blue.Checked,
                              UDMinIntensityCh1.Position,UDMaxIntensityCh1.Position);
   ImViewLayerCH1.Repaint;
  end;
MEMinIntensityCh1.Text:=IntToStr(UDMinIntensityCh1.Position);

end

end;

procedure TFColoc2D.MEMaxIntensityCh1KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
if key = VK_RETURN then
begin
 UDMaxIntensityCh1.Position:= StrToInt(MEMaxIntensityCh1.Text);

 if UDMaxIntensityCh1.Position > UDMinIntensityCh1.Position then
  begin
   MaskRGBandIntensity(CH1,ImViewLayerCH1.Bitmap,CBCh1Red.Checked,CBCh1Green.Checked,CBCh1Blue.Checked,
                              UDMinIntensityCh1.Position,UDMaxIntensityCh1.Position);

  ImViewLayerCH1.Repaint;
 end
 else
  begin
   UDMaxIntensityCh1.Position:=UDMinIntensityCh1.Position+1;
   MaskRGBandIntensity(CH1,ImViewLayerCH1.Bitmap,CBCh1Red.Checked,CBCh1Green.Checked,CBCh1Blue.Checked,
                              UDMinIntensityCh1.Position,UDMaxIntensityCh1.Position);

   ImViewLayerCH1.Repaint;
  end;
 MEMaxIntensityCh1.Text:=IntToStr(UDMaxIntensityCh1.Position);
end
end;

procedure TFColoc2D.MEMinIntensityCh2KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
if key= VK_RETURN then
 begin
 UDMinIntensityCh2.Position:=StrToInt(MEMinIntensityCh2.Text);

if UDMinIntensityCh2.Position < UDMaxIntensityCh2.Position then
 begin
  MaskRGBandIntensity(CH2,ImViewLayerCH2.Bitmap,CBCh2Red.Checked,CBCh2Green.Checked,CBCh2Blue.Checked,
                      UDMinIntensityCh2.Position,UDMaxIntensityCh2.Position);
  ImViewLayerCH2.Repaint;
 end
else
 begin
  UDMinIntensityCh2.Position:= UDMaxIntensityCh2.Position-1;
  MaskRGBandIntensity(CH2,ImViewLayerCH2.Bitmap,CBCh2Red.Checked,CBCh2Green.Checked,CBCh2Blue.Checked,
                      UDMinIntensityCh2.Position,UDMaxIntensityCh2.Position);
  ImViewLayerCH2.Repaint;
 end;
MEMinIntensityCh2.Text:=IntToStr(UDMinIntensityCh2.Position);

 end
end;

procedure TFColoc2D.MEMaxIntensityCh2KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
if Key= VK_RETURN then
begin
UDMaxIntensityCh2.Position:=StrToInt(MEMaxIntensityCh2.Text);
if UDMaxIntensityCh2.Position > UDMinIntensityCh2.Position then
 begin
  MaskRGBandIntensity(CH2,ImViewLayerCH2.Bitmap,CBCh2Red.Checked,CBCh2Green.Checked,CBCh2Blue.Checked,
                      UDMinIntensityCh2.Position,UDMaxIntensityCh2.Position);
  ImViewLayerCH2.Repaint;
 end
else
 begin
  UDMaxIntensityCh2.Position:= UDMinIntensityCh2.Position+1;
  MaskRGBandIntensity(CH2,ImViewLayerCH2.Bitmap,CBCh2Red.Checked,CBCh2Green.Checked,CBCh2Blue.Checked,
                      UDMinIntensityCh2.Position,UDMaxIntensityCh2.Position);
  ImViewLayerCH2.Repaint;
 end;
MEMaxIntensityCh2.Text:=IntToStr(UDMaxIntensityCh2.Position);
end

end;

procedure TFColoc2D.UDMinIntensityCh1ChangingEx(Sender: TObject;
  var AllowChange: Boolean; NewValue: Smallint;
  Direction: TUpDownDirection);
begin
 if NewValue < UDMaxIntensityCh1.Position then AllowChange:=True
  else AllowChange:=False;
end;

procedure TFColoc2D.UDMaxIntensityCh1ChangingEx(Sender: TObject;
  var AllowChange: Boolean; NewValue: Smallint;
  Direction: TUpDownDirection);
begin
if NewValue > UDMinIntensityCh1.Position then AllowChange:=True
 else AllowChange:=False;

end;

procedure TFColoc2D.UDMinIntensityCh2ChangingEx(Sender: TObject;
  var AllowChange: Boolean; NewValue: Smallint;
  Direction: TUpDownDirection);
begin
if NewValue < UDMaxIntensityCh2.Position then AllowChange:=True
else AllowChange:=False;

end;

procedure TFColoc2D.UDMaxIntensityCh2ChangingEx(Sender: TObject;
  var AllowChange: Boolean; NewValue: Smallint;
  Direction: TUpDownDirection);
begin
if NewValue > UDMinIntensityCh2.Position then AllowChange:=True
else AllowChange:=False;

end;

end.
