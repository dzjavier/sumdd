object FViewSection: TFViewSection
  Left = 356
  Top = 193
  BorderStyle = bsSingle
  Caption = 'Secci'#243'n:'
  ClientHeight = 416
  ClientWidth = 530
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
    530
    416)
  PixelsPerInch = 120
  TextHeight = 16
  object PInfo: TPanel
    Left = 1
    Top = 247
    Width = 259
    Height = 166
    Alignment = taRightJustify
    Anchors = [akLeft, akBottom]
    BevelInner = bvRaised
    BevelOuter = bvNone
    BorderStyle = bsSingle
    UseDockManager = False
    DockSite = True
    Locked = True
    TabOrder = 0
    object LXY: TLabel
      Left = 16
      Top = 63
      Width = 106
      Height = 16
      Caption = 'Posici'#243'n [micras]:'
    end
    object LIntRaw: TLabel
      Left = 19
      Top = 94
      Width = 104
      Height = 16
      Caption = 'Intensidad Cruda:'
    end
    object LIntDeconv: TLabel
      Left = 5
      Top = 123
      Width = 119
      Height = 16
      Caption = 'Int. Desconvoluci'#243'n:'
    end
    object EXY: TEdit
      Left = 130
      Top = 59
      Width = 122
      Height = 24
      BevelInner = bvNone
      BevelKind = bkFlat
      ReadOnly = True
      TabOrder = 0
    end
    object EIntRaw: TEdit
      Left = 131
      Top = 89
      Width = 100
      Height = 24
      ReadOnly = True
      TabOrder = 1
    end
    object EIntDeconv: TEdit
      Left = 131
      Top = 120
      Width = 100
      Height = 24
      ReadOnly = True
      TabOrder = 2
    end
    object PData: TPanel
      Left = 3
      Top = 3
      Width = 248
      Height = 41
      BorderStyle = bsSingle
      Caption = 'Datos de la Secci'#243'n'
      TabOrder = 3
    end
  end
  object PTransformations: TPanel
    Left = 262
    Top = 247
    Width = 266
    Height = 166
    Anchors = [akLeft, akBottom]
    BorderStyle = bsSingle
    TabOrder = 1
    object LScale: TLabel
      Left = 75
      Top = 62
      Width = 49
      Height = 16
      Caption = 'Escalar:'
    end
    object LTotalMagnification: TLabel
      Left = 5
      Top = 89
      Width = 120
      Height = 16
      Caption = 'Magnificaci'#243'n Total:'
    end
    object EScale: TEdit
      Left = 132
      Top = 56
      Width = 56
      Height = 24
      TabOrder = 0
      Text = '1'
    end
    object Panel1: TPanel
      Left = 3
      Top = 3
      Width = 256
      Height = 42
      BorderStyle = bsSingle
      Caption = 'Transformaciones'
      TabOrder = 1
    end
    object BUpDate: TButton
      Left = 18
      Top = 125
      Width = 90
      Height = 29
      Caption = 'Actualizar'
      TabOrder = 2
      OnClick = BUpDateClick
    end
    object EMagnification: TEdit
      Left = 132
      Top = 87
      Width = 56
      Height = 24
      TabOrder = 3
      Text = '1'
    end
  end
  object ImViewLayerRaw: TImgView32
    Left = 1
    Top = 1
    Width = 262
    Height = 242
    Hint = 'Secci'#243'n Cruda'
    Anchors = [akLeft, akTop, akRight, akBottom]
    Centered = False
    ParentShowHint = False
    Scale = 1
    ScrollBars.Color = clScrollBar
    ScrollBars.ShowHandleGrip = True
    ScrollBars.Style = rbsDefault
    ShowHint = True
    SizeGrip = sgAuto
    TabOrder = 2
    Visible = False
    OnMouseMove = ImViewLayerRawMouseMove
  end
  object ImViewLayerDeconv: TImgView32
    Left = 266
    Top = 1
    Width = 262
    Height = 242
    Hint = 'Secci'#243'n Desconvolucionada'
    Anchors = [akLeft, akTop, akRight, akBottom]
    Centered = False
    ParentShowHint = False
    Scale = 1
    ScrollBars.Color = clScrollBar
    ScrollBars.ShowHandleGrip = True
    ScrollBars.Style = rbsDefault
    ShowHint = True
    SizeGrip = sgAuto
    TabOrder = 3
    Visible = False
    OnMouseMove = ImViewLayerDeconvMouseMove
  end
end
