object FLLSDeconvolution: TFLLSDeconvolution
  Left = 252
  Top = 198
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Desconvoluci'#243'n con M'#233't. Lineal de los Cuadrados M'#237'nimos'
  ClientHeight = 175
  ClientWidth = 411
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 411
    Height = 175
    BorderStyle = bsSingle
    TabOrder = 0
    object Panel3: TPanel
      Left = 3
      Top = 113
      Width = 401
      Height = 54
      BorderStyle = bsSingle
      TabOrder = 0
      object BBOk: TBitBtn
        Left = 103
        Top = 8
        Width = 99
        Height = 35
        Caption = 'Aceptar'
        ModalResult = 1
        TabOrder = 0
      end
      object BBCancel: TBitBtn
        Left = 208
        Top = 8
        Width = 90
        Height = 36
        Caption = 'Cancelar'
        TabOrder = 1
        OnClick = BBCancelClick
      end
    end
    object Panel2: TPanel
      Left = 3
      Top = 3
      Width = 205
      Height = 108
      BorderStyle = bsSingle
      TabOrder = 1
      object LLens: TLabel
        Left = 32
        Top = 8
        Width = 89
        Height = 16
        Caption = 'Lente Objetiva:'
      end
      object LDeltaZ: TLabel
        Left = 25
        Top = 40
        Width = 97
        Height = 16
        Caption = 'Delta Z [micras]:'
      end
      object LPSF: TLabel
        Left = 42
        Top = 74
        Width = 29
        Height = 16
        Caption = 'PSF:'
      end
      object CBLens: TComboBox
        Left = 123
        Top = 3
        Width = 60
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
      object EDelta: TEdit
        Left = 124
        Top = 36
        Width = 46
        Height = 24
        TabOrder = 1
        Text = '1'
      end
      object CBPSF: TComboBox
        Left = 83
        Top = 69
        Width = 89
        Height = 24
        ItemHeight = 16
        ItemIndex = 1
        TabOrder = 2
        Text = 'Emp'#237'rica'
        Items.Strings = (
          'Te'#243'rica'
          'Emp'#237'rica')
      end
    end
    object Panel4: TPanel
      Left = 210
      Top = 3
      Width = 194
      Height = 108
      BorderStyle = bsSingle
      TabOrder = 2
      object LMuOptimo: TLabel
        Left = 31
        Top = 22
        Width = 135
        Height = 16
        Caption = 'Relaci'#243'n Se'#241'al/Ruido:'
      end
      object Label1: TLabel
        Left = 15
        Top = 51
        Width = 164
        Height = 16
        Caption = '-                                                   +'
      end
      object TBSNR: TTrackBar
        Left = 24
        Top = 48
        Width = 146
        Height = 25
        Max = 100
        Min = 1
        Orientation = trHorizontal
        Frequency = 1
        Position = 75
        SelEnd = 0
        SelStart = 0
        TabOrder = 0
        TickMarks = tmBottomRight
        TickStyle = tsAuto
      end
    end
  end
end
