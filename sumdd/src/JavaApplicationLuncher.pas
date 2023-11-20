unit JavaApplicationLuncher;

interface

uses
 Windows,ShellAPI,Dialogs;

type
 JavaAppLuncher = class
  public
   constructor Create(const application_name:string; const args: string);
   procedure run;
   destructor Destroy; override;
  private
   ApplicationName:string;
   ApplicationArguments:string;
   StartInfo : TStartupInfo;
   ProcInfo : TProcessInformation;
   CreateOK : Boolean;
end;
implementation
constructor JavaAppLuncher.Create(const application_name:string; const args: string);
begin
  ApplicationName:=application_name;
  ApplicationArguments:=args;
  FillChar(StartInfo,SizeOf(TStartupInfo),#0); // inicializar todo en cero
  StartInfo.dwFlags:=STARTF_USESHOWWINDOW;
  StartInfo.wShowWindow:=SW_HIDE;
  FillChar(ProcInfo,SizeOf(TProcessInformation),#0);
  StartInfo.cb := SizeOf(TStartupInfo);
end;
procedure JavaAppLuncher.run;
begin
 CreateOK := CreateProcess(nil, PChar('java -jar'+ ' '+ApplicationName + ' ' + ApplicationArguments),nil, nil,False,
              CREATE_NEW_PROCESS_GROUP+NORMAL_PRIORITY_CLASS,
              nil, nil, StartInfo, ProcInfo);
    { check to see if successful }
  if CreateOK then
    begin
// may or may not be needed. Usually wait for child processes
//      if Wait then
        WaitForSingleObject(ProcInfo.hProcess, INFINITE);
    end
  else
    begin
      ShowMessage('No es posible ejecutar la aplicación java');
     end;
end;

destructor JavaAppLuncher.Destroy;
 begin
  CloseHandle(ProcInfo.hProcess);
  CloseHandle(ProcInfo.hThread);
 end;

end.
