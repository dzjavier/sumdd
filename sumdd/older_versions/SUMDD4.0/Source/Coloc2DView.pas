unit Coloc2DView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GR32_Image, Menus, ExtCtrls, StdCtrls,
  BMP2Tiff;

type
  TFColoc2DView = class(TForm)
    MMColocview: TMainMenu;
    MMFile: TMenuItem;
    ImColocView: TImgView32;
    PColocresults: TPanel;
    LPearsonCoef: TLabel;
    PResults: TPanel;
    EPearsonCoef: TEdit;
    LCorrelationCoef: TLabel;
    ECorrCoef: TEdit;
    LK1Coef: TLabel;
    EK1CorrCoef: TEdit;
    LK2Coef: TLabel;
    EK2CorrCoef: TEdit;
    LcoloccoefMm1: TLabel;
    LColocCoefMm2: TLabel;
    EColocCoefMm1: TEdit;
    EColocCoefMm2: TEdit;
    LColocCoefM1: TLabel;
    LColocCoefM2: TLabel;
    EColocCoefM1: TEdit;
    EColocCoefM2: TEdit;
    SDColoc: TSaveDialog;
    MMFSave: TMenuItem;
    procedure MMFSaveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FColoc2DView: TFColoc2DView;

implementation

{$R *.dfm}

procedure TFColoc2DView.MMFSaveClick(Sender: TObject);
var
 i,j:Integer;
 BM:TBitmap;
 StAux:TMemoryStream;

begin


 if SDColoc.Execute then
   begin
    BM:=TBitmap.Create;
    StAux:=TMemoryStream.Create;
    ImColocView.Bitmap.SaveToStream(StAux);
    StAux.Position:=0;
    BM.LoadFromStream(StAux);
    StAux.Position:=0;
    Writetifftofile(ChangeFileExt(SDColoc.FileName,'.tif'),BM);
    BM.Destroy;
    StAux.Free;

   end;



end;

end.
