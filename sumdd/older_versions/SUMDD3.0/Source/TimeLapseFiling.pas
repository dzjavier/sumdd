unit TimeLapseFiling;
{ Módulo encargado de realizar captura de imágenes a intervalos de tiempo preestablecidos.
Se realiza un logueo (txt) de datos de tiempo de incio y tiempo de finalización del proceso.
Solo utiliza la clase controladora de la cámara.}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, GR32_Image,DecTypes,Sectioner,
  GR32,Bmp2tiff, ToolWin, ActnMan, ActnCtrls,  ComCtrls, Mask, ProgressActivity,
  SMDDManager,
  cPalette,
  jpeg;

type
  TFTimeLapse = class(TForm)
    PData: TPanel;
    BBSaveData: TBitBtn;
    GBSpecimen: TGroupBox;
    LAuthor: TLabel;
    LDate: TLabel;
    LTime: TLabel;
    LObjLens: TLabel;
    LMagnification: TLabel;
    LOil: TLabel;
    LTile: TLabel;
    LResX: TLabel;
    LDepthRes: TLabel;
    LResY: TLabel;
    LAntiBody: TLabel;
    LRetardo: TLabel;
    EAuthor: TEdit;
    EDate: TEdit;
    EMagnification: TEdit;
    EInmersionOil: TEdit;
    ETile: TEdit;
    EAntibody: TEdit;
    LNumOfSections: TLabel;
    LHeader: TLabel;
    ENumOfSections: TEdit;
    EIniSection: TEdit;
    EHeader: TEdit;
    LIniSection: TLabel;
    EExpositionTime: TEdit;
    CBObjectiveLens: TComboBox;
    EXResolution: TEdit;
    EYResolution: TEdit;
    EResolutionColor: TEdit;
    EDelay: TEdit;
    BBCapturar: TBitBtn;
    ESpecimen: TEdit;
    LSpecimen: TLabel;
    SDDataSectioning: TSaveDialog;
    EMean: TEdit;
    LMean: TLabel;
    SBCancel: TSpeedButton;
    TTimeLapse: TTimer;
    procedure BBSaveDataClick(Sender: TObject);
    procedure GetCamera(Cam:TAM4Control);
    procedure FormCreate(Sender: TObject);
    procedure SBCancelClick(Sender: TObject);
    procedure ESpecimenChange(Sender: TObject);
    procedure CBSpeedChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BBCapturarClick(Sender: TObject);

  private
    { Private declarations }
  public

    { Public declarations }
  end;



var
  FTimeLapse: TFTimeLapse;
  DataTimeLapse:TSectioningData;
  AM4:TAM4Control;

  FActivityProgress:TFActivityProgress;
  PalManager:TPaletteMngr;
  LogFile:TextFile;
  LogFileName:string; // variable que guarda el nombre del archivo de logueo actual
implementation

{$R *.dfm}

procedure TFTimeLapse.BBSaveDataClick(Sender: TObject);
var
 T,Mag:Double;

begin
 try
  strtoint(ENumOfSections.text);
 except
  on E: EConvertError do
   begin
    MessageDlg('Error de Conversión',mtError, [mbOk], 0);
    ENumOfSections.SelectAll;
    exit;
   end
 end;

 try
   T:=StrToFloat(EExpositiontime.Text);
   If (T<0.01) then
    begin
     MessageDlg('El tiempo de exposición debe ser mayor o igual a 10 ms.',mtError, [mbOk], 0);
     EExpositiontime.SelectAll;
     exit;
    end;
 except
  on E: EConvertError do
   begin
    MessageDlg('Error de Conversión',mtError, [mbOk], 0);
    EExpositiontime.SelectAll;
    exit;
   end
 end;

 try
  strtoint(EXResolution.Text);
 except
  on E: EConvertError do
   begin
    MessageDlg('Error de Conversión',mtError, [mbOk], 0);
    EXResolution.SelectAll;
    exit;
   end
 end;

 try
  strtoint(EYResolution.Text);
 except
  on E: EConvertError do
   begin
    MessageDlg('Error de Conversión',mtError, [mbOk], 0);
    EYResolution.SelectAll;
    exit;
   end
 end;
 try
   StrToFloat(EDelay.Text);
 except
  on E: EConvertError do
   begin
    MessageDlg('Error de Conversión',mtError, [mbOk], 0);
    EDelay.SelectAll;
    exit;
   end
 end;

 try
   StrToInt(EIniSection.Text);
 except
  on E: EConvertError do
   begin
    MessageDlg('Error de Conversión',mtError, [mbOk], 0);
    EIniSection.SelectAll;
    exit;
   end
 end;

 try
   Mag:=StrToFloat(EMagnification.Text);
 except
  on E: EConvertError do
   begin
    MessageDlg('Error de Conversión',mtError, [mbOk], 0);
    EMagnification.SelectAll;
    exit;
   end
 end;


if SDDataSectioning.Execute then
  begin

  DataTimeLapse.FileRoot:=ExtractFileDir(SDDataSectioning.FileName)+'\';
  DataTimeLapse.Header:=EHeader.Text;
  DataTimeLapse.IniNumber:=StrToInt(EIniSection.Text);
  DataTimeLapse.NumberOfSections:=strtoint(ENumOfSections.text);
  DataTimeLapse.FormatFileSection:='.tif';
  DataTimeLapse.XDimension:=StrToInt(EXResolution.Text);
  DataTimeLapse.YDimension:=StrToInt(EYResolution.Text);
  DataTimeLapse.BitsResolution:=14;
  DataTimeLapse.ExpositionTime:=StrToFloat(EExpositionTime.Text);
  DataTimeLapse.DeltaZ:=StrToFloat(EDelay.Text); // Espesor del seccionamiento en micras

  DataTimeLapse.Specimen:=ESpecimen.Text;
  DataTimeLapse.Author:=EAuthor.Text;
  DataTimeLapse.Date:=EDate.Text;
  DataTimeLapse.ImersionOil:=EInmersionOil.Text; // Índice de Refración
  DataTimeLapse.Tile:=ETile.Text; // Marcador Fluorescente
  DataTimeLapse.AntiBody:=EAntiBody.Text; // Anticuerpo utilizado para la marcación
  DataTimeLapse.Magnification:=Mag;
  DataTimeLapse.OjectiveLens:=StrToFloat(CBObjectiveLens.Text);

  DataTimeLapse.Deconvolved:=False;
  DataTimeLapse.DeconvAlgorithm:='none';
  DataTimeLapse.OriginalFileSections:='';
  DataTimeLapse.OriginalFileRoot:=DataTimeLapse.FileRoot;
  DataTimeLapse.OriginalHeader:=DataTimeLapse.Header;
  DataTimeLapse.OriginalIniNumber:=DataTimeLapse.IniNumber;
  DataTimeLapse.OriginalNumberOfSections:=DataTimeLapse.NumberOfSections;
  DataTimeLapse.OriginalFormatFileSection:=DataTimeLapse.FormatFileSection;
  BBCapturar.Enabled:=true;

  LogFileName:=SDDataSectioning.FileName+'.txt';
  AssignFile(LogFile,LogFileName);
  ReWrite(LogFile);
  writeln(LogFile,'Especimen= ',ESpecimen.Text);
  writeln(LogFile,'Autor= ',EAuthor.Text);
  writeln(LogFile,'Fecha= ',EDate.Text);
  writeln(LogFile,'T. Exposición [s]= ',EExpositionTime.Text);
  writeln(LogFile,'T. Retardo [s]= ',EDelay.Text);
  writeln(LogFile,'Lente Objetiva= ',CBObjectiveLens.Text);
  writeln(LogFile,'Magnificación Total= ',FloatToStr(Mag));
  writeln(LogFile,'Aceite de Inm.= ',EInmersionOil.Text);
  writeln(LogFile,'Marcador= ',ETile.Text);
  writeln(LogFile,'Anticuerpo= ',EAntiBody.Text);
  writeln(LogFile,'Encabezado= ',EHeader.Text);
  writeln(LogFile,'Sección Inicial= ',EIniSection.Text);
  writeln(LogFile,'Número de Secciones= ',ENumOfSections.Text);
  writeln(LogFile,'Res. X= ',EXResolution.Text);
  writeln(LogFile,'Res. Y= ',EYResolution.Text);
  writeln(LogFile,'Imgs. a Promediar= ',EMean.Text);
  CloseFile(LogFile);

 end;

end;

procedure TFTimeLapse.GetCamera(Cam:TAM4Control);
 begin
  AM4:=Cam;
 end;
procedure TFTimeLapse.FormCreate(Sender: TObject);
begin
PalManager:=TPaletteMngr.Create;
PalManager.PaletteOrder:=PAL_GRAY;

end;

procedure TFTimeLapse.SBCancelClick(Sender: TObject);
begin
 Close;
end;

procedure TFTimeLapse.ESpecimenChange(Sender: TObject);
begin
BBCapturar.Enabled:=False;
end;

procedure TFTimeLapse.CBSpeedChange(Sender: TObject);
begin
BBCapturar.Enabled:=False;
end;

procedure TFTimeLapse.FormDestroy(Sender: TObject);
begin
PalManager.Destroy;
end;

procedure TFTimeLapse.BBCapturarClick(Sender: TObject);
var
 k:integer;
 BMap:TBitmap32;
 Dir:String;
 ti,ts:Cardinal;
 jpaux:TJPEGImage;
 BM:TBitmap;
 StAux:TMemoryStream;
begin


BMap:=TBitmap32.Create;
BMap.SetSize(DataTimeLapse.XDimension,DataTimeLapse.YDimension);
BMap.Clear(100);

BM:=TBitMap.Create;
jpaux:=TJPEGImage.Create;
StAux:=TMemoryStream.Create;

//Cycles:=50*strtoFloat(ERetardo.Text);
FActivityProgress:=TFActivityProgress.Create(Application);
FActivityProgress.Caption:='Progreso del Time Lapse';
FActivityProgress.Show;
ti:=gettickcount;
for k:=0 to StrToInt(ENumOfSections.Text) - 1 do
 begin

  Application.ProcessMessages;
  FActivityProgress.PBActivityProgress.Position:=Trunc(k/(DataTimeLapse.NumberOfSections - 1)*100);
  FActivityProgress.LProgress.Caption:=FormatFloat('##.#%',k/(DataTimeLapse.NumberOfSections - 1)*100);

  if not FActivityProgress.Visible then
   begin
   TTimeLapse.Enabled:=False;
   exit;
   end;

 AM4.GetImage(BMap,False,False,StrtoInt(EMean.Text)
              ,DataTimeLapse.XDimension,
               DataTimeLapse.YDimension,
               DataTimeLapse.ExpositionTime);

  Dir:=DataTimeLapse.FileRoot+DataTimeLapse.Header+
           FormatFloat('###000',StrToInt(EIniSection.Text)+k)
           +DataTimeLapse.FormatFileSection;
   BMAp.SaveToStream(StAux);
   StAux.Position:=0;
   BM.LoadFromStream(StAux);
   StAux.Position:=0;
   jpaux.Assign(BM);
   jpaux.SaveToStream(StAux);
   StAux.Position:=0;
   jpaux.Grayscale:=True;
   jpaux.PixelFormat:=jf8bit;
   jpaux.LoadFromStream(StAux);
   Staux.Position:=0;
   BM.Assign(jpaux);
   WriteTiffToFile(Dir,BM);
   ts:=gettickcount;
   while (gettickcount-ts<Trunc(StrToInt(EDelay.Text)*1000)) do;

 end;
ti:=gettickcount-ti;
AssignFile(LogFile,LogFileName);
Append(LogFile);
writeln(LogFile,'Duración Total [ms]= ',FloatToStr(ti));
CloseFile(LogFile);

jpaux.Destroy;
StAux.Free;
BM.Destroy;
BMap.Destroy;
FActivityProgress.Destroy;
BBCapturar.Enabled:=False;
end;


end.
