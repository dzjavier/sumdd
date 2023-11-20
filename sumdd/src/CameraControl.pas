unit CameraControl;

interface
uses Forms,
SysUtils,
Windows,LightMonitor,DecTypes,Dialogs,ComObj,APOGEELib_TLB,variants,DateUtils,DateAndTime,
SUMDDMetadata,
Images;

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
   isCameraDetected:Boolean;
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
    AM4CameraInterface:ICamera; // Contiene a ICamera, interface de un activeX
    // que controla la camara apogee AM4
    Temperature:double;
    MaxIntensityCaptured:word; // Contiene el máximo valor de intensidad capturado
    MinIntensityCaptured:word; // Contiene el minimo valor de intensidad capturado
    MaxIntensityValue: word;

    MinExpTime : double;  // Contiene el tiempo mínimo de exposición, cargado en el constructor
    MaxXDim:integer;  // Contiene el tamaño máximo en la dimensión X
    MaxYDim:integer;  // Contiene el tamaño máximo en la dimensión Y
    LightLevel:single ; // Obtained from UVLightMonitor
                       // negative value means no dose capture (case average capture)
    ExpositionTimeCorrected: double; // corrected by UV Monitor
    Freq:Int64;// Frecuencia del contador de alta resolución
    ContextualMetadata: Metadata;
    CaptureNumber:Word; // número de imágenes a promediar
    BiasLevel :Word; // valor obtenido de hoja de datos
    function  getContextualMetadata: Metadata;

   public
    constructor Create(const IFileName:String);
    destructor  Destroy; override;
    procedure   getImage(var CapturedData:TWordArray;
                         const XDim, YDim:Word;
                         const ExTime:Double;
                         const DoseControl:Boolean);reintroduce;overload;

    procedure getImage(var CapturedImage:MicroscopeDigitalImage;
                       const NumIm,XDim,YDim:Word;
                       const ExTime:Double);reintroduce;overload;

    procedure getImage(var CapturedImage:MicroscopeDigitalImage;
                       const number_of_captures,XDim,YDim:Word;
                       const ExTime:Double;
                       const is_open_shutter:Boolean;
                       const measure_light:Boolean);reintroduce;overload;

    procedure getDarkCurrentImage(var CapturedData:TWordArray;
                       const XDim,YDim:Word;
                  //    const shutterPos: boolean;
                       const ExTime:Double);//reintroduce;overload;


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
    function  getExposureTime:Double;
    function  getImageDose: single; { TODO : Too much cohesion beetwen CameraControl and LightMonitor }
    procedure getInitialTemperature(Ti:Single);

    function  setIntegration(const number_of_captures:Word):boolean;
    function  getIntegration:Word;
    function  getBiasLevel:Word;

    property  iniTemperature:Double read Temperature;

    property  MaxCameraIntensity: Word read MaxIntensityValue;

    property  MaxCapturedValue: Word read MaxIntensityCaptured;

    property  MinCapturedValue: Word read MinIntensityCaptured;

    property  MinExpositionTime:Double read MinExpTime;

    property  MaxXDimension:Integer read MaxXDim;

    property  MaxYDimension:Integer read MaxYDim;

    property  ReadTargetTemperature: Double read TargetTemperature;

    end;

 type
   PArrayImage=^TArrayImage;
   TArrayImage=array [0..511,0..767] of Word;



var
 Cam:AM4Camera;
implementation


constructor AM4Camera.create(const IFileName:String);
 begin
  try
   AM4CameraInterface:=CoCamera.Create;
   AM4CameraInterface.Init(IFileName,-1,-1);
   if AM4CameraInterface.Present then
    begin
     BiasLevel:=475; // obtenido de hoja de datos
     AM4CameraInterface.OptionBase:=False;
     isCameraDetected:=True;
     AM4CameraInterface.CoolerMode:= Camera_CoolerMode_Off;  
     ContextualMetadata:=Metadata.Create();
     with ContextualMetadata do
      begin
       setString('DetectorNoise',FloatToStr(AM4CameraInterface.Noise));
       setString('DetectorGain',FloatToStr(AM4CameraInterface.Gain));
       setString('DetectorOffset',IntToStr(BiasLevel));
       setString('PixelsSignificantBits',IntToStr(AM4CameraInterface.DataBits));
       setString('DetectorTemperatureUnit','C');
       setString('DetectorSizeUnit','um');
       setString('DetectorTimeUnit','s');
       setString('PixelsPhysicalSizeX',FloatToStr(AM4CameraInterface.PixelXSize));
       setString('PixelsPhysicalSizeY',FloatToStr(AM4CameraInterface.PixelYSize));
       setString('DetectorSettingsBinning','ONEXONE');
       setString('DetectorType','CCD');
       setString('DetectorModel','AM4'); // del instrumento y hoja de datos
       setString('DetectorManufacturer','APOGEE');
       setString('DetectorSerialNumber','A198132'); // de la hoja de datos
      end;
     ExposeTime:=0.2;
     CaptureNumber:=1;
     end
    else
     begin
      isCameraDetected:=False;
      MessageDlg('El programa no pudo comunicarse con la cámara.',mtWarning, [mbOk], 0);
     end;
  except on EOleSysError do
   MessageDlg('El controlador de la cámara'+ #13 + ' no ha sido instalado',mtWarning, [mbOk], 0);
  end;
   QueryPerformanceFrequency(Freq);
   LightLevel:=-1;
   MaxIntensityValue:=16383;
   MaxIntensityValue:=16383;
   MinExpTime:=0.01;
   MaxYDim:=512;
   MaxXDim:=768;
end;

destructor AM4Camera.Destroy;
 begin
  ContextualMetadata.Destroy;
 end;
procedure AM4Camera.getImage(var CapturedImage:MicroscopeDigitalImage;
                             const number_of_captures,XDim,YDim:Word;
                             const ExTime:Double;
                             const is_open_shutter:Boolean;
                             const measure_light:Boolean);

var
 ImVar:OleVariant;
 i,j,counter,k:Integer;
 P:PArrayImage;
 t,tf:int64;
 aux: array of LongWord;
 captured_data:TWordArray;
 aux_light_level:double;

begin
if isCameraDetected then
begin
 if SetResolutionX(XDim) and SetResolutionY(YDim) and SetTimeExposure(ExTime) and
     setIntegration(number_of_captures) then
 begin
   if (is_open_shutter) then
    begin
    SetLength(aux,XDim*YDim);
    for k := 1 to CaptureNumber do
     begin
      aux_light_level:=0;
      if measure_light and (UVMon<>nil) then
       UVMon.SetLigthRecorderSwitch(true);
      AM4CameraInterface.Expose(ExposeTime,is_open_shutter);
      repeat
       Application.ProcessMessages;
      until AM4CameraInterface.Status=Camera_Status_ImageReady;
      if (measure_light) and (UVMon<>nil) then
      begin
       UVMon.setLigthRecorderSwitch(false);
       UVMon.SetExpositionTime(ExTime);
       aux_light_level:=aux_light_level+UVMon.getLightLevel;
      end;
      ImVar:=AM4CameraInterface.Image;
      P:=VarArrayLock(ImVar);
      counter:=0;
      try
       for i:=0 to YDim-1 do
        for j:=0 to XDim-1  do
        begin
          aux[counter]:= Aux[counter]+ P^[i,j];
          inc(counter);
        end;
      finally
       VarArrayUnlock(ImVar);
      end; // end finally
     end; // end for k
    VarClear(ImVar);
    end // end if is_shutter_open
    else
    begin

    end;
 end;

 SetLength(captured_data,XDim*YDim);
 for i := low(captured_data) to High(captured_data) do
       captured_data[i]:=trunc(Aux[i]/CaptureNumber);
    CapturedImage.setImageFromDynamicArray(captured_data,YDim,XDim);
    if measure_light and (UVMon<>nil) then
     LightLevel:=aux_light_level/CaptureNumber;
    CapturedImage.addMetadata(getContextualMetadata);
 end; // end if camera detected
end;

procedure AM4Camera.getImage(var CapturedData:TWordArray;
                             const XDim,YDim:Word;
                             const ExTime:Double;
                             const DoseControl:Boolean);
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
     LightLevel:=0;
     AM4CameraInterface.Expose(ExposeTime+(ExposeTime*0.25),false); // tiempo de exposición más 25% por decaimiento natural a largo plazo
     UVMon.setLigthRecorderSwitch(true);
     QueryPerformanceCounter(t);
     AM4CameraInterface.ForceShutterOpen:=true;
     while (not (AM4CameraInterface.Status=Camera_Status_ImageReady)) and (LightLevel<CALIBRATED_DOSE*ExTime) do
      begin
       QueryPerformanceCounter(tf);
       ExpositionTimeCorrected:=(tf-t)/Freq;
//       UVMon.setExpositionTime(ExpositionTimeCorrected);
//       UVLightLevel:=UVMon.getDosis;
       if (LightLevel>=CALIBRATED_DOSE*ExTime) then // dosis calibrada en un seg ver LightMonitor
        begin
         AM4CameraInterface.ForceShutterOpen:=false;
         UVMon.setLigthRecorderSwitch(false);
         break;
        end;
      end; // end while
     repeat
      Application.ProcessMessages;
     until (AM4CameraInterface.Status=Camera_Status_ImageReady);
     if AM4CameraInterface.ForceShutterOpen then AM4CameraInterface.ForceShutterOpen:=false;{ TODO : Me parece que esta línea está demás }

 //    SetPriorityClass( GetCurrentProcess, pc );
 //    SetThreadPriority( GetCurrentThread, tp );

    end
   else
    begin
     UVMon.SetLigthRecorderSwitch(true);
     AM4CameraInterface.Expose(ExposeTime,true);
     ExpositionTimeCorrected:=ExposeTime;
     repeat
      Application.ProcessMessages;
     until AM4CameraInterface.Status=Camera_Status_ImageReady;
     UVMon.setLigthRecorderSwitch(false);
     UVMon.SetExpositionTime(ExTime);
     LightLevel:=UVMon.getLightLevel;
    end;
   ImVar:=AM4CameraInterface.Image;
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

//Sin control de dosis, promediando
procedure AM4Camera.getImage(var CapturedImage:MicroscopeDigitalImage;
                           const NumIm,XDim,YDim:Word;
                           const ExTime:Double);

var
 ImVar:OleVariant;
 i,j,k,counter:Integer;
 P:PArrayImage;
 Aux: array of LongWord;
 CapturedData:TWordArray;
begin
 if SetResolutionX(XDim) and SetResolutionY(YDim) and SetTimeExposure(ExTime)  then
  begin
   SetLength(Aux,XDim*YDim);
   ExposeTime:=ExTime;
   setIntegration(NumIm);
   for k:=1 to CaptureNumber do
    begin
     AM4CameraInterface.Expose(ExposeTime,true);
     repeat
     until AM4CameraInterface.Status=Camera_Status_ImageReady;
     ImVar:=AM4CameraInterface.Image;
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
     end; // end finally
    end; // end for k
    VarClear(ImVar);
    SetLength(CapturedData,XDim*YDim);
     for i := low(CapturedData) to High(CapturedData) do
       CapturedData[i]:=trunc(Aux[i]/NumIm);
    CapturedImage.setImageFromDynamicArray(CapturedData,YDim,XDim);
    CapturedImage.addMetadata(getContextualMetadata);
  end;//end If
 // MessageDlg(inttostr(MaxWordValue(CapturedData)),mtInformation,mbOKCancel,0);
  LightLevel:=-1;
 end;


procedure AM4Camera.getDarkCurrentImage(var CapturedData:TWordArray;
                           const XDim,YDim:Word;
                         //  const shutterPos: boolean;
                           const ExTime:Double);
var
 ImVar:OleVariant;
 i,j,counter:Integer;
 P:PArrayImage;
begin
 if SetResolutionX(XDim) and SetResolutionY(YDim) and SetTimeExposure(ExTime)  then
  begin
   SetLength(CapturedData,XDim*YDim);
   ExposeTime:=ExTime;
   AM4CameraInterface.Expose(ExposeTime,false);
   repeat
   until AM4CameraInterface.Status=Camera_Status_ImageReady;
   ImVar:=AM4CameraInterface.Image;
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
  LightLevel:=-1;
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
     ResolutionY:=NRow;
     result:=true;
    end;

 end;

procedure AM4Camera.setTargetTemperature(T:Double);
 begin
  TargetTemperature:=T;
  AM4CameraInterface.CoolerMode:=Camera_CoolerMode_On;
  AM4CameraInterface.CoolerSetPoint:=T;
 end;

function AM4Camera.getTemperature:Double;
 begin
  result:=AM4CameraInterface.Temperature;
 end;

procedure AM4Camera.goToAmbient;
 begin
  AM4CameraInterface.CoolerMode:= Camera_CoolerMode_Shutdown;
 end;

procedure AM4Camera.temperatureControlOff;
begin
 AM4CameraInterface.CoolerMode:= Camera_CoolerMode_Off;
end;

function  AM4Camera.getControlTemperatureStatus:ShortString;
 begin
  case AM4CameraInterface.CoolerStatus of
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
  result:=LightLevel;
 end;

procedure AM4Camera.getBiasFrame;
 begin
 end;

function AM4Camera.setTimeExposure(const T:Double):boolean;
 begin
  if  (T<MinExpTime) then
    begin
      MessageDlg('Tiempo de exposición mínimo: 10 [ms]',mtWarning, [mbOk], 0);
      result:=false;
    end
   else
    begin
     ExposeTime:=T;
     result:=true;
    end;
 end;
function  AM4Camera.getExposureTime:Double;
begin
 result:=ExposeTime;
end;

function AM4Camera.setIntegration(const number_of_captures:Word):boolean;
begin
result:=false;
if number_of_captures>=1 then
 begin
  CaptureNumber:=number_of_captures;
  result:=true;
 end
else
 MessageDlg('El número de capturas debe ser entero positivo',mtWarning, [mbOk], 0);
end;
function  AM4Camera.getIntegration:Word;
begin
 result:=CaptureNumber;
end;

procedure AM4Camera.getInitialTemperature(Ti:Single);
 begin
  Temperature:=Ti;
 end;
function  AM4Camera.getBiasLevel:Word;
begin
 result:=BiasLevel;
end;
function AM4Camera.getContextualMetadata: Metadata;
var
 iso_dt:DateTime;
begin
 with ContextualMetadata do
  begin
   setString('DetectorTemperature',FloatToStrF(getTemperature,ffFixed,5,3));
   setString('PlaneExposureTime',FloatToStr(getExposureTime));
   setString('DetectorSettingsIntegration',IntToStr(getIntegration));
   setString('PixelsSizeX',IntToStr(ResolutionX));
   setString('PixelsSizeY',IntToStr(ResolutionY));
   setString('PlaneExposureTime',FloatToStr(getExposureTime));
   setString('ImageAcquisitionDate',iso_dt.getDateTimeISO8601);
   if UVMon<>nil then
    begin
     setString('UVLightMonitorStatus','On');
     setString('UVLightLevel',FloatToStrF(LightLevel,ffFixed,5,3));
     setString('UVLightLevelReference',FloatToStrF(UVMon.getReferenceLigthLevel,ffFixed,5,3));
     setString('UVLightLevelCalibrated',FloatToStrF(UVMon.getCalibratedLightLevel,ffFixed,5,3));
    end
   else
    setString('UVLightMonitorStatus','Off');

  end;
   result:=ContextualMetadata;
end;
end.
