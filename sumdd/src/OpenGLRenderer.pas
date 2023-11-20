unit OpenGLRenderer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls,dglOpengl, StdCtrls;// OpenglDrawables;

type
  TFOGLRenderer = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
//  procedure getDrawbleObject(drawable_obj:OGLDrawable);
//    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;

  private
    { Private declarations }
  //iDrawable:OGLDrawable;

  public

    { Public declarations }
  end;

var
  FOGLRenderer: TFOGLRenderer;
  MyDC:HWND;
  MyRC:HGLRC;
  HP:HPALETTE;

implementation

{$R *.dfm}

procedure TFOGLRenderer.FormCreate(Sender: TObject);
begin
if InitOpenGL then // Don't forget, or first gl-Call will result in an access violation!
begin
 try
  MyRC := CreateRenderingContext(Canvas.Handle,[opDoubleBuffered],32,0,0,0,0,0);
 finally
  ActivateRenderingContext(Canvas.Handle, MyRC); // Necessary, will also read some extension
  glClearColor(0.5,0.5,0,0);
  DeactivateRenderingContext();
 end;
 end;
end;

procedure TFOGLRenderer.FormDestroy(Sender: TObject);
begin
 DeactivateRenderingContext; // Deactivates the current context
 wglDeleteContext(myRC);
 ReleaseDC(MyRC, mydc);
end;

procedure TFOGLRenderer.FormPaint(Sender: TObject);
begin
 ActivateRenderingContext(Canvas.Handle,MyRC);
//  ActivateRenderingContext(MyDC,MyRC);
 glClear(GL_COLOR_BUFFER_BIT );
 glViewport(0,0,ClientWidth,ClientHeight);
 glMatrixMode(GL_PROJECTION);
 glLoadIdentity();
 glOrtho(0,1,0,1,-1,1);
 glMatrixMode(GL_MODELVIEW);
 glLoadIdentity();

//Drawable.draw();
 SwapBuffers(Canvas.Handle);
 DeactivateRenderingContext;

end;



procedure TFOGLRenderer.FormResize(Sender: TObject);
begin
 ActivateRenderingContext(Canvas.Handle,MyRC);
 glViewport(0,0,ClientWidth,ClientHeight);
 glMatrixMode(GL_PROJECTION);
 glLoadIdentity();
 glOrtho(0,1,0,1,-1,-1);
 glMatrixMode(GL_MODELVIEW);
 glLoadIdentity();
 DeactivateRenderingContext();
 Refresh();
end;
//procedure TFOGLRenderer.getDrawbleObject(drawable_obj:OGLDrawable);
//begin
////Drawable:=drawable_obj;
//end;
end.
