unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtDlgs, ExtCtrls,StdCtrls, DecTypes, Grids,
  math, ComCtrls, Buttons,ImageCapture,
  // DataSectioning,
  // SectioningFiling,
  TemperatureControl,
  ControlOptions,
  ConstrainedIterativeDeconvolution,
  WienerFilterDeconvolution,
  AboutSUMDD,
//  SaveDeconvSectioning,
  inifiles,
  InitWindow,
  ToolWin,
  StageControl,
  LightMonitor,
  CameraControl;

type
  TMainWindow = class(TForm)
    MMFile: TMenuItem;
    MMFClose: TMenuItem;
    MMAcquisition: TMenuItem;
    MMAImage: TMenuItem;
    MMHelp: TMenuItem;
    MMTools: TMenuItem;
    MMAVolumeSectioning: TMenuItem;
    ODLoadSections: TOpenDialog;
    OPDLoadImage: TOpenPictureDialog;
    MainMenu: TMainMenu;
    MMTTemperatureControl: TMenuItem;
    MMTControlOptions: TMenuItem;
    MMHAbout: TMenuItem;
    ToolBar1: TToolBar;
    SBMainWindow: TStatusBar;
    TimerUpDate: TTimer;
    MATimeLapse: TMenuItem;
    MMTCalibrateUVMonitor: TMenuItem;
    procedure MMFCloseClick(Sender: TObject);

    procedure MMAImageClick(Sender: TObject);
    procedure MMAVolumeSectioningClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);


    procedure MMTTemperatureControlClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MMTControlOptionsClick(Sender: TObject);


    procedure MMHAboutClick(Sender: TObject);
    procedure MMSaveSectioningClick(Sender: TObject);
    procedure UpDateDataSystem;
    procedure TimerUpDateTimer(Sender: TObject);
    procedure MATimeLapseClick(Sender: TObject);
    procedure MMTCalibrateUVMonitorClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  private
    { Private declarations }
    Speed,ImageMean,XDim,YDim:Integer;
    DeltaZ,ExTime:Double;
    DFrame,FFrame:Boolean;

    protected

  public
    Sit:String;
    { Public declarations }



end;

const
 AP = 0.6; // Porcentaje del area de la pantalla para la
                   //visualización de galerías;

 //Número de la imagen correspondiente a la
 //PSF Empiríca en foco para cada lente Objetiva

 PSFinFocusEmp4x   = 4030;
 PSFinFocusEmp10x  = 10027;
 PSFinFocusEmp20x  = 20017;
 PSFinFocusEmp40x  = 40020;
 PSFinFocusEmp100x = 100020;

 //Número de la imagen correspondiente a la
 //PSF Teórica en foco para cada lente Objetiva
 PSFinFocusTheo4x   = 4009;
 PSFinFocusTheo10x  = 10009;
 PSFinFocusTheo20x  = 20050;
 PSFinFocusTheo40x  = 40049;
 PSFinFocusTheo100x = 100019;

 //Cantidad de imágenes de PSF Empírica
 // en archivo para cada lente objetiva
 PSFNumberEmp4x  = 32;
 PSFNumberEmp10x = 32;
 PSFNumberEmp20x = 32;
 PSFNumberEmp40x = 32;
 PSFNumberEmp100x= 32;

 //Cantidad de imágenes de PSF Teórica
 // en archivo para cada lente objetiva
 PSFNumberTheo4x   = 16;
 PSFNumberTheo10x  = 16;
 PSFNumberTheo20x  = 64;
 PSFNumberTheo40x  = 64;
 PSFNumberTheo100x = 16;


var
  MainWindow: TMainWindow;
  FImage:TFImage;
  SLV:Integer;
  Dim: Integer;
  ImForm:TForm;
  HeaSections:String;
  PSFsdir:String;
  DirSUMDDIniFile:String;
  DirSUMDD:String; // directorio del SUMDD... en principio para  logging
  CameraIniFileName:String;
  UVLongTermRegisteFileName:string;
  //Open GL
//  RC : HGLRC;
//  Angulo : GLInt;
////////
  FControlOptions:TFControlOptions;
//  FTimeLapse:TFTimeLapse;
//  FViewSection: TFViewSection;
//  FGallery: TFGallery;
//  FDataSections:TFDataSections;
//  FSectioning:TFSectioning;

  FCID:TFConstrainedIterativeDeconvolution;
  FWF2D:TFWiener2DDeconvolution;
  FTemperatureControl: TFTemperatureControl;

//  FSDSectioning: TFSaveDeconvSectioning;
  AboutBox: TAboutBox;
//  FSeg3D:TFSegmentation3D;

// Sytem
  MemorySystem: TMemoryStatus;

implementation

uses SectioningFiling, TimeLapseFiling;

{$R *.dfm}

procedure TMainWindow.MMFCloseClick(Sender: TObject);
begin
 close;
end;


procedure TMainWindow.MMAImageClick(Sender: TObject);
begin

 if FImage=nil then FImage:= TFImage.Create(Application);

 FImage.ETime.Text:=FloatToStr(0.2);
 FImage.TimerLightMonitor.Enabled:=true;
 FImage.ShowModal;
 FImage.TimerLightMonitor.Enabled:=false;
 DeltaZ:=StrtoFloat(FImage.CBDeltaZ.text);
 Speed:=StrToInt(FImage.CBSpeed.Text);
 ImageMean:=StrToInt(FImage.EMean.Text);
 XDim:=StrToInt(FImage.EXDim.Text);
 YDim:=StrToInt(FImage.EYDim.Text);
 ExTime:=StrToFloat(FImage.ETime.Text);
 DFrame:=FImage.CBDarkFrame.Checked;
// FFrame:=FImage.CBFlatFrame.Checked;

end;

procedure TMainWindow.MMAVolumeSectioningClick(Sender: TObject);
begin
if FSectioning=nil then FSectioning:=TFSectioning.Create(Application);
with FSectioning do
 begin
  EExpositionTime.Text:=FloatToStr(ExTime);
  EXResolution.Text:=IntToStr(XDim);
  EYResolution.Text:=IntToStr(YDim);
  EDeltaZ.Text:=FloatToStr(DeltaZ);
  CBSpeed.Text:=IntToStr(Speed);
  EMean.Text:=IntToStr(ImageMean);
  ShowModal;
 end;

end;

procedure TMainWindow.FormCreate(Sender: TObject);
var
 DirPort:String;
 IniFile:TIniFile;
 CamIniFile:String;
 begin
  FInitWindow:=TFInitWindow.Create(Application);
  FInitWindow.ShowModal;
  FInitWindow.Destroy;
  DirSUMDDIniFile:=GetCurrentDir+'\iniSUMDD.ini';
  IniFile:=TIniFile.Create(DirSUMDDIniFile);
  CamIniFile:=IniFile.ReadString('Camera','Name','');
  DirPort:=IniFile.ReadString('Stage','DirPP','$378');
  CameraIniFileName:=GetCurrentDir+'\'+CamIniFile+'.ini';

 // Creación de objetos controladores de hardware //
  if (MessageDlg('¿Trabajará con control de Dosis?',mtConfirmation,[mbYes, mbNo],0) = mrYes) then
  begin
    if (MessageDlg('Asegúrese de encender la lámpara (15 min.) y'+#13+
    'la alimentación del monitor UV, luego presione Ok',mtWarning,[mbOk, mbCancel],0) = mrOk) then
     begin
      UVMon:=UVLightMonitor.Create;
      UVLongTermRegisteFileName:=GetCurrentDir+'\UVLongTerm.txt';
      UVMon.saveForLongTermRegister(UVLongTermRegisteFileName);
     end;
  end;

  Stg:=Stage.Create(StrtoInt(DirPort));
  Cam:=AM4Camera.Create(CameraIniFileName);
 // Creación de objetos controladores de hardware //

  PSFsdir:=GetCurrentDir+'\PSFs';
  DeltaZ:=1;
  Speed:=2;
  ImageMean:=1;
  XDim:=512;
  YDim:=512;
  ExTime:=0.2;
  DFrame:=False;
  FFrame:=False;
 // System
  UpDateDataSystem;



 end;


procedure TMainWindow.FormDestroy(Sender: TObject);
 begin
 if UVMon<>nil then
   UVMon.saveForLongTermRegister(UVLongTermRegisteFileName);
 end;

procedure TMainWindow.MMTTemperatureControlClick(Sender: TObject);
begin
If FTemperatureControl=nil then FTemperatureControl:= TFTemperatureControl.Create(Application);
 FTemperatureControl.Show;
 FTemperatureControl.WindowState:=wsNormal;

end;

procedure TMainWindow.FormClose(Sender: TObject; var Action: TCloseAction);
begin
{ if not(Manager.Cam=nil) then
  begin
   if (Manager.Cam.GetControlTemperatureStatus='Apagado') xor
      (Manager.Cam.GetControlTemperatureStatus='A Temperatura Ambiente') then exit
   else
    begin
     if Application.MessageBox('El Control de Temperatura'+#13+'se encuentra Activo' +#13+#13+
                              '¿Desea Cancelar el Control?', 'Atención', MB_YESNO)=IDYes then
      begin
       Manager.Cam.TemperatureControlOff;
       exit;
      end
     else
      begin
       If FTemperatureControl=nil then FTemperatureControl:= TFTemperatureControl.Create(Application);
       FTemperatureControl.ClientHeight:=480;
       FTemperatureControl.ClientWidth:=640;
       FTemperatureControl.GetCamera(Manager.Cam);
       FTemperatureControl.Show;
       FTemperatureControl.WindowState:=wsNormal;
       abort;
      end;
    end;
  end;

if not(F3DProjectionRaw = nil) then F3DProjectionRaw.Free;

}
end;

procedure TMainWindow.MMTCalibrateUVMonitorClick(Sender: TObject);
begin
 UVMon.Calibrate;
end;

procedure TMainWindow.MMTControlOptionsClick(Sender: TObject);
var
 IniFile:TIniFile;
 DirPort:String;
begin

 FControlOptions:=TFControlOptions.Create(Application);
 IniFile:=TIniFile.Create(DirSUMDDIniFile);
 DirPort:=IniFile.ReadString('Stage','DirPP','$378');
 FControlOptions.CBPortDir.Text:=DirPort;
 FCOntrolOptions.ShowModal;
 if FCOntrolOptions.ModalResult=mrOK then
  IniFile.WriteString('Stage','DirPP',FControlOptions.CBPortDir.Text);

 FControlOptions.Destroy;

end;

procedure TMainWindow.MMHAboutClick(Sender: TObject);
 begin
  if AboutBox=nil then AboutBox:= TAboutBox.Create(Application);
   AboutBox.ShowModal;

  end;

procedure TMainWindow.MMSaveSectioningClick(Sender: TObject);

begin

{ If FSDSectioning = nil then FSDSectioning:= TFSaveDeconvSectioning.Create(Application);
//  FSDSectioning.Manager:=Manager;
  with FSDSectioning do
   begin
    BBSaveData.Enabled:=True;
    EXResolution.Text:=inttoStr(Manager.XDim);
    EYResolution.Text:=inttoStr(Manager.YDim);
    ENumOfSections.Text:=IntToStr(Manager.ZDim);
   end;
  FSDSectioning.ShowModal;
 }

end;

procedure TMainWindow.UpDateDataSystem;
 begin
  MemorySystem.dwLength:=Sizeof(MemorySystem);
  GlobalMemoryStatus(MemorySystem);
  SBMainWindow.Panels[0].Text:='Memoria Total: ' + IntToStr(trunc(MemorySystem.dwTotalPhys/1024)) + ' KB';
  SBMainWindow.Panels[1].Text:='Memoria Libre: ' + IntToStr(trunc(MemorySystem.dwAvailPhys/1024)) + ' KB';
 end;

procedure TMainWindow.TimerUpDateTimer(Sender: TObject);
 begin
  UpDateDataSystem;
 end;

procedure TMainWindow.MATimeLapseClick(Sender: TObject);
begin
if FTimeLapse=nil then FTimeLapse:=TFTimeLapse.Create(Application);
with FTimeLapse do
 begin
// Stage:=Manager.StgControl;
 EExpositionTime.Text:=FloatToStr(ExTime);
 EXResolution.Text:=IntToStr(XDim);
 EYResolution.Text:=IntToStr(YDim);
 EDelay.Text:=FloatToStr(DeltaZ);
// CBSpeed.Text:=IntToStr(Speed);
// CBDarkFrame.Checked:=DFrame;
// CBFlatFrame.Checked:=FFrame;
 EMean.Text:=IntToStr(ImageMean);
 ShowModal;
 end;

end;

end.
