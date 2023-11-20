unit Segmentation3D;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GR32_Image, ExtCtrls, TeeProcs, TeEngine, Chart, Series,DecTypes,
  ComCtrls, StdCtrls, Buttons,
  GR32,
  GR32_Layers;

type
  TFSegmentation3D = class(TForm)
    IVSeries: TImgView32;
    ChHist: TChart;
    Panel1: TPanel;
    TBImageSeries: TTrackBar;
    Label1: TLabel;
    CBBackground: TCheckBox;
    CBFluorescence: TCheckBox;
    BBClearPoints: TBitBtn;
    LRFB: TLabel;
    ERFB: TEdit;
    LScale: TLabel;
    EScale: TEdit;
    EIntensity: TEdit;
    Label2: TLabel;
    procedure TBImageSeriesChange(Sender: TObject);
    procedure ChHistClickSeries(Sender: TCustomChart; Series: TChartSeries;
      ValueIndex: Integer; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure CBBackgroundClick(Sender: TObject);
    procedure CBFluorescenceClick(Sender: TObject);
    procedure BBClearPointsClick(Sender: TObject);
    procedure EScaleChange(Sender: TObject);
    procedure IVSeriesMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer; Layer: TCustomLayer);
  private

    { Private declarations }
  public
    HistPoints: TPointSeries;
    HistSeries:TLineSeries;
    Data: TRawData;

    { Public declarations }
  end;


var

SegBG : array [0..255] of Double; // Vector de puntos seleccionados en el Histograma que considero que son Background
SegSig: array [0..255] of Double; // // Vector de puntos seleccionados en el Histograma que considero que son Señal
  //FSegmentation3D: TFSegmentation3D;

implementation

uses StdConvs;

{$R *.dfm}

procedure TFSegmentation3D.TBImageSeriesChange(Sender: TObject);

var
 j,i,index:integer;
begin

IVSeries.Bitmap.Assign(Data[TBImageSeries.Position]);
 With IVSeries.Bitmap do
  begin
   for j:=0 to Width do
    for i:=0 to Height do
     begin
      Index:=Intensity(PixelS[j,i]);
      if SegSig[Index]<> 0 then
       PixelS[j,i]:=Color32(0,255,0);
      if SegBG[Index] <> 0 then
       PixelS[j,i]:=Color32(255,0,0);
     end;
  end;


end;

procedure TFSegmentation3D.ChHistClickSeries(Sender: TCustomChart;
  Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
 j:Integer;
 Signal,BackGround:double;
begin
if Series is TLineSeries then
 begin
  if CBBackground.Checked then
   begin
    if SegBG[ValueIndex] = Series.GetMarkValue(ValueIndex) then
     begin
      for j:=0 to HistPoints.Count-1 do
       if HistPoints.GetMarkValue(j)= SegBG[ValueIndex] then
        begin
         HistPoints.Delete(j);
         Break;
        end;
        SegBG[ValueIndex]:=0;
     end
    else
     begin
      HistPoints.AddXY(ValueIndex,Series.GetMarkValue(ValueIndex),'',clRed);
      SegBG[ValueIndex]:=Series.GetMarkValue(ValueIndex);
     end;
   end
  else
   begin
    if SegSig[ValueIndex] = Series.GetMarkValue(ValueIndex) then
     begin
      for j:=0 to HistPoints.Count-1 do
       if HistPoints.GetMarkValue(j)= SegSig[ValueIndex] then
        begin
         HistPoints.Delete(j);
         Break;
        end;
        SegSig[ValueIndex]:=0;
     end
    else
     begin
      HistPoints.AddXY(ValueIndex,Series.GetMarkValue(ValueIndex),'', clLime);
      SegSig[ValueIndex]:=Series.GetMarkValue(ValueIndex);
     end;
   end;
 end;

 Signal:=0;
 Background:=0;
 for j:=0 to 255 do
  begin
   Signal:= Signal + j*SegSig[j];
   BackGround:= BackGround+ j*SegBG[j];
  end;

 try
   ERFB.Text := FloatToStr(Signal/Background);
 except
  on EZeroDivide do ERFB.Text:='NaN';
 end;

 TBImageSeriesChange(self);
 end;

procedure TFSegmentation3D.FormCreate(Sender: TObject);
 begin
  HistPoints:=TPointSeries.Create(Self);
  HistPoints.ParentChart:=ChHist;
  HistSeries:=TLineSeries.Create(self);
  HistSeries.ParentChart:=ChHist;
  HistPoints.Marks.Visible:=True;
  HistPoints.Marks.Transparent:=True;
  HistPoints.Marks.Style:=smsXValue;
 end;

procedure TFSegmentation3D.CBBackgroundClick(Sender: TObject);
begin
  if CBBackground.Checked then
 begin
  CBBackground.Checked:=True;
  CBFluorescence.Checked:=False;
 end
else
 begin
  CBBackground.Checked:=False;
  CBFluorescence.Checked:=True;
 end;
end;

procedure TFSegmentation3D.CBFluorescenceClick(Sender: TObject);
begin
   if CBFluorescence.Checked then
 begin
  CBFluorescence.Checked:=True;
  CBBackground.Checked:=False;
  end
else
 begin
   CBFluorescence.Checked:=False;
   CBBackground.Checked:=True;
 end;
end;

procedure TFSegmentation3D.BBClearPointsClick(Sender: TObject);
begin
 HistPoints.Clear;
 ZeroMemory(@SegBG,Length(SegBG)*SizeOf(Double));
 ZeroMemory(@SegSig,Length(SegBG)*SizeOf(Double));
 TBImageSeriesChange(self);
 ERFB.Text:='NaN';
end;

procedure TFSegmentation3D.EScaleChange(Sender: TObject);
begin
 try
  IVSeries.Scale:=StrToFloat(EScale.Text);
 except on E: EConvertError do
  begin
   MessageDlg('No es un número',mtError, [mbOk], 0);
   IVSeries.Scale:=0.5;
   EScale.Text:='0.5';
  end;
 end;
end;

procedure TFSegmentation3D.IVSeriesMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
begin
 EIntensity.Text:=inttostr(Intensity(IVSeries.Bitmap.PixelS[Trunc(X/StrToFloat(EScale.Text)),Trunc(Y/StrToFloat(EScale.Text))]));
end;

end.
