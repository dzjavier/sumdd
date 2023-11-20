object FDataSections: TFDataSections
  Left = 370
  Top = 154
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Datos de Seccionamiento'
  ClientHeight = 321
  ClientWidth = 409
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
  PixelsPerInch = 96
  TextHeight = 13
  object PData: TPanel
    Left = 0
    Top = 0
    Width = 407
    Height = 320
    BorderStyle = bsSingle
    TabOrder = 0
    object LNumOfSections: TLabel
      Left = 17
      Top = 215
      Width = 108
      Height = 13
      Caption = 'N'#250'mero de Secciones:'
    end
    object LIniSection: TLabel
      Left = 56
      Top = 237
      Width = 72
      Height = 13
      Caption = 'Secci'#243'n Inicial:'
    end
    object LHeader: TLabel
      Left = 63
      Top = 260
      Width = 63
      Height = 13
      Caption = 'Encabezado:'
      Visible = False
    end
    object BBLoad: TBitBtn
      Left = 197
      Top = 206
      Width = 72
      Height = 34
      Caption = 'Cargar'
      ModalResult = 1
      TabOrder = 1
    end
    object BBCancelLoad: TBitBtn
      Left = 197
      Top = 247
      Width = 72
      Height = 34
      Caption = 'Cancelar'
      ModalResult = 2
      TabOrder = 2
    end
    object GBSpecimen: TGroupBox
      Left = 2
      Top = 2
      Width = 399
      Height = 200
      Caption = 'Especimen'
      TabOrder = 3
      object LAuthor: TLabel
        Left = 23
        Top = 20
        Width = 28
        Height = 13
        Caption = 'Autor:'
      end
      object LDate: TLabel
        Left = 23
        Top = 41
        Width = 33
        Height = 13
        Caption = 'Fecha:'
      end
      object LDesconvolved: TLabel
        Left = 191
        Top = 30
        Width = 98
        Height = 13
        Caption = 'Desconvolucionado:'
      end
      object LDeconvAlgorithm: TLabel
        Left = 191
        Top = 51
        Width = 141
        Height = 13
        Caption = 'Algoritmo de Desconvoluci'#243'n:'
      end
      object LTime: TLabel
        Left = 23
        Top = 62
        Width = 107
        Height = 13
        Caption = 'Tiempo de Exposici'#243'n:'
      end
      object LObjLens: TLabel
        Left = 23
        Top = 83
        Width = 72
        Height = 13
        Caption = 'Lente Objetiva:'
      end
      object LMagnification: TLabel
        Left = 23
        Top = 105
        Width = 96
        Height = 13
        Caption = 'Magnificaci'#243'n Total:'
      end
      object LOil: TLabel
        Left = 23
        Top = 126
        Width = 96
        Height = 13
        Caption = 'Aceite de Inmersi'#243'n:'
      end
      object LTile: TLabel
        Left = 23
        Top = 147
        Width = 48
        Height = 13
        Caption = 'Marcador:'
      end
      object LSections: TLabel
        Left = 192
        Top = 158
        Width = 53
        Height = 13
        Caption = 'Secciones:'
      end
      object LResX: TLabel
        Left = 191
        Top = 72
        Width = 66
        Height = 13
        Caption = 'Resoluci'#243'n X:'
      end
      object LDepthRes: TLabel
        Left = 191
        Top = 115
        Width = 98
        Height = 13
        Caption = 'Resoluci'#243'n de Color:'
      end
      object LResY: TLabel
        Left = 191
        Top = 94
        Width = 66
        Height = 13
        Caption = 'Resoluci'#243'n Y:'
      end
      object LAntiBody: TLabel
        Left = 23
        Top = 169
        Width = 54
        Height = 13
        Caption = 'Anticuerpo:'
      end
      object LDeltaZ: TLabel
        Left = 191
        Top = 137
        Width = 58
        Height = 13
        Caption = 'Delta Z[um]:'
      end
    end
    object ENumOfSections: TEdit
      Left = 132
      Top = 210
      Width = 58
      Height = 24
      TabOrder = 0
    end
    object EIniSection: TEdit
      Left = 132
      Top = 234
      Width = 58
      Height = 24
      TabOrder = 4
    end
    object CBLoadRawData: TCheckBox
      Left = 12
      Top = 287
      Width = 125
      Height = 14
      Caption = 'Cargar Datos Crudos'
      TabOrder = 5
      Visible = False
    end
    object EHeader: TEdit
      Left = 132
      Top = 258
      Width = 58
      Height = 24
      TabOrder = 6
      Visible = False
    end
    object Panel1: TPanel
      Left = 283
      Top = 204
      Width = 118
      Height = 110
      BorderStyle = bsSingle
      Caption = 'Panel1'
      TabOrder = 7
    end
  end
end
