unit APOGEELib_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : $Revision:   1.130.1.0.1.0.1.6  $
// File generated on 26/4/04 15.44.22 from Type Library described below.

// ************************************************************************  //
// Type Lib: E:\JavierD\Proyecto Final\SUMDD\Apogee.tlb (1)
// LIBID: {A2882C73-7CFB-11D4-9155-0060676644C1}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINNT\System32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINNT\System32\stdvcl40.dll)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
//{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  APOGEELibMajorVersion = 1;
  APOGEELibMinorVersion = 0;

  LIBID_APOGEELib: TGUID = '{A2882C73-7CFB-11D4-9155-0060676644C1}';

  IID_ICamera: TGUID = '{A2882C7F-7CFB-11D4-9155-0060676644C1}';
  CLASS_Camera: TGUID = '{A2882C80-7CFB-11D4-9155-0060676644C1}';
  IID_ICamera2: TGUID = '{B7AF5DDD-3281-493D-B28A-434FDBC269D9}';
  CLASS_Camera2: TGUID = '{5F6A47EF-4BD7-4608-B27B-8AF7BFE26ADA}';
  IID_ICamDiscover: TGUID = '{66FCB019-20D1-41CA-B400-D0D82ECA5A67}';
  CLASS_CamDiscover: TGUID = '{CF9D3BA9-0435-4908-9353-8E808FF210D5}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum Camera_Status
type
  Camera_Status = TOleEnum;
const
  Camera_Status_Idle = $00000000;
  Camera_Status_Waiting = $00000001;
  Camera_Status_Exposing = $00000002;
  Camera_Status_Downloading = $00000003;
  Camera_Status_LineReady = $00000004;
  Camera_Status_ImageReady = $00000005;
  Camera_Status_Flushing = $00000006;

// Constants for enum Camera_CoolerStatus
type
  Camera_CoolerStatus = TOleEnum;
const
  Camera_CoolerStatus_Off = $00000000;
  Camera_CoolerStatus_RampingToSetPoint = $00000001;
  Camera_CoolerStatus_Correcting = $00000002;
  Camera_CoolerStatus_RampingToAmbient = $00000003;
  Camera_CoolerStatus_AtAmbient = $00000004;
  Camera_CoolerStatus_AtMax = $00000005;
  Camera_CoolerStatus_AtMin = $00000006;
  Camera_CoolerStatus_AtSetPoint = $00000007;

// Constants for enum Camera_CoolerMode
type
  Camera_CoolerMode = TOleEnum;
const
  Camera_CoolerMode_Off = $00000000;
  Camera_CoolerMode_On = $00000001;
  Camera_CoolerMode_Shutdown = $00000002;

// Constants for enum Apn_Interface
type
  Apn_Interface = TOleEnum;
const
  Apn_Interface_NET = $00000000;
  Apn_Interface_USB = $00000001;

// Constants for enum Apn_CameraMode
type
  Apn_CameraMode = TOleEnum;
const
  Apn_CameraMode_Normal = $00000000;
  Apn_CameraMode_TDI = $00000001;
  Apn_CameraMode_Test = $00000002;
  Apn_CameraMode_ExternalTrigger = $00000003;
  Apn_CameraMode_ExternalShutter = $00000004;

// Constants for enum Apn_Resolution
type
  Apn_Resolution = TOleEnum;
const
  Apn_Resolution_SixteenBit = $00000000;
  Apn_Resolution_TwelveBit = $00000001;

// Constants for enum Apn_Status
type
  Apn_Status = TOleEnum;
const
  Apn_Status_DataError = $FFFFFFFE;
  Apn_Status_PatternError = $FFFFFFFF;
  Apn_Status_Idle = $00000000;
  Apn_Status_Exposing = $00000001;
  Apn_Status_ImagingActive = $00000002;
  Apn_Status_ImageReady = $00000003;
  Apn_Status_Flushing = $00000004;
  Apn_Status_WaitingOnTrigger = $00000005;

// Constants for enum Apn_NetworkMode
type
  Apn_NetworkMode = TOleEnum;
const
  Apn_NetworkMode_Tcp = $00000000;
  Apn_NetworkMode_Udp = $00000001;

// Constants for enum Apn_LedMode
type
  Apn_LedMode = TOleEnum;
const
  Apn_LedMode_DisableAll = $00000000;
  Apn_LedMode_DisableWhileExpose = $00000001;
  Apn_LedMode_EnableAll = $00000002;

// Constants for enum Apn_LedState
type
  Apn_LedState = TOleEnum;
const
  Apn_LedState_Expose = $00000000;
  Apn_LedState_ImageActive = $00000001;
  Apn_LedState_Flushing = $00000002;
  Apn_LedState_ExtTriggerWaiting = $00000003;
  Apn_LedState_ExtTriggerReceived = $00000004;
  Apn_LedState_ExtShutterInput = $00000005;
  Apn_LedState_ExtStartReadout = $00000006;
  Apn_LedState_AtTemp = $00000007;

// Constants for enum Apn_CoolerStatus
type
  Apn_CoolerStatus = TOleEnum;
const
  Apn_CoolerStatus_Off = $00000000;
  Apn_CoolerStatus_RampingToSetPoint = $00000001;
  Apn_CoolerStatus_AtSetPoint = $00000002;
  Apn_CoolerStatus_Revision = $00000003;

// Constants for enum Apn_FanMode
type
  Apn_FanMode = TOleEnum;
const
  Apn_FanMode_Off = $00000000;
  Apn_FanMode_Low = $00000001;
  Apn_FanMode_Medium = $00000002;
  Apn_FanMode_High = $00000003;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  ICamera = interface;
  ICameraDisp = dispinterface;
  ICamera2 = interface;
  ICamera2Disp = dispinterface;
  ICamDiscover = interface;
  ICamDiscoverDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  Camera = ICamera;
  Camera2 = ICamera2;
  CamDiscover = ICamDiscover;


// *********************************************************************//
// Interface: ICamera
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A2882C7F-7CFB-11D4-9155-0060676644C1}
// *********************************************************************//
  ICamera = interface(IDispatch)
    ['{A2882C7F-7CFB-11D4-9155-0060676644C1}']
    procedure Init(const inifile: WideString; BaseAddress: Smallint; RegOffset: Smallint); safecall;
    procedure Reset; safecall;
    procedure Flush(Rows: Smallint); safecall;
    procedure AuxOutput(Val: Byte); safecall;
    procedure RegWrite(reg: Smallint; Val: Smallint); safecall;
    function  Get_RegRead(reg: Smallint): Smallint; safecall;
    procedure FilterHome; safecall;
    procedure FilterSet(Slot: Smallint); safecall;
    procedure Expose(Duration: Double; Light: WordBool); safecall;
    procedure DigitizeLine; safecall;
    procedure GetImage(pImageBuffer: Integer); safecall;
    procedure GetLine(pLineBuffer: Integer); safecall;
    function  Get_Image: OleVariant; safecall;
    function  Get_Line: OleVariant; safecall;
    function  Get_Snap(Duration: Double; Light: WordBool): OleVariant; safecall;
    function  Get_ConvertShortToLong: WordBool; safecall;
    procedure Set_ConvertShortToLong(pVal: WordBool); safecall;
    function  Get_OptionBase: WordBool; safecall;
    procedure Set_OptionBase(pVal: WordBool); safecall;
    function Get_Present: WordBool; safecall;
    function Get_Status: Camera_Status; safecall;
    function Get_Shutter: WordBool; safecall;
    function Get_ForceShutterOpen: WordBool; safecall;
    procedure Set_ForceShutterOpen(pVal: WordBool); safecall;
    function Get_LongCable: WordBool; safecall;
    procedure Set_LongCable(pVal: WordBool); safecall;
    function Get_Mode: Smallint; safecall;
    procedure Set_Mode(pVal: Smallint); safecall;
    function Get_TestBits: Smallint; safecall;
    procedure Set_TestBits(pVal: Smallint); safecall;
    function Get_Test2Bits: Smallint; safecall;
    procedure Set_Test2Bits(pVal: Smallint); safecall;
    function Get_FastReadout: WordBool; safecall;
    procedure Set_FastReadout(pVal: WordBool); safecall;
    function Get_UseTrigger: WordBool; safecall;
    procedure Set_UseTrigger(pVal: WordBool); safecall;
    function Get_CoolerSetPoint: Double; safecall;
    procedure Set_CoolerSetPoint(pVal: Double); safecall;
    function Get_CoolerStatus: Camera_CoolerStatus; safecall;
    function Get_CoolerMode: Camera_CoolerMode; safecall;
    procedure Set_CoolerMode(pVal: Camera_CoolerMode); safecall;
    function Get_Temperature: Double; safecall;
    function Get_TempCalibration: Smallint; safecall;
    procedure Set_TempCalibration(pVal: Smallint); safecall;
    function Get_TempScale: Double; safecall;
    procedure Set_TempScale(pVal: Double); safecall;
    function Get_BinX: Smallint; safecall;
    procedure Set_BinX(pVal: Smallint); safecall;
    function Get_BinY: Smallint; safecall;
    procedure Set_BinY(pVal: Smallint); safecall;
    function Get_StartX: Smallint; safecall;
    procedure Set_StartX(pVal: Smallint); safecall;
    function Get_StartY: Smallint; safecall;
    procedure Set_StartY(pVal: Smallint); safecall;
    function Get_NumX: Smallint; safecall;
    procedure Set_NumX(pVal: Smallint); safecall;
    function Get_NumY: Smallint; safecall;
    procedure Set_NumY(pVal: Smallint); safecall;
    function Get_Columns: Smallint; safecall;
    procedure Set_Columns(pVal: Smallint); safecall;
    function Get_Rows: Smallint; safecall;
    procedure Set_Rows(pVal: Smallint); safecall;
    function Get_ImgColumns: Smallint; safecall;
    procedure Set_ImgColumns(pVal: Smallint); safecall;
    function Get_ImgRows: Smallint; safecall;
    procedure Set_ImgRows(pVal: Smallint); safecall;
    function Get_SkipC: Smallint; safecall;
    procedure Set_SkipC(pVal: Smallint); safecall;
    function Get_SkipR: Smallint; safecall;
    procedure Set_SkipR(pVal: Smallint); safecall;
    function Get_HFlush: Smallint; safecall;
    procedure Set_HFlush(pVal: Smallint); safecall;
    function Get_VFlush: Smallint; safecall;
    procedure Set_VFlush(pVal: Smallint); safecall;
    function Get_BIC: Smallint; safecall;
    procedure Set_BIC(pVal: Smallint); safecall;
    function Get_BIR: Smallint; safecall;
    procedure Set_BIR(pVal: Smallint); safecall;
    function Get_Sensor: WideString; safecall;
    procedure Set_Sensor(const pVal: WideString); safecall;
    function Get_Noise: Double; safecall;
    procedure Set_Noise(pVal: Double); safecall;
    function Get_Gain: Double; safecall;
    procedure Set_Gain(pVal: Double); safecall;
    function Get_PixelXSize: Double; safecall;
    procedure Set_PixelXSize(pVal: Double); safecall;
    function Get_PixelYSize: Double; safecall;
    procedure Set_PixelYSize(pVal: Double); safecall;
    function Get_TDI: WordBool; safecall;
    procedure Set_TDI(pVal: WordBool); safecall;
    function Get_PPRepeat: Smallint; safecall;
    procedure Set_PPRepeat(pVal: Smallint); safecall;
    function Get_DataBits: Smallint; safecall;
    function Get_HighPriority: WordBool; safecall;
    procedure Set_HighPriority(pVal: WordBool); safecall;
    function Get_MaxExposure: Double; safecall;
    function Get_MinExposure: Double; safecall;
    function Get_MaxBinX: Smallint; safecall;
    function Get_MaxBinY: Smallint; safecall;
    function Get_CoolerControl: WordBool; safecall;
    function Get_Color: WordBool; safecall;
    function Get_GuiderRelays: WordBool; safecall;
    function Get_Timeout: Double; safecall;
    procedure Set_Timeout(pVal: Double); safecall;
    property RegRead[reg: Smallint]: Smallint read Get_RegRead;
    property Image: OleVariant read Get_Image;
    property Line: OleVariant read Get_Line;
    property Snap[Duration: Double; Light: WordBool]: OleVariant read Get_Snap;
    property ConvertShortToLong: WordBool read Get_ConvertShortToLong write Set_ConvertShortToLong;
    property OptionBase: WordBool read Get_OptionBase write Set_OptionBase;
    property Present: WordBool read Get_Present;
    property Status: Camera_Status read Get_Status;
    property Shutter: WordBool read Get_Shutter;
    property ForceShutterOpen: WordBool read Get_ForceShutterOpen write Set_ForceShutterOpen;
    property LongCable: WordBool read Get_LongCable write Set_LongCable;
    property Mode: Smallint read Get_Mode write Set_Mode;
    property TestBits: Smallint read Get_TestBits write Set_TestBits;
    property Test2Bits: Smallint read Get_Test2Bits write Set_Test2Bits;
    property FastReadout: WordBool read Get_FastReadout write Set_FastReadout;
    property UseTrigger: WordBool read Get_UseTrigger write Set_UseTrigger;
    property CoolerSetPoint: Double read Get_CoolerSetPoint write Set_CoolerSetPoint;
    property CoolerStatus: Camera_CoolerStatus read Get_CoolerStatus;
    property CoolerMode: Camera_CoolerMode read Get_CoolerMode write Set_CoolerMode;
    property Temperature: Double read Get_Temperature;
    property TempCalibration: Smallint read Get_TempCalibration write Set_TempCalibration;
    property TempScale: Double read Get_TempScale write Set_TempScale;
    property BinX: Smallint read Get_BinX write Set_BinX;
    property BinY: Smallint read Get_BinY write Set_BinY;
    property StartX: Smallint read Get_StartX write Set_StartX;
    property StartY: Smallint read Get_StartY write Set_StartY;
    property NumX: Smallint read Get_NumX write Set_NumX;
    property NumY: Smallint read Get_NumY write Set_NumY;
    property Columns: Smallint read Get_Columns write Set_Columns;
    property Rows: Smallint read Get_Rows write Set_Rows;
    property ImgColumns: Smallint read Get_ImgColumns write Set_ImgColumns;
    property ImgRows: Smallint read Get_ImgRows write Set_ImgRows;
    property SkipC: Smallint read Get_SkipC write Set_SkipC;
    property SkipR: Smallint read Get_SkipR write Set_SkipR;
    property HFlush: Smallint read Get_HFlush write Set_HFlush;
    property VFlush: Smallint read Get_VFlush write Set_VFlush;
    property BIC: Smallint read Get_BIC write Set_BIC;
    property BIR: Smallint read Get_BIR write Set_BIR;
    property Sensor: WideString read Get_Sensor write Set_Sensor;
    property Noise: Double read Get_Noise write Set_Noise;
    property Gain: Double read Get_Gain write Set_Gain;
    property PixelXSize: Double read Get_PixelXSize write Set_PixelXSize;
    property PixelYSize: Double read Get_PixelYSize write Set_PixelYSize;
    property TDI: WordBool read Get_TDI write Set_TDI;
    property PPRepeat: Smallint read Get_PPRepeat write Set_PPRepeat;
    property DataBits: Smallint read Get_DataBits;
    property HighPriority: WordBool read Get_HighPriority write Set_HighPriority;
    property MaxExposure: Double read Get_MaxExposure;
    property MinExposure: Double read Get_MinExposure;
    property MaxBinX: Smallint read Get_MaxBinX;
    property MaxBinY: Smallint read Get_MaxBinY;
    property CoolerControl: WordBool read Get_CoolerControl;
    property Color: WordBool read Get_Color;
    property GuiderRelays: WordBool read Get_GuiderRelays;
    property Timeout: Double read Get_Timeout write Set_Timeout;
  end;

// *********************************************************************//
// DispIntf:  ICameraDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A2882C7F-7CFB-11D4-9155-0060676644C1}
// *********************************************************************//
  ICameraDisp = dispinterface
    ['{A2882C7F-7CFB-11D4-9155-0060676644C1}']
    procedure Init(const inifile: WideString; BaseAddress: Smallint; RegOffset: Smallint); dispid 1;
    procedure Reset; dispid 2;
    procedure Flush(Rows: Smallint); dispid 3;
    procedure AuxOutput(Val: Byte); dispid 4;
    procedure RegWrite(reg: Smallint; Val: Smallint); dispid 5;
    property RegRead[reg: Smallint]: Smallint readonly dispid 6;
    procedure FilterHome; dispid 7;
    procedure FilterSet(Slot: Smallint); dispid 8;
    procedure Expose(Duration: Double; Light: WordBool); dispid 9;
    procedure DigitizeLine; dispid 10;
    procedure GetImage(pImageBuffer: Integer); dispid 11;
    procedure GetLine(pLineBuffer: Integer); dispid 12;
    property Image: OleVariant readonly dispid 13;
    property Line: OleVariant readonly dispid 14;
    property Snap[Duration: Double; Light: WordBool]: OleVariant readonly dispid 15;
    property ConvertShortToLong: WordBool dispid 16;
    property OptionBase: WordBool dispid 17;
    property Present: WordBool readonly dispid 18;
    property Status: Camera_Status readonly dispid 19;
    property Shutter: WordBool readonly dispid 20;
    property ForceShutterOpen: WordBool dispid 21;
    property LongCable: WordBool dispid 22;
    property Mode: Smallint dispid 23;
    property TestBits: Smallint dispid 24;
    property Test2Bits: Smallint dispid 25;
    property FastReadout: WordBool dispid 26;
    property UseTrigger: WordBool dispid 27;
    property CoolerSetPoint: Double dispid 28;
    property CoolerStatus: Camera_CoolerStatus readonly dispid 29;
    property CoolerMode: Camera_CoolerMode dispid 30;
    property Temperature: Double readonly dispid 31;
    property TempCalibration: Smallint dispid 32;
    property TempScale: Double dispid 33;
    property BinX: Smallint dispid 34;
    property BinY: Smallint dispid 35;
    property StartX: Smallint dispid 36;
    property StartY: Smallint dispid 37;
    property NumX: Smallint dispid 38;
    property NumY: Smallint dispid 39;
    property Columns: Smallint dispid 40;
    property Rows: Smallint dispid 41;
    property ImgColumns: Smallint dispid 42;
    property ImgRows: Smallint dispid 43;
    property SkipC: Smallint dispid 44;
    property SkipR: Smallint dispid 45;
    property HFlush: Smallint dispid 46;
    property VFlush: Smallint dispid 47;
    property BIC: Smallint dispid 48;
    property BIR: Smallint dispid 49;
    property Sensor: WideString dispid 50;
    property Noise: Double dispid 51;
    property Gain: Double dispid 52;
    property PixelXSize: Double dispid 53;
    property PixelYSize: Double dispid 54;
    property TDI: WordBool dispid 55;
    property PPRepeat: Smallint dispid 56;
    property DataBits: Smallint readonly dispid 57;
    property HighPriority: WordBool dispid 58;
    property MaxExposure: Double readonly dispid 59;
    property MinExposure: Double readonly dispid 60;
    property MaxBinX: Smallint readonly dispid 61;
    property MaxBinY: Smallint readonly dispid 62;
    property CoolerControl: WordBool readonly dispid 63;
    property Color: WordBool readonly dispid 64;
    property GuiderRelays: WordBool readonly dispid 65;
    property Timeout: Double dispid 66;
  end;

// *********************************************************************//
// Interface: ICamera2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B7AF5DDD-3281-493D-B28A-434FDBC269D9}
// *********************************************************************//
  ICamera2 = interface(IDispatch)
    ['{B7AF5DDD-3281-493D-B28A-434FDBC269D9}']
    procedure Init(Interface_: Apn_Interface; CamIdOne: Integer; CamIdTwo: Integer; Option: Integer); safecall;
    procedure Expose(Duration: Double; Light: WordBool); safecall;
    procedure ResetSystem; safecall;
    procedure PauseTimer(PauseState: WordBool); safecall;
    procedure StopExposure(DigitizeData: WordBool); safecall;
    procedure GetImage(pImageBuffer: Integer); safecall;
    procedure GetLine(pLineBuffer: Integer); safecall;
    procedure ShowIoDialog; safecall;
    procedure ShowLedDialog; safecall;
    procedure ShowTempDialog; safecall;
    function Get_AvailableMemory: Integer; safecall;
    function Get_CameraInterface: Apn_Interface; safecall;
    function Get_CameraMode: Apn_CameraMode; safecall;
    procedure Set_CameraMode(pVal: Apn_CameraMode); safecall;
    function Get_CameraModel: WideString; safecall;
    function Get_DataBits: Apn_Resolution; safecall;
    procedure Set_DataBits(pVal: Apn_Resolution); safecall;
    function Get_DriverVersion: WideString; safecall;
    function Get_FastSequence: WordBool; safecall;
    procedure Set_FastSequence(pVal: WordBool); safecall;
    function Get_FirmwareVersion: Integer; safecall;
    function Get_ImagingStatus: Apn_Status; safecall;
    function Get_InputVoltage: Double; safecall;
    function Get_MaxExposure: Double; safecall;
    function Get_MinExposure: Double; safecall;
    function Get_NetworkTransferMode: Apn_NetworkMode; safecall;
    procedure Set_NetworkTransferMode(pVal: Apn_NetworkMode); safecall;
    function Get_SerialASupport: WordBool; safecall;
    function Get_SerialBSupport: WordBool; safecall;
    function Get_DisableShutter: WordBool; safecall;
    procedure Set_DisableShutter(pVal: WordBool); safecall;
    function Get_ExternalIoReadout: WordBool; safecall;
    procedure Set_ExternalIoReadout(pVal: WordBool); safecall;
    function Get_ForceShutterOpen: WordBool; safecall;
    procedure Set_ForceShutterOpen(pVal: WordBool); safecall;
    function Get_ShutterAmpControl: WordBool; safecall;
    procedure Set_ShutterAmpControl(pVal: WordBool); safecall;
    function Get_ShutterState: WordBool; safecall;
    function Get_ShutterStrobePeriod: Double; safecall;
    procedure Set_ShutterStrobePeriod(pVal: Double); safecall;
    function Get_ShutterStrobePosition: Double; safecall;
    procedure Set_ShutterStrobePosition(pVal: Double); safecall;
    function Get_TDICounter: Integer; safecall;
    function Get_TDIRate: Double; safecall;
    procedure Set_TDIRate(pVal: Double); safecall;
    function Get_TDIRows: Integer; safecall;
    procedure Set_TDIRows(pVal: Integer); safecall;
    function Get_ImageCount: Integer; safecall;
    procedure Set_ImageCount(pVal: Integer); safecall;
    function Get_SequenceCounter: Integer; safecall;
    function Get_SequenceDelay: Double; safecall;
    procedure Set_SequenceDelay(pVal: Double); safecall;
    function Get_VariableSequenceDelay: WordBool; safecall;
    procedure Set_VariableSequenceDelay(pVal: WordBool); safecall;
    function Get_PhysicalColumns: Integer; safecall;
    function Get_PhysicalRows: Integer; safecall;
    function Get_ImagingColumns: Integer; safecall;
    function Get_ImagingRows: Integer; safecall;
    function Get_OverscanColumns: Integer; safecall;
    function Get_DigitizeOverscan: WordBool; safecall;
    procedure Set_DigitizeOverscan(pVal: WordBool); safecall;
    function Get_RoiPixelsH: Integer; safecall;
    procedure Set_RoiPixelsH(pVal: Integer); safecall;
    function Get_RoiPixelsV: Integer; safecall;
    procedure Set_RoiPixelsV(pVal: Integer); safecall;
    function Get_RoiStartX: Integer; safecall;
    procedure Set_RoiStartX(pVal: Integer); safecall;
    function Get_RoiStartY: Integer; safecall;
    procedure Set_RoiStartY(pVal: Integer); safecall;
    function Get_MaxBinningH: Integer; safecall;
    function Get_MaxBinningV: Integer; safecall;
    function Get_RoiBinningH: Integer; safecall;
    procedure Set_RoiBinningH(pVal: Integer); safecall;
    function Get_RoiBinningV: Integer; safecall;
    procedure Set_RoiBinningV(pVal: Integer); safecall;
    function Get_LedMode: Apn_LedMode; safecall;
    procedure Set_LedMode(pVal: Apn_LedMode); safecall;
    function Get_LedA: Apn_LedState; safecall;
    procedure Set_LedA(pVal: Apn_LedState); safecall;
    function Get_LedB: Apn_LedState; safecall;
    procedure Set_LedB(pVal: Apn_LedState); safecall;
    function Get_TestLedBrightness: Double; safecall;
    procedure Set_TestLedBrightness(pVal: Double); safecall;
    function Get_IoPortAssignment: Integer; safecall;
    procedure Set_IoPortAssignment(pVal: Integer); safecall;
    function Get_IoPortDirection: Integer; safecall;
    procedure Set_IoPortDirection(pVal: Integer); safecall;
    function Get_IoPortData: Integer; safecall;
    procedure Set_IoPortData(pVal: Integer); safecall;
    function Get_CoolerControl: WordBool; safecall;
    function Get_CoolerRegulated: WordBool; safecall;
    function Get_CoolerEnable: WordBool; safecall;
    procedure Set_CoolerEnable(pVal: WordBool); safecall;
    function Get_CoolerStatus: Apn_CoolerStatus; safecall;
    function Get_CoolerSetPoint: Double; safecall;
    procedure Set_CoolerSetPoint(pVal: Double); safecall;
    function Get_CoolerBackoffPoint: Double; safecall;
    procedure Set_CoolerBackoffPoint(pVal: Double); safecall;
    function Get_CoolerDrive: Double; safecall;
    function Get_FanMode: Apn_FanMode; safecall;
    procedure Set_FanMode(pVal: Apn_FanMode); safecall;
    function Get_TempCCD: Double; safecall;
    function Get_TempHeatsink: Double; safecall;
    function Get_Color: WordBool; safecall;
    function Get_GainSixteenBit: Double; safecall;
    function Get_GainTwelveBit: Integer; safecall;
    procedure Set_GainTwelveBit(pVal: Integer); safecall;
    function Get_PixelSizeX: Double; safecall;
    function Get_PixelSizeY: Double; safecall;
    function Get_Sensor: WideString; safecall;
    function Get_SensorTypeCCD: WordBool; safecall;
    function Get_CameraRegister(RegNumber: Integer): Integer; safecall;
    procedure Set_CameraRegister(RegNumber: Integer; pVal: Integer); safecall;
    function Get_Image: OleVariant; safecall;
    function Get_Line: OleVariant; safecall;
    function Get_ConvertShortToLong: WordBool; safecall;
    procedure Set_ConvertShortToLong(pVal: WordBool); safecall;
    function Get_OptionBase: WordBool; safecall;
    procedure Set_OptionBase(pVal: WordBool); safecall;
    property AvailableMemory: Integer read Get_AvailableMemory;
    property CameraInterface: Apn_Interface read Get_CameraInterface;
    property CameraMode: Apn_CameraMode read Get_CameraMode write Set_CameraMode;
    property CameraModel: WideString read Get_CameraModel;
    property DataBits: Apn_Resolution read Get_DataBits write Set_DataBits;
    property DriverVersion: WideString read Get_DriverVersion;
    property FastSequence: WordBool read Get_FastSequence write Set_FastSequence;
    property FirmwareVersion: Integer read Get_FirmwareVersion;
    property ImagingStatus: Apn_Status read Get_ImagingStatus;
    property InputVoltage: Double read Get_InputVoltage;
    property MaxExposure: Double read Get_MaxExposure;
    property MinExposure: Double read Get_MinExposure;
    property NetworkTransferMode: Apn_NetworkMode read Get_NetworkTransferMode write Set_NetworkTransferMode;
    property SerialASupport: WordBool read Get_SerialASupport;
    property SerialBSupport: WordBool read Get_SerialBSupport;
    property DisableShutter: WordBool read Get_DisableShutter write Set_DisableShutter;
    property ExternalIoReadout: WordBool read Get_ExternalIoReadout write Set_ExternalIoReadout;
    property ForceShutterOpen: WordBool read Get_ForceShutterOpen write Set_ForceShutterOpen;
    property ShutterAmpControl: WordBool read Get_ShutterAmpControl write Set_ShutterAmpControl;
    property ShutterState: WordBool read Get_ShutterState;
    property ShutterStrobePeriod: Double read Get_ShutterStrobePeriod write Set_ShutterStrobePeriod;
    property ShutterStrobePosition: Double read Get_ShutterStrobePosition write Set_ShutterStrobePosition;
    property TDICounter: Integer read Get_TDICounter;
    property TDIRate: Double read Get_TDIRate write Set_TDIRate;
    property TDIRows: Integer read Get_TDIRows write Set_TDIRows;
    property ImageCount: Integer read Get_ImageCount write Set_ImageCount;
    property SequenceCounter: Integer read Get_SequenceCounter;
    property SequenceDelay: Double read Get_SequenceDelay write Set_SequenceDelay;
    property VariableSequenceDelay: WordBool read Get_VariableSequenceDelay write Set_VariableSequenceDelay;
    property PhysicalColumns: Integer read Get_PhysicalColumns;
    property PhysicalRows: Integer read Get_PhysicalRows;
    property ImagingColumns: Integer read Get_ImagingColumns;
    property ImagingRows: Integer read Get_ImagingRows;
    property OverscanColumns: Integer read Get_OverscanColumns;
    property DigitizeOverscan: WordBool read Get_DigitizeOverscan write Set_DigitizeOverscan;
    property RoiPixelsH: Integer read Get_RoiPixelsH write Set_RoiPixelsH;
    property RoiPixelsV: Integer read Get_RoiPixelsV write Set_RoiPixelsV;
    property RoiStartX: Integer read Get_RoiStartX write Set_RoiStartX;
    property RoiStartY: Integer read Get_RoiStartY write Set_RoiStartY;
    property MaxBinningH: Integer read Get_MaxBinningH;
    property MaxBinningV: Integer read Get_MaxBinningV;
    property RoiBinningH: Integer read Get_RoiBinningH write Set_RoiBinningH;
    property RoiBinningV: Integer read Get_RoiBinningV write Set_RoiBinningV;
    property LedMode: Apn_LedMode read Get_LedMode write Set_LedMode;
    property LedA: Apn_LedState read Get_LedA write Set_LedA;
    property LedB: Apn_LedState read Get_LedB write Set_LedB;
    property TestLedBrightness: Double read Get_TestLedBrightness write Set_TestLedBrightness;
    property IoPortAssignment: Integer read Get_IoPortAssignment write Set_IoPortAssignment;
    property IoPortDirection: Integer read Get_IoPortDirection write Set_IoPortDirection;
    property IoPortData: Integer read Get_IoPortData write Set_IoPortData;
    property CoolerControl: WordBool read Get_CoolerControl;
    property CoolerRegulated: WordBool read Get_CoolerRegulated;
    property CoolerEnable: WordBool read Get_CoolerEnable write Set_CoolerEnable;
    property CoolerStatus: Apn_CoolerStatus read Get_CoolerStatus;
    property CoolerSetPoint: Double read Get_CoolerSetPoint write Set_CoolerSetPoint;
    property CoolerBackoffPoint: Double read Get_CoolerBackoffPoint write Set_CoolerBackoffPoint;
    property CoolerDrive: Double read Get_CoolerDrive;
    property FanMode: Apn_FanMode read Get_FanMode write Set_FanMode;
    property TempCCD: Double read Get_TempCCD;
    property TempHeatsink: Double read Get_TempHeatsink;
    property Color: WordBool read Get_Color;
    property GainSixteenBit: Double read Get_GainSixteenBit;
    property GainTwelveBit: Integer read Get_GainTwelveBit write Set_GainTwelveBit;
    property PixelSizeX: Double read Get_PixelSizeX;
    property PixelSizeY: Double read Get_PixelSizeY;
    property Sensor: WideString read Get_Sensor;
    property SensorTypeCCD: WordBool read Get_SensorTypeCCD;
    property CameraRegister[RegNumber: Integer]: Integer read Get_CameraRegister write Set_CameraRegister;
    property Image: OleVariant read Get_Image;
    property Line: OleVariant read Get_Line;
    property ConvertShortToLong: WordBool read Get_ConvertShortToLong write Set_ConvertShortToLong;
    property OptionBase: WordBool read Get_OptionBase write Set_OptionBase;
  end;

// *********************************************************************//
// DispIntf:  ICamera2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B7AF5DDD-3281-493D-B28A-434FDBC269D9}
// *********************************************************************//
  ICamera2Disp = dispinterface
    ['{B7AF5DDD-3281-493D-B28A-434FDBC269D9}']
    procedure Init(Interface_: Apn_Interface; CamIdOne: Integer; CamIdTwo: Integer; Option: Integer); dispid 1;
    procedure Expose(Duration: Double; Light: WordBool); dispid 2;
    procedure ResetSystem; dispid 3;
    procedure PauseTimer(PauseState: WordBool); dispid 4;
    procedure StopExposure(DigitizeData: WordBool); dispid 5;
    procedure GetImage(pImageBuffer: Integer); dispid 6;
    procedure GetLine(pLineBuffer: Integer); dispid 7;
    procedure ShowIoDialog; dispid 8;
    procedure ShowLedDialog; dispid 9;
    procedure ShowTempDialog; dispid 10;
    property AvailableMemory: Integer readonly dispid 11;
    property CameraInterface: Apn_Interface readonly dispid 12;
    property CameraMode: Apn_CameraMode dispid 13;
    property CameraModel: WideString readonly dispid 14;
    property DataBits: Apn_Resolution dispid 15;
    property DriverVersion: WideString readonly dispid 16;
    property FastSequence: WordBool dispid 17;
    property FirmwareVersion: Integer readonly dispid 18;
    property ImagingStatus: Apn_Status readonly dispid 19;
    property InputVoltage: Double readonly dispid 20;
    property MaxExposure: Double readonly dispid 21;
    property MinExposure: Double readonly dispid 22;
    property NetworkTransferMode: Apn_NetworkMode dispid 23;
    property SerialASupport: WordBool readonly dispid 24;
    property SerialBSupport: WordBool readonly dispid 25;
    property DisableShutter: WordBool dispid 26;
    property ExternalIoReadout: WordBool dispid 27;
    property ForceShutterOpen: WordBool dispid 28;
    property ShutterAmpControl: WordBool dispid 29;
    property ShutterState: WordBool readonly dispid 30;
    property ShutterStrobePeriod: Double dispid 31;
    property ShutterStrobePosition: Double dispid 32;
    property TDICounter: Integer readonly dispid 33;
    property TDIRate: Double dispid 34;
    property TDIRows: Integer dispid 35;
    property ImageCount: Integer dispid 36;
    property SequenceCounter: Integer readonly dispid 37;
    property SequenceDelay: Double dispid 38;
    property VariableSequenceDelay: WordBool dispid 39;
    property PhysicalColumns: Integer readonly dispid 40;
    property PhysicalRows: Integer readonly dispid 41;
    property ImagingColumns: Integer readonly dispid 42;
    property ImagingRows: Integer readonly dispid 43;
    property OverscanColumns: Integer readonly dispid 44;
    property DigitizeOverscan: WordBool dispid 45;
    property RoiPixelsH: Integer dispid 46;
    property RoiPixelsV: Integer dispid 47;
    property RoiStartX: Integer dispid 48;
    property RoiStartY: Integer dispid 49;
    property MaxBinningH: Integer readonly dispid 50;
    property MaxBinningV: Integer readonly dispid 51;
    property RoiBinningH: Integer dispid 52;
    property RoiBinningV: Integer dispid 53;
    property LedMode: Apn_LedMode dispid 54;
    property LedA: Apn_LedState dispid 55;
    property LedB: Apn_LedState dispid 56;
    property TestLedBrightness: Double dispid 57;
    property IoPortAssignment: Integer dispid 58;
    property IoPortDirection: Integer dispid 59;
    property IoPortData: Integer dispid 60;
    property CoolerControl: WordBool readonly dispid 61;
    property CoolerRegulated: WordBool readonly dispid 62;
    property CoolerEnable: WordBool dispid 63;
    property CoolerStatus: Apn_CoolerStatus readonly dispid 64;
    property CoolerSetPoint: Double dispid 65;
    property CoolerBackoffPoint: Double dispid 66;
    property CoolerDrive: Double readonly dispid 67;
    property FanMode: Apn_FanMode dispid 68;
    property TempCCD: Double readonly dispid 69;
    property TempHeatsink: Double readonly dispid 70;
    property Color: WordBool readonly dispid 71;
    property GainSixteenBit: Double readonly dispid 72;
    property GainTwelveBit: Integer dispid 73;
    property PixelSizeX: Double readonly dispid 74;
    property PixelSizeY: Double readonly dispid 75;
    property Sensor: WideString readonly dispid 76;
    property SensorTypeCCD: WordBool readonly dispid 77;
    property CameraRegister[RegNumber: Integer]: Integer dispid 78;
    property Image: OleVariant readonly dispid 79;
    property Line: OleVariant readonly dispid 80;
    property ConvertShortToLong: WordBool dispid 81;
    property OptionBase: WordBool dispid 82;
  end;

// *********************************************************************//
// Interface: ICamDiscover
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {66FCB019-20D1-41CA-B400-D0D82ECA5A67}
// *********************************************************************//
  ICamDiscover = interface(IDispatch)
    ['{66FCB019-20D1-41CA-B400-D0D82ECA5A67}']
    procedure ShowDialog(Interactive: WordBool); safecall;
    function Get_DlgCheckUsb: WordBool; safecall;
    procedure Set_DlgCheckUsb(pVal: WordBool); safecall;
    function Get_DlgCheckEthernet: WordBool; safecall;
    procedure Set_DlgCheckEthernet(pVal: WordBool); safecall;
    function Get_DlgNetworkMask: Integer; safecall;
    procedure Set_DlgNetworkMask(pVal: Integer); safecall;
    function Get_ValidSelection: WordBool; safecall;
    function Get_SelectedInterface: Apn_Interface; safecall;
    function Get_SelectedCamIdOne: Integer; safecall;
    function Get_SelectedCamIdTwo: Integer; safecall;
    function Get_SelectedModel: WideString; safecall;
    function Get_DlgTitleBarText: WideString; safecall;
    procedure Set_DlgTitleBarText(const pVal: WideString); safecall;
    function Get_DlgShowUsb: WordBool; safecall;
    procedure Set_DlgShowUsb(pVal: WordBool); safecall;
    function Get_DlgShowEthernet: WordBool; safecall;
    procedure Set_DlgShowEthernet(pVal: WordBool); safecall;
    property DlgCheckUsb: WordBool read Get_DlgCheckUsb write Set_DlgCheckUsb;
    property DlgCheckEthernet: WordBool read Get_DlgCheckEthernet write Set_DlgCheckEthernet;
    property DlgNetworkMask: Integer read Get_DlgNetworkMask write Set_DlgNetworkMask;
    property ValidSelection: WordBool read Get_ValidSelection;
    property SelectedInterface: Apn_Interface read Get_SelectedInterface;
    property SelectedCamIdOne: Integer read Get_SelectedCamIdOne;
    property SelectedCamIdTwo: Integer read Get_SelectedCamIdTwo;
    property SelectedModel: WideString read Get_SelectedModel;
    property DlgTitleBarText: WideString read Get_DlgTitleBarText write Set_DlgTitleBarText;
    property DlgShowUsb: WordBool read Get_DlgShowUsb write Set_DlgShowUsb;
    property DlgShowEthernet: WordBool read Get_DlgShowEthernet write Set_DlgShowEthernet;
  end;

// *********************************************************************//
// DispIntf:  ICamDiscoverDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {66FCB019-20D1-41CA-B400-D0D82ECA5A67}
// *********************************************************************//
  ICamDiscoverDisp = dispinterface
    ['{66FCB019-20D1-41CA-B400-D0D82ECA5A67}']
    procedure ShowDialog(Interactive: WordBool); dispid 1;
    property DlgCheckUsb: WordBool dispid 2;
    property DlgCheckEthernet: WordBool dispid 3;
    property DlgNetworkMask: Integer dispid 4;
    property ValidSelection: WordBool readonly dispid 5;
    property SelectedInterface: Apn_Interface readonly dispid 6;
    property SelectedCamIdOne: Integer readonly dispid 7;
    property SelectedCamIdTwo: Integer readonly dispid 8;
    property SelectedModel: WideString readonly dispid 9;
    property DlgTitleBarText: WideString dispid 10;
    property DlgShowUsb: WordBool dispid 11;
    property DlgShowEthernet: WordBool dispid 12;
  end;

// *********************************************************************//
// The Class CoCamera provides a Create and CreateRemote method to          
// create instances of the default interface ICamera exposed by              
// the CoClass Camera. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCamera = class
    class function Create: ICamera;
    class function CreateRemote(const MachineName: string): ICamera;
  end;

// *********************************************************************//
// The Class CoCamera2 provides a Create and CreateRemote method to          
// create instances of the default interface ICamera2 exposed by              
// the CoClass Camera2. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCamera2 = class
    class function Create: ICamera2;
    class function CreateRemote(const MachineName: string): ICamera2;
  end;

// *********************************************************************//
// The Class CoCamDiscover provides a Create and CreateRemote method to          
// create instances of the default interface ICamDiscover exposed by              
// the CoClass CamDiscover. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCamDiscover = class
    class function Create: ICamDiscover;
    class function CreateRemote(const MachineName: string): ICamDiscover;
  end;

implementation

uses ComObj;

class function CoCamera.Create: ICamera;
begin
  Result := CreateComObject(CLASS_Camera) as ICamera;
end;

class function CoCamera.CreateRemote(const MachineName: string): ICamera;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Camera) as ICamera;
end;

class function CoCamera2.Create: ICamera2;
begin
  Result := CreateComObject(CLASS_Camera2) as ICamera2;
end;

class function CoCamera2.CreateRemote(const MachineName: string): ICamera2;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Camera2) as ICamera2;
end;

class function CoCamDiscover.Create: ICamDiscover;
begin
  Result := CreateComObject(CLASS_CamDiscover) as ICamDiscover;
end;

class function CoCamDiscover.CreateRemote(const MachineName: string): ICamDiscover;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CamDiscover) as ICamDiscover;
end;

end.
