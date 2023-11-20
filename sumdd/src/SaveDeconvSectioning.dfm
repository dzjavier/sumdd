object FSaveDeconvSectioning: TFSaveDeconvSectioning
  Left = 293
  Top = 232
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Datos de Seccionamiento'
  ClientHeight = 312
  ClientWidth = 474
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  PrintScale = poNone
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PData: TPanel
    Left = 0
    Top = 0
    Width = 474
    Height = 309
    BorderStyle = bsSingle
    TabOrder = 0
    object SBCancel: TSpeedButton
      Left = 235
      Top = 266
      Width = 65
      Height = 33
      Caption = 'Cerrar'
      OnClick = SBCancelClick
    end
    object GBSpecimen: TGroupBox
      Left = 3
      Top = -3
      Width = 465
      Height = 264
      TabOrder = 1
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
        Left = 280
        Top = 50
        Width = 66
        Height = 13
        Caption = 'Resoluci'#243'n X:'
      end
      object LDepthRes: TLabel
        Left = 245
        Top = 100
        Width = 98
        Height = 13
        Caption = 'Resoluci'#243'n de Color:'
      end
      object LResY: TLabel
        Left = 280
        Top = 76
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
      object LDeltaZ: TLabel
        Left = 288
        Top = 124
        Width = 58
        Height = 13
        Caption = 'Delta Z[um]:'
      end
      object LNumOfSections: TLabel
        Left = 236
        Top = 150
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
        Left = 275
        Top = 174
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
      object LAlgorithm: TLabel
        Left = 29
        Top = 239
        Width = 80
        Height = 13
        Caption = 'Desconvoluci'#243'n:'
      end
      object LTime: TLabel
        Left = 220
        Top = 198
        Width = 121
        Height = 13
        Caption = 'Tiempo de Exposici'#243'n [s]:'
      end
      object EAuthor: TEdit
        Left = 112
        Top = 41
        Width = 98
        Height = 21
        TabOrder = 0
        Text = 'Lab.Microscopia'
      end
      object EDate: TEdit
        Left = 112
        Top = 65
        Width = 98
        Height = 21
        TabOrder = 1
      end
      object EMagnification: TEdit
        Left = 112
        Top = 114
        Width = 98
        Height = 21
        TabOrder = 2
        Text = '1'
      end
      object EInmersionOil: TEdit
        Left = 112
        Top = 138
        Width = 98
        Height = 21
        TabOrder = 3
      end
      object ETile: TEdit
        Left = 112
        Top = 163
        Width = 98
        Height = 21
        TabOrder = 4
      end
      object EAntibody: TEdit
        Left = 112
        Top = 187
        Width = 98
        Height = 21
        TabOrder = 5
      end
      object ENumOfSections: TEdit
        Left = 349
        Top = 145
        Width = 99
        Height = 21
        TabOrder = 6
        Text = '1'
      end
      object EIniSection: TEdit
        Left = 349
        Top = 171
        Width = 99
        Height = 21
        TabOrder = 7
        Text = '000'
      end
      object EHeader: TEdit
        Left = 112
        Top = 212
        Width = 98
        Height = 21
        TabOrder = 8
        Text = 'Hea'
      end
      object CBObjectiveLens: TComboBox
        Left = 112
        Top = 89
        Width = 98
        Height = 21
        ItemHeight = 13
        ItemIndex = 1
        TabOrder = 9
        Text = '10'
        Items.Strings = (
          '4'
          '10'
          '20'
          '40'
          '100')
      end
      object EXResolution: TEdit
        Left = 349
        Top = 48
        Width = 99
        Height = 21
        TabOrder = 10
      end
      object EYResolution: TEdit
        Left = 349
        Top = 72
        Width = 99
        Height = 21
        TabOrder = 11
      end
      object EResolutionColor: TEdit
        Left = 349
        Top = 97
        Width = 99
        Height = 21
        TabOrder = 12
        Text = '14 Bits'
      end
      object EDeltaZ: TEdit
        Left = 349
        Top = 121
        Width = 99
        Height = 21
        TabOrder = 13
        Text = '1'
      end
      object ESpecimen: TEdit
        Left = 112
        Top = 16
        Width = 98
        Height = 21
        TabOrder = 14
      end
      object EAlgorithm: TEdit
        Left = 112
        Top = 236
        Width = 98
        Height = 21
        TabOrder = 15
      end
      object EExpositionTime: TEdit
        Left = 349
        Top = 195
        Width = 99
        Height = 21
        TabOrder = 16
        Text = '0.2'
      end
    end
    object BBSaveData: TBitBtn
      Left = 137
      Top = 265
      Width = 83
      Height = 33
      Caption = 'Guardar Datos'
      TabOrder = 0
      OnClick = BBSaveDataClick
    end
  end
  object SDDataSectioning: TSaveDialog
    Filter = 'sdf (Sectioning Data File)|*.sdf'
    Left = 16
    Top = 16
  end
end
