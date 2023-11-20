unit TemperatureControl;

interface

uses
  CameraControl, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, Menus;
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

      { Public declarations }
  end;



var
  FTemperatureControl: TFTemperatureControl;
  Roll:Integer;
  Sum, ActualTemp:Double;
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

  Cam.SetTargetTemperature(T);
  ActualTemp:=Cam.GetTemperature;
  Timer1.Enabled:=true;
end;

procedure TFTemperatureControl.Timer1Timer(Sender: TObject);

var
 TempStatus:ShortString;
begin
 with Cam do
  begin
   TempStatus:= GetControlTemperatureStatus;
   if Roll = 16 then
    begin
     Sum:=Sum/16;
     ActualTemp:=Sum;

     ESenseTemperature.Text:=FormatFloat('0.00',Sum);
     //TempStatus:= GetControlTemperatureStatus;
     Sum:=GetTemperature;
     Roll:=1;
    end
   else
    begin
     if (ActualTemp - ReadTargetTemperature <= 3) and
         ((TempStatus = 'Refrigerando') or (TempStatus = 'Corrigiendo')
          or (TempStatus = 'A Temperatura Deseada')) then
      begin
       EStatus.Color:=clSkyBlue;
       EStatus.Font.Color:=clBlack;
       EStatus.Text:='Cámara Refrigerada';
      end
     else
      begin
       if (TempStatus = 'Apagado') then
        begin
         EStatus.Color:=clSilver;
         EStatus.Font.Color:=clBlue;
         EStatus.Text:='Apagado';
        end;
       if (ActualTemp < 5) and (TempStatus = 'Hacia Temperatura Ambiente') or
           (TempStatus = 'A Temperatura Ambiente') then
        begin
         if Roll<= 7 then
          begin
           EStatus.Color:=clSilver;
           EStatus.Font.Color:=clBlue;
          end
         else
          begin
           EStatus.Color:=clSkyBlue;
           EStatus.Font.Color:=clBlack;
          end;
         EStatus.Text:='Hacia Temperatura Ambiente';
        end;

        if (TempStatus = 'Refrigerando') then
         begin
          if Roll <=7 then
           begin
            EStatus.Color:=clSkyBlue;
            EStatus.Font.Color:=clBlack;
           end
          else
           begin
            EStatus.Color:=clSilver;
            EStatus.Font.Color:=clBlue;
           end;
          EStatus.Text:='Refrigerando';
         end;

       if (ActualTemp > 5) and (TempStatus = 'Hacia Temperatura Ambiente') or
           (TempStatus = 'A Temperatura Ambiente') then
         begin
          EStatus.Color:=clSilver;
          EStatus.Font.Color:=clBlue;
          EStatus.Text:='A Temperatura Ambiente';
         end;

      end; // End else
//     EStatus.Text:=AM4TControl.GetControlTemperatureStatus;
     Sum:=Sum+Cam.GetTemperature;
     Roll:=Roll+1;
    end; // End Else
   end; //end With
end;

procedure TFTemperatureControl.FormCreate(Sender: TObject);
begin
 Roll:=1;
end;

procedure TFTemperatureControl.BBCancelClick(Sender: TObject);
begin

if (Cam.GetControlTemperatureStatus='Apagado') or
 (Cam.GetControlTemperatureStatus='A Temperatura Ambiente') then
 begin
  Cam.TemperatureControlOff;
  Close;
 end
else
 if Application.MessageBox('¿Está seguro que desea cancelar'
             + #13 + ' el Control de Temperatura?', 'Antención', MB_YESNO)=IDYes then
  begin
   Cam.TemperatureControlOff;
   Close;
  end;

end;

procedure TFTemperatureControl.BBAmbientTemperatureClick(Sender: TObject);
begin
{if AM4TControl.GetControlTemperatureStatus = 'Apagado' then
 begin
  MessageDlg('El control de Temperatura'+#13+'está apagado',mtInformation, [mbOk], 0);
  Timer1.Enabled:=False;
 end
else
 begin}
  Cam.GoToAmbient;

  Timer1.Enabled:=True;
// end; 
end;

end.
