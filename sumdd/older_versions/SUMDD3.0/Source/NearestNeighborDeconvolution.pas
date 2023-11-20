unit NearestNeighborDeconvolution;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Buttons;

type

  TFNearestNeighborDeconvolution = class(TForm)
    PDeconvolution: TPanel;
    Panel1: TPanel;
    BBOK: TBitBtn;
    BBCancel: TBitBtn;
    Panel2: TPanel;
    LPlaneNumber: TLabel;
    EPlaneNumber: TEdit;
    LC1: TLabel;
    LC2: TLabel;
    UDPlaneNumber: TUpDown;
    Panel3: TPanel;
    CBLens: TComboBox;
    LLens: TLabel;
    LDeltaZ: TLabel;
    EDelta: TEdit;
    LSetPSF: TLabel;
    CBPSF: TComboBox;
    TBC1: TTrackBar;
    TBC2: TTrackBar;
    LMoreLess1: TLabel;
    LMoreLess2: TLabel;
    procedure BBCancelClick(Sender: TObject);
   private
    { Private declarations }
   public
    { Public declarations }
  end;

var
 FNearestNeighborDeconvolution: TFNearestNeighborDeconvolution;
implementation

{$R *.dfm}

procedure TFNearestNeighborDeconvolution.BBCancelClick(Sender: TObject);
begin
Close;
end;

end.
