unit ControlOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons;

type
  TFControlOptions = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    CBPortDir: TComboBox;
    BBApply: TBitBtn;
    BBCancelar: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FControlOptions: TFControlOptions;

implementation

{$R *.dfm}

end.
