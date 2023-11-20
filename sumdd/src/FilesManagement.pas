unit FilesManagement;


interface
uses
 LibTiffDelphi,SysUtils,
 Images,
 DecTypes;
 type
  Filer = class

   public

    procedure Save14BitsTIFFFile(const FileName:String;
                                 const DataOrder: AnsiString; //Formato XYCZT
                                 const Xres, Yres, Zres:double;  //pixeles  por cm
                                 const Timelapse: Single; //[s]
                                 const Channel: Word;
                                 const Xsize, Ysize, Zsize, Csize, Tsize: Word;
                                 const Data: array of Word;
                                 const Page: integer);overload;

    procedure Save14BitsTIFFFile(const file_name:String;
                                   const page: integer;
                                   const image_to_save: MicroscopeDigitalImage);overload;

    procedure Open14BitsTIFFFile( const FileName:String;
                                  var Xres, Yres:single;
                                  const Width, Height: Word;
                                  var Data: array of Word);

 end;
 var
  TiffFiler:Filer;
implementation

procedure Filer.Save14BitsTIFFFile(const FileName:String;
                                 const DataOrder: AnsiString; //Formato XYCZT
                                 const Xres, Yres, Zres:double;  //pixeles  por cm
                                 const Timelapse: Single; //[s]
                                 const Channel: Word; //TODO: DEFINIR CARACTERISTICAS
                                 const Xsize, Ysize, Zsize, Csize, Tsize: Word;

                                 const Data: array of Word;
                                 const Page: integer               //TODO: agregar resto de metadata
                               );
 var
  TiffFileWriter:PTIFF;

 begin

   if Page=0 then  //crea el archivo
    TiffFileWriter := TIFFOPEN(ChangeFileExt(FileName,'.tif'),'w')

   else
    TiffFileWriter := TIFFOPEN(ChangeFileExt(FileName,'.tif'),'a');  //para continuar un tiff multipagina


   //Tiff tags requeridos.
   TIFFSetField(TiffFileWriter,TIFFTAG_IMAGEWIDTH, Xsize);
   TIFFSetField(TiffFileWriter,TIFFTAG_IMAGELENGTH, Ysize);
   TIFFSetField(TiffFileWriter,TIFFTAG_BITSPERSAMPLE, 16);
   TIFFSetField(TiffFileWriter,TIFFTAG_COMPRESSION, COMPRESSION_NONE);

   TIFFSetField(TiffFileWriter,TIFFTAG_PHOTOMETRIC,PHOTOMETRIC_MINISBLACK  );
   TIFFSetField(TiffFileWriter,TIFFTAG_SAMPLESPERPIXEL, 1);
   TIFFSetField(TiffFileWriter,TIFFTAG_ROWSPERSTRIP,Ysize);

   TIFFSetField(TiffFileWriter,TIFFTAG_XRESOLUTION,Xres);
   TIFFSetField(TiffFileWriter,TIFFTAG_YRESOLUTION,Yres);
   TIFFSetField(TiffFileWriter,TIFFTAG_RESOLUTIONUNIT,RESUNIT_CENTIMETER);

   TIFFSetField(TiffFileWriter,TIFFTAG_FILLORDER,FILLORDER_MSB2LSB);// tag 10A
   TIFFSetField(TiffFileWriter,TIFFTAG_PLANARCONFIG,PLANARCONFIG_CONTIG); // tag 11C
   TIFFSetField(TiffFileWriter,TIFFTAG_ORIENTATION,ORIENTATION_TOPLEFT);  //tag 113

   TIFFWriteEncodedStrip(TiffFileWriter, 0, @Data[0], 2*(Xsize*Ysize));

   TIFFClose(TiffFileWriter);

 end;

procedure Filer.Open14BitsTIFFFile( const FileName:String;
                                  var Xres, Yres:single;
                                  const Width, Height: Word;
                                  var Data: array of Word);
var
 MaxVal:integer;  // Maximum sample value
 MinVal: integer; // Minimum sample value
 rs:cardinal;     // Row per strip
 TiffFileReader:PTIFF;
begin

  TiffFileReader := TIFFOPEN(FileName,'r');
   TIFFGetField(TiffFileReader,TIFFTAG_IMAGEWIDTH, Width); // tag 100
   TIFFGetField(TiffFileReader,TIFFTAG_IMAGELENGTH, Height); // tag 101
//  TIFFGetField(TiffFileReader,TIFFTAG_BITSPERSAMPLE, b); // tag 102
   TIFFGetField(TiffFileReader,TIFFTAG_ROWSPERSTRIP,rs); // tag 116
   TIFFGetField(TiffFileReader,TIFFTAG_XRESOLUTION,xres); // tag 11A
   TIFFGetField(TiffFileReader,TIFFTAG_YRESOLUTION,yres); // tag 11B
   TIFFGetField(TiffFileReader,TIFFTAG_RESOLUTIONUNIT,RESUNIT_CENTIMETER); // tag 128
   TIFFGetField(TiffFileReader,TIFFTAG_MINSAMPLEVALUE,MinVal); // tag 154
   TIFFGetField(TiffFileReader,TIFFTAG_MAXSAMPLEVALUE,MaxVal);// tag 155
   TIFFReadEncodedStrip(TiffFileReader, 0, @Data[0], 2*(Width*Height));
  TIFFClose(TiffFileReader);


end;
procedure Filer.Save14BitsTIFFFile(const file_name:String;
                                   const page: integer;
                                   const image_to_save: MicroscopeDigitalImage);

 var
  TiffFileWriter:PTIFF;
  Data:TWordArray;
  XSize,YSize:Word;
 begin
   if Page=0 then  //crea el archivo
    begin
      TiffFileWriter := TIFFOPEN(ChangeFileExt(file_name,'.test.tif.'),'w');
    end
   else
    begin
     TiffFileWriter := TIFFOPEN(ChangeFileExt(file_name,'.test.tif'),'a');  //para continuar un tiff multipagina
    end;
   XSize:=image_to_save.getColumnNumber;
   YSize:=image_to_save.getRowNumber;
   TIFFSetField(TiffFileWriter,TIFFTAG_IMAGEDESCRIPTION,image_to_save.getMetadata_asAnsiString);  //tag 113
   //Tiff tags requeridos.
   TIFFSetField(TiffFileWriter,TIFFTAG_IMAGEWIDTH,XSize);
   TIFFSetField(TiffFileWriter,TIFFTAG_IMAGELENGTH, YSize);
   TIFFSetField(TiffFileWriter,TIFFTAG_BITSPERSAMPLE, 16);
   TIFFSetField(TiffFileWriter,TIFFTAG_COMPRESSION, COMPRESSION_NONE);

   TIFFSetField(TiffFileWriter,TIFFTAG_PHOTOMETRIC,PHOTOMETRIC_MINISBLACK  );
   TIFFSetField(TiffFileWriter,TIFFTAG_SAMPLESPERPIXEL, 1);
   TIFFSetField(TiffFileWriter,TIFFTAG_ROWSPERSTRIP,image_to_save.getRowNumber);

   //    TIFFSetField(TiffFileWriter,TIFFTAG_XRESOLUTION,Xres);
   //    TIFFSetField(TiffFileWriter,TIFFTAG_YRESOLUTION,Yres);
   //    TIFFSetField(TiffFileWriter,TIFFTAG_RESOLUTIONUNIT,RESUNIT_CENTIMETER);

   TIFFSetField(TiffFileWriter,TIFFTAG_FILLORDER,FILLORDER_MSB2LSB);// tag 10A
   TIFFSetField(TiffFileWriter,TIFFTAG_PLANARCONFIG,PLANARCONFIG_CONTIG); // tag 11C
   TIFFSetField(TiffFileWriter,TIFFTAG_ORIENTATION,ORIENTATION_TOPLEFT);  //tag 113
   Data:=image_to_save.getImageAsArray;
   TIFFWriteEncodedStrip(TiffFileWriter, 0, @Data[0], 2*(XSize*YSize));

   TIFFClose(TiffFileWriter);

 end;

end.
