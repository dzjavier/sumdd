object FSegmentation3D: TFSegmentation3D
  Left = 238
  Top = 155
  Width = 754
  Height = 589
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
    746
    555)
  PixelsPerInch = 96
  TextHeight = 13
  object IVSeries: TImgView32
    Left = 1
    Top = 3
    Width = 328
    Height = 478
    Anchors = [akLeft, akTop, akRight, akBottom]
    Centered = False
    Scale = 0.500000000000000000
    ScrollBars.ShowHandleGrip = True
    ScrollBars.Style = rbsDefault
    SizeGrip = sgAuto
    TabOrder = 0
    OnMouseMove = IVSeriesMouseMove
  end
  object ChHist: TChart
    Left = 333
    Top = 1
    Width = 412
    Height = 480
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
    Top = 483
    Width = 745
    Height = 70
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
      Left = 356
      Top = 11
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
      Left = 628
      Top = 13
      Width = 97
      Height = 17
      Caption = 'Background'
      Checked = True
      State = cbChecked
      TabOrder = 1
      OnClick = CBBackgroundClick
    end
    object CBFluorescence: TCheckBox
      Left = 628
      Top = 37
      Width = 97
      Height = 17
      Caption = 'Fluorescencia'
      TabOrder = 2
      OnClick = CBFluorescenceClick
    end
    object BBClearPoints: TBitBtn
      Left = 524
      Top = 13
      Width = 75
      Height = 25
      Caption = 'Limpiar'
      TabOrder = 3
      OnClick = BBClearPointsClick
    end
    object ERFB: TEdit
      Left = 362
      Top = 26
      Width = 121
      Height = 21
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
  end
end
