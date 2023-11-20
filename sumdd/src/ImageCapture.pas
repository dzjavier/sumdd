unit ImageCapture;

interface

uses
  StageControl, CameraControl, Windows, Messages, SysUtils, Variants,
  Classes, Graphics, Controls, Forms, Dialogs, Menus, StdCtrls, Buttons,
  IniFiles, LightMonitor, dglOpengl, ProgressActivity, DecTypes,
  FilesManagement, ComCtrls, ExtCtrls,
  Images;
type
 TFImage = class(TForm)
    MainMenu1: TMainMenu;
    PCamera: TPanel;
    IMMFile: TMenuItem;
    IMMFClose: TMenuItem;
    ETime: TEdit;
    Label1: TLabel;
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
    IMMFSaveAs: TMenuItem;
    SaveDialog1: TSaveDialog;
    LMaxIntensity: TLabel;
    LMinIntensity: TLabel;
    PLightMonitor: TPanel;
    PB: TProgressBar;
    LLightMonitor: TLabel;
    TimerLightMonitor: TTimer;
    LDosis: TLabel;
    CBObjective: TComboBox;
    LObjective: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Lbright: TLabel;
    Lcontrast: TLabel;
    Label6: TLabel;
    Lgammavalue: TLabel;
    UDBright: TUpDown;
    UDContrast: TUpDown;
    UDGamma: TUpDown;
    Button1: TButton;
    CBColorDisplay: TComboBox;
    CBScale: TComboBox;
    LScale: TLabel;
    Label3: TLabel;
    CBCamControl: TComboBox;



    procedure IMMFCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BMoveUpClick(Sender: TObject);
    procedure BMoveDownClick(Sender: TObject);
    procedure BBExposeClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
//    procedure BUpDateClick(Sender: TObject);
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
    procedure CBColorDisplayChange(Sender: TObject);
    procedure CBScaleChange(Sender: TObject);
    procedure UDBrightClick(Sender: TObject; Button: TUDBtnType);
    procedure UDContrastClick(Sender: TObject; Button: TUDBtnType);
    procedure UDGammaClick(Sender: TObject; Button: TUDBtnType);
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);


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

 CurrentImage:MicroscopeDigitalImage;

 //Display var
 RC:HGLRC;
 hp:HPalette;
 W:Integer; // Ancho dibujo
 H:Integer; // altura dibujo
 Yini:integer;// Posición inicial viewport
 Xini:integer;// Posición inicial viewport
 ColorBackground: array [1..3] of single ;
 Xoffset: integer;
 yoffset: integer;
 bright: single;
 contrast: single;
 gamma: single;
implementation

uses Math, JavaApplicationLuncher;


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
 CurrentImage:=MicroscopeDigitalImage.Create;
 PLightMonitor.Enabled:=false;
 //CBDoseControl.Checked:=false;
 //CBDoseControl.Enabled:=false;
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
Xoffset:=0;
Yoffset:=0;
CBDeltaZ.Text:=FloatToStr(DeltaZ);
CBSpeed.Text:=IntToStr(Speed);
EMean.Text:=IntToStr(Mean);
EXDim.Text:=IntToStr(XDim);
EYDim.Text:=IntToStr(YDim);
bright:=0;
LBright.Caption:=FloatToStrF(bright,ffGeneral,2,1);
contrast:=1;
Lcontrast.Caption:=FloatToStrF(contrast,ffGeneral,2,1);
gamma:=1;
Lgammavalue.Caption:=FloatToStrF(gamma,ffGeneral,2,1);
//CurrentMetaData:=SUMDDImageMetadata.Create();
//CurrentMetaData.setString('DimensionOrder','XY');

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
   RC:=CreateRenderingContext(Canvas.Handle,[opDoubleBuffered],32,0,0,0,1,hp); //Primero
  finally
   ActivateRenderingContext(Canvas.Handle,RC);
   glClearColor(ColorBackground[1],ColorBackground[2],ColorBackground[3],0.0);
   DeactivateRenderingContext;
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



 {if MaxWordValue(CurrentCapture)>=16383 then
  begin
   LMaxIntensity.Color:=clRed;
   LMaxIntensity.Caption:='Intensidad Máxima: '+IntToStr(MaxWordValue(CurrentCapture));
  end
 else
  begin
     LMaxIntensity.Caption:='Intensidad Máxima: '+IntToStr(MaxWordValue(CurrentCapture));
  end;
           }
end;

procedure TFImage.FormDestroy(Sender: TObject);
begin
 CurrentImage.Destroy;
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
  x,y:Integer;
 begin
  BBExpose.Enabled:=False;

  Texposition:=StrToFloat(ETime.Text);
  Texposition:=Texposition/1000;

  XDim:=StrtoInt(EXDim.Text);
  YDim:=StrToInt(EYDim.Text);
  Mean:=StrToInt(EMean.Text);


  case CBCamControl.ItemIndex of  //Diferentes modos de captura: Corriente oscura o imagen de muestra, reduciendo ruido por promediado o control de dosis
  0:  //imagen de muestra
    begin
         SetLength(CurrentCapture,XDim*YDim);
       for y:=0 to YDim-1 do
        for x:=0 to XDim-1 do
           begin
            CurrentCapture[y*XDim+x]:= y*XDim+x;
           end;
      end;
   1: //Control de Dosis
     begin
      TimerLightMonitor.Enabled:=false;
      Cam.GetImage(CurrentCapture,XDim,YDim,TExposition,false);
      ActualDosis:=Cam.getImageDose;
      LDosis.Caption:= 'Dosis : '+ FloatToStrF(ActualDosis,ffGeneral ,6,4);
      TimerLightMonitor.Enabled:=true;
     end;
   2: //Corriente oscura
     begin
      Cam.GetDarkCurrentImage(CurrentCapture,XDim,YDim,TExposition);
     end;
   3: //Promediado
     begin
//      Cam.GetImage(CurrentImage,Mean,XDim,YDim,TExposition);
      Cam.getImage(CurrentImage,Mean,XDim,YDim,Texposition,true,false);
      CurrentCapture:=CurrentImage.getImageAsArray;
//      CurrentMetaData.addMetadata(Cam.getContextualMetadata);
     end;
    end;
   
   //Control de saturación
 if MaxWordValue(CurrentCapture)>=16383 then
  begin
   LMaxIntensity.Color:=clRed;
   LMaxIntensity.Caption:='Intensidad Máxima (SATURADO): '+IntToStr(MaxWordValue(CurrentCapture));
  end
 else
  begin
    LMaxIntensity.Color:=clBtnFace;
    LMaxIntensity.Caption:='Intensidad Máxima: '+IntToStr(MaxWordValue(CurrentCapture));
  end;
    LMinIntensity.Caption:='Intensidad Mínima: '+IntToStr(MinWordValue(CurrentCapture));

   //Matriz para graficar
  if (CurrentCapture<>nil) then
   begin
    SetLength(CurrentDisplay,XDim*YDim);
   for j := low(CurrentDisplay) to high(CurrentDisplay)do
     CurrentDisplay[j]:=CurrentCapture[j]/16383;
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
  Y:=trunc((self.Height-Y-YIni-57)/FScale);

  //PixelIntensity:=self.Canvas.Pixels[X,Y];
  if ((X>=0) and (X<XDim)) and ((Y>=0)and(Y<YDim)) then
     begin
     EIntensity.Text:=inttostr(CurrentCapture[Y*XDim+X]);
     ECoord.Text:=FloatToStrF(X*MT*9,ffGeneral ,3,3)+' x '+FloatToStrF(Y*MT*9,ffGeneral ,3,3);
     end

  else
  begin
   EIntensity.Text:= 'NaN' ;
   ECoord.Text:= 'NaN' ;
  end;

end;

procedure TFImage.FormPaint(Sender: TObject);
var
lut,vacio: array of single;
i: integer;

begin

 //PData.SetFocus;

 ActivateRenderingContext(Canvas.Handle,RC);
  glClear(GL_COLOR_BUFFER_BIT);
  //glClearColor(ColorBackground[1],ColorBackground[2],ColorBackground[3],0.0);
  //  glMatrixMode(GL_MODELVIEW);
  //  glLoadIdentity();

  glRasterPos2i(0,0);
  glPixelZoom(FScale,FScale);

  SetLength(lut,65536)  ;
  SetLength(vacio,65536)  ;
  //LUT para corrección de brillo,gama y contraste correction
  for i:=0 to 65535 do
    begin
    lut[i]:=power(contrast*(i+bright*65535),gamma)/65536;
    vacio[i]:=0;
    end;

  glPixelTransferf(GL_MAP_COLOR,GL_TRUE);

  case CBColorDisplay.ItemIndex of
  0:
   begin
   //gamma
   glPixelMapfv(GL_PIXEL_MAP_R_TO_R, 65536, @lut[0]);
   glPixelMapfv(GL_PIXEL_MAP_G_TO_G, 65536, @lut[0]);
   glPixelMapfv(GL_PIXEL_MAP_B_TO_B, 65536, @lut[0]);
                                             
   glDrawPixels(XDim,YDim,GL_LUMINANCE,GL_FLOAT,@CurrentDisplay[0]);
   end;
  1:
   begin
   //gamma
   glPixelMapfv(GL_PIXEL_MAP_R_TO_R, 65536, @lut[0]);
   glPixelMapfv(GL_PIXEL_MAP_G_TO_G, 65536, @vacio[0]);
   glPixelMapfv(GL_PIXEL_MAP_B_TO_B, 65536, @vacio[0]);

   glDrawPixels(XDim,YDim,GL_RED,GL_FLOAT,@CurrentDisplay[0]);
   end;
  2:
   begin
   //gamma
   glPixelMapfv(GL_PIXEL_MAP_R_TO_R, 65536, @vacio[0]);
   glPixelMapfv(GL_PIXEL_MAP_G_TO_G, 65536, @lut[0]);
   glPixelMapfv(GL_PIXEL_MAP_B_TO_B, 65536, @vacio[0]);

   glDrawPixels(XDim,YDim,GL_GREEN,GL_FLOAT,@CurrentDisplay[0]);
   end;
  3:
   begin
   //gamma
   glPixelMapfv(GL_PIXEL_MAP_R_TO_R, 65536, @vacio[0]);
   glPixelMapfv(GL_PIXEL_MAP_G_TO_G, 65536, @vacio[0]);
   glPixelMapfv(GL_PIXEL_MAP_B_TO_B, 65536, @lut[0]);

   glDrawPixels(XDim,YDim,GL_BLUE,GL_FLOAT,@CurrentDisplay[0]);
   end;
  end;

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


procedure TFImage.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

   if (Key=VK_Down) and (Shift=[ssShift]) then
   begin
    Yini:=Yini-50;
   end;
   if (Key=VK_Up) and (Shift=[ssShift]) then
   begin
    Yini:=Yini+50;
   end;
   if (Key=VK_Left) and (Shift=[ssShift]) then
   begin
    Xini:=Xini-50;
   end;
   if (Key=VK_Right) and (Shift=[ssShift]) then
   begin
    Xini:=Xini+50;
   end;

   FormResize(Sender);

  if Stg=nil then exit;

 if (Key=VK_Down) and (Shift=[ssCtrl]) then
   begin

    CBDeltaZ.Enabled:=False;
    CBSpeed.Enabled:=False;
    Stg.MoveDown(1);
    CBDeltaZ.Enabled:=True;
    CBSpeed.Enabled:=True;
   end;

  if (Key=VK_Up) and (Shift=[ssCtrl]) then
   begin

    CBDeltaZ.Enabled:=False;
    CBSpeed.Enabled:=False;
    Stg.MoveUp(-1);
    CBDeltaZ.Enabled:=True;
    CBSpeed.Enabled:=True;
   end;


end;

procedure TFImage.IMMFSaveAsClick(Sender: TObject);
var
 i:Integer;
 LightFile: Textfile;
 file_name:string;
 file_extension_filter:Integer;
 modificate_metadata_java:JavaAppLuncher;

begin

 if SaveDialog1.Execute then
   begin
//    TiffFiler.Save14BitsTIFFFile(ChangeFileExt(SaveDialog1.FileName,'.tif'),'XYZCT',MT/9*10000,MT/9*10000,0,0,0,XDim,YDim,1,1,1,CurrentCapture,0);
    file_name:=ChangeFileExt(SaveDialog1.FileName,'');
    file_extension_filter:=SaveDialog1.FilterIndex;
    case file_extension_filter of
    1:
        begin
         TiffFiler.Save14BitsTIFFFile(ChangeFileExt(file_name,'.tif'),0,CurrentImage);
        end;
    2:
       begin
        modificate_metadata_java:=JavaAppLuncher.Create('EditorMetadatos.jar',' ');
        modificate_metadata_java.run;
        modificate_metadata_java.Destroy;
       end;
    end;


    //    TiffFiler.Save14BitsTIFFFile(ChangeFileExt(SaveDialog1.FileName,'.tif'),XDim,YDim,0,CurrentCapture,CurrentMetaData);
   if UVMon<>nil then
   begin
    AssignFile(LightFile,ChangeFileExt(SaveDialog1.FileName,'.txt'));
    Rewrite(LightFile);
    Writeln(LightFile,'Dosis: ', FloatToStr(ActualDosis));
    for i:=low(LightSamples) to High(LightSamples) do
      Writeln(LightFile,FloatToStr(LightSamples[i]));
    CloseFile(LightFile);
   end;
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




procedure TFImage.CBColorDisplayChange(Sender: TObject);
begin
Refresh;
end;

procedure TFImage.CBScaleChange(Sender: TObject);
begin

Fscale:=StrToFloat(CBScale.Items[CBScale.ItemIndex]);
Refresh;
end;



procedure TFImage.UDBrightClick(Sender: TObject; Button: TUDBtnType);
begin
  if Button=btNext then bright:=bright+0.01;
  if Button=btPrev then bright:=bright-0.01;

  if bright<-1 then bright:=-1;
  if bright>1 then bright:=1;


  Lbright.Caption:=FloatToStrF(bright,ffNumber ,3,3)  ;

  Refresh;


end;

procedure TFImage.UDContrastClick(Sender: TObject; Button: TUDBtnType);
begin
  if Button=btNext then contrast:=contrast+1;
  if Button=btPrev then contrast:=contrast-1;

   if contrast<0 then contrast:=0;

  Lcontrast.Caption:=FloatToStrF(contrast,ffNumber ,3,3)  ;

  Refresh;
end;



procedure TFImage.UDGammaClick(Sender: TObject; Button: TUDBtnType);
begin
   if Button=btNext then gamma:=gamma+0.01;
  if Button=btPrev then gamma:=gamma-0.01;

   if gamma<0 then gamma:=0;

  Lgammavalue.Caption:=FloatToStrF(gamma,ffNumber ,3,3)  ;

  Refresh;
end;

procedure TFImage.Button1Click(Sender: TObject);
begin
   gamma:=1;
   Lgammavalue.Caption:=FloatToStrF(gamma,ffNumber ,3,3)  ;
   bright:=0;
   Lbright.Caption:=FloatToStrF(bright,ffNumber ,3,3)  ;
   contrast:=1;
   Lcontrast.Caption:=FloatToStrF(contrast,ffNumber ,3,3)  ;
   CBColorDisplay.ItemIndex:=0;
   Refresh;
end;



end.
