object FTimeLapse: TFTimeLapse
  Left = 293
  Top = 232
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Datos de Time Lapse'
  ClientHeight = 307
  ClientWidth = 474
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
    Width = 474
    Height = 307
    BorderStyle = bsSingle
    TabOrder = 0
    object SBCancel: TSpeedButton
      Left = 279
      Top = 257
      Width = 65
      Height = 34
      Caption = 'Cerrar'
      OnClick = SBCancelClick
    end
    object GBSpecimen: TGroupBox
      Left = 2
      Top = 1
      Width = 465
      Height = 252
      TabOrder = 2
      object LAuthor: TLabel
        Left = 82
        Top = 44
        Width = 28
        Height = 13
        Caption = 'Autor:'
      end
      object LDate: TLabel
        Left = 76
        Top = 68
        Width = 33
        Height = 13
        Caption = 'Fecha:'
      end
      object LTime: TLabel
        Left = 226
        Top = 190
        Width = 121
        Height = 13
        Caption = 'Tiempo de Exposici'#243'n [s]:'
      end
      object LObjLens: TLabel
        Left = 37
        Top = 93
        Width = 72
        Height = 13
        Caption = 'Lente Objetiva:'
      end
      object LMagnification: TLabel
        Left = 12
        Top = 117
        Width = 96
        Height = 13
        Caption = 'Magnificaci'#243'n Total:'
      end
      object LOil: TLabel
        Left = 11
        Top = 141
        Width = 96
        Height = 13
        Caption = 'Aceite de Inmersi'#243'n:'
      end
      object LTile: TLabel
        Left = 60
        Top = 166
        Width = 48
        Height = 13
        Caption = 'Marcador:'
      end
      object LResX: TLabel
        Left = 286
        Top = 19
        Width = 66
        Height = 13
        Caption = 'Resoluci'#243'n X:'
      end
      object LDepthRes: TLabel
        Left = 251
        Top = 68
        Width = 98
        Height = 13
        Caption = 'Resoluci'#243'n de Color:'
      end
      object LResY: TLabel
        Left = 285
        Top = 44
        Width = 66
        Height = 13
        Caption = 'Resoluci'#243'n Y:'
      end
      object LAntiBody: TLabel
        Left = 55
        Top = 190
        Width = 54
        Height = 13
        Caption = 'Anticuerpo:'
      end
      object LRetardo: TLabel
        Left = 294
        Top = 93
        Width = 55
        Height = 13
        Caption = 'Retardo [s]:'
      end
      object LNumOfSections: TLabel
        Left = 241
        Top = 118
        Width = 108
        Height = 13
        Caption = 'N'#250'mero de Secciones:'
      end
      object LHeader: TLabel
        Left = 45
        Top = 215
        Width = 63
        Height = 13
        Caption = 'Encabezado:'
      end
      object LIniSection: TLabel
        Left = 272
        Top = 166
        Width = 72
        Height = 13
        Caption = 'Secci'#243'n Inicial:'
      end
      object LSpecimen: TLabel
        Left = 52
        Top = 20
        Width = 55
        Height = 13
        Caption = 'Especimen:'
      end
      object LMean: TLabel
        Left = 240
        Top = 141
        Width = 107
        Height = 13
        Caption = 'Im'#225'genes a promediar:'
      end
      object EAuthor: TEdit
        Left = 112
        Top = 41
        Width = 98
        Height = 21
        TabOrder = 1
        Text = 'Lab.Microscopia'
        OnChange = ESpecimenChange
      end
      object EDate: TEdit
        Left = 112
        Top = 65
        Width = 98
        Height = 21
        TabOrder = 2
        OnChange = ESpecimenChange
      end
      object EExpositionTime: TEdit
        Left = 355
        Top = 187
        Width = 98
        Height = 21
        TabOrder = 16
        OnChange = ESpecimenChange
      end
      object EMagnification: TEdit
        Left = 112
        Top = 114
        Width = 98
        Height = 21
        TabOrder = 4
        Text = '1'
        OnChange = ESpecimenChange
      end
      object EInmersionOil: TEdit
        Left = 112
        Top = 138
        Width = 98
        Height = 21
        TabOrder = 5
        OnChange = ESpecimenChange
      end
      object ETile: TEdit
        Left = 112
        Top = 163
        Width = 98
        Height = 21
        TabOrder = 6
        OnChange = ESpecimenChange
      end
      object EAntibody: TEdit
        Left = 112
        Top = 187
        Width = 98
        Height = 21
        TabOrder = 7
        OnChange = ESpecimenChange
      end
      object ENumOfSections: TEdit
        Left = 355
        Top = 114
        Width = 98
        Height = 21
        TabOrder = 13
        Text = '1'
        OnChange = ESpecimenChange
      end
      object EIniSection: TEdit
        Left = 355
        Top = 163
        Width = 98
        Height = 21
        TabOrder = 15
        Text = '000'
        OnChange = ESpecimenChange
      end
      object EHeader: TEdit
        Left = 112
        Top = 212
        Width = 98
        Height = 21
        TabOrder = 8
        Text = 'Hea'
        OnChange = ESpecimenChange
      end
      object CBObjectiveLens: TComboBox
        Left = 112
        Top = 89
        Width = 98
        Height = 21
        ItemHeight = 13
        ItemIndex = 1
        TabOrder = 3
        Text = '10'
        OnChange = CBSpeedChange
        Items.Strings = (
          '4'
          '10'
          '20'
          '40'
          '100')
      end
      object EXResolution: TEdit
        Left = 355
        Top = 16
        Width = 98
        Height = 21
        TabOrder = 9
        OnChange = ESpecimenChange
      end
      object EYResolution: TEdit
        Left = 355
        Top = 41
        Width = 98
        Height = 21
        TabOrder = 10
        OnChange = ESpecimenChange
      end
      object EResolutionColor: TEdit
        Left = 355
        Top = 65
        Width = 98
        Height = 21
        TabOrder = 11
        Text = '8 Bits'
        OnChange = ESpecimenChange
      end
      object EDelay: TEdit
        Left = 355
        Top = 89
        Width = 98
        Height = 21
        TabOrder = 12
        Text = '1'
        OnChange = ESpecimenChange
      end
      object ESpecimen: TEdit
        Left = 112
        Top = 16
        Width = 98
        Height = 21
        TabOrder = 0
        OnChange = ESpecimenChange
      end
      object EMean: TEdit
        Left = 355
        Top = 138
        Width = 98
        Height = 21
        TabOrder = 14
        OnChange = ESpecimenChange
      end
    end
    object BBSaveData: TBitBtn
      Left = 110
      Top = 257
      Width = 83
      Height = 34
      Caption = 'Guardar Datos'
      TabOrder = 0
      OnClick = BBSaveDataClick
    end
    object BBCapturar: TBitBtn
      Left = 202
      Top = 257
      Width = 68
      Height = 34
      Caption = 'Capturar'
      Enabled = False
      TabOrder = 1
      OnClick = BBCapturarClick
    end
    object CBDoseControl: TCheckBox
      Left = 357
      Top = 215
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
