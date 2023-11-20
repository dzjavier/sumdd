object FSegmentation3D: TFSegmentation3D
  Left = 115
  Top = 176
  Width = 805
  Height = 483
  Caption = 'Segmentaci'#243'n 3D'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    789
    447)
  PixelsPerInch = 96
  TextHeight = 13
  object IVSeries: TImgView32
    Left = 1
    Top = 3
    Width = 379
    Height = 358
    Anchors = [akLeft, akTop, akRight, akBottom]
    Centered = False
    Scale = 0.500000000000000000
    ScrollBars.ShowHandleGrip = True
    ScrollBars.Style = rbsDefault
    SizeGrip = sgAuto
    TabOrder = 0
    OnMouseDown = IVSeriesMouseDown
    OnMouseMove = IVSeriesMouseMove
    OnMouseUp = IVSeriesMouseUp
  end
  object ChHist: TChart
    Left = 384
    Top = 1
    Width = 401
    Height = 360
    AnimatedZoom = True
    BackWall.Brush.Color = clWhite
    BackWall.Color = clBtnFace
    Foot.Font.Charset = DEFAULT_CHARSET
    Foot.Font.Color = clBlack
    Foot.Font.Height = -11
    Foot.Font.Name = 'Arial'
    Foot.Font.Style = []
    Foot.Text.Strings = (
      'Intensidad')
    Title.Color = clWhite
    Title.Text.Strings = (
      'Histograma 3D')
    OnClickSeries = ChHistClickSeries
    BackColor = clBtnFace
    LeftAxis.AxisValuesFormat = '#,##0,###'
    LeftAxis.Title.Caption = 'Frecuencia Relativa'
    Legend.Alignment = laBottom
    Legend.Visible = False
    View3D = False
    View3DWalls = False
    BevelInner = bvLowered
    BorderWidth = 2
    Color = clWhite
    TabOrder = 1
    Anchors = [akTop, akRight, akBottom]
  end
  object Panel1: TPanel
    Left = 0
    Top = 361
    Width = 786
    Height = 84
    Anchors = [akLeft, akRight, akBottom]
    BevelInner = bvLowered
    TabOrder = 2
    object Label1: TLabel
      Left = 16
      Top = 13
      Width = 88
      Height = 13
      Caption = 'Serie de Im'#225'genes'
    end
    object LRFB: TLabel
      Left = 272
      Top = 6
      Width = 133
      Height = 13
      Caption = 'Relaci'#243'n Fluorscn./Bckgrnd'
    end
    object LScale: TLabel
      Left = 19
      Top = 44
      Width = 35
      Height = 13
      Caption = 'Escalar'
    end
    object Label2: TLabel
      Left = 129
      Top = 45
      Width = 49
      Height = 13
      Caption = 'Intensidad'
    end
    object LGlobalSNR: TLabel
      Left = 244
      Top = 53
      Width = 56
      Height = 13
      Caption = 'SNR Global'
    end
    object LROISNR: TLabel
      Left = 429
      Top = 5
      Width = 60
      Height = 13
      Caption = 'SNR de ROI'
    end
    object LCNR: TLabel
      Left = 385
      Top = 50
      Width = 23
      Height = 13
      Caption = 'CNR'
    end
    object TBImageSeries: TTrackBar
      Left = 104
      Top = 10
      Width = 150
      Height = 23
      Frequency = 0
      TabOrder = 0
      OnChange = TBImageSeriesChange
    end
    object CBBackground: TCheckBox
      Left = 518
      Top = 21
      Width = 97
      Height = 17
      Caption = 'Background'
      Checked = True
      State = cbChecked
      TabOrder = 1
      OnClick = CBBackgroundClick
    end
    object CBFluorescence: TCheckBox
      Left = 518
      Top = 45
      Width = 97
      Height = 17
      Caption = 'Fluorescencia'
      TabOrder = 2
      OnClick = CBFluorescenceClick
    end
    object BBClearPoints: TBitBtn
      Left = 612
      Top = 16
      Width = 75
      Height = 49
      Caption = 'Limpiar'
      TabOrder = 3
      OnClick = BBClearPointsClick
    end
    object ERFB: TEdit
      Left = 278
      Top = 22
      Width = 121
      Height = 21
      Color = cl3DLight
      ReadOnly = True
      TabOrder = 4
      Text = 'NaN'
    end
    object EScale: TEdit
      Left = 60
      Top = 40
      Width = 45
      Height = 21
      TabOrder = 5
      Text = '0.5'
      OnChange = EScaleChange
    end
    object EIntensity: TEdit
      Left = 185
      Top = 40
      Width = 41
      Height = 21
      Color = cl3DLight
      ReadOnly = True
      TabOrder = 6
      Text = '0'
    end
    object EGlobalSNR: TEdit
      Left = 304
      Top = 49
      Width = 49
      Height = 21
      Color = cl3DLight
      ReadOnly = True
      TabOrder = 7
    end
    object ESNRROI: TEdit
      Left = 415
      Top = 20
      Width = 89
      Height = 21
      Color = cl3DLight
      ReadOnly = True
      TabOrder = 8
    end
    object ECNR: TEdit
      Left = 414
      Top = 48
      Width = 91
      Height = 21
      Color = cl3DLight
      TabOrder = 9
    end
  end
end
