unit SectionView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GR32,GR32_Image, StdCtrls, ExtCtrls,GR32_Layers;

type
  TFViewSection = class(TForm)
    PInfo: TPanel;
    EXY: TEdit;
    LXY: TLabel;
    EIntRaw: TEdit;
    EIntDeconv: TEdit;
    LIntRaw: TLabel;
    LIntDeconv: TLabel;
    PData: TPanel;
    PTransformations: TPanel;
    LScale: TLabel;
    EScale: TEdit;
    Panel1: TPanel;
    BUpDate: TButton;
    ImViewLayerRaw: TImgView32;
    ImViewLayerDeconv: TImgView32;
    LTotalMagnification: TLabel;
    EMagnification: TEdit;
    procedure ImViewLayerDeconvMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
    procedure ImViewLayerRawMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer; Layer: TCustomLayer);
    procedure BUpDateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
   FScale:Single; // Factor de escala
   MT:Double; // Magnificación
    { Public declarations }
  end;

var
 FViewSection: TFViewSection;
implementation

{$R *.dfm}

procedure TFViewSection.ImViewLayerDeconvMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
begin
 EXY.Text:= '['+ formatfloat('#.#',9*X/(FScale*MT))+', '+formatfloat('#.#',9*Y/(FScale*MT))+']';
 EIntDeconv.Text:= inttostr(intensity(ImViewLayerDeconv.Bitmap.PixelS[trunc(X/FScale),trunc(Y/FScale)]));
 if not(ImViewLayerRaw.Bitmap.Empty) then
   EIntRaw.Text:= inttostr(intensity(ImViewLayerRaw.Bitmap.PixelS[trunc(X/FScale),trunc(Y/FScale)]));
end;

procedure TFViewSection.ImViewLayerRawMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
begin
 EXY.Text:= '['+ formatfloat('#.#',9*X/(FScale*MT))+', '+formatfloat('#.#',9*Y/(FScale*MT))+']';
 EIntRaw.Text:= inttostr(intensity(ImViewLayerRaw.Bitmap.PixelS[trunc(X/FScale),trunc(Y/FScale)]));
  if not(ImViewLayerDeconv.Bitmap.Empty) then
   EIntDeconv.Text:= inttostr(intensity(ImViewLayerDeconv.Bitmap.PixelS[trunc(X/FScale),trunc(Y/FScale)]));
end;

procedure TFViewSection.BUpDateClick(Sender: TObject);
begin
FScale:=StrToFloat(EScale.Text);
MT:=StrToFloat(EMagnification.Text);
ImViewLayerDeconv.Scale:=FScale;
ImViewLayerRaw.Scale:=FScale;
end;

procedure TFViewSection.FormCreate(Sender: TObject);
begin
MT:=1;
FScale:=1;
end;

procedure TFViewSection.FormResize(Sender: TObject);
begin
ImViewLayerRaw.Width:=(Self.Width div 2)-6;
ImViewLayerDeconv.Width:=(Self.Width div 2)-6;
ImViewLayerDeconv.Left:=ImViewLayerRaw.Left+ImViewLayerRaw.Width+2;
end;

end.
