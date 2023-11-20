unit DecTypes;

{Unit de declaración de tipos; Implementación de algunos métodos directamente
asociados con la declaración de estos tipos de datos}

interface

uses
 math,
 Forms,
 SysUtils,
 Windows,
 ProgressActivity,
 dglOpenGL,
 //OpenGL12,
 TofyLink;


type TComplex = record
    	Re:TReal;
    	Im:TReal;
end;
type

 TImageArray = array of array of Word;

 TRawData = array of double;
 
 TSignal = array of TComplex;

 TSignal2D = array of TSignal;

 TSignal3D = array of TSignal2D;

 TVector = array of Double;

 TSectioningData = record // Tipo de dato generado para guardar informacion acerca del
               //el seccionamiento que se encuentra en un archivo.

  FileRoot:ShortString;
  Header:ShortString;
  IniNumber:Integer;
  NumberOfSections:Integer;
  FormatFileSection:ShortString;
  XDimension:Integer;
  YDimension:Integer;
  BitsResolution:Integer;
  ExpositionTime:Real;
  DeltaZ:Real; // Espesor del seccionamiento en micras

  Specimen:ShortString;
  Author:ShortString;
  Date:ShortString;
  ImersionOil:ShortString; // Índice de Refración
  Tile:ShortString; // Marcador Fluorescente
  AntiBody:ShortString; // Anticuerpo utilizado para la marcación
  Magnification:Real;
  OjectiveLens:Real;


  Deconvolved:Boolean;
  DeconvAlgorithm:ShortString;
  OriginalFileSections:ShortString;
  OriginalFileRoot:ShortString;
  OriginalHeader:ShortString;
  OriginalIniNumber:Integer;
  OriginalNumberOfSections:Integer;
  OriginalFormatFileSection:ShortString;

 end;

 type TWordArray = array of Word; // Se va a utilzar para tener el volumen
                                  // Crudo y desconvolucionado. Es mas fácil para representar
                                  //los  Datos, además ocupa menos memoria;

 type TFloatArray = array of Single; // Se va a utilzar para tener el volumen
                                  // Crudo y desconvolucionado. Es mas fácil para representar
                                  //los  Datos, además ocupa menos memoria;


 FSectioningData = File of TSectioningData;

 T3DVertex = array [1..3] of GLFloat;
 T3DVectorVertex = array of T3DVertex;

 T3DColor = array [1..3] of GLubyte;
 T3DColorVector = array of T3DColor;




{Declaración de algunas funciones relacionadas directamente con los tipos
 declarados}

procedure SetDimension(var S: TSignal;Y:Integer);
procedure Set2DDimension(var S: TSignal2D;X,Y:Integer);
procedure Set3DDimension(var S: TSignal3D;Z,X,Y:Integer);


function MaxTSignalABS(DataIn:TSignal):Single; // Devuelve el máximo valor del
                                             // Vector DataIn en Valor Absoluto
function MaxTSignalIndex(DataIn:TSignal):Integer;// Devuelve el índice del máximo valor del

function MaxTSignal3DABS(DataIn:TSignal3D;DimDep,DimCol,DimRow:Integer):Single;

function MinTSignal3DABS(DataIn:TSignal3D;DimDep,DimCol,DimRow:Integer):Single;

function MinTSignalABS(DataIn:TSignal):Single; // Devuelve el mínimo valor del
                                             // Vector DataIn en Valor Absoluto
function MinTSignalIndex(DataIn:TSignal):Integer;// Devuelve el índice del mínimo valor del
                                             // Vector DataIn
                                             // Vector DataIn

function MaxTSignal2DABS(DataIn:TSignal2D;DimCol,DimRow:Integer):Single;

// Methods for the TVector Type

//procedure TVectorByAConstant(V: TVector; const c: Double);

//End of Methods for the TVector Type
function SumTSignal(DataIn:TSignal):Double;
function SumTSignal2D(DataIn:TSignal2D):Double;
function SumTSignal3D(DataIn:TSignal3D):Double;


procedure InsertElement(var DataIn:TSignal;NewData:TComplex;Index:Integer);
procedure DeleteElement(var DataIn:TSignal;Index:Integer);
procedure Sort(DataIn,DataOut:TSignal;Ascendent:Boolean);

{ Método que organiza los datos de un vector en forma ascente o descendente
respecto del valor absoluto}

procedure SortUpTo(DataIn:TSignal; var DataOut:TSignal;Ascendent:Boolean;MinMaxValue:Single);
{ Método que organiza los datos de un vector en forma ascendente o descendente
respecto del valor absoluto pero lo hace hasta un valor determinado por MinMaxValue}

procedure TSignalQuickSort(var DataIn:array of TComplex;iLo,iHi:Integer;H2L:Boolean;Phase:Boolean);
procedure QSort(var DataIn:array of TComplex;iLo,iHi:Integer;H2L:Boolean;Phase:Boolean);
{Método que ordena un vector de datos complejos. iHi e iLo: índices máximos y mínimo del
Vector de datos Complejos. H2L= True: ordena de mayor a menor, H2L= False: Ordena de menor a mayor;
Phase=True: Ordena respecto del Ángulo que existe entre la parte real y la imaginaria, Phase=FAlse:
ordena respecto del módulo del número complejo }

function  OpenSectioningFile(Directory:String):TSectioningData;
procedure SaveSectioningFile(D:TSectioningData;Directory:String);
function   MaxWordValue(const Data: TWordArray):Word;
function   MinWordValue(const Data: TWordArray):Word;

var
FActivityProgress: TFActivityProgress;
implementation

procedure SetDimension(var S:TSignal;Y:Integer);
var
 j:Integer;
begin
 SetLength(S,Y);
 for j:=0 to Y-1 do
  begin
   S[j].Re:=0;
   S[j].Im:=0;
  end;
end;

procedure Set2DDimension(var S:TSignal2D;X,Y:Integer);
var
i:Integer;
 begin
 SetLength(S,X);
 for i:=0 to X-1 do
   SetDimension(S[i],Y);
 end;

procedure Set3DDimension(var S:TSignal3D;Z,X,Y:Integer);
var
i:Integer;
begin
 SetLength(S,Z);
 for i:=0 to Z-1 do
   Set2DDimension(S[i],X,Y)
end;

function OpenSectioningFile(Directory:String):TSectioningData;
 var
  Data:FSectioningData;
  begin
   AssignFile(Data,Directory);
   Reset(Data);
   Read(Data,Result);
   CloseFile(Data);
 end;

procedure SaveSectioningFile(D:TSectioningData;Directory:String);
 var
  Data:FSectioningData;
  begin
   AssignFile(Data,Directory);
   Rewrite(Data);
   write(Data,D);
   CloseFile(Data);
 end;

function MaxTSignalABS(DataIn:TSignal):Single;
var
 i:integer;
 begin
  Result:= sqrt(sqr(DataIn[0].Re) + sqr(DataIn[0].Im));
  for i:=1 to High(DataIn) do
   begin
    if sqrt(sqr(DataIn[i].Re) + sqr(DataIn[i].Im))> Result then
     begin
       Result:=sqrt(sqr(DataIn[i].Re) + sqr(DataIn[i].Im));
     end;
   end;
 end;

function MaxTSignalIndex(DataIn:TSignal):Integer;
var
 i:integer;
 aux:single;
 begin
  Result:=0;
  Aux:=sqrt(sqr(DataIn[0].Re) + sqr(DataIn[0].Im));
  for i:=1 to High(DataIn) do
   begin
    if sqrt(sqr(DataIn[i].Re) + sqr(DataIn[i].Im))> Aux then
     begin
       Result:=i;
       Aux:=sqrt(sqr(DataIn[i].Re) + sqr(DataIn[i].Im))
     end;
   end;
 end;

function MinTSignalABS(DataIn:TSignal):Single;
var
 i:integer;
 begin
  Result:= sqrt(sqr(DataIn[0].Re) + sqr(DataIn[0].Im));
  for i:=1 to Length(DataIn)-1 do
   begin
    if sqrt(sqr(DataIn[i].Re) + sqr(DataIn[i].Im))< Result then
     begin
       Result:=sqrt(sqr(DataIn[i].Re) + sqr(DataIn[i].Im));
     end;
   end;
 end;

function MinTSignalIndex(DataIn:TSignal):Integer;
var
 i:integer;
 aux:single;
 begin
  Result:=0;
  Aux:=sqrt(sqr(DataIn[0].Re) + sqr(DataIn[0].Im));
  for i:=1 to High(DataIn) do
   begin
    if sqrt(sqr(DataIn[i].Re) + sqr(DataIn[i].Im))< Aux then
     begin
       Result:=i;
       Aux:=sqrt(sqr(DataIn[i].Re) + sqr(DataIn[i].Im))
     end;
   end;
 end;

function MaxTSignal3DABS(DataIn:TSignal3D;DimDep,DimCol,DimRow:Integer):Single;
var
 i,j,k:integer;
 aux:single;
 begin
  Aux:=sqrt(sqr(DataIn[0,0,0].Re) + sqr(DataIn[0,0,0].Im));
  for k:=1 to DimDep -1 do
   for i:=1 to DimRow -1 do
    for j:=1 to DimCol -1 do
      if sqrt(sqr(DataIn[k,j,i].Re) + sqr(DataIn[k,j,i].Im))> Aux then
         Aux:=sqrt(sqr(DataIn[k,j,i].Re) + sqr(DataIn[k,j,i].Im));
   Result:=Aux;
 end;

function MinTSignal3DABS(DataIn:TSignal3D;DimDep,DimCol,DimRow:Integer):Single;
 var
  i,j,k:integer;
  aux:single;
 begin
  Aux:=sqrt(sqr(DataIn[0,0,0].Re) + sqr(DataIn[0,0,0].Im));
  for k:=1 to DimDep -1 do
   for i:=1 to DimRow -1 do
    for j:=1 to DimCol -1 do
      if sqrt(sqr(DataIn[k,j,i].Re) + sqr(DataIn[k,j,i].Im))< Aux then
         Aux:=sqrt(sqr(DataIn[k,j,i].Re) + sqr(DataIn[k,j,i].Im));
   Result:=Aux;
 end;

procedure Sort(DataIn,DataOut:TSignal;Ascendent:Boolean);
 var
  ind,j:Integer;
  Aux:TSignal;
 begin
  SetDimension(Aux,Length(DataIn));
  for j:=0 to Length(DataIn)-1 do Aux[j]:=DataIn[j];
  for j:=0 to Length(DataIn)-1 do
   begin
    if ascendent then
     begin
      ind:=MaxTSignalIndex(Aux);
      DataOut[j].Re:=MaxTSignalABS(Aux);
     end
     else
      begin
       ind:=MinTSignalIndex(Aux);
       DataOut[j].Re:=MinTSignalABS(Aux);
      end;
    DeleteElement(Aux,ind);
   end;
  Aux:=nil;
 end;

procedure SortUpTo(DataIn:TSignal; var DataOut:TSignal;Ascendent:Boolean;MinMaxValue:Single);
 var
  ind,j:Integer;
  MaxMinVal:Single;
  Aux:TSignal;
 begin
  FActivityProgress:= TFActivityProgress.Create(Application);
  FActivityProgress.Caption:= 'Ordenando Datos';
  FActivityProgress.Show;

  SetDimension(Aux,Length(DataIn));
  for j:=0 to Length(DataIn)-1 do Aux[j]:=DataIn[j];
  for j:=0 to Length(Aux)-1 do
   begin
    if not(ascendent) then
     begin
      ind:=MaxTSignalIndex(Aux);
      MaxMinVal:=MaxTSignalABS(Aux);
      Application.ProcessMessages;
      FActivityProgress.PBActivityProgress.Position:=Trunc((1-(abs(MaxMinVal-MinMaxValue)/MaxMinVal))*100);
      FActivityProgress.LProgress.Caption:=FormatFloat('##.##%',(1-(abs(MaxMinVal-MinMaxValue)/MaxMinVal))*100);
      if not FActivityProgress.Visible then exit;
      if MaxMinVal < MinMaxValue  then break;
      SetLength(DataOut,j+1);
      DataOut[j].Re:=MaxMinVal;
      if High(Aux)<=1 then break
       else DeleteElement(Aux,ind);
     end;
    if ascendent then
     begin
      ind:=MinTSignalIndex(Aux);
      MaxMinVal:=MinTSignalIndex(Aux);
      Application.ProcessMessages;
      FActivityProgress.PBActivityProgress.Position:=Trunc((1-(abs(MaxMinVal-MinMaxValue)/MinMaxValue))*100);
      FActivityProgress.LProgress.Caption:=FormatFloat('##.##%',(1-(abs(MaxMinVal-MinMaxValue)/MinMaxValue))*100);
      if not FActivityProgress.Visible then exit;      
      if  MaxMinVal > MinMaxValue then break;
      SetLength(DataOut,j+1);
      DataOut[j].Re:=MaxMinVal;
      if High(Aux)<=1 then break
       else DeleteElement(Aux,ind);
     end;
     FActivityProgress.Refresh;
    end; // end For
  FActivityProgress.Destroy;
  Aux:=nil;
 end;

procedure TSignalQuickSort(var DataIn:array of TComplex;iLo,iHi:Integer;H2L:Boolean;Phase:Boolean);
  // quick sort (recursive)
 begin
  QSort(DataIn, Low(DataIn), High(DataIn), H2L,Phase);
 end;

procedure QSort(var DataIn:array of TComplex;iLo,iHi:Integer;H2L:Boolean;Phase:Boolean);
 var
   Lo, Hi: Integer; // indexes
   MidPhase,MidABS: Double; // counter values
   T: TComplex;
 begin
  Lo := iLo;
  Hi := iHi;
  if Phase then
   begin
    MidPhase :=  ArcTan2 (DataIn[(Lo + Hi) div 2].Im,DataIn[(Lo + Hi) div 2].Re);
    if H2L then // Highest to Lowest
     begin
      repeat
       while ArcTan2(DataIn[Lo].Im,DataIn[Lo].Re) > MidPhase do Inc(Lo);
       while ArcTan2(DataIn[Hi].Im,DataIn[Hi].Re) < MidPhase do Dec(Hi);
       if Lo <= Hi then
        begin
         T := DataIn[Lo];
         DataIn[Lo] := DataIn[Hi];
         DataIn[Hi] := T;
         Inc(Lo);
         Dec(Hi);
        end;
      until Lo > Hi;
      if Hi > iLo then QSort(DataIn, iLo, Hi,H2L,Phase);
      if Lo < iHi then QSort(DataIn, Lo, iHi,H2L,Phase);
     end // if H2L
    else
     begin
      {repeat
       // de menor a mayor
       //while A[Lo].Count < Mid do Inc(Lo);
       //while A[Hi].Count > Mid do Dec(Hi);
       // de mayor a menor

       while A[Lo].Count > Mid do Inc(Lo);
       while A[Hi].Count < Mid do Dec(Hi);
       if Lo <= Hi then
        begin
         T := A[Lo];
         A[Lo] := A[Hi];
         A[Hi] := T;
         Inc(Lo);
         Dec(Hi);
        end;
      until Lo > Hi;
      if Hi > iLo then Sort(A, iLo, Hi);
      if Lo < iHi then Sort(A, Lo, iHi);}
     end // else H2L

   end // if Phase
  else
   begin
    if H2L then
     begin
      MidABS := sqrt(sqr(DataIn[(Lo + Hi) div 2].Re)+sqr(DataIn[(Lo + Hi) div 2].Im));
      repeat
       while sqrt(sqr(DataIn[Lo].Re)+sqr(DataIn[Lo].Im)) > MidABS do Inc(Lo);
       while sqrt(sqr(DataIn[Hi].Re)+sqr(DataIn[Hi].Im)) < MidABS do Dec(Hi);
       if Lo <= Hi then
        begin
         T := DataIn[Lo];
         DataIn[Lo] := DataIn[Hi];
         DataIn[Hi] := T;
         Inc(Lo);
         Dec(Hi);
        end;
      until Lo > Hi;
      if Hi > iLo then QSort(DataIn, iLo, Hi,H2L,Phase);
      if Lo < iHi then QSort(DataIn, Lo, iHi,H2L,Phase);

     end //if H2L
    else
     begin
     { MidABS := sqrt(sqr(DataIn[(Lo + Hi) div 2].Re)+sqr(DataIn[(Lo + Hi) div 2].Im));
      repeat
        // de menor a mayor
        //while A[Lo].Count < Mid do Inc(Lo);
        //while A[Hi].Count > Mid do Dec(Hi);
        // de mayor a menor
       while A[Lo].Count > Mid do Inc(Lo);
       while A[Hi].Count < Mid do Dec(Hi);
       if Lo <= Hi then
        begin
         T := A[Lo];
         A[Lo] := A[Hi];
         A[Hi] := T;
         Inc(Lo);
         Dec(Hi);
        end;
      until Lo > Hi;
      if Hi > iLo then Sort(A, iLo, Hi);
      if Lo < iHi then Sort(A, Lo, iHi);}

     end; // else H2L

   end;// else Phase

 end;

procedure InsertElement(var DataIn:TSignal;NewData:TComplex;Index:Integer);
 var
  i:Integer;
 begin
  Setlength(DataIn,Length(DataIn)+1);
  for i:=Length(DataIn)-1 downto Index-1 do
   DataIn[i]:=DataIn[i-1];
  DataIn[Index]:=NewData;
 end;

procedure DeleteElement(var DataIn:TSignal;Index:Integer);
 var
  i:Integer;
 begin
  for i:=Index to Length(DataIn)-2 do
   if Index=Length(DataIn)-1 then break
    else  DataIn[i]:=DataIn[i+1];
  Setlength(DataIn,Length(DataIn)-1);
 end;

function MaxTSignal2DABS(DataIn:TSignal2D;DimCol,DimRow:Integer):Single;
var
 i,j:integer;
 aux:single;
 begin
  Aux:=sqrt(sqr(DataIn[0,0].Re) + sqr(DataIn[0,0].Im));
  for i:=1 to DimRow -1 do
    for j:=1 to DimCol -1 do
      if sqrt(sqr(DataIn[j,i].Re) + sqr(DataIn[j,i].Im))> Aux then
         Aux:=sqrt(sqr(DataIn[j,i].Re) + sqr(DataIn[j,i].Im));
   Result:=Aux;
 end;

function SumTSignal(DataIn:TSignal):Double;
 var
  i: Integer;
 begin
  Result:=0;
  for i:=0 to length(DataIn)-1 do
    Result:= sqrt(sqr(DataIn[i].Re)+sqr(DataIn[i].Im))+Result;
 end;

function SumTSignal2D(DataIn:TSignal2D):Double;
 var
  i:Integer;
 begin
  Result:=0;
  for i:=0 to length(DataIn)-1 do
    Result:= SumTSignal(DataIn[i]) + Result;
 end;

function SumTSignal3D(DataIn:TSignal3D):Double;
 var
  i:Integer;
 begin
  Result:=0;
  for i:=0 to length(DataIn)-1 do
    Result:= SumTSignal2D(DataIn[i]) + Result;
 end;

function   MaxWordValue(const Data: TWordArray):Word;
var
  I: Word;
begin
  Result := Data[Low(Data)];
  for I := Low(Data) + 1 to High(Data) do
    if Result < Data[I] then
      Result := Data[I];
end;

function   MinWordValue(const Data: TWordArray):Word;
var
  I: Word;
begin
  Result := Data[Low(Data)];
  for I := Low(Data) + 1 to High(Data) do
    if Result > Data[I] then
      Result := Data[I];
end;
end.
