object F3DProjection: TF3DProjection
  Left = 278
  Top = 172
  Width = 519
  Height = 505
  Caption = 'Proyecci'#243'n Tridimensional'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnMouseUp = FormMouseUp
  OnPaint = FormPaint
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object PTools: TPanel
    Left = 0
    Top = 405
    Width = 511
    Height = 66
    Align = alBottom
    BorderStyle = bsSingle
    TabOrder = 0
    object LScale: TLabel
      Left = 117
      Top = 14
      Width = 70
      Height = 13
      Caption = 'Escalar en XY:'
    end
    object Label1: TLabel
      Left = 128
      Top = 33
      Width = 60
      Height = 13
      Caption = 'Escala en Z:'
    end
    object LAngX: TLabel
      Left = 13
      Top = 13
      Width = 54
      Height = 13
      Caption = 'Rotar en X:'
    end
    object LAngY: TLabel
      Left = 12
      Top = 31
      Width = 54
      Height = 13
      Caption = 'Rotar en Y:'
    end
    object BBUpDate: TBitBtn
      Left = 439
      Top = 34
      Width = 65
      Height = 23
      Caption = 'Actualizar'
      TabOrder = 0
      OnClick = BBUpDateClick
    end
    object EXYScale: TEdit
      Left = 190
      Top = 12
      Width = 39
      Height = 21
      TabOrder = 1
      Text = '1'
    end
    object EZScale: TEdit
      Left = 190
      Top = 31
      Width = 39
      Height = 21
      TabOrder = 2
      Text = '1'
    end
    object EAngX: TEdit
      Left = 67
      Top = 11
      Width = 35
      Height = 21
      TabOrder = 3
      Text = '45'
    end
    object EAngY: TEdit
      Left = 67
      Top = 31
      Width = 35
      Height = 21
      TabOrder = 4
      Text = '45'
    end
    object CBR: TCheckBox
      Left = 243
      Top = 10
      Width = 33
      Height = 14
      Caption = 'R'
      Checked = True
      State = cbChecked
      TabOrder = 5
      OnClick = CBRClick
    end
    object CBG: TCheckBox
      Left = 243
      Top = 23
      Width = 32
      Height = 14
      Caption = 'G'
      Checked = True
      State = cbChecked
      TabOrder = 6
      OnClick = CBGClick
    end
    object CBB: TCheckBox
      Left = 243
      Top = 36
      Width = 34
      Height = 14
      Caption = 'B'
      Checked = True
      State = cbChecked
      TabOrder = 7
      OnClick = CBBClick
    end
    object BBStartStop: TBitBtn
      Left = 439
      Top = 7
      Width = 65
      Height = 23
      Caption = 'Comenzar'
      TabOrder = 8
      OnClick = BBStartStopClick
    end
    object CBMIP: TCheckBox
      Left = 282
      Top = 11
      Width = 46
      Height = 14
      Hint = 'Proyecci'#243'n de M'#225'ximas intensidades'
      Caption = 'PMI'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 9
      OnClick = CBMIPClick
    end
    object CBDistance: TCheckBox
      Left = 282
      Top = 32
      Width = 72
      Height = 13
      Caption = 'Distancia'
      TabOrder = 10
      OnClick = CBDistanceClick
    end
    object TBDistance: TTrackBar
      Left = 344
      Top = 30
      Width = 79
      Height = 20
      Enabled = False
      Max = 100
      Min = 1
      PageSize = 10
      Frequency = 10
      Position = 30
      TabOrder = 11
      OnChange = TBDistanceChange
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 1
    OnTimer = Timer1Timer
    Top = 1
  end
end
