unit SectioningFiling;
{ Módulo encargado del guardado de datos para realizar el seccionamiento
 óptico de un espécimen. Guarda los archivos del tipo SDF en el directorio
 indicado por el usuario}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, GR32_Image,DecTypes,Sectioner,
  GR32,Bmp2tiff, ToolWin, ActnMan, ActnCtrls,  ComCtrls, Mask, ProgressActivity,
  SMDDManager,
  cPalette,
  jpeg;

type
  TFSectioning = class(TForm)
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
    LDeltaZ: TLabel;
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
    EDeltaZ: TEdit;
    BBSection: TBitBtn;
    ESpecimen: TEdit;
    LSpecimen: TLabel;
    SDDataSectioning: TSaveDialog;
    CBSpeed: TComboBox;
    LSpeed: TLabel;
    EMean: TEdit;
    LMean: TLabel;
    CBDarkFrame: TCheckBox;
    CBFlatFrame: TCheckBox;
    SBCancel: TSpeedButton;
    CBSectioningUp: TCheckBox;
    CBSectioningDown: TCheckBox;
    procedure BBSaveDataClick(Sender: TObject);
    procedure BBSectionClick(Sender: TObject);
    procedure GetCamera(Cam:TAM4Control);
    procedure FormCreate(Sender: TObject);
    procedure SBCancelClick(Sender: TObject);
    procedure ESpecimenChange(Sender: TObject);
    procedure CBSpeedChange(Sender: TObject);
    procedure CBSectioningUpClick(Sender: TObject);
    procedure CBSectioningDownClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FSectioning: TFSectioning;
  DataSectioning:TSectioningData;
  AM4:TAM4Control;
  Stage:TStageControl;
  FActivityProgress:TFActivityProgress;
  PalManager:TPaletteMngr;
implementation

{$R *.dfm}

procedure TFSectioning.BBSaveDataClick(Sender: TObject);
var
 XDim,YDim,INumber,NumOfSections:Integer;
 T,Dz,Mag:Double;

begin
 try
  NumOfSections:=strtoint(ENumOfSections.text);
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
 except
  on E: EConvertError do
   begin
    MessageDlg('Error de Conversión',mtError, [mbOk], 0);
    EExpositiontime.SelectAll;
    exit;
   end
 end;

 try
    XDim:=strtoint(EXResolution.Text);
 except
  on E: EConvertError do
   begin
    MessageDlg('Error de Conversión',mtError, [mbOk], 0);
    EXResolution.SelectAll;
    exit;
   end
 end;

 try
   YDim:=strtoint(EYResolution.Text);
 except
  on E: EConvertError do
   begin
    MessageDlg('Error de Conversión',mtError, [mbOk], 0);
    EYResolution.SelectAll;
    exit;
   end
 end;
 try
   Dz:=StrToFloat(EDeltaZ.Text);
 except
  on E: EConvertError do
   begin
    MessageDlg('Error de Conversión',mtError, [mbOk], 0);
    EDeltaZ.SelectAll;
    exit;
   end
 end;

 try
   INumber:=StrToInt(EIniSection.Text);
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
  DataSectioning.FileRoot:=ExtractFileDir(SDDataSectioning.FileName)+'\';
  DataSectioning.Header:=EHeader.Text;
  DataSectioning.IniNumber:=StrToInt(EIniSection.Text);
  DataSectioning.NumberOfSections:=strtoint(ENumOfSections.text);
  DataSectioning.FormatFileSection:='.tif';
  DataSectioning.XDimension:=strtoint(EXResolution.Text);
  DataSectioning.YDimension:=strtoint(EYResolution.Text);
  DataSectioning.BitsResolution:=14;
  DataSectioning.ExpositionTime:=StrToFloat(EExpositiontime.Text);
  DataSectioning.DeltaZ:=StrToFloat(EDeltaZ.Text); // Espesor del seccionamiento en micras

  DataSectioning.Specimen:=ESpecimen.Text;
  DataSectioning.Author:=EAuthor.Text;
  DataSectioning.Date:=EDate.Text;
  DataSectioning.ImersionOil:=EInmersionOil.Text; // Índice de Refración
  DataSectioning.Tile:=ETile.Text; // Marcador Fluorescente
  DataSectioning.AntiBody:=EAntiBody.Text; // Anticuerpo utilizado para la marcación
  DataSectioning.Magnification:=Mag;
  DataSectioning.OjectiveLens:=StrToFloat(CBObjectiveLens.Text);

  DataSectioning.Deconvolved:=False;
  DataSectioning.DeconvAlgorithm:='none';
  DataSectioning.OriginalFileSections:='';
  DataSectioning.OriginalFileRoot:=DataSectioning.FileRoot;
  DataSectioning.OriginalHeader:=DataSectioning.Header;
  DataSectioning.OriginalIniNumber:=DataSectioning.IniNumber;
  DataSectioning.OriginalNumberOfSections:=DataSectioning.NumberOfSections;
  DataSectioning.OriginalFormatFileSection:=DataSectioning.FormatFileSection;
  BBSection.Enabled:=true;
  SaveSectioningfile(DataSectioning,ChangeFileExt(SDDataSectioning.FileName,'.sdf'));
 end;

end;

procedure TFSectioning.BBSectionClick(Sender: TObject);
var
 k,i,j:integer;
 BMap:TBitmap32;
 Dir:String;
 T:Double;
 Freq:TLargeInteger;
 Count,Cycles:Real;
 ti,ts:Cardinal;
 jpaux:TJPEGImage;
 BM:TBitmap;
 StAux:TMemoryStream;
begin


BMap:=TBitmap32.Create;
BMap.SetSize(DataSectioning.XDimension,DataSectioning.YDimension);
BMap.Clear(100);

BM:=TBitMap.Create;
jpaux:=TJPEGImage.Create;
StAux:=TMemoryStream.Create;

//BM.Width:= DataSectioning.XDimension;
//BM.Height:=DataSectioning.YDimension;
//BM.PixelFormat:=pf8bit;
//PalManager.ChangePalette(BM);

Cycles:=50*strtoFloat(EDeltaZ.Text);
T:=1000000*0.005/StrToFloat(CBSpeed.Text);
FActivityProgress:=TFActivityProgress.Create(Application);
FActivityProgress.Caption:='Progreso del Seccionamiento';
FActivityProgress.Show;

for k:=0 to DataSectioning.NumberOfSections - 1 do
 begin

  ti:=gettickcount;
  repeat
  until gettickcount-ti>200;

  Application.ProcessMessages;
  FActivityProgress.PBActivityProgress.Position:=Trunc(k/(DataSectioning.NumberOfSections - 1)*100);
  FActivityProgress.LProgress.Caption:=FormatFloat('##.#%',k/(DataSectioning.NumberOfSections - 1)*100);

  if not FActivityProgress.Visible then
   begin
   BBSection.Enabled:=False;
   exit;
   end;

  {AM4.GetImage(BMap,CBDarkFrame.Checked,False,StrtoInt(EMean.Text)
              ,DataSectioning.XDimension,
               DataSectioning.YDimension,
               DataSectioning.ExpositionTime);
   }
  Dir:=DataSectioning.FileRoot+DataSectioning.Header+
           FormatFloat('###000',StrToInt(EIniSection.Text)+k)
           +DataSectioning.FormatFileSection;

  {for i:=0 to DataSectioning.YDimension-1 do
   for j:=0 to Datasectioning.XDimension-1 do
    BM.Canvas.Pixels[j,i]:=WinColor(BMap.PixelS[j,i]);}
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

  if CBSectioningUp.Checked and not(k=DataSectioning.NumberOfSections - 1) then
   begin
    for i:=1 to trunc(Cycles) do Stage.MoveUp(T);
   end;

  if CBSectioningDown.Checked and not(k=DataSectioning.NumberOfSections - 1)then
   begin
    for i:=1 to trunc(Cycles) do Stage.MoveDown(T);
   end;
 end;

jpaux.Destroy;
StAux.Free;
BM.Destroy;
BMap.Destroy;
FActivityProgress.Destroy;
BBSection.Enabled:=False;

end;
procedure TFSectioning.GetCamera(Cam:TAM4Control);
 begin
  AM4:=Cam;
 end;
procedure TFSectioning.FormCreate(Sender: TObject);
begin
PalManager:=TPaletteMngr.Create;
PalManager.PaletteOrder:=PAL_GRAY;

//Stage:=TStageControl.Create(DirPort);
CBSectioningUp.Checked:=True;

end;

procedure TFSectioning.SBCancelClick(Sender: TObject);
begin
 Close;
end;

procedure TFSectioning.ESpecimenChange(Sender: TObject);
begin
BBSection.Enabled:=False;
end;

procedure TFSectioning.CBSpeedChange(Sender: TObject);
begin
BBSection.Enabled:=False;
end;

procedure TFSectioning.CBSectioningUpClick(Sender: TObject);
begin
if CBSectioningUp.Checked then CBSectioningDown.Checked:=False
else CBSectioningDown.Checked:=True;

end;

procedure TFSectioning.CBSectioningDownClick(Sender: TObject);
begin
if CBSectioningDown.Checked then CBSectioningUp.Checked:=False
else CBSectioningUp.Checked:=True;

end;

procedure TFSectioning.FormDestroy(Sender: TObject);
begin
PalManager.Destroy;
end;

end.
