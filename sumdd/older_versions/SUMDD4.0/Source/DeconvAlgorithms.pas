unit DeconvAlgorithms;

{
 Módulo que contiene la implementación de los algoritmos de desconvolución
 utilizados para corregir la fluorescencia fuera de foco de volúmenes obtenidos
 por seccionamiento óptico.
}

interface

uses    SysUtils,
        Windows,
      	Forms,
      	Math,
      	DecTypes,
        Dialogs,
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

procedure ConstrainedIterative1(DataIn,PSF3D:TSignal3D;ZDim,XDim,YDim:Integer;DataOut:TSignal3D);

procedure WienerFilter2D(const VecPSF: TVector;
                               VecImage: TVector;
                         const X,Y,Z:Integer;
                         const c:Double);


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
  N,c,Dif,Counter,j:Integer;
  EigAux,AuxIm:TVector;
  ldn2Vector: array [0..pred(ND_MAX_DIMENSION)] of UINT;
  AuxMax1,AuxMax2,AuxMin1,AuxMin2:Double;

  begin

   FActivityProgress:=TFActivityProgress.Create(Application);
   FActivityProgress.PBActivityProgress.Max:=100;
   FActivityProgress.Caption:='Desconvolucionando';
   FActivityProgress.Show;

   ldn2Vector[0]:=ldn2(Length(VecPSF));

   SetLength(EigAux,Length(VecPSF));
   SetLength(AuxIm,Length(VecPSF));
   CopyMemory(EigAux,VecPSF,Length(VecPSF)*Sizeof(Double));

    // Normalization
       // Eig
   AuxMax1:=MaxValue(EigAux);
   AuxMin1:=MinValue(EigAux);
//   AuxMin1:=Sum(EigAux);

       // VecImage
   AuxMax2:=MaxValue(VecImage);
   AuxMin2:=MinValue(VecImage);

   for j:= Low(VecImage) to High(VecImage) do
    begin
     VecImage[j]:=(VecImage[j]-AuxMin2)/(AuxMax2-AuxMin2);
     if (j<=High(EigAux)) and (j>=Low(EigAux)) then
      EigAux[j]:=(EigAux[j]-AuxMin1)/(AuxMax1-AuxMin1);

    end;
   try
    ndim_fft(PDouble(@EigAux[0]),PDouble(@AuxIm[0]),1,PUINT(@ldn2Vector[0]));
   except
   end;

//   for j:=Low(EigAux) to High(EigAux) do  EigAux[j]:=sqrt(sqr(EigAux[j])+sqr(AuxIm[j]));

   QSortNR(EigAux); // sort not recursive

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

    Application.ProcessMessages;
    FActivityProgress.PBActivityProgress.Position:=Trunc((Counter)/(Length(VecImage)-1)*100);
    FActivityProgress.LProgress.Caption:=FormatFloat('##.#%',(Counter/(Length(VecImage)-1)*100));
    FActivityProgress.Refresh;

    if not FActivityProgress.Visible then exit;

     ZeroMemory(AuxIm,Length(AuxIm)*Sizeof(Double));
     try
     ndim_fft(PDouble(@VecImage[Counter]),PDouble(@AuxIm[0]),1,PUINT(@ldn2Vector[0]));
     except
     end;

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
     try
      ndim_inv_fft(PDouble(@VecImage[Counter]),PDouble(@AuxIm[0]),1,PUINT(@ldn2Vector[0]));
     except

     end;
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

    EigAux:=nil;
    AuxIm:=nil;

    AuxMax1:= MaxValue(VecImage);
//    AuxMin1:=MinValue(VecImage);
    for j:=Low(VecImage) to High(VecImage) do
     VecImage[j]:=VecImage[j]/AuxMax1*255;

    FActivityProgress.Destroy;

 end;
procedure ConstrainedIterative(DataIn,PSF3D:TSignal3D;const ZDim,XDim,YDim:Integer;DataOut:TSignal3D);
var
 R,MaxSumIntData,MaxSumIntPSF,MaxDataIn,minDataIn,A,MinOTF,MaxOTF:Single;
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
// SetLength(SumIntData,ZDim);
 SetLength(SumIntPSF,ZDim);
 for k:= 0 to ZDim-1 do
  begin
  // SumIntData[k]:=SumTSignal2D(DataIn[k]);
   SumIntPSF[k]:=SumTSignal2D(PSF3D[k]);
  end;

// MaxSumIntData:=MaxValue(SumIntData);
 MaxSuMIntPSF:=MaxValue(SumIntPSF);
 for j:=0 to XDim-1 do
  for i:=0 to YDim-1 do
   for k:=0 to ZDim-1 do
    begin
//     DataIn[k,j,i].Re:= DataIn[k,j,i].Re*MaxSumIntData/SumIntData[k];
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


 Set3DDimension(FImAux,ZDim,XDim,YDim);
 DirectFFT3D(DataIn,XDim,YDim,ZDim,FImAux);

 Set3DDimension(OTF,ZDim,XDim,YDim);
 DirectFFT3D(PSF3D,XDim,YDim,ZDim,OTF);

 minDataIn:=sqr(MinTSignal3DABS(FImAux,ZDim,XDim,YDim));
 MaxDataIn:=sqr(MaxTSignal3DABS(FImAux,ZDim,XDim,YDim));
 MaxOTF:=sqr(MaxTSignal3DABS(OTF,ZDim,XDim,YDim));
 MinOTF:=sqr(MinTSignal3DABS(OTF,ZDim,XDim,YDim));
 for k:=0 to ZDim-1 do
  for j:=0 to XDim-1 do
   for i:=0 to YDim-1 do
    begin
//     OTF[k,j,i].Re:=((sqr(OTF[k,j,i].Re)+sqr(OTF[k,j,i].Im))-MinOTF)/(MaxOTF-MinOTF);
     OTF[k,j,i].Re:=OTF[k,j,i].Re/MaxOTF;
     OTF[k,j,i].Im:=OTF[k,j,i].Im/MaxOTF;
     //FImAux[k,j,i].Re:=(sqrt(sqr(FImAux[k,j,i].Re)+sqr(FImAux[k,j,i].Im)-MinDataIn))/(MaxDataIn-MinDataIn);
//     FImAux[k,j,i].Re:=FImAux[k,j,i].Re/MaxDataIn;
//     FImAux[k,j,i].Im:=FImAux[k,j,i].Im/MaxDataIn;
     //FImAux[k,j,i].Re:=FImAux[k,j,i].Re;
     //FImAux[k,j,i].Im:=FImAux[k,j,i].Im;
     //OTF[k,j,i].Re:=OTF[k,j,i].Re/MaxOTF;
     //OTF[k,j,i].Im:=OTF[k,j,i].Im/MaxOTF;
    end;


 Set3DDimension(FObAux,ZDim,XDim,YDim);
 Set3DDimension(gamma,ZDim,XDim,YDim);
 Set3DDimension(ObAux,ZDim,XDim,YDim);

 //A:=0.5;
// A := MaxTSignal3DABS(DataIn,ZDim,XDim,YDim)/2;
// iterate:=5;
 Count:=0;
 R:=100;
 while {Count<=iterate} R > 0.1 do
  begin
//////////  Convolución 3D /////////////////////////////////
   for k:=0 to ZDim-1 do
    for j:=0 to XDim-1 do
     for i:=0 to YDim-1 do
      begin
       FObaux[k,j,i].Re := (FImAux[k,j,i].Re*OTF[k,j,i].Re);//-(FImAux[k,j,i].Im*OTF[k,j,i].Im);
       FObaux[k,j,i].Im := (FImAux[k,j,i].Im*OTF[k,j,i].IM);//+(FImAux[k,j,i].Re*OTF[k,j,i].Im);
      end;
//////////////////////////////////////////////////////////
   InverseFFT3D(FObAux,XDim,YDim,ZDim,ObAux);
   InverseFFT3D(FImAux,XDim,YDim,ZDim,DataOut);
   //NORMALIZACIÓN
   minDataIn:=sqr(MinTSignal3DABS(ObAux,ZDim,XDim,YDim));
   MaxDataIn:=sqr(MaxTSignal3DABS(ObAux,ZDim,XDim,YDim));
   MinOTF:=sqr(MinTSignal3DABS(DataOut,ZDim,XDIm,YDim));
   MaxOTF:=sqr(MaxTSignal3DABS(DataOut,ZDim,XDIm,YDim));
   for j:=0 to XDim-1 do
    for i:=0 to YDim-1 do
     for k:=0 to ZDim-1 do
      begin
 //      ObAux[k,j,i].Re:= (sqr(ObAux[k,j,i].Re)+sqr(ObAux[k,j,i].Im) - MinDataIn)/(MaxDataIn-MinDataIn);
 //      DataOut[k,j,i].Re:=((sqr(DataOut[k,j,i].Re)+sqr(DataOut[k,j,i].Im))- MinOTF)/(MaxOTF-MinOTF);
       ObAux[k,j,i].Re:= (sqr(ObAux[k,j,i].Re)+sqr(ObAux[k,j,i].Im));
       DataOut[k,j,i].Re:=((sqr(DataOut[k,j,i].Re)+sqr(DataOut[k,j,i].Im)));
     end;


////////////////// Determinación del estimador////////////////////////////
   for k:=0 to ZDim-1 do
    for j:=0 to XDim-1 do
     for i:=0 to YDim-1 do
      begin
       //gamma[k,j,i].Re:= 1 - sqr(sqrt(sqr(ObAux[k,j,i].Re)+sqr(ObAux[k,j,i].Im))-0.5)/0.25;
       gamma[k,j,i].Re:= 1 - sqr(ObAux[k,j,i].Re-0.5)/0.25;
//       gamma[k,j,i].Im:= ObAux[k,j,i].Re*ObAux[k,j,i].Im/sqr(A);
       DataOut[k,j,i].Re:= DataOut[k,j,i].Re + gamma[k,j,i].Re*(DataIn[k,j,i].Re-ObAux[k,j,i].Re);
       DataOut[k,j,i].Im:= 0;
          ///////////////Positividad//////////////////////////////////////
       if (DataOut[k,j,i].Re<0) then
        begin
         DataOut[k,j,i].Re:=0;
        end
     end;

//////////////////////////// Convergence////////////////////////////////////////

   for k:=0 to ZDim-1 do
    for j:=0 to XDim-1 do
     for i:=0 to YDim-1 do
      begin
       gamma[k,j,i].Re:=abs(DataIn[k,j,i].Re-ObAux[k,j,i].Re);
      end;

   R:=SumTSignal3D(gamma)/SumTSignal3D(DataIn);
////////////////////////////////////////////////////////////////////////////////
   Application.ProcessMessages;
   FActivityProgress.PBActivityProgress.Position:=trunc(Count/iterate*100);
   FActivityProgress.LProgress.Caption:=FormatFloat('##.##%',Count/iterate*100)+ '   R = ' + FormatFloat('##.##%',R*100);
   FActivityProgress.Refresh;
   if not FActivityProgress.Visible then exit;



   {MaxDataIn:=MaxTSignal3DABS(DataOut,ZDim,XDim,YDim);
   for k:=0 to ZDim-1 do
    for j:=0 to XDim-1 do
     for i:=0 to YDim-1 do
      begin
//       DataOut[k,j,i].Re:= DataOut[k,j,i].Re*MaxSumInt/SumInt[k];
       DataOut[k,j,i].Re:=sqrt(sqr(DataOut[k,j,i].Re)+sqr(DataOut[k,j,i].Im))/MaxDataIn;
       //DataOut[k,j,i].Re:=ObAux[k,j,i].Re;
      end;}


   DirectFFT3D(DataOut,XDim,YDim,ZDim,FImAux);
   {minDataIn:=MinTSignal3DABS(FImAux,ZDim,XDim,YDim);
   MaxDataIn:=MaxTSignal3DABS(FImAux,ZDim,XDim,YDim);
   for k:=0 to ZDim-1 do
    for j:=0 to XDim-1 do
     for i:=0 to YDim-1 do
      begin
       //FImAux[k,j,i].Re:=(sqrt(sqr(FImAux[k,j,i].Re)+sqr(FImAux[k,j,i].Im)-MinDataIn))/(MaxDataIn-MinDataIn);
       FImAux[k,j,i].Re:=FImAux[k,j,i].Re/MaxDataIn;
       FImAux[k,j,i].Im:=FImAux[k,j,i].Im/MaxDataIn;
       //FImAux[k,j,i].Re:=FImAux[k,j,i].Re;
       //FImAux[k,j,i].Im:=FImAux[k,j,i].Im;
      end;
    }
   inc(Count,1);
  end; // End While

 FActivityProgress.Destroy;
end;// end begin

procedure ConstrainedIterativeNEW(const VecPSF: TVector;
			                                  VecImage:TVector;
                  	              const XDim,YDim,ZDim:Integer);
var

 logfile: TextFile; // Para realizar controles
 gamma,MaxError,Tolerancia,PresentError,PastError,SumAux,MaxAux1,MaxAux2,MinAux1,MinAux2:Double;
 Count,iterate,j:Integer;
 AuxRe1,AuxIm1,AuxRe2,AuxIm2,AuxRe3:TVector;
 ldn3Vector:array [0..2] of UINT;
 A:Double;

begin
///// Para hacer logging de algunos datos
//  AssignFile(logfile,'C:\JavierD\Programming\SUMDD3.0\Output\log.txt'); /// directorio en casa
  AssignFile(logfile,'C:\JavierD\Programming\SUMDD3.0\Output\log.txt');

  ReWrite(logfile);
  writeln(logfile,'It  VecImage        AuxRe2        AuxRe3');

 SetLength(AuxRe1,Length(VecImage));
 SetLength(AuxRe2,Length(VecImage));
 SetLength(AuxIm1,Length(VecImage));
 SetLength(AuxIm2,Length(VecImage));

 // PSF and Image Normalization
 MaxAux2:=MaxValue(VecImage);
 MinAux2:=MinValue(VecImage);
 MinAux1:=MinValue(VecPSF);
 MaxAux1:=MaxValue(VecPSF);

 Tolerancia := 1/255;

 /// normalizacion entre cero y uno
 for j:=Low(VecImage)to High(VecImage) do
  begin
   VecImage[j]:=(VecImage[j]-MinAux2)/(MaxAux2-MinAux2);
   AuxRe1[j]:=(VecPSF[j]-MinAux1)/(MaxAux1-MinAux1)
  end;

 CopyMemory(AuxRe2,VecImage,Sizeof(Double)*Length(VecImage));

 SumAux:=1/(Sum(AuxRe1));
  for j:=Low(VecImage)to High(VecImage) do
    AuxRe1[j]:=AuxRe1[j]*SumAux;

 FActivityProgress:= TFActivityProgress.Create(Application);
 FActivityProgress.Caption:='Desconvolucionando';
 FActivityProgress.Show;
 FActivityProgress.PBActivityProgress.Position:=0;
 FActivityProgress.LProgress.Caption:='Its.:'+ FormatFloat('##.##%',0.0);
 FActivityProgress.Refresh;

 ldn3Vector[0]:=ldn2(XDim);
 ldn3Vector[1]:=ldn2(YDim);
 ldn3Vector[2]:=ldn2(ZDim);


try
 ndim_fft(PDouble(@AuxRe1[0]),PDouble(@AuxIm1[0]),3,PUINT(@ldn3Vector[0])); //OTF
except on E: Exception do  MessageDlg(E.Message,mtWarning, [mbOk],0);
end;

 for j:=Low(VecImage) to High(VecImage) do
  AuxRe1[j]:= sqrt(sqr(AuxRe1[j])+sqr(AuxIm1[j]));
 {
 SumAux:=1/(Sum(AuxRe1));
  for j:=Low(VecImage)to High(VecImage) do
    AuxRe1[j]:=AuxRe1[j]*SumAux;
  }


 SetLength(AuxRe3,Length(VecImage));


 A := MaxValue(AuxRe2)/2;
 Iterate:=1;
 Count:=0;
 PastError:=0;
 PresentError:=1000;
// SetLength(gamma,LenAux);}
 while abs(PresentError-PastError)>Tolerancia  do
// while Count<Iterate do
  begin
//   if Count<Iterate then
   try
    ndim_fft(PDouble(@AuxRe2[0]),PDouble(@AuxIm2[0]),3,PUINT(@ldn3Vector[0]));
   except on E: Exception do  MessageDlg(E.Message,mtWarning, [mbOk],0);
   end;

//////////  Convolución 3D /////////////////////////////////
   for j:=Low(VecImage)to High(VecImage) do
    begin
     AuxRe3[j]:=AuxRe2[j]*AuxRe1[j];
     AuxIm1[j]:=AuxIm2[j]*AuxRe1[j];
//     AuxRe3[j]:=AuxRe1[j];
//     AuxIm3[j]:=AuxIm1[j];
    end;

   try
    ndim_inv_fft(PDouble(@AuxRe2[0]),PDouble(@AuxIm2[0]),3,PUINT(@ldn3Vector[0]));
    ndim_inv_fft(PDouble(@AuxRe3[0]),PDouble(@AuxIm1[0]),3,PUINT(@ldn3Vector[0]));
   except on E: Exception do  MessageDlg(E.Message,mtWarning, [mbOk],0);
   end;


  MinAux1:=MinValue(AuxRe3);
  MaxAux1:=MaxValue(AuxRe3);
  for j:=Low(VecImage)to High(VecImage) do
    AuxRe3[j]:=(AuxRe3[j]-MinAux1)/(MaxAux1-MinAux1);

  writeln(logfile,IntToStr(Count)+'  '+FloatToStr(Sum(VecImage))+'   '+FloatToStr(Sum(AuxRe2))+ '   '+FloatToStr(Sum(AuxRe3)));

  Application.ProcessMessages;
   if not FActivityProgress.Visible then break;

//  ZeroMemory(AuxIm2,Length(VecImage)*SizeOf(Double));

////////////////////////////////////////////////////////////////////
   MaxError:=0;
   for j:= Low(VecImage) to High(VecImage) do
    begin
     gamma:=1 - (sqr(AuxRe3[j]-A)/sqr(A));
//     gamma[j]:= 1 - (sqr(AuxRe3[j]-A)/sqr(A));
     AuxRe2[j]:= AuxRe2[j] + gamma*(VecImage[j]-AuxRe3[j]);;
     MaxError:=Max((VecImage[j]-AuxRe3[j]),MaxError);
    // AuxRe2[j]:=AuxRe3[j];
     AuxIm2[j]:=0;
 ///////////////Positividad//////////////////////////////////////
       if (AuxRe2[j]<0) then AuxRe2[j]:=0;
       if (AuxRe2[j]>2*A) then AuxRe2[j]:=2*A;
     end;

//    for j:=Low(VecImage) to High(VecImage) do
//     gamma[j]:=abs(VecImage[j]-AuxRe3[j]);

{   R1:=R2;
    R2:=Sum(gamma)/Sum(VecImage);
    Error:=abs(R2-R1);
 }
   PastError:=PresentError;
   PresentError:=MaxError;
   //FActivityProgress.PBActivityProgress.Position:=trunc(Error*100);
   //FActivityProgress.LProgress.Caption:='R: ' + FormatFloat('##.####%',abs(1-Error)*100)+ '  It.: ' + IntToStr(Count);
   FActivityProgress.LProgress.Caption:='Máximo Error: ' + FormatFloat('##.####%',PresentError)+ '  It.: ' + IntToStr(Count);
   FActivityProgress.Refresh;
////////////////////////////////////////////////////////////////////

//   CopyMemory(AuxIm1,AuxIm2,LenAux*Sizeof(Double));

{  if Count=Iterate then
  MaxAux2:=MaxValue(AuxRe2);
  MinAux2:=MinValue(AuxRe2);
  for j:=Low(VecImage)to High(VecImage) do
    VecImage[j]:=255*(AuxRe2[j]-MinAux2)/(MaxAux2-MinAux2);
 }

   inc(Count);

    {if Count=Iterate then
    for j:=Low(VecImage) to High(VecImage) do
     VecImage[j]:=AuxRe2[j]*MaxAux2;}

  end; // End While

 for j:=Low(VecImage) to High(VecImage) do
     VecImage[j]:=AuxRe2[j]*MaxAux2;

 CloseFile(LogFile);
 FActivityProgress.Destroy;

end;// end begin

procedure WienerFilter2D(const VecPSF: TVector;
                               VecImage: TVector;
                         const X,Y,Z:Integer;
                         const c:Double);
var
 ImAux,ReAux,OTFAuxRe,OTFAuxIm:array of Double;
 ldn2Vector: array [0.. 1] of UINT;
 Counter1,j,k,VecPSFLength :Integer;
 D,NR,NI,MinIm,MaxIm,MinOTF,MaxOTF:Double;

 begin

  ldn2Vector[0]:=ldn2(X);
  ldn2Vector[1]:=ldn2(Y);

  FActivityProgress:=TFActivityProgress.Create(Application);
  FActivityProgress.PBActivityProgress.Max:=Z;
  FActivityProgress.Caption:='Desconvolucionando';


  VecPSFLength:=Length(VecPSF);

  SetLength(OTFAuxRe,VecPSFLength);
  SetLength(OTFAuxIm,VecPSFLength);
  CopyMemory(OTFAuxRe,VecPSF,VecPSFLength*Sizeof(Double));

 //PSF And Image Normalization

  MaxOTF:=MaxValue(OTFAuxRe);
  MinOTF:=MinValue(OTFAuxRe);
  for j:= 0 to VecPSFLength-1 do
   begin
      OTFAuxRe[j]:= (OTFAuxRe[j]-MinOTF)/(MaxOTF-MinOTF);
   end;


  MaxOTF:=Sum(OTFAuxRe);
  for j:= 0 to VecPSFLength-1 do
    OTFAuxRe[j]:= OTFAuxRe[j]/MaxOTF;


 /////////////////OTF///////////////////////////////

  ndim_fft(PDouble(@OTFAuxRe[0]),PDouble(@OTFAuxIm[0]),2,PUINT(@ldn2Vector[0]));

/////////////OTF////////////////////////////
  SetLength(ReAux,VecPSFLength);
  for j:=0 to VecPSFLength-1 do
   begin
    OTFAuxRe[j]:=sqrt(sqr(OTFAuxRe[j])+sqr(OTFAuxIm[j]));
    D:=sqr(OTFAuxRe[j])+ c;
    OTFAuxRe[j]:=OTFAuxRe[j]/D;
   end;

/////////////////////////////////////////////////////////
  k:=0;
  Counter1:= 0;

  SetLength(ImAux,VecPSFLength);

  FActivityProgress.Show;

  repeat
   Application.ProcessMessages;
   FActivityProgress.PBActivityProgress.Position:=k;
   FActivityProgress.LProgress.Caption:=FormatFloat('##.#%',K*100/Z);
   FActivityProgress.Refresh;

   If not FActivityProgress.Visible then break;

   ZeroMemory(ReAux,Length(ReAux)*Sizeof(Double));
   ZeroMemory(ImAux,Length(ReAux)*Sizeof(Double));

   CopyMemory(ReAux,@VecImage[Counter1],Length(ReAux)*Sizeof(Double));

   MaxIm:=MaxValue(ReAux);
   MinIm:=MinValue(ReAux)  ;

   for j:= 0 to VecPSFLength-1 do
    ReAux[j]:= (ReAux[j]-MinIm)/(MaxIm-MinIm);

   MaxIm:=(MaxIm-MinIm);

/// Image Transformation
   try
    ndim_fft(PDouble(@ReAux[0]),PDouble(@ImAux[0]),2,PUINT(@ldn2Vector[0]));
   except on E: Exception do MessageDlg('1st image fft',mtError,[mbOk],0);

   end;

///

   for j:= 0 to VecPSFLength-1 do
    begin
     //NR:=1;
     //ReAux[j] := ReAux[j]*NR;
     //ImAux[j] := ImAux[j]*NR;
     try
      ReAux[j] := ReAux[j]*OTFAuxRe[j];
      ImAux[j] := ImAux[j]*OTFAuxRe[j];
     except on E: Exception do MessageDlg('es acá!!',mtError,[mbOk],0);

     end;

     inc(Counter1);
    end;

 // Come Back where you belonged
  try
   ndim_inv_fft(PDouble(@ReAux[0]),PDouble(@ImAux[0]),2,PUINT(@ldn2Vector[0]));
  except on E: Exception do MessageDlg('The Come Back',mtError,[mbOk],0);

  end;

  for j:= 0 to VecPSFLength-1 do
   begin
    ReAux[j]:= sqrt(sqr(ReAux[j])+sqr(ImAux[j]));
    VecImage[Counter1 -(X*Y)+ j]:=ReAux[j]*MaxIm;
   end;

 inc(k);

until k>=Z;

ReAux:=nil;
ImAux:=nil;
OTFAuxRe:=nil;
OTFAuxIm:=nil;

FActivityProgress.Destroy;

end;


procedure NearestNeighborndNEW(const VecPSF: TVector;
				     VecImage: TVector;
               		       const X,Y,Z:Integer;
              		       const C1,C2:Double);
var
 ImAux,ReAux,OTFAuxRe,OTFAuxIm,ImaAuxRe,ImaAuxIm:array of Double;
 ldn2Vector: array [0..1] of UINT;
 Counter1, Counter2,Counter3,j,k,VecImageLength,VecPSFLength :Integer;
 SumAux,D,MinIm,MaxIm,MinOTF,MaxOTF:Double;
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

  //PSF And Image Normalization

  MaxOTF:=MaxValue(OTFAuxRe);
  MinOTF:=MinValue(OTFAuxRe);
  MaxIm :=MaxValue(ImaAuxRe);
  MinIm :=MinValue(ImaAuxRe)  ;
  for j:= 0 to VecImageLength-1 do
   begin
    if (j<=(VecPSFLength-1)) and (j>=0) then
     OTFAuxRe[j]:= (OTFAuxRe[j]-MinOTF)/(MaxOTF-MinOTF);
    ImaAuxRe[j]:= (ImaAuxRe[j]-MinIm)/(MaxIm-MinIm);
   end;

  SumAux:=3/Sum(OTFAuxRe);
  for j:= 0 to (VecPSFLength-1) do OTFAuxRe[j]:= OTFAuxRe[j]*SumAux;

 //////////////////////////////////OTF/////////////////////////////////////////
  SetLength(ReAux,X*Y);
  SetLength(ImAux,X*Y);

  try
   ndim_fft(PDouble(@OTFAuxRe[0]),PDouble(@OTFAuxIm[0]),2,PUINT(@ldn2Vector[0]));
   ndim_fft(PDouble(@OTFAuxRe[X*Y]),PDouble(@OTFAuxIm[X*Y]),2,PUINT(@ldn2Vector[0]));
   ndim_fft(PDouble(@OTFAuxRe[2*X*Y]),PDouble(@OTFAuxIm[2*X*Y]),2,PUINT(@ldn2Vector[0]));
  except on E: Exception do  MessageDlg(E.Message,mtWarning, [mbOk], 0);
  end;


  for j:=Low(OTFAuxRe) to High(OTFAuxRe) do
   begin
    OTFAuxRe[j]:=sqrt(sqr(OTFAuxRe[j])+sqr(OTFAuxIm[j]));
    if (j>=X*Y) and (j<=2*X*Y) then
     begin
      D:=sqr(OTFAuxRe[j])+ c2;
      OTFAuxRe[j]:=OTFAuxRe[j]/D;
     end
   end;
     

///////////////////////////////////////////////////////
  ZeroMemory(VecImage,VecImageLength*Sizeof(Double));

  k:=0;
  Counter1:= 0;
  Counter2:= (X*Y);
  Counter3:= (2*X*Y);


  ndim_fft(PDouble(@ImaAuxRe[Counter1]),PDouble(@ImaAuxIm[Counter1]),2,PUINT(@ldn2Vector[0]));
  ndim_fft(PDouble(@ImaAuxRe[Counter2]),PDouble(@ImaAuxIm[Counter2]),2,PUINT(@ldn2Vector[0]));

  SetLength(ReAux,X*Y);
  SetLength(ImAux,X*Y);

  FActivityProgress.Show;

  repeat
   Application.ProcessMessages;
   FActivityProgress.PBActivityProgress.Position:=k;
   FActivityProgress.LProgress.Caption:=FormatFloat('##.#%',k/(Z-2)*100);
   FActivityProgress.Refresh;

   If not FActivityProgress.Visible then break;

   ndim_fft(PDouble(@ImaAuxRe[Counter3]),PDouble(@ImaAuxIm[Counter3]),2,PUINT(@ldn2Vector[0]));

   ZeroMemory(ReAux,Length(ReAux)*Sizeof(Double));
   ZeroMemory(ImAux,Length(ImAux)*Sizeof(Double));

   for j:=Low(ReAux) to High(ReAux) do
    begin
     ReAux[j]:=ImaAuxRe[Counter2] - c1*((ImaAuxRe[Counter1]*OTFAuxRe[j])+(ImaAuxRe[Counter3]*OTFAuxRe[j+(2*X*Y)]));
     ImAux[j]:=ImaAuxIm[Counter2] - c1*((ImaAuxIm[Counter1]*OTFAuxRe[j])+(ImaAuxIm[Counter3]*OTFAuxRe[j+(2*X*Y)]));
 //    ReAux[j]:=ImaAuxRe[Counter3];
 //    ImAux[j]:=ImaAuxIm[Counter3];
//     ImaAuxRe[Counter1] := ImaAuxRe[Counter3]*NR;
//     ImaAuxIm[Counter1] := ImaAuxIm[Counter3]*NR;
     ImaAuxRe[Counter1] := ReAux[j]*OTFAuxRe[j+(X*Y)];
     ImaAuxIm[Counter1] := ImAux[j]*OTFAuxRe[j+(X*Y)];
     inc(Counter1);
     inc(Counter2);
     inc(Counter3);
    end;

 // Come Back where you belonged
   ndim_inv_fft(PDouble(@ImaAuxRe[Counter1-(X*Y)]),PDouble(@ImaAuxIm[Counter1-(X*Y)]),2,PUINT(@ldn2Vector[0]));

   CopyMemory(ReAux,@ImaAuxRe[Counter1-(X*Y)],Length(ReAux)*Sizeof(Double));
   CopyMemory(ImAux,@ImaAuxRe[Counter1-(X*Y)],Length(ReAux)*Sizeof(Double));

   for j:=Low(ReAux) to High(ReAux) do
    VecImage[Counter1+j]:=MaxIm*(sqrt(sqr(ReAux[j])+sqr(ImAux[j])));

  inc(k);

until k>=Z-2;
 ReAux:=nil;
 ImAux:=nil;
 OTFAuxRe:=nil;
 OTFAuxIm:=nil;

ImaAuxRe:=nil;
ImaAuxIm:=nil;

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
procedure ConstrainedIterative1(DataIn,PSF3D:TSignal3D;ZDim,XDim,YDim:Integer;DataOut:TSignal3D);
var
 MaxPSF,MinPSF,Error,R1,R2,MaxSumInt,MaxDataIn,minDataIn,MaxImAux,A,MaxOTF:Single;
 Ob,FObAux,ObAux,FImAux,ImAux,OTF,gamma:TSignal3D;
 iterate,i,j,k,Count:Integer;
 SumInt: array of Double;

begin
 FActivityProgress:= TFActivityProgress.Create(Application);
 FActivityProgress.Caption:='Desconvolucionando';
 FActivityProgress.PBActivityProgress.Visible:=False;
 FActivityProgress.LProgress.Left:= (FActivityProgress.Width div 2 ) - (FActivityProgress.Width div 4 );
 FActivityProgress.LProgress.Top:= (FActivityProgress.Height div 4);
 FActivityProgress.Show;
//FActivityProgress.PBActivityProgress.Position:=0;
// FActivityProgress.LProgress.Caption:=FormatFloat('##.##%',0.0);
 FActivityProgress.Refresh;

// Sustracción de Background
 minDataIn:=MinTSignal3DABS(DataIn,ZDim,XDim,YDim);
 MaxDataIn:=MaxTSignal3DABS(DataIn,ZDim,XDim,YDim);
 minPSF:=MinTSignal3DABS(PSF3D,ZDim,XDim,YDim);
 MaxPSF:=MaxTSignal3DABS(PSF3D,ZDim,XDim,YDim);
 for j:=0 to XDim-1 do
  for i:=0 to YDim-1 do
   for k:=0 to ZDim-1 do
    begin
     DataIn[k,j,i].Re:= 255*(DataIn[k,j,i].Re - minDataIn)/(MaxDataIn-MinDataIn);
     PSF3D[k,j,i].Re:= 255*(PSF3D[k,j,i].Re - minPSF)/(MaxPSF-MinPSF);
    end;

// NORMALIZACIÓN
// PSF Normalization
// SetLength(SumInt,ZDim);
//   for k:= 0 to ZDim-1 do SumInt[k]:=SumTSignal2D(PSF3D[k]);

{ MaxSumInt:=MaxValue(SumInt);
 for j:=0 to XDim-1 do
  for i:=0 to YDim-1 do
   for k:=0 to ZDim-1 do
    PSF3D[k,j,i].Re:= PSF3D[k,j,i].Re*MaxSumInt/SumInt[k];
 SumInt:=nil;

 MaxDataIn:=MaxTSignal3DABS(PSF3D,ZDim,XDim,YDim);
 for j:=0 to XDim-1 do
  for i:=0 to YDim-1 do
   for k:=0 to ZDim-1 do
    PSF3D[k,j,i].Re:= PSF3D[k,j,i].Re/MaxDataIn;
}
 MaxDataIn:=SumTSignal3D(PSF3D);
 for j:=0 to XDim-1 do
  for i:=0 to YDim-1 do
   for k:=0 to ZDim-1 do
    PSF3D[k,j,i].Re:= PSF3D[k,j,i].Re/MaxDataIn;

 Set3DDimension(OTF,ZDim,XDim,YDim);
 DirectFFT3D(PSF3D,XDim,YDim,ZDim,OTF);

{MaxOTF:=sqr(MaxTSignal3DABS(OTF,ZDim,XDim,YDim));
 for k:=0 to ZDim-1 do
  for j:=0 to XDim-1 do
   for i:=0 to YDim-1 do
    begin
     OTF[k,j,i].Re:=OTF[k,j,i].Re/MaxOTF;
     OTF[k,j,i].Im:=OTF[k,j,i].Im/MaxOTF;
    end; }

 Ob:=DataIn;
 Set3DDimension(FImAux,ZDim,XDim,YDim);
 Set3DDimension(FObAux,ZDim,XDim,YDim);
 Set3DDimension(gamma,ZDim,XDim,YDim);
 ImAux:=DataOut;
 DirectFFT3D(Ob,XDim,YDim,ZDim,FImAux);
 Set3DDimension(ObAux,ZDim,XDim,YDim);

 A := MaxTSignal3DABS(DataIn,ZDim,XDim,YDim)/2;
 iterate:=5;
 Count:=0;
 R2:=0;
 Error:=0;
 while (Count<=iterate) or (Error>0.1) do
  begin
//////////  Convolución 3D /////////////////////////////////
   for k:=0 to ZDim-1 do
    for j:=0 to XDim-1 do
     for i:=0 to YDim-1 do
      begin
       FObaux[k,j,i].Re :=  FImAux[k,j,i].Re*OTF[k,j,i].Re-FImAux[k,j,i].Im*OTF[k,j,i].Im;
       FObaux[k,j,i].Im :=  FImAux[k,j,i].Im*OTF[k,j,i].Re+FImAux[k,j,i].Re*OTF[k,j,i].Im;
      end;
//////////////////////////////////////////////////////////
   InverseFFT3D(FObAux,XDim,YDim,ZDim,ObAux);
   InverseFFT3D(FImAux,XDim,YDim,ZDim,ImAux);

////////////////// Determinación del estimador////////////////////////////
   for k:=0 to ZDim-1 do
    for j:=0 to XDim-1 do
     for i:=0 to YDim-1 do
      begin
//      gamma[k,j,i].Re:= 1 - (sqr(sqr(ObAux[k,j,i].Re)+sqr(ObAux[k,j,i].Im))-A)/sqr(A);
       gamma[k,j,i].Re:= 1;// Van Citert's Method
//       gamma[k,j,i].Re:= 1 - abs(ObAux[k,j,i].Re-A)/sqr(A); // Jansson's Method
//       ImAux[k,j,i].Re:= ImAux[k,j,i].Re + gamma[k,j,i].Re*(Ob[k,j,i].Re-(sqr(ObAux[k,j,i].Re)+sqr(ObAux[k,j,i].Im)));
       ImAux[k,j,i].Re:= ImAux[k,j,i].Re + gamma[k,j,i].Re*(Ob[k,j,i].Re-ObAux[k,j,i].Re);// Algebraic update
//       ImAux[k,j,i].Re:= ImAux[k,j,i].Re * gamma[k,j,i].Re*(Ob[k,j,i].Re/ObAux[k,j,i].Re);// Geometric update
//       ImAux[k,j,i].Re:= sqrt(sqr(ImAux[k,j,i].Re)+sqr(ImAux[k,j,i].Im)) + gamma[k,j,i].Re*(Ob[k,j,i].Re-sqrt(sqr(ObAux[k,j,i].Re)+sqr(ObAux[k,j,i].Im)));
       ImAux[k,j,i].Im:= 0;

///////////////Positividad//////////////////////////////////////
       if (ImAux[k,j,i].Re<0) then  ImAux[k,j,i].Re:=0;
     end;

   for k:=0 to ZDim-1 do
    for j:=0 to XDim-1 do
     for i:=0 to YDim-1 do
      begin
       gamma[k,j,i].Re:=abs(DataIn[k,j,i].Re-ObAux[k,j,i].Re);
      end;

   R1:=R2;
   R2:=SumTSignal3D(gamma)/SumTSignal3D(DataIn);

   Error:=abs(R2-R1);


   Application.ProcessMessages;
// FActivityProgress.PBActivityProgress.Position:=trunc(Error*100);
   FActivityProgress.LProgress.Caption:='R: ' + FormatFloat('##.####%',abs(1-Error)*100)+ '  It.: ' + IntToStr(Count);
   FActivityProgress.Refresh;
   if not FActivityProgress.Visible then exit;

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
   DirectFFT3D(ImAux,XDim,YDim,ZDim,FImAux);

{   for k:=0 to ZDim -1 do
    begin
     MaxImAux:=sqr(MaxTSignal2DABS(ImAux[k],XDim,YDim));
     for i:=0 to YDim-1 do
      for j:=0 to XDim-1  do
       if (count<iterate)   then //and (Error<0.9999999)
        begin
        // ImAux[k,j,i].Re:= (sqr(ImAux[k,j,i].Re)+sqr(ImAux[k,j,i].Im))/MaxImAux*255;
        // ImAux[k,j,i].Im:=0;
        end
       else
        begin
         //ImAux[k,j,i].Re:= (sqr(ImAux[k,j,i].Re)+sqr(ImAux[k,j,i].Im))/MaxImAux;
         //ImAux[k,j,i].Im:=0;
        end;
    end;}

 {  MaxImAux:=sqr(MaxTSignal3DABS(ImAux,ZDim,XDim,YDim));
   for k:=0 to ZDim-1 do
    for j:=0 to XDim-1 do
     for i:=0 to YDim-1 do
       if (count<iterate) and (Error<0.9999)  then
        begin
         ImAux[k,j,i].Re:= (sqr(ImAux[k,j,i].Re)+sqr(ImAux[k,j,i].Im))/MaxImAux*255;
         ImAux[k,j,i].Im:=0;
        end
       else
        begin
         ImAux[k,j,i].Re:= (sqr(ImAux[k,j,i].Re)+sqr(ImAux[k,j,i].Im))/MaxImAux;
         ImAux[k,j,i].Im:=0;
        end;
  }

   Count:=Count+1;

  end; // End While

  MaxImAux:=MaxTSignal3DABS(ImAux,ZDim,XDim,YDim);
   for k:=0 to ZDim-1 do
    for j:=0 to XDim-1 do
     for i:=0 to YDim-1 do
      ImAux[k,j,i].Re:= ImAux[k,j,i].Re/MaxImAux;

  FActivityProgress.Destroy;

 end;// end begin
end.