unit Images;

interface
 uses
  DecTypes,
  SUMDDMetadata;
//OpenGLDrawables;

 type
//  MicroscopeDigitalImage = class(TInterfacedObject,OGLDrawable)
  MicroscopeDigitalImage = class(TInterfacedObject)
  {Represents a microscope digital registered image with contextual data}
  public
   constructor Create;
   procedure resize(const nR: Word; const nC: Word);
   procedure setPixel(const R: Word; const C: Word; const V: Word);
   function  getPixel(const R: Word; const C: Word):Word;
   function  getRowNumber: Word;
   function  getColumnNumber: Word;
   procedure addMetadata(const m: Metadata);
   function  getMetadata:Metadata;
   function  getMetadata_asAnsiString: AnsiString;
   procedure setImageFromDynamicArray(const img_tword_array:TWordArray;
                                      const nR:Word; const nC:Word);
   function  getImageAsArray: TWordArray;
   procedure  draw;
   destructor Destroy;override;

  private
   img: TWordArray;
   RowNumber:Word;
   ColumnNumber:Word;
   ImageMetadata:Metadata;
end;

implementation
uses
dglOpenGL;

constructor MicroscopeDigitalImage.Create;
 begin
  ImageMetadata:=Metadata.Create();
  ImageMetadata.setString('Software','SUMDD2.0');
  ImageMetadata.setString('PixelsType','uint16');
 end;

procedure MicroscopeDigitalImage.resize(const nR: Word; const nC: Word);
begin
 ColumnNumber:=nC;
 RowNumber:=nR;
 SetLength(img,RowNumber*ColumnNumber);
end;

procedure MicroscopeDigitalImage.setPixel(const R: Word; const C: Word; const V: Word);
begin
 img[R*RowNumber+C]:=V;
end;

function MicroscopeDigitalImage.getPixel(const R: Word; const C: Word):Word;
begin
 result:= img[R*RowNumber+C];
end;

function  MicroscopeDigitalImage.getRowNumber: Word;
begin
 result:=RowNumber;
end;

function  MicroscopeDigitalImage.getColumnNumber: Word;
begin
 result:=ColumnNumber;
end;
procedure MicroscopeDigitalImage.addMetadata(const m: Metadata);
begin
 ImageMetadata.addMetadata(m);
end;
function  MicroscopeDigitalImage.getMetadata:Metadata;
begin
 result:=ImageMetadata;
end;

function  MicroscopeDigitalImage.getMetadata_asAnsiString: AnsiString;
begin
  Result:=ImageMetadata.getAllMetadata;
end;

procedure MicroscopeDigitalImage.setImageFromDynamicArray(const img_tword_array:TWordArray;
                                      const nR:Word; const nC:Word);
begin
  resize(nR,nC);
  img:=img_tword_array;
end;                                      

function MicroscopeDigitalImage.getImageAsArray: TWordArray;
begin
  result:=img;
end;
destructor MicroscopeDigitalImage.Destroy;
begin
 ImageMetadata.Destroy;
end;

procedure MicroscopeDigitalImage.draw;
var
 maximum,i,j:integer;
 data_to_draw: TFloatArray;
begin
 setlength(data_to_draw,length(img));
 maximum:=MaxWordValue(img);
 for i:=low(img) to high(img) do
  data_to_draw[i]:=img[i]/maximum;
  glPixelZoom(0.5,0.5);
 glDrawPixels(getColumnNumber,getRowNumber,GL_LUMINANCE,GL_FLOAT,@data_to_draw[0]);
{ glBegin(GL_POINTS);
  glDisableClientState(GL_VERTEX_ARRAY);
 for i:=0 to getRowNumber-1 do
  for j:=0 to getColumnNumber-1 do
  begin
   glColor3f(getPixel(i+1,j+1)/maximum,getPixel(i+1,j+1)/maximum,getPixel(i+1,j+1)/maximum);
   glVertex2f(i/getRowNumber,j/getColumnNumber);
   end;
 glEnd();}

end;

end.
