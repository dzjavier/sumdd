unit TestPacthInt3;

interface

implementation

procedure PatchINT3;
var
  NOP : Byte;
  NTDLL: THandle;
  BytesWritten: DWORD;
  Address: Pointer;

begin
  if Win32Platform <> VER_PLATFORM_WIN32_NT then Exit;
  NTDLL := GetModuleHandle('NTDLL.DLL');
  if NTDLL = 0 then Exit;
  Address := GetProcAddress(NTDLL, 'DbgBreakPoint');
  if Address = nil then Exit;
  try
    if Char(Address^) <> #$CC then Exit;

    NOP := $90;
    if WriteProcessMemory(GetCurrentProcess, Address, @NOP, 1, BytesWritten) and
      (BytesWritten = 1) then
      FlushInstructionCache(GetCurrentProcess, Address, 1);
  except
    //Do not panic if you see an EAccessViolation here, it is perfectly harmless!
    on EAccessViolation do ;
    else raise;
  end;
end;

initialization
  PatchInt3;
end.

