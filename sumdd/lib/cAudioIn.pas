{* -----------------------------------------------------------------------------
  Audio input class definition. Contains methods for acquiring data through a
  wave-mapped device using MCI API.
  Notification is achieved through an event (see OnBufferDone).
  Callback function approach is used, which makes this class independent from
  a window handle.

  @Author Hector Laforcada (HJL)
  @Version v1.0 14-Jun-2008 HJL Initial revision
-------------------------------------------------------------------------------}

unit cAudioIn;

interface

uses
  Windows,  // general constants and types
  MMSystem, // multimedia types and functions
  SysUtils; // conversions

const
  BITS_16 = 16;
  BITS_8  = 8;
  FREQ_6K = 6000;
  FREQ_8K = 8000;
  FREQ_12K = 12000;
  FREQ_22K = 22000;
  FREQ_44K = 44100;
  CHANN_MONO = 1;
  CHANN_STEREO = 2;
  N_SAMPLES_PER_FRAME = 256;

type
  /// Buffer done event proto
  TOnBufferDone = procedure (const Buffer: Pointer; const Size: Integer) Of Object;

  /// Multimedia Exception
  EMMError = class(Exception);

  /// Audio Input manager class
  TAudioIn = class
  private
    fWaveInHandle: HWAVEIN; /// Handle to wave in device

    fWaveFormat : TWaveFormatEx; /// Destination wave format

    flpWaveHdr0  : pWaveHdr; /// Buffer 0 properties
    flpWaveHdr1  : pWaveHdr; /// Buffer 1 properties
    fCurrWaveHdr : pWaveHdr; /// Current buffer properties
    fCurrentBuff : Byte; /// Current buffer index (0..1)

    //fErrorStr : String; /// Error translation

    fOnBufferDone: TOnBufferDone; /// Buffer done event handler
    fRecording: Boolean; /// Recording flag

    fNChannels: Word; /// Number of channels (1=mono, 2=stereo)
    fSamplesPerSec: DWORD;  /// Sampling rate
    fBitsPerSample: Word; /// Number of bits per sample of mono data
    fNSamples: Integer; /// Number of samples in buffer

    procedure SetWaveFormat;
    procedure SetNChannels(const Value: Word);
    procedure SetSamplesPerSec(const Value: DWORD);
    procedure SetBitsPerSample(const Value: Word);

    // Use callback type: CALLBACK_FUNCTION
    // See waveInProc() reference for details
    procedure BufferFinished(const hwi: HWAVEIN;
                             const uMsg: UINT;
                             dwInstance: DWORD;
                             dwParam1: DWORD;
                             dwParam2: DWORD);
  public

    Constructor Create;
    Destructor Destroy; override;

    procedure Open;
    procedure Close;
    procedure Start;
    procedure Stop;

    property Recording: Boolean read fRecording;
    property NChannels: Word read fNChannels write SetNChannels;
    property SamplesPerSec: DWORD read fSamplesPerSec write SetSamplesPerSec;
    property BitsPerSample: Word read fBitsPerSample write SetBitsPerSample;
    property NSamples: Integer read fNSamples write fNSamples;
    property OnBufferDone: TOnBufferDone read fOnBufferDone write fOnBufferDone;

  end; // TAudioIn


implementation

{* -----------------------------------------------------------------------------
  If error code is not MMSYSERR_NOERROR, translate passed error code and raise
  an exception
-------------------------------------------------------------------------------}
procedure TranslateError(const ErrCode: Integer);
var
  ErrorStr: String;
begin
  if (ErrCode <> MMSYSERR_NOERROR) then begin
    SetLength(ErrorStr, MAXERRORLENGTH);
    waveInGetErrorText(ErrCode, pChar(ErrorStr), MAXERRORLENGTH);
    Raise EMMError.Create(ErrorStr);
  end;
end;

{* -----------------------------------------------------------------------------
  waveInProc Callback proto. Call is forwarded to our TAudioIn object
-------------------------------------------------------------------------------}
procedure waveInProc(const hwi: HWAVEIN;
                     const uMsg: UINT;
                     dwInstance: DWORD;
                     dwParam1: DWORD;
                     dwParam2: DWORD); stdcall;
begin
  // cast Instance parameter and forward call to TAudioIn
  TAudioIn(dwInstance).BufferFinished(hwi, uMsg, dwInstance, dwParam1, dwParam2);

end;

// -----------------------------------------------------------------------------

{ TAudioIn }

{* -----------------------------------------------------------------------------
  If Message is WIM_DATA, swap the buffers, reset current buffer and generate
  notifying event
  See waveInProc() reference for parameter details

  @return Callback proc does not return any value
-------------------------------------------------------------------------------}
procedure TAudioIn.BufferFinished(const hwi: HWAVEIN;
                                  const uMsg: UINT;
                                  dwInstance: DWORD;
                                  dwParam1: DWORD;
                                  dwParam2: DWORD);
var
  DoneWH: PWaveHdr;
  mmErr: MMRESULT;
begin
  if (uMsg = WIM_DATA) AND fRecording then begin

    // save current buffer: this is the one holding the data we need to pass
    DoneWH := fCurrWaveHdr;

    if (fCurrentBuff = 0) then begin
      fCurrentBuff := 1;
      fCurrWaveHdr := flpWaveHdr1;
    end
    else begin
      fCurrentBuff := 0;
      fCurrWaveHdr := flpWaveHdr0;
    end;

    // reset buffer properties and re-add it to wave in
    with fCurrWaveHdr^ do begin
      dwFlags := WHDR_PREPARED; // reset!!!!
      dwBytesRecorded := 0;
    end;
    mmErr := WaveInAddBuffer( fWaveInHandle, fCurrWaveHdr, SizeOf(TWaveHdr) );
    TranslateError(mmErr);

    // generate notification event: send data pointer and data size
    if Assigned(fOnBufferDone) then
      fOnBufferDone( DoneWH.lpData, DoneWH.dwBufferLength );

  end; // if (uMsg = WIM_DATA) AND fRecording

end; // BufferFinished()

{* -----------------------------------------------------------------------------
  Stop, close and release buffer memory
-------------------------------------------------------------------------------}
procedure TAudioIn.Close;
var
  mmErr: MMRESULT;
begin
  if (fWaveInHandle <> 0) then begin
    try
      Stop;

      mmErr := waveInUnPrepareHeader(fWaveInHandle, flpWaveHdr0, Sizeof(TWaveHdr));
      TranslateError(mmErr);

      mmErr := waveInUnPrepareHeader(fWaveInHandle, flpWaveHdr1, Sizeof(TWaveHdr));
      TranslateError(mmErr);

      mmErr := waveInClose(fWaveInHandle);
      TranslateError(mmErr);
    finally
      fWaveInHandle := 0;
      FreeMem(flpWaveHdr0.lpData, fNSamples * fNChannels * fBitsPerSample div 8);
      FreeMem(flpWaveHdr1.lpData, fNSamples * fNChannels * fBitsPerSample div 8);
    end;

  end;

end; // Close()

{* -----------------------------------------------------------------------------
  Creates the instance and initializes buffer pointers. Sets default format
-------------------------------------------------------------------------------}
constructor TAudioIn.Create;
begin
  // initialize the buffers
  New( flpWaveHdr0 );
  ZeroMemory(flpWaveHdr0, SizeOf(TWaveHdr));
  New( flpWaveHdr1 );
  ZeroMemory(flpWaveHdr1, SizeOf(TWaveHdr));

  fRecording := FALSE;

  // init defaults
  fNChannels     := CHANN_MONO;
  fSamplesPerSec := FREQ_6K;
//  fSamplesPerSec := FREQ_8K;
//  fSamplesPerSec := FREQ_12K;
//  fSamplesPerSec := FREQ_22K;
//  fSamplesPerSec := FREQ_44K;
  fBitsPerSample := BITS_16;
  fNSamples      := N_SAMPLES_PER_FRAME;
  SetWaveFormat;

end; // Create()

{* -----------------------------------------------------------------------------
  Close device, release buffer memory and free this instance
-------------------------------------------------------------------------------}
destructor TAudioIn.Destroy;
begin
  Close;
  Dispose(flpWaveHdr0);
  Dispose(flpWaveHdr1);
  inherited;
end;

{* -----------------------------------------------------------------------------
  Gets a valid handle for input device and memory for buffers
-------------------------------------------------------------------------------}
procedure TAudioIn.Open;
var
  aHandle: HWAVEIN;
  mmErr: MMRESULT;
begin
  if (fWaveInHandle = 0) then begin
    aHandle := 0;
    mmErr := waveInOpen(
               @aHandle,
               WAVE_MAPPER,
               @fWaveFormat,
               UINT(@waveInProc),
               UINT(Self),
               CALLBACK_FUNCTION);

    TranslateError(mmErr);

    fWaveInHandle := aHandle;

    if (fWaveInHandle <> 0) then begin
      // we have a valid handle, time to alloc some memory for our buffers
      GetMem(flpWaveHdr0.lpData, fNSamples * fNChannels * fBitsPerSample div 8);
      flpWaveHdr0.dwBufferLength := fNSamples * fNChannels * fBitsPerSample div 8;

      GetMem(flpWaveHdr1.lpData, fNSamples * fNChannels * fBitsPerSample div 8);
      flpWaveHdr1.dwBufferLength := fNSamples * fNChannels * fBitsPerSample div 8;
    end;

    mmErr := WaveInPrepareHeader(fWaveInHandle, flpWaveHdr0, SizeOf(TWaveHdr));
    TranslateError(mmErr);

    mmErr := WaveInPrepareHeader(fWaveInHandle, flpWaveHdr1, SizeOf(TWaveHdr));
    TranslateError(mmErr);
  end;

end; // Open()

{* -----------------------------------------------------------------------------
  Stops the acquisition
-------------------------------------------------------------------------------}
procedure TAudioIn.Stop;
var
  mmErr: MMRESULT;
begin
  if (fWaveInHandle <> 0) AND fRecording then begin
    try
      fRecording := FALSE;

      mmErr := waveInStop(fWaveInHandle);
      TranslateError(mmErr);

      //mmErr := WaveInReset(fWaveInHandle);
      //TranslateError(mmErr);
    finally
      fRecording := FALSE;
    end;
  end;

end; // Stop()

{* -----------------------------------------------------------------------------
  Sets bits per sample and internal wave format
-------------------------------------------------------------------------------}
procedure TAudioIn.SetBitsPerSample(const Value: Word);
begin
  // Sanity
  if fRecording then
    Exit;

  fBitsPerSample := Value;
  SetWaveFormat;

end;

{* -----------------------------------------------------------------------------
  Sets number of channels and internal wave format
-------------------------------------------------------------------------------}
procedure TAudioIn.SetNChannels(const Value: Word);
begin
  // Sanity
  if fRecording then
    Exit;

  fNChannels := Value;
  SetWaveFormat;

end;

{* -----------------------------------------------------------------------------
  Sets sampling rate and internal wave format
-------------------------------------------------------------------------------}
procedure TAudioIn.SetSamplesPerSec(const Value: DWORD);
begin
  // Sanity
  if fRecording then
    Exit;

  fSamplesPerSec := Value;
  SetWaveFormat;

end;

{* -----------------------------------------------------------------------------
  Sets internal wave format
-------------------------------------------------------------------------------}
procedure TAudioIn.SetWaveFormat;
begin
  // Sanity
  if fRecording then
    Exit;

  with fWaveFormat do begin
    wFormatTag     := WAVE_FORMAT_PCM;
    nChannels      := fNChannels;
    nSamplesPerSec := fSamplesPerSec;
    nAvgBytesPerSec:= fSamplesPerSec * fNChannels * fBitsPerSample div 8;
    nBlockAlign    := fNChannels * fBitsPerSample div 8;
    wBitsPerSample := fBitsPerSample;
    cbSize         := 0;
  end;

end; // SetWaveFormat()

{* -----------------------------------------------------------------------------
  Sets the active buffer to be buffer0 and starts the acquisition
-------------------------------------------------------------------------------}
procedure TAudioIn.Start;
var
  mmErr: MMRESULT;
begin
  if (fWaveInHandle <> 0) AND (fRecording = FALSE) then begin
    Stop;

    fCurrWaveHdr := flpWaveHdr0;
    fCurrentBuff := 0;

    mmErr := WaveInAddBuffer(fWaveInHandle, flpWaveHdr0, SizeOf(TWaveHdr));
    TranslateError(mmErr);

    mmErr := waveInStart(fWaveInHandle);
    TranslateError(mmErr);

    fRecording := TRUE;
  end;

end; // Start()

end.
