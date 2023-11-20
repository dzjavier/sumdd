(*
    This unit interfaces to the processing library ToFy.dll.
    Original translation from C --> Object Pascal by Diego Milone.
    Completed by Héctor Laforcada.
    Laboratorio de Cibernética - Facultad de Ingeniería - UNER
*)

unit TofyLink;

interface

{
  Type compatibility:

    TReal32 --> Single   (usar TReal)
    TReal64 --> Double   (usar TDouble)
    TUInt8  --> Byte
    TSInt16 --> SmallInt
    TSInt32 --> Integer
    TUInt32 --> Cardinal
}

type
  TReal   = Single;
  TVector = array[1..536870911] of TReal;  // One based instead of zero based, as originally declared
  PVector = ^TVector;
  TDouble = Double;
  TVecDbl = array[1..9999999] of TDouble; // One based instead of zero based, as originally declared
  PVecDbl = ^TVecDbl;

  // 8 bit vectors
  TVecP8 = array[1..9999999] of ShortInt;
  PVecP8 = ^TVecP8;

  // 16 bit vectors
  TVecP16 = array[1..9999999] of SmallInt;
  PVecP16 = ^TVecP16;

  TWins = (Hamming, Hanning, Blackman, Bartlett, Gaussian, Rectangular);

const
  // Control de errores
  tofy_NO_ERROR     = 0;
  tofy_MEM_ALLOCATE = 1;

  // Invertir o no para las rutinas de FFT
  NO_INVERT         = 0;
  INVERT            = 1;

  // Ventanas para la integral por bandas de Mel
  RECT              = 0;
  TRIANG            = 1;
  //function tofyGetVersion : Integer; stdcall;

  // remez
  BANDPASS          = 1;
  DIFFERENTIATOR    = 2;
  HILBERT           = 3;
  NEGATIVE          = 0;
  POSITIVE          = 1;

function tofyLastError : Integer; stdcall;

procedure CreateVector(var P : PVector; N : Integer); stdcall;
procedure DestroyVector(var P : PVector); stdcall;
procedure VectorSize(P : PVector; var N : Integer); stdcall;

// Declared in "filter.h"

// Moving average filters
procedure FilterMA(b : PVector; x : PVector;
                   y : PVector; init : PVector); stdcall;
procedure FilterMAP8(b : PVector; var x : PVecP8;
                     o : Cardinal; init : PVector); stdcall;
procedure FilterMAP16(b : PVector; var x : PVecP16;
                      o : Cardinal; init : PVector); stdcall;
procedure FilterMAPF(b : PVector; var x : PVector;
                     o : Cardinal; init : PVector); stdcall;

// Auto regressive filters
procedure FilterAR(a : PVector; x : PVector;
                   y : PVector; init : PVector); stdcall;
procedure FilterARP8(a : PVector; var x : PVecP8;
                     o : Cardinal; init : PVector); stdcall;
procedure FilterARP16(a : PVector; var x : PVecP16;
                      o : Cardinal; init : PVector); stdcall;
procedure FilterARPF(a : PVector; var x : PVector;
                     o : Cardinal; init : PVector); stdcall;

// ARMA filters
procedure Filter(b : PVector; a : PVector;
                 x : PVector; y : PVector;
                 xinit : PVector; yinit : PVector); stdcall;
procedure FilterP8(b : PVector; a : PVector; var x : PVecP8;
                   o : Cardinal; xi : PVector; yi : PVector); stdcall;
procedure FilterP16(b : PVector; a : PVector; var x : PVecP16;
                   o : Cardinal; xi : PVector; yi : PVector); stdcall;
procedure FilterPF(b : PVector; a : PVector; var x : PVector;
                   o : Cardinal; xi : PVector; yi : PVector); stdcall;

// Declared in "???.h"
procedure FFTFilter(b : PVector; x : PVector;
                    y : PVector; init : PVector); stdcall;

// Declared in "fir.h"
// FIR filter design
procedure Remez(h : PVector;   bands : PVector;
                des : PVector; weights : PVector;
                ttype : integer); stdcall;

// Declared in "emath.h"
procedure VectorModulus(S : PVector; M : PVector); stdcall;
procedure VectorLogModulus(S : PVector; L : PVector; Invert : Integer); stdcall;
procedure VectorPhase(S : PVector; P : PVector); stdcall;
// figura en el .h pero no está implementado}{procedure VectorAbs(V: Pvector); stdcall;
procedure NormalizeVector(V: PVector); stdcall;
procedure FindMax(c: PVector; var iMax: Integer; var Max: TReal;
                  const LowLimit: Integer; const HighLimit: Integer); stdcall;
procedure FindAbsMax(c: PVector; var iMax: Integer; var Max: TReal;
                     const LowLimit: Integer; const HighLimit: Integer); stdcall;
procedure Preemphasis(S : PVector; Alpha : TReal; SInic : TReal); stdcall;
procedure AutoCorrelation(S : PVector; r : PVector; p : Integer; N : Integer); stdcall;
procedure Energy(s: PVector; var E: TReal); stdcall;
procedure EnergyFrames(s: PVector; var E: PVector; const NFrame, NStep: Integer;
                       const WinType: TWins); stdcall;
procedure Swap16(var p: Smallint); stdcall;
procedure Swap32(var p: Longint); stdcall;
procedure ulaw8lin16(var u2l: TReal); stdcall;
procedure lin16ulaw8(var l2u: TReal); stdcall;

// Declared in "win.h"
procedure CreateWin(Win : PVector; WinType : TWins); stdcall;
procedure ApplyWin(Vec : PVector; Win : PVector); stdcall;

// Declared in "spec.h"
procedure FFT(P: PVector; Invert: Integer); stdcall;
procedure RealFFT(P: PVector); stdcall;
procedure PadRealFFT(P: PVector; S: PVector); stdcall;
procedure RealFFTP8(p : PVecP8; s : PVector); stdcall;
procedure RealFFTP16(p : PVecP16; s : PVector); stdcall;
procedure RealFFTPF(p : PVector; s : PVector); stdcall; // RealFFT overloading

// Declared in "lpc.h"
procedure LPC(s: PVector; a: PVector; k: PVector; var re: TReal; var te: TReal); stdcall;
procedure LPCToCepstrum(a : PVector; c : PVector); stdcall;
procedure CepstrumToLPC(c : PVector; a : PVector); stdcall;
procedure LPCToRefC(a: PVector; k: PVector); stdcall;
procedure RefCToLPC(k: PVector; a: PVector); stdcall;
procedure LPCFreqResp(a: PVector; f: PVector); stdcall;

// Declared in "ceps.h"
procedure RealLPCCepstrum(s: PVector; c: PVector); stdcall;
procedure RealFFTCepstrum(s: PVector; c: PVector); stdcall;

// Declared in "mel.h"
procedure CalculateMelBands(fInic: TReal; sFin: TReal; MelBands: PVector); stdcall;
procedure MelCepstrum(s: PVector; c: PVector; NFilter: Integer; fSamp: Integer; Win: TWins); stdcall;
procedure MelFFT(s: PVector; c: PVector; NFilter: Integer; fSamp: Integer; Win: TWins); stdcall;

// Declared in "pitch.h"
procedure PitchFrames(const s: PVector; var Ph:PVector; const NFrame: Cardinal;
                      const NStep: Cardinal;const WinType: TWins;
                      const SampleRate: Cardinal); stdcall;

implementation

const
  TOFYDLL = 'tofy.dll';

// Library Version
function tofyGetVersion:Integer; stdcall;
  external TOFYDLL name 'tfGetVersion';

// Last Error
function tofyLastError:Integer; stdcall;
  external TOFYDLL name 'tfLastError';

// Memory management
procedure CreateVector(var P : PVector; N : Integer); stdcall;
  external TOFYDLL name 'tfCreateVector';

procedure DestroyVector(var P : PVector); stdcall;
  external TOFYDLL name 'tfDestroyVector';

procedure VectorSize(P : PVector; var N : Integer); stdcall;
  external TOFYDLL name 'tfVectorSize';

{ --- << -------------------------------------------------------------- >> --- }
// MA Filters
procedure FilterMA(b : PVector; x : PVector;
                   y : PVector; init : PVector); stdcall;
  external TOFYDLL name 'tfFilterMA';

procedure FilterMAP8(b : PVector; var x : PVecP8;
                     o : Cardinal; init : PVector); stdcall;
  external TOFYDLL name 'tfFilterMAP8';

procedure FilterMAP16(b : PVector; var x : PVecP16;
                      o : Cardinal; init : PVector); stdcall;
  external TOFYDLL name 'tfFilterMAP16';

procedure FilterMAPF(b : PVector; var x : PVector;
                     o : Cardinal; init : PVector); stdcall;
  external TOFYDLL name 'tfFilterMAPF';

{ --- << -------------------------------------------------------------- >> --- }
// AR Filters
procedure FilterAR(a : PVector; x : PVector;
                   y : PVector; init : PVector); stdcall;
  external TOFYDLL name 'tfFilterAR';

procedure FilterARP8(a : PVector; var x : PVecP8;
                     o : Cardinal; init : PVector); stdcall;
  external TOFYDLL name 'tfFilterARP8';

procedure FilterARP16(a : PVector; var x : PVecP16;
                      o : Cardinal; init : PVector); stdcall;
  external TOFYDLL name 'tfFilterARP16';

procedure FilterARPF(a : PVector; var x : PVector;
                     o : Cardinal; init : PVector); stdcall;
  external TOFYDLL name 'tfFilterARPF';

{ --- << -------------------------------------------------------------- >> --- }
// ARMA Filters
procedure Filter(b : PVector; a : PVector; x : PVector;
                 y : PVector; xinit : PVector; yinit : PVector); stdcall;
  external TOFYDLL name 'tfFilter';

procedure FilterP8(b : PVector; a : PVector; var x : PVecP8;
                   o : Cardinal; xi : PVector; yi : PVector); stdcall;
  external TOFYDLL name 'tfFilterP8';

procedure FilterP16(b : PVector; a : PVector; var x : PVecP16;
                   o : Cardinal; xi : PVector; yi : PVector); stdcall;
  external TOFYDLL name 'tfFilterP16';

procedure FilterPF(b : PVector; a : PVector; var x : PVector;
                   o : Cardinal; xi : PVector; yi : PVector); stdcall;
  external TOFYDLL name 'tfFilterPF';

{ --- << -------------------------------------------------------------- >> --- }
// IT'S NOT IN THE TOFY INTERFACE... !!!!!
procedure FFTFilter(b : PVector; x : PVector;
                    y : PVector; init : PVector); stdcall;
  external TOFYDLL name 'tfFFTFilter';

// FIR filter design
procedure Remez(h : PVector; bands : PVector; des : PVector;
                weights : PVector; ttype : integer); stdcall;
  external TOFYDLL name 'tfRemez';

{--- << ---------------------------------------------------------------- >> ---}
// Essential Mathematical routines
procedure VectorModulus(S : PVector; M : PVector); stdcall;
  external TOFYDLL name 'tfVectorModulus';

procedure VectorLogModulus(S : PVector; L : PVector; Invert : Integer); stdcall;
  external TOFYDLL name 'tfVectorLogModulus';

procedure VectorPhase(S: PVector; P: PVector); stdcall;
  external TOFYDLL name 'tfVectorPhase';

{procedure VectorAbs(V: Pvector); stdcall;
  external TOFYDLL name 'tfVectorAbs';}

procedure NormalizeVector(V: PVector); stdcall;
  external TOFYDLL name 'tfNormalizeVector';

procedure FindMax(c: PVector; var iMax: Integer; var Max: TReal;
                  const LowLimit: Integer; const HighLimit: Integer); stdcall;
  external TOFYDLL name 'tfFindMax';

procedure FindAbsMax(c: PVector; var iMax: Integer; var Max: TReal;
                    const LowLimit: Integer; const HighLimit: Integer); stdcall;
  external TOFYDLL name 'tfFindAbsMax';

procedure Preemphasis(S: PVector; Alpha: TReal; SInic: TReal); stdcall;
  external TOFYDLL name 'tfPreemphasis';

procedure AutoCorrelation(S: PVector; r: PVector; p: Integer; N: Integer); stdcall;
  external TOFYDLL name 'tfAutoCorrelation';

procedure Energy(s: PVector; var E: TReal); stdcall;
  external TOFYDLL name 'tfEnergy';

procedure EnergyFrames(s: PVector; var E: PVector; const NFrame, NStep: Integer;
                       const WinType: TWins); stdcall;
  external TOFYDLL name 'tfEnergyFrames';

procedure Swap16(var p: Smallint); stdcall;
  external TOFYDLL name 'tfSwap16';

procedure Swap32(var p: Longint); stdcall;
  external TOFYDLL name 'tfSwap32';

procedure ulaw8lin16(var u2l: TReal); stdcall;
  external TOFYDLL name 'tfulaw8lin16';

procedure lin16ulaw8(var l2u: TReal); stdcall;
  external TOFYDLL name 'tflin16ulaw8';

{ --- << -------------------------------------------------------------- >> --- }
// Windows Management
procedure CreateWin(Win : PVector; WinType : TWins); stdcall;
  external TOFYDLL name 'tfCreateWin';

procedure ApplyWin(Vec : PVector; Win : PVector); stdcall;
  external TOFYDLL name 'tfApplyWin';

{ --- << -------------------------------------------------------------- >> --- }
// Spectrum Analysis
procedure FFT(P : PVector; Invert : Integer); stdcall;
  external TOFYDLL name 'tfFFT';

procedure RealFFT(P : PVector); stdcall;
  external TOFYDLL name 'tfRealFFT';

procedure PadRealFFT(P : PVector; S : PVector); stdcall;
  external TOFYDLL name 'tfPadRealFFT';

procedure RealFFTP8(p : PVecP8; s : PVector); stdcall;
  external TOFYDLL name 'tfRealFFTP8';

procedure RealFFTP16(p : PVecP16; s : PVector); stdcall;
  external TOFYDLL name 'tfRealFFTP16';

procedure RealFFTPF(p : PVector; s : PVector); stdcall; // RealFFT overloading
  external TOFYDLL name 'tfRealFFTPF';

{ --- << -------------------------------------------------------------- >> --- }
// Linear Prediction Analysis
procedure LPC(s: PVector; a: PVector; k: PVector;
              var re: TReal; var te: TReal); stdcall;
  external TOFYDLL name 'tfLPC';

procedure LPCToCepstrum(a : PVector; c : PVector); stdcall;
  external TOFYDLL name 'tfLPCToCepstrum';

procedure CepstrumToLPC(c : PVector; a : PVector); stdcall;
  external TOFYDLL name 'tfCepstrumToLPC';

procedure LPCToRefC(a: PVector; k: PVector); stdcall;
  external TOFYDLL name 'tfLPCToRefC';

procedure RefCToLPC(k: PVector; a: PVector); stdcall;
  external TOFYDLL name 'tfRefCToLPC';

procedure LPCFreqResp(a: PVector; f: PVector); stdcall;
  external TOFYDLL name 'tfLPCFreqResp';

{ --- << -------------------------------------------------------------- >> --- }
// Cepstrum
procedure RealLPCCepstrum(s: PVector; c: PVector); stdcall;
  external TOFYDLL name 'tfRealLPCCepstrum';

procedure RealFFTCepstrum(s : PVector; c : PVector); stdcall;
  external TOFYDLL name 'tfRealFFTCepstrum';

{ --- << -------------------------------------------------------------- >> --- }
// Mel scale analysis
procedure CalculateMelBands(fInic: TReal; sFin: TReal; MelBands: PVector); stdcall;
  external TOFYDLL name 'tfCalculateMelBands';

procedure MelCepstrum(s: PVector; c: PVector; NFilter: Integer;
                      fSamp: Integer; Win: TWins); stdcall;
  external TOFYDLL name 'tfMelCepstrum';

procedure MelFFT(s: PVector; c: PVector; NFilter: Integer;
                 fSamp: Integer; Win: TWins); stdcall;
  external TOFYDLL name 'tfMelFFT';

{ --- << -------------------------------------------------------------- >> --- }
// Pitch Estimation
procedure PitchFrames(const s: PVector; var Ph:PVector; const NFrame: Cardinal;
                      const NStep: Cardinal;const WinType: TWins;
                      const SampleRate: Cardinal); stdcall;
  external TOFYDLL name 'tfPitchFrames';

end.
