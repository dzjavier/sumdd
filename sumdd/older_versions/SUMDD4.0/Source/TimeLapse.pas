unit TimeLapse;

{Módulo donde se describen las clases TCameraControl y sus descendientes, y
TStageControl}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ShellAPI, GR32,GR32_Image,APOGEELib_TLB,GR32_ByteMaps,math;

 type
    TCameraControl = class
    private
     ResolutionBits:Byte;
     ResolutionX:Word;
     ResolutionY:Word;
     Magnification:Double;
     TargetTemperature:Double;  // Temperatura deseada en grados centígrados.
     TemperatureMesured:Double;    // Temperatura medida en grados centígrados.
     AllowCooling:Boolean; // Para algunas cámara que no traen refrigeración.

     ExposeTime:Double;
     IniFileName:String; //Ruta y Nombre del Archivo donde buscar los datos para inicializar
                         //la cámara.
     SaveFileName:String;//Ruta y Nombre donde se guarda la CurrentImage.
     CameraDetected:Boolean;
     Light:Boolean;


    public
     procedure GetImage; virtual;abstract;
     procedure SetResolutionBits;virtual;abstract;
     procedure SetResolutionX;virtual;abstract;
     procedure SetResolutionY;virtual;abstract;
     procedure SetTargetTemperature;virtual;abstract;
     function  GetTemperature:Double;virtual;abstract;
     procedure GetDarkFrame;virtual;abstract;
     procedure GetBiasFrame;virtual;abstract;
     procedure SetTimeExposure(T:Double);virtual;abstract; // establece el tiempo de
                                                // exposición en segundos.
     procedure Setlight(L:Boolean);virtual;abstract;



//     property  Temperature:Double read GetTemperature write TargetTemperature;
 end;
type
    TAM4Control=class(TCameraControl)
     private
      Cam:ICamera; // Contiene a ICamera, interface de un activeX
                   // que controla la camara apogee AM4

      VCurrentImage:OleVariant; // Es el tipo de dato que maneja la
                                // cámara para devolver la imagen capturada.

      ACurrentImage:array of array of LongWord;//Sirve para crear el espacio
                          //de memoria que necesita el variant y es el puntero
                          // donde ICamera va a organizar los datos de la imagen.

     CurrentImage:TByteMap;
     DarkFrame:TByteMap;
     FlatFrame:TByteMap;
     InitialTemperature:Single;

     MaxIntensityValue:Integer; // Contiene el máximo valor de intensidad de la última imagen capturada
     MinIntensityValue:Integer; // Contiene el mínimo valor de intensidad de la última imagen capturada

     public
      constructor Create(IFileName:String);
      destructor Destroy;
      procedure GetImage(BP:TBitmap32;DF,BF:Boolean;NumIm,XDim,YDim:Integer;ExTime:Double);
      procedure SetResolutionBits;
      procedure SetResolutionX(NCol:Integer);
      procedure SetResolutionY(NRow:Integer);
      procedure SetTargetTemperature(T:Double);
      function  GetTemperature:Double;
      procedure GoToAmbient;
      procedure TemperatureControlOff;
      function  GetControlTemperatureStatus:ShortString;
      procedure GetDarkFrame;
      procedure GetBiasFrame;
      procedure SetTimeExposure(T:Double);
      procedure Setlight(L:Boolean);
      function  IsPresent:Boolean;
      procedure GetInitialTemperature(Ti:Single);
      procedure Focus(T:Double;Light:Boolean;XDim,YDim:Integer;Iview:TImgView32);
      property  IniTemperature:Single read InitialTemperature;
      property  MaxIntensity: Integer read MaxIntensityValue;
      property  MinIntensity: Integer read MinIntensityValue;

end;
type
    TStageControl=class
     private
      DeltaX:Double; // Valores de desplazamiento para las cordenadas X,Y y Z.
      DeltaY:Double;
      DeltaZ:Double;

      MinDeltaX:Double; // Mínimos valores permitidos para los despalazamientos
                        // en las direcciones X,Y,Z.
      MinDeltaY:Double;
      MinDeltaZ:Double;

      MaxDeltaX:Double;// Máximos valores permitidos para los despalazamientos
                       // en las direcciones X,Y,Z.
      MaxDeltaY:Double;
      MaxDeltaZ:Double;

      SpeedX:Double; //Velocidades de los desplazamientos en las
                     //direcciones X,Y,Z.
      SpeedY:Double;
      SpeedZ:Double;

      MaxSpeedX:Double;// Máximas velocidades permitidas en
                       //las direcciones X,Y,Z.
      MaxSpeedY:Double;
      MaxSpeedZ:Double;

      MinSpeedX:Double;// Mínimas velocidades permitidas en
                       //las direcciones X,Y,Z.
      MinSpeedY:Double;
      MinSpeedZ:Double;

      Dirdata, DirStatus,Dircontr : Word;{Dirección del Puerto Paralelo}
      DataIni,ContIni,StatusIni : Byte;

      DataToMoveUp:Array[1..4] of Byte;
      DataToMoveDown:Array[1..4] of Byte;
      Ticks:Int64;
      CPUClock: extended;
      Freq:Int64;// frecuencia del contador de alta resolución

      procedure Delay(T:Double);overload;// T en microsegundos
      procedure Calibrate;
      function getport(p:word):byte; stdcall; //función para acceso al puerto
               // paralelo lee el puerto.

      procedure Setport(p:word;b:byte);Stdcall;//procedimiento para acceso
                //al puerto, escribe el puerto.



     protected

     public
      constructor Create(DirBasePort:Word);
      destructor Destroy;
      procedure MoveUp(T:Double);overload;
      procedure MoveDown(T:Double);overload;
      procedure MoveLeft;
      procedure MoveRight;
      procedure MoveClose;
      procedure MoveFar;

end;

implementation
////////////////////////////////////////////////////////////////////////////////
///////// CLASE TAM4CONTROL
////////////////////////////////////////////////////////////////////////////////

constructor TAM4Control.Create(IFileName:String);
 begin
  IniFileName:=IFileName;
  Cam:=CoCamera.Create;
  Cam.Init(IniFileName,-1,-1);
  if Cam.Present then
   begin
    Cam.OptionBase:=False;
    CameraDetected:=True;
    Cam.CoolerMode:= Camera_CoolerMode_Off;
    Light:=Cam.Shutter;
    ExposeTime:=0.2;
   end
  else CameraDetected:=False;
  DarkFrame:=TByteMap.Create;
  DarkFrame.SetSize(768,512);
  DarkFrame.Clear(0);
  CurrentImage:=TByteMap.Create;
  CurrentImage.SetSize(768,512);
  CurrentImage.Clear(0);
end;

destructor TAM4Control.Destroy;
 begin
  if not(CurrentImage=nil) then CurrentImage.Destroy;
  if not(DarkFrame=nil) then DarkFrame.Destroy;
  if not(FlatFrame=nil) then FlatFrame.Destroy;
 end;

procedure TAM4Control.GetImage(BP:TBitmap32;DF,BF:Boolean;NumIm,XDim,YDim:Integer;ExTime:Double);

type
 PArrayImage=^TArrayImage;
 TArrayImage=array [0..511,0..767] of Word;
var
 ImVar:OleVariant;
 i,j,k:Integer;
 P:PArrayImage;
begin
 MaxIntensityValue:=0;
 MinIntensityValue:=255;
 if DF then
  begin
   Cam.Expose(ExTime,False);
   Repeat
   until Cam.Status=Camera_Status_ImageReady;
   ImVar:=Cam.Image;
   DarkFrame.Clear(0);
   DarkFrame.SetSize(XDim,YDim);

   for i:=0 to YDim-1 do
    begin
     for j:=0 to XDim-1  do
      begin
      DarkFrame.Value[j,i]:=trunc(ImVar[j,i] shl 6);
      end;
    end;
   end
 else DarkFrame.Clear(0);

 SetLight(True);
 CurrentImage.Clear(0);
 CurrentImage.SetSize(XDim,YDim);
 ExposeTime:=ExTime;
 for k:=1 to NumIm do
  begin
   Cam.Expose(ExposeTime,true);
   Repeat
   until Cam.Status=Camera_Status_ImageReady;
   ImVar:=Cam.Image;
   P:=VarArrayLock(ImVar);
   try
    for i:=0 to YDim-1 do
     begin
      for j:=0 to XDim-1  do
       begin
        CurrentImage.Value[j,i]:= trunc(CurrentImage.Value[j,i] + P^[i,j]/(64*NumIm))- DarkFrame.Value[j,i];
        MaxIntensityValue:=Max(MaxIntensityValue,CurrentImage.Value[j,i]);
        MinIntensityValue:=Min(MinIntensityValue,CurrentImage.Value[j,i]);
       end;
     end;
   finally

   VarArrayUnlock(ImVar);
   end;
  end;
 VarClear(ImVar);
 CurrentImage.WriteTo(BP,ctUniformRGB);

end;

procedure TAM4Control.SetResolutionBits;
 begin
  if Cam.Present then ResolutionBits:=Cam.DataBits;
 end;
procedure TAM4Control.SetResolutionX(NCol:Integer);
 begin
  //if Cam.Present then
   //begin

    //Cam.ImgColumns:=NCol;
    //ResolutionX:=NCol;
   //end;

 end;

procedure TAM4Control.SetResolutionY(NRow:Integer);
 begin
  // if Cam.Present then
  // begin
  // Cam.ImgRows:=NRow;
  // ResolutionY:=NRow;
  //end;
 end;
procedure TAM4Control.SetTargetTemperature(T:Double);
 begin

  Cam.CoolerMode:=Camera_CoolerMode_On;
  Cam.CoolerSetPoint:=T;

  // TargetTemperature:=T;
end;

function TAM4Control.GetTemperature:Double;
 begin
  result:=Cam.Temperature;
 end;
procedure TAM4Control.GoToAmbient;
 begin
  Cam.CoolerMode:= Camera_CoolerMode_Shutdown;
 end;
procedure TAM4Control.TemperatureControlOff;
begin
 Cam.CoolerMode:= Camera_CoolerMode_Off;
end;
function  TAM4Control.GetControlTemperatureStatus:ShortString;
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

procedure TAM4Control.GetDarkFrame;
begin
end;
procedure TAM4Control.GetBiasFrame;
begin
end;
procedure TAM4Control.SetTimeExposure(T:Double);
 begin
   ExposeTime:=T;
 end;
procedure TAM4Control.Setlight(L:Boolean);
 begin
  Light:=L;
 end;

procedure TAM4Control.Focus(T:Double;Light:Boolean;XDim,YDim:Integer;Iview:TImgView32);

type
 PArrayImage=^TArrayImage;
 TArrayImage=array [0..511,0..767] of Word;
var
 ImVar:OleVariant;
 i,k,j:Integer;
 P:PArrayImage;
begin

Cam.FastReadout:=True;
Cam.HighPriority:=True;
for k:=1 to 5 do
 begin
 Cam.Expose(T,true);
 ImVar:=Cam.Image;
 P:=VarArrayLock(ImVar);
 try
  for i:=0 to YDim-1 do
   begin
    for j:=0 to XDim-1  do
     begin
      IView.Bitmap.PixelS[i,j]:=Gray32(trunc(P^[i,j] shr 6));
     end;
   end;
   IView.Refresh;
  finally
   VarArrayUnlock(ImVar);
  end;
 end;
 Cam.FastReadout:=False;
 Cam.HighPriority:=False;
 VarClear(ImVar);


end;
function  TAM4Control.IsPresent:Boolean;
 begin
  result:=CameraDetected;
 end;
procedure TAM4Control.GetInitialTemperature(Ti:Single);
 begin
  InitialTemperature:=Ti;
 end;
////////////////////////////////////////////////////////////////////////////////
///////// CLASE TStageControl
////////////////////////////////////////////////////////////////////////////////

function TStageControl.getport(p:word):byte; stdcall;
 begin
  asm
   push edx
   push eax
   mov  dx,p
   in   al,dx
   mov  @result,al
   pop  eax
   pop  edx
  end;
 end;


procedure TStageControl.Setport(p:word;b:byte);Stdcall;
 begin
  asm
   push  edx
   push  eax
   mov   dx,p
   mov   al,b
   out   dx,al
   pop   eax
   pop   edx
  end;
 end;
constructor TStageControl.Create(DirBasePort:Word);
 var
  i:integer;
  ti:cardinal;
 begin

  Dirdata  := DirBasePort; // Dirección del Puerto Paralelo por defecto.
  DirStatus:= DirBasePort+1; // Dirección Registro de Estado del puerto Paralelo.
  Dircontr := DirBasePort+2; //  Dirección del Registro de Control del Puerto Paralelo.
  try
   statusIni  := getport(DirStatus);
  except
    on E: EExternal do
     begin
      MessageDlg('El control de Platina'+ #13+
                 'no puede ser Inicializado',mtInformation, [mbOk], 0);
      exit;
     end
   end;
  ContIni  := getport(Dircontr); {guarda configuración inicial del puerto}
  DataIni  := getport(DirData);
  Setport(Dircontr,2+4); {asegura configurar el puerto como unidireccional y
                          desabilita el pulsador}
  Setport(Dirdata ,0); {Pone todos los bits del port de datos a cero}

  DataToMoveUp[1]:=1;
  DataToMoveUp[2]:=2;
  DataToMoveUp[3]:=4;
  DataToMoveUp[4]:=8;

  DataToMoveDown[1]:=8;
  DataToMoveDown[2]:=4;
  DataToMoveDown[3]:=2;
  DataToMoveDown[4]:=1;
  Calibrate;
 end;
destructor TStageControl.Destroy;
 begin
  Setport(Dircontr,ContIni); {dejar puertos como estaban al inicio del programa}
  Setport(Dirdata ,DataIni); {                 "                      }
 end;
procedure TStageControl.Calibrate;
begin
QueryPerformanceFrequency(Freq);
end;
procedure TStageControl.Delay(T:Double);// T en microsegundos
var
c2,c1:Int64;
i:integer;
begin
QueryPerformanceCounter(c1);
for i:=1 to 2147483647 do
 begin
   QueryPerformanceCounter(c2);
   if ((c2-c1)/T)>= (Freq/1000000) then break;
 end;
end;

procedure TStageControl.MoveUp(T:Double);
begin
  Delay(T);
  SetPort(DirData,DataToMoveUp[1]);
  Delay(T);
  SetPort(DirData,DataToMoveUp[2]);
  Delay(T);
  SetPort(DirData,DataToMoveUp[3]);
  Delay(T);
  SetPort(DirData,DataToMoveUp[4]);
end;
procedure TStageControl.MoveDown(T:Double);
 begin
  Delay(T);
  SetPort(DirData,DataToMoveDown[1]);
  Delay(T);
  SetPort(DirData,DataToMoveDown[2]);
  Delay(T);
  SetPort(DirData,DataToMoveDown[3]);
  Delay(T);
  SetPort(DirData,DataToMoveDown[4]);
 end;

procedure TStageControl.MoveLeft;
 begin
 end;

procedure TStageControl.MoveRight;
 begin
 end;

procedure TStageControl.MoveClose;
 begin
 end;

procedure TStageControl.MoveFar;
 begin
 end;







end.

