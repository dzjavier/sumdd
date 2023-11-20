
unit SectioningFiling;
{Módulo encargado del guardado de datos para realizar el seccionamiento
 óptico de un espécimen. Guarda los archivos del tipo SDF en el directorio
 indicado por el usuario}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, DecTypes, ToolWin, ActnMan,
  ActnCtrls,  ComCtrls, Mask, Sectioning, LightMonitor,CameraControl,images;

type
  TFSectioning = class(TForm)
    PData: TPanel;
    BBSaveData: TBitBtn;
    GBSpecimen: TGroupBox;
    LTime: TLabel;
    LResY: TLabel;
    LDeltaZ: TLabel;
    LDeltaT: TLabel;
    EDeltaT: TEdit;
    EExpositionTime: TEdit;
    EYDimension: TEdit;
    EDeltaZ: TEdit;
    BBSection: TBitBtn;
    CBSpeed: TComboBox;
    LSpeed: TLabel;
    SBCancel: TSpeedButton;
    CBLightLevel: TCheckBox;
    SaveDialog1: TSaveDialog;
    LResX: TLabel;
    EXDimension: TEdit;
    LZDim: TLabel;
    EZDimension: TEdit;
    LTDim: TLabel;
    ETDimension: TEdit;
    GBCaptureModeSelection: TGroupBox;
    RBOpticalSectioning: TRadioButton;
    RBTimeLapse: TRadioButton;
    LNumberOfCapture: TLabel;
    ECaptureNumber: TEdit;
    BImageTest: TButton;
    procedure BBSaveDataClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SBCancelClick(Sender: TObject);
    procedure BBSectionClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure RBOpticalSectioningClick(Sender: TObject);
    procedure RBTimeLapseClick(Sender: TObject);
    procedure BImageTestClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FSectioning: TFSectioning;
  Sect:Sectioner;
  isDataSaved:boolean;
  test_image:MicroscopeDigitalImage;
implementation

{$R *.dfm}
uses
 FilesManagement,JavaApplicationLuncher, OpenGLRenderer;

procedure TFSectioning.BBSaveDataClick(Sender: TObject);
var
 file_name:string;
 file_extension_filter:integer;
 k:Integer;
 modificate_metadata_java:JavaAppLuncher;
begin
if Sect<>nil then
 begin
  if SaveDialog1.Execute then
    begin
     file_name:=ChangeFileExt(SaveDialog1.FileName,'');
     file_extension_filter:=SaveDialog1.FilterIndex;
     case file_extension_filter of
      1:
        begin
         for k := 0 to sect.getNumberOfSections -1 do
          TiffFiler.Save14BitsTIFFFile(ChangeFileExt(file_name,'.test.tif'),k,Sect.getImage(k));
          isDataSaved:=true;
        end;
      2:
        begin
         modificate_metadata_java:=JavaAppLuncher.Create('EditorMetadatos.jar',' ');
         modificate_metadata_java.run;
         modificate_metadata_java.Destroy;
        end;
     end;
    end;
 end;

end;

procedure TFSectioning.FormCreate(Sender: TObject);
 begin
  if UVMon<>nil then
   begin
     CBLightLevel.Enabled:=true;
     CBLightLevel.Checked:=false;
   end;
  Sect:=Sectioner.Create;
  isDataSaved:=true;
 end;

procedure TFSectioning.FormDestroy(Sender: TObject);
begin
if Sect<>nil then
 Sect.Destroy;
end;

procedure TFSectioning.RBOpticalSectioningClick(Sender: TObject);
begin
 EZDimension.Enabled:=true;
 EDeltaZ.Enabled:=true;
 LZDim.Enabled:=true;
 LDeltaZ.Enabled:=true;

 ETDimension.Enabled:=false;
 EDeltaT.Enabled:=false;
 LTDim.Enabled:=false;
 LDeltaT.Enabled:=false;
end;

procedure TFSectioning.RBTimeLapseClick(Sender: TObject);
begin
 EZDimension.Enabled:=false;
 EDeltaZ.Enabled:=false;
 LZDim.Enabled:=false;
 LDeltaZ.Enabled:=false;

 ETDimension.Enabled:=true;
 EDeltaT.Enabled:=true;
 LTDim.Enabled:=true;
 LDeltaT.Enabled:=true;

end;

procedure TFSectioning.SBCancelClick(Sender: TObject);
 begin
  Close;
 end;

procedure TFSectioning.BBSectionClick(Sender: TObject);
var
  number_of_captures,x_dimension,y_dimension,z_dimension:word;
  t_dimension:integer;
  exposure_time:double;
  delta_z,delta_t:Single;
  light_measurement:boolean;
  begin
   light_measurement:=CBLightLevel.Checked;
  try
   x_dimension:=strtoint(EXDimension.Text);
   y_dimension:=strtoint(EYDimension.Text);
   exposure_time:=strToFloat(EExpositiontime.Text)/1000;
   number_of_captures:=strToInt(ECaptureNumber.Text);
  except on E: EConvertError do
   begin
    MessageDlg('Error de Conversión',mtError, [mbOk], 0);
    exit;
   end ;
  end;
  if isDataSaved then
  begin
   if RBOpticalSectioning.Checked then
    begin
     try
      z_dimension:=strtoint(EZDimension.text);
      delta_z:=strToFloat(EDeltaZ.Text);
     except on E: EConvertError do
      begin
       MessageDlg('Error de Conversión',mtError, [mbOk], 0);
       exit;
      end;
     end;
     Sect.doOpticalSectioning(delta_z,light_measurement,number_of_captures,
                            exposure_time,x_dimension,y_dimension,z_dimension);
     isDataSaved:=false;
    end;
   if RBTimeLapse.Checked then
    begin
     try
      t_dimension:=strtoint(ETDimension.text);
      delta_t:=strToFloat(EDeltaT.Text);
     except on E: EConvertError do
      begin
       MessageDlg('Error de Conversión',mtError, [mbOk], 0);
       exit;
      end;
    end;
   Sect.doTemporalSectioning(delta_t,light_measurement,number_of_captures,
                           exposure_time,x_dimension,y_dimension,t_dimension);
   isDataSaved:=false;
   end;
   BBSaveData.Enabled:=true;
  end
  else
   begin
    if MessageDlg('¿Desea almacenar el seccionamiento?',
                   mtConfirmation,[mbYes,mbNo],0)=mrYes then
      BBSaveData.Click
    else
     isDataSaved:=true;
   end;
 end;


procedure TFSectioning.BImageTestClick(Sender: TObject);
var
  number_of_captures,x_dimension,y_dimension:word;
  exposure_time:double;
begin
//   light_measurement:=CBLightLevel.Checked;
  try
   x_dimension:=strtoint(EXDimension.Text);
   y_dimension:=strtoint(EYDimension.Text);
   exposure_time:=strToFloat(EExpositiontime.Text)/1000;
   number_of_captures:=strToInt(ECaptureNumber.Text);
  except on E: EConvertError do
   begin
    MessageDlg('Error de Conversión',mtError, [mbOk], 0);
    exit;
   end ;
  end;

 if FOGLRenderer=nil then
  FOGLRenderer:=TFOGLRenderer.Create(self);

   test_image:=MicroscopeDigitalImage.Create;
   Cam.getImage(test_image,number_of_captures,x_dimension,y_dimension,
                 exposure_time,true,false);
//   FOGLRenderer.getDrawbleObject(test_image);
//   FOGLRenderer.Visible:=true;
   FOGLRenderer.ShowModal;
//   FOGLRenderer.Visible:=False;

end;

end.
