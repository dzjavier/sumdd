object FNearestNeighborDeconvolution: TFNearestNeighborDeconvolution
  Left = 133
  Top = 120
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Desconvoluci'#243'n con Planos Vecinos'
  ClientHeight = 171
  ClientWidth = 355
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
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
  PixelsPerInch = 96
  TextHeight = 13
  object PDeconvolution: TPanel
    Left = 0
    Top = 0
    Width = 354
    Height = 171
    BevelOuter = bvSpace
    BorderStyle = bsSingle
    TabOrder = 0
    object Panel1: TPanel
      Left = 2
      Top = 118
      Width = 347
      Height = 47
      BorderStyle = bsSingle
      TabOrder = 0
      object BBOK: TBitBtn
        Left = 73
        Top = 5
        Width = 92
        Height = 35
        Caption = 'Aceptar'
        ModalResult = 1
        TabOrder = 0
      end
      object BBCancel: TBitBtn
        Left = 171
        Top = 5
        Width = 86
        Height = 35
        Caption = 'Cancelar'
        ModalResult = 2
        TabOrder = 1
        OnClick = BBCancelClick
      end
    end
    object Panel2: TPanel
      Left = 195
      Top = 2
      Width = 154
      Height = 114
      BorderStyle = bsSingle
      TabOrder = 1
      object LPlaneNumber: TLabel
        Left = 12
        Top = 10
        Width = 76
        Height = 13
        Caption = 'Planos Vecinos:'
      end
      object LC1: TLabel
        Left = 7
        Top = 35
        Width = 99
        Height = 13
        Caption = 'Influencia de Planos:'
      end
      object LC2: TLabel
        Left = 6
        Top = 72
        Width = 73
        Height = 13
        Caption = 'Nivel de Ruido:'
      end
      object LMoreLess1: TLabel
        Left = 13
        Top = 50
        Width = 122
        Height = 16
        Caption = '-                                     +'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object LMoreLess2: TLabel
        Left = 13
        Top = 87
        Width = 122
        Height = 16
        Caption = '-                                     +'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object EPlaneNumber: TEdit
        Left = 95
        Top = 6
        Width = 35
        Height = 21
        Enabled = False
        TabOrder = 0
        Text = '1'
      end
      object UDPlaneNumber: TUpDown
        Left = 130
        Top = 6
        Width = 13
        Height = 19
        Enabled = False
        Min = 1
        Max = 10
        Position = 1
        TabOrder = 1
        Wrap = False
      end
      object TBC1: TTrackBar
        Left = 16
        Top = 50
        Width = 122
        Height = 19
        Max = 100
        Min = 1
        Orientation = trHorizontal
        Frequency = 1
        Position = 50
        SelEnd = 0
        SelStart = 0
        TabOrder = 2
        TickMarks = tmBottomRight
        TickStyle = tsAuto
      end
      object TBC2: TTrackBar
        Left = 16
        Top = 86
        Width = 122
        Height = 20
        Max = 1000
        Min = 1
        Orientation = trHorizontal
        Frequency = 1
        Position = 500
        SelEnd = 0
        SelStart = 0
        TabOrder = 3
        TickMarks = tmBottomRight
        TickStyle = tsAuto
      end
    end
    object Panel3: TPanel
      Left = 2
      Top = 2
      Width = 192
      Height = 114
      BorderStyle = bsSingle
      TabOrder = 2
      object LLens: TLabel
        Left = 13
        Top = 8
        Width = 72
        Height = 13
        Caption = 'Lente Objetiva:'
      end
      object LDeltaZ: TLabel
        Left = 7
        Top = 35
        Width = 77
        Height = 13
        Caption = 'Delta Z [micras]:'
      end
      object LSetPSF: TLabel
        Left = 5
        Top = 67
        Width = 99
        Height = 13
        Caption = 'Selecci'#243'n de la PSF:'
      end
      object CBLens: TComboBox
        Left = 88
        Top = 5
        Width = 49
        Height = 21
        ItemHeight = 13
        ItemIndex = 1
        TabOrder = 0
        Text = '10x'
        Items.Strings = (
          '4x'
          '10x'
          '20x'
          '40x'
          '100x')
      end
      object EDelta: TEdit
        Left = 89
        Top = 31
        Width = 39
        Height = 21
        TabOrder = 1
        Text = '1'
      end
      object CBPSF: TComboBox
        Left = 110
        Top = 63
        Width = 68
        Height = 21
        ItemHeight = 13
        ItemIndex = 1
        TabOrder = 2
        Text = 'Emp'#237'rica'
        Items.Strings = (
          'Te'#243'rica'
          'Emp'#237'rica')
      end
    end
  end
end
