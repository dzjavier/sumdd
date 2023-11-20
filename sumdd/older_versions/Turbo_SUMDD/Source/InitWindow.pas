unit InitWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TFInitWindow = class(TForm)
    Timer1: TTimer;
    Label1: TLabel;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FInitWindow: TFInitWindow;
  Alpha:Integer;

implementation

{$R *.dfm}

procedure TFInitWindow.Timer1Timer(Sender: TObject);
begin

Self.AlphaBlendValue:=Alpha;
Refresh;
Alpha:=Alpha-5;
if Alpha<=0 then
 begin
  Timer1.Enabled:=false;
  Close;
 end;

end;

procedure TFInitWindow.FormCreate(Sender: TObject);
begin
Alpha:=255;
Timer1.Enabled:=True;
Label1.Caption:= 'Software desarrollado para uso exclusivo' +#13+
                 'en el Laboratorio de Microscopía, de la' +#13+
                 'de la Facultad de Ingeniería, UNER.' +#13+
                 'Año 2004-2011, Oro Verde,'+#13+
                 'Entre Ríos, Argentina';
end;

end.
