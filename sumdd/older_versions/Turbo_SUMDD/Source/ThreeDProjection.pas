unit ThreeDProjection;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls,  ComCtrls, StdCtrls, Buttons,
  //opengl12,
  dglOpenGL,
  DecTypes,
  Bmp2tiff,
  Menus,
  ExtDlgs;

type
  TF3DProjection = class(TForm)
    PTools: TPanel;
    BBUpDate: TBitBtn;
    EXYScale: TEdit;
    LScale: TLabel;
    EZScale: TEdit;
    Label1: TLabel;
    LAngX: TLabel;
    LAngY: TLabel;
    EAngX: TEdit;
    EAngY: TEdit;
    CBR: TCheckBox;
    CBG: TCheckBox;
    CBB: TCheckBox;
    Timer1: TTimer;
    BBStartStop: TBitBtn;
    CBMIP: TCheckBox;
    CBDistance: TCheckBox;
    TBDistance: TTrackBar;
    GBCoordinates: TGroupBox;
    CBCube: TCheckBox;
    CBAxis: TCheckBox;
    MMenu: TMainMenu;
    MFile: TMenuItem;
    MFSaveImg: TMenuItem;
    SPD3DProjection: TSaveDialog;
    MFSaveAnimation: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure FormResize(Sender: TObject);
    procedure BBUpDateClick(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure BBStartStopClick(Sender: TObject);
    procedure CBDistanceClick(Sender: TObject);
    procedure TBDistanceChange(Sender: TObject);
    procedure CBMIPClick(Sender: TObject);
    procedure CBRClick(Sender: TObject);
    procedure CBGClick(Sender: TObject);
    procedure CBBClick(Sender: TObject);
    procedure InitData;
    procedure MakeCube;//Hace un cubo para ubicación espacial
    procedure MakeAxis;//Hace ejes para ubicación espacial
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure CBCubeClick(Sender: TObject);
    procedure CBAxisClick(Sender: TObject);
    procedure MFSaveImgClick(Sender: TObject);
    procedure ScreenShot(activeWindow: bool; destBitmap : TBitmap) ;
    procedure MFSaveAnimationClick(Sender: TObject);
    function  InitLibOpenGL:boolean;

  private
    { Private declarations }
  public

    Volume:TRawData;

    XDim,YDim,ZDim:Integer;
    { Public declarations }
    VColor:T3DColorVector;
    VDeconvColor:T3DColorVector;
    VVertex: T3DVectorVertex;
    VDeconvVertex: T3DVectorVertex;
    RC:HGLRC;
    // Rendering Context
    //DC  : HDC;
    hp:HPalette;
    AngX,AngY:GLInt;
    FZScale,FXYScale:Single;
    W1,W2,H1,H2,Distance,dx,dy,xs,xf,ys,yf:Integer;
    alpha:Real;
    IsOpenGLLoaded:boolean;

  end;



//var
//  F3DProjection: TF3DProjection;
//  RC:HGLRC;
    // Rendering Context
//  dc  : HDC;

 // AngX,AngY:GLInt;
 // FZScale,FXYScale:Single;
 // W1,W2,H1,H2,Distance,dx,dy,xs,xf,ys,yf:Integer;
 // alpha:Real;

implementation

{$R *.dfm}

procedure TF3DProjection.FormCreate(Sender: TObject);

begin
 AngX:=45;
 AngY:=45;
 FXYScale:=1;
 FZScale:=1;
 Distance:=30;
 W1:=Self.Width;
 H1:=Self.Height;
 W2:=W1;
 H2:=H2;
 end;
function TF3DProjection.InitLibOpenGL:boolean;
 begin
  //if InitOpenGL then
   //begin

    IsOpenGLLoaded:=False;
    try
     RC:=CreateRenderingContext(Canvas.Handle,[opDoubleBuffered],32,0,0,0,0,hp); //Primero
    finally
     ActivateRenderingContext(Canvas.Handle,RC);
     glClearColor(0,0,0,0);
     glViewport(0,0, Self.Width,Self.Height);
     glMatrixMode(GL_PROJECTION);
     glLoadIdentity;
     glOrtho(-1.25,1.25,-1.25,1.25,-1.25,1.25);
     glMatrixMode(GL_MODELVIEW);
     glLoadIdentity;
     glEnable(GL_POINT_SMOOTH);
     glHint(GL_POINT_SMOOTH_HINT,GL_NICEST);
     DeactivateRenderingContext;
     IsOpenGLLoaded:=True;
    end;
  //else
   if not IsOpenGLLoaded then    MessageDlg('No fue posible iniciar OpenGL',mtInformation, [mbOk], 0);
   result:=IsOpenGLLoaded;
 end;
procedure TF3DProjection.FormPaint(Sender: TObject);
var
 Save_Cursor:TCursor;
begin
 Save_Cursor:=Screen.Cursor;
 Screen.Cursor:=crHourGlass;
 ActivateRenderingContext(Canvas.Handle,RC); // Se asocia el contexto con el
 glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
// glMatrixMode(GL_MODELVIEW);
 if not (VColor = nil) then
  begin
   glLoadIdentity;
   //glTranslatef(-1,0,0);
   glRotatef(AngX,1,0,0);
   glRotatef(AngY,0,1,0);
   glPushMatrix();
   glScalef(FXYScale, FXYScale, FZScale);
   glColorMask(CBR.Checked,CBG.Checked,CBB.Checked,True);
   glVertexPointer(3,GL_FLOAT,0,VVertex);
   glColorPointer(3,GL_UNSIGNED_BYTE,0,VColor);
   //GLPointSize(0.5*FXYScale); // Tamaño pixeles para cada punto.
   glDrawArrays(GL_POINTS,1,Length(VVertex)-1);
   glPopMatrix();

  end;
 if CBCube.Checked then MakeCube;
 if CBAxis.Checked then MakeAxis;

 glFlush;
 SwapBuffers(Canvas.Handle); //
 UpdateWindow(Canvas.Handle);
 DeactivateRenderingContext; //Libera el contexto.
 Screen.Cursor:=Save_Cursor;

end;
procedure TF3DProjection.WMEraseBkgnd(var Message: TWMEraseBkgnd);
 begin
  Message.Result:=1;
end;

procedure TF3DProjection.FormDestroy(Sender: TObject);
 begin
  if IsOpenGLLoaded then
   begin
    ActivateRenderingContext(Canvas.Handle,RC);
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_COLOR_ARRAY);
    DeactivateRenderingContext;
    DestroyRenderingContext(RC);
   end;
  VColor:=nil;
// VDeconvColor:=nil;
  VVertex:=nil;
//  VDeconvVertex:=nil;
  CBDistance.Checked:=False;
  CBMIP.Checked:=False;
 end;
procedure TF3DProjection.FormResize(Sender: TObject);
 begin
 if IsOpenGLLoaded then
  begin
   ActivateRenderingContext(Canvas.Handle,RC);
   glViewport(0,0, Self.Width,Self.Height);
   glMatrixMode(GL_PROJECTION);
   glLoadIdentity;
   glOrtho(-1.25,1.25,-1.25,1.25,-1.25,1.25);
   glMatrixMode(GL_MODELVIEW);
   glLoadIdentity;
   DeactivateRenderingContext;
   Refresh; // Redibujar la escena ...
  end;
 end;
procedure TF3DProjection.BBUpDateClick(Sender: TObject);
 begin
  try
   FXYScale:=StrToCurr(EXYScale.Text);
   FZScale:=StrToCurr(EZScale.Text);
  except
   on E: EConvertError do
    begin
      MessageDlg(E.Message,mtError, [mbOk], 0);
      exit;
    end;
  end;
  AngX:=StrToInt(EAngX.Text);
  AngY:=StrToInt(EAngY.Text);
  Distance:= TBDistance.Position;
  Refresh;
 end;
procedure TF3DProjection.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
 begin
  xs:=X;
  ys:=Y;
 end;
procedure TF3DProjection.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
 begin
//  dx:=xs-X;
//  dy:=ys-Y;
//  AngX:=AngX+dy;
 // Angy:=Angy+dx;

  AngX:=Y-ys;
  AngY:=X-xs;
  refresh;
 end;
procedure TF3DProjection.Timer1Timer(Sender: TObject);
 begin
  inc(AngY,4);
  AngY:=AngY mod 360;
  refresh;
 end;

procedure TF3DProjection.BBStartStopClick(Sender: TObject);
begin

if BBStartStop.Caption='Parar' then
 begin
  Timer1.Enabled:=False;
  BBStartStop.Caption:='Comenzar';
  Refresh;
  exit;
 end;

if BBStartStop.Caption='Comenzar' then
 begin
  BBStartStop.Caption:='Parar';
  Refresh;
  Timer1.Enabled:=True;
  exit;
 end;
 Application.ProcessMessages;
end;

procedure TF3DProjection.CBDistanceClick(Sender: TObject);

begin

if CBDistance.Checked then TBDistance.Enabled:=True
 else TBDistance.Enabled:=False;
ActivateRenderingContext(Canvas.Handle,RC);
if CBDistance.Checked then
 begin
  glEnable(GL_FOG);
  glEnable(GL_DEPTH_TEST);
  Self.TBDistanceChange(Self);
 end
else
 begin
  glDisable(GL_FOG);
  glDisable(GL_DEPTH_TEST);
 end;
DeactivateRenderingContext;
Refresh;
end;

procedure TF3DProjection.TBDistanceChange(Sender: TObject);
begin

Distance:=TBDistance.Position;
ActivateRenderingContext(Canvas.Handle,RC);
 glFogi(GL_FOG_MODE,GL_LINEAR);
 glFogf(GL_FOG_COLOR,0.5);
 glFogf (GL_FOG_DENSITY,0.25);
 glHint (GL_FOG_HINT, GL_FASTEST);
 glFogf (GL_FOG_START,1);
 glFogf(GL_FOG_END,1-(Distance/100));
DeactivateRenderingContext;
Refresh;
end;

procedure TF3DProjection.CBMIPClick(Sender: TObject);
begin
 ActivateRenderingContext(Canvas.Handle,RC); // Se asocia el contexto con el
 If CBMIP.Checked then
  begin
   glEnable(GL_BLEND);
   glBlendEquation(GL_MAX); //Maximum intensity projection
   //glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);// Over Operator
   //glBlendFunc(GL_CONSTANT_ALPHA_EXT, GL_ONE);// Atenuation
   //glBlendColorEXT(1.0, 1.0, 1.0, 1.0/16); // Attenuation
   //glBlendFunc(GL_ONE_MINUS_DST_COLOR, GL_DST_COLOR); // Under Operator (an aproximation)
  end
 else
  begin
   glDisable(GL_BLEND);
  end;
 DeactivateRenderingContext;
 Refresh;
end;

procedure TF3DProjection.CBRClick(Sender: TObject);
 begin
  Refresh;
 end;

procedure TF3DProjection.CBGClick(Sender: TObject);
 begin
  Refresh;
 end;

procedure TF3DProjection.CBBClick(Sender: TObject);
 begin
  Refresh;
 end;

procedure TF3DProjection.InitData;
 begin
  ActivateRenderingContext(Canvas.Handle,RC);
   glEnableClientState(GL_VERTEX_ARRAY);
   glEnableClientState(GL_COLOR_ARRAY);
  DeactivateRenderingContext;
 end;
procedure TF3DProjection.FormMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
if (Shift=[ssLeft]) then
 begin
  AngX:=Y-ys;
  AngY:=X-xs;
  refresh;
  EAngY.Text:=IntToStr(AngY);
  EAngX.Text:=IntToStr(AngX);
 end
end;
procedure TF3DProjection.MakeCube;
 begin
   glColorMask(True,True,True,True);
   glColor4f(1,0,0,0);
   glBegin(GL_LINES);
    //Eje Z
    glVertex3f(0.5,0.5,-0.5);
    glVertex3f(0.5,0.5,0.5);

    glVertex3f(-0.5,0.5,-0.5);
    glVertex3f(-0.5,0.5,0.5);

    glVertex3f(-0.5,-0.5,-0.5);
    glVertex3f(-0.5,-0.5,0.5);

    glVertex3f(0.5,-0.5,-0.5);
    glVertex3f(0.5,-0.5,0.5);

    //Eje X
    glColor4f(0,1,0,0);
    glVertex3f(-0.5,0.5,0.5);
    glVertex3f(0.5,0.5,0.5);

    glVertex3f(-0.5,0.5,-0.5);
    glVertex3f(0.5,0.5,-0.5);

    glVertex3f(-0.5,-0.5,-0.5);
    glVertex3f(0.5,-0.5,-0.5);

    glVertex3f(-0.5,-0.5,0.5);
    glVertex3f(0.5,-0.5,0.5);

    //Eje Y
    glColor4f(0,0,1,0);
    glVertex3f(0.5,-0.5,0.5);
    glVertex3f(0.5,0.5,0.5);

    glVertex3f(-0.5,-0.5,0.5);
    glVertex3f(-0.5,0.5,0.5);

    glVertex3f(-0.5,-0.5,-0.5);
    glVertex3f(-0.5,0.5,-0.5);

    glVertex3f(0.5,-0.5,-0.5);
    glVertex3f(0.5,0.5,-0.5);
   glEnd();
 end;

procedure TF3DProjection.MakeAxis;
 begin

   glColorMask(True,True,True,True);
   glColor4f(1,0,0,0);
   glBegin(GL_LINES);
    //Eje Z
    glVertex3f(0,0,-0.5);
    glVertex3f(0,0,0.5);

    //Eje X
    glColor4f(0,1,0,0);
    glVertex3f(-0.5,0,0);
    glVertex3f(0.5,0,0);

    //Eje Y
    glColor4f(0,0,1,0);
    glVertex3f(0,-0.5,0);
    glVertex3f(0,0.5,0);
   glEnd();
 end;

procedure TF3DProjection.CBCubeClick(Sender: TObject);
begin
Refresh;
end;

procedure TF3DProjection.CBAxisClick(Sender: TObject);
begin
Refresh;
end;

procedure TF3DProjection.MFSaveImgClick(Sender: TObject);

var
 b:TBitmap;
begin
 MFile.Visible:=false;
 PTools.Visible:=False;
 b := TBitmap.Create;
 try
  Refresh;
  ScreenShot(TRUE, b);
 finally
  If SPD3DProjection.Execute then WriteTiffToFile(ChangeFileExT(SPD3DProjection.FileName,'.tif'),b);
 end;

  b.FreeImage;
  FreeAndNil(b);
  MFile.Visible:=true;
  PTools.Visible:=True;
end;

procedure TF3DProjection.ScreenShot(activeWindow: bool; destBitmap : TBitmap) ;
var
   l,t,w,h : integer;
   DC_Desk : HDC;
   hDesk: Cardinal;
begin
 if activeWindow then
  begin
   hDesk := GetDesktopWindow;
   DC_Desk := GetWindowDC(hDesk) ;
   l:=ClientOrigin.X; // origen
   t:=ClientOrigin.Y;// origen
   w := ClientWidth-BorderWidth;
   h := ClientHeight-PTools.Height;
   try
    destBitmap.Width := w;
    destBitmap.Height := h;
    BitBlt(destBitmap.Canvas.Handle,
           0,
           0,
           destBitmap.Width,
           destBitmap.Height,
           DC_Desk,
           l,
           t,
           SRCCOPY) ;
   finally
   ReleaseDC(hDesk, DC_Desk) ;

   end;

  end;
 end;
procedure TF3DProjection.MFSaveAnimationClick(Sender: TObject);
var
  b:TBitmap;
  Contador,AngIni:Integer;
  FName:string;
 begin
  MFile.Visible:=false;
  PTools.Visible:=False;
  b := TBitmap.Create;
  AngIni:=AngY;
  Contador:=0;
If SPD3DProjection.Execute then
 begin
  FName:=SPD3DProjection.FileName;
  Self.BringToFront;  
  repeat
   try
    inc(AngY,4);
    AngY:=AngY mod 360;
    Refresh;
    Inc(Contador,1);
    ScreenShot(TRUE, b);
   finally
    b.SaveToFile(ChangeFileExt(FNAme + IntToStr(Contador),'.bmp'));
   end;
  until (AngY=AngIni);
  end;
  b.FreeImage;
  FreeAndNil(b);
  MFile.Visible:=true;
  PTools.Visible:=True;
end;

end.
