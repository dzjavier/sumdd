unit LightMonitor;

interface

uses cAudioIn,math,ndlink,forms,windows,sysutils,ProgressActivity,dialogs;

const

CALIBRATED_DOSE = 0.5; // dosis calibrada en un seg

type TDynamicDoubleArray = array of Double;

type

 UVLightMonitor=class

  public
   constructor create;
   function    getLightLevel: double;
   destructor  destroy;reintroduce;
   procedure   setLigthRecorderSwitch(const TurnOn:boolean);  // when true resets buffers
   procedure   getLigthRecorded(var RepData: TDynamicDoubleArray);
   procedure   getSpectrum(var Data: TDynamicDoubleArray);
   function    getLigthRecordedSamplesNumber : integer;
   procedure   setExpositionTime(const TExp: Double);
   function    getDosis:double;
   function    getLigthRecorderSwitch: boolean;
   function    getExpostionTime: double;

   procedure   applyLowPassFilter(var Data: TDynamicDoubleArray; const filterWeight:single = 1.5);
   procedure   getRawWaveData(var Data: TDynamicDoubleArray);
   procedure   Calibrate; // calibra dosis a 1 sec
   function    getCalibrateDose: single;
   procedure   saveForLongTermRegister(filename:string);

  private
   LigthRecorderSwitch: boolean;
   LightRecorded, WaveData,Spectrum : TDynamicDoubleArray;
   RecordedSamplesNumber:integer;
   MainFreq: double; // Main frec obtained using fft
   LightLevel:double; // corrección a MainFreq por exponencial: 325.39x2.32^v // calibrado en el circuito
   LightIn: TAudioIn;
   ExpositionTime: double;
   CalibratedDose: single;
   procedure OnBufferDone(const Buffer: Pointer; const Size: Integer);

end;

procedure HanningWindow(var w: TDynamicDoubleArray; const n: integer);

var
 UVMon:UVLightMonitor;
implementation

constructor UVLightMonitor.Create;
 begin
  LightIn := TAudioIn.Create;
  LightIn.OnBufferDone  := Self.OnBufferDone;
  SetLength(WaveData,LightIn.NSamples);
  LightIn.Open;
  LightIn.Start;
  LigthRecorderSwitch:=false;
  MainFreq:=0;
//  Calibrate;
end;
procedure UVLightMonitor.Calibrate;
var

 freq,ti,tf:int64;
 j:integer;
 begin
  if FActivityProgress = nil then FActivityProgress:=TFActivityProgress.Create(nil);
  FActivityProgress.Caption:='Calibrando monitor UV';
  FActivityProgress.Visible:=true;
  QueryPerformanceFrequency(freq);
  setExpositionTime(1.0);
  CalibratedDose:=0;
  for j := 1 to 10 do
   begin
    setLigthRecorderSwitch(true);
    QueryPerformanceCounter(ti);
    tf:=ti;
    while ((tf-ti)/freq)<1.0 do
     begin
       // nothing
      QueryPerformanceCounter(tf);
     end;
    setLigthRecorderSwitch(false);
    CalibratedDose:=CalibratedDose+getDosis/10;
    FActivityProgress.PBActivityProgress.Position:=trunc(j*10);
    FActivityProgress.LProgress.Caption:= FloatToStrF(j*10,ffGeneral,3,3)+'%';
    Application.ProcessMessages;
   end;// end for
  FActivityProgress.Visible:=false;
  FActivityProgress.PBActivityProgress.Position:=0;
  FActivityProgress.Visible:=false;
  MessageDlg('Dosis obtenida: '+floattostr(CalibratedDose),mtInformation, [mbOk], 0);
  end;

function UVLightMonitor.getCalibrateDose:single;
 begin
  result:=CalibratedDose;
 end;
 procedure UVLightMonitor.SetLigthRecorderSwitch(const TurnOn:boolean);
begin
 LigthRecorderSwitch:=TurnOn;
 if LigthRecorderSwitch then
  begin
   SetLength(LightRecorded,0);
   RecordedSamplesNumber:=0;
  end;
end;

function  UVLightMonitor.GetLigthRecorderSwitch: boolean;
 begin
  result:= LigthRecorderSwitch;
 end;

function  UVLightMonitor.GetLigthRecordedSamplesNumber : integer;
 begin
  result:= RecordedSamplesNumber;
 end;

procedure UVLightMonitor.GetLigthRecorded(var RepData: TDynamicDoubleArray);
begin
   RepData:=LightRecorded;
end;

procedure UVLightMonitor.OnBufferDone(const Buffer: Pointer; const Size: Integer);
 var
  pbuffer: PSmallInt;
  counter,j:cardinal;
  aux: TDynamicDoubleArray;
  val: double;
  ldn: array [0..4] of UINT;
 begin
   pbuffer:=PSmallInt(Buffer);
   //HanningWindow(aux,LightIn.NSamples);
   for j:=0 to LightIn.NSamples-1 do
   begin
    WaveData[j]:=(pbuffer^);
//     WaveData[j]:=(pbuffer^)*aux[j]; // ventaneo, en caso que sea necesario
                                      // ajustar el número de ventanas
    inc(pbuffer);
   end;


  applyLowPassFilter(WaveData,2.7); // filtrado pasa bajos
  setlength(aux,LightIn.NSamples);
  ZeroMemory(PDouble(aux),LightIn.NSamples*8);
  ldn[0]:=ldn2(LightIn.NSamples);
  try
   ndim_fft(PDouble(@WaveData[0]),PDouble(@aux[0]),1,PUINT(@ldn[0]));
  except raise
  end;
  counter:=0;
  SetLength(Spectrum,LightIn.NSamples div 2);
  val:=( sqr(WaveData[0])+sqr(aux[0]));
  spectrum[0]:=( sqr(WaveData[0])+sqr(aux[0]));
  for j := 1 to High(WaveData) div 2 do // sólo utilizar la mitad de muestras
   begin
    spectrum[j]:=( sqr(WaveData[j])+sqr(aux[j]));
    if val < spectrum[j] then // Busco máxima potencia
     begin
      val:= spectrum[j];
      counter:=j;
     end;
   end;
  MainFreq:=(counter*LightIn.SamplesPerSec/LightIn.NSamples); // esto anda al pelo...
  LightLevel:=log10(MainFreq/300)/log10(2.87);
  if LigthRecorderSwitch then
   begin
    inc(RecordedSamplesNumber);
    SetLength(LightRecorded,RecordedSamplesNumber);
    LightRecorded[high(LightRecorded)]:=LightLevel;
   end;
end;

procedure UVLightMonitor.SetExpositionTime(const TExp: Double);
 begin
  ExpositionTime:=Texp;
 end;

function UVLightMonitor.GetDosis:double;
 var
  j:integer;
  h,Dosis:double;
 begin
 // integración numérica con polinomio de orden 1...
 if RecordedSamplesNumber>=3 then
  begin

   Dosis:=LightRecorded[low(LightRecorded)]+LightRecorded[high(LightRecorded)];
   for j:=low(LightRecorded)+1 to  high(LightRecorded)-1 do
    begin
     Dosis:=Dosis+2*LightRecorded[j];
    end;
    h:=ExpositionTime / (RecordedSamplesNumber-1);// paso de integración
    result:=Dosis*h*0.5;
  end
 else result:=0;
 end;

function UVLightMonitor.getLightLevel: double;
 begin
  result:=LightLevel;
 end;

destructor UVLightMonitor.Destroy;
begin
  try
    // stop and free mem
    if LightIn.Recording then begin
      LightIn.Stop;
      LightIn.Close;
    end;
  finally
    LightIn.Destroy;
  end;
end;

procedure HanningWindow(var w: TDynamicDoubleArray; const n: integer);
 var
  n1,n2,j:integer;
 begin
  n1:=Floor(1/2*n);
  n2:=n-2*n1;
  setlength(w,n);
  for j:=0 to n do
   begin
    if (j+1)<=n1 then
      w[j]:=0.5*(1-cos(2*PI*(j+1)/(n+1)));
    if ((j+1)>n1) and ((j+1)<=n2) then w[j]:=1;

    if (j+1)>n2 then w[j]:=0.5*(1-cos(2*PI*(n-(j+1))/(n+1)));
   end;


 end;

procedure UVLightMonitor.getSpectrum(var Data: TDynamicDoubleArray);
 begin
  Data:=spectrum;
 end;

procedure UVLightMonitor.applyLowPassFilter(var Data: TDynamicDoubleArray;const filterWeight:single = 1.5);
 var
  j: integer;
  aux:TDynamicDoubleArray;
 begin
  SetLength(aux,high(Data));
  CopyMemory(@aux[0],@data[0],LightIn.NSamples);
  for j:= low(Data) to high(Data)-1 do
     data[j+1]:= data[j]+(aux[j]-data[j])/filterWeight;
 end;

procedure  UVLightMonitor.getRawWaveData(var Data: TDynamicDoubleArray);
 begin
  Data:=WaveData;
 end;
function    UVLightMonitor.getExpostionTime: double;
begin
  result:=ExpositionTime;
end;
procedure   UVLightMonitor.saveForLongTermRegister(filename:string);
var
UVlog:textfile;
 begin
  Calibrate;
  AssignFile(UVlog,filename);
  try
   Append(UVlog);
  except on E: EInOutError do
   Rewrite(UVlog);
  end;
  writeln(UVlog,floattostrf(CalibratedDose,ffGeneral,6,4),' ',DateTimeToStr(Now));
  CloseFile(UVLog);
 end;
end.
