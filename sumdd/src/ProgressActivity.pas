unit ProgressActivity;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, ExtCtrls;

type
  TFActivityProgress = class(TForm)
    Panel1: TPanel;
    PBActivityProgress: TProgressBar;
    LProgress: TLabel;
    BBProcessCancel: TBitBtn;
    procedure BBProcessCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FActivityProgress: TFActivityProgress;

implementation

{$R *.dfm}


procedure TFActivityProgress.BBProcessCancelClick(Sender: TObject);
 begin
  close;
 end;

end.







