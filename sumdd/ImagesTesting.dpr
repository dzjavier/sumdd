program ImagesTesting;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  variants,
  Images in 'src\Images.pas';

var
img_var1,img_var2:OleVariant;
p_variant_array:Pointer;
img: CCDImage;
size_img_var:array[0..3] of Integer;
c,I,J:integer;
begin
  { TODO -oUser -cConsole Main : Insert code here }
  Writeln('-------------------');
  Writeln('Olevariant creation');
  Writeln('-------------------');

  // setlength(size_img_var,4);
  size_img_var[0]:=0;
  size_img_var[1]:=10;
  size_img_var[2]:=0;
  size_img_var[3]:=10;

  img_var1:=  VarArrayCreate(size_img_var,varWord);
  varasc
  img_var2:=  VarArrayCreate(size_img_var,varWord);
  for i := 0 to size_img_var[1] - 1 do
    for j := 0 to size_img_var[3] - 1 do
    begin
      img_var1[i,j]:=i+j;
      img_var2[i,j]:=2 ;
     end;
     vararray
  img_var1:=img_var1+img_var2;
  Writeln('-------------------');
  Writeln('Assign variant to image and read data element-by-element from image');
  Writeln('-------------------');

  img:=CCDImage.Create;
  img.setImageFromVariant(img_var1);
  for i := 0 to img.getRowNumber - 1 do
  begin
    for j := 0 to img.getColumnNumber - 1 do
    begin
       write(img.getPixel(i,j),' ');
    end;
    write(#10);
  end;
  readln;

end.
