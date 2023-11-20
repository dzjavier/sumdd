object FImage: TFImage
  Left = 284
  Top = 195
  BorderIcons = [biSystemMenu, biMaximize]
  BorderStyle = bsSingle
  Caption = 'Captura de Im'#225'genes'
  ClientHeight = 458
  ClientWidth = 623
  Color = clInactiveBorder
  DefaultMonitor = dmPrimary
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -6
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
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  PrintScale = poNone
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  DesignSize = (
    623
    458)
  PixelsPerInch = 96
  TextHeight = 13
  object PCamera: TPanel
    Left = 413
    Top = 1
    Width = 208
    Height = 232
    Anchors = [akTop, akRight]
    BevelInner = bvRaised
    BorderStyle = bsSingle
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -8
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 12
      Top = 52
      Width = 121
      Height = 13
      Caption = 'Tiempo de Exposici'#243'n [s]:'
    end
    object LMean: TLabel
      Left = 25
      Top = 79
      Width = 108
      Height = 13
      Caption = 'Im'#225'genes a Promediar:'
    end
    object LXDim: TLabel
      Left = 49
      Top = 106
      Width = 84
      Height = 13
      Caption = 'Dimension X [pix]:'
    end
    object LYDim: TLabel
      Left = 49
      Top = 134
      Width = 84
      Height = 13
      Caption = 'Dimension Y [pix]:'
    end
    object ETime: TEdit
      Left = 135
      Top = 48
      Width = 55
      Height = 21
      AutoSelect = False
      HideSelection = False
      TabOrder = 1
      Text = '0.2'
      OnKeyPress = ETimeKeyPress
    end
    object CBDarkFrame: TCheckBox
      Left = 13
      Top = 163
      Width = 92
      Height = 16
      Caption = 'Campo Oscuro'
      TabOrder = 2
    end
    object CBFlatFrame: TCheckBox
      Left = 111
      Top = 162
      Width = 83
      Height = 16
      Caption = 'Campo Plano'
      Enabled = False
      TabOrder = 3
    end
    object EMean: TEdit
      Left = 135
      Top = 75
      Width = 44
      Height = 21
      TabOrder = 4
      Text = '1'
      OnKeyPress = EMeanKeyPress
    end
    object UDMean: TUpDown
      Left = 179
      Top = 75
      Width = 13
      Height = 21
      Associate = EMean
      Position = 1
      TabOrder = 5
    end
    object BBExpose: TBitBtn
      Left = 18
      Top = 184
      Width = 102
      Height = 38
      Hint = 'Capturar Imagen'
      Caption = 'Exponer (E)'
      Default = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TabStop = False
      OnClick = BBExposeClick
    end
    object PCameraTitle: TPanel
      Left = 2
      Top = 4
      Width = 199
      Height = 37
      Hint = 'Par'#225'metros de la C'#225'mara'
      BevelInner = bvRaised
      BorderStyle = bsSingle
      Caption = 'C'#225'mara'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
    end
    object EXDim: TEdit
      Left = 135
      Top = 101
      Width = 55
      Height = 21
      TabOrder = 7
      Text = '512'
      OnKeyPress = EXDimKeyPress
    end
    object EYDim: TEdit
      Left = 135
      Top = 130
      Width = 56
      Height = 21
      TabOrder = 8
      Text = '512'
      OnKeyPress = EYDimKeyPress
    end
    object BFocus: TButton
      Left = 132
      Top = 184
      Width = 55
      Height = 38
      Caption = 'Enfocar'
      TabOrder = 9
      OnClick = BFocusClick
    end
  end
  object PStage: TPanel
    Left = 413
    Top = 232
    Width = 208
    Height = 226
    Anchors = [akTop, akRight, akBottom]
    BevelInner = bvRaised
    BorderStyle = bsSingle
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -8
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object LSpeed: TLabel
      Left = 8
      Top = 132
      Width = 100
      Height = 13
      Caption = 'Velocidad [Micras/s]:'
    end
    object LDeltaZ: TLabel
      Left = 30
      Top = 102
      Width = 78
      Height = 13
      Caption = 'Delta Z [Micras]:'
    end
    object PStageTitle: TPanel
      Left = 2
      Top = 4
      Width = 199
      Height = 36
      Hint = 'Par'#225'metros de la Platina'
      BevelInner = bvRaised
      BorderStyle = bsSingle
      Caption = 'Platina'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
    object BMoveUp: TButton
      Left = 16
      Top = 46
      Width = 89
      Height = 39
      Caption = 'Mover Arriba'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      TabStop = False
      OnClick = BMoveUpClick
    end
    object BMoveDown: TButton
      Left = 104
      Top = 46
      Width = 89
      Height = 39
      Caption = 'Mover Abajo'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      TabStop = False
      OnClick = BMoveDownClick
    end
    object CBSpeed: TComboBox
      Left = 121
      Top = 129
      Width = 74
      Height = 21
      ItemHeight = 13
      TabOrder = 3
      TabStop = False
      Text = '2'
      OnKeyPress = CBSpeedKeyPress
      Items.Strings = (
        '1'
        '2'
        '3')
    end
    object CBDeltaZ: TComboBox
      Left = 121
      Top = 98
      Width = 74
      Height = 21
      ItemHeight = 13
      ItemIndex = 4
      TabOrder = 4
      TabStop = False
      Text = '10'
      OnKeyPress = CBDeltaZKeyPress
      Items.Strings = (
        '0.1'
        '0.25'
        '0.5'
        '1'
        '10'
        '20')
    end
  end
  object PData: TPanel
    Left = 0
    Top = 360
    Width = 410
    Height = 58
    Anchors = [akLeft, akRight, akBottom]
    BorderStyle = bsSingle
    TabOrder = 2
    object Label2: TLabel
      Left = 8
      Top = 10
      Width = 105
      Height = 13
      Caption = 'Coordenadas [micras]:'
    end
    object LIntensity: TLabel
      Left = 218
      Top = 10
      Width = 57
      Height = 13
      Caption = 'Intensisdad:'
    end
    object LMaxIntensity: TLabel
      Left = 44
      Top = 35
      Width = 94
      Height = 13
      Caption = 'Intensidad M'#225'xima: '
    end
    object LMinIntensity: TLabel
      Left = 179
      Top = 35
      Width = 93
      Height = 13
      Caption = 'Intensidad M'#237'nima: '
    end
    object ECoord: TEdit
      Left = 116
      Top = 7
      Width = 85
      Height = 21
      Cursor = crCross
      TabStop = False
      Color = cl3DLight
      ReadOnly = True
      TabOrder = 0
    end
    object EIntensity: TEdit
      Left = 279
      Top = 7
      Width = 60
      Height = 21
      Cursor = crCross
      TabStop = False
      Color = cl3DLight
      DragCursor = crCross
      ReadOnly = True
      TabOrder = 1
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 419
    Width = 410
    Height = 37
    Anchors = [akLeft, akRight, akBottom]
    BorderStyle = bsSingle
    TabOrder = 3
    object LObjective: TLabel
      Left = 8
      Top = 10
      Width = 54
      Height = 13
      Caption = 'L. Objetiva:'
    end
    object LScale: TLabel
      Left = 138
      Top = 10
      Width = 38
      Height = 13
      Caption = 'Escalar:'
    end
    object CBObjective: TComboBox
      Left = 65
      Top = 6
      Width = 53
      Height = 21
      ItemHeight = 13
      ItemIndex = 2
      TabOrder = 0
      TabStop = False
      Text = '20x'
      OnKeyPress = CBObjectiveKeyPress
      Items.Strings = (
        '4x'
        '10x'
        '20x'
        '40x'
        '100x')
    end
    object EScale: TEdit
      Left = 179
      Top = 6
      Width = 42
      Height = 21
      TabStop = False
      TabOrder = 1
      Text = '0.5'
      OnKeyPress = EScaleKeyPress
    end
    object BUpDate: TButton
      Left = 256
      Top = 4
      Width = 75
      Height = 25
      Hint = 'Actualizar Escala y Lente de Trabajo'
      Caption = 'Actualizar'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      TabStop = False
      OnClick = BUpDateClick
    end
  end
  object ImageCap: TImgView32
    Left = 1
    Top = 2
    Width = 408
    Height = 357
    Anchors = [akLeft, akTop, akRight, akBottom]
    Centered = False
    Scale = 0.500000000000000000
    ScrollBars.ShowHandleGrip = True
    ScrollBars.Style = rbsDefault
    SizeGrip = sgAuto
    TabOrder = 4
    OnMouseMove = ImageCapMouseMove
  end
  object MainMenu1: TMainMenu
    Left = 24
    Top = 168
    object IMMFile: TMenuItem
      Caption = 'Archivo'
      object IMMFSaveAs: TMenuItem
        Caption = 'Guardar Como'
        OnClick = IMMFSaveAsClick
      end
      object IMMFClose: TMenuItem
        Caption = 'Cerrar'
        OnClick = IMMFCloseClick
      end
    end
  end
  object SaveDialog1: TSaveDialog
    Filter = 'Tagged  Image File Format (tif)|*.tif;*.tiff'
    Left = 56
    Top = 168
  end
end
