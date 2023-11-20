object FColoc2D: TFColoc2D
  Left = 356
  Top = 181
  BorderStyle = bsSingle
  Caption = 'Colocalizaci'#243'n 2D'
  ClientHeight = 392
  ClientWidth = 435
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
  Visible = True
  OnCreate = FormCreate
  DesignSize = (
    435
    392)
  PixelsPerInch = 96
  TextHeight = 13
  object PChs: TPanel
    Left = 0
    Top = 197
    Width = 431
    Height = 165
    Anchors = [akLeft, akRight, akBottom]
    BorderStyle = bsSingle
    TabOrder = 0
    DesignSize = (
      427
      161)
    object LIntCh1: TLabel
      Left = 20
      Top = 79
      Width = 74
      Height = 13
      Caption = 'Canal1 [R,G,B]:'
    end
    object LIntCh2: TLabel
      Left = 261
      Top = 79
      Width = 77
      Height = 13
      Anchors = [akTop, akRight]
      Caption = 'Canal 2 [R,G,B]:'
      ExplicitLeft = 269
    end
    object LFileNameCh1: TLabel
      Left = 11
      Top = 9
      Width = 75
      Height = 13
      Caption = 'Archivo Canal1:'
    end
    object LFileNameCh2: TLabel
      Left = 218
      Top = 9
      Width = 75
      Height = 13
      Anchors = [akTop, akRight]
      Caption = 'Archivo Canal2:'
      ExplicitLeft = 226
    end
    object LMinIntensityCh1: TLabel
      Left = 17
      Top = 113
      Width = 106
      Height = 13
      Caption = 'Intensidad M'#237'nima C1:'
    end
    object LMaxIntensityCh1: TLabel
      Left = 14
      Top = 136
      Width = 107
      Height = 13
      Caption = 'Intensidad M'#225'xima C1:'
    end
    object LMinIntensityCh2: TLabel
      Left = 237
      Top = 113
      Width = 106
      Height = 13
      Anchors = [akTop, akRight]
      Caption = 'Intensidad M'#237'nima C2:'
      ExplicitLeft = 245
    end
    object LMaxIntensityCh2: TLabel
      Left = 233
      Top = 136
      Width = 107
      Height = 13
      Anchors = [akTop, akRight]
      Caption = 'Intensidad M'#225'xima C2:'
      ExplicitLeft = 241
    end
    object BLoadCH1: TButton
      Left = 11
      Top = 36
      Width = 61
      Height = 26
      Hint = 'Cargar Canal 1'
      Caption = 'Cargar C1'
      TabOrder = 0
      OnClick = BLoadCH1Click
    end
    object BuBloadCH2: TButton
      Left = 350
      Top = 37
      Width = 60
      Height = 26
      Hint = 'Cargar Canal 2'
      Anchors = [akTop, akRight]
      Caption = 'Cargar C2'
      TabOrder = 1
      OnClick = BuBloadCH2Click
      ExplicitLeft = 358
    end
    object CBCh1Red: TCheckBox
      Left = 81
      Top = 25
      Width = 79
      Height = 15
      Caption = 'C1 Rojo'
      Checked = True
      State = cbChecked
      TabOrder = 2
      OnClick = CBCh1RedClick
    end
    object CBCh1Green: TCheckBox
      Left = 81
      Top = 38
      Width = 79
      Height = 14
      Caption = 'C1 Verde'
      Checked = True
      State = cbChecked
      TabOrder = 3
      OnClick = CBCh1GreenClick
    end
    object CBCh1Blue: TCheckBox
      Left = 81
      Top = 52
      Width = 79
      Height = 14
      Caption = 'C1 Azul'
      Checked = True
      State = cbChecked
      TabOrder = 4
      OnClick = CBCh1BlueClick
    end
    object CbCh2Red: TCheckBox
      Left = 287
      Top = 28
      Width = 54
      Height = 13
      Alignment = taLeftJustify
      Anchors = [akTop, akRight]
      Caption = 'C2 Rojo'
      Checked = True
      State = cbChecked
      TabOrder = 5
      OnClick = CbCh2RedClick
      ExplicitLeft = 295
    end
    object CBCh2Green: TCheckBox
      Left = 280
      Top = 42
      Width = 61
      Height = 12
      Alignment = taLeftJustify
      Anchors = [akTop, akRight]
      Caption = 'C2 Verde'
      Checked = True
      State = cbChecked
      TabOrder = 6
      OnClick = CBCh2GreenClick
      ExplicitLeft = 288
    end
    object CBCh2Blue: TCheckBox
      Left = 289
      Top = 55
      Width = 52
      Height = 12
      Alignment = taLeftJustify
      Anchors = [akTop, akRight]
      Caption = 'C2 Azul'
      Checked = True
      State = cbChecked
      TabOrder = 7
      OnClick = CBCh2BlueClick
      ExplicitLeft = 297
    end
    object EIntCh1: TEdit
      Left = 97
      Top = 76
      Width = 62
      Height = 24
      Color = clInactiveCaptionText
      ReadOnly = True
      TabOrder = 8
      Text = '[0,0,0]'
    end
    object EIntCh2: TEdit
      Left = 342
      Top = 76
      Width = 63
      Height = 24
      Anchors = [akTop, akRight]
      Color = clInactiveCaptionText
      ReadOnly = True
      TabOrder = 9
      Text = '[0,0,0]'
      ExplicitLeft = 350
    end
    object MEMinIntensityCh1: TMaskEdit
      Left = 124
      Top = 110
      Width = 39
      Height = 24
      MaxLength = 3
      TabOrder = 10
      Text = '0'
      OnKeyDown = MEMinIntensityCh1KeyDown
    end
    object MEMaxIntensityCh1: TMaskEdit
      Left = 124
      Top = 132
      Width = 39
      Height = 24
      TabOrder = 11
      Text = '255'
      OnKeyDown = MEMaxIntensityCh1KeyDown
    end
    object MEMinIntensityCh2: TMaskEdit
      Left = 343
      Top = 110
      Width = 39
      Height = 24
      Anchors = [akTop, akRight]
      TabOrder = 12
      Text = '0'
      OnKeyDown = MEMinIntensityCh2KeyDown
      ExplicitLeft = 351
    end
    object MEMaxIntensityCh2: TMaskEdit
      Left = 343
      Top = 132
      Width = 39
      Height = 24
      Anchors = [akTop, akRight]
      TabOrder = 13
      Text = '255'
      OnKeyDown = MEMaxIntensityCh2KeyDown
      ExplicitLeft = 351
    end
    object UDMinIntensityCh1: TUpDown
      Left = 163
      Top = 110
      Width = 15
      Height = 19
      Associate = MEMinIntensityCh1
      Max = 255
      TabOrder = 14
      OnChangingEx = UDMinIntensityCh1ChangingEx
      OnClick = UDMinIntensityCh1Click
    end
    object UDMaxIntensityCh1: TUpDown
      Left = 163
      Top = 132
      Width = 15
      Height = 20
      Associate = MEMaxIntensityCh1
      Max = 255
      Position = 255
      TabOrder = 15
      OnChangingEx = UDMaxIntensityCh1ChangingEx
      OnClick = UDMaxIntensityCh1Click
    end
    object UDMinIntensityCh2: TUpDown
      Left = 382
      Top = 110
      Width = 15
      Height = 19
      Anchors = [akTop, akRight]
      Associate = MEMinIntensityCh2
      Max = 255
      TabOrder = 16
      OnChangingEx = UDMinIntensityCh2ChangingEx
      OnClick = UDMinIntensityCh2Click
      ExplicitLeft = 390
    end
    object UDMaxIntensityCh2: TUpDown
      Left = 382
      Top = 132
      Width = 15
      Height = 20
      Anchors = [akTop, akRight]
      Associate = MEMaxIntensityCh2
      Max = 255
      Position = 255
      TabOrder = 17
      OnChangingEx = UDMaxIntensityCh2ChangingEx
      OnClick = UDMaxIntensityCh2Click
      ExplicitLeft = 390
    end
  end
  object BColoc: TButton
    Left = 349
    Top = 365
    Width = 78
    Height = 25
    Anchors = [akBottom]
    Caption = 'Colocalizar'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = BColocClick
  end
  object OPDColoc2D: TOpenPictureDialog
    Left = 6
    Top = 95
  end
end
