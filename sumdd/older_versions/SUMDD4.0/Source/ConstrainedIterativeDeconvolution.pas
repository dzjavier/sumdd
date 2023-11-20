unit ConstrainedIterativeDeconvolution;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Buttons;

type

  TFConstrainedIterativeDeconvolution = class(TForm)
    PDeconvolution: TPanel;
    Panel1: TPanel;
    BBOK: TBitBtn;
    BBCancel: TBitBtn;
    Panel2: TPanel;
    LDeltaZ: TLabel;
    EDelta: TEdit;
    LLens: TLabel;
    CBLens: TComboBox;
    LSetPSF: TLabel;
    CBPSF: TComboBox;
    procedure BBCancelClick(Sender: TObject);
   private
    { Private declarations }
   public
    { Public declarations }
  end;

var

 FConstrainedIterativeDeconvolution: TFConstrainedIterativeDeconvolution;

implementation

{$R *.dfm}

procedure TFConstrainedIterativeDeconvolution.BBCancelClick(
  Sender: TObject);
begin
Close;
end;

end.
