object FControlOptions: TFControlOptions
  Left = 452
  Top = 273
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Opciones de Control'
  ClientHeight = 151
  ClientWidth = 235
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
    Left = 1
    Top = 1
    Width = 233
    Height = 149
    BorderStyle = bsSingle
    TabOrder = 0
    object Panel2: TPanel
      Left = 3
      Top = 4
      Width = 222
      Height = 39
      BorderStyle = bsSingle
      Caption = 'Direcci'#243'n de Puerto Paralelo'
      TabOrder = 0
    end
    object CBPortDir: TComboBox
      Left = 56
      Top = 56
      Width = 121
      Height = 24
      ItemHeight = 16
      ItemIndex = 0
      TabOrder = 1
      Text = '$378'
      Items.Strings = (
        '$378'
        '$278')
    end
    object BBApply: TBitBtn
      Left = 32
      Top = 104
      Width = 81
      Height = 30
      Caption = 'Aplicar'
      ModalResult = 1
      TabOrder = 2
    end
    object BBCancelar: TBitBtn
      Left = 120
      Top = 104
      Width = 81
      Height = 30
      Caption = 'Cancelar'
      ModalResult = 2
      TabOrder = 3
    end
  end
end