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
    LTime: TLabel;
    LResX: TLabel;
    LResY: TLabel;
    LRetardo: TLabel;
    LNumOfSections: TLabel;
    ENumOfSections: TEdit;
    EExpositionTime: TEdit;
    EXResolution: TEdit;
    EYResolution: TEdit;
    EDelay: TEdit;
    BBCapturar: TBitBtn;
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
  file_name:string;
  number_of_captures,XDimension,YDimension,TemporalNSamples:word;
  ExpositionTime:double;
  DeltaT:Single;
  DoseControl:boolean;

implementation

{$R *.dfm}

procedure TFTimeLapse.BBCapturarClick(Sender: TObject);
var
Sect:Sectioner;
begin
  Sect:=Sectioner.Create;
{
  Sect.doTemporalSectioning(DeltaT,ExpositionTime,DoseControl,HeaderFileName,
                            MeanImages,InitialSection,Magnification*10000/9,
                            Magnification*10000/9,XDimension,YDimension,TemporalNSamples);
}
  Sect.Destroy;
  BBCapturar.Enabled:=false;

end;

procedure TFTimeLapse.BBSaveDataClick(Sender: TObject);
begin
 try
  TemporalNSamples:=strtoint(ENumOfSections.text);
 // ExpositionTime:=strToFloat(EExpositiontime.Text);
  ExpositionTime:=strToFloat(EExpositiontime.Text)/1000;
  XDimension:=strtoint(EXResolution.Text);
  YDimension:=strtoint(EYResolution.Text);
  number_of_captures:=strToInt(EMean.Text);
  DeltaT:=strToFloat(EDelay.Text);
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
   file_name:=ChangeFileExt(SDDataSectioning.FileName,'.tif');
  end;
 BBCapturar.Enabled:=true;

end;

procedure TFTimeLapse.FormCreate(Sender: TObject);
begin

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
