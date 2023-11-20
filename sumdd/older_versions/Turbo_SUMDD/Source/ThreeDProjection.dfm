object F3DProjection: TF3DProjection
  Left = 229
  Top = 119
  Caption = 'Proyecci'#243'n Tridimensional'
  ClientHeight = 544
  ClientWidth = 584
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  Menu = MMenu
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
    Top = 478
    Width = 584
    Height = 66
    Align = alBottom
    BorderStyle = bsSingle
    TabOrder = 0
    object LScale: TLabel
      Left = 104
      Top = 12
      Width = 70
      Height = 13
      Caption = 'Escalar en XY:'
    end
    object Label1: TLabel
      Left = 115
      Top = 31
      Width = 60
      Height = 13
      Caption = 'Escala en Z:'
    end
    object LAngX: TLabel
      Left = 8
      Top = 13
      Width = 54
      Height = 13
      Caption = 'Rotar en X:'
    end
    object LAngY: TLabel
      Left = 8
      Top = 31
      Width = 54
      Height = 13
      Caption = 'Rotar en Y:'
    end
    object BBUpDate: TBitBtn
      Left = 387
      Top = 32
      Width = 65
      Height = 23
      Caption = 'Actualizar'
      TabOrder = 0
      OnClick = BBUpDateClick
    end
    object EXYScale: TEdit
      Left = 177
      Top = 10
      Width = 32
      Height = 21
      TabOrder = 1
      Text = '1'
    end
    object EZScale: TEdit
      Left = 177
      Top = 29
      Width = 32
      Height = 21
      TabOrder = 2
      Text = '1'
    end
    object EAngX: TEdit
      Left = 63
      Top = 10
      Width = 35
      Height = 21
      TabOrder = 3
      Text = '45'
    end
    object EAngY: TEdit
      Left = 63
      Top = 30
      Width = 35
      Height = 21
      TabOrder = 4
      Text = '45'
    end
    object CBR: TCheckBox
      Left = 213
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
      Left = 213
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
      Left = 213
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
      Left = 387
      Top = 5
      Width = 65
      Height = 23
      Caption = 'Comenzar'
      TabOrder = 8
      OnClick = BBStartStopClick
    end
    object CBMIP: TCheckBox
      Left = 246
      Top = 13
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
      Left = 246
      Top = 34
      Width = 72
      Height = 13
      Caption = 'Distancia'
      TabOrder = 10
      OnClick = CBDistanceClick
    end
    object TBDistance: TTrackBar
      Left = 310
      Top = 31
      Width = 78
      Height = 20
      Enabled = False
      Max = 100
      Min = 1
      PageSize = 10
      Frequency = 10
      Position = 60
      TabOrder = 11
      OnChange = TBDistanceChange
    end
    object GBCoordinates: TGroupBox
      Left = 463
      Top = 1
      Width = 100
      Height = 58
      Caption = 'Coordenadas'
      TabOrder = 12
      object CBCube: TCheckBox
        Left = 8
        Top = 16
        Width = 80
        Height = 17
        Caption = 'Cubo'
        TabOrder = 0
        OnClick = CBCubeClick
      end
      object CBAxis: TCheckBox
        Left = 8
        Top = 32
        Width = 79
        Height = 17
        Caption = 'Ejes'
        TabOrder = 1
        OnClick = CBAxisClick
      end
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 1
    OnTimer = Timer1Timer
    Left = 24
    Top = 25
  end
  object MMenu: TMainMenu
    Left = 104
    Top = 24
    object MFile: TMenuItem
      Caption = 'Archivo'
      object MFSaveImg: TMenuItem
        Caption = 'Guardar Imagen'
        OnClick = MFSaveImgClick
      end
      object MFSaveAnimation: TMenuItem
        Caption = 'Guardar Animaci'#243'n'
        OnClick = MFSaveAnimationClick
      end
    end
  end
  object SPD3DProjection: TSaveDialog
    Left = 64
    Top = 24
  end
end
