unit CameraControl;

interface
uses Forms,SysUtils,Windows,LightMonitor,DecTypes,Dialogs,ComObj,APOGEELib_TLB,variants;

type
  CCDCamera = class
  protected
   ResolutionBits:Byte;
   ResolutionX:Word;
   ResolutionY:Word;
   Magnification:Double;
   TargetTemperature:Double;  // Temperatura deseada en grados centígrados.
   TemperatureMesured:Double; // Temperatura medida en grados centígrados.
   AllowCooling:Boolean;      // Para algunas cámara que no traen refrigeración.
   ExposeTime:Double;
   CameraDetected:Boolean;
  public
   procedure getImage; overload;virtual;abstract;
   function  setResolutionX(const NCol:Word):boolean;overload;virtual;abstract;
   function  setResolutionY(const NRow:Word):boolean;overload;virtual;abstract;
   procedure setTargetTemperature;overload;virtual;abstract;
   function  getTemperature:Double;overload;virtual;abstract;
   procedure getDarkFrame;overload;virtual;abstract;
   procedure getBiasFrame;overload;virtual;abstract;
   function  setTimeExposure(const T:Double):integer;overload;virtual;abstract; // establece el tiempo de
   // exposición en segundos.

   // property  Temperature:Double read GetTemperature write TargetTemperature;
  end;

  AM4Camera = class(CCDCamera)
   private
    Cam:ICamera; // Contiene a ICamera, interface de un activeX
    // que controla la camara apogee AM4
    Temperature:double;
    MaxIntensityCaptured:word; // Contiene el máximo valor de intensidad capturado
    MinIntensityCaptured:word; // Contiene el minimo valor de intensidad capturado
    MaxIntensityValue: word;

    MinExpTime : double;  // Contiene el tiempo mínimo de exposición, cargado en el constructor
    MaxXDim:integer;  // Contiene el tamaño máximo en la dimensión X
    MaxYDim:integer;  // Contiene el tamaño máximo en la dimensión Y
    ImageDose:single ; // Obtained from UVLightMonitor
                       // negative value means no dose capture (case average capture)
    ExpositionTimeCorrected: double; // corrected by UV Monitor
    Freq:Int64;// Frecuencia del contador de alta resolución


   public
    constructor Create(const IFileName:String);
    destructor  Destroy; override;
    procedure   getImage(var CapturedData:TWordArray;
                         const XDim, YDim:Word;
                         const ExTime:Double;
                         const DoseControl:Boolean);reintroduce;overload;

    procedure getImage(var CapturedData:TWordArray;
                       const NumIm,XDim,YDim:Word;
                       const ExTime:Double);reintroduce;overload;
    procedure getImage(var CapturedData:TWordArray;
                       const XDim,YDim:Word;
                       const shutterPos: boolean;
                       const ExTime:Double);reintroduce;overload;

    function  setResolutionX(const NCol:Word):boolean;reintroduce;
    function  setResolutionY(const NRow:Word):boolean;reintroduce;
    procedure setTargetTemperature(T:Double);
    function  getTemperature:Double;reintroduce;overload;
    function  getExpositionTimeCorrected: double;
    procedure goToAmbient;
    procedure temperatureControlOff;
    function  getControlTemperatureStatus:ShortString;
    procedure getDarkFrame;reintroduce;overload;
    procedure getBiasFrame;reintroduce;overload;
    function  setTimeExposure(const T:Double):boolean;reintroduce;
    function  isPresent:Boolean;
    function  getImageDose: single; { TODO : Too much cohesion beetwen CameraControl and LightMonitor }
    procedure getInitialTemperature(Ti:Single);
    property  iniTemperature:Double read Temperature;

    property  MaxCameraIntensity: Word read MaxIntensityValue;

    property  MaxCapturedValue: Word read MaxIntensityCaptured;

    property  MinCapturedValue: Word read MinIntensityCaptured;

    property  MinExpositionTime:Double read MinExpTime;

    property  MaxXDimension:Integer read MaxXDim;

    property  MaxYDimension:Integer read MaxYDim;

    property  ReadTargetTemperature: Double read TargetTemperature;
   end;
var
 Cam:AM4Camera;
implementation

constructor AM4Camera.create(const IFileName:String);
 begin
  try
   Cam:=CoCamera.Create;
   Cam.Init(IFileName,-1,-1);
   if Cam.Present then
    begin
     Cam.OptionBase:=False;
     CameraDetected:=True;
     Cam.CoolerMode:= Camera_CoolerMode_Off;
     ExposeTime:=0.2;
     end
    else
     begin
      CameraDetected:=False;
      MessageDlg('El programa no pudo comunicarse con la cámara.',mtWarning, [mbOk], 0);
     end;
  except on EOleSysError do
   MessageDlg('El controlador de la cámara'+ #13 + ' no ha sido instalado',mtWarning, [mbOk], 0);
  end;
   QueryPerformanceFrequency(Freq);
   ImageDose:=-1;
   MaxIntensityValue:=16383;
   MaxIntensityValue:=16383;
   MinExpTime:=0.01;
   MaxYDim:=512;
   MaxXDim:=768;


end;

destructor AM4Camera.destroy;
 begin
 //
 end;

procedure AM4Camera.getImage(var CapturedData:TWordArray;
                             const XDim,YDim:Word;
                             const ExTime:Double;
                             const DoseControl:Boolean);
type
 PArrayImage=^TArrayImage;
 TArrayImage=array [0..511,0..767] of Word;
var
 ImVar:OleVariant;
 i,j,counter:Integer;
 P:PArrayImage;
 t,tf:int64;
begin
 if SetResolutionX(XDim) and SetResolutionY(YDim) and SetTimeExposure(ExTime) then
 begin
   SetLength(CapturedData,XDim*YDim);
   if (DoseControl) then
    begin
//     pc := GetPriorityClass( GetCurrentProcess );
//     tp := GetThreadPriority( GetCurrentThread );
//     SetPriorityClass( GetCurrentProcess, HIGH_PRIORITY_CLASS );
//     SetThreadPriority( GetCurrentThread, THREAD_PRIORITY_HIGHEST );
     ImageDose:=0;
     Cam.Expose(ExposeTime+(ExposeTime*0.25),false); // tiempo de exposición más 25% por decaimiento natural a largo plazo
     UVMon.setLigthRecorderSwitch(true);
     QueryPerformanceCounter(t);
     Cam.ForceShutterOpen:=true;
     while (not (Cam.Status=Camera_Status_ImageReady)) and (ImageDose<CALIBRATED_DOSE*ExTime) do
      begin
       QueryPerformanceCounter(tf);
       ExpositionTimeCorrected:=(tf-t)/Freq;
       UVMon.setExpositionTime(ExpositionTimeCorrected);
       ImageDose:=UVMon.getDosis;
       if (ImageDose>=CALIBRATED_DOSE*ExTime) then // dosis calibrada en un seg ver LightMonitor
        begin
         Cam.ForceShutterOpen:=false;
         UVMon.setLigthRecorderSwitch(false);
         break;
        end;
      end; // end while
     repeat
      Application.ProcessMessages;
     until (Cam.Status=Camera_Status_ImageReady);
     if cam.ForceShutterOpen then cam.ForceShutterOpen:=false; { TODO : Me parece que esta línea está demás }

 //    SetPriorityClass( GetCurrentProcess, pc );
 //    SetThreadPriority( GetCurrentThread, tp );

    end
   else
    begin
     UVMon.SetLigthRecorderSwitch(true);
     Cam.Expose(ExposeTime,true);
     repeat
      Application.ProcessMessages;
     until Cam.Status=Camera_Status_ImageReady;
     UVMon.setLigthRecorderSwitch(false);
     UVMon.SetExpositionTime(ExTime);
     ImageDose:=UVMon.getDosis;
    end;
   ImVar:=Cam.Image;
   P:=VarArrayLock(ImVar);
   counter:=0;
   try
    for i:=0 to YDim-1 do
     for j:=0 to XDim-1  do
      begin
       CapturedData[counter]:= P^[i,j];
       inc(counter);
      end;
   finally
    VarArrayUnlock(ImVar);
   end;
   VarClear(ImVar);
  end;// end if
end;

procedure AM4Camera.getImage(var CapturedData:TWordArray;
                           const NumIm,XDim,YDim:Word;
                           const ExTime:Double);

type
 PArrayImage=^TArrayImage;
 TArrayImage=array [0..511,0..767] of Word;
var
 ImVar:OleVariant;
 i,j,k,counter:Integer;
 P:PArrayImage;
 Aux: array of LongWord;
begin
 if SetResolutionX(XDim) and SetResolutionY(YDim) and SetTimeExposure(ExTime)  then
  begin
   SetLength(Aux,XDim*YDim);
   ExposeTime:=ExTime;
   for k:=1 to NumIm do
    begin
     Cam.Expose(ExposeTime,true);
     repeat
     until Cam.Status=Camera_Status_ImageReady;
     ImVar:=Cam.Image;
     P:=VarArrayLock(ImVar);
     counter:=0;
     try
      for i:=0 to YDim-1 do
       for j:=0 to XDim-1  do
        begin
         Aux[counter]:= Aux[counter]+ P^[i,j];
         inc(counter);
        end;
     finally
      VarArrayUnlock(ImVar);
      SetLength(CapturedData,XDim*YDim);
      for i := low(CapturedData) to High(CapturedData) do
        CapturedData[i]:=trunc(Aux[i]/NumIm);
     end; // end finally
    end; // end for k
    VarClear(ImVar);
  end;//end If
  ImageDose:=-1;
 end;

procedure AM4Camera.getImage(var CapturedData:TWordArray;
                           const XDim,YDim:Word;
                           const shutterPos: boolean;
                           const ExTime:Double);
type
 PArrayImage=^TArrayImage;
 TArrayImage=array [0..511,0..767] of Word;
var
 ImVar:OleVariant;
 i,j,counter:Integer;
 P:PArrayImage;
begin
 if SetResolutionX(XDim) and SetResolutionY(YDim) and SetTimeExposure(ExTime)  then
  begin
   SetLength(CapturedData,XDim*YDim);
   ExposeTime:=ExTime;
   Cam.Expose(ExposeTime,shutterPos);
   repeat
   until Cam.Status=Camera_Status_ImageReady;
   ImVar:=Cam.Image;
   P:=VarArrayLock(ImVar);
   counter:=0;
   try
    for i:=0 to YDim-1 do
     for j:=0 to XDim-1  do
      begin
       CapturedData[counter]:= P^[i,j];
       inc(counter);
      end;
   finally
    VarArrayUnlock(ImVar);
   end;
   VarClear(ImVar);
  end;//end If
  ImageDose:=-1;
 end;

function AM4Camera.setResolutionX(const NCol:Word):boolean;
 begin
   if  (NCol>MaxXDim) then
    begin
      MessageDlg('Ancho máximo: 768 pix.',mtWarning, [mbOk], 0);
      result:=false;
    end
   else
    begin
     ResolutionX:=NCol;
     result:=true;
    end;
 end;

function AM4Camera.getExpositionTimeCorrected: double;
 begin
  result:=ExpositionTimeCorrected;
 end;

function AM4Camera.setResolutionY(const NRow:Word):boolean;

 begin
   if  (NRow>MaxYDim) then
    begin
      MessageDlg('Altura máxima: 512 pix.',mtWarning, [mbOk], 0);
      result:=false;
    end
   else
    begin
     ResolutionX:=NRow;
     result:=true;
    end;

 end;

procedure AM4Camera.setTargetTemperature(T:Double);
 begin
  TargetTemperature:=T;
  Cam.CoolerMode:=Camera_CoolerMode_On;
  Cam.CoolerSetPoint:=T;
 end;

function AM4Camera.getTemperature:Double;
 begin
  result:=Cam.Temperature;
 end;

procedure AM4Camera.goToAmbient;
 begin
  Cam.CoolerMode:= Camera_CoolerMode_Shutdown;
 end;

procedure AM4Camera.temperatureControlOff;
begin
 Cam.CoolerMode:= Camera_CoolerMode_Off;
end;

function  AM4Camera.getControlTemperatureStatus:ShortString;
 begin
  case Cam.CoolerStatus of
   Camera_CoolerStatus_Off: result:= 'Apagado';
   Camera_CoolerStatus_RampingToSetPoint:result:= 'Refrigerando';
   Camera_CoolerStatus_Correcting: result:= 'Corrigiendo';
   Camera_CoolerStatus_RampingToAmbient: result:= 'Hacia Temperatura Ambiente';
   Camera_CoolerStatus_AtAmbient: result:= 'A Temperatura Ambiente';
   Camera_CoolerStatus_AtMax : result:= 'En Máximo Límite de Refrigeración';
   Camera_CoolerStatus_AtMin: result:= 'En Mínimo Límite de Refrigeración';
   Camera_CoolerStatus_AtSetPoint: result:= 'A Temperatura Deseada';
  end;
end;

procedure AM4Camera.getDarkFrame;
 begin
 end;

function  AM4Camera.getImageDose: single; { TODO : Too much cohesion beetwen CameraControl and LightMonitor }
 begin
  result:=ImageDose;
 end;

procedure AM4Camera.getBiasFrame;
 begin
 end;

function AM4Camera.setTimeExposure(const T:Double):boolean;
 begin
  if  (T<MinExpTime) then
    begin
      MessageDlg('Tiempo de exposición mínimo: 0,01 seg.',mtWarning, [mbOk], 0);
      result:=false;
    end
   else
    begin
     ExposeTime:=T;
     result:=true;
    end;


 end;

function  AM4Camera.isPresent:Boolean;
 begin
  result:=CameraDetected;
 end;

procedure AM4Camera.getInitialTemperature(Ti:Single);
 begin
  Temperature:=Ti;
 end;

end.
