object FTemperatureControl: TFTemperatureControl
  Left = 375
  Top = 241
  Anchors = [akTop, akRight]
  AutoSize = True
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Control de Temperatura'
  ClientHeight = 177
  ClientWidth = 361
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
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object PControlTemperature: TPanel
    Left = 0
    Top = 0
    Width = 361
    Height = 177
    BorderStyle = bsSingle
    TabOrder = 0
    object LTargetTemperature: TLabel
      Left = 82
      Top = 17
      Width = 149
      Height = 16
      Caption = 'Temperatura Target ['#186'C]:'
    end
    object LSenseTemperature: TLabel
      Left = 68
      Top = 50
      Width = 164
      Height = 16
      Caption = 'Temperatura Sensada ['#186'C]:'
    end
    object Label1: TLabel
      Left = 10
      Top = 86
      Width = 113
      Height = 16
      Caption = 'Estado del Control:'
    end
    object ETTemperature: TEdit
      Left = 235
      Top = 13
      Width = 56
      Height = 24
      TabOrder = 0
      Text = '-10.00'
    end
    object BBSet: TBitBtn
      Left = 16
      Top = 125
      Width = 102
      Height = 40
      Caption = 'Refrigerar'
      TabOrder = 1
      OnClick = BBSetClick
    end
    object BBCancel: TBitBtn
      Left = 240
      Top = 125
      Width = 102
      Height = 40
      Caption = 'Cancelar'
      TabOrder = 2
      OnClick = BBCancelClick
    end
    object ESenseTemperature: TEdit
      Left = 235
      Top = 47
      Width = 57
      Height = 24
      Cursor = crCross
      Color = cl3DLight
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 3
    end
    object EStatus: TEdit
      Left = 126
      Top = 82
      Width = 222
      Height = 24
      Cursor = crCross
      Color = clSilver
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 4
    end
    object BBAmbientTemperature: TBitBtn
      Left = 126
      Top = 125
      Width = 102
      Height = 40
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
