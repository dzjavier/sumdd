unit ImageCapture;

interface

uses
  StageControl, CameraControl, Windows, Messages, SysUtils, Variants,
  Classes, Graphics, Controls, Forms, Dialogs, Menus, StdCtrls, Buttons,
  IniFiles, LightMonitor, dglOpengl, ProgressActivity, DecTypes,
  FilesManagement, ComCtrls, ExtCtrls;
type
 TFImage = class(TForm)
    MainMenu1: TMainMenu;
    PCamera: TPanel;
    IMMFile: TMenuItem;
    IMMFClose: TMenuItem;
    ETime: TEdit;
    Label1: TLabel;
    CBDarkFrame: TCheckBox;
    CBDoseControl: TCheckBox;
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
    IMMFSaveAs: TMenuItem;
    SaveDialog1: TSaveDialog;
    LMaxIntensity: TLabel;
    LMinIntensity: TLabel;
    PLightMonitor: TPanel;
    PB: TProgressBar;
    LLightMonitor: TLabel;
    TimerLightMonitor: TTimer;
    LDosis: TLabel;
    procedure IMMFCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BMoveUpClick(Sender: TObject);
    procedure BMoveDownClick(Sender: TObject);
    procedure BBExposeClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure GetCamera( Cam:AM4Camera);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
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

    procedure TimerLightMonitorTimer(Sender: TObject);
    procedure CBObjectiveChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure FormPaint(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

  private
    { Private declarations }
  public

       { Public declarations }
  end;
var
 FScale:single;
 DeltaZ,MT:single; // Magnificación Total
 Speed,Mean:integer;
 XDim,YDim:word;
 Texposition:Double;
 ActualDosis:Double;
 LightSamples: array of double;
 CurrentCapture: TWordArray;
 CurrentDisplay: TFloatArray;

 RC:HGLRC;
 hp:HPalette;
 W:Integer; // Ancho dibujo
 H:Integer; // altura dibujo
 Yini:integer;// Posición inicial viewport
 Xini:integer;// Posición inicial viewport
 ColorBackground: array [1..3] of single ;
implementation

uses Math;


{$R *.dfm}

procedure TFImage.IMMFCloseClick(Sender: TObject);
 begin
  Close;
 end;

procedure TFImage.WMEraseBkgnd(var Message: TWMEraseBkgnd);
 begin
  Message.Result:=1;
end;

procedure TFImage.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 TimerLightMonitor.Enabled:=false;
end;

procedure TFImage.FormCreate(Sender: TObject);
var
 i,j:integer;
begin
if UVMon<>nil then TimerLightMonitor.Enabled:=true
else
begin
 PLightMonitor.Enabled:=false;
 CBDoseControl.Checked:=false;
 CBDoseControl.Enabled:=false;
 TimerLightMonitor.Enabled:=false;
end;
//////////////// initialization variables ///////////////
DeltaZ:=1.0;
Speed:=1;
Mean:=1;
TExposition:=0.1;
XDim:=512;
YDim:=512;
FScale:=0.5;
ColorBackground[1]:=0.4;
ColorBackground[2]:=0.5;
ColorBackground[3]:=0.4;
CBDeltaZ.Text:=FloatToStr(DeltaZ);
CBSpeed.Text:=IntToStr(Speed);
EMean.Text:=IntToStr(Mean);
EXDim.Text:=IntToStr(XDim);
EYDim.Text:=IntToStr(YDim);
EScale.Text:=FloatToStr(FScale);


 // generación de una imagen para pruebas
 i:=0;
 setlength(CurrentCapture,XDim*YDim);
 setlength(CurrentDisplay,XDim*YDim);
 for j:= Low(CurrentCapture) to High(CurrentCapture) do
  begin
   CurrentCapture[j]:= trunc(i/(XDim-1)*16383);
   CurrentDisplay[j]:= CurrentCapture[j]/16383;
   if i<(XDim-1) then
    inc(i)
   else i:=0;
  end;
 W:=Self.Width-(PCamera.Width+10);
 H:=Self.Height-(PData.Height+Panel1.Height+10);
 Yini:= PData.Height+Panel1.Height+10;
// Yini:= 10;
 Xini:=10;
 /////// OpenGL ///////
  try
   InitOpenGL();
   RC:=CreateRenderingContext(Canvas.Handle,[opDoubleBuffered],32,0,0,0,0,hp); //Primero
  finally
   ActivateRenderingContext(Canvas.Handle,RC);
   glClearColor(ColorBackground[1],ColorBackground[2],ColorBackground[3],0.0);
   DeactivateRenderingContext;
//   glViewport(Xini,Yini, W,H);
//   glMatrixMode(GL_PROJECTION);
//   glOrtho(-1.0,1.0,-1.0,1.0,1.0,-1.0);
//   glMatrixMode(GL_MODELVIEW);
//   glLoadIdentity;
//   DeactivateRenderingContext;
  end;
 /////// OpenGL ///////

 LMaxIntensity.Caption:='Intensidad Máxima: ';
 LMinIntensity.Caption:='Intensidad Mínima: ';
// ImageCap.ScaleMode:=smScale;
// FScale:=ImageCap.Scale;
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



 if MaxWordValue(CurrentCapture)>=16383 then
  begin
   LMaxIntensity.Color:=clRed;
   LMaxIntensity.Caption:='Intensidad Máxima: '+IntToStr(MaxWordValue(CurrentCapture));
  end
 else
  begin
     LMaxIntensity.Caption:='Intensidad Máxima: '+IntToStr(MaxWordValue(CurrentCapture));
  end;

end;

procedure TFImage.BMoveUpClick(Sender: TObject);
var
 DZ:single;
 begin
  try
   DZ:=strtofloat(CBDeltaZ.text);
   Stg.MoveUp(DZ);
  except on EConvertError do
   MessageDlg('Error de conversión',mtWarning,[mbOK],0);
  end;
 end;

procedure TFImage.BMoveDownClick(Sender: TObject);
 var
  DZ:single;
 begin
  try
   DZ:=strtofloat(CBDeltaZ.text);
   Stg.MoveDown(DZ);
  except on EConvertError do
   MessageDlg('Error de conversión',mtWarning,[mbOK],0);
  end;
 end;

procedure TFImage.BBExposeClick(Sender: TObject);
var
  j:Integer;
 begin
  BBExpose.Enabled:=False;
 try
  Texposition:=StrToFloat(ETime.Text);
  XDim:=StrtoInt(EXDim.Text);
  YDim:=StrToInt(EYDim.Text);
  Mean:=StrToInt(EMean.Text);
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
 end; // try
 if Mean>1 then Cam.GetImage(CurrentCapture,Mean,XDim,YDim,TExposition)
 else
  begin
  if ((UVMon<>nil) and (not CBDarkFrame.Checked)) then
   begin
    TimerLightMonitor.Enabled:=false;
    Cam.GetImage(CurrentCapture,XDim,YDim,TExposition,CBDarkFrame.Checked);
    ActualDosis:=UVMon.GetDosis;
    LDosis.Caption:= 'Dosis : '+ FloatToStrF(UVMon.GetDosis,ffGeneral ,6,4);
    TimerLightMonitor.Enabled:=true;
   end
   else
     Cam.GetImage(CurrentCapture,XDim,YDim,not(CBDarkFrame.Checked),TExposition);
   end;

  SetLength(CurrentDisplay,XDim*YDim);
  for j := low(CurrentDisplay) to high(CurrentDisplay)do
    CurrentDisplay[j]:=CurrentCapture[j]/16383;

 if MaxWordValue(CurrentCapture)>=16383 then
  begin
   LMaxIntensity.Color:=clRed;
   LMaxIntensity.Caption:='Intensidad Máxima: '+IntToStr(MaxWordValue(CurrentCapture));
  end
 else
  begin
    LMaxIntensity.Color:=clBtnFace;
     LMaxIntensity.Caption:='Intensidad Máxima: '+IntToStr(MaxWordValue(CurrentCapture));
  end;

 Refresh;
 BBExpose.Enabled:=True;
end;

procedure TFImage.FormKeyPress(Sender: TObject; var Key: Char);
begin
 if Key ='e' then  BBExpose.OnClick(Sender);
end;

procedure TFImage.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);

begin
  X:=trunc((X-Xini)/FScale);
  Y:=trunc((self.Height-Y-YIni-47)/FScale);
  //PixelIntensity:=self.Canvas.Pixels[X,Y];
  if ((X>=0) and (X<XDim)) and ((Y>=0)and(Y<YDim)) then
     EIntensity.Text:=inttostr(CurrentCapture[Y*XDim+X])
  else EIntensity.Text:= 'NaN' ;
//  EIntensity.Text:=IntToStr(self.Height)+', '+IntToStr(Y)+', '+inttostr(Yini);
end;

procedure TFImage.FormPaint(Sender: TObject);

begin
 ActivateRenderingContext(Canvas.Handle,RC); // Se asocia el contexto con el
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
  glClearColor(ColorBackground[1],ColorBackground[2],ColorBackground[3],0.0);
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();

  glRasterPos2f(0.0,0.0);
  glPixelZoom(FScale,FScale);
  glDrawPixels(XDim,YDim,GL_LUMINANCE,GL_FLOAT,@CurrentDisplay[0]);


  SwapBuffers(Canvas.Handle); //
  UpdateWindow(Canvas.Handle);
 DeactivateRenderingContext;
end;

procedure TFImage.FormResize(Sender: TObject);
begin
 // W:=Self.Width-(PCamera.Width+20);
 H:=Self.Height-(PData.Height+Panel1.Height+10);
 W:=H;
 ActivateRenderingContext(Canvas.Handle,RC);
  glViewport(Xini,Yini,trunc(XDim*FScale),trunc(YDim*FScale));
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  glOrtho(0.0,XDim,0.0,YDim,1.0,-1.0);
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity;
 DeactivateRenderingContext;
 Refresh; // Redibujar la escena ...
end;

procedure TFImage.GetCamera( Cam:AM4Camera);
 begin
  Cam:=Cam;
  If Cam.IsPresent then  BBExpose.Enabled:=true;
 end;

procedure TFImage.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var

 i:integer;
 T:Double;
begin
 if Stg=nil then exit;

 if (Key=VK_Down) and (Shift=[ssCtrl]) then
   begin
    CBDeltaZ.Enabled:=False;
    CBSpeed.Enabled:=False;
    T:=1000000*0.005/3.1;
    for i:=1 to 50 do Stg.MoveDown(T);
    CBDeltaZ.Enabled:=True;
    CBSpeed.Enabled:=True;
   end;

  if (Key=VK_Up) and (Shift=[ssCtrl]) then
   begin
    CBDeltaZ.Enabled:=False;
    CBSpeed.Enabled:=False;
    T:=1000000*0.005/3.1;
    for i:=1 to 50 do Stg.MoveUp(T);
    CBDeltaZ.Enabled:=True;
    CBSpeed.Enabled:=True;
   end;
end;

procedure TFImage.BUpDateClick(Sender: TObject);
begin
 try
  FScale:=StrToFloat(EScale.Text);
 except
    on E: EConvertError do
     begin
      MessageDlg('Error de Conversión',mtError, [mbOk], 0);
      exit;
     end
 end;
 Refresh;
end;

procedure TFImage.IMMFSaveAsClick(Sender: TObject);
var
 i:Integer;
 LightFile: Textfile;
begin


 if SaveDialog1.Execute then
   begin
//    TiffFiler:=Filer.Create;
    TiffFiler.Save14BitsTIFFFile(ChangeFileExt(SaveDialog1.FileName,'.tif'),MT/9*10000,MT/9*10000,XDim,YDim,CurrentCapture);
//    TiffFiler.Destroy;
//    Writetifftofile(ChangeFileExt(SaveDialog1.FileName+'8bits','.tif'),BM);
    AssignFile(LightFile,ChangeFileExt(SaveDialog1.FileName,'.txt'));
    Rewrite(LightFile);
    Writeln(LightFile,'Dosis: ', FloatToStr(ActualDosis));
    for i:=low(LightSamples) to High(LightSamples) do
      Writeln(LightFile,FloatToStr(LightSamples[i]));
    CloseFile(LightFile);
   // ShowMessage('Tiempo [ms]: ' +IntToStr(D1));
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

procedure TFImage.TimerLightMonitorTimer(Sender: TObject);
 begin
 if UVMon<>nil then
  begin
   LLightMonitor.Caption:= 'Dosis UV (0.5 seg): '+ FloatToStrF(UVMon.getLightLevel,ffGeneral ,6,4);
   //UVMon.SetExpositionTime(0.5);
   PB.Position:=trunc(UVMon.getLightLevel*100);
   //  UVMon.SetLigthRecorderSwitch(true);
  end;
 end;

procedure TFImage.CBObjectiveChange(Sender: TObject);
begin
case CBObjective.ItemIndex of
 0: MT:= 4 *0.5;
 1: MT:= 10 *0.5;
 2: MT:= 20 *0.5;
 3: MT:= 40 *0.5;
 4: MT:= 100 *0.5;
end;
end;

end.
