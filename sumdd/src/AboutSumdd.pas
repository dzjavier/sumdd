unit AboutSumdd;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TAboutBox = class(TForm)
    Panel1: TPanel;
    ProgramIcon: TImage;
    ProductName: TLabel;
    Version: TLabel;
    Copyright: TLabel;
    Comments: TLabel;
    OKButton: TButton;
    procedure FormCreate(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutBox: TAboutBox;

implementation

{$R *.dfm}

procedure TAboutBox.FormCreate(Sender: TObject);
begin
 ProductName.Caption:='SUMDD Software para Usuarios   '+ #13+
                      'de Microscopios de Desconvoluci�n';

 CopyRight.Caption:= 'Software desarrollado en el Laboratorio' + #13+
                     'de Microscop�a, y para uso exclusivo ' + #13+
                     'dentro del mismo.           ' + #13+#13+
                     'Facultad de Ingenier�a ' + #13+
                     'Universidad Nacional de Entre R�os.  ' + #13+
                     'Ruta Prov. 11 Km. 10 - Oro Verde    ' + #13+
                     'Dpto. Paran� - Entre R�os - Argentina.';

// Version.Caption:=Version;
end;

procedure TAboutBox.OKButtonClick(Sender: TObject);
begin
close;
end;

end.

