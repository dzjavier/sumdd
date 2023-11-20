unit Sectioning;

interface

uses FilesManagement,CameraControl,StageControl,LightMonitor,DecTypes,SysUtils,
ProgressActivity, windows, Forms;

type
 Sectioner = class
   public
    procedure doOpticalSectioning(const DeltaZ:single;
                                 const DosisControl: boolean;
                                 const HeaderFileName: string;
                                 const AverageImages: word;
                                 const ExpositionTime:double ;
                                 const InitialSection: word;
                                 const XRes: single;
                                 const YRes: single;
                                 const XDimension: word;
                                 const YDimension: word;
                                 const ZDimension: word);

    procedure doTemporalSectioning(const DeltaT:single;
                                 const ExpositionTime:double;
                                 const DosisControl: boolean;
                                 const HeaderFileName: string;
                                 const AverageImages: word;
                                 const InitialSection: Word;
                                 const XRes: single;
                                 const YRes: single;
                                 const XDimension: word;
                                 const YDimension: word;
                                 const TemporalSamplesNumber: word);


  end;
var
 Sect:Sectioner;

implementation

 procedure Sectioner.doOpticalSectioning(const DeltaZ:single;
                                 const DosisControl: boolean;
                                 const HeaderFileName: string;
                                 const AverageImages: word;
                                 const ExpositionTime:double;
                                 const InitialSection: word;
                                 const XRes: single;
                                 const YRes: single;
                                 const XDimension: word;
                                 const YDimension: word;
                                 const ZDimension: word);

  var
   Data: DecTypes.TWordArray; // Collision TWordArray of sysutils
   k,j:integer;
   t:Int64;
   SectionDosisFile: textfile;
   logfile:textfile;
   SectionFileName: string;
   aux: TDynamicDoubleArray;
  begin

   if UVMon<>nil then
    begin
     AssignFile(SectionDosisFile,HeaderFileName+'_Dosis.txt');
     Rewrite(SectionDosisFile);
     Writeln(SectionDosisFile,'Nombre de Archivo',#9,'Dosis',#9,'Tiempo de exposición');
    end;

   for k:=0 to ZDimension-1 do
    begin
     if FActivityProgress = nil then FActivityProgress:=TFActivityProgress.Create(nil);
     FActivityProgress.Visible:=true;
     Stg.Move(DeltaZ);
     SectionFileName:= HeaderFileName + FormatFloat('000',(k+InitialSection));
     if AverageImages > 1 then Cam.getImage(Data,AverageImages,XDimension,YDimension,ExpositionTime)
     else

      if UVMon<>nil then
       begin
        Cam.getImage(Data,XDimension,YDimension,ExpositionTime,DosisControl);
        Writeln(SectionDosisFile,ExtractFileName(SectionFileName),#9,FloatToStrF(
              Cam.getImageDose(),ffGeneral ,6,4),#9,FloatToStrF(Cam.getExpositionTimeCorrected,ffgeneral ,3,3));
        AssignFile(logfile,SectionFileName+'_Dosis.txt');
        Rewrite(logfile);
        UVMon.getLigthRecorded(aux);
        for j:=low(aux) to high(aux) do
         Writeln(SectionDosisFile,FloatToStrF(aux[j],ffGeneral,6,4));
        CloseFile(logfile);
       end
       else Cam.getImage(Data,XDimension,YDimension,true,ExpositionTime);

      TiffFiler.Save14BitsTIFFFile(SectionFileName,XRes,YRes,XDimension,YDimension,Data);
      FActivityProgress.PBActivityProgress.Position:=trunc(k*100/(ZDimension-1));
      FActivityProgress.LProgress.Caption:= FloatToStrF(k*100/(ZDimension-1),ffGeneral,3,3)+'%';
      if not FActivityProgress.Visible then
       begin
        if UVMon<>nil then CloseFile(SectionDosisFile);
        exit;
       end;
      Application.ProcessMessages;
      t:=GetTickCount;
     repeat
      { TODO :
       Ver de utilizar un valor a elección de usario para la espera.
       Además, agregar el control de eventos mientras espera }
     until (GetTickCount-t) >=200; // esperar 200 milisec por vibraciones
    end;
    if UVMon<>nil then  CloseFile(SectionDosisFile);
    FActivityProgress.Visible:=false;
    FActivityProgress.PBActivityProgress.Position:=0;
    FActivityProgress.LProgress.Caption:= '0%';

  end;

procedure Sectioner.doTemporalSectioning(const DeltaT:single;
                                         const ExpositionTime:double;
                                         const DosisControl: boolean;
                                         const HeaderFileName: string;
                                         const AverageImages: word;
                                         const InitialSection: word;
                                         const XRes: single;
                                         const YRes: single;
                                         const XDimension: word;
                                         const YDimension: word;
                                         const TemporalSamplesNumber: word);

var
   Data: DecTypes.TWordArray; // Collision TWordArray of sysutils
   k,j:integer;
   logfile:textfile;
   t:Int64;
   SectionDosisFile: textfile;
   SectionFileName: string;
   aux:TDynamicDoubleArray;
   auxvalue: single;
   pc: cardinal;// priority class
   tp: int64;// thread priority
  begin
  if UVMon<>nil then
   begin
    AssignFile(SectionDosisFile,HeaderFileName+'_Dosis.txt');
    Rewrite(SectionDosisFile);
    Writeln(SectionDosisFile,'Nombre de Archivo',#9,'Dosis',#9,'Tiempo de exposición');
   end;

   for k:=0 to TemporalSamplesNumber-1 do
    begin
     SectionFileName:= HeaderFileName + FormatFloat('000',(k+InitialSection));
     if FActivityProgress = nil then FActivityProgress:=TFActivityProgress.Create(nil);
     FActivityProgress.Visible:=true;
     if AverageImages > 1 then Cam.getImage(Data,AverageImages,XDimension,YDimension,ExpositionTime)
     else
      if UVMon<>nil then
       begin
        Cam.getImage(Data,XDimension,YDimension,ExpositionTime,DosisControl);
        Writeln(SectionDosisFile,ExtractFileName(SectionFileName),#9,FloatToStrF(
              UVMon.getDosis,ffGeneral ,6,4),#9,FloatToStrF(Cam.getExpositionTimeCorrected,ffgeneral,3,3));
        AssignFile(logfile,SectionFileName+'_Dosis.txt');
        Rewrite(logfile);
        SetLength(aux,UVMon.getLigthRecordedSamplesNumber);
        UVMon.getLigthRecorded(aux);
        for j:=low(aux) to high(aux) do
         begin
          auxvalue:=aux[j];
          Writeln(logfile,FloatToStrF(auxvalue,ffGeneral,6,4));
         end;
        CloseFile(logfile);
       end
       else Cam.getImage(Data,XDimension,YDimension,true,ExpositionTime);

      TiffFiler.Save14BitsTIFFFile(SectionFileName,XRes,YRes,XDimension,YDimension,Data);
      FActivityProgress.PBActivityProgress.Position:=trunc(k*100/(TemporalSamplesNumber-1));
      FActivityProgress.LProgress.Caption:= FloatToStrf(k*100/(TemporalSamplesNumber-1),ffGeneral,3,3)+'%' ;
      if not FActivityProgress.Visible then
       begin
        if UVMon<>nil then CloseFile(SectionDosisFile);
        exit;
       end;
      t:=GetTickCount;
      repeat

      { TODO :
       Ver de utilizar un valor a elección de usario para la espera.
       Además, agregar el control de eventos mientras espera }
     until (GetTickCount-t)/1000 >=DeltaT;
     Application.ProcessMessages;
    end;

    if UVMon<> nil then CloseFile(SectionDosisFile);
    FActivityProgress.Visible:=false;
    FActivityProgress.PBActivityProgress.Position:=0;
    FActivityProgress.LProgress.Caption:= '0%';

  end;

end.
