unit DarkCurrentAdquisition;

interface

uses
  Windows, Messages, SysUtils, Variants, CameraControl,Classes, Graphics, Controls, Forms,
  Dialogs,DecTypes ,StdCtrls, FilesManagement;

type
  TFDarkCurrentAdquisition = class(TForm)
    BAdd2list: TButton;
    LBMacroList: TListBox;
    BDarkCapture: TButton;
    ETexp: TEdit;
    ERep: TEdit;
    EEspera: TEdit;
    Exdim: TEdit;
    Eydim: TEdit;
    EFileName: TEdit;
    BReset: TButton;
    procedure BAdd2listClick(Sender: TObject);
    procedure BDarkCaptureClick(Sender: TObject);
    procedure BResetClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

   type CaptureData = array[0..2] of single;
var
  FDarkCurrentAdquisition: TFDarkCurrentAdquisition;

  CaptureList: array of CaptureData;

implementation

{$R *.dfm}

procedure TFDarkCurrentAdquisition.BAdd2listClick(Sender: TObject);
var
data: CaptureData;

begin

SetLength(CaptureList, Length(CaptureList)+1);

data[0]:=StrToFloat(ETexp.Text);
data[1]:=StrToFloat(ERep.Text);
data[2]:=StrToFloat(EEspera.Text);

CaptureList[Length(CaptureList)-1]:=data;


LBMacroList.AddItem(ETexp.Text+' '+ERep.Text+' '+EEspera.Text,nil);


end;

procedure TFDarkCurrentAdquisition.BDarkCaptureClick(Sender: TObject);
var
i,x,y,repeats,xdim,ydim,counter: integer;
data: CaptureData;
CurrentCapture: DecTypes.TWordArray;
t:Int64;
logfile:textfile;
begin
BDarkCapture.Enabled:=false;
XDim:=StrtoInt(Exdim.Text);
YDim:=StrToInt(EYDim.Text);
counter:=0;
AssignFile(logfile,EFileName.text+'_Log.txt');
Rewrite(logfile);

for i := 0 to Length(CaptureList)-1 do
  begin

   //ejecuta una captura con cada elemento de la lista
   data:=CaptureList[i];

    for repeats := 1 to trunc(data[1]) do
     begin


     /////TEST
 {  SetLength(CurrentCapture,XDIM*ydim);
       for y:=0 to XDIM-1 do
       for x:=0 to XDIM-1 do
           begin
           if x < XDIM/3 then
            CurrentCapture[y*512+x]:= (counter+1)*600;
           if (x > XDIM/3) and (x < 2*512/3) then
           CurrentCapture[y*512+x]:= (counter+1)*100;
           if x > 2*XDIM/3 then
           CurrentCapture[y*512+x]:= (counter+1)*50;
          end;                }
     ////////TEST

      ///captura
     Cam.GetDarkCurrentImage(CurrentCapture,xdim,ydim,data[0]/1000);
     //guarda el archivo
     TiffFiler.Save14BitsTIFFFile(EFileName.Text,'XYTZT',1,1,0,1,0,XDIM,yDIM,1,1,99,CurrentCapture,counter);

 //    if (cam.getControlTemperatureStatus() = 'Apagado')
  //    then
      Writeln(logfile,counter,#9,FormatFloat('#######',data[0]),#9,FormatFloat('###',data[1]),#9,FormatFloat('####',data[2])) ;
  //   else
   //    Writeln(logfile,counter,#9,FormatFloat('#######',data[0]),#9,FormatFloat('###',data[1]),#9,FormatFloat('####',data[2]),#9,Cam.getTemperature);
     //Timer de espera
      t:=GetTickCount;
     repeat
     until (GetTickCount-t) >=data[2];

     counter:=counter+1;
     end;


  end;

SetLength(CaptureList,0);
LBMacroList.Clear();
CloseFile(logfile);

BDarkCapture.Enabled:=true;
end;



procedure TFDarkCurrentAdquisition.BResetClick(Sender: TObject);
begin
 SetLength(CaptureList,0);
LBMacroList.Clear();
end;

end.
