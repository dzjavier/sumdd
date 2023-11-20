program Project1;

uses
  Forms,
  OpenGLRenderer in 'OpenGLRenderer.pas' {Form1},
  OpenGLDrawables in 'OpenGLDrawables.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
