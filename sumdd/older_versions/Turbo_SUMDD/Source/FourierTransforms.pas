unit FourierTransforms;

interface

uses

  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtDlgs, ExtCtrls, StdCtrls, DecTypes,
  TofyLink, math, ndlink;

  procedure DirectFFTShifted(DataIn: TSignal ; DimCol:Integer; var DataOut:TSignal);
  procedure DirectFFT(DataIn: TSignal ; DimCol:Integer; var DataOut:TSignal);
  procedure InverseFFT(DataIn: TSignal ; DimCol:Integer; var DataOut:TSignal);
  procedure InverseFFTShifted(DataIn: TSignal ; DimCol:Integer; var DataOut:TSignal);
 
  procedure DirectFFTShiftednd(DataIn: TSignal ; DimCol:Integer; var DataOut:TSignal);
  procedure DirectFFTnd(DataIn: TSignal ; DimCol:Integer; var DataOut:TSignal);
  procedure InverseFFTnd(DataIn: TSignal ; DimCol:Integer; var DataOut:TSignal);
  procedure InverseFFTShiftednd(DataIn: TSignal ; DimCol:Integer; var DataOut:TSignal);
  
  procedure DirectFFT2DShifted(DataIn: TSignal2D ; DimCol,DimRow:Integer; var DataOut:TSignal2D);
  procedure DirectFFT2D(DataIn: TSignal2D ; DimCol,DimRow:Integer; var DataOut:TSignal2D);
  procedure InverseFFT2DShifted(DataIn: TSignal2D ; DimCol,DimRow:Integer; var DataOut:TSignal2D);
  procedure InverseFFT2D(DataIn: TSignal2D ; DimCol,DimRow:Integer; var DataOut:TSignal2D);
  
  procedure DirectFFT2DShiftednd(DataIn: TSignal2D ; DimCol,DimRow:Integer; var DataOut:TSignal2D);
  procedure DirectFFT2Dnd(DataIn: TSignal2D ; DimCol,DimRow:Integer; var DataOut:TSignal2D);
  procedure InverseFFT2DShiftednd(DataIn: TSignal2D ; DimCol,DimRow:Integer; var DataOut:TSignal2D);
  procedure InverseFFT2Dnd(DataIn: TSignal2D ; DimCol,DimRow:Integer; var DataOut:TSignal2D);


  procedure DirectFFT3DShifted(DataIn: TSignal3D ; DimCol,DimRow,DimDep:Integer; var DataOut:TSignal3D);
  procedure DirectFFT3D(DataIn: TSignal3D ; DimCol,DimRow,DimDep:Integer; var DataOut:TSignal3D);
  procedure InverseFFT3DShifted(DataIn: TSignal3D ; DimCol,DimRow,DimDep:Integer; var DataOut:TSignal3D);
  procedure InverseFFT3D(DataIn: TSignal3D ; DimCol,DimRow,DimDep:Integer; var DataOut:TSignal3D);

  { Other methods used to calculate FFTs  }

  function ldn2(const x: UINT): UINT;

implementation

function ldn2(const x: UINT): UINT;
 var
  i: UINT;
 begin
  i := x; Result := 0;
  while (i > 1) do begin
    i := i shr 1;
    inc(Result);
  end;

  //See if argument is power of two...
  if (x <> UINT(1) shl Result) then
    inc(Result); // not a power of two, make result = next pow of two.
end;


////////////////////////////////////FFT DIRECTAS /////////////////////////
/////////////////////////////FFT EN UNA DIMENSION ////////////////////////

procedure DirectFFTShifted(DataIn:TSignal; DimCol:Integer; var DataOut:TSignal);
var
 Aux:PVector;
 k,h,i:Integer;
 begin
  CreateVector(Aux,DimCol);
   // Llenado con ceros
  for i:=1 to DimCol do Aux[i]:=0;

  k:=1;
  h:=2;
  for i:=1 to (DimCol div 2) do
   begin
    Aux[k]:= DataIn[i-1].Re;
    Aux[h]:= DataIn[i-1].Im;
    k:=k+2;
    h:=h+2;
   end;
  FFT(Aux,NO_INVERT);

// Acomodar los datos para que la frecuencia cero quede centrada
  k:=1;
  h:=2;
  for i:=1 to DimCol div 2 do
   begin
    if h<= (DimCol div 2) then
     begin
      DataOut[i-1].Re:=Aux[k+ (DimCol div 2)];
      DataOut[i-1].Im:=Aux[h+ (DimCol div 2)];
      k:=k+2;
      h:=h+2;
     end
    else
     begin
      DataOut[i-1].Re:=Aux[k - (DimCol div 2)];
      DataOut[i-1].Im:=Aux[h - (DimCol div 2)];
      k:=k+2;
      h:=h+2;
     end;
   end;
   DestroyVector(Aux);
 end;

procedure DirectFFT(DataIn: TSignal ; DimCol:Integer; var DataOut:TSignal);
var
 Aux:PVector;
 k,h,i:Integer;
 begin
  CreateVector(Aux,DimCol);
  // Llenado con ceros
  for i:=1 to DimCol do Aux[i]:=0;
  k:=1;
  h:=2;
  for i:=1 to (DimCol div 2) do
   begin
    Aux[k]:= DataIn[i-1].Re;
    Aux[h]:= DataIn[i-1].Im;
    k:=k+2;
    h:=h+2;
   end;
  FFT(Aux,NO_INVERT); { esta función devuelve los datos reales intercalados
                                                   con los datos imaginarios}
// Acomodar los datos imaginarios y reales
  k:=1;
  h:=2;
  for i:=1 to DimCol div 2 do
   begin
    DataOut[i-1].Re:= Aux[k];
    DataOut[i-1].Im:= Aux[h];
    k:=k+2;
    h:=h+2;
   end;
   DestroyVector(Aux);
 end;

/////////////////////////FFT DIRECTAS EN DOS DIMENSIONES//////////////////////
procedure DirectFFT2DShifted(DataIn: TSignal2D ; DimCol,DimRow:Integer; var DataOut:TSignal2D);
var
 V1:TSignal;
 V2:TSignal2D;
 i,j:Integer;
begin
 SetDimension(V1,DimCol);
 Set2DDimension(V2,DimCol,DimRow);
 for i:=1 to DimRow do
  begin
   DirectFFTShifted(DataIn[i-1],2*DimCol,V1);
   for j:=1 to DimCol do
     V2[j-1,i-1]:= V1[j-1];
  end;
 V1:=nil;
 SetDimension(V1,DimRow);
 for i:=1 to DimCol do
  begin
   DirectFFTShifted(V2[i-1],2*DimRow,V1);
   for j:=1 to DimCol do
     DataOut[i-1,j-1]:= V1[j-1];
  end;
 V2:= nil;
 V1:= nil;
end;
procedure DirectFFT2D(DataIn: TSignal2D ; DimCol,DimRow:Integer; var DataOut:TSignal2D);
var
 V1:TSignal;
 V2:TSignal2D;
 i,j:Integer;
begin

 SetDimension(V1,DimCol);
 Set2DDimension(V2,DimCol,DimRow);
 for i:=1 to DimRow do
  begin
   DirectFFT(DataIn[i-1],2*DimCol,V1);
   for j:=1 to DimCol do
     V2[j-1,i-1]:= V1[j-1];
  end;

 V1:=nil;
 SetDimension(V1,DimRow);

 for i:=1 to DimCol do
  begin
   DirectFFT(V2[i-1],2*DimRow,V1);
   for j:=1 to DimCol do
     DataOut[i-1,j-1]:= V1[j-1];
  end;
 V2:= nil;
 V1:= nil;
end;
///////////////////////// FFT DIRECTAS EN TRES DIMENSIONES /////////////////////
procedure DirectFFT3D(DataIn: TSignal3D ; DimCol,DimRow,DimDep:Integer; var DataOut:TSignal3D);
var
 V1,V2:TSignal;
 V3:TSignal3D;
 i,j,k:Integer;
begin
 Set3DDimension(V3,DimDep,DimCol,DimRow);
 for k:=1 to DimDep do
  begin
   DirectFFT2D(DataIn[k-1],DimCol,DimRow,V3[k-1]);
  end;
 SetDimension(V1,DimDep);
 SetDimension(V2,DimDep);
 for j:=1 to DimCol do
  for i:=1 to DimRow do
   begin
    for k:=1 to DimDep do V1[k-1]:=V3[k-1,j-1,i-1];
    DirectFFT(V1,2*DimDep,V2);
    for k:=1 to DimDep do DataOut[k-1,j-1,i-1]:=V2[k-1];
   end;
 V2:=nil;
 V3:=nil;
 V1:= nil;
end;

procedure DirectFFT3DShifted(DataIn: TSignal3D ; DimCol,DimRow,DimDep:Integer; var DataOut:TSignal3D);
var
 V1,V2:TSignal;
 V3:TSignal3D;
 i,j,k:Integer;
begin
 Set3DDimension(V3,DimDep,DimCol,DimRow);
 for k:=1 to DimDep do
  begin
   DirectFFT2DShifted(DataIn[k-1],DimCol,DimRow,V3[k-1]);
  end;
 SetDimension(V1,DimDep);
 SetDimension(V2,DimDep);
 for j:=1 to DimCol do
  for i:=1 to DimRow do
   begin
    for k:=1 to DimDep do V1[k-1]:=V3[k-1,j-1,i-1];
    DirectFFTShifted(V1,2*DimDep,V2);
    for k:=1 to DimDep do DataOut[k-1,j-1,i-1]:=V2[k-1];
   end;
 V2:=nil;
 V3:=nil;
 V1:= nil;
end;

////////////////// FFTs INVERSAS //////////////////////////////////
////////////////// FFT INVERSA EN DOS DIMENSIONES ////////////////////////////
procedure InverseFFTShifted(DataIn:TSignal; DimCol:Integer; var DataOut:TSignal);
var
 Aux:PVector;
 k,h,i:Integer;
 begin
  CreateVector(Aux,DimCol);
   // Llenado con ceros
  for i:=1 to DimCol do Aux[i]:=0;

  k:=1;
  h:=2;
  for i:=1 to (DimCol div 2) do
   begin
    Aux[k]:= DataIn[i-1].Re;
    Aux[h]:= DataIn[i-1].Im;
    k:=k+2;
    h:=h+2;
   end;
  FFT(Aux,INVERT);

// Acomodar los datos para que la frecuencia cero quede centrada
  k:=1;
  h:=2;
  for i:=1 to DimCol div 2 do
   begin
    if h<= (DimCol div 2) then
     begin
      DataOut[i-1].Re:=Aux[k+ (DimCol div 2)];
      DataOut[i-1].Im:=Aux[h+ (DimCol div 2)];
      k:=k+2;
      h:=h+2;
     end
    else
     begin
      DataOut[i-1].Re:=Aux[k - (DimCol div 2)];
      DataOut[i-1].Im:=Aux[h - (DimCol div 2)];
      k:=k+2;
      h:=h+2;
     end;
   end;
   DestroyVector(Aux);
 end;

procedure InverseFFT(DataIn: TSignal ; DimCol:Integer; var DataOut:TSignal);
var
 Aux:PVector;
 k,h,i:Integer;
 begin
  CreateVector(Aux,DimCol);
  // Llenado con ceros
  for i:=1 to DimCol do Aux[i]:=0;

  k:=1;
  h:=2;
  for i:=1 to (DimCol div 2) do
   begin
    Aux[k]:= DataIn[i-1].Re;
    Aux[h]:= DataIn[i-1].Im;
    k:=k+2;
    h:=h+2;
   end;
  FFT(Aux,INVERT);

// Acomodar los datos para que la frecuencia cero quede centrada
  k:=1;
  h:=2;
  for i:=1 to DimCol div 2 do
   begin
    DataOut[i-1].Re:= Aux[k];
    DataOut[i-1].Im:= Aux[h];
    k:=k+2;
    h:=h+2;
   end;
   DestroyVector(Aux);
 end;
///////////////////// INVERSAS EN 2 DIMENSIONES /////////////////////////////
procedure InverseFFT2DShifted(DataIn: TSignal2D ; DimCol,DimRow:Integer; var DataOut:TSignal2D);
var
 V1:TSignal;
 V2:TSignal2D;
 i,j:Integer;
begin

 SetDimension(V1,DimCol);
 Set2DDimension(V2,DimCol,DimRow);
 for i:=1 to DimRow do
  begin
   InverseFFTShifted(DataIn[i-1],2*DimCol,V1);
   for j:=1 to DimCol do
     V2[j-1,i-1]:= V1[j-1];
  end;

 V1:=nil;
 SetDimension(V1,DimRow);

 for i:=1 to DimCol do
  begin
   InverseFFTShifted(V2[i-1],2*DimRow,V1);
   for j:=1 to DimCol do
     DataOut[i-1,j-1]:= V1[j-1];
  end;
 V2:= nil;
 V1:= nil;
end;
procedure InverseFFT2D(DataIn: TSignal2D ; DimCol,DimRow:Integer; var DataOut:TSignal2D);
var
 V1:TSignal;
 V2:TSignal2D;
 i,j:Integer;
begin

 SetDimension(V1,DimCol);
 Set2DDimension(V2,DimCol,DimRow);
 for i:=1 to DimRow do
  begin
   InverseFFT(DataIn[i-1],2*DimCol,V1);
   for j:=1 to DimCol do
     V2[j-1,i-1]:= V1[j-1];
  end;

 V1:=nil;
 SetDimension(V1,DimRow);

 for i:=1 to DimCol do
  begin
   InverseFFT(V2[i-1],2*DimRow,V1);
   for j:=1 to DimCol do
     DataOut[i-1,j-1]:= V1[j-1];
  end;
 V2:= nil;
 V1:= nil;
end;
////////////////////////// INVERSAS EN TRES DIMESIONES ////////////////////////
procedure InverseFFT3D(DataIn: TSignal3D ; DimCol,DimRow,DimDep:Integer; var DataOut:TSignal3D);
var
 V1,V2:TSignal;
 V3:TSignal3D;
 i,j,k:Integer;
begin
 Set3DDimension(V3,DimDep,DimCol,DimRow);
 for k:=1 to DimDep do
  begin
   InverseFFT2D(DataIn[k-1],DimCol,DimRow,V3[k-1]);
  end;
 SetDimension(V1,DimDep);
 SetDimension(V2,DimDep);
 for j:=1 to DimCol do
  for i:=1 to DimRow do
   begin
    for k:=1 to DimDep do V1[k-1]:=V3[k-1,j-1,i-1];
    InverseFFT(V1,2*DimDep,V2);
    for k:=1 to DimDep do DataOut[k-1,j-1,i-1]:=V2[k-1];
   end;
 V2:=nil;
 V3:=nil;
 V1:= nil;
end;

procedure InverseFFT3DShifted(DataIn: TSignal3D ; DimCol,DimRow,DimDep:Integer; var DataOut:TSignal3D);
var
 V1,V2:TSignal;
 V3:TSignal3D;
 i,j,k:Integer;
begin
 Set3DDimension(V3,DimDep,DimCol,DimRow);
 for k:=1 to DimDep do
  begin
   InverseFFT2DShifted(DataIn[k-1],DimCol,DimRow,V3[k-1]);
  end;
 SetDimension(V1,DimDep);
 SetDimension(V2,DimDep);
 for j:=1 to DimCol do
  for i:=1 to DimRow do
   begin
    for k:=1 to DimDep do V1[k-1]:=V3[k-1,j-1,i-1];
    InverseFFTShifted(V1,2*DimDep,V2);
    for k:=1 to DimDep do DataOut[k-1,j-1,i-1]:=V2[k-1];
   end;
 V2:=nil;
 V3:=nil;
 V1:= nil;
end;

procedure DirectFFT2DShiftednd(DataIn: TSignal2D ; DimCol,DimRow:Integer; var DataOut:TSignal2D);

type
 Mat = Array [0..268435454] of Double;
 pMat= ^Mat;
var

MemSize:UINT;
AuxRe,AuxIm:pMat;
ldn:array [0..1] of UINT;
i,j:Integer;
 begin

  MemSize := DimCol * DimRow * SizeOf(Double);
  AuxRe := pMat(GlobalAllocPtr(GHND or GMEM_SHARE, MemSize) );
  AuxIm := pMat(GlobalAllocPtr(GHND or GMEM_SHARE, MemSize) );

  for i:=0 to DimRow-1 do
   for j:= 0 to DimCol-1 do
    begin
     AuxRe[i*DimCol+j]:= DataIn[i,j].Re;
     AuxIm[i*DimCol+j]:= DataIn[i,j].Im;
    end;

  ldn[0]:= Ldn2(DimCol);
  ldn[1]:= Ldn2(DimRow);

  ndim_fft(PDouble(@AuxRe[0]), PDouble(@AuxIm[0]),2, PUINT(@ldn[0]), -1);

  for i:=0 to DimRow-1 do
   for j:= 0 to DimCol-1 do
    begin
     DataOut[i,j].Re:= AuxRe[i*DimCol+j];
     DataOut[i,j].Im:= AuxIm[i*DimCol+j];
    end;

  GlobalFreePtr(AuxRe);
  GlobalFreePtr(AuxIm);

 end;

procedure DirectFFT2Dnd(DataIn: TSignal2D ; DimCol,DimRow:Integer; var DataOut:TSignal2D);
begin
 end;
procedure InverseFFT2DShiftednd(DataIn: TSignal2D ; DimCol,DimRow:Integer; var DataOut:TSignal2D);
begin
 end;

procedure InverseFFT2Dnd(DataIn: TSignal2D ; DimCol,DimRow:Integer; var DataOut:TSignal2D);
type
 Mat = Array [0..268435454] of Double;//Array [0..268435454] of Double
 pMat= ^Mat;
var
MemSize:UINT;
AuxRe,AuxIm:pMat;
ldn:array [0..1] of UINT;
i,j:Integer;
 begin
  MemSize := DimCol * DimRow * SizeOf(Double);
  AuxRe := pMat(GlobalAllocPtr(GHND or GMEM_SHARE, MemSize) );
  // zero im part
  AuxIm := pMat(GlobalAllocPtr(GHND or GMEM_SHARE, MemSize) );
  for i:=0 to DimRow-1 do
   for j:= 0 to DimCol-1 do
    begin
     AuxRe[i*DimCol+j]:= DataIn[i,j].Re;
     AuxIm[i*DimCol+j]:= DataIn[i,j].Im;
    end;

  ldn[0]:= ldn2(DimCol);
  ldn[1]:=ldn2(DimRow);

  ndim_fft(PDouble(@AuxRe[0]), PDouble(@AuxIm[0]),2, PUINT(@ldn[0]), 1);

  for i:=0 to DimRow-1 do
   for j:= 0 to DimCol-1 do
    begin
     DataOut[i,j].Re:= AuxRe[i*DimCol+j];
     DataOut[i,j].Im:= AuxIm[i*DimCol+j];
    end;
  GlobalFreePtr(AuxRe);
  GlobalFreePtr(AuxIm);

 end;
procedure DirectFFTShiftednd(DataIn: TSignal ; DimCol:Integer; var DataOut:TSignal);

 begin

 end;
procedure DirectFFTnd(DataIn: TSignal ; DimCol:Integer; var DataOut:TSignal);
type
 Mat = Array [0..268435454] of Double;//Array [0..268435454] of Double
 pMat= ^Mat;
var
MemSize:UINT;
AuxRe,AuxIm:pMat;
ldn:array [0..1] of UINT;
j:Integer;
 begin
  MemSize := DimCol * SizeOf(Double);
  AuxRe := pMat(GlobalAllocPtr(GHND or GMEM_SHARE, MemSize) );
  // zero im part
  AuxIm := pMat(GlobalAllocPtr(GHND or GMEM_SHARE, MemSize) );
  for j:= 0 to DimCol-1 do
   begin
    AuxRe[j]:= DataIn[j].Re;
    AuxIm[j]:= DataIn[j].Im;
   end;

  ldn[0]:=7;
  ldn[1]:=0;

  ndim_fft(PDouble(@AuxRe[0]), PDouble(@AuxIm[0]),2, PUINT(@ldn[0]), -1);

  for j:= 0 to DimCol-1 do
   begin
    DataOut[j].Re:= AuxRe[j];
    DataOut[j].Im:= AuxIm[j];
   end;
  GlobalFreePtr(AuxRe);
  GlobalFreePtr(AuxIm);

 end;

procedure InverseFFTnd(DataIn: TSignal ; DimCol:Integer; var DataOut:TSignal);

 begin

 end;

procedure InverseFFTShiftednd(DataIn: TSignal ; DimCol:Integer; var DataOut:TSignal);

 begin

 end;

end.
