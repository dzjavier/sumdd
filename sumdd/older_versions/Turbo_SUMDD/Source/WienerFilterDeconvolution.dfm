object FWiener2DDeconvolution: TFWiener2DDeconvolution
  Left = 441
  Top = 242
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Filtro de Wiener 2D'
  ClientHeight = 208
  ClientWidth = 268
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
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
  PixelsPerInch = 120
  TextHeight = 16
  object PDeconvolution: TPanel
    Left = 0
    Top = 0
    Width = 267
    Height = 208
    BevelOuter = bvSpace
    BorderStyle = bsSingle
    TabOrder = 0
    object Panel1: TPanel
      Left = 2
      Top = 141
      Width = 258
      Height = 58
      BorderStyle = bsSingle
      TabOrder = 0
      object BBOK: TBitBtn
        Left = 10
        Top = 6
        Width = 113
        Height = 43
        Caption = 'Aceptar'
        ModalResult = 1
        TabOrder = 0
      end
      object BBCancel: TBitBtn
        Left = 130
        Top = 6
        Width = 106
        Height = 43
        Caption = 'Cancelar'
        ModalResult = 2
        TabOrder = 1
        OnClick = BBCancelClick
      end
    end
    object Panel3: TPanel
      Left = 3
      Top = 3
      Width = 257
      Height = 135
      BorderStyle = bsSingle
      TabOrder = 1
      object LLens: TLabel
        Left = 49
        Top = 8
        Width = 89
        Height = 16
        Caption = 'Lente Objetiva:'
      end
      object LSetPSF: TLabel
        Left = 13
        Top = 44
        Width = 125
        Height = 16
        Caption = 'Selecci'#243'n de la PSF:'
      end
      object LC: TLabel
        Left = 34
        Top = 78
        Width = 92
        Height = 16
        Caption = 'Nivel de Ruido:'
      end
      object LMoreLess: TLabel
        Left = 43
        Top = 96
        Width = 162
        Height = 20
        Caption = '-                                     +'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object CBLens: TComboBox
        Left = 143
        Top = 4
        Width = 84
        Height = 24
        ItemHeight = 16
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
      object CBPSF: TComboBox
        Left = 143
        Top = 40
        Width = 84
        Height = 24
        ItemHeight = 16
        ItemIndex = 1
        TabOrder = 1
        Text = 'Emp'#237'rica'
        Items.Strings = (
          'Te'#243'rica'
          'Emp'#237'rica')
      end
      object TBC: TTrackBar
        Left = 47
        Top = 95
        Width = 150
        Height = 24
        Max = 1000
        Min = 1
        Orientation = trHorizontal
        Frequency = 1
        Position = 500
        SelEnd = 0
        SelStart = 0
        TabOrder = 2
        TickMarks = tmBottomRight
        TickStyle = tsAuto
      end
    end
  end
end
