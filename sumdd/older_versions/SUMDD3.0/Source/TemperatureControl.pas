unit TemperatureControl;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, Menus,
  Sectioner;
type
  TFTemperatureControl = class(TForm)
    PControlTemperature: TPanel;
    ETTemperature: TEdit;
    LTargetTemperature: TLabel;
    BBSet: TBitBtn;
    BBCancel: TBitBtn;
    Timer1: TTimer;
    ESenseTemperature: TEdit;
    EStatus: TEdit;
    BBAmbientTemperature: TBitBtn;
    LSenseTemperature: TLabel;
    Label1: TLabel;
    procedure BBSetClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BBCancelClick(Sender: TObject);
    procedure BBAmbientTemperatureClick(Sender: TObject);
  private
    { Private declarations }

  public
   procedure GetCamera(Cam:TAM4Control);
    { Public declarations }
  end;



var
  FTemperatureControl: TFTemperatureControl;
  AM4TControl:TAM4Control;
  Roll:Integer;
  Sum:Double;
implementation

{$R *.dfm}

procedure TFTemperatureControl.BBSetClick(Sender: TObject);
var
 T:Double;
begin
  try
   T:=StrToFloat(ETTemperature.Text);
   except
    on E: EConvertError do
     begin
      MessageDlg('Error de Conversión',mtError, [mbOk], 0);
      exit;
     end;
  end;
  AM4TControl.SetTargetTemperature(T);
  Timer1.Enabled:=true;
end;
procedure TFTemperatureControl.GetCamera(Cam:TAM4Control);
 begin
  AM4TControl:=Cam;
  EStatus.Text:=AM4TControl.GetControlTemperatureStatus;
 end;
procedure TFTemperatureControl.Timer1Timer(Sender: TObject);
begin
 if Roll = 16 then
  begin
  Sum:=Sum/16;
  ESenseTemperature.Text:=FormatFloat('0.00',Sum);
  Sum:=AM4TControl.GetTemperature;
  Roll:=1;
  end
  else
   begin
    EStatus.Text:=AM4TControl.GetControlTemperatureStatus;
    Sum:=Sum+AM4TControl.GetTemperature;
    Roll:=Roll+1;
   end;
end;

procedure TFTemperatureControl.FormCreate(Sender: TObject);
begin
 Roll:=1;
end;

procedure TFTemperatureControl.BBCancelClick(Sender: TObject);
begin

if (AM4TControl.GetControlTemperatureStatus='Apagado') or
 (AM4TControl.GetControlTemperatureStatus='A Temperatura Ambiente') then
 begin
  AM4TControl.TemperatureControlOff;
  Close;
 end
else
 if Application.MessageBox('¿Está seguro que desea cancelar'
             + #13 + ' el Control de Temperatura?', 'Antención', MB_YESNO)=IDYes then
  begin
   AM4TControl.TemperatureControlOff;
   Close;
  end;

end;

procedure TFTemperatureControl.BBAmbientTemperatureClick(Sender: TObject);
begin
 AM4TControl.GoToAmbient;
 Timer1.Enabled:=True;
end;

end.
