object MainWindow: TMainWindow
  Left = 183
  Top = 38
  HorzScrollBar.Style = ssFlat
  HorzScrollBar.Tracking = True
  VertScrollBar.Style = ssFlat
  VertScrollBar.Tracking = True
  AlphaBlend = True
  Caption = 'SUMDD'
  ClientHeight = 420
  ClientWidth = 484
  Color = clBtnFace
  DefaultMonitor = dmPrimary
  DockSite = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIForm
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000010000000000000000000
    0000000080000080000000808000800000008000800080800000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000200000022000000000000000000000002000
    000AA20000000000000000000000000000022000000000000000000000000000
    0000000000000000000000000000000000000000AAAAA0000000000000000000
    0000000AA0000AA00000000000000000000000AA000000AA0000000000000000
    000000AA0000000A0000000000000000000000AA0000000AA00000000000A200
    000000000000000AA00000000000A220000000000000000AA00000000000AAA2
    00000000000000AAA0000000000022200000000000000AAA0000000000000AA0
    000000000000AAA00000000000000220000000000000AAA00000000000000002
    20000000000AAA00000000000000000220000000000AA0000000000000000000
    00000000000AA0000A0000000000000000000000000AA0000A00000000000000
    000000000000A0000A000200000000000000000000000A000AA0022000000000
    00000000000000AAAAA000000000000000000000000000000000000000000000
    00000000000000022000000000000000000000000000002AA200000000000000
    000000000000002AAA20000000000000000000000000000AAA20000000000000
    0000000000200000220000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000}
  Menu = MainMenu
  OldCreateOrder = False
  Position = poDesigned
  PrintScale = poNone
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 484
    Height = 21
    Caption = 'ToolBar1'
    TabOrder = 0
  end
  object SBMainWindow: TStatusBar
    Left = 0
    Top = 401
    Width = 484
    Height = 19
    Panels = <
      item
        Text = 'Memoria Total:'
        Width = 200
      end
      item
        Text = 'Memoria Libre:'
        Width = 50
      end>
  end
  object MainMenu: TMainMenu
    Left = 200
    Top = 27
    object MMFile: TMenuItem
      Caption = 'Archivo'
      object MMFClose: TMenuItem
        Caption = 'Cerrar'
        OnClick = MMFCloseClick
      end
    end
    object MMAcquisition: TMenuItem
      Caption = 'Adquisici'#243'n'
      object MMAImage: TMenuItem
        Caption = 'Imagen'
        OnClick = MMAImageClick
      end
      object MMAVolumeSectioning: TMenuItem
        Caption = 'Seccionamiento Volumen'
        OnClick = MMAVolumeSectioningClick
      end
      object MATimeLapse: TMenuItem
        Caption = 'Time Lapse'
        OnClick = MATimeLapseClick
      end
    end
    object MMTools: TMenuItem
      Caption = 'Herramientas'
      object MMTTemperatureControl: TMenuItem
        Caption = 'Control de Temperatura'
        OnClick = MMTTemperatureControlClick
      end
      object MMTControlOptions: TMenuItem
        Caption = 'Opciones de Control'
        OnClick = MMTControlOptionsClick
      end
      object MMTCalibrateUVMonitor: TMenuItem
        Caption = 'Calibrar monitor de luz UV'
        OnClick = MMTCalibrateUVMonitorClick
      end
    end
    object MMHelp: TMenuItem
      Caption = 'Ayuda'
      object MMHAbout: TMenuItem
        Caption = 'Acerca de SUMDD'
        OnClick = MMHAboutClick
      end
    end
  end
  object ODLoadSections: TOpenDialog
    Filter = 
      'sdf (Sectioning Data File)|*.sdf|tif, tiff (Tagged Image File Fo' +
      'rmat )|*.tif;*.tiff|Archivo de texto|*.txt'
    FilterIndex = 2
    Left = 232
    Top = 27
  end
  object OPDLoadImage: TOpenPictureDialog
    Left = 264
    Top = 27
  end
  object TimerUpDate: TTimer
    OnTimer = TimerUpDateTimer
    Left = 165
    Top = 27
  end
end
