program SUMDD;


{%TogetherDiagram 'ModelSupport_SUMDD\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SUMDD\TemperatureControl\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SUMDD\ThreeDProjection\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SUMDD\TimeLapseFiling\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SUMDD\TofyLink\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SUMDD\SectioningFiling\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SUMDD\ImageCapture\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SUMDD\Coloc2DView\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SUMDD\LLSDeconvolution\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SUMDD\WienerFilterDeconvolution\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SUMDD\InitWindow\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SUMDD\ConstrainedIterativeDeconvolution\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SUMDD\AboutSumdd\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SUMDD\ControlOptions\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SUMDD\SectionView\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SUMDD\FourierTransforms\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SUMDD\Colocalization2D\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SUMDD\SMDDManager\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SUMDD\NearestNeighborDeconvolution\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SUMDD\DataSectioning\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SUMDD\Segmentation3D\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SUMDD\MainForm\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SUMDD\SUMDD\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SUMDD\FilesManagement\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SUMDD\DeconvAlgorithms\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SUMDD\LightMonitor\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SUMDD\APOGEELib_TLB\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SUMDD\DecTypes\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SUMDD\default.txvpck'}
{%TogetherDiagram 'ModelSupport_SUMDD\ThreeDProjection\default.txvpck'}
{%TogetherDiagram 'ModelSupport_SUMDD\InitWindow\default.txvpck'}
{%TogetherDiagram 'ModelSupport_SUMDD\ConstrainedIterativeDeconvolution\default.txvpck'}
{%TogetherDiagram 'ModelSupport_SUMDD\DecTypes\default.txvpck'}
{%TogetherDiagram 'ModelSupport_SUMDD\TofyLink\default.txvpck'}
{%TogetherDiagram 'ModelSupport_SUMDD\AboutSumdd\default.txvpck'}
{%TogetherDiagram 'ModelSupport_SUMDD\ImageCapture\default.txvpck'}
{%TogetherDiagram 'ModelSupport_SUMDD\ControlOptions\default.txvpck'}
{%TogetherDiagram 'ModelSupport_SUMDD\SectionView\default.txvpck'}
{%TogetherDiagram 'ModelSupport_SUMDD\APOGEELib_TLB\default.txvpck'}
{%TogetherDiagram 'ModelSupport_SUMDD\FourierTransforms\default.txvpck'}
{%TogetherDiagram 'ModelSupport_SUMDD\Colocalization2D\default.txvpck'}
{%TogetherDiagram 'ModelSupport_SUMDD\SMDDManager\default.txvpck'}
{%TogetherDiagram 'ModelSupport_SUMDD\NearestNeighborDeconvolution\default.txvpck'}
{%TogetherDiagram 'ModelSupport_SUMDD\DataSectioning\default.txvpck'}
{%TogetherDiagram 'ModelSupport_SUMDD\TimeLapseFiling\default.txvpck'}
{%TogetherDiagram 'ModelSupport_SUMDD\Segmentation3D\default.txvpck'}
{%TogetherDiagram 'ModelSupport_SUMDD\SectioningFiling\default.txvpck'}
{%TogetherDiagram 'ModelSupport_SUMDD\MainForm\default.txvpck'}
{%TogetherDiagram 'ModelSupport_SUMDD\SUMDD\default.txvpck'}
{%TogetherDiagram 'ModelSupport_SUMDD\FilesManagement\default.txvpck'}
{%TogetherDiagram 'ModelSupport_SUMDD\DeconvAlgorithms\default.txvpck'}
{%TogetherDiagram 'ModelSupport_SUMDD\LightMonitor\default.txvpck'}
{%TogetherDiagram 'ModelSupport_SUMDD\TemperatureControl\default.txvpck'}
{%TogetherDiagram 'ModelSupport_SUMDD\Coloc2DView\default.txvpck'}
{%TogetherDiagram 'ModelSupport_SUMDD\LLSDeconvolution\default.txvpck'}
{%TogetherDiagram 'ModelSupport_SUMDD\WienerFilterDeconvolution\default.txvpck'}
{%TogetherDiagram 'ModelSupport_SUMDD\CameraControl\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SUMDD\CameraControl\default.txvpck'}
{%TogetherDiagram 'ModelSupport_SUMDD\StageControl\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SUMDD\StageControl\default.txvpck'}
{%TogetherDiagram 'ModelSupport_SUMDD\Sectioning\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_SUMDD\Sectioning\default.txvpck'}
{%ToDo 'SUMDD.todo'}
{%ConfigurationCompiler 'ModelSupport_SUMDD\Sectioning\default.config'}

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
  TimeLapseFiling in 'TimeLapseFiling.pas' {FTimeLapse},
  LightMonitor in 'LightMonitor.pas',
  CameraControl in 'CameraControl.pas',
  StageControl in 'StageControl.pas',
  Sectioning in 'Sectioning.pas',
  SectioningFiling in 'SectioningFiling.pas' {FSectioning};

{$E exe}

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'SUMDD';
  Application.CreateForm(TMainWindow, MainWindow);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TFTimeLapse, FTimeLapse);
  Application.CreateForm(TFSectioning, FSectioning);
  Application.Run;
end.
