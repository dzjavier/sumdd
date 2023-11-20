unit WienerFilterDeconvolution;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Buttons;

type

  TFWiener2DDeconvolution = class(TForm)
    PDeconvolution: TPanel;
    Panel1: TPanel;
    BBOK: TBitBtn;
    BBCancel: TBitBtn;
    Panel3: TPanel;
    CBLens: TComboBox;
    LLens: TLabel;
    LSetPSF: TLabel;
    CBPSF: TComboBox;
    LC: TLabel;
    TBC: TTrackBar;
    LMoreLess: TLabel;
    procedure BBCancelClick(Sender: TObject);
   private
    { Private declarations }
   public
    { Public declarations }
  end;

var
 FWiener2DDeconvolution: TFWiener2DDeconvolution;
implementation

{$R *.dfm}

procedure TFWiener2DDeconvolution.BBCancelClick(Sender: TObject);
begin
Close;
end;

end.
