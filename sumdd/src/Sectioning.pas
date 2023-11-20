
// test de cambio, borrar luego

unit Sectioning;

interface

uses FilesManagement,CameraControl,StageControl,LightMonitor,DecTypes,
SysUtils,
ProgressActivity, windows, Forms,
SUMDDMetadata,
Images;

type
 Sectioner = class
   public
    constructor Create;
    function  getNumberOfSections:integer;
    function  getImage(const section:integer):MicroscopeDigitalImage;
    procedure doOpticalSectioning(const DeltaZ:single;
                                  const LightMeasurement: boolean;
                                  const number_of_captures: word;
                                  const exposition_time:double;
                                  const XDim: word;
                                  const YDim: word;
                                  const ZDim: word);

    procedure doTemporalSectioning(const DeltaT:single;
                                   const LightMeasurement: boolean;
                                   const number_of_captures: integer;
                                   const exposition_time:double;
                                   const XDim: word;
                                   const YDim: word;
                                   const TDim: integer);
   procedure Clear;
   destructor Destroy;override;
  private
    Sections: array of MicroscopeDigitalImage;
    SectionNumber:Integer;
    SectionerMetadata: Metadata;
    procedure setDefaultMetadata();
    procedure setUpSections(const section_number:Integer);

  end;

implementation

constructor Sectioner.Create;
 begin
  SectionerMetadata:=Metadata.Create();
 end;

procedure Sectioner.doOpticalSectioning(const DeltaZ:single;
                                        const LightMeasurement: boolean;
                                        const number_of_captures: word;
                                        const exposition_time:double;
                                        const XDim: word;
                                        const YDim: word;
                                        const ZDim: word);
  var
   k:integer;
   t:Int64;
  begin
   Self.setUpSections(ZDim);
   setDefaultMetadata;
   SectionerMetadata.setString('PixelsPhysicalSizeZ',FloatToStrF(DeltaZ,ffFixed,5,4));
   SectionerMetadata.setString('PixelsSizeZ',IntToStr(ZDim));
   SectionerMetadata.setString('DimensionOrder','XYZTC');

   for k:=0 to SectionNumber-1 do
    begin
     SectionerMetadata.setString('PixelsTheZ',IntToStr(k));
     if FActivityProgress = nil then FActivityProgress:=TFActivityProgress.Create(nil);
     FActivityProgress.Visible:=true;
     FActivityProgress.Caption:='Progreso del Sec. óptico';
     Cam.GetImage(Sections[k],number_of_captures,XDim,YDim,exposition_time,true,false);
      {TODO: cambiar el control de exposición con medición de luz}
     Sections[k].addMetadata(SectionerMetadata);
     FActivityProgress.PBActivityProgress.Position:=trunc(k*100/(ZDim-1));
     FActivityProgress.LProgress.Caption:= FloatToStrF(k*100/(ZDim-1),ffGeneral,3,3)+'%';
     if not FActivityProgress.Visible then exit;
     Application.ProcessMessages;

     if k<(SectionNumber-1) then
      begin
       t:=GetTickCount;
       if Stg<>nil then
        Stg.Move(DeltaZ);
        repeat
        { TODO :
         Ver de utilizar un valor a elección de usario para la espera.
         Además, agregar el control de eventos mientras espera }
        until (GetTickCount-t) >=200; // esperar 200 milisec por vibraciones
      end;
    end;
   FActivityProgress.Visible:=false;
   FActivityProgress.PBActivityProgress.Position:=0;
   FActivityProgress.LProgress.Caption:= '0%';

  end;

procedure Sectioner.doTemporalSectioning(const DeltaT:single;
                                         const LightMeasurement: boolean;
                                         const number_of_captures: integer;
                                         const exposition_time:double;
                                         const XDim: word;
                                         const YDim: word;
                                         const TDim: integer);
var
   k:integer;
   t:Int64;
  begin
   Self.setUpSections(TDim);
   setDefaultMetadata;
   SectionerMetadata.setString('PixelsSizeT',IntToStr(TDim));
   SectionerMetadata.setString('PixelsTimeIncrement',FloatToStrF(DeltaT,ffFixed,5,4));

   SectionerMetadata.setString('DimensionOrder','XYTZC');
   if FActivityProgress = nil then FActivityProgress:=TFActivityProgress.Create(nil);
   FActivityProgress.Visible:=true;
   FActivityProgress.Caption:='Progreso del Time Lapse';
   for k:=0 to TDim-1 do
    begin
     SectionerMetadata.setString('PixelsTheT',IntToStr(k));

     Cam.GetImage(Sections[k],number_of_captures,XDim,YDim,exposition_time,true,false);
     Sections[k].addMetadata(SectionerMetadata);
     
     FActivityProgress.PBActivityProgress.Position:=trunc(k*100/(TDim-1));
     FActivityProgress.LProgress.Caption:= FloatToStrf(k*100/(TDim-1),ffGeneral,3,3)+'%' ;
     if not FActivityProgress.Visible then
      exit;
     if k<(SectionNumber-1) then
      begin
       t:=GetTickCount;
       repeat
       { TODO :
        Ver de utilizar un valor a elección de usario para la espera.
        Además, agregar el control de eventos mientras espera }
       until (GetTickCount-t)/1000 >=DeltaT;
       Application.ProcessMessages;
      end;
    end;
    FActivityProgress.Visible:=false;
    FActivityProgress.PBActivityProgress.Position:=0;
    FActivityProgress.LProgress.Caption:= '0%';

  end;
procedure Sectioner.setDefaultMetadata;
begin
 SectionerMetadata.setString('PixelsTheZ','0');
 SectionerMetadata.setString('PixelsPhysicalSizeZ','0');
 SectionerMetadata.setString('PixelsSizeZ','1');
 SectionerMetadata.setString('PixelsPhysicalSizeZUnit','um');

 SectionerMetadata.setString('PixelsSizeT','1');
 SectionerMetadata.setString('PixelsTimeIncrement','0');
 SectionerMetadata.setString('PixelsTheT','0');
end;
procedure Sectioner.Clear;
 var
  i:Integer;
 begin
  if Sections<>nil then
  begin
   for i:=0 to SectionNumber-1 do
    Sections[i].Destroy;
   Sections:=nil;
   SectionNumber:=0;
  setDefaultMetadata;
  end;
end;
procedure Sectioner.setUpSections(const section_number:Integer);
var
 i:Integer;
begin
 Self.Clear;
 SectionNumber:=section_number;
 SetLength(Sections,SectionNumber);
 for i := 0 to SectionNumber - 1 do
  begin
   Sections[i]:=MicroscopeDigitalImage.Create;
   Sections[i].addMetadata(SectionerMetadata);
 end;  
end;
destructor Sectioner.Destroy;
 begin
  SectionerMetadata.Destroy;
  Self.Clear;
 end;
function  Sectioner.getNumberOfSections:integer;
 begin
  result:=SectionNumber;
 end;
function Sectioner.getImage(const section:integer):MicroscopeDigitalImage;
begin
 result:=nil;
 if (Sections<>nil) and (section>=0) and (section<=(SectionNumber-1)) then
  begin
   result:=sections[section];
  end;
end;

end.
