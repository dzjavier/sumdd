program SUMDD30;


uses
  Forms,
  tofylink in 'tofylink.pas',
  DecTypes in 'DecTypes.pas',
  FourierTransforms in 'FourierTransforms.pas',
  APOGEELib_TLB in 'APOGEELib_TLB.pas',
  SUMDD in 'SUMDD.pas' {MainWindow},
  ConstrainedIterativeDeconvolution in 'ConstrainedIterativeDeconvolution.pas' {FConstrainedIterativeDeconvolution},
  DeconvAlgorithms in 'DeconvAlgorithms.pas',
  Bmp2tiff in 'Bmp2tiff.pas',
  NearestNeighborDeconvolution in 'NearestNeighborDeconvolution.pas' {FNearestNeighborDeconvolution},
  SMDDManager in 'SMDDManager.pas',
  TemperatureControl in 'TemperatureControl.pas' {FTemperatureControl},
  Sectioner in 'Sectioner.pas',
  SectionView in 'SectionView.pas' {FViewSection},
  DataSectioning in 'DataSectioning.pas' {FDataSections},
  AboutSumdd in 'AboutSumdd.pas' {AboutBox},
  LLSDeconvolution in 'LLSDeconvolution.pas' {FLLSDeconvolution},
  ControlOptions in 'ControlOptions.pas' {FControlOptions},
  SaveDeconvSectioning in 'SaveDeconvSectioning.pas' {FSaveDeconvSectioning},
  SectioningFiling in 'SectioningFiling.pas' {FSectioning},
  InitWindow in 'InitWindow.pas' {FInitWindow},
  ThreeDProjection in 'ThreeDProjection.pas' {F3DProjection},
  Colocalization2D in 'Colocalization2D.pas' {FColoc2D},
  Coloc2DView in 'Coloc2DView.pas' {FColoc2DView},
  WienerFilterDeconvolution in 'WienerFilterDeconvolution.pas' {FWiener2DDeconvolution},
  Segmentation3D in 'Segmentation3D.pas' {FSegmentation3D},
  ImageCapture in 'ImageCapture.pas' {FImage};

{$E exe}

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'SUMDD3.0';
  Application.CreateForm(TMainWindow, MainWindow);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.Run;
end.
