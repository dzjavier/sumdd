
unit SectioningFiling;
{Módulo encargado del guardado de datos para realizar el seccionamiento
 óptico de un espécimen. Guarda los archivos del tipo SDF en el directorio
 indicado por el usuario}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, DecTypes, ToolWin, ActnMan,
  ActnCtrls,  ComCtrls, Mask, Sectioning, LightMonitor;

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
    SBCancel: TSpeedButton;
    CBDoseControl: TCheckBox;
    procedure BBSaveDataClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SBCancelClick(Sender: TObject);
    procedure ESpecimenChange(Sender: TObject);
    procedure CBSpeedChange(Sender: TObject);
    procedure BBSectionClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FSectioning: TFSectioning;
  LogFile:TextFile;
  LogFileName:string;
  Fecha:string;
  HeaderFileName:string;
  MeanImages,InitialSection,XDimension,YDimension,ZDimension:word;
  ExpositionTime:double;
  DeltaZ,Magnification:Single;
  DoseControl:boolean;
implementation

{$R *.dfm}

procedure TFSectioning.BBSaveDataClick(Sender: TObject);
begin
 try
  ZDimension:=strtoint(ENumOfSections.text);
  ExpositionTime:=strToFloat(EExpositiontime.Text);
  XDimension:=strtoint(EXResolution.Text);
  YDimension:=strtoint(EYResolution.Text);
  MeanImages:=strToInt(EMean.Text);
  DeltaZ:=strToFloat(EDeltaZ.Text);
  InitialSection:=strToInt(EIniSection.Text);
  Magnification:=strToFloat(EMagnification.Text);
  HeaderFileName:=EHeader.Text;
  DoseControl:=CBDoseControl.Checked;

 except on E: EConvertError do
   begin
    MessageDlg('Error de Conversión',mtError, [mbOk], 0);
    exit;
   end
 end;


if SDDataSectioning.Execute then
  begin
   LogFileName:=ExtractFileName(SDDataSectioning.FileName)+'.txt';
   AssignFile(LogFile,LogFileName);
   ReWrite(LogFile);
    writeln(LogFile,'Especimen= ',ESpecimen.Text);
    writeln(LogFile,'Autor= ',EAuthor.Text);
    writeln(LogFile,'Fecha= ',EDate.Text);
    writeln(LogFile,'T. Exposición [s]= ',EExpositionTime.Text);
    writeln(LogFile,'DeltaZ [um]= ',EDeltaZ.Text);
    writeln(LogFile,'Lente Objetiva= ',CBObjectiveLens.Text);
    writeln(LogFile,'Magnificación Total= ',FloatToStr(Magnification));
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
   BBSection.Enabled:=true;

 end;

end;

procedure TFSectioning.FormCreate(Sender: TObject);
 begin

  EDate.Text:=DateToStr(Date);
  if UVMon<>nil then
   begin
     CBDoseControl.Enabled:=true;
     CBDoseControl.Checked:=false;
   end;
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

procedure TFSectioning.BBSectionClick(Sender: TObject);
 begin
  Sect.doOpticalSectioning(DeltaZ,DoseControl,HeaderFileName,MeanImages,ExpositionTime,
                            InitialSection,Magnification*10000/9,Magnification*10000/9,
                            XDimension,YDimension,ZDimension);
  BBSection.Enabled:=false;
 end;

end.
