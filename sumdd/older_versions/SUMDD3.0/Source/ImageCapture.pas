unit ImageCapture;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Menus, GR32,GR32_Image, StdCtrls, Buttons, ComCtrls,
  Sectioner,Qt,GR32_Layers, ExtDlgs,
  CpuCycles,
  Bmp2Tiff,
  cPalette,
  jpeg;
type
  TFImage = class(TForm)
    MainMenu1: TMainMenu;
    PCamera: TPanel;
    IMMFile: TMenuItem;
    IMMFClose: TMenuItem;
    ETime: TEdit;
    Label1: TLabel;
    CBDarkFrame: TCheckBox;
    CBFlatFrame: TCheckBox;
    LMean: TLabel;
    EMean: TEdit;
    UDMean: TUpDown;
    BBExpose: TBitBtn;
    PCameraTitle: TPanel;
    PStage: TPanel;
    PStageTitle: TPanel;
    BMoveUp: TButton;
    BMoveDown: TButton;
    CBSpeed: TComboBox;
    LSpeed: TLabel;
    EXDim: TEdit;
    LXDim: TLabel;
    EYDim: TEdit;
    LYDim: TLabel;
    CBDeltaZ: TComboBox;
    LDeltaZ: TLabel;
    PData: TPanel;
    ECoord: TEdit;
    Label2: TLabel;
    LIntensity: TLabel;
    EIntensity: TEdit;
    Panel1: TPanel;
    LObjective: TLabel;
    CBObjective: TComboBox;
    EScale: TEdit;
    LScale: TLabel;
    BUpDate: TButton;
    ImageCap: TImgView32;
    IMMFSaveAs: TMenuItem;
    SaveDialog1: TSaveDialog;
    BFocus: TButton;
    LMaxIntensity: TLabel;
    LMinIntensity: TLabel;
    procedure IMMFCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BMoveUpClick(Sender: TObject);
    procedure BMoveDownClick(Sender: TObject);
    procedure BBExposeClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure GetCamera( Cam:TAM4Control);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ImageCapMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer; Layer: TCustomLayer);
    procedure BUpDateClick(Sender: TObject);
    procedure IMMFSaveAsClick(Sender: TObject);
    procedure ETimeKeyPress(Sender: TObject; var Key: Char);
    procedure EMeanKeyPress(Sender: TObject; var Key: Char);
    procedure EXDimKeyPress(Sender: TObject; var Key: Char);
    procedure EYDimKeyPress(Sender: TObject; var Key: Char);
    procedure CBDeltaZKeyPress(Sender: TObject; var Key: Char);
    procedure CBSpeedKeyPress(Sender: TObject; var Key: Char);
    procedure CBObjectiveKeyPress(Sender: TObject; var Key: Char);
    procedure EScaleKeyPress(Sender: TObject; var Key: Char);
    procedure SBFocusClick(Sender: TObject);
    procedure BFocusClick(Sender: TObject);

  private
    { Private declarations }
  public
    CamControl:TAM4Control;
    SControl:TStageControl;
       { Public declarations }
  end;


var
 //  FImage: TFImage;
// CamControl:TAM4Control;
// SControl:TStageControl;

 FScale:single;
 DeltaZ,MT:Single; // Magnificación Total
 Speed,Mean,XDim,YDim:Integer;
 Texposition:Double;
implementation


{$R *.dfm}

procedure TFImage.IMMFCloseClick(Sender: TObject);
begin
close;
end;

procedure TFImage.FormCreate(Sender: TObject);
var
i,j:integer;

begin
//SControl:=TStageControl.Create;
LMaxIntensity.Caption:='Intensidad Máxima: ';
LMinIntensity.Caption:='Intensidad Mínima: '; 
ImageCap.ScaleMode:=smScale;
FScale:=ImageCap.Scale;
case CBObjective.ItemIndex of
 0: MT:= 4 *0.5;
 1: MT:= 10 *0.5;
 2: MT:= 20 *0.5;
 3: MT:= 40 *0.5;
 4: MT:= 100 *0.5;
end;

BMoveUp.Hint:= ' Mueva la platina presionando'+ #13 +
               ' CONTROL+Cursor Arriba ';
BMoveDown.Hint:= ' Mueva la platina presionando'+ #13 +
                 ' CONTROL+Cursor Abajo';

DeltaZ:= StrToFloat(CBDeltaZ.Text);
Speed:= StrToInt(CBSpeed.Text);
Mean:= StrToInt(EMean.Text);
XDim:= StrToInt(EXDim.Text);
YDim:= StrToInt(EXDim.Text);
TExposition:= StrToFloat(ETime.Text);


// generación de una imagen para pruebas

ImageCap.Bitmap.SetSize(256,256);
for i:= 0 to 255 do
 for j:=0 to 255 do
  ImageCap.Bitmap.PixelS[j,i]:=Gray32(j);

 LMaxIntensity.Caption:='Intensidad Máxima: '+IntToStr(255);
 LMinIntensity.Caption:='Intensidad Mínima: '+IntToStr(0);
end;

procedure TFImage.BMoveUpClick(Sender: TObject);
 var
 Cycles:Real;
 i:integer;
 T:Double;
 begin
  Cycles:=50*StrToFloat(CBDeltaZ.Text);
  T:=1000000*0.005/StrToFloat(CBSpeed.Text);
  for i:=1 to trunc(Cycles) do SControl.MoveUp(T);
 end;

procedure TFImage.BMoveDownClick(Sender: TObject);
 var
 Cycles:Real;
 i:integer;
 T:Double;
 begin
  Cycles:=50*StrToFloat(CBDeltaZ.Text);
  T:=1000000*0.005/StrToFloat(CBSpeed.Text);
  for i:=1 to trunc(Cycles) do SControl.MoveDown(T);
 end;

procedure TFImage.BBExposeClick(Sender: TObject);

var
 Mean,XDim,YDim:Integer;
 TimeEx:Double;
begin
 BBExpose.Enabled:=False;
 try
   TimeEx:=StrToFloat(ETime.Text);
 except
    on E: EConvertError do
     begin
      MessageDlg('Error de Conversión',mtError, [mbOk], 0);
      ETime.Enabled:=True;
      EMean.Enabled:=True;
      EXDim.Enabled:=True;
      EYDim.Enabled:=True;
      CBDeltaZ.Enabled:=True;
      CBSpeed.Enabled:=True;
      BBExpose.Enabled:=True;
      exit;
     end
 end;
 try
  XDim:=StrtoInt(EXDim.Text);
 except
    on E: EConvertError do
     begin
      MessageDlg('Error de Conversión',mtError, [mbOk],0);
      ETime.Enabled:=True;
      EMean.Enabled:=True;
      EXDim.Enabled:=True;
      EYDim.Enabled:=True;
      CBDeltaZ.Enabled:=True;
      CBSpeed.Enabled:=True;
      BBExpose.Enabled:=True;
      exit;
     end
 end;
 try
   YDim:=StrToInt(EYDim.Text);
 except
    on E: EConvertError do
     begin
      MessageDlg('Error de Conversión',mtError, [mbOk],0);
      ETime.Enabled:=True;
      EMean.Enabled:=True;
      EXDim.Enabled:=True;
      EYDim.Enabled:=True;
      CBDeltaZ.Enabled:=True;
      CBSpeed.Enabled:=True;
      BBExpose.Enabled:=True;
      exit;
     end
 end;
 try
   Mean:=StrToInt(EMean.Text);
 except
    on E: EConvertError do
     begin
      MessageDlg('Error de Conversión',mtError, [mbOk],0);
      ETime.Enabled:=True;
      EMean.Enabled:=True;
      EXDim.Enabled:=True;
      EYDim.Enabled:=True;
      CBDeltaZ.Enabled:=True;
      CBSpeed.Enabled:=True;
      BBExpose.Enabled:=True;
      exit;
     end
 end;

 ImageCap.Scale:=FScale;
 ImageCap.Bitmap.Clear(Color32(0,0,255,0));
 ImageCap.Bitmap.SetSize(XDim,YDim);
 CamControl.GetImage(ImageCap.Bitmap,CBDarkFrame.Checked,False,Mean,XDim,YDim,TimeEx);
 LMaxIntensity.Caption:='Intensidad Máxima: '+IntToStr(CamControl.MaxIntensity);
 LMinIntensity.Caption:='Intensidad Mínima: '+IntToStr(CamControl.MinIntensity);
 BBExpose.Enabled:=True;
end;

procedure TFImage.FormKeyPress(Sender: TObject; var Key: Char);

begin

if CamControl=nil then exit;

if Key ='e' then
 begin
   ETime.Enabled:=False;
   EMean.Enabled:=False;
   EXDim.Enabled:=False;
   EYDim.Enabled:=False;
   CBDeltaZ.Enabled:=False;
   CBSpeed.Enabled:=False;
   BBExpose.Enabled:=False;

   try
    TExposition:=StrToFloat(ETime.Text);
   except
    on E: EConvertError do
     begin
      MessageDlg('Error de Conversión',mtError, [mbOk], 0);
      ETime.Enabled:=True;
      ETime.SelectAll;
      EMean.Enabled:=True;
      EXDim.Enabled:=True;
      EYDim.Enabled:=True;
      CBDeltaZ.Enabled:=True;
      CBSpeed.Enabled:=True;
      BBExpose.Enabled:=True;
      exit;
     end
   end;
   try
    XDim:=StrtoInt(EXDim.Text);
   except
    on E: EConvertError do
     begin
      MessageDlg('Error de Conversión',mtError, [mbOk],0);
      ETime.Enabled:=True;
      EMean.Enabled:=True;
      EXDim.Enabled:=True;
      EXDim.SelectAll;
      EYDim.Enabled:=True;
      CBDeltaZ.Enabled:=True;
      CBSpeed.Enabled:=True;
      BBExpose.Enabled:=True;
      exit;
     end
   end;
   try
    YDim:=StrToInt(EYDim.Text);
   except
    on E: EConvertError do
     begin
      MessageDlg('Error de Conversión',mtError, [mbOk],0);
      ETime.Enabled:=True;
      EMean.Enabled:=True;
      EXDim.Enabled:=True;
      EYDim.Enabled:=True;
      EYDim.SelectAll;
      CBDeltaZ.Enabled:=True;
      CBSpeed.Enabled:=True;
      BBExpose.Enabled:=True;
      exit;
     end
   end;
   try
    Mean:=StrToInt(EMean.Text);
   except
    on E: EConvertError do
     begin
      MessageDlg('Error de Conversión',mtError, [mbOk],0);
      ETime.Enabled:=True;
      EMean.Enabled:=True;
      EMean.SelectAll;
      EXDim.Enabled:=True;
      EYDim.Enabled:=True;
      CBDeltaZ.Enabled:=True;
      CBSpeed.Enabled:=True;
      BBExpose.Enabled:=True;
      exit;
     end
   end;

  ImageCap.Scale:=FScale;
  ImageCap.Bitmap.Clear(Color32(0,0,255,0));
  ImageCap.Bitmap.SetSize(XDim,YDim);
  CamControl.GetImage(ImageCap.Bitmap,CBDarkFrame.Checked,False,Mean,XDim,YDim,TExposition);
  LMaxIntensity.Caption:='Intensidad Máxima: '+IntToStr(CamControl.MaxIntensity);
  LMinIntensity.Caption:='Intensidad Mínima: '+IntToStr(CamControl.MinIntensity);

  ETime.Enabled:=True;
  EMean.Enabled:=True;
  EXDim.Enabled:=True;
  EYDim.Enabled:=True;
  CBDeltaZ.Enabled:=True;
  CBSpeed.Enabled:=True;
  BBExpose.Enabled:=True;
  ETime.Text:=FormatFloat('0.0',TExposition);
  EXDim.Text:=IntToStr(XDim);
  EYDim.Text:=IntToStr(YDim);
  EMean.Text:=IntToStr(Mean);
 end;

end;

procedure TFImage.GetCamera( Cam:TAM4Control);
 begin
  CamControl:=Cam;
  If CamControl.IsPresent then  BBExpose.Enabled:=true;
 end;
procedure TFImage.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var

 i:integer;
 T:Double;
begin
 if SControl=nil then exit;

 if (Key=VK_Down) and (Shift=[ssCtrl]) then
   begin
    CBDeltaZ.Enabled:=False;
    CBSpeed.Enabled:=False;
    T:=1000000*0.005/3.1;
    for i:=1 to 50 do SControl.MoveDown(T);
    CBDeltaZ.Enabled:=True;
    CBSpeed.Enabled:=True;
   end;

  if (Key=VK_Up) and (Shift=[ssCtrl]) then
   begin
    CBDeltaZ.Enabled:=False;
    CBSpeed.Enabled:=False;
    T:=1000000*0.005/3.1;
    for i:=1 to 50 do SControl.MoveUp(T);
    CBDeltaZ.Enabled:=True;
    CBSpeed.Enabled:=True;
   end;
end;

procedure TFImage.ImageCapMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer; Layer: TCustomLayer);
begin
 ECoord.Text:= '['+ formatfloat('#.#',9*X/(FScale*MT))+', '+formatfloat('#.#',9*Y/(FScale*MT))+']';
 EIntensity.Text:=inttostr(Intensity(ImageCap.Bitmap.PixelS[Trunc(X/FScale),Trunc(Y/FScale)]));
end;

procedure TFImage.BUpDateClick(Sender: TObject);
begin
 case CBObjective.ItemIndex of
 0: MT:= 4 *0.5;
 1: MT:= 10 *0.5;
 2: MT:= 20 *0.5;
 3: MT:= 40 *0.5;
 4: MT:= 100 *0.5;
end;
 try
  FScale:=StrToFloat(EScale.Text);
 except
    on E: EConvertError do
     begin
      MessageDlg('Error de Conversión',mtError, [mbOk], 0);
      exit;
     end
 end;
 ImageCap.Scale:=FScale;
end;

procedure TFImage.IMMFSaveAsClick(Sender: TObject);
var
 i,j:Integer;
 D1:Int64;
 jpaux:TJPEGImage;
 BM:TBitmap;
 StAux:TMemoryStream;

begin


 if SaveDialog1.Execute then
   begin
    BM:=TBitmap.Create;
    jpaux:=TJPEGImage.Create;
    StAux:=TMemoryStream.Create;

    ImageCap.Bitmap.SaveToStream(StAux);
    StAux.Position:=0;
    BM.LoadFromStream(StAux);
    StAux.Position:=0;
    jpaux.Assign(BM);
    jpaux.SaveToStream(StAux);
    StAux.Position:=0;
    jpaux.Grayscale:=True;
    jpaux.PixelFormat:=jf8bit;
    jpaux.LoadFromStream(StAux);
    StAux.Position:=0;
    BM.Assign(jpaux);

   // BM.Width:=ImageCap.Bitmap.Width;
   // BM.Height:=ImageCap.Bitmap.Height;

   // D1:=GetTickCount;
    {for i:=0 to BM.Height-1 do
     for j:=0 to BM.Width-1 do
      BM.Canvas.Pixels[j,i]:=WinColor(ImageCap.Bitmap.PixelS[j,i]);}

  //   D1:=GetTickCount-D1;

    Writetifftofile(ChangeFileExt(SaveDialog1.FileName,'.tif'),BM);

   // ShowMessage('Tiempo [ms]: ' +IntToStr(D1));

    jpaux.Destroy;
    BM.Destroy;
    StAux.Free;

   end;



end;

procedure TFImage.ETimeKeyPress(Sender: TObject; var Key: Char);
 begin
  if key='e' then key:=#0;
 end;

procedure TFImage.EMeanKeyPress(Sender: TObject; var Key: Char);
 begin
  if key='e' then key:=#0;
 end;

procedure TFImage.EXDimKeyPress(Sender: TObject; var Key: Char);
begin
if key='e' then key:=#0;
end;

procedure TFImage.EYDimKeyPress(Sender: TObject; var Key: Char);
begin
if key='e' then key:=#0;
end;

procedure TFImage.CBDeltaZKeyPress(Sender: TObject; var Key: Char);
begin
if key='e' then key:=#0;
end;

procedure TFImage.CBSpeedKeyPress(Sender: TObject; var Key: Char);
begin
if key='e' then key:=#0;
end;

procedure TFImage.CBObjectiveKeyPress(Sender: TObject; var Key: Char);
begin
if key='e' then key:=#0;
end;

procedure TFImage.EScaleKeyPress(Sender: TObject; var Key: Char);
begin
if key='e' then key:=#0;
end;

procedure TFImage.SBFocusClick(Sender: TObject);
var
 i:integer;
begin

end;

procedure TFImage.BFocusClick(Sender: TObject);
var
 Mean,XDim,YDim:Integer;
 TimeEx:Double;
begin

 BFocus.Enabled:=False;
 try
   TimeEx:=StrToFloat(ETime.Text);
 except
    on E: EConvertError do
     begin
      MessageDlg('Error de Conversión',mtError, [mbOk], 0);
      ETime.Enabled:=True;
      EMean.Enabled:=True;
      EXDim.Enabled:=True;
      EYDim.Enabled:=True;
      CBDeltaZ.Enabled:=True;
      CBSpeed.Enabled:=True;
      BBExpose.Enabled:=True;
      exit;
     end
 end;
 try
  XDim:=StrtoInt(EXDim.Text);
 except
    on E: EConvertError do
     begin
      MessageDlg('Error de Conversión',mtError, [mbOk],0);
      ETime.Enabled:=True;
      EMean.Enabled:=True;
      EXDim.Enabled:=True;
      EYDim.Enabled:=True;
      CBDeltaZ.Enabled:=True;
      CBSpeed.Enabled:=True;
      BBExpose.Enabled:=True;
      exit;
     end
 end;
 try
   YDim:=StrToInt(EYDim.Text);
 except
    on E: EConvertError do
     begin
      MessageDlg('Error de Conversión',mtError, [mbOk],0);
      ETime.Enabled:=True;
      EMean.Enabled:=True;
      EXDim.Enabled:=True;
      EYDim.Enabled:=True;
      CBDeltaZ.Enabled:=True;
      CBSpeed.Enabled:=True;
      BBExpose.Enabled:=True;
      exit;
     end
 end;
 try
   Mean:=StrToInt(EMean.Text);
 except
    on E: EConvertError do
     begin
      MessageDlg('Error de Conversión',mtError, [mbOk],0);
      ETime.Enabled:=True;
      EMean.Enabled:=True;
      EXDim.Enabled:=True;
      EYDim.Enabled:=True;
      CBDeltaZ.Enabled:=True;
      CBSpeed.Enabled:=True;
      BBExpose.Enabled:=True;
      exit;
     end
 end;
 ImageCap.Scale:=FScale;
 ImageCap.Bitmap.Clear(Color32(0,0,255,0));
 ImageCap.Bitmap.SetSize(XDim,YDim);
 CamControl.Focus(StrToFloat(ETime.Text),True,StrtoInt(EXDim.Text),StrtoInt(EYDim.Text),ImageCap);
 BFocus.Enabled:=True;


end;

end.
