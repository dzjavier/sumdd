object FConstrainedIterativeDeconvolution: TFConstrainedIterativeDeconvolution
  Left = 579
  Top = 512
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Desconvoluci'#243'n con M'#233'todo Iterativo'
  ClientHeight = 176
  ClientWidth = 306
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
    Width = 305
    Height = 176
    BorderStyle = bsSingle
    TabOrder = 0
    object Panel1: TPanel
      Left = 3
      Top = 111
      Width = 295
      Height = 57
      BorderStyle = bsSingle
      TabOrder = 0
      object BBOK: TBitBtn
        Left = 23
        Top = 6
        Width = 108
        Height = 43
        Caption = 'Aceptar'
        ModalResult = 1
        TabOrder = 0
      end
      object BBCancel: TBitBtn
        Left = 141
        Top = 6
        Width = 102
        Height = 43
        Caption = 'Cancelar'
        ModalResult = 2
        TabOrder = 1
        OnClick = BBCancelClick
      end
    end
    object Panel2: TPanel
      Left = 3
      Top = 4
      Width = 295
      Height = 105
      BorderStyle = bsSingle
      TabOrder = 1
      object LDeltaZ: TLabel
        Left = 38
        Top = 44
        Width = 97
        Height = 16
        Caption = 'Delta Z [micras]:'
      end
      object LLens: TLabel
        Left = 45
        Top = 10
        Width = 89
        Height = 16
        Caption = 'Lente Objetiva:'
      end
      object LSetPSF: TLabel
        Left = 10
        Top = 76
        Width = 125
        Height = 16
        Caption = 'Selecci'#243'n de la PSF:'
      end
      object EDelta: TEdit
        Left = 137
        Top = 40
        Width = 47
        Height = 24
        TabOrder = 0
        Text = '1'
      end
      object CBLens: TComboBox
        Left = 137
        Top = 7
        Width = 60
        Height = 24
        ItemHeight = 16
        ItemIndex = 2
        TabOrder = 1
        Text = '20x'
        Items.Strings = (
          '4x'
          '10x'
          '20x'
          '40x'
          '100x')
      end
      object CBPSF: TComboBox
        Left = 137
        Top = 71
        Width = 101
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
  end
end
