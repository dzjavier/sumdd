object FTimeLapse: TFTimeLapse
  Left = 293
  Top = 232
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Datos de Time Lapse'
  ClientHeight = 169
  ClientWidth = 472
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
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PData: TPanel
    Left = 0
    Top = 0
    Width = 473
    Height = 170
    BorderStyle = bsSingle
    TabOrder = 0
    object SBCancel: TSpeedButton
      Left = 279
      Top = 127
      Width = 65
      Height = 34
      Caption = 'Cerrar'
      OnClick = SBCancelClick
    end
    object GBSpecimen: TGroupBox
      Left = 8
      Top = 0
      Width = 457
      Height = 122
      TabOrder = 2
      object LTime: TLabel
        Left = 225
        Top = 73
        Width = 129
        Height = 13
        Caption = 'Tiempo de Exposici'#243'n [ms]:'
      end
      object LResX: TLabel
        Left = 30
        Top = 17
        Width = 66
        Height = 13
        Caption = 'Resoluci'#243'n X:'
      end
      object LResY: TLabel
        Left = 30
        Top = 44
        Width = 66
        Height = 13
        Caption = 'Resoluci'#243'n Y:'
      end
      object LRetardo: TLabel
        Left = 293
        Top = 20
        Width = 55
        Height = 13
        Caption = 'Retardo [s]:'
      end
      object LNumOfSections: TLabel
        Left = 240
        Top = 47
        Width = 108
        Height = 13
        Caption = 'N'#250'mero de Secciones:'
      end
      object LMean: TLabel
        Left = 22
        Top = 71
        Width = 74
        Height = 13
        Caption = 'N'#176' de capturas:'
      end
      object EExpositionTime: TEdit
        Left = 354
        Top = 70
        Width = 98
        Height = 21
        TabOrder = 5
        OnChange = ESpecimenChange
      end
      object ENumOfSections: TEdit
        Left = 354
        Top = 43
        Width = 98
        Height = 21
        TabOrder = 3
        Text = '10'
        OnChange = ESpecimenChange
      end
      object EXResolution: TEdit
        Left = 102
        Top = 14
        Width = 98
        Height = 21
        TabOrder = 0
        OnChange = ESpecimenChange
      end
      object EYResolution: TEdit
        Left = 102
        Top = 41
        Width = 98
        Height = 21
        TabOrder = 1
        OnChange = ESpecimenChange
      end
      object EDelay: TEdit
        Left = 354
        Top = 16
        Width = 98
        Height = 21
        TabOrder = 2
        Text = '1'
        OnChange = ESpecimenChange
      end
      object EMean: TEdit
        Left = 102
        Top = 68
        Width = 98
        Height = 21
        TabOrder = 4
        OnChange = ESpecimenChange
      end
    end
    object BBSaveData: TBitBtn
      Left = 110
      Top = 127
      Width = 83
      Height = 34
      Caption = 'Guardar Datos'
      TabOrder = 0
      OnClick = BBSaveDataClick
    end
    object BBCapturar: TBitBtn
      Left = 202
      Top = 127
      Width = 68
      Height = 34
      Caption = 'Capturar'
      Enabled = False
      TabOrder = 1
      OnClick = BBCapturarClick
    end
    object CBDoseControl: TCheckBox
      Left = 53
      Top = 94
      Width = 97
      Height = 17
      Caption = 'Control de dosis'
      TabOrder = 3
    end
  end
  object SDDataSectioning: TSaveDialog
    Filter = 'txt (Archivo de texto)|*.txt'
    Left = 32
    Top = 360
  end
end
