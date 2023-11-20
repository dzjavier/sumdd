unit LLSDeconvolution;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls;

type

  TFLLSDeconvolution = class(TForm)
    Panel1: TPanel;
    Panel3: TPanel;
    BBOk: TBitBtn;
    BBCancel: TBitBtn;
    Panel2: TPanel;
    LLens: TLabel;
    LDeltaZ: TLabel;
    CBLens: TComboBox;
    EDelta: TEdit;
    Panel4: TPanel;
    LPSF: TLabel;
    CBPSF: TComboBox;
    LMuOptimo: TLabel;
    TBSNR: TTrackBar;
    Label1: TLabel;
    procedure BBCancelClick(Sender: TObject);
   private
    { Private declarations }
   public
    { Public declarations }
  end;

var
  FLLSDeconvolution: TFLLSDeconvolution;

implementation

{$R *.dfm}

procedure TFLLSDeconvolution.BBCancelClick(Sender: TObject);
begin
Close;
end;

end.
