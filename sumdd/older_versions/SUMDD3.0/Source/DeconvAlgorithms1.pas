unit DeconvAlgorithms;

{Módulo que contiene la implementación de los algoritmos de desconvolución
 utilizados para corregir la fluorescencia fuera de foco de volúmenes obtenidos
 por seccionamiento óptico.}

interface

uses    SysUtils,
        Windows,
      	Forms,
      	Math,
      	DecTypes,
      	FourierTransforms,
      	ProgressActivity,
      	USort,
        ndLink;


/////  Algoritmos //////////
procedure LinearLeastSquare(VectorIn,VectorOut,VectorPSF,Eigenvalues:TSignal;
                              MuOptimo:Single;MuLength:Integer);

procedure LinearLeastSquareNEW(const VecPSF:TVector;
                                     VecImage:TVector;
                               const MuOptimo:Double);

procedure NearestNeighbor(PSFinfocus,PSFUp,PSFDown,
                          Image,ImageUp,ImageDown:TSignal2D;
                          var ImageOut:TSignal2D;X,Y:Integer;C1,C2:Double);


procedure NearestNeighborndNEW(const VecPSF: TVector;
	                             VecImage: TVector;
                               const X,Y,Z:Integer;
                               const C1,C2:Double);


procedure ConstrainedIterativeNEW(const VecPSF: TVector;
								  VecImage:TVector;
								  const XDim,YDim,ZDim:Integer);

procedure ConstrainedIterative(DataIn,PSF3D:TSignal3D;const ZDim,XDim,YDim:Integer;
                               DataOut:TSignal3D);

procedure WienerFilter(DataIn,PSF3D:TSignal3D;ZDim,XDim,YDim:Integer;
                       DataOut:TSignal3D);


///// Otras Funciones Necesarias para la ejecución de los algoritmos //////////

function ldn2(const x: UINT): UINT;

procedure threedim_fft(const DataRe,DataIm: TVector; 
					   const X,Y,Z:Integer; 
					   const isign: Integer = 1);


const
 sqrt2 = 1.4142135623730950488016887242097; //2 square root

 var
FActivityProgress: TFActivityProgress;

implementation

/////////////////////////// OTRAS FUNCIONES///////////////////////////////

/////////////////////ALGORITMOS DE DESCONVOLUCIÓN/////////////////////////
///////////////////// NEAREST NEIGHBOR /////////////////////////////

procedure NearestNeighbor(PSFinfocus,PSFUp,PSFDown,
                          Image,ImageUp,ImageDown:TSignal2D;
                          var ImageOut:TSignal2D;X,Y:Integer;C1,C2:Double);

var
 RAux,FImageAux,FIup,FIDown,OTF,OTFUp,OTFDown:TSignal2D;
 i,j:Integer;
 MaxImOut:Double;

 begin

  Set2DDimension(OTF,X,Y);
  Set2DDimension(OTFUp,X,Y);
  Set2DDimension(OTFDown,X,Y);
  DirectFFT2DShifted(PSFinfocus,X,Y,OTF);
  DirectFFT2DShifted(PSFUp,X,Y,OTFUp);
  DirectFFT2DShifted(PSFDown,X,Y,OTFDown);

  Set2DDimension(FIUp,X,Y);
  Set2DDimension(FIDown,X,Y);
  Set2DDimension(RAux,X,Y);
  DirectFFT2DShifted(ImageUp,X,Y,FIUp);
  DirectFFT2DShifted(Image,X,Y,RAux);
  DirectFFT2DShifted(ImageDown,X,Y,FIDown);
  Set2DDimension(FImageAux,X,Y);
  for i:=0 to Y-1 do
   for j:=0 to X-1 do
    begin
     RAux[i,j].Re:=RAux[i,j].Re - C1*(FIUp[i,j].Re*OTFUp[i,j].Re +FIDown[i,j].Re*OTFDown[i,j].Re);
     RAux[i,j].Im:=RAux[i,j].Im - C1*(FIUp[i,j].Im*OTFUp[i,j].Im+FIDown[i,j].Im*OTFDown[i,j].Im);
     FImageAux[i,j].Re:=(RAux[i,j].Re*OTF[i,j].Re)/(OTF[i,j].Re+C2);
     FImageAux[i,j].Im:=(RAux[i,j].Im*OTF[i,j].Im)/(OTF[i,j].Im+C2);
    end;
  RAux:=nil;
  FIUp:=nil;
  FIDown:=nil;
  InverseFFT2D(FImageAux,X,Y,ImageOut);
  FImageAux:=nil;
  MaxImOut:=MaxTSignal2DABS(ImageOut,X,Y);
  for i:=0 to Y-1 do
   for j:=0 to X-1 do
    ImageOut[j,i].Re:=sqrt(sqr(ImageOut[j,i].Re)+sqr(ImageOut[j,i].Im))/MaxImOut;
 end;

///////////////////// LINEAR LEAST SQUARE /////////////////////////////

procedure LinearLeastSquare(VectorIn,VectorOut,VectorPSF,Eigenvalues:TSignal;
                            MuOptimo:Single;MuLength:Integer);
 var
  c,Dif,Count,i,j:Integer;
  Mu:TSignal;
  EigAux:array of Double;
  Aux,ChiK,TaoK:TSignal;
  
  Auxnd,ChiKnd,TaoKnd:Array of Double;
  AuxMax,MaxMu:Single;
 
  begin
  // if Eigenvalues = nil then
  // begin
    SetLength(EigAux,MuLength);
    SetDimension(Mu,MuLength);
    DirectFFT(VectorPSF,2*MuLength,Mu);
    MaxMu:=MaxTSignalABS(Mu);
    for j:=0 to MuLength-1 do
     begin
      Mu[j].Re:=Mu[j].Re/MaxMu;
      Mu[j].Im:=Mu[j].Im/MaxMu;
      EigAux[j]:=sqrt(sqr(Mu[j].Re)+sqr(Mu[j].Im));
     end;
   Mu:=nil;

//   QSortNR(EigAux); // sort not recursive

   j:=0;
   Repeat
    j:=j+1;
   until EigAux[j]<=MuOptimo;

   SetLength(EigAux,j+1);

 //   Eigenvalues:= Mu;
   //end;
   SetDimension(TaoK,MuLength);
   SetDimension(ChiK,MuLength);
   SetDimension(Aux,MuLength);
   Count:=0;
   while (Count<Length(VectorOut)-1) do
    begin
     c:=0;
     for j:=Count to Count+Length(Aux)-1 do
      begin
       Aux[c].Re:=VectorIn[j].Re;
       Aux[c].Im:=VectorIn[j].Im;
       c:=c+1;
      end;
     DirectFFT(Aux,2*MuLength,ChiK);
     for i:=0 to Length(EigAux)-1 do
      begin
       TaoK[i].Re := ((ChiK[i].Re))/sqr(EigAux[i]);
       TaoK[i].Im := ((ChiK[i].Im))/sqr(EigAux[i]);
      end;
     for i:=Length(EigAux) to MuLength-1 do
      begin
       TaoK[i].Re:=0;
       TaoK[i].Im:=0;
      end;
     InverseFFT(TaoK,2*MuLength,Aux);
     AuxMax:=MaxTSignalABS(Aux);
     c:=0;
     for j:=Count to Count+Length(Aux)-1 do
      begin
       VectorOut[j].Re:=sqrt(sqr(Aux[c].Re)+sqr(Aux[c].Im))/AuxMax;
       c:=c+1;
      end;
     Dif:=Length(VectorOut)-(Count+Length(Aux));
     if (Dif < 0) then Count:=Count+Dif;
     Count:=Count+Length(Aux);
    end; // end While   
   EigAux:=nil;
 end;

procedure LinearLeastSquareNEW(const VecPSF:TVector;
                      	             VecImage:TVector;
		     	       const MuOptimo:Double);
 var
  c,Dif,Counter,j:Integer;
  EigAux,AuxIm:TVector;
  ldn2Vector: array [0..1] of UINT;
  AuxMax1,AuxMax2,AuxMin1,AuxMin2:Double;

  begin

   FActivityProgress:=TFActivityProgress.Create(Application);
   FActivityProgress.PBActivityProgress.Max:=100;
   FActivityProgress.Caption:='Desconvolucionando';
   FActivityProgress.Show;

   FActivityProgress.PBActivityProgress.Position:=10;
   FActivityProgress.LProgress.Caption:=FormatFloat('##.#%',10);
   FActivityProgress.Refresh;



   ldn2Vector[0]:=ldn2(Length(VecPSF));
   ldn2Vector[1]:=0;

   SetLength(EigAux,Length(VecPSF));
   SetLength(AuxIm,Length(VecPSF));
   CopyMemory(EigAux,VecPSF,Length(VecPSF)*Sizeof(Double));

    // Normalization
       // Eig
   AuxMax1:=MaxValue(EigAux);
   AuxMin1:=MinValue(EigAux);
       // VecImage
   AuxMax2:=MaxValue(VecImage);
   AuxMin2:=MinValue(VecImage);

   for j:= Low(VecImage) to High(VecImage) do
    begin
     VecImage[j]:=(VecImage[j]-AuxMin2)/(AuxMax2-AuxMin2);
     if (j<=High(EigAux)) and (j>=Low(EigAux)) then
      EigAux[j]:=(EigAux[j]-AuxMin1)/(AuxMax1-AuxMin1);
    end;

   ndim_fft(PDouble(@EigAux[0]),PDouble(@AuxIm[0]),2,PUINT(@ldn2Vector[0]),-1);

   for j:= Low(EigAux) to High(EigAux) do  EigAux[j]:=sqrt(sqr(EigAux[j])+sqr(AuxIm[j]));


   QSortNR(EigAux); // sort not recursive

   Application.ProcessMessages;
   FActivityProgress.PBActivityProgress.Position:=50;
   FActivityProgress.LProgress.Caption:=FormatFloat('##.#%',50);
   FActivityProgress.Refresh;

   AuxMax1:=EigAux[Low(EigAux)];
   for j:= Low(EigAux) to High(EigAux) do
     begin
      EigAux[j]:=EigAux[j]/AuxMax1;
      if  EigAux[j] <=MuOptimo then
       begin
        SetLength(EigAux,j+1);
        break;
       end;
     end;


   Counter:=0;
   while (Counter<Length(VecImage)-1) do
    begin

     ZeroMemory(AuxIm,Length(AuxIm)*Sizeof(Double));
     ndim_fft(PDouble(@VecImage[Counter]),PDouble(@AuxIm[0]),2,PUINT(@ldn2Vector[0]),-1);

     for j:=Low(EigAux) to High(EigAux) do
      begin
       //This for loop is TaoK= ChiK/Eingenvalues^2
       VecImage[j+Counter]:= VecImage[j+Counter]/sqr(EigAux[j]);
       AuxIm[j] := AuxIm[j]/sqr(EigAux[j]);
      end;
     for j:=Length(EigAux) to Length(VecPSF)-1 do
      begin
       // Leave zero high frequencies
       VecImage[j+Counter] :=0;
       AuxIm[j]:=0
      end;

      // Get Back where you belonged
     ndim_fft(PDouble(@VecImage[Counter]),PDouble(@AuxIm[0]),2,PUINT(@ldn2Vector[0]),1);

     c:=0;
     for j:=Counter to Counter+High(VecPSF) do
      begin
       VecImage[j]:=sqrt(sqr(VecImage[j])+sqr(AuxIm[c]));
       c:=c+1;
      end;
     Dif :=Length(VecImage)-(Counter+Length(VecPSF));
     if (Dif < 0) then Counter:=Counter+Dif;
     Counter:=Counter+Length(VecPSF);
    end; // end While

    Application.ProcessMessages;
    FActivityProgress.PBActivityProgress.Position:=90;
    FActivityProgress.LProgress.Caption:=FormatFloat('##.#%',90);
    FActivityProgress.Refresh;

    EigAux:=nil;
    AuxIm:=nil;

    AuxMax1:= MaxValue(VecImage);
    AuxMin1:=MinValue(VecImage);
    for j:=Low(VecImage) to High(VecImage) do
     VecImage[j]:=(VecImage[j]-AuxMin1)/(AuxMax1-AuxMin1);

    FActivityProgress.Destroy;

 end;
procedure ConstrainedIterative(DataIn,PSF3D:TSignal3D;const ZDim,XDim,YDim:Integer;DataOut:TSignal3D);
var
 MaxSumIntData,MaxSumIntPSF,MaxDataIn,minDataIn,A,MinOTF,MaxOTF:Single;
 FObAux,ObAux,FImAux,OTF,gamma:TSignal3D;
 iterate,i,j,k,Count:Integer;
 SumIntData,SumIntPSF: array of Double;
begin
 FActivityProgress:= TFActivityProgress.Create(Application);
 FActivityProgress.Caption:='Desconvolucionando';
 FActivityProgress.Show;
 FActivityProgress.PBActivityProgress.Position:=0;
 FActivityProgress.LProgress.Caption:=FormatFloat('##.##%',0.0);
 FActivityProgress.Refresh;

 // Normalización de Suma de Intensidades
 SetLength(SumIntData,ZDim);
 SetLength(SumIntPSF,ZDim);
 for k:= 0 to ZDim-1 do
  begin
   SumIntData[k]:=SumTSignal2D(DataIn[k]);
   SumIntPSF[k]:=SumTSignal2D(PSF3D[k]);

  end;

 MaxSumIntData:=MaxValue(SumIntData);
 MaxSuMIntPSF:=MaxValue(SumIntPSF);
 for j:=0 to XDim-1 do
  for i:=0 to YDim-1 do
   for k:=0 to ZDim-1 do
    begin
     DataIn[k,j,i].Re:= DataIn[k,j,i].Re*MaxSumIntData/SumIntData[k];
     PSF3D[k,j,i].Re:= PSF3D[k,j,i].Re*MaxSumIntPSF/SumIntPSF[k];
    end;

 SumIntData:=nil;
 SumIntPSF:=nil;

 // NORMALIZACIÓN
 minDataIn:=MinTSignal3DABS(DataIn,ZDim,XDim,YDim);
 MaxDataIn:=MaxTSignal3DABS(DataIn,ZDim,XDim,YDim);
 MinOTF:=MinTSignal3DABS(PSF3D,ZDim,XDIm,YDim);
 MaxOTF:=MaxTSignal3DABS(PSF3D,ZDim,XDIm,YDim);
 for j:=0 to XDim-1 do
  for i:=0 to YDim-1 do
   for k:=0 to ZDim-1 do
    begin
     DataIn[k,j,i].Re:= (DataIn[k,j,i].Re - minDataIn)/(MaxDataIn-minDataIn);
     DataOut[k,j,i].Re:=DataIn[k,j,i].Re;
     PSF3D[k,j,i].Re:= (PSF3D[k,j,i].Re - MinOTF)/(MaxOTF-MinOTF);
    end;



 Set3DDimension(OTF,ZDim,XDim,YDim);
 DirectFFT3D(PSF3D,XDim,YDim,ZDim,OTF);
 MaxOTF:=MaxTSignal3DABS(OTF,ZDim,XDim,YDim);
 for k:=0 to ZDim-1 do
  for j:=0 to XDim-1 do
   for i:=0 to YDim-1 do
    begin
     OTF[k,j,i].Re:=OTF[k,j,i].Re/MaxOTF;
     OTF[k,j,i].Im:=OTF[k,j,i].Im/MaxOTF;
    end;

 Set3DDimension(FImAux,ZDim,XDim,YDim);
 Set3DDimension(FObAux,ZDim,XDim,YDim);
 Set3DDimension(gamma,ZDim,XDim,YDim);
 DirectFFT3D(DataIn,XDim,YDim,ZDim,FImAux);
 Set3DDimension(ObAux,ZDim,XDim,YDim);

 //A:=0.5;
// A := MaxTSignal3DABS(DataIn,ZDim,XDim,YDim)/2;
 iterate:=10;
 Count:=0;
 while Count<=iterate do
  begin
//////////  Convolución 3D /////////////////////////////////
   for k:=0 to ZDim-1 do
    for j:=0 to XDim-1 do
     for i:=0 to YDim-1 do
      begin
       FObaux[k,j,i].Re := (FImAux[k,j,i].Re*OTF[k,j,i].Re)-(FImAux[k,j,i].Im*OTF[k,j,i].Im);
       FObaux[k,j,i].Im := (FImAux[k,j,i].Im*OTF[k,j,i].Re)+(FImAux[k,j,i].Re*OTF[k,j,i].Im);
      end;
//////////////////////////////////////////////////////////
   InverseFFT3D(FObAux,XDim,YDim,ZDim,ObAux);
   InverseFFT3D(FImAux,XDim,YDim,ZDim,DataOut);
   Application.ProcessMessages;
   FActivityProgress.PBActivityProgress.Position:=trunc(Count/iterate*100);
   FActivityProgress.LProgress.Caption:=FormatFloat('##.##%',Count/iterate*100);
   FActivityProgress.Refresh;
   if not FActivityProgress.Visible then exit;

////////////////// Determinación del estimador////////////////////////////
   for k:=0 to ZDim-1 do
    for j:=0 to XDim-1 do
     for i:=0 to YDim-1 do
      begin
       gamma[k,j,i].Re:= 1 - sqr(sqrt(sqr(ObAux[k,j,i].Re)+sqr(ObAux[k,j,i].Im))-0.5)/0.25;
//       gamma[k,j,i].Im:= ObAux[k,j,i].Re*ObAux[k,j,i].Im/sqr(A);
       DataOut[k,j,i].Re:= DataOut[k,j,i].Re + gamma[k,j,i].Re*(DataIn[k,j,i].Re-sqrt(sqr(ObAux[k,j,i].Re)+sqr(ObAux[k,j,i].Im)));
       DataOut[k,j,i].Im:= 0;
       ///////////////Positividad//////////////////////////////////////
       if (DataOut[k,j,i].Re<0) then
        begin
         DataOut[k,j,i].Re:=0;
        end
     end;
   MaxDataIn:=MaxTSignal3DABS(DataOut,ZDim,XDim,YDim);
   for k:=0 to ZDim-1 do
    for j:=0 to XDim-1 do
     for i:=0 to YDim-1 do
      begin
//       DataOut[k,j,i].Re:= DataOut[k,j,i].Re*MaxSumInt/SumInt[k];
       DataOut[k,j,i].Re:=sqrt(sqr(DataOut[k,j,i].Re)+sqr(DataOut[k,j,i].Im))/MaxDataIn;
      end;


   DirectFFT3D(DataOut,XDim,YDim,ZDim,FImAux);
   inc(Count,1);
  end; // End While

 FActivityProgress.Destroy;
end;// end begin

procedure ConstrainedIterativeNEW(const VecPSF: TVector;
					    	     VecImage:TVector;
				  	              const XDim,YDim,ZDim:Integer);
var
 MaxAux1,MaxAux2, MinAux1,MinAux2:Double;
 Count,iterate,j,HiAux,LoAux,LenAux:Integer;
 AuxRe1,AuxIm1,AuxRe2,AuxIm2,AuxRe3,AuxIm3,gamma:TVector;
 ldn3Vector:array [0..2] of UINT;
 A:Double;
 
 //Ob,FObAux,ObAux,FImAux,ImAux,OTF,gamma:TSignal3D;
 //i,j,k,:Integer;
 //SumInt: array of Double;
begin
 
 FActivityProgress:= TFActivityProgress.Create(Application);
 FActivityProgress.Caption:='Desconvolucionando';
 FActivityProgress.Show;
 FActivityProgress.PBActivityProgress.Position:=0;
 FActivityProgress.LProgress.Caption:=FormatFloat('##.##%',0.0);
 FActivityProgress.Refresh;
 
 ldn3Vector[0]:=ldn2(XDim);
 ldn3Vector[1]:=ldn2(YDim);
 ldn3Vector[2]:=ldn2(ZDim);

 LoAux:=Low(VecImage);
 HiAux:=High(VecImage);
 LenAux:=Length(VecImage);
 
 SetLength(AuxIm3,LenAux);

 threedim_fft(VecImage,AuxIm3,XDim,YDim,ZDim,-1);
 threedim_fft(VecImage,AuxIm3,XDim,YDim,ZDim,1);

// ndim_fft(PDouble(@VecImage[0]),PDouble(@AuxIm3[0]),3,PUINT(@ldn3Vector[0]),-1);
// ndim_fft(PDouble(@VecImage[0]),PDouble(@AuxIm3[0]),3,PUINT(@ldn3Vector[0]),1);
 
 for j:=LoAux to HiAux do VecImage[j]:=sqrt(sqr(VecImage[j])+sqr(AuxIm3[j]));
 MaxAux1:=MaxValue(VecImage);
 MinAux1:=MinValue(VecImage);
 for j:=LoAux to HiAux do VecImage[j]:=(VecImage[j]-MinAux1)/(MaxAux1-MinAux1);
 
 // Normalization
 {MinAux1:=MinValue(VecPSF);
 MaxAux1:=MaxValue(VecPSF);
 MinAux2:=MinValue(VecImage);
 MaxAux2:=MaxValue(VecImage);
 
 for j:=LoAux to HiAux do
  begin
   VecImage[j]:=(VecImage[j]-MinAux2)/(MaxAux2-MinAux2);
   //AuxRe1[j]:=(VecPSF[j]-MinAux1)/(MaxAux1-MinAux1);
  end;}
  
   
 //SetLength(AuxRe3,LenAux);
 //CopyMemory(AuxRe3,VecImage,LenAux*SizeOf(Double));
 
 // NORMALIZACIÓN
 // Normalización de Suma de Intensidades
 {SetLength(SumInt,ZDim);
   for k:= 0 to ZDim-1 do
    SumInt[k]:=SumTSignal2D(DataIn[k]);

 MaxSumInt:=MaxValue(SumInt);
 for j:=0 to XDim-1 do
  for i:=0 to YDim-1 do
   for k:=0 to ZDim-1 do
     DataIn[k,j,i].Re:= DataIn[k,j,i].Re*MaxSumInt/SumInt[k];

 SumInt:=nil;}

 // Normalización de Intensidades
 {MaxDataIn:=MaxTSignal3DABS(DataIn,ZDim,XDim,YDim);
 for j:=0 to XDim-1 do
  for i:=0 to YDim-1 do
   for k:=0 to ZDim-1 do
    DataIn[k,j,i].Re:= 255*(DataIn[k,j,i].Re/MaxDataIn);}
 
 // OTF
 //SetLength(AuxIm1,LenAux);
 
 //ndim_fft(PDouble(@AuxRe1[0]),PDouble(@AuxIm1[0]),3,PUINT(@ldn3Vector[0]),-1);
 
 // OTF Norm
 
 
 {
 for j:=LoAux to HiAux do AuxRe1[j]:=sqrt(sqr(AuxRe1[j])+sqr(AuxIm1[j]));
 
  MinAux1:=MinValue(AuxRe1);
  MaxAux1:=MaxValue(AuxRe1);
 
 for j:=LoAux to HiAux do AuxRe1[j]:=(AuxRe1[j]-MinAux1)/(MaxAux1-MinAux1);
 }
 // 
 
 //ZeroMemory(AuxIm1,LenAux*SizeOf(Double));
 // ndim_fft(PDouble(@VecImage[0]),PDouble(@AuxIm1[0]),3,PUINT(@ldn3Vector[0]),-1);
 
 {SetLength(AuxRe2,LenAux);
 SetLength(AuxIm2,LenAux);
 SetLength(AuxIm3,LenAux);
 
 Ob:=DataIn;
 Set3DDimension(FImAux,ZDim,XDim,YDim);
 Set3DDimension(FObAux,ZDim,XDim,YDim);
 Set3DDimension(gamma,ZDim,XDim,YDim);
 ImAux:=DataOut;
 DirectFFT3D(Ob,XDim,YDim,ZDim,FImAux);
 Set3DDimension(ObAux,ZDim,XDim,YDim);
 

 A := MaxValue(VecImage)/2;
 iterate:=1;
 Count:=0;
 SetLength(gamma,LenAux);}
 
 {while Count<=iterate do
  begin
   //ZeroMemory(AuxIm1,Length(AuxIm1)*SizeOf(Double));
   //ndim_fft(PDouble(@VecImage[0]),PDouble(@AuxIm3[0]),3,PUINT(@ldn3Vector[0]),-1);
//////////  Convolución 3D /////////////////////////////////
   
   for j:=LoAux to HiAux do
    begin 
     //AuxRe2[j]:=VecImage[j]*AuxRe1[j]-AuxIm3[j]*AuxIm1[j];
     //AuxIm2[j]:=VecImage[j]*AuxIm1[j]+AuxIm3[j]*AuxRe1[j];
     
     //AuxRe2[j]:=VecImage[j]*AuxRe1[j];
     //AuxIm2[j]:=AuxIm3[j]*AuxRe1[j];
    end;
   
  
  for k:=0 to ZDim-1 do
    for j:=0 to XDim-1 do
     for i:=0 to YDim-1 do
      begin
       FObaux[k,j,i].Re :=  FImAux[k,j,i].Re*OTF[k,j,i].Re;
       FObaux[k,j,i].Im :=  FImAux[k,j,i].Im*OTF[k,j,i].Im;
      end;
  
//////////////////////////////////////////////////////////
   
   //ndim_fft(PDouble(@VecImage[0]),PDouble(@AuxIm1[0]),3,PUINT(@ldn3Vector[0]),1);   
   //ndim_fft(PDouble(@AuxRe2[0]),PDouble(@AuxIm2[0]),3,PUINT(@ldn3Vector[0]),1);   
   
   
   InverseFFT3D(FObAux,XDim,YDim,ZDim,ObAux);
   InverseFFT3D(FImAux,XDim,YDim,ZDim,ImAux);
   
   
   Application.ProcessMessages;
   FActivityProgress.PBActivityProgress.Position:=trunc(Count/iterate*100);
   FActivityProgress.LProgress.Caption:=FormatFloat('##.##%',Count/iterate*100);
   FActivityProgress.Refresh;
   if not FActivityProgress.Visible then exit;

////////////////// Determinación del estimador////////////////////////////
   
   for j:=LoAux to HiAux do
    begin
     gamma[j]:=1 - sqr(sqrt(sqr(AuxRe2[j])+sqr(AuxIm2[j]))-A)/sqr(A);
     VecImage[j]:= VecImage[j] + gamma[j]*(AuxRe3[j]-sqrt(sqr(AuxRe2[j])+sqr(AuxIm2[j])));
     If VecImage[j] < 0 then VecImage[j]:=0;
    end;
    ZeroMemory(AuxIm1,LenAux*SizeOf(Double));
   
    
   for k:=0 to ZDim-1 do
    for j:=0 to XDim-1 do
     for i:=0 to YDim-1 do
      begin
       gamma[k,j,i].Re:= 1 - sqr(sqrt(sqr(ObAux[k,j,i].Re)+sqr(ObAux[k,j,i].Im))-A)/sqr(A);
//       gamma[k,j,i].Im:= ObAux[k,j,i].Re*ObAux[k,j,i].Im/sqr(A);
       ImAux[k,j,i].Re:= ImAux[k,j,i].Re + gamma[k,j,i].Re*(Ob[k,j,i].Re-sqrt(sqr(ObAux[k,j,i].Re)+sqr(ObAux[k,j,i].Im)));
       ImAux[k,j,i].Im:= 0;
       ///////////////Positividad//////////////////////////////////////
       if (ImAux[k,j,i].Re<0) then
        begin
         ImAux[k,j,i].Re:=0;
        end
     end;
     
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
   for k:=0 to ZDim -1 do
    begin
     MaxImAux:=MaxTSignal2DABS(ImAux[k],XDim,YDim);
     for i:=0 to YDim-1 do
      for j:=0 to XDim-1  do
       if count<iterate then ImAux[k,j,i].Re:= sqrt(sqr(ImAux[k,j,i].Re)+sqr(ImAux[k,j,i].Im))/MaxImAux*255
       else ImAux[k,j,i].Re:= sqrt(sqr(ImAux[k,j,i].Re)+sqr(ImAux[k,j,i].Im))/MaxImAux
    end;
   
  MaxImAux:=MaxTSignal3DABS(ImAux,ZDim,XDim,YDim);
   for k:=0 to ZDim-1 do
    for j:=0 to XDim-1 do
     for i:=0 to YDim-1 do
      ImAux[k,j,i].Re:=sqrt(sqr(ImAux[k,j,i].Re)+sqr(ImAux[k,j,i].Im))/MaxImAux*255;

   //DirectFFT3D(ImAux,XDim,YDim,ZDim,FImAux);
   
   
   threedim_fft(VecImage,AuxIm3,XDim,YDim,ZDim,-1);
   threedim_fft(VecImage,AuxIm3,XDim,YDim,ZDim,1);
   //ndim_fft(PDouble(@VecImage[0]),PDouble(@AuxIm3[0]),3,PUINT(@ldn3Vector[0]),1);   
   
   //CopyMemory(VecImage,AuxRe2,LenAux*Sizeof(Double));
   //CopyMemory(AuxIm1,AuxIm2,LenAux*Sizeof(Double));
   
   for j:=LoAux to HiAux do VecImage[j]:=sqrt(sqr(VecImage[j])+sqr(AuxIm3[j]));
   MaxAux1:=MaxValue(VecImage);
   MinAux1:=MinValue(VecImage);
   for j:=LoAux to HiAux do VecImage[j]:=(VecImage[j]-MinAux1)/(MaxAux1-MinAux1);
  
   inc(Count);
  
  end; // End While}

 FActivityProgress.Destroy;
 
end;// end begin

procedure WienerFilter(DataIn,PSF3D:TSignal3D;ZDim,XDim,YDim:Integer;DataOut:TSignal3D);

 begin

  end;



procedure NearestNeighborndNEW(const VecPSF: TVector;
							   VecImage: TVector;
               				  const X,Y,Z:Integer;
              				  const C1,C2:Double);


var
 ImAux,ReAux,OTFAuxRe,OTFAuxIm,ImaAuxRe,ImaAuxIm:array of Double;
 ldn2Vector: array [0.. 1] of UINT;
 Counter1, Counter2,Counter3,j,k,VecImageLength,VecPSFLength :Integer;
 ModOTF1,ModOTF2,D,NR,NI,MinIm,MaxIm,MinOTF,MaxOTF:Double;

 begin

  ldn2Vector[0]:=ldn2(X);
  ldn2Vector[1]:=ldn2(Y);

  FActivityProgress:=TFActivityProgress.Create(Application);
  FActivityProgress.PBActivityProgress.Max:=Z-2;
  FActivityProgress.Caption:='Desconvolucionando';
  
  VecImageLength:=Length(VecImage);
  VecPSFLength:=Length(VecPSF);
  
  SetLength(OTFAuxRe,VecPSFLength);
  SetLength(OTFAuxIm,VecPSFLength);


  CopyMemory(OTFAuxRe,VecPSF,VecPSFLength*Sizeof(Double));

  SetLength(ImaAuxRe,VecImageLength);
  SetLength(ImaAuxIm,VecImageLength);

  CopyMemory(ImaAuxRe,VecImage,VecImageLength*Sizeof(Double));


  //Normalization

  MaxOTF:=MaxValue(OTFAuxRe);
  MinOTF:=MinValue(OTFAuxRe);
  MaxIm:=MaxValue(ImaAuxRe);
  MinIm:=MinValue(ImaAuxRe)  ;
  for j:= 0 to VecImageLength-1 do
   begin
    if (j<=(VecPSFLength-1)) and (j>=0) then
     OTFAuxRe[j]:= (OTFAuxRe[j]-MinOTF)/(MaxOTF-MinOTF);
    ImaAuxRe[j]:= (ImaAuxRe[j]-MinIm)/(MaxIm-MinIm);
   end;

  ndim_fft(PDouble(@OTFAuxRe[0]),PDouble(@OTFAuxIm[0]),2,PUINT(@ldn2Vector[0]),-1);
  ndim_fft(PDouble(@OTFAuxRe[X*Y]),PDouble(@OTFAuxIm[X*Y]),2,PUINT(@ldn2Vector[0]),-1);
  ndim_fft(PDouble(@OTFAuxRe[2*X*Y]),PDouble(@OTFAuxIm[2*X*Y]),2,PUINT(@ldn2Vector[0]),-1);


  ZeroMemory(VecImage,VecImageLength*Sizeof(Double));

  k:=0;
  Counter1:= 0;
  Counter2:= (X*Y);
  Counter3:= (2*X*Y);

  ndim_fft(PDouble(@ImaAuxRe[Counter1]),PDouble(@ImaAuxIm[Counter1]),2,PUINT(@ldn2Vector[0]),-1);
  ndim_fft(PDouble(@ImaAuxRe[Counter2]),PDouble(@ImaAuxIm[Counter2]),2,PUINT(@ldn2Vector[0]),-1);

  SetLength(ReAux,X*Y);
  SetLength(ImAux,X*Y);

  FActivityProgress.Show;

  repeat
   Application.ProcessMessages;
   FActivityProgress.PBActivityProgress.Position:=k;
   FActivityProgress.LProgress.Caption:=FormatFloat('##.#%',k/(Z-2)*100);
   FActivityProgress.Refresh;

   If not FActivityProgress.Visible then break;

   ndim_fft(PDouble(@ImaAuxRe[Counter3]),PDouble(@ImaAuxIm[Counter3]),2,PUINT(@ldn2Vector[0]),-1);

   ZeroMemory(ReAux,Length(ReAux)*Sizeof(Double));
   ZeroMemory(ImAux,Length(ImAux)*Sizeof(Double));

   for j:=Low(ReAux) to High(ReAux) do
    begin
     
     ModOTF1:=sqrt2*OTFAuxRe[j];
     ModOTF2:=sqrt2*OTFAuxRe[j+(2*X*Y)];
	 
 
     ReAux[j]:=ImaAuxRe[Counter2] - C1*((ImaAuxRe[Counter1]*ModOTF1)+(ImaAuxRe[Counter3]*ModOTF2));
     ImAux[j]:=ImaAuxIm[Counter2] - C1*((ImaAuxIm[Counter1]*ModOTF1)+(ImaAuxIm[Counter3]*ModOTF2));
     
     D:=sqr(sqr(OTFAuxRe[j+(X*Y)])+C2);
     NR:=(IntPower(OTFAuxRe[j+(X*Y)],3)+C2*OTFAuxRe[j+(X*Y)])/D;
          
     
     ImaAuxRe[Counter1] := ReAux[j]*abs(NR);
     ImaAuxIm[Counter1] := ImAux[j]*abs(NR);

     inc(Counter1);
     inc(Counter2);
     inc(Counter3);

    end;

  // Come Back where you belonged
   ndim_fft(PDouble(@ImaAuxRe[Counter1-(X*Y)]),PDouble(@ImaAuxIm[Counter1-(X*Y)]),2,PUINT(@ldn2Vector[0]),1);

 inc(k);
until k>=Z-2;

 ReAux:=nil;
 ImAux:=nil;
 OTFAuxRe:=nil;
 OTFAuxIm:=nil;

 j:=X*Y;
 repeat
  VecImage[j]:=sqrt(sqr(ImaAuxRe[j-(X*Y)])+sqr(ImaAuxIm[j-(X*Y)]));
  inc(j);
 until j>=Length(ImaAuxRe)-(X*Y);

ImaAuxRe:=nil;
ImaAuxIm:=nil;

MaxIm:=MaxValue(VecImage);
MinIm:=MinValue(VecImage);

for j:=0 to VecImageLength-1 do VecImage[j]:=(VecImage[j]-MinIm)/(MaxIm-MinIm);

FActivityProgress.Destroy;

end;
/////////// Some other funtions////////////////

procedure threedim_fft(const DataRe,DataIm: TVector; 
					   const X,Y,Z:Integer; 
					   const isign: Integer = 1);
					   
var					   
 AuxIm,AuxRe:TVector;
 ldn2Vector: array [0..1] of UINT;
 j,Counter1,Counter2:Integer;

begin
 
   
 SetLength(AuxRe,X*Y);
 SetLength(AuxIm,X*Y);
 ldn2Vector[0]:=ldn2(X);
 ldn2Vector[1]:=ldn2(Y);
 Counter1:=0;
 
while Counter1 < (X*Y*Z) do // Firts And Second Dimensions
 begin
  //CopyMemory(AuxRe,PDouble(@DataRe[Counter1]),X*Y*SizeOf(Double));
  //CopyMemory(AuxIm,PDouble(@DataIm[Counter1]),X*Y*SizeOf(Double));
  ndim_fft(PDouble(@DataRe[Counter1]),PDouble(@DataIm[Counter1]),2,PUINT(@ldn2Vector[0]),isign);
  //CopyMemory(PDouble(@DataRe[Counter1]),AuxRe,X*Y*SizeOf(Double));
  //CopyMemory(PDouble(@DataIm[Counter1]),AuxIm,X*Y*SizeOf(Double));
  inc(Counter1,X*Y);
 end; // end While Firts and Second Dimensions
 
 ldn2Vector[0]:=ldn2(Z);
 ldn2Vector[1]:=0;
 SetLength(AuxRe,Z);
 SetLength(AuxIm,Z);
 
 Counter2:=0;
 while Counter2 < (X*Y) do // Third Dimension
  begin
   Counter1:=0;
   for j:=Low(AuxRe) to High(AuxRe) do
    begin
     AuxRe[j]:=DataRe[Counter1+Counter2];
     AuxIm[j]:=DataIm[Counter1+Counter2];
     inc(Counter1,X*Y);
    end;
   ndim_fft(PDouble(@AuxRe[0]),PDouble(@AuxIm[0]),2,PUINT(@ldn2Vector[0]),isign);
   Counter1:=0;
   for j:=Low(AuxRe) to High(AuxRe) do
    begin
     DataRe[Counter1+Counter2]:=AuxRe[j];
     DataIm[Counter1+Counter2]:=AuxIm[j];
     inc(Counter1,X*Y);
    end; 
   inc(Counter2); 
  end; /// End while Third dimension
 AuxRe:=nil;
 AuxIm:=nil;
end;

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

end.