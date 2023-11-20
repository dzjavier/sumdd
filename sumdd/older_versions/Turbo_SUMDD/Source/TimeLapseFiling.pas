unit TimeLapseFiling;
{ Módulo encargado de realizar captura de imágenes a intervalos de tiempo preestablecidos.
Se realiza un logueo (txt) de datos de tiempo de incio y tiempo de finalización del proceso.
Solo utiliza la clase controladora de la cámara.}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, ToolWin, ActnMan, ActnCtrls,
  ComCtrls, Mask, Sectioning,LightMonitor;

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
    CBDoseControl: TCheckBox;
    procedure BBSaveDataClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SBCancelClick(Sender: TObject);
    procedure ESpecimenChange(Sender: TObject);
    procedure CBSpeedChange(Sender: TObject);
    procedure BBCapturarClick(Sender: TObject);

  private
    { Private declarations }
  public

    { Public declarations }
  end;



var
  FTimeLapse: TFTimeLapse;
  LogFile:TextFile;
  LogFileName:string;
  Fecha:string;
  HeaderFileName:string;
  MeanImages,InitialSection,XDimension,YDimension,TemporalNSamples:word;
  ExpositionTime:double;
  DeltaT,Magnification:Single;
  DoseControl:boolean;

implementation

{$R *.dfm}

procedure TFTimeLapse.BBCapturarClick(Sender: TObject);
begin
  Sect.doTemporalSectioning(DeltaT,ExpositionTime,DoseControl,HeaderFileName,
                            MeanImages,InitialSection,Magnification*10000/9,
                            Magnification*10000/9,XDimension,YDimension,TemporalNSamples);
  BBCapturar.Enabled:=false;

end;

procedure TFTimeLapse.BBSaveDataClick(Sender: TObject);
begin
 try
  TemporalNSamples:=strtoint(ENumOfSections.text);
  ExpositionTime:=strToFloat(EExpositiontime.Text);
  ExpositionTime:=strToFloat(EExpositiontime.Text);
  XDimension:=strtoint(EXResolution.Text);
  YDimension:=strtoint(EYResolution.Text);
  MeanImages:=strToInt(EMean.Text);
  DeltaT:=strToFloat(EDelay.Text);
  InitialSection:=strToInt(EIniSection.Text);
  Magnification:=strToFloat(EMagnification.Text);
  HeaderFileName:=EHeader.Text;
  DoseControl:=CBDoseControl.Checked;
 except
  on E: EConvertError do
   begin
    MessageDlg('Error de Conversión',mtError, [mbOk], 0);
    exit;
   end
 end;


if SDDataSectioning.Execute then
  begin
   LogFileName:= ExtractFileName(SDDataSectioning.FileName)+'.txt';
   AssignFile(LogFile,LogFileName);
   ReWrite(LogFile);
    writeln(LogFile,'Especimen= ',ESpecimen.Text);
    writeln(LogFile,'Autor= ',EAuthor.Text);
    writeln(LogFile,'Fecha= ',EDate.Text);
    writeln(LogFile,'T. Exposición [s]= ',EExpositionTime.Text);
    writeln(LogFile,'T. Retardo [s]= ',EDelay.Text);
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
 end;
 BBCapturar.Enabled:=true;

end;

procedure TFTimeLapse.FormCreate(Sender: TObject);
begin
 EDate.Text:=DateToStr(Date);
 if UVMon<>nil then
 begin
  CBDoseControl.Enabled:=true;
  CBDoseControl.Checked:=false;
 end;
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

end.
