object FDataSections: TFDataSections
  Left = 370
  Top = 154
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Datos de Seccionamiento'
  ClientHeight = 395
  ClientWidth = 503
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
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
  PixelsPerInch = 120
  TextHeight = 16
  object PData: TPanel
    Left = 0
    Top = 0
    Width = 501
    Height = 394
    BorderStyle = bsSingle
    TabOrder = 0
    object LNumOfSections: TLabel
      Left = 21
      Top = 264
      Width = 137
      Height = 16
      Caption = 'N'#250'mero de Secciones:'
    end
    object LIniSection: TLabel
      Left = 69
      Top = 292
      Width = 89
      Height = 16
      Caption = 'Secci'#243'n Inicial:'
    end
    object LHeader: TLabel
      Left = 78
      Top = 320
      Width = 80
      Height = 16
      Caption = 'Encabezado:'
      Visible = False
    end
    object BBLoad: TBitBtn
      Left = 243
      Top = 253
      Width = 88
      Height = 42
      Caption = 'Cargar'
      ModalResult = 1
      TabOrder = 1
    end
    object BBCancelLoad: TBitBtn
      Left = 242
      Top = 304
      Width = 89
      Height = 42
      Caption = 'Cancelar'
      ModalResult = 2
      TabOrder = 2
    end
    object GBSpecimen: TGroupBox
      Left = 3
      Top = 2
      Width = 491
      Height = 246
      Caption = 'Especimen'
      TabOrder = 3
      object LAuthor: TLabel
        Left = 28
        Top = 24
        Width = 34
        Height = 16
        Caption = 'Autor:'
      end
      object LDate: TLabel
        Left = 28
        Top = 50
        Width = 41
        Height = 16
        Caption = 'Fecha:'
      end
      object LDesconvolved: TLabel
        Left = 235
        Top = 37
        Width = 124
        Height = 16
        Caption = 'Desconvolucionado:'
      end
      object LDeconvAlgorithm: TLabel
        Left = 235
        Top = 63
        Width = 179
        Height = 16
        Caption = 'Algoritmo de Desconvoluci'#243'n:'
      end
      object LTime: TLabel
        Left = 28
        Top = 76
        Width = 138
        Height = 16
        Caption = 'Tiempo de Exposici'#243'n:'
      end
      object LObjLens: TLabel
        Left = 28
        Top = 102
        Width = 89
        Height = 16
        Caption = 'Lente Objetiva:'
      end
      object LMagnification: TLabel
        Left = 28
        Top = 129
        Width = 120
        Height = 16
        Caption = 'Magnificaci'#243'n Total:'
      end
      object LOil: TLabel
        Left = 28
        Top = 155
        Width = 121
        Height = 16
        Caption = 'Aceite de Inmersi'#243'n:'
      end
      object LTile: TLabel
        Left = 28
        Top = 181
        Width = 61
        Height = 16
        Caption = 'Marcador:'
      end
      object LSections: TLabel
        Left = 236
        Top = 194
        Width = 67
        Height = 16
        Caption = 'Secciones:'
      end
      object LResX: TLabel
        Left = 235
        Top = 89
        Width = 82
        Height = 16
        Caption = 'Resoluci'#243'n X:'
      end
      object LDepthRes: TLabel
        Left = 235
        Top = 142
        Width = 125
        Height = 16
        Caption = 'Resoluci'#243'n de Color:'
      end
      object LResY: TLabel
        Left = 235
        Top = 116
        Width = 83
        Height = 16
        Caption = 'Resoluci'#243'n Y:'
      end
      object LAntiBody: TLabel
        Left = 28
        Top = 208
        Width = 67
        Height = 16
        Caption = 'Anticuerpo:'
      end
      object LDeltaZ: TLabel
        Left = 235
        Top = 168
        Width = 72
        Height = 16
        Caption = 'Delta Z[um]:'
      end
    end
    object ENumOfSections: TEdit
      Left = 162
      Top = 259
      Width = 72
      Height = 24
      TabOrder = 0
    end
    object EIniSection: TEdit
      Left = 162
      Top = 288
      Width = 72
      Height = 24
      TabOrder = 4
    end
    object CBLoadRawData: TCheckBox
      Left = 15
      Top = 353
      Width = 153
      Height = 17
      Caption = 'Cargar Datos Crudos'
      TabOrder = 5
      Visible = False
    end
    object EHeader: TEdit
      Left = 162
      Top = 317
      Width = 72
      Height = 24
      TabOrder = 6
      Visible = False
    end
    object Panel1: TPanel
      Left = 348
      Top = 251
      Width = 146
      Height = 135
      BorderStyle = bsSingle
      Caption = 'Panel1'
      TabOrder = 7
      object ISectionPreview: TImage32
        Left = 4
        Top = 3
        Width = 134
        Height = 126
        BitmapAlign = baTopLeft
        Scale = 1
        ScaleMode = smStretch
        TabOrder = 0
      end
    end
  end
end
