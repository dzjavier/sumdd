unit StageControl;

interface
uses SysUtils,Dialogs,Windows;
type
 Stage=class
  // Motor RS 440-436 1 paso equivale a 1.8 grados
  // Posee caja reductora 1:100
  private
    Dirdata, DirStatus,Dircontr : Word;{Dirección del Puerto Paralelo}
    DataIni, ContIni,StatusIni : Byte;
    DataToMoveUp:Array[1..4] of Byte;
    DataToMoveDown:Array[1..4] of Byte;
    Freq:Int64;// Frecuencia del contador de alta resolución
    procedure Delay(const Speed:Single=1);inline;// T en microsegundos

    function getport(p:word):byte; stdcall; //función para acceso al puerto
    // paralelo lee el puerto.
    procedure Setport(p:word;b:byte);Stdcall;//procedimiento para acceso
    // al puerto, escribe el puerto.
    procedure MoveFourStepsUp(const Speed:Single=1);
    procedure MoveFourStepsDown(const Speed:Single=1);
    procedure Calibrate;
  protected

  public
    constructor Create(const DirBasePort:Word);
    destructor Destroy;reintroduce;overload;
    procedure Move(const DeltaZ: Single; const Speed:Single = 1);
    procedure MoveUp(const DeltaZ:Single; Speed:Single = 1); // Speed puede cambiar
    procedure MoveDown(const DeltaZ:Single; Speed:Single = 1);  // Speed puede cambiar

  end;
var
 Stg:Stage;
implementation

function Stage.getport(p:word):byte; stdcall;
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

procedure Stage.Setport(p:word;b:byte);Stdcall;
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

constructor Stage.Create(const DirBasePort:Word);
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
  Calibrate();
 end;

procedure Stage.Calibrate;
 begin
  QueryPerformanceFrequency(Freq);
 end;

destructor Stage.Destroy;
 begin
  Setport(Dircontr,ContIni); {dejar puertos como estaban al inicio del programa}
  Setport(Dirdata ,DataIni); {                 "                      }
 end;

procedure Stage.Delay(const Speed:Single=1); // T en microsegundos
var
 Counts,c2,c1:Int64;
 i:integer;
begin
 QueryPerformanceCounter(c1);
 Counts:=trunc((3000/Speed)*Freq/1000000); // 3000/Speed para lograr aprox. 1 um/seg
 for i := 0 to MaxInt do
  begin
   QueryPerformanceCounter(c2);
   if (c2-c1)>= Counts then break;
  end;
end;

procedure Stage.MoveFourStepsUp(const Speed:Single=1);
 begin
  SetPort(DirData,DataToMoveUp[1]);
  Delay(Speed);
  SetPort(DirData,DataToMoveUp[2]);
  Delay(Speed);
  SetPort(DirData,DataToMoveUp[3]);
  Delay(Speed);
  SetPort(DirData,DataToMoveUp[4]);
  Delay(Speed);
 end;

procedure Stage.MoveFourStepsDown(const Speed:Single=1);
 begin
  SetPort(DirData,DataToMoveDown[1]);
  Delay(Speed);
  SetPort(DirData,DataToMoveDown[2]);
  Delay(Speed);
  SetPort(DirData,DataToMoveDown[3]);
  Delay(Speed);
  SetPort(DirData,DataToMoveDown[4]);
  Delay(Speed);
 end;

procedure Stage.Move(const DeltaZ:Single; const Speed:Single=1);
// DeltaZ en micrómetros
 begin
  if DeltaZ<0 then    MoveUp(abs(DeltaZ),Speed)
  else MoveDown(DeltaZ,Speed);
end;

procedure Stage.MoveUp(const DeltaZ:Single; Speed:Single = 1);
var
 MaxSteps,i:integer;
begin

 if (Speed>1.70) or (Speed<0.8)then
   begin
     MessageDlg('Velocidad entre 0.8 y 1.7 um/s',mtWarning,[mbOK],0);
     Speed:=1;
   end;

 if abs(DeltaZ)<0.050 then
  begin
   MessageDlg('El menor desplazamiento permitido es 0.050 um',mtWarning,[mbOK],0);
  end
 else
  begin
   MaxSteps:=trunc(abs(DeltaZ)*50);
   for i := 1 to  MaxSteps do
     MoveFourStepsUp(Speed);
  end;
 end;

procedure Stage.MoveDown(const DeltaZ:Single; Speed:Single = 1);
 var
  MaxSteps,i:integer;
 begin
   if (Speed>1.70) or (Speed<0.8)then
   begin
     MessageDlg('Velocidad entre 0.8 y 1.7 um/s',mtWarning,[mbOK],0);
     Speed:=1;
   end;
  if abs(DeltaZ)<0.050 then
   begin
    MessageDlg('El menor desplazamiento permitido es 0.050 um',mtWarning,[mbOK],0);
   end
  else
   begin
    MaxSteps:=trunc(abs(DeltaZ)*50); // 1000 / 20
    for i := 1 to  MaxSteps do
      MoveFourStepsDown(Speed);
   end;
 end;

end.
