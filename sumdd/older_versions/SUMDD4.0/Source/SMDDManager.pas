unit SMDDManager;

interface

uses
 Forms,Windows,SysUtils,Sectioner,DecTypes,GR32,GR32_ByteMaps,GR32_Image,
 GR32_Layers,ProgressActivity,Dialogs;

type
 TDDMSManager= class // Digital Deconvolution Microscopy System Manager
  private

   XDimension,YDimension,ZDimension:Integer;
      // Para contener los datos y visualizarlos
   VolumeDeconv,VolumeRaw,VolumePSF:TRawData;
   
      
   VRaw,VDeconv,VPSF:TSignal3D;// Older, It should be discarded
   
   VeCal,VeDeconv,VePSF:TVector;
	   
   
   AVal,VectorRaw,VectorDeconv,VectorPSF:TSignal; // AVal Vector de autovalores

   VR,VD,LoadVR:Boolean;

   CuDataVolume:TSectioningData;

   LensMagnification:Double;
   TotalMagnification:Double;

   SLV:Integer;      // Longitud del cuadrado de visualization de las imágenes
   MonitorWidth,MonitorHeight:Integer;

   Stage:TStageControl;
   Camera:TAM4Control;

  public
   Hist3D: array [0..255] of double;
   //VeCal,VeDeconv,VePSF:TVector;

   constructor Create(CameraIniFile:String;DirPort:word);
   procedure SetDirPSF;
   procedure LoadPSF;
   procedure GetMonitorResolution(MH,MW:Integer);
   procedure InitiateStage;
   procedure InitiateCamera;
   procedure Section;


   procedure LoadRawSectioning(XDim,YDim, // Dimensión X Y de las imágenes
                            ImNumber, // número de imágenes
                            InitNumber:Integer;// Número inicial del Seccinamiemto
                            Header,FormatFile:ShortString;RString:String);

   procedure LoadSDFSectioning(InitNumber,NumberOfImages:Integer;LoadRaw:Boolean);
   procedure GalleryView(IViewDeconv,IViewRaw:TImgView32);
   procedure SetDirPort(DirPort:word);
   procedure SaveSectioning;
   procedure CleanVolRaw;
   procedure CleanVolDeconv;
   procedure CleanVolPSF;
   procedure Deconvolve;
   procedure PrepareForDeconvolution;
   procedure PrepareForLinearDeconvolution;

   procedure DeconvolutionFinished;
   procedure LinearDeconvolutionFinished;
   property  VolDeconv:TRawData read VolumeDeconv;
   property  VolRaw:TRawData read VolumeRaw;
   property  VolumeR:TSignal3D read VRaw write VRaw;
   property  VolumeD:TSignal3D read VDeconv write VDeconv;
   property  VolumeP:TSignal3D read VPSF write VPSF;
   property  VecRaw:TSignal read VectorRaw write VectorRaw;
   property  VecDeconv:TSignal read VectorDeconv write VectorDeconv;
   property  VecPSF:TSignal read VectorPSF write VectorPSF;

   // New Additions //
   property  DataCalc:TVector read VeCal write VeCal;
   property  DataPSF:TVector read VePSF write VePSF;
   procedure CalcHist3D;
   // New Additions //

   property  VecAVal:TSignal read AVal write AVal;
   property  XDim:Integer read XDimension;
   property  YDim:Integer read YDimension;
   property  ZDim:Integer read ZDimension;
   property  DataVolume:TSectioningData read CuDataVolume write CuDataVolume;
   property  TMagnification:Double read TotalMagnification write TotalMagnification;
   property  LMagnification:Double read LensMagnification write LensMagnification;
   property  Cam :TAM4Control read Camera write Camera;
   property  StgControl: TStageControl read Stage write Stage;
   property  MHeight :Integer read MonitorHeight;
   property  MWidth :Integer read MonitorWidth;
end;

const
  AP = 0.6; // Porcentaje del area de la pantalla para la
                   //visualización de galerías;

var
BLDeconv:TBitmapLayer;
BLRaw:TBitmapLayer;
FActivityProgress: TFActivityProgress;

implementation

constructor TDDMSManager.Create(CameraIniFile:String;DirPort:word);
 begin
  try
     Camera:=TAM4control.Create(CameraIniFile);
  except
    on E: Exception do
     begin
      MessageDlg('Su Dispositivo de Captura' +#13+
                   'no puede ser Inicializado.',mtInformation, [mbOk], 0);
      Camera.Free;
     end
  end;
  Stage:=TStageControl.Create(DirPort);
 end;
procedure TDDMSManager.GetMonitorResolution(MH,MW:Integer);
begin
MonitorWidth:=MW;
MonitorHeight:=MH;
SLV:=trunc(AP*MonitorHeight);
end;
procedure TDDMSManager.InitiateStage;
begin
end;
procedure TDDMSManager.SetDirPort(DirPort:word);
begin

end;

procedure TDDMSManager.Section;
begin
end;

procedure TDDMSManager.InitiateCamera;
begin
end;
procedure TDDMSManager.LoadRawSectioning(XDim,YDim,ImNumber,InitNumber:Integer;
                       Header,FormatFile:ShortString;RString:String);
var
 k:integer;
 DirDeconv,DirRaw:String;
 BR,BD:TBitmap32;
begin


XDimension:=XDim;
YDimension:=YDim;
ZDimension:=ImNumber;
VolumeRaw:=nil;
VolumeDeconv:=nil;
VR:=False;
VD:=False;
LoadVR:=False;
BR:=TBitmap32.Create;
SetLength(VolumeRaw,ZDimension);
VR:=True;

CuDataVolume.FileRoot:=RString;
CuDataVolume.Header:=Header;
CuDataVolume.IniNumber:=InitNumber;
CuDataVolume.FormatFileSection:=FormatFile;
CuDataVolume.XDimension:=XDim;
CuDataVolume.YDimension:=YDim;
CuDataVolume.NumberOfSections:=ImNumber;

FActivityProgress:=TFActivityProgress.Create(Application);
FActivityProgress.Caption:= 'Cargando Seccionamiento';
FActivityProgress.BBProcessCancel.Enabled:=False;
FActivityProgress.Show;

for k:=1 to ZDimension do
 begin
  FActivityProgress.PBActivityProgress.Position:=Trunc(k/ZDimension*100);
  FActivityProgress.LProgress.Caption:=FormatFloat('##.#%',k/ZDimension*100);
  FActivityProgress.Refresh;
  DirRaw:= RString + Header + FormatFloat('###000',InitNumber+k-1) + FormatFile;
  BR.LoadFromFile(DirRaw);
  VolumeRaw[k-1]:=TByteMap.Create;
  VolumeRaw[k-1].Readfrom(BR,ctUniformRGB);
 end; // End For


FActivityProgress.Destroy;
BR.Destroy;
end;

procedure TDDMSManager.LoadSDFSectioning(InitNumber,NumberOfImages:Integer;LoadRaw:Boolean);
var
 k:integer;
 DirDeconv,DirRaw:String;
 BR,BD:TBitmap32;
begin

ZDimension:=NumberOfImages;
VolumeRaw:=nil;
VolumeDeconv:=nil;
VR:=False;
VD:=False;
LoadVR:=False;

BR:=TBitmap32.Create;
BD:=TBitmap32.Create;

if LoadRaw then
 begin
  SetLength(VolumeRaw,NumberOfImages);
  VR:=False;
  LoadVR:=True;
 end;

if CuDataVolume.Deconvolved then
 begin
  SetLength(VolumeDeconv,ZDimension);
  VD:=True;
 end;

FActivityProgress:=TFActivityProgress.Create(Application);
FActivityProgress.Caption:= 'Cargando Seccionamiento';
FActivityProgress.BBProcessCancel.Enabled:=False;
FActivityProgress.Show;

for k:=1 to ZDimension do
 begin
  FActivityProgress.PBActivityProgress.Position:=Trunc(k/ZDimension*100);
  FActivityProgress.LProgress.Caption:=FormatFloat('##.#%',k/ZDimension*100);
  FActivityProgress.Refresh;
  if not CuDataVolume.Deconvolved then
   begin
    DirRaw:= CuDataVolume.FileRoot + CuDataVolume.Header
         + FormatFloat('###000',InitNumber+k-1) + CuDataVolume.FormatFileSection;
    BR.LoadFromFile(DirRaw);
    VolumeRaw[k-1]:=TByteMap.Create;
    VolumeRaw[k-1].Readfrom(BR,ctUniformRGB);
   end;
  if CuDataVolume.Deconvolved then
   begin
    DirDeconv:= CuDataVolume.FileRoot + CuDataVolume.Header
         + FormatFloat('###000',InitNumber+k-1) + CuDataVolume.FormatFileSection;
    BD.LoadFromFile(DirDeconv);
    VolumeDeconv[k-1]:=TByteMap.Create;
    VolumeDeconv[k-1].ReadFrom(BD,ctUniformRGB);
    if  LoadVR then
     begin
      DirRaw:=CuDataVolume.OriginalFileRoot+ CuDataVolume.OriginalHeader +
       FormatFloat('###000',CuDataVolume.OriginalIniNumber+k-1)+CuDataVolume.OriginalFormatFileSection;
      BR.LoadFromFile(DirRaw);
      VolumeRaw[k-1]:=TByteMap.Create;
      VolumeRaw[k-1].ReadFrom(BR,ctUniformRGB);
     end;
   end;
 end; // End for
FActivityProgress.Destroy;
BR.Destroy;
BD.Destroy;
end;
procedure TDDMSManager.GalleryView(IViewDeconv,IViewRaw:TImgView32);
var
 k:Integer;
 PlaceDeconv,PlaceRaw:TRect;
 SFactor:Single; // Factor de escala
 XPosition:Integer;
 YPosition:Integer;
 Separation:Integer;
 XFactor:Integer;
 YFactor:Integer;
 Aux:Integer;

begin

Separation:=3;
SFactor:=0.15*SLV/XDimension;
XFactor:=Trunc(SFactor*XDimension);
YFactor:=Trunc(SFactor*YDimension);
XPosition:=0;
YPosition:=0;


// Determinación del tamaño Y del fondo de la galería
aux:=trunc((ZDimension/trunc(SLV/(XFactor+(SLV/XFactor)*Separation+Separation)))*YFactor+(ZDimension/trunc(SLV/(XFactor+(SLV/XFactor)*Separation+Separation)))*Separation+Separation+YFactor);


IViewRaw.Layers.Clear;
IViewRaw.Bitmap.Delete;
IViewRaw.Left:=5;
IViewRaw.Top:=25;
IViewRaw.Width:=8;
IViewRaw.Height:=8;
IViewRaw.Visible:=False;

IViewDeconv.Layers.Clear;
IViewDeconv.Bitmap.Delete;
IViewDeconv.Left:=5;
IViewDeconv.Top:=25;
IViewDeconv.Width:=8;
IViewDeconv.Height:=8;
IViewDeconv.Visible:=False;


if VR  then
 begin
  IViewRaw.Visible:=True;
  IViewRaw.Bitmap.SetSize(SLV,aux);
  IViewRaw.Bitmap.Clear(Color32(90,90,90,255));
  IViewraw.AutoSize:= True;
 end;

if VD then
 begin
  IViewDeconv.Visible:=True;
  IViewDeconv.Bitmap.SetSize(SLV,aux);
  IViewDeconv.Bitmap.Clear(Color32(90,90,90,255));
  IViewDeconv.AutoSize:= True;
  IViewDeconv.Top:=IViewRaw.Top;
  if LoadVR then
   begin
    IViewRaw.Visible:=True;
    IViewRaw.Bitmap.SetSize(SLV,aux);
    IViewRaw.Bitmap.Clear(Color32(90,90,90,255));
    IViewRaw.AutoSize:= True;
    IViewDeconv.Left:=IViewRaw.Left+IViewRaw.Bitmap.Width;
   end;
 end;


for k:=1 to ZDimension do
 begin
  if VD then
   begin
     BLDeconv := TBitmapLayer.Create(IViewDeconv.Layers);
     BLDeconv.Bitmap.Assign(VolumeDeconv[k-1]);
     BLDeconv.Bitmap.DrawMode:=dmCustom;
     BLDeconv.Scaled:=True;
    if LoadVR then
     begin
      BLRaw := TBitmapLayer.Create(IViewRaw.Layers);
      BLRaw.Bitmap.Assign(VolumeRaw[k-1]);
      BLRaw.Bitmap.DrawMode:=dmCustom;
      BLRaw.Scaled:=True;
     end;
   end;
  if VR then
   begin
    BLRaw := TBitmapLayer.Create(IViewRaw.Layers);
    BLRaw.Bitmap.Assign(VolumeRaw[k-1]);
    BLRaw.Bitmap.DrawMode:=dmCustom;
    BLRaw.Scaled:=True;
   end;

  if  (XPosition + Trunc(SFactor*XDimension) + Separation) < SLV then
   begin
    if not VR then
     begin
      PlaceDeconv.Left:=XPosition + Separation;
      PlaceDeconv.Right:=XPosition + Trunc(SFactor*XDimension)+Separation;
      PlaceDeconv.Top:=YPosition+Separation;
      PlaceDeconv.Bottom:=YPosition+ Trunc(SFactor*YDimension)+Separation;
     end;

    if (VR or LoadVR) then
     begin
      PlaceRaw.Left:=XPosition + Separation;
      PlaceRaw.Right:=XPosition + Trunc(SFactor*XDimension)+Separation;
      PlaceRaw.Top:=YPosition+Separation;
      PlaceRaw.Bottom:=YPosition+ Trunc(SFactor*YDimension)+Separation;
     end;
     XPosition:=XPosition + Trunc(SFactor*XDimension)+Separation;
   end
  else
   begin
    XPosition:=0;
    YPosition:=YPosition+ Trunc(SFactor*YDimension) +  Separation ;
    if not VR then
     begin
      PlaceDeconv.Left:=XPosition + Separation;
      PlaceDeconv.Right:=XPosition + Trunc(SFactor*XDimension)+ Separation;
      PlaceDeconv.Top:=YPosition + Separation;
      PlaceDeconv.Bottom:=YPosition+ Trunc(SFactor*YDimension)+Separation;
     end;
    if (VR or LoadVR) then
     begin
      PlaceRaw.Left:=XPosition + Separation;
      PlaceRaw.Right:=XPosition + Trunc(SFactor*XDimension)+ Separation;
      PlaceRaw.Top:=YPosition + Separation;
      PlaceRaw.Bottom:=YPosition+ Trunc(SFactor*YDimension)+Separation;
     end;
    XPosition:=XPosition + Trunc(SFactor*XDimension)+Separation;
   end;

  if VD then
   begin
    BLDeconv.Cropped := True;
    BLDeconv.Location := FloatRect(PlaceDeconv);
   end;

  if (VR or LoadVR) then
   begin
    BLRaw.Cropped := True;
    BLRaw.Location := FloatRect(PlaceRaw);
   end;

 end; // End for
end;
procedure TDDMSManager.SaveSectioning;
begin
end;
procedure TDDMSManager.CleanVolRaw;
begin
VolumeRaw:=nil;
VR:=False;
LoadVR:=False;
end;
procedure TDDMSManager.CleanVolDeconv;
begin
VolumeDeconv:=nil;
VD:=False;
if LoadVR then
 begin
  LoadVR:=False;
  VR:=True;
 end

end;
procedure TDDMSManager.CleanVolPSF;
begin
VolumePSF:=nil;
end;
procedure TDDMSManager.Deconvolve;
 begin

 end;
procedure TDDMSManager.PrepareForDeconvolution;
var
i,j,k,Counter:integer;
begin
 VolumeDeconv:=nil;
 SetLength(VeCal,XDimension*YDimension*ZDimension);
 Set3DDimension(VRaw,ZDimension,XDimension,YDimension);
Counter:=0;
 for k:=0 to High(VolumeRaw) do
  for i:=0 to YDimension -1 do
   for j:=0 to XDimension -1 do
    begin
     VRaw[k,j,i].Re:=VolumeRaw[k].Value[j,i];
     VeCal[Counter]:=VolumeRaw[k].Value[j,i];
     inc(Counter);
    end;
 //VolumeRaw:=nil;
 //VolumeDeconv:=nil;
 //VolumePSF:=nil;
 //VeDeconv:=nil;
 //VePSF:=nil;

 //SetLength(VePSF,XDimension*YDimension*ZDimension);

 Set3DDimension(VDeconv,ZDimension,XDimension,YDimension);
 Set3DDimension(VPSF,ZDimension,XDimension,YDimension);


end;
procedure TDDMSManager.PrepareForLinearDeconvolution;
var
c,i,j,k:Integer;
begin
 //VectorDeconv:=nil;
 //SetDimension(VectorRaw,XDimension*YDimension*ZDimension);
 SetLength(VeCal,XDimension*YDimension*ZDimension);
 c:=0;
 for k:=0 to High(VolumeRaw) do
  for i:=0 to YDimension -1 do
   for j:=0 to XDimension -1 do
    begin
//     VectorRaw[c].Re:=VolumeRaw[k].Value[j,i];
     VeCal[c]:=VolumeRaw[k].Value[j,i];
     c:=c+1;
    end;
// VolumeRaw:=nil;
 VolumeDeconv:=nil;
 //VolumePSF:=nil;

 //SetDimension(VectorDeconv,XDimension*YDimension*ZDimension);
 //SetDimension(VectorPSF,XDimension*YDimension*ZDimension);
 //SetLength(VePSF,XDimension*YDimension*ZDimension);
end;
procedure TDDMSManager.DeconvolutionFinished;
var
 i,j,k,Counter:integer;
begin
 //SetLength(VolumeRaw,ZDimension);
 SetLength(VolumeDeconv,ZDimension);
 //SetLength(VeCal,XDimension*YDimension*ZDimension);
 VD:=True;
 VR:=False;
 LoadVR:=True;
 Counter:=0;
 for k:=0 to ZDimension -1 do
  begin
   //VolumeRaw[k]:=TByteMap.Create;
   VolumeDeconv[k]:=TByteMap.Create;
   //VolumeRaw[k].SetSize(XDimension,YDimension);
   VolumeDeconv[k].SetSize(XDimension,YDimension);
   for i:=0 to YDimension-1 do
    for j:=0 to XDimension-1 do
     begin
  //    VolumeRaw[k].Value[j,i]:= trunc(VRaw[k,j,i].Re);
//      VolumeDeconv[k].Value[j,i]:= trunc(255*VDeconv[k,j,i].Re);
      VolumeDeconv[k].Value[j,i]:= trunc(VeCal[Counter]) ;
      inc(Counter);
     end;

  end;
 VRaw:=nil;
 VDeconv:=nil;
 VPSF:=nil;
end;
procedure TDDMSManager.CalcHist3D;
var
 i,j,k:integer;
begin
 ZeroMemory(@Hist3D,length(Hist3D)*Sizeof(integer));
 for k:=0 to ZDimension-1 do
  for i:=0 to YDimension-1 do
   for j:=0 to XDimension-1 do
    Hist3D[VolumeRaw[k].Value[j,i]]:=Hist3D[VolumeRaw[k].Value[j,i]]+1;

end;
procedure TDDMSManager.LinearDeconvolutionFinished;
 var
  c,i,j,k:integer;
begin
// SetLength(VolumeRaw,ZDimension);
 SetLength(VolumeDeconv,ZDimension);
 VD:=True;
 VR:=False;
 LoadVR:=True;
 c:=0;
 for k:=0 to ZDimension -1 do
  begin
   //VolumeRaw[k]:=TByteMap.Create;
   VolumeDeconv[k]:=TByteMap.Create;
   //VolumeRaw[k].SetSize(XDimension,YDimension);
   VolumeDeconv[k].SetSize(XDimension,YDimension);
   for i:=0 to YDimension-1 do
    for j:=0 to XDimension-1 do
     begin
      //VolumeRaw[k].Value[j,i]:=trunc(VectorRaw[c].Re);
      VolumeDeconv[k].Value[j,i]:=trunc(VeCal[c]);
      c:=c+1;
     end;
  end;
 //VRaw:=nil;
 //VDeconv:=nil;
 //VPSF:=nil;
end;

procedure TDDMSManager.SetDirPSF;
begin

end;

procedure TDDMSManager.LoadPSF;
begin

end;

end.
