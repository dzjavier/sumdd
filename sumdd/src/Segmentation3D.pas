unit Segmentation3D;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GR32_Image, ExtCtrls, TeeProcs, TeEngine, Chart, Series,DecTypes,
  ComCtrls, StdCtrls, Buttons,
  GR32,
  GR32_Layers,
  DeconvAlgorithms,
  math;

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
    LGlobalSNR: TLabel;
    EGlobalSNR: TEdit;
    LROISNR: TLabel;
    ESNRROI: TEdit;
    ECNR: TEdit;
    LCNR: TLabel;
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
    procedure IVSeriesMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
    procedure IVSeriesMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
  private

    { Private declarations }
  public
    HistPoints: TPointSeries;
    HistSeries: TLineSeries; // Histograma
    Data: TRawData;
    SignalCube,NoiseCube:TVector;
    XIni,YIni,ZIni:Integer;
    XEnd,YEnd,ZEnd:Integer;

    SignalLayer,NoiseLayer:TBitmapLayer;
    ContrastROISignal,MeanROISignal,StdROINoise:Real;

    { Public declarations }
  end;


var

SegBG : array [0..255] of Double; // Vector de puntos seleccionados en el Histograma que considero que son Background
SegSig: array [0..255] of Double; // // Vector de puntos seleccionados en el Histograma que considero que son Señal
  //FSegmentation3D: TFSegmentation3D;
Scl:Real;
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
  Scl:=StrToFloat(EScale.text);
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
 ESNRROI.Text:='';
 ECNR.Text:='';
 if not (SignalLayer = nil) then
  begin
   SignalLayer.Destroy;
   SignalLayer:=nil;
  end;
 if not (NoiseLayer = nil) then
  begin
   NoiseLayer.Destroy;
   NoiseLayer:=nil;
  end;
 IVSeries.Layers.Clear;
 SignalCube:=nil;
 NoiseCube:=nil;
 StdROINoise:=0;
 MeanROISignal:=0;
 ContrastROISignal:=0;
end;

procedure TFSegmentation3D.EScaleChange(Sender: TObject);
begin
 try
  IVSeries.Scale:=StrToFloat(EScale.Text);
  Scl:=StrToFloat(EScale.Text);
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

procedure TFSegmentation3D.IVSeriesMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer;
  Layer: TCustomLayer);
begin
  XIni:=trunc(X/scl);
  YIni:=trunc(Y/scl);
  ZIni:=TBImageSeries.Min;
end;

procedure TFSegmentation3D.IVSeriesMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer;
  Layer: TCustomLayer);
var
i,j,k,c,Dim:Integer;
PlaceRect:TRect;
BM:TBitmap32;
maxInt,minInt:Real;

begin
 BM:=TBitmap32.Create;
 XEnd:=trunc(X/Scl);
 YEnd:=trunc(Y/Scl);
 ZEnd:=TBImageSeries.Max;
 BM.Width:=abs(XEnd-XIni);
 BM.Height:=abs(YEnd-YIni);

 Dim:=abs(XEnd-XIni)*abs(YEnd-YIni)*Length(Data);
 c:=0;
 If CBFluorescence.Checked then
  begin
   try
    SetLength(SignalCube,Dim);
    for k:=Low(Data) to High(Data) do
     for j:=XIni to XEnd-1 do
      for i:=YIni to YEnd-1 do
       begin
        SignalCube[c]:=Data[k].Value[j,i];
        inc(c,1);
       end;
    finally
    SetLength(SignalCube,Dim);
    MeanROISignal:=Mean(SignalCube);
    maxInt:=MaxValue(SignalCube);
    minInt:=MinValue(SignalCube);
    ContrastROISignal:=(maxInt-minInt);
    end;


   BM.Clear(Color32(0,200,0,75));
   if SignalLayer=nil then SignalLayer:=TBitmapLayer.Create(IVSeries.Layers);
   SignalLayer.Bitmap.Assign(BM);
   SignalLayer.Scaled:=True;
   SignalLayer.Bitmap.DrawMode:=dmBlend;
   if XIni<=XEnd then
    begin
     PlaceRect.Left:=trunc(XIni);
     PlaceRect.Right:=trunc(XEnd);
    end
   else
    begin
     PlaceRect.Left:=trunc(XEnd);
     PlaceRect.Right:=trunc(XIni);
    end;
   if YIni<=YEnd then
    begin
     PlaceRect.Top:=trunc(YIni);
     PlaceRect.Bottom:=trunc(YEnd);
    end
   else
    begin
     PlaceRect.Top:=trunc(YEnd);
     PlaceRect.Bottom:=trunc(YIni);
    end;
   SignalLayer.Location:=FloatRect(PlaceRect);
   SignalLayer.Cropped:=True;
  end; //Signal

 If CBBackground.Checked then
  begin
   try
    SetLength(NoiseCube,Dim);
    for k:=Low(Data) to High(Data) do
     for j:=XIni to XEnd-1 do
      for i:=YIni to YEnd-1 do
       begin
        NoiseCube[c]:=Data[k].Value[j,k];
        inc(c,1);
       end;
    finally
     StdROINoise:=StdDev(NoiseCube);
    end;
   BM.Clear(Color32(150,50,75,75));
   if NoiseLayer=nil then NoiseLayer:=TBitmapLayer.Create(IVSeries.Layers);
   NoiseLayer.Bitmap.Assign(BM);
   NoiseLayer.Scaled:=True;
   NoiseLayer.Bitmap.DrawMode:=dmBlend;
   if XIni<=XEnd then
    begin
     PlaceRect.Left:=trunc(XIni);
     PlaceRect.Right:=trunc(XEnd);
    end
   else
    begin
     PlaceRect.Left:=trunc(XEnd);
     PlaceRect.Right:=trunc(XIni);
    end;
   if YIni<=YEnd then
    begin
     PlaceRect.Top:=trunc(YIni);
     PlaceRect.Bottom:=trunc(YEnd);
    end
   else
    begin
     PlaceRect.Top:=trunc(YEnd);
     PlaceRect.Bottom:=trunc(YIni);
    end;
   NoiseLayer.Location:=FloatRect(PlaceRect);
   NoiseLayer.Cropped:=True;

 end;
  if not(SignalCube=nil) and not(NoiseCube=nil) then
   begin
    ESNRROI.Text:=FormatFloat('0.00',20*log10(MeanROISignal/StdROINoise));
    ECNR.Text:=FormatFloat('0.00',20*log10(ContrastROISignal/StdROINoise));
   end;

BM.Free;
end;

end.
