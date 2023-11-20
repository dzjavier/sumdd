object FColoc2D: TFColoc2D
  Left = 356
  Top = 181
  BorderStyle = bsSingle
  Caption = 'Colocalizaci'#243'n 2D'
  ClientHeight = 483
  ClientWidth = 535
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
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
  Visible = True
  OnCreate = FormCreate
  OnResize = FormResize
  DesignSize = (
    535
    483)
  PixelsPerInch = 120
  TextHeight = 16
  object ImViewLayerCH2: TImgView32
    Left = 265
    Top = 0
    Width = 265
    Height = 240
    Hint = 'Canal 2'
    Anchors = [akLeft, akTop, akRight, akBottom]
    Centered = False
    ParentShowHint = False
    Scale = 1
    ScrollBars.Color = clScrollBar
    ScrollBars.ShowHandleGrip = True
    ScrollBars.Style = rbsDefault
    ShowHint = True
    SizeGrip = sgAuto
    TabOrder = 0
    OnMouseMove = ImViewLayerCH2MouseMove
  end
  object ImViewLayerCH1: TImgView32
    Left = 1
    Top = 0
    Width = 262
    Height = 240
    Hint = 'Canal 1'
    Anchors = [akLeft, akTop, akRight, akBottom]
    Centered = False
    ParentShowHint = False
    Scale = 1
    ScrollBars.Color = clScrollBar
    ScrollBars.ShowHandleGrip = True
    ScrollBars.Style = rbsDefault
    ShowHint = True
    SizeGrip = sgAuto
    TabOrder = 1
    OnMouseMove = ImViewLayerCH1MouseMove
  end
  object PChs: TPanel
    Left = 0
    Top = 242
    Width = 530
    Height = 203
    Anchors = [akLeft, akRight, akBottom]
    BorderStyle = bsSingle
    TabOrder = 2
    DesignSize = (
      526
      199)
    object LIntCh1: TLabel
      Left = 25
      Top = 97
      Width = 91
      Height = 16
      Caption = 'Canal1 [R,G,B]:'
    end
    object LIntCh2: TLabel
      Left = 331
      Top = 97
      Width = 94
      Height = 16
      Anchors = [akTop, akRight]
      Caption = 'Canal 2 [R,G,B]:'
    end
    object LFileNameCh1: TLabel
      Left = 13
      Top = 11
      Width = 93
      Height = 16
      Caption = 'Archivo Canal1:'
    end
    object LFileNameCh2: TLabel
      Left = 278
      Top = 11
      Width = 93
      Height = 16
      Anchors = [akTop, akRight]
      Caption = 'Archivo Canal2:'
    end
    object LMinIntensityCh1: TLabel
      Left = 21
      Top = 139
      Width = 130
      Height = 16
      Caption = 'Intensidad M'#237'nima C1:'
    end
    object LMaxIntensityCh1: TLabel
      Left = 17
      Top = 167
      Width = 134
      Height = 16
      Caption = 'Intensidad M'#225'xima C1:'
    end
    object LMinIntensityCh2: TLabel
      Left = 301
      Top = 139
      Width = 130
      Height = 16
      Anchors = [akTop, akRight]
      Caption = 'Intensidad M'#237'nima C2:'
    end
    object LMaxIntensityCh2: TLabel
      Left = 297
      Top = 167
      Width = 134
      Height = 16
      Anchors = [akTop, akRight]
      Caption = 'Intensidad M'#225'xima C2:'
    end
    object BLoadCH1: TButton
      Left = 13
      Top = 44
      Width = 75
      Height = 32
      Hint = 'Cargar Canal 1'
      Caption = 'Cargar C1'
      TabOrder = 0
      OnClick = BLoadCH1Click
    end
    object BuBloadCH2: TButton
      Left = 440
      Top = 46
      Width = 75
      Height = 32
      Hint = 'Cargar Canal 2'
      Anchors = [akTop, akRight]
      Caption = 'Cargar C2'
      TabOrder = 1
      OnClick = BuBloadCH2Click
    end
    object CBCh1Red: TCheckBox
      Left = 100
      Top = 31
      Width = 97
      Height = 18
      Caption = 'C1 Rojo'
      Checked = True
      State = cbChecked
      TabOrder = 2
      OnClick = CBCh1RedClick
    end
    object CBCh1Green: TCheckBox
      Left = 100
      Top = 47
      Width = 97
      Height = 17
      Caption = 'C1 Verde'
      Checked = True
      State = cbChecked
      TabOrder = 3
      OnClick = CBCh1GreenClick
    end
    object CBCh1Blue: TCheckBox
      Left = 100
      Top = 64
      Width = 97
      Height = 17
      Caption = 'C1 Azul'
      Checked = True
      State = cbChecked
      TabOrder = 4
      OnClick = CBCh1BlueClick
    end
    object CbCh2Red: TCheckBox
      Left = 363
      Top = 35
      Width = 67
      Height = 16
      Alignment = taLeftJustify
      Anchors = [akTop, akRight]
      Caption = 'C2 Rojo'
      Checked = True
      State = cbChecked
      TabOrder = 5
      OnClick = CbCh2RedClick
    end
    object CBCh2Green: TCheckBox
      Left = 355
      Top = 52
      Width = 75
      Height = 14
      Alignment = taLeftJustify
      Anchors = [akTop, akRight]
      Caption = 'C2 Verde'
      Checked = True
      State = cbChecked
      TabOrder = 6
      OnClick = CBCh2GreenClick
    end
    object CBCh2Blue: TCheckBox
      Left = 366
      Top = 68
      Width = 64
      Height = 15
      Alignment = taLeftJustify
      Anchors = [akTop, akRight]
      Caption = 'C2 Azul'
      Checked = True
      State = cbChecked
      TabOrder = 7
      OnClick = CBCh2BlueClick
    end
    object EIntCh1: TEdit
      Left = 119
      Top = 94
      Width = 77
      Height = 24
      Color = clInactiveCaptionText
      ReadOnly = True
      TabOrder = 8
      Text = '[0,0,0]'
    end
    object EIntCh2: TEdit
      Left = 431
      Top = 93
      Width = 77
      Height = 24
      Anchors = [akTop, akRight]
      Color = clInactiveCaptionText
      ReadOnly = True
      TabOrder = 9
      Text = '[0,0,0]'
    end
    object MEMinIntensityCh1: TMaskEdit
      Left = 152
      Top = 135
      Width = 48
      Height = 24
      MaxLength = 3
      TabOrder = 10
      Text = '0'
      OnKeyDown = MEMinIntensityCh1KeyDown
    end
    object MEMaxIntensityCh1: TMaskEdit
      Left = 152
      Top = 163
      Width = 48
      Height = 24
      TabOrder = 11
      Text = '255'
      OnKeyDown = MEMaxIntensityCh1KeyDown
    end
    object MEMinIntensityCh2: TMaskEdit
      Left = 432
      Top = 135
      Width = 48
      Height = 24
      Anchors = [akTop, akRight]
      TabOrder = 12
      Text = '0'
      OnKeyDown = MEMinIntensityCh2KeyDown
    end
    object MEMaxIntensityCh2: TMaskEdit
      Left = 432
      Top = 163
      Width = 48
      Height = 24
      Anchors = [akTop, akRight]
      TabOrder = 13
      Text = '255'
      OnKeyDown = MEMaxIntensityCh2KeyDown
    end
    object UDMinIntensityCh1: TUpDown
      Left = 200
      Top = 135
      Width = 19
      Height = 24
      Associate = MEMinIntensityCh1
      Min = 0
      Max = 255
      Position = 0
      TabOrder = 14
      Wrap = False
      OnChangingEx = UDMinIntensityCh1ChangingEx
      OnClick = UDMinIntensityCh1Click
    end
    object UDMaxIntensityCh1: TUpDown
      Left = 200
      Top = 163
      Width = 19
      Height = 24
      Associate = MEMaxIntensityCh1
      Min = 0
      Max = 255
      Position = 255
      TabOrder = 15
      Wrap = False
      OnChangingEx = UDMaxIntensityCh1ChangingEx
      OnClick = UDMaxIntensityCh1Click
    end
    object UDMinIntensityCh2: TUpDown
      Left = 480
      Top = 135
      Width = 19
      Height = 24
      Anchors = [akTop, akRight]
      Associate = MEMinIntensityCh2
      Min = 0
      Max = 255
      Position = 0
      TabOrder = 16
      Wrap = False
      OnChangingEx = UDMinIntensityCh2ChangingEx
      OnClick = UDMinIntensityCh2Click
    end
    object UDMaxIntensityCh2: TUpDown
      Left = 480
      Top = 163
      Width = 19
      Height = 24
      Anchors = [akTop, akRight]
      Associate = MEMaxIntensityCh2
      Min = 0
      Max = 255
      Position = 255
      TabOrder = 17
      Wrap = False
      OnChangingEx = UDMaxIntensityCh2ChangingEx
      OnClick = UDMaxIntensityCh2Click
    end
  end
  object BColoc: TButton
    Left = 429
    Top = 449
    Width = 96
    Height = 31
    Anchors = [akBottom]
    Caption = 'Colocalizar'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = BColocClick
  end
  object OPDColoc2D: TOpenPictureDialog
    Left = 6
    Top = 95
  end
end
