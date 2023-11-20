unit SUMDDMetadata;

interface
uses Classes;
type
   Metadata=class
    public
     constructor Create(const SeparatorChar:AnsiChar='=';
                        const LineBreakChar:AnsiChar=#10);
     procedure setSeparator(const SeparatorChar:AnsiChar);
     procedure setLineBreak(const LineBreakChar:AnsiChar);
     procedure setString(const Key: AnsiString; const Value:AnsiString);
     procedure getString(const Key: AnsiString; var Value:AnsiString);
     procedure addMetadata(const Metadata:Metadata);
     function  getAllMetadata:AnsiString;
     destructor Destroy;override;
    private
     Separator: AnsiChar;
     LineBreak: AnsiChar;
     Data:TStringList;


 end;
implementation
constructor Metadata.Create(const SeparatorChar:AnsiChar='=';
                                      const LineBreakChar:AnsiChar=#10);

begin
Separator:=SeparatorChar;
LineBreak:=LineBreakChar;
//Data:=TStringList.Create;
//Data.LineBreak:=LineBreakChar; problem in D7, OK in BDS
//Data.NameValueSeparator:=Separator;
Data.CaseSensitive:=True;
//Data.Sorted:=true; // Do not use insert, use add
end;
procedure Metadata.setSeparator(const SeparatorChar:AnsiChar);
begin
  Separator:=SeparatorChar;
end;
procedure Metadata.setLineBreak(const LineBreakChar:AnsiChar);
begin
 LineBreak:=LineBreakChar;
end;
procedure Metadata.setString(const Key: AnsiString; const Value:Ansistring);
begin
 Data.Values[Key]:=Value;
end;

procedure Metadata.getString(const Key: AnsiString; var Value:AnsiString);
begin
  Value:=Data.Values[Key];
end;

procedure Metadata.addMetadata(const Metadata:Metadata);
 var
  I:Integer;
 begin
  if Metadata<>nil then
  for I:=0 to Metadata.Data.Count-1 do
   setString(Metadata.Data.Names[I],Metadata.Data.Values[Metadata.Data.Names[I]]);
end;
function  Metadata.getAllMetadata:AnsiString;
var
 I:integer;
 metadata_result:AnsiString;
 key_aux:AnsiString;
 value_aux:AnsiString;
begin
  for I := 0 to Data.Count - 1 do
   begin
    key_aux:=Data.Names[I];
    value_aux:=Data.Values[key_aux];
    metadata_result:=metadata_result+key_aux+Separator+value_aux+LineBreak;
   end;

 Result:=metadata_result;
end;
destructor Metadata.Destroy;
begin
 Data.Free;
end;
end.
