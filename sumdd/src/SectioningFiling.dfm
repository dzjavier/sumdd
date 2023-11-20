object FSectioning: TFSectioning
  Left = 195
  Top = 245
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Seccionamiento'
  ClientHeight = 223
  ClientWidth = 375
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
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
  OldCreateOrder = False
  Position = poScreenCenter
  PrintScale = poNone
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PData: TPanel
    Left = 0
    Top = 0
    Width = 375
    Height = 223
    BorderStyle = bsSingle
    TabOrder = 0
    object SBCancel: TSpeedButton
      Left = 234
      Top = 179
      Width = 65
      Height = 34
      Caption = 'Cerrar'
      ParentShowHint = False
      ShowHint = True
      OnClick = SBCancelClick
    end
    object GBSpecimen: TGroupBox
      Left = 2
      Top = 35
      Width = 367
      Height = 140
      TabOrder = 1
      object LTime: TLabel
        Left = 181
        Top = 66
        Width = 104
        Height = 13
        Caption = 'T. de Exposici'#243'n [ms]:'
        ParentShowHint = False
        ShowHint = True
      end
      object LResY: TLabel
        Left = 15
        Top = 41
        Width = 62
        Height = 13
        Hint = 'Fijar la dimensi'#243'n Y, vertical.'
        Caption = 'Dimensi'#243'n Y:'
        ParentShowHint = False
        ShowHint = True
      end
      object LDeltaZ: TLabel
        Left = 227
        Top = 15
        Width = 58
        Height = 13
        Hint = 'Valor negativo desplaza platina hacia arriba.'
        Caption = 'Delta Z[um]:'
        ParentShowHint = False
        ShowHint = True
      end
      object LDeltaT: TLabel
        Left = 236
        Top = 39
        Width = 49
        Height = 13
        Hint = 'Fijar tiempo de espera entre im'#225'genes.'
        Caption = 'Delta T[s]:'
        Enabled = False
        ParentShowHint = False
        ShowHint = True
      end
      object LSpeed: TLabel
        Left = 180
        Top = 117
        Width = 100
        Height = 13
        Caption = 'Velocidad [Micras/s]:'
        ParentShowHint = False
        ShowHint = True
      end
      object LResX: TLabel
        Left = 15
        Top = 17
        Width = 62
        Height = 13
        Hint = 'Fijar la dimensi'#243'n X, horizontal.'
        Caption = 'Dimensi'#243'n X:'
        ParentShowHint = False
        ShowHint = True
      end
      object LZDim: TLabel
        Left = 15
        Top = 64
        Width = 62
        Height = 13
        Hint = 'Fijar la dimensi'#243'n Z, profundidad.'
        Caption = 'Dimensi'#243'n Z:'
        ParentShowHint = False
        ShowHint = True
      end
      object LTDim: TLabel
        Left = 15
        Top = 87
        Width = 62
        Height = 13
        Hint = 'Fijar la dimensi'#243'n T, tiempo.'
        Caption = 'Dimensi'#243'n T:'
        Enabled = False
        ParentShowHint = False
        ShowHint = True
      end
      object LNumberOfCapture: TLabel
        Left = 215
        Top = 87
        Width = 71
        Height = 13
        Hint = 'N'#250'mero de captura a promediar.'
        Caption = 'N'#176'de capturas:'
        ParentShowHint = False
        ShowHint = True
      end
      object EExpositionTime: TEdit
        Left = 291
        Top = 64
        Width = 58
        Height = 21
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
      end
      object EDeltaT: TEdit
        Left = 291
        Top = 37
        Width = 58
        Height = 21
        Hint = 'Fijar tiempo de espera entre im'#225'genes.'
        Enabled = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        Text = '10'
      end
      object EYDimension: TEdit
        Left = 80
        Top = 37
        Width = 58
        Height = 21
        Hint = 'Fijar la dimensi'#243'n Y, vertical.'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
      end
      object EDeltaZ: TEdit
        Left = 291
        Top = 12
        Width = 58
        Height = 21
        Hint = 'Valor negativo desplaza platina hacia arriba.'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
      end
      object CBSpeed: TComboBox
        Left = 284
        Top = 113
        Width = 55
        Height = 21
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        Items.Strings = (
          '1'
          '2'
          '3')
      end
      object CBLightLevel: TCheckBox
        Left = 54
        Top = 119
        Width = 106
        Height = 10
        Hint = 
          'Mide el nivel de luz de la l'#225'mpara de exitaci'#243'n de fluorescencia' +
          '.'
        Caption = 'Medir nivel de luz'
        Enabled = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
      end
      object EXDimension: TEdit
        Left = 80
        Top = 12
        Width = 58
        Height = 21
        Hint = 'Fijar la dimensi'#243'n X, horizontal.'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 6
      end
      object EZDimension: TEdit
        Left = 80
        Top = 61
        Width = 58
        Height = 21
        Hint = 'Fijar la dimensi'#243'n Z, profundidad.'
        TabOrder = 7
      end
      object ETDimension: TEdit
        Left = 80
        Top = 86
        Width = 58
        Height = 21
        Hint = 'Fijar la dimensi'#243'n T, tiempo.'
        Enabled = False
        TabOrder = 8
      end
      object ECaptureNumber: TEdit
        Left = 291
        Top = 86
        Width = 58
        Height = 21
        Hint = 'N'#250'mero de captura a promediar.'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 9
      end
    end
    object BBSaveData: TBitBtn
      Left = 66
      Top = 179
      Width = 83
      Height = 34
      Caption = 'Guardar Datos'
      Enabled = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = BBSaveDataClick
    end
    object BBSection: TBitBtn
      Left = 160
      Top = 179
      Width = 68
      Height = 34
      Hint = 'Valores negativos mueve platina hacia arriba y viceversa'
      Caption = 'Seccionar'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = BBSectionClick
    end
    object GBCaptureModeSelection: TGroupBox
      Left = 2
      Top = -3
      Width = 367
      Height = 43
      TabOrder = 3
      object RBOpticalSectioning: TRadioButton
        Left = 40
        Top = 16
        Width = 149
        Height = 14
        Caption = 'Seccionamiento '#243'ptico'
        Checked = True
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        TabStop = True
        OnClick = RBOpticalSectioningClick
      end
      object RBTimeLapse: TRadioButton
        Left = 206
        Top = 16
        Width = 113
        Height = 17
        Caption = 'Time Lapse'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = RBTimeLapseClick
      end
    end
    object BImageTest: TButton
      Left = 307
      Top = 184
      Width = 51
      Height = 25
      Caption = 'Test'
      TabOrder = 4
      OnClick = BImageTestClick
    end
  end
  object SaveDialog1: TSaveDialog
    Filter = 
      'Tagged image file format (tif,tiff)|*.tiff;*.tif|OME TIFF|*.ome.' +
      'tif;*.ome.tiff'
    Left = 32
    Top = 184
  end
end
