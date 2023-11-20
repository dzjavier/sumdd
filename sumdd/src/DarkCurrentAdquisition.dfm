object FDarkCurrentAdquisition: TFDarkCurrentAdquisition
  Left = 680
  Top = 137
  Width = 340
  Height = 425
  Caption = 'FDarkCurrentAdquisition'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object BAdd2list: TButton
    Left = 192
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Agregar'
    TabOrder = 0
    OnClick = BAdd2listClick
  end
  object LBMacroList: TListBox
    Left = 24
    Top = 128
    Width = 137
    Height = 233
    ItemHeight = 13
    TabOrder = 1
  end
  object BDarkCapture: TButton
    Left = 176
    Top = 336
    Width = 75
    Height = 25
    Caption = 'Ejecutar Lista'
    TabOrder = 2
    OnClick = BDarkCaptureClick
  end
  object ETexp: TEdit
    Left = 32
    Top = 24
    Width = 97
    Height = 21
    TabOrder = 3
    Text = 'TExposicion [ms]'
  end
  object ERep: TEdit
    Left = 32
    Top = 56
    Width = 97
    Height = 21
    TabOrder = 4
    Text = 'Repeticion'
  end
  object EEspera: TEdit
    Left = 32
    Top = 88
    Width = 97
    Height = 21
    TabOrder = 5
    Text = 'TEspera [ms]'
  end
  object Exdim: TEdit
    Left = 192
    Top = 128
    Width = 81
    Height = 21
    TabOrder = 6
    Text = '512'
  end
  object Eydim: TEdit
    Left = 192
    Top = 160
    Width = 81
    Height = 21
    TabOrder = 7
    Text = '512'
  end
  object EFileName: TEdit
    Left = 168
    Top = 200
    Width = 121
    Height = 21
    TabOrder = 8
    Text = 'CorrienteOscura1'
  end
  object BReset: TButton
    Left = 192
    Top = 88
    Width = 75
    Height = 25
    Caption = 'Reset'
    TabOrder = 9
    OnClick = BResetClick
  end
end
