unit DataSectioning;
{Módulo que carga los datos de imágenes obtenidas por seccionamiento y archivos
SDF}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, GR32_Image;

type
  TFDataSections = class(TForm)
    PData: TPanel;
    BBLoad: TBitBtn;
    BBCancelLoad: TBitBtn;
    GBSpecimen: TGroupBox;
    LAuthor: TLabel;
    LDate: TLabel;
    LDesconvolved: TLabel;
    LDeconvAlgorithm: TLabel;
    LTime: TLabel;
    LObjLens: TLabel;
    LMagnification: TLabel;
    LOil: TLabel;
    LTile: TLabel;
    ENumOfSections: TEdit;
    LNumOfSections: TLabel;
    EIniSection: TEdit;
    LIniSection: TLabel;
    LSections: TLabel;
    LResX: TLabel;
    LDepthRes: TLabel;
    LResY: TLabel;
    LAntiBody: TLabel;
    LDeltaZ: TLabel;
    CBLoadRawData: TCheckBox;
    EHeader: TEdit;
    LHeader: TLabel;
    Panel1: TPanel;
    ISectionPreview: TImage32;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FDataSections: TFDataSections;

implementation

{$R *.dfm}

end.
