unit SaveDeconvSectioning;
{ Módulo encargado del guardado de datos para realizar el seccionamiento
 óptico de un espécimen. Guarda los archivos del tipo SDF en el directorio
 indicado por el usuario}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, DecTypes,
  Bmp2tiff, ToolWin, ActnMan, ActnCtrls,  ComCtrls, Mask, ProgressActivity,
  SMDDManager,
  jpeg;

type
  TFSaveDeconvSectioning = class(TForm)
    PData: TPanel;
    BBSaveData: TBitBtn;
    GBSpecimen: TGroupBox;
    LAuthor: TLabel;
    LDate: TLabel;
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
    CBObjectiveLens: TComboBox;
    EXResolution: TEdit;
    EYResolution: TEdit;
    EResolutionColor: TEdit;
    EDeltaZ: TEdit;
    ESpecimen: TEdit;
    LSpecimen: TLabel;
    SDDataSectioning: TSaveDialog;
    SBCancel: TSpeedButton;
    LAlgorithm: TLabel;
    EAlgorithm: TEdit;
    LTime: TLabel;
    EExpositionTime: TEdit;
    procedure BBSaveDataClick(Sender: TObject);
    procedure SBCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
   Manager:TDDMSManager;
    { Public declarations }
  end;

var
  FSaveDeconvSectioning: TFSaveDeconvSectioning;
  DataSectioning:TSectioningData;
  FActivityProgress:TFActivityProgress;

  LogFileName:string;
  LogFile:TextFile;
implementation

{$R *.dfm}

procedure TFSaveDeconvSectioning.BBSaveDataClick(Sender: TObject);
var
 k,i,j,XDim,YDim,INumber,NumOfSections:Integer;
 T,Dz,Mag:Double;
 jpaux:TJPEGImage;
 BM:TBitmap;

 StAux:TMemoryStream;
 Dir:String;

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
   Refresh;
   FActivityProgress:=TFActivityProgress.Create(Application);
   FActivityProgress.Caption:= 'Guardando Datos';
   FActivityProgress.BBProcessCancel.Enabled:= False;
   FActivityProgress.Show;

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

   DataSectioning.Deconvolved:=True;
   DataSectioning.DeconvAlgorithm:=EAlgorithm.Text;
   DataSectioning.OriginalFileSections:='';
   DataSectioning.OriginalFileRoot:=Manager.DataVolume.FileRoot;
   DataSectioning.OriginalHeader:=Manager.DataVolume.Header;
   DataSectioning.OriginalIniNumber:=Manager.DataVolume.IniNumber;
   DataSectioning.OriginalNumberOfSections:=Manager.DataVolume.NumberOfSections;
   DataSectioning.OriginalFormatFileSection:=Manager.DataVolume.FormatFileSection;
//   SaveSectioningfile(DataSectioning,ChangeFileExt(SDDataSectioning.FileName,'.sdf'));

  LogFileName:=ChangeFileExt(SDDataSectioning.FileName,'.txt');
  AssignFile(LogFile,LogFileName);
  ReWrite(LogFile);
  writeln(LogFile,'Especimen= ',ESpecimen.Text);
  writeln(LogFile,'Autor= ',EAuthor.Text);
  writeln(LogFile,'Fecha= ',EDate.Text);
  writeln(LogFile,'T. Exposición [s]= ',EExpositionTime.Text);
  writeln(LogFile,'DeltaZ [um]= ',EDeltaZ.Text);
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
  writeln(LogFile,'Desconvolución= ',DataSectioning.DeconvAlgorithm);
//  writeln(LogFile,'Imgs. a Promediar= ',EMean.Text);
  CloseFile(LogFile);

   FActivityProgress.Caption:= 'Guardando Seccionamiento';


//   B:=TBitmap32.Create;
//   B.Width:=Manager.XDim;
//   B.Height:=Manager.YDim;
   BM:=TBitmap.Create;
   jpaux:=TJPEGImage.Create;
   StAux:=TMemoryStream.Create;

//   PalMngr.ChangePalette(B);
//   B.PixelFormat:=pf8bit;

   for k:= DataSectioning.IniNumber to DataSectioning.IniNumber + DataSectioning.NumberOfSections -1 do
    begin
     Dir:=DataSectioning.FileRoot+DataSectioning.Header+
           FormatFloat('###000',k) + DataSectioning.FormatFileSection;


     for i:=0 to DataSectioning.YDimension-1 do
      for j:=0 to DataSectioning.XDimension -1 do
        //B.PixelS[j,i]:=Gray32(Manager.VolDeconv[k-DataSectioning.IniNumber].Value[j,i]);


//     B.SaveToStream(StAux);
     StAux.Position:=0;
     BM.LoadFromStream(StAux);
     StAux.Position:=0;
     jpaux.Assign(BM);
     jpaux.SaveToStream(StAux);
     StAux.Position:=0;
     jpaux.Grayscale:=True;
     jpaux.PixelFormat:=jf8bit;
     jpaux.LoadFromStream(StAux);
     StAux.Position:=0;
     BM.Assign(jpaux);

     WriteTiffToFile(Dir,BM);
     FActivityProgress.PBActivityProgress.Position:=trunc(k/DataSectioning.NumberOfSections*100);
     FActivityProgress.LProgress.Caption:=FormatFloat('#.##%',k/DataSectioning.NumberOfSections*100);
     FActivityProgress.Refresh;
    end;

    jpaux.Destroy;
    BM.Destroy;
    StAux.Free;


//   BBSaveData.Enabled:=False;
   FActivityProgress.Destroy;
 end;// end If


end; // end Begin

procedure TFSaveDeconvSectioning.SBCancelClick(Sender: TObject);
 begin
  Close;
 end;

procedure TFSaveDeconvSectioning.FormCreate(Sender: TObject);
begin
//PalMngr:=TPaletteMngr.Create;
//PalMngr.PaletteOrder:=PAL_GRAY;
EDate.Text:=DateToStr(Date);
end;

procedure TFSaveDeconvSectioning.FormDestroy(Sender: TObject);
begin
//PalMngr.Destroy;
end;

end.
