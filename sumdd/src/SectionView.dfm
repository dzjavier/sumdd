object FViewSection: TFViewSection
  Left = 356
  Top = 193
  BorderStyle = bsSingle
  Caption = 'Secci'#243'n:'
  ClientHeight = 338
  ClientWidth = 431
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
  OnResize = FormResize
  DesignSize = (
    431
    338)
  PixelsPerInch = 96
  TextHeight = 13
  object PInfo: TPanel
    Left = 1
    Top = 201
    Width = 210
    Height = 135
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
      Left = 13
      Top = 51
      Width = 82
      Height = 13
      Caption = 'Posici'#243'n [micras]:'
    end
    object LIntRaw: TLabel
      Left = 15
      Top = 76
      Width = 83
      Height = 13
      Caption = 'Intensidad Cruda:'
    end
    object LIntDeconv: TLabel
      Left = 4
      Top = 100
      Width = 98
      Height = 13
      Caption = 'Int. Desconvoluci'#243'n:'
    end
    object EXY: TEdit
      Left = 106
      Top = 48
      Width = 99
      Height = 24
      BevelInner = bvNone
      BevelKind = bkFlat
      ReadOnly = True
      TabOrder = 0
    end
    object EIntRaw: TEdit
      Left = 106
      Top = 72
      Width = 82
      Height = 24
      ReadOnly = True
      TabOrder = 1
    end
    object EIntDeconv: TEdit
      Left = 106
      Top = 98
      Width = 82
      Height = 24
      ReadOnly = True
      TabOrder = 2
    end
    object PData: TPanel
      Left = 2
      Top = 2
      Width = 202
      Height = 34
      BorderStyle = bsSingle
      Caption = 'Datos de la Secci'#243'n'
      TabOrder = 3
    end
  end
  object PTransformations: TPanel
    Left = 213
    Top = 201
    Width = 216
    Height = 135
    Anchors = [akLeft, akBottom]
    BorderStyle = bsSingle
    TabOrder = 1
    object LScale: TLabel
      Left = 61
      Top = 50
      Width = 38
      Height = 13
      Caption = 'Escalar:'
    end
    object LTotalMagnification: TLabel
      Left = 4
      Top = 72
      Width = 96
      Height = 13
      Caption = 'Magnificaci'#243'n Total:'
    end
    object EScale: TEdit
      Left = 107
      Top = 46
      Width = 46
      Height = 24
      TabOrder = 0
      Text = '1'
    end
    object Panel1: TPanel
      Left = 2
      Top = 2
      Width = 208
      Height = 35
      BorderStyle = bsSingle
      Caption = 'Transformaciones'
      TabOrder = 1
    end
    object BUpDate: TButton
      Left = 15
      Top = 102
      Width = 73
      Height = 23
      Caption = 'Actualizar'
      TabOrder = 2
      OnClick = BUpDateClick
    end
    object EMagnification: TEdit
      Left = 107
      Top = 71
      Width = 46
      Height = 24
      TabOrder = 3
      Text = '1'
    end
  end
end
