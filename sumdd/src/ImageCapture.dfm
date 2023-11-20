object FImage: TFImage
  Left = 149
  Top = 126
  BorderIcons = [biSystemMenu, biMaximize]
  BorderStyle = bsSingle
  Caption = 'Captura de Im'#225'genes'
  ClientHeight = 514
  ClientWidth = 882
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
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnMouseMove = FormMouseMove
  OnPaint = FormPaint
  OnResize = FormResize
  DesignSize = (
    882
    514)
  PixelsPerInch = 96
  TextHeight = 13
  object PCamera: TPanel
    Left = 675
    Top = 1
    Width = 208
    Height = 233
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
      Left = 7
      Top = 52
      Width = 129
      Height = 13
      Caption = 'Tiempo de Exposici'#243'n [ms]:'
    end
    object LMean: TLabel
      Left = 20
      Top = 79
      Width = 108
      Height = 13
      Caption = 'Im'#225'genes a Promediar:'
    end
    object LXDim: TLabel
      Left = 44
      Top = 106
      Width = 84
      Height = 13
      Caption = 'Dimension X [pix]:'
    end
    object LYDim: TLabel
      Left = 44
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
      OnKeyPress = ETimeKeyPress
    end
    object EMean: TEdit
      Left = 135
      Top = 75
      Width = 44
      Height = 21
      TabOrder = 2
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
      TabOrder = 3
    end
    object BBExpose: TBitBtn
      Left = 34
      Top = 185
      Width = 135
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
      TabOrder = 4
    end
    object EXDim: TEdit
      Left = 135
      Top = 101
      Width = 55
      Height = 21
      TabOrder = 5
      Text = '512'
      OnKeyPress = EXDimKeyPress
    end
    object EYDim: TEdit
      Left = 135
      Top = 130
      Width = 56
      Height = 21
      TabOrder = 6
      Text = '512'
      OnKeyPress = EYDimKeyPress
    end
    object CBCamControl: TComboBox
      Left = 32
      Top = 160
      Width = 145
      Height = 21
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 7
      Text = 'Imagen Prueba'
      Items.Strings = (
        'Imagen Prueba'
        'Control de Dosis'
        'Corriente oscura'
        'Promediado')
    end
  end
  object PStage: TPanel
    Left = 675
    Top = 296
    Width = 208
    Height = 219
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
      Left = 8
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
    Top = 417
    Width = 677
    Height = 60
    Anchors = [akLeft, akRight, akBottom]
    BorderStyle = bsSingle
    TabOrder = 2
    object Label2: TLabel
      Left = 6
      Top = 10
      Width = 105
      Height = 13
      Caption = 'Coordenadas [micras]:'
    end
    object LIntensity: TLabel
      Left = 274
      Top = 10
      Width = 57
      Height = 13
      Caption = 'Intensisdad:'
    end
    object LMaxIntensity: TLabel
      Left = 56
      Top = 35
      Width = 94
      Height = 13
      Caption = 'Intensidad M'#225'xima: '
    end
    object LMinIntensity: TLabel
      Left = 287
      Top = 35
      Width = 93
      Height = 13
      Caption = 'Intensidad M'#237'nima: '
    end
    object LDosis: TLabel
      Left = 486
      Top = 35
      Width = 29
      Height = 13
      Caption = 'Dosis:'
    end
    object LObjective: TLabel
      Left = 416
      Top = 8
      Width = 54
      Height = 13
      Caption = 'L. Objetiva:'
    end
    object LScale: TLabel
      Left = 538
      Top = 10
      Width = 38
      Height = 13
      Caption = 'Escalar:'
    end
    object ECoord: TEdit
      Left = 116
      Top = 7
      Width = 149
      Height = 21
      Cursor = crCross
      TabStop = False
      Color = cl3DLight
      ReadOnly = True
      TabOrder = 0
    end
    object EIntensity: TEdit
      Left = 336
      Top = 7
      Width = 65
      Height = 21
      Cursor = crCross
      TabStop = False
      Color = cl3DLight
      DragCursor = crCross
      ReadOnly = True
      TabOrder = 1
    end
    object CBObjective: TComboBox
      Left = 481
      Top = 6
      Width = 53
      Height = 21
      ItemHeight = 13
      ItemIndex = 2
      TabOrder = 2
      TabStop = False
      Text = '20x'
      OnChange = CBObjectiveChange
      OnKeyPress = CBObjectiveKeyPress
      Items.Strings = (
        '4x'
        '10x'
        '20x'
        '40x'
        '100x')
    end
    object CBScale: TComboBox
      Left = 592
      Top = 7
      Width = 57
      Height = 21
      Hint = 'Escala de dibujo'
      ItemHeight = 13
      TabOrder = 3
      Text = '0.50'
      OnChange = CBScaleChange
      Items.Strings = (
        '0.25'
        '0.50'
        '0.75'
        '1.00'
        '1.50'
        '2.00'
        '3.00'
        '4.00')
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 477
    Width = 677
    Height = 37
    Anchors = [akLeft, akRight, akBottom]
    BorderStyle = bsSingle
    TabOrder = 3
    object Label4: TLabel
      Left = 112
      Top = 8
      Width = 45
      Height = 13
      Caption = 'Contraste'
    end
    object Label5: TLabel
      Left = 8
      Top = 8
      Width = 22
      Height = 13
      Caption = 'Brillo'
    end
    object Lbright: TLabel
      Left = 72
      Top = 8
      Width = 28
      Height = 13
      Caption = 'lbright'
    end
    object Lcontrast: TLabel
      Left = 200
      Top = 8
      Width = 44
      Height = 13
      Caption = 'Lcontrast'
    end
    object Label6: TLabel
      Left = 256
      Top = 8
      Width = 36
      Height = 13
      Caption = 'Gamma'
    end
    object Lgammavalue: TLabel
      Left = 320
      Top = 8
      Width = 50
      Height = 13
      Caption = 'Valorgama'
    end
    object Label3: TLabel
      Left = 384
      Top = 8
      Width = 24
      Height = 13
      Caption = 'Color'
    end
    object UDBright: TUpDown
      Left = 40
      Top = -2
      Width = 19
      Height = 35
      Min = -1000
      Max = 1000
      TabOrder = 0
      OnClick = UDBrightClick
    end
    object UDContrast: TUpDown
      Left = 168
      Top = -2
      Width = 19
      Height = 35
      Min = -1000
      Max = 1000
      TabOrder = 1
      OnClick = UDContrastClick
    end
    object UDGamma: TUpDown
      Left = 296
      Top = -2
      Width = 19
      Height = 35
      Min = -1000
      Max = 1000
      TabOrder = 2
      OnClick = UDgammaClick
    end
    object Button1: TButton
      Left = 584
      Top = 0
      Width = 89
      Height = 33
      Caption = 'Reset'
      TabOrder = 3
      OnClick = Button1Click
    end
    object CBColorDisplay: TComboBox
      Left = 416
      Top = 4
      Width = 89
      Height = 21
      Hint = 'Color de dibujo'
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 4
      Text = 'Luminancia'
      OnChange = CBColorDisplayChange
      Items.Strings = (
        'Luminancia'
        'Rojo'
        'Verde'
        'Azul')
    end
  end
  object PLightMonitor: TPanel
    Left = 675
    Top = 234
    Width = 208
    Height = 62
    Anchors = [akTop, akRight]
    BevelInner = bvRaised
    BorderStyle = bsSingle
    TabOrder = 4
    object LLightMonitor: TLabel
      Left = 9
      Top = 5
      Width = 70
      Height = 13
      Caption = 'Monitor de Luz'
    end
    object PB: TProgressBar
      Left = 8
      Top = 24
      Width = 185
      Height = 17
      TabOrder = 0
    end
  end
  object MainMenu1: TMainMenu
    Left = 24
    Top = 250
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
    Filter = 
      'Tagged  Image File Format (tif)|*.tif;*.tiff|OME TIFF (ome.tiff)' +
      '|*.ome.tif;*.ome.tiff'
    Left = 56
    Top = 250
  end
  object TimerLightMonitor: TTimer
    Enabled = False
    Interval = 100
    OnTimer = TimerLightMonitorTimer
    Left = 89
    Top = 252
  end
end
