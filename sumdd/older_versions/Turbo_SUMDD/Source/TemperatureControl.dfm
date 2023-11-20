object FTemperatureControl: TFTemperatureControl
  Left = 375
  Top = 241
  Anchors = [akTop, akRight]
  AutoSize = True
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Control de Temperatura'
  ClientHeight = 144
  ClientWidth = 293
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
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PControlTemperature: TPanel
    Left = 0
    Top = 0
    Width = 293
    Height = 144
    BorderStyle = bsSingle
    TabOrder = 0
    object LTargetTemperature: TLabel
      Left = 67
      Top = 14
      Width = 117
      Height = 13
      Caption = 'Temperatura Target ['#186'C]:'
    end
    object LSenseTemperature: TLabel
      Left = 55
      Top = 41
      Width = 128
      Height = 13
      Caption = 'Temperatura Sensada ['#186'C]:'
    end
    object Label1: TLabel
      Left = 50
      Top = 70
      Width = 39
      Height = 13
      Caption = 'Estado :'
    end
    object ETTemperature: TEdit
      Left = 191
      Top = 11
      Width = 45
      Height = 21
      TabOrder = 0
      Text = '-10.00'
    end
    object BBSet: TBitBtn
      Left = 13
      Top = 102
      Width = 83
      Height = 32
      Caption = 'Refrigerar'
      TabOrder = 1
      OnClick = BBSetClick
    end
    object BBCancel: TBitBtn
      Left = 195
      Top = 102
      Width = 83
      Height = 32
      Caption = 'Cancelar'
      TabOrder = 2
      OnClick = BBCancelClick
    end
    object ESenseTemperature: TEdit
      Left = 191
      Top = 38
      Width = 46
      Height = 21
      Cursor = crCross
      Color = cl3DLight
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 3
    end
    object EStatus: TEdit
      Left = 102
      Top = 67
      Width = 181
      Height = 21
      Cursor = crCross
      Color = clSilver
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 4
    end
    object BBAmbientTemperature: TBitBtn
      Left = 102
      Top = 102
      Width = 83
      Height = 32
      Caption = 'T. Ambiente'
      TabOrder = 5
      OnClick = BBAmbientTemperatureClick
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer1Timer
    Left = 8
    Top = 232
  end
end
