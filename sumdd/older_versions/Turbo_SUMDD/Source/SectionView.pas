unit SectionView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

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
    LTotalMagnification: TLabel;
    EMagnification: TEdit;
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



procedure TFViewSection.BUpDateClick(Sender: TObject);
begin
FScale:=StrToFloat(EScale.Text);
MT:=StrToFloat(EMagnification.Text);
//ImViewLayerDeconv.Scale:=FScale;
//ImViewLayerRaw.Scale:=FScale;
end;

procedure TFViewSection.FormCreate(Sender: TObject);
begin
MT:=1;
FScale:=1;
end;

procedure TFViewSection.FormResize(Sender: TObject);
begin
//ImViewLayerRaw.Width:=(Self.Width div 2)-6;
//ImViewLayerDeconv.Width:=(Self.Width div 2)-6;
//ImViewLayerDeconv.Left:=ImViewLayerRaw.Left+ImViewLayerRaw.Width+2;
end;

end.
