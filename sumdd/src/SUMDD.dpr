program SUMDD;




uses
  Forms,
  DecTypes in 'DecTypes.pas',
  APOGEELib_TLB in 'APOGEELib_TLB.pas',
  MainForm in 'MainForm.pas' {MainWindow},
  TemperatureControl in 'TemperatureControl.pas' {FTemperatureControl},
  DataSectioning in 'DataSectioning.pas' {FDataSections},
  AboutSumdd in 'AboutSumdd.pas' {AboutBox},
  ControlOptions in 'ControlOptions.pas' {FControlOptions},
  InitWindow in 'InitWindow.pas' {FInitWindow},
  ImageCapture in 'ImageCapture.pas' {FImage},
  LightMonitor in 'LightMonitor.pas',
  CameraControl in 'CameraControl.pas',
  StageControl in 'StageControl.pas',
  Sectioning in 'Sectioning.pas',
  SectioningFiling in 'SectioningFiling.pas' {FSectioning},
  DarkCurrentAdquisition in 'DarkCurrentAdquisition.pas' {FDarkCurrentAdquisition},
  FilesManagement in 'FilesManagement.pas',
  DateAndTime in 'DateAndTime.pas',
  SUMDDMetadata in 'SUMDDMetadata.pas',
  Images in 'Images.pas',
  JavaApplicationLuncher in 'JavaApplicationLuncher.pas',
  OpenGLRenderer in 'OpenGLRenderer.pas' {FOGLRenderer};
//  OpenGLDrawables in 'OpenGLDrawables.pas';

{$E exe}

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'SUMDD_test_2014';
  Application.CreateForm(TMainWindow, MainWindow);
  Application.CreateForm(TFInitWindow, FInitWindow);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TFControlOptions, FControlOptions);
  Application.CreateForm(TFTemperatureControl, FTemperatureControl);
  Application.CreateForm(TFSectioning, FSectioning);
  Application.Run;
end.
