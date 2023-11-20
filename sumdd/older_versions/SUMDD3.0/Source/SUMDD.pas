unit SUMDD;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus,Sectioner, ExtDlgs, GR32_Image, ExtCtrls, graphicex,
  StdCtrls, GR32, gr32_layers, DecTypes, Grids,math, FourierTransforms,
  ComCtrls, Buttons,SectionView,ImageCapture,
//  TofyLink,
  Series,
  TeEngine,
  ProgressActivity,
  DateUtils,
  SqlTimSt,
  gfx_files,
  Bmp2tiff,
  GraphicColor,
  DataSectioning,
  SectioningFiling,
  GR32_ByteMaps,
  NearestNeighborDeconvolution,
  DeconvAlgorithms,
  TemperatureControl,
  LLSDeconvolution,
  ThreeDProjection,
  dglOpenGL,
 // OpenGL12,
  SMDDManager,
  ControlOptions,
  ConstrainedIterativeDeconvolution,
  WienerFilterDeconvolution,
  AboutSUMDD,
  SaveDeconvSectioning,
  inifiles,
  InitWindow,
  ToolWin,
  CPUCycles,
  Colocalization2D,
  Segmentation3D,
  TimeLapseFiling;


type
  TMainWindow = class(TForm)
    MMFile: TMenuItem;
    MMFClose: TMenuItem;
    MMAcquisition: TMenuItem;
    MMAImage: TMenuItem;
    MMHelp: TMenuItem;
    MMTools: TMenuItem;
    MMAVolumeSectioning: TMenuItem;
    MMFLoadSections: TMenuItem;
    ODLoadSections: TOpenDialog;
    OPDLoadImage: TOpenPictureDialog;
    IViewGalleryRaw: TImgView32;
    IViewGalleryDeconv: TImgView32;
    MainMenu: TMainMenu;
    MMProcessing: TMenuItem;
    MMPDeconvolution: TMenuItem;
    MMPDNearestNeighbor: TMenuItem;
    MMPDLinearLeastSquare: TMenuItem;
    MMTCleanVolumes: TMenuItem;
    MMTCRaw: TMenuItem;
    MMTCDesconv: TMenuItem;
    MMTTemperatureControl: TMenuItem;
    MMPDConstrainedIterative: TMenuItem;
    LVDataSectioning: TListView;
    MMTControlOptions: TMenuItem;
    MMTCSectioningData: TMenuItem;
    MMTCAll: TMenuItem;
    MMSaveSectioning: TMenuItem;
    MMVisualization: TMenuItem;
    MMV3DProjection: TMenuItem;
    MMHAbout: TMenuItem;
    MMPDWienerFilter2D: TMenuItem;
    ToolBar1: TToolBar;
    SBMainWindow: TStatusBar;
    TimerUpDate: TTimer;
    MMPColoc2D: TMenuItem;
    MMPSegmentation3D: TMenuItem;
    MATimeLapse: TMenuItem;
    procedure MMFCloseClick(Sender: TObject);
    procedure MMFLoadSectionsClick(Sender: TObject);
    procedure MMAImageClick(Sender: TObject);
    procedure MMAVolumeSectioningClick(Sender: TObject);
    procedure IViewGalleryRawMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer;
      Layer: TCustomLayer);
    procedure IViewGalleryDeconvMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer;
      Layer: TCustomLayer);
    procedure FormCreate(Sender: TObject);
    procedure MMTCRawClick(Sender: TObject);
    procedure MMTCDesconvClick(Sender: TObject);
    procedure MMTTemperatureControlClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MMTControlOptionsClick(Sender: TObject);
    procedure MMTCSectioningDataClick(Sender: TObject);
    procedure MMTCAllClick(Sender: TObject);
    procedure MMPDNearestNeighborClick(Sender: TObject);
    procedure MMPDConstrainedIterativeClick(Sender: TObject);
    procedure MMV3DProjectionClick(Sender: TObject);
    procedure MMHAboutClick(Sender: TObject);
    procedure MMPDLinearLeastSquareClick(Sender: TObject);
    procedure MMSaveSectioningClick(Sender: TObject);
    procedure UpDateDataSystem;
    procedure TimerUpDateTimer(Sender: TObject);
    procedure MMPColoc2DClick(Sender: TObject);
    procedure MMPDWienerFilter2DClick(Sender: TObject);
    procedure MMPSegmentation3DClick(Sender: TObject);
    procedure MATimeLapseClick(Sender: TObject);

  private
    { Private declarations }
    Manager:TDDMSManager;
    Speed,ImageMean,XDim,YDim:Integer;
    DeltaZ,ExTime:Double;
    DFrame,FFrame:Boolean;

    protected

  public
    Sit:String;
    { Public declarations }
    procedure PaintLayerToBitmap(Vol:TRawData;IndexLayer:Integer;Btmp:TBitmap32);


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
  Map:TSignal2D;
  SLV:Integer;
  BLDeconv:TBitmapLayer;
  BLRaw:TBitmapLayer;
  Dim: Integer;
  ImForm:TForm;
  Image:TImage32;
  HeaSections:String;
  PSFsdir:String;
  DirSUMDDIniFile:String;
  DirSUMDD:String; // directorio del SUMDD... en principio para el logging
  CameraIniFileName:String;
  //Open GL
  RC : HGLRC;
  Angulo : GLInt;
////////
  FControlOptions:TFControlOptions;
  FTimeLapse:TFTimeLapse;
//  FViewSection: TFViewSection;
//  FGallery: TFGallery;
  FDataSections:TFDataSections;
  FSectioning:TFSectioning;
  FNN:TFNearestNeighborDeconvolution;
  FLLS:TFLLSDeconvolution;
  FCID:TFConstrainedIterativeDeconvolution;
  FWF2D:TFWiener2DDeconvolution;
  FTemperatureControl: TFTemperatureControl;
  FActivityProgress: TFActivityProgress;
  F3DProjectionRaw,F3DProjectionDeconv:  TF3DProjection;
  FSDSectioning: TFSaveDeconvSectioning;
  AboutBox: TAboutBox;
  FSeg3D:TFSegmentation3D;

// Sytem
  MemorySystem: TMemoryStatus;

implementation

{$R *.dfm}

procedure TMainWindow.MMFCloseClick(Sender: TObject);
begin
 close;
end;

procedure TMainWindow.MMFLoadSectionsClick(Sender: TObject);
 var
  Dir:string;
  name,hea,Num: string;
  d:char;
  i,x,y,aux:integer;
begin

if FDataSections=nil then FDataSections:=TFDataSections.Create(Application);

if ODLoadSections.Execute then
  begin
   Dir:=ODLoadSections.FileName;
   if (ODLoadSections.FilterIndex = 2) then
     begin
      FDataSections.LHeader.Visible:=True;
      FDataSections.EHeader.Visible:=True;
      SetLength(hea,5);
      x:=1;
      y:=1;
      name:=ExtractFileName(dir);
      for i:=1 to Length(name)+1 do
       begin
        d:=name[i];
        aux:=StrToIntDef(d,-1);

        if d='.' then break;

        if not(aux=-1) then
         begin
          SetLength(Num,x);
          Num[x]:=d;
          x:=x+1
         end
        else
         begin
          SetLength(Hea,y);
          Hea[y]:=d;
          y:=y+1;
         end;

       end;

      FDataSections.ISectionPreview.Bitmap.LoadFromFile(Dir);
      FDataSections.EIniSection.Text:=Num;
      FDataSections.EHeader.Text:=Hea;
      FDataSections.ENumOfSections.Text:='1';
      FDataSections.ShowModal;

      if FDataSections.ModalResult = mrOK then
        begin

         Manager.LoadRawSectioning(FDataSections.ISectionPreview.Bitmap.Width,
                                FDataSections.ISectionPreview.Bitmap.Height,
                                strtoint(FDataSections.ENumOfSections.Text),
                                strtoint(FDataSections.EIniSection.Text),
                                FDataSections.EHeader.Text,
                                '.tif',
                                ExtractFilePath(Dir));
         MMPDNearestNeighbor.Enabled:=True;
         MMPDConstrainedIterative.Enabled:=True;
         MMPDLinearLeastSquare.Enabled:=True;
         MMPDWienerFilter2D.Enabled:=True;
         MMPSegmentation3D.Enabled:=True;
        end;
      if FDataSections.ModalResult = mrCANCEL then MMFLoadSectionsClick(Sender);
     end;

   if (ODLoadSections.FilterIndex = 1) then
    begin
     Manager.DataVolume:=OpenSectioningFile(Dir);
     with FDataSections, LVDataSectioning do
      begin
       ENumOfSections.Text:=IntToStr(Manager.DataVolume.NumberOfSections);
       Items.Item[16].Caption:='Secciones: ' + IntToStr(Manager.DataVolume.NumberOfSections);
       EIniSection.Text:=FormatFloat('###000',Manager.DataVolume.IniNumber);

       GBSpecimen.Caption:='Especimen: ' + Manager.DataVolume.Specimen;
       Items.Item[1].Caption :='Especimen: ' + Manager.DataVolume.Specimen;

       LDepthRes.Caption:='Resolución de Color: ' + IntToStr(Manager.DataVolume.BitsResolution);
       Items.Item[14].Caption := 'R. de Color: '+ IntToStr(Manager.DataVolume.BitsResolution);

       LResX.Caption:='Resolución X: ' + inttoStr(Manager.DataVolume.XDimension);
       Items.Item[12].Caption :='Resolución X: ' + inttoStr(Manager.DataVolume.XDimension);

       LResY.Caption:='Resolución Y: ' + inttoStr(Manager.DataVolume.YDimension);
       Items.Item[13].Caption :='Resolución Y: ' + inttoStr(Manager.DataVolume.YDimension);

       LDeltaZ.Caption:='Delta Z[um]: ' + FloatToStr(Manager.DataVolume.DeltaZ);
       Items.Item[15].Caption :='Delta Z[um]: ' + FloatToStr(Manager.DataVolume.DeltaZ);

       LTime.Caption:= 'Tiempo de Exposición [s]: ' + FloatToStr(Manager.DataVolume.ExpositionTime);
       Items.Item[4].Caption :='T. de Exposición [s]: ' + FloatToStr(Manager.DataVolume.ExpositionTime);

       LDate.Caption:='Fecha: '+ Manager.DataVolume.Date;
       Items.Item[3].Caption :='Fecha: '+ Manager.DataVolume.Date;

       LTile.Caption:='Marcador: ' + Manager.DataVolume.Tile;
       Items.Item[8].Caption :='Marcador: ' + Manager.DataVolume.Tile;

       LAntiBody.Caption:='Anticuerpo: ' + Manager.DataVolume.AntiBody;
       Items.Item[9].Caption :='Anticuerpo: ' + Manager.DataVolume.AntiBody;

       LSections.Caption:= 'Secciones: ' + IntToStr(Manager.DataVolume.NumberOfSections);

       LAuthor.Caption:='Autor: '+ Manager.DataVolume.Author;
       Items.Item[2].Caption :='Autor: '+ Manager.DataVolume.Author;

       if Manager.DataVolume.Deconvolved then
        begin
         LDesconvolved.Caption:= 'Desconvolución: Sí';
         Items.Item[10].Caption :='Desconvolución: Sí';
         CBLoadRawData.Visible:=True;
        end
       else
        begin
         LDesconvolved.Caption:= 'Desconvolución: No';
         Items.Item[10].Caption :='Desconvolución: No';
        end;
       LDeconvAlgorithm.Caption:='Algoritmo de Desconvolución: ' + Manager.DataVolume.DeconvAlgorithm;
       Items.Item[11].Caption :='Algoritmo de Dcv.: ' + Manager.DataVolume.DeconvAlgorithm;

       LMagnification.Caption:='Magnificación: ' + FloatToStr(Manager.DataVolume.Magnification)+'x';
       Items.Item[6].Caption:='Magnificación: ' + FloatToStr(Manager.DataVolume.Magnification)+'x';

       LObjLens.Caption:='Lente Objetiva: ' + FloatToStr(Manager.DataVolume.OjectiveLens)+ 'x';
       Items.Item[5].Caption:='Lente Objetiva: ' + FloatToStr(Manager.DataVolume.OjectiveLens)+ 'x';

       LOil.Caption:='Aceite de Inmersión: ' + Manager.DataVolume.ImersionOil;
       Items.Item[7].Caption:='Inmersión: ' + Manager.DataVolume.ImersionOil;
       IconOptions.AutoArrange:=True;
       Visible:=true;

       ShowModal;
       if ModalResult = mrOK then
        begin
         Manager.LoadSDFSectioning(strtoint(FDataSections.EIniSection.Text),
                         strtoint(FDataSections.ENumOfSections.Text),
                         CBLoadRawData.Checked);
         MMPDNearestNeighbor.Enabled:=True;
         MMPDConstrainedIterative.Enabled:=True;
         MMPDLinearLeastSquare.Enabled:=True;
         MMPDWienerFilter2D.Enabled:=True;
         MMPSegmentation3D.Enabled:=True;
        end;

       if ModalResult = mrCANCEL then
        begin
         MMFLoadSectionsClick(Sender);
         Visible:=False;
        end;
      end; // End with
    end;
   Manager.GalleryView(IViewGalleryDeconv,IViewGalleryRaw);
  end; // end if execute
end;


procedure TMainWindow.MMAImageClick(Sender: TObject);
begin
 if FImage=nil then FImage:= TFImage.Create(Application);

if Manager.StgControl=nil then
 begin
  FImage.BMoveUp.Enabled:=False;
  FImage.BMoveDown.Enabled:=False;
 end
else FImage.SControl:=Manager.StgControl;
if Manager.Cam=nil then
 begin
  FImage.BBExpose.Enabled:=False;
  FImage.BFocus.Enabled:=False;
 end
else FImage.CamControl:=Manager.Cam;

FImage.ShowModal;
DeltaZ:=StrtoFloat(FImage.CBDeltaZ.text);
Speed:=StrToInt(FImage.CBSpeed.Text);
ImageMean:=StrToInt(FImage.EMean.Text);
XDim:=StrToInt(FImage.EXDim.Text);
YDim:=StrToInt(FImage.EYDim.Text);
ExTime:=StrToFloat(FImage.ETime.Text);
DFrame:=FImage.CBDarkFrame.Checked;
FFrame:=FImage.CBFlatFrame.Checked;
end;

procedure TMainWindow.MMAVolumeSectioningClick(Sender: TObject);
begin
if FSectioning=nil then FSectioning:=TFSectioning.Create(Application);
with FSectioning do
 begin
 GetCamera(Manager.Cam);
 Stage:=Manager.StgControl;
 EExpositionTime.Text:=FloatToStr(ExTime);
 EXResolution.Text:=IntToStr(XDim);
 EYResolution.Text:=IntToStr(YDim);
 EDeltaZ.Text:=FloatToStr(DeltaZ);
 CBSpeed.Text:=IntToStr(Speed);
 CBDarkFrame.Checked:=DFrame;
 CBFlatFrame.Checked:=FFrame;
 EMean.Text:=IntToStr(ImageMean);
 ShowModal;
 end;

end;
procedure TMainWindow.PaintLayerToBitmap(Vol:TRawData;IndexLayer:Integer;Btmp:TBitmap32);
 begin
  Btmp.Assign(Vol[IndexLayer]);
 end;

procedure TMainWindow.IViewGalleryRawMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer;
  Layer: TCustomLayer);
begin
 if not(Layer=nil) then
  begin
   FViewSection:= TFViewSection.Create(Application);
    with FViewSection do
    begin
     ImViewLayerRaw.Visible:=true;
     ImViewLayerRaw.Bitmap.Clear(Color32(255,255,255,255));

//     ImViewLayerRaw.Width:=trunc(Manager.MWidth/2.1);
//     ImViewLayerRaw.Height:=trunc(Manager.MHeight/2.1);

     ImViewLayerRaw.Bitmap.SetSize(Manager.XDim,Manager.YDim);
     PaintLayerToBitmap(Manager.VolRaw,Layer.Index,ImViewLayerRaw.Bitmap);

     if not (Manager.VolDeconv = nil) then
      begin
       ImViewLayerDeconv.Visible:=true;

//       ImViewLayerDeconv.Width:=trunc(Manager.MWidth/2.1);
//       ImViewLayerDeconv.Height:=trunc(Manager.MHeight/2.1);
       ImViewLayerDeconv.Left:=ImViewLayerRaw.Width+2;
       ImViewLayerDeconv.Bitmap.Clear(Color32(255,255,255,255));
       ImViewLayerDeconv.Bitmap.SetSize(Manager.XDim,Manager.YDim);
       ImViewLayerDeconv.Bitmap.Clear(Color32(255,255,255,255));
       ImViewLayerDeconv.Bitmap.SetSize(Manager.XDim,Manager.YDim);
       PaintLayerToBitmap(Manager.VolDeconv,Layer.Index,ImViewLayerDeconv.Bitmap);
      end;
     Caption:='Sección: ' + IntToStr(Layer.Index);
     Show;
    end; //end with
  end; // end if "nil"
end;

procedure TMainWindow.IViewGalleryDeconvMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer;
  Layer: TCustomLayer);
begin
 if not(Layer=nil) then
  begin
   FViewSection:= TFViewSection.Create(Application);
   with FViewSection do
    begin
     ImViewLayerDeconv.Visible:=true;
//     ImViewLayerDeconv.Width:=trunc(Manager.MWidth/2.1);
//     ImViewLayerDeconv.Height:=trunc(Manager.MHeight/2.1);

     if not (Manager.VolRaw = nil) then
      begin
       ImViewLayerRaw.Visible:=true;
//     ImViewLayerRaw.Width:=trunc(Manager.MWidth/2.1);
//     ImViewLayerRaw.Height:=trunc(Manager.MHeight/2.1);
       ImViewLayerDeconv.Left:=ImViewLayerRaw.Width+2;

       ImViewLayerRaw.Bitmap.Clear(Color32(255,255,255,255));
       ImViewLayerRaw.Bitmap.SetSize(Manager.XDim,Manager.YDim);
       PaintLayerToBitmap(Manager.VolRaw,Layer.Index,ImViewLayerRaw.Bitmap);
      end;
     ImViewLayerDeconv.Bitmap.Clear(Color32(255,255,255,255));
     ImViewLayerDeconv.Bitmap.SetSize(Manager.XDim,Manager.YDim);
     PaintLayerToBitmap(Manager.VolDeconv,Layer.Index,ImViewLayerDeconv.Bitmap);
     Caption:='Sección: ' + IntToStr(Layer.Index);
     Show;
    end; //end with
  end; // end if "nil"
end;

procedure TMainWindow.FormCreate(Sender: TObject);
var
 DirPort:String;
 IniFile:TIniFile;
 Cam:String;
 begin
  FInitWindow:=TFInitWindow.Create(Application);
  FInitWindow.ShowModal;
  FInitWindow.Destroy;
  DirSUMDDIniFile:=GetCurrentDir+'\iniSUMDD.ini';
  IniFile:=TIniFile.Create(DirSUMDDIniFile);
  Cam:=IniFile.ReadString('Camera','Name','');
  DirPort:=IniFile.ReadString('Stage','DirPP','$378');
  CameraIniFileName:=GetCurrentDir+'\'+Cam+'.ini';
  Manager:=TDDMSManager.Create(CameraIniFileName,StrtoInt(DirPort));
   if (Manager.Cam=nil) or (Manager.StgControl=nil) then
    begin
     Self.MMAVolumeSectioning.Enabled:=False;
     Self.MMTTemperatureControl.Enabled:=False;
     Self.MATimeLapse.Enabled:=False;
    end;
  Manager.GetMonitorResolution(Monitor.Height,Monitor.Width);
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

procedure TMainWindow.MMTCRawClick(Sender: TObject);
begin
 Manager.CleanVolRaw;
 Manager.GalleryView(IViewGalleryDeconv,IViewGalleryRaw);
 MMPDNearestNeighbor.Enabled:=False;
 MMPDConstrainedIterative.Enabled:=False;
 MMPDLinearLeastSquare.Enabled:=False;

end;

procedure TMainWindow.MMTCDesconvClick(Sender: TObject);

begin
 Manager.CleanVolDeconv;
 Manager.GalleryView(IViewGalleryDeconv,IViewGalleryRaw);
 MMSaveSectioning.Enabled:=False;
end;

procedure TMainWindow.MMTTemperatureControlClick(Sender: TObject);
begin
If FTemperatureControl=nil then FTemperatureControl:= TFTemperatureControl.Create(Application);
FTemperatureControl.GetCamera(Manager.Cam);
FTemperatureControl.Show;
FTemperatureControl.WindowState:=wsNormal;

end;

procedure TMainWindow.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if not(Manager.Cam=nil) then
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

procedure TMainWindow.MMTCSectioningDataClick(Sender: TObject);
begin
LVDataSectioning.Visible:=False;
end;

procedure TMainWindow.MMTCAllClick(Sender: TObject);
begin

Manager.CleanVolRaw;
Manager.CleanVolDeconv;
Manager.CleanVolPSF;
MMPDNearestNeighbor.Enabled:=False;
MMPDLinearLeastSquare.Enabled:=False;
MMPDConstrainedIterative.Enabled:=False;
MMPDWienerFilter2D.Enabled:=False;
MMPSegmentation3D.Enabled:=False;
LVDataSectioning.Visible:=False;
MMSaveSectioning.Enabled:=False;
Manager.GalleryView(IViewGalleryDeconv,IViewGalleryRaw);
{
if not(FDataSections=nil)  then FDataSections.Destroy;
if not (FSectioning=nil) then FSectioning.Destroy;
if not(FNN=nil) then FNN.Destroy;
if not(FLLS=nil)then FLLS.Destroy;
if not(FCID=nil)then FCID.Destroy;
//FActivityProgress.Destroy;
if not(F3DProjection=nil) then F3DProjection.Destroy;
if not(FSDSectioning=nil) then FSDSectioning.Destroy;
if not (AboutBox=nil) then AboutBox.Destroy;
}
end;

procedure TMainWindow.MMPDNearestNeighborClick(Sender: TObject);
var
 c1,c2:Double;
 PSFinFocus,k,j,i,Counter:Integer;
 PSFKind:ShortString;
 PSFRoot:String;
 B:TBitmap32;
 //cpu1, cpu2:Int64;
 VecPSF:TVector;

begin

 if FNN = nil then
  FNN:=TFNearestNeighborDeconvolution.Create(Application);

 FNN.ShowModal;
 with FNN do
  begin
   if ModalResult = mrOk then
    begin
     MainWindow.Refresh;
     case CBPSF.ItemIndex of
      0: PSFKind:='\Theo';
      1: PSFKind:='\Emp';
     end;
     case CBLens.ItemIndex of
      0:begin
         case CBPSF.ItemIndex of
          0:PSFInFocus:= PSFinFocusTheo4x;
          1:PSFInFocus:= PSFinFocusEmp4x;
         end;
         PSFRoot:=PSFsDir+PSFKind+'\psf4\psf';
        end;
      1:begin
         case CBPSF.ItemIndex of
          0:PSFInFocus:= PSFinFocusTheo10x;
          1:PSFInFocus:= PSFinFocusEmp10x;
         end;
         PSFRoot:=PSFsDir+PSFKind+'\psf10\psf';
        end;
      2:begin
         case CBPSF.ItemIndex of
          0:PSFInFocus:= PSFinFocusTheo20x;
          1:PSFInFocus:= PSFinFocusEmp20x;
         end;
         PSFRoot:=PSFsDir+PSFKind+'\psf20\psf';
        end;
      3:begin
         case CBPSF.ItemIndex of
          0:PSFInFocus:= PSFinFocusTheo40x;
          1:PSFInFocus:= PSFinFocusEmp40x;
         end;
         PSFRoot:=PSFsDir+PSFKind+'\psf40\psf';
        end;
      4:begin
         case CBPSF.ItemIndex of
          0:PSFInFocus:= PSFinFocusTheo100x;
          1:PSFInFocus:= PSFinFocusEmp100x;
         end;
         PSFRoot:=PSFsDir+PSFKind+'\psf100\psf';
        end;
     end;

     Manager.PrepareForLinearDeconvolution;

     B:=TBitmap32.Create;
     for k:=0 to 2 do
      begin
       Counter:=k*Manager.XDim*Manager.YDim;
       B.LoadFromFile(PSFRoot+IntToStr(PSFinFocus-1+k)+'.tif');

       if Counter=0 then SetLength(VecPSF,Manager.XDim*Manager.YDim*3);

       for i:=0 to B.Height-1 do
        begin
         for j:=0 to B.Width-1 do
          begin
           //Manager.VolumeP[k,j,i].Re:=intensity(B.PixelS[j,i]);
           VecPSF[Counter]:=intensity(B.PixelS[j,i]);
//           Manager.DataPSF[Counter]:=intensity(B.PixelS[j,i]);
           inc(Counter);
          end;
          Counter:= Counter + (Manager.XDim-B.Width);
        end;
      end;
     B.Destroy;

{    //old const and algorithm

     c1:=0.0001;
     c2:=0.005;
     FActivityProgress:= TFActivityProgress.Create(Application);
     FActivityProgress.PBActivityProgress.Max:=Manager.ZDim-2;
     FActivityProgress.Caption:='Desconvolucionando';
     FActivityProgress.Show;
     FActivityProgress.Refresh;
     for k:=1 to Manager.ZDim-2 do
      begin
       Application.ProcessMessages;
       FActivityProgress.PBActivityProgress.Position:=k;
       FActivityProgress.LProgress.Caption:=FormatFloat('##.#%',k/(Manager.ZDim-2)*100);
       FActivityProgress.Refresh;
       If not FActivityProgress.Visible then break;

      NearestNeighbornd(Manager.VolumeP[1],Manager.VolumeP[0],Manager.VolumeP[2],
                       Manager.VolumeR[k],Manager.VolumeR[k-1],Manager.VolumeR[k+1],
                       Manager.VolumeD[k],Manager.XDim,Manager.YDim,c1,c2);



      end;




     FActivityProgress.Destroy;
     }

     c1:=TBC1.Position/100;
     c2:=100/TBC2.Position;
//     c:=10/TBC.Position;
   // cpu1:=GetCPUCycles;
     NearestNeighborndNEW(VecPSF,Manager.DataCalc,Manager.XDim,Manager.YDim,Manager.ZDim,c1,c2);
   // cpu1:=GetCPUCycles-cpu1;



	 //Manager.DataRaw:=

	 {MessageDlg( 'NN     : '+ IntToStr(cpu1) + #13+
                       'NN var: '+ IntToStr(cpu2),mtInformation, [mbOk], 0);}

     Manager.LinearDeconvolutionFinished;
     Manager.GalleryView(IViewGalleryDeconv,IViewGalleryRaw);
     MMSaveSectioning.Enabled:=True;

    end
  end;
// Don't waste code
// FNN.Destroy;

end;


procedure TMainWindow.MMPDConstrainedIterativeClick(Sender: TObject);
var
 Counter,c,PSFinFocus,PSFNumber,k,j,i:Integer;
 PSFKind:ShortString;
 PSFRoot:String;
 B:TBitmap32;
 VecPSF:TVector;
begin
 if FCID= nil then FCID:=TFConstrainedIterativeDeconvolution.Create(Application);

 FCID.ShowModal;
 with FCID do
  begin
   if ModalResult = mrOk then
    begin
     MainWindow.Refresh;
     case CBPSF.ItemIndex of
      0: PSFKind:='\Theo';
      1: PSFKind:='\Emp';
     end;
     case CBLens.ItemIndex of
      0:begin
         case CBPSF.ItemIndex of
          0:begin
             PSFInFocus:= PSFinFocusTheo4x;
             PSFNumber:=PSFNumberTheo4x;
            end;
          1:begin
             PSFInFocus:= PSFinFocusEmp4x;
             PSFNumber:=PSFNumberEmp4x;
            end;
         end;
         PSFRoot:=PSFsDir+PSFKind+'\psf4\psf';
        end;
      1:begin
         case CBPSF.ItemIndex of
          0:begin
             PSFInFocus:= PSFinFocusEmp10x;
             PSFNumber:=PSFNumberEmp10x;
            end;
          1:begin
             PSFInFocus:= PSFinFocusEmp10x;
             PSFNumber:=PSFNumberemp10x;
            end;
         end;
         PSFRoot:=PSFsDir+PSFKind+'\psf10\psf';
        end;
      2:begin
         case CBPSF.ItemIndex of
          0:begin
             PSFInFocus:= PSFinFocusTheo20x;
             PSFNumber:=PSFNumberTheo20x;
            end;
          1:begin
             PSFInFocus:= PSFinFocusEmp20x;
             PSFNumber:=PSFNumberEmp20x;
            end;
         end;
         PSFRoot:=PSFsDir+PSFKind+'\psf20\psf';
        end;
      3:begin
         case CBPSF.ItemIndex of
          0:begin
             PSFInFocus:= PSFinFocusTheo40x;
             PSFNumber:=PSFNumberTheo40x;
            end;
          1:begin
             PSFInFocus:= PSFinFocusEmp40x;
             PSFNumber:=PSFNumberEmp40x;
            end;

         end;
         PSFRoot:=PSFsDir+PSFKind+'\psf40\psf';
        end;
      4:begin
         case CBPSF.ItemIndex of
          0:begin
             PSFInFocus:= PSFinFocusTheo100x;
             PSFNumber:=PSFNumberTheo100x;
            end;
          1:begin
             PSFInFocus:= PSFinFocusEmp100x;
             PSFNumber:=PSFNumberEmp100x;
            end;
         end;
         PSFRoot:=PSFsDir+PSFKind+'\psf100\psf';
        end;
     end;

     Manager.PrepareForDeconvolution;
     B:=TBitmap32.Create;
     c:=0;
     Counter:=0;
     if Manager.ZDim >= PSFNumber then
      begin
        for k:= PSFInFocus-(PSFNumber div 2) to PSFInFocus+(PSFNumber div 2)-1 do
         begin
          B.LoadFromFile(PSFRoot+IntToStr(k)+'.tif');
          if Counter=0 then SetLength(VecPSF,Manager.XDim*Manager.YDim*Manager.ZDim);
          for i:=0 to B.Height-1 do
           begin
            for j:=0 to B.Width-1 do
             begin
           //   Manager.VolumeP[c,j,i].Re:=intensity(B.PixelS[j,i]);
              VecPSF[Counter]:=intensity(B.PixelS[j,i]);
              inc(Counter);
             end;
            Counter:= Counter + (Manager.XDim-B.Width);
            inc(c,1);
           end;
          Counter:= Counter + ((Manager.YDim-B.Height)*Manager.XDim);
        end;
      end // end if
     else
      begin
       for k:= PSFInFocus-(Manager.ZDim div 2) to PSFInFocus+(Manager.ZDim div 2)-1 do
         begin
          B.LoadFromFile(PSFRoot+IntToStr(k)+'.tif');
          if Counter=0 then SetLength(VecPSF,Manager.XDim*Manager.YDim*Manager.ZDim);
           for i:=0 to B.Height-1 do
            begin
             for j:=0 to B.Width-1 do
              begin
         //      Manager.VolumeP[c,j,i].Re:=intensity(B.PixelS[j,i]);
               VecPSF[Counter]:=intensity(B.PixelS[j,i]);
               inc(Counter);
              end;
             Counter:= Counter + (Manager.XDim-B.Width);
             inc(c,1);
            end;
          Counter:= Counter + ((Manager.YDim-B.Height)*Manager.XDim);
         end;
      end;//end else
     B.Destroy;

//     ConstrainedIterative1(Manager.VolumeR,Manager.VolumeP,Manager.ZDim,
//                          Manager.XDim,Manager.YDim,Manager.VolumeD);

     ConstrainedIterativeNEW(VecPSF,
                             Manager.DataCalc,
                             Manager.XDim,
                             Manager.YDim,
                             Manager.ZDim);

     Manager.DeconvolutionFinished;
     Manager.GalleryView(IViewGalleryDeconv,IViewGalleryRaw);
     MMSaveSectioning.Enabled:=True;
    end // end If ModalResult
  end; // end With
end;

procedure TMainWindow.MMV3DProjectionClick(Sender: TObject);
 var
 i,j,k,cRaw,cDeconv :integer;
begin
 if not (Manager.VolRaw=nil) then
  begin
   if F3DProjectionRaw = nil then F3DProjectionRaw:= TF3DProjection.Create(Application);
   if F3DProjectionDeconv = nil then F3DProjectionDeconv:= TF3DProjection.Create(Application);
   F3DProjectionRaw.Caption:='Proyección Tridimensional de Datos';
   F3DProjectionDeconv.Caption:='Proyección Tridimensional de Datos';
   cRaw:=0;
   cDeconv:=0;
   for k:=0 to Manager.ZDim-1 do
    for i:=0 to Manager.YDim-1 do
     for j:=0 to Manager.XDim-1 do
      begin
       if (not(Manager.VolRaw=nil)) and (Manager.VolRaw[k].Value[j,i]>0)then
        begin
         SetLength(F3DProjectionRaw.VColor,cRaw+1);
         SetLength(F3DProjectionRaw.VVertex,cRaw+1);
         F3DProjectionRaw.VColor[cRaw,1]:=Manager.VolRaw[k].Value[j,i];
         F3DProjectionRaw.VColor[cRaw,2]:=Manager.VolRaw[k].Value[j,i];
         F3DProjectionRaw.VColor[cRaw,3]:=Manager.VolRaw[k].Value[j,i];
         F3DProjectionRaw.VVertex[cRaw,1]:=(j-Manager.XDim/2)/512;
         F3DProjectionRaw.VVertex[cRaw,2]:=(i-Manager.YDim/2)/512;
         F3DProjectionRaw.VVertex[cRaw,3]:=(k-Manager.ZDim/2)/512;
         cRaw:= cRaw+1;
        end;

       if (not(Manager.VolDeconv=nil)) and (Manager.VolDeconv[k].Value[j,i]>0) then
        begin
       {  SetLength(F3DProjectionDeconv.VColor,cDeconv+1);
         SetLength(F3DProjectionDeconv.VVertex,cDeconv+1);
         F3DProjectionDeconv.VColor[cDeconv,1]:=Manager.VolDeconv[k].Value[j,i];
         F3DProjectionDeconv.VColor[cDeconv,2]:=Manager.VolDeconv[k].Value[j,i];
         F3DProjectionDeconv.VColor[cDeconv,3]:=Manager.VolDeconv[k].Value[j,i];
         F3DProjectionDeconv.VVertex[cDeconv,1]:=(j-Manager.XDim/2)/512;
         F3DProjectionDeconv.VVertex[cDeconv,2]:=(i-Manager.YDim/2)/512;
         F3DProjectionDeconv.VVertex[cDeconv,3]:=(k-Manager.ZDim/2)/512;
         cDeconv:= cDeconv+1;}
        end;
       end;
   F3DProjectionRaw.InitData;
   F3DProjectionRaw.XDim:=Manager.XDim;
   F3DProjectionRaw.YDim:=Manager.YDim;
   F3DProjectionRaw.ZDim:=Manager.ZDim;
{   F3DProjectionDeconv.InitData;
   F3DProjectionDeconv.XDim:=Manager.XDim;
   F3DProjectionDeconv.YDim:=Manager.YDim;
   F3DProjectionDeconv.ZDim:=Manager.ZDim;}
   F3DProjectionRaw.Show;
  end;

  end;

procedure TMainWindow.MMHAboutClick(Sender: TObject);
 begin
  if AboutBox=nil then AboutBox:= TAboutBox.Create(Application);
   AboutBox.ShowModal;

  end;

procedure TMainWindow.MMPDLinearLeastSquareClick(Sender: TObject);

var
 Counter1,Counter2,PSFinFocus,PSFNumber,k,j,i:Integer;
 PSFKind:ShortString;
 PSFRoot:String;
 B:TBitmap32;
 MuOptimo:Double;
 VecPSF:TVector;
 //cpu1,cpu2:Int64;
begin

 if FLLS= nil then FLLS:=TFLLSDeconvolution.Create(Application);

 FLLS.ShowModal;
 with FLLS do
  begin
   if ModalResult = mrOk then
    begin
     MainWindow.Refresh;
     MuOptimo:=0.005;
     case CBPSF.ItemIndex of
      0: PSFKind:='\Theo';
      1: PSFKind:='\Emp';
     end;
     case CBLens.ItemIndex of
      0:begin
        case CBPSF.ItemIndex of
         0:begin
            PSFInFocus:= PSFinFocusTheo4x;
            PSFNumber:=PSFNumberTheo4x;
           end;
         1:begin
            PSFInFocus:= PSFinFocusEmp4x;
            PSFNumber:=PSFNumberEmp4x;
           end;
        end;
        PSFRoot:=PSFsDir+PSFKind+'\psf4\psf';
        end;
       1:begin
           case CBPSF.ItemIndex of
            0:begin
               PSFInFocus:= PSFinFocusTheo10x;
               PSFNumber:=PSFNumberTheo10x;
              end;
            1:begin
               PSFInFocus:= PSFinFocusEmp10x;
               PSFNumber:=PSFNumberemp10x;
              end;
           end;
           PSFRoot:=PSFsDir+PSFKind+'\psf10\psf';
         end;
        2:begin
           case CBPSF.ItemIndex of
            0:begin
               PSFInFocus:= PSFinFocusTheo20x;
               PSFNumber:=PSFNumberTheo20x;
              end;
            1:begin
               PSFInFocus:= PSFinFocusEmp20x;
               PSFNumber:=PSFNumberEmp20x;
             end;
           end;
           PSFRoot:=PSFsDir+PSFKind+'\psf20\psf';
          end;
        3:begin
           case CBPSF.ItemIndex of
            0:begin
               PSFInFocus:= PSFinFocusTheo40x;
               PSFNumber:=PSFNumberTheo40x;
              end;
            1:begin
               PSFInFocus:= PSFinFocusEmp40x;
               PSFNumber:=PSFNumberEmp40x;
              end;
           end;
           PSFRoot:=PSFsDir+PSFKind+'\psf40\psf';
          end;
        4:begin
           case CBPSF.ItemIndex of
            0:begin
               PSFInFocus:= PSFinFocusTheo100x;
               PSFNumber:=PSFNumberTheo100x;
              end;
            1:begin
               PSFInFocus:= PSFinFocusEmp100x;
               PSFNumber:=PSFNumberEmp100x;
              end;
           end;
           PSFRoot:=PSFsDir+PSFKind+'\psf100\psf';
          end;
        end;// en Case Lens

       Manager.PrepareForLinearDeconvolution;

       /// This is just for a moment
       //SetLength(VecPSF,64*64*32);
       ///

       B:=TBitmap32.Create;
       Counter1:=0;
       Counter2:=0;

//      if Manager.ZDim >= PSFNumber then
//        begin
          for k:= PSFInFocus-(PSFNumber div 2) to PSFInFocus+(PSFNumber div 2)-1 do
           begin
            B.LoadFromFile(PSFRoot+IntToStr(k)+'.tif');
            if Counter1=0 then SetLength(VecPSF,B.Width*B.Height*PSFNumber);
            for i:=0 to B.Height-1 do
             begin
              for j:=0 to B.Width-1 do
               begin
               //Manager.VecPSF[Counter1].Re:=intensity(B.PixelS[j,i]);
               //Manager.DataPSF[Counter1]:=intensity(B.PixelS[j,i]);
                VecPSF[Counter1]:=intensity(B.PixelS[j,i]);
                inc(Counter1);
               end;
//              Counter1:= Counter1+(Manager.XDim-B.Width)
             end;
//             inc(Counter2);
            end;

//        end // end if


       B.Destroy;
       MuOptimo:=1/(TBSNR.Position*100);


     {cpu1:=GetCPUCycles;
     LinearLeastSquare(Manager.VecRaw,Manager.VecDeconv,Manager.VecPSF,
                       Manager.VecAval,MuOptimo,Manager.XDim*Manager.YDim*Manager.ZDim);
	 cpu1:=GetCPUCycles-cpu1;}

     //cpu2:=GetCPUCycles;
     LinearLeastSquareNEW(VecPSF,Manager.DataCalc,MuOptimo);
     //cpu2:=GetCPUCycles-cpu2;

     Manager.LinearDeconvolutionFinished;
     Manager.GalleryView(IViewGalleryDeconv,IViewGalleryRaw);
     MMSaveSectioning.Enabled:=True;
    end // end If ModalResult
  end;

Refresh;
 {MessageDlg( 'NN     : '+ IntToStr(cpu1) + #13+
                       'NN var: '+ IntToStr(cpu2),mtInformation, [mbOk], 0);}
end;

procedure TMainWindow.MMSaveSectioningClick(Sender: TObject);

begin

 If FSDSectioning = nil then FSDSectioning:= TFSaveDeconvSectioning.Create(Application);
  FSDSectioning.Manager:=Manager;
  with FSDSectioning do
   begin
    BBSaveData.Enabled:=True;
    EXResolution.Text:=inttoStr(Manager.XDim);
    EYResolution.Text:=inttoStr(Manager.YDim);
    ENumOfSections.Text:=IntToStr(Manager.ZDim);
   end;
  FSDSectioning.ShowModal;


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

procedure TMainWindow.MMPColoc2DClick(Sender: TObject);
begin

 if FColoc2D = nil then FColoc2D:=TFColoc2D.Create(Self);
 FColoc2D.Show;

end;

procedure TMainWindow.MMPDWienerFilter2DClick(Sender: TObject);
var
 c:Double;
 PSFinFocus,k,j,i,Counter:Integer;
 PSFKind:ShortString;
 PSFRoot:String;
 B:TBitmap32;
 //cpu1, cpu2:Int64;
 VecPSF:TVector;

begin

 if FWF2D = nil then
  FWF2D:=TFWiener2DDeconvolution.Create(Application);

 FWF2D.ShowModal;
 with FWF2D do
  begin
   if ModalResult = mrOk then
    begin
     MainWindow.Refresh;
     case CBPSF.ItemIndex of
      0: PSFKind:='\Theo';
      1: PSFKind:='\Emp';
     end;
     case CBLens.ItemIndex of
      0:begin
         case CBPSF.ItemIndex of
          0:PSFInFocus:= PSFinFocusTheo4x;
          1:PSFInFocus:= PSFinFocusEmp4x;
         end;
         PSFRoot:=PSFsDir+PSFKind+'\psf4\psf';
        end;
      1:begin
         case CBPSF.ItemIndex of
          0:PSFInFocus:= PSFinFocusTheo10x;
          1:PSFInFocus:= PSFinFocusEmp10x;
         end;
         PSFRoot:=PSFsDir+PSFKind+'\psf10\psf';
        end;
      2:begin
         case CBPSF.ItemIndex of
          0:PSFInFocus:= PSFinFocusTheo20x;
          1:PSFInFocus:= PSFinFocusEmp20x;
         end;
         PSFRoot:=PSFsDir+PSFKind+'\psf20\psf';
        end;
      3:begin
         case CBPSF.ItemIndex of
          0:PSFInFocus:= PSFinFocusTheo40x;
          1:PSFInFocus:= PSFinFocusEmp40x;
         end;
         PSFRoot:=PSFsDir+PSFKind+'\psf40\psf';
        end;
      4:begin
         case CBPSF.ItemIndex of
          0:PSFInFocus:= PSFinFocusTheo100x;
          1:PSFInFocus:= PSFinFocusEmp100x;
         end;
         PSFRoot:=PSFsDir+PSFKind+'\psf100\psf';
        end;
     end;

     Manager.PrepareForLinearDeconvolution;

     B:=TBitmap32.Create;
     B.LoadFromFile(PSFRoot+IntToStr(PSFinFocus)+'.tif');
     SetLength(VecPSF,Manager.XDim*Manager.YDim);
     Counter:=0;
     for i:=0 to B.Height-1 do
      begin
       for j:=0 to B.Width-1 do
        begin
         VecPSF[Counter]:=intensity(B.PixelS[j,i]);
         inc(Counter);
        end;
         Counter:= Counter + (Manager.XDim-B.Width);
        end;
      end;
     B.Destroy;
     c:=10/TBC.Position;

   // cpu1:=GetCPUCycles;
     WienerFilter2D(VecPSF,Manager.DataCalc,Manager.XDim,Manager.YDim,Manager.ZDim,c);
   // cpu1:=GetCPUCycles-cpu1;
    // cpu2:=GetCPUCycles;
    // NearestNeighborndNEWVar(Manager.DataPSF,Manager.VeRaw,Manager.XDim,Manager.YDim,Manager.ZDim,c1,c2);
	// cpu2:=GetCPUCycles-cpu2;

	 //Manager.DataRaw:=

	 {MessageDlg( 'NN     : '+ IntToStr(cpu1) + #13+
                       'NN var: '+ IntToStr(cpu2),mtInformation, [mbOk], 0);}

     Manager.LinearDeconvolutionFinished;
     Manager.GalleryView(IViewGalleryDeconv,IViewGalleryRaw);
     MMSaveSectioning.Enabled:=True;

    end
  end;
// Don't waste code
// FWF2D.Destroy;

procedure TMainWindow.MMPSegmentation3DClick(Sender: TObject);
var
 j:integer;

begin

 if FSeg3D = nil then FSeg3D:=TFSegmentation3D.Create(Self);
 FSeg3D.Data:=Manager.VolRaw;
 FSeg3D.TBImageSeries.Min:=0;
 FSeg3D.TBImageSeries.Max:=Manager.ZDim-1;
 FSeg3D.TBImageSeries.Position:=Manager.ZDim div 2;
 FSeg3D.IVSeries.Bitmap.Assign(Manager.VolRaw[Manager.ZDim div 2]);
 Manager.CalcHist3D;
 FSeg3D.HistSeries.AddArray(Manager.Hist3D);

 //HistSeries.Marks.Transparent:=true;
 //HistSeries.Marks.Style:=smsLabel;

 FSeg3D.ShowModal;
 FSeg3D.HistSeries.Clear;
 FSeg3D.HistPoints.Clear

end;

procedure TMainWindow.MATimeLapseClick(Sender: TObject);
begin
if FTimeLapse=nil then FTimeLapse:=TFTimeLapse.Create(Application);
with FTimeLapse do
 begin
 GetCamera(Manager.Cam);
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
