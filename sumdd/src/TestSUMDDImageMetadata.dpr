program TestSUMDDImageMetadata;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  SUMDDMetadata in 'SUMDDMetadata.pas';
var
 MD: SUMDDImageMetadata;
 value:AnsiString;
 MD2:SUMDDImageMetadata;
begin
  { TODO -oUser -cConsole Main : Insert code here }
  WriteLn('Testing SUMDDImageMetadata');
  MD:=SUMDDImageMetadata.Create('=',#13);
  MD.setString('Nombre','Javier');
  MD.setString('Edad','36');
readln;
  WriteLn('Testing metadata loaded');
  MD.getString('Nombre',Value);
  WriteLn(Value);
  MD.getString('Edad',Value);
  WriteLn(Value);
readln;
  WriteLn('Testing metadata changes');
  MD.setString('Nombre','Lucca');
  MD.setString('Edad','8');
  MD.setString('Profesion','Chamaco');

  MD.getString('Nombre',Value);
  WriteLn(Value);
  MD.getString('Edad',Value);
  WriteLn(Value);
  MD.getString('Profesion',Value);
  WriteLn(Value);

  Write(MD.getAllMetadata);
  readln;

  Writeln('------------------------------');
  Writeln('Prueba de combinar dos objetos');
  MD.setString('Nombre','Santiago');
  MD.setString('Edad','45');
  MD.setString('Profesion','Coordinador de viaje de estudios');
  MD2:=SUMDDImageMetadata.Create();
  MD2.setString('Nombre','cualquiera');
  MD2.setString('talla','xl');
  MD.addMetadata(MD2);
  MD.getString('talla',value);
  WriteLn('talla=',Value);
  MD.getString('Nombre',value);
  WriteLn('Nombre=',Value);

 readln;

end.
