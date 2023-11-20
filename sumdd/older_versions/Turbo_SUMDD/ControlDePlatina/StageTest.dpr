program StageTest;

{$APPTYPE CONSOLE}

uses
  SysUtils, Windows,StageControl;

var
 Stg:Stage;
 DeltaZ,Speed:single;
 Control:integer;
 ti,tf:int64;
begin
 Stg:=Stage.Create($378);

 repeat
  writeln('Para salir ingresar 0 (cero)');
  readln(Control);
  if (Control=0) then break;
  writeln('Ingrese el deplazamiento en micrómetros: ');
  readln(DeltaZ);
  writeln('Ingrese velocidad en um/s: ');
  readln(Speed);

  ti:=GetTickCount;
  Stg.Move(DeltaZ,Speed);
  tf:=GetTickCount-ti;
  writeln('Tiempo transcurrido: ', tf, ' ms')
 until Control=0;

Stg.Destroy;
end.
