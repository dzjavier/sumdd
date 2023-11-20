object MainWindow: TMainWindow
  Left = 378
  Top = 266
  HorzScrollBar.Style = ssFlat
  HorzScrollBar.Tracking = True
  VertScrollBar.Style = ssFlat
  VertScrollBar.Tracking = True
  AlphaBlend = True
  AutoScroll = False
  Caption = 'SUMDD 3.0'
  ClientHeight = 353
  ClientWidth = 431
  Color = clBtnFace
  DefaultMonitor = dmPrimary
  DockSite = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIForm
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
  Menu = MainMenu
  OldCreateOrder = False
  Position = poScreenCenter
  PrintScale = poNone
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    431
    353)
  PixelsPerInch = 96
  TextHeight = 13
  object IViewGalleryRaw: TImgView32
    Left = 2
    Top = 21
    Width = 59
    Height = 53
    AutoSize = True
    Constraints.MaxHeight = 600
    Constraints.MaxWidth = 800
    Scale = 1.000000000000000000
    ScrollBars.ShowHandleGrip = True
    ScrollBars.Style = rbsDefault
    SizeGrip = sgAuto
    TabOrder = 0
    OnMouseDown = IViewGalleryRawMouseDown
  end
  object IViewGalleryDeconv: TImgView32
    Left = 64
    Top = 21
    Width = 60
    Height = 53
    AutoSize = True
    Constraints.MaxHeight = 600
    Constraints.MaxWidth = 800
    Scale = 1.000000000000000000
    ScrollBars.ShowHandleGrip = True
    ScrollBars.Style = rbsDefault
    SizeGrip = sgAuto
    TabOrder = 1
    OnMouseDown = IViewGalleryDeconvMouseDown
  end
  object LVDataSectioning: TListView
    Left = 0
    Top = 77
    Width = 259
    Height = 259
    Anchors = [akLeft, akBottom]
    Columns = <>
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Pitch = fpFixed
    Font.Style = []
    IconOptions.AutoArrange = True
    Items.Data = {
      2E0200001100000000000000FFFFFFFFFFFFFFFF000000000000000000000000
      00FFFFFFFFFFFFFFFF00000000000000000A4573706563696D656E3A00000000
      FFFFFFFFFFFFFFFF0000000000000000064175746F723A00000000FFFFFFFFFF
      FFFFFF00000000000000000646656368613A00000000FFFFFFFFFFFFFFFF0000
      00000000000015542E206465204578706F73696369F36E205B735D3A00000000
      FFFFFFFFFFFFFFFF00000000000000000F4C656E7465204F626A65746976613A
      00000000FFFFFFFFFFFFFFFF00000000000000000E4D61676E69666963616369
      F36E3A00000000FFFFFFFFFFFFFFFF00000000000000000A496E6D65727369F3
      6E3A00000000FFFFFFFFFFFFFFFF0000000000000000094D61726361646F723A
      00000000FFFFFFFFFFFFFFFF00000000000000000A416E746963756572706F00
      000000FFFFFFFFFFFFFFFF000000000000000012446573636F6E766F6C756369
      6F6E61646F3A00000000FFFFFFFFFFFFFFFF000000000000000012416C676F72
      69746D6F206465204463762E3A00000000FFFFFFFFFFFFFFFF00000000000000
      000D5265736F6C756369F36E20583A00000000FFFFFFFFFFFFFFFF0000000000
      0000000D5265736F6C756369F36E20593A00000000FFFFFFFFFFFFFFFF000000
      00000000000C522E20646520436F6C6F723A00000000FFFFFFFFFFFFFFFF0000
      0000000000000844656C7461205A3A00000000FFFFFFFFFFFFFFFF0000000000
      0000000A53656363696F6E65733A}
    ParentFont = False
    TabOrder = 2
    ViewStyle = vsList
    Visible = False
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 431
    Height = 21
    Caption = 'ToolBar1'
    TabOrder = 3
  end
  object SBMainWindow: TStatusBar
    Left = 0
    Top = 334
    Width = 431
    Height = 19
    Panels = <
      item
        Text = 'Memoria Total:'
        Width = 200
      end
      item
        Text = 'Memoria Libre:'
        Width = 50
      end>
  end
  object MainMenu: TMainMenu
    Left = 200
    Top = 27
    object MMFile: TMenuItem
      Caption = 'Archivo'
      object MMFLoadSections: TMenuItem
        Caption = 'Cargar Seccionamiento'
        OnClick = MMFLoadSectionsClick
      end
      object MMSaveSectioning: TMenuItem
        Caption = 'Guardar Seccionamiento'
        Enabled = False
        OnClick = MMSaveSectioningClick
      end
      object MMFClose: TMenuItem
        Caption = 'Cerrar'
        OnClick = MMFCloseClick
      end
    end
    object MMAcquisition: TMenuItem
      Caption = 'Adquisici'#243'n'
      object MMAImage: TMenuItem
        Caption = 'Imagen'
        OnClick = MMAImageClick
      end
      object MMAVolumeSectioning: TMenuItem
        Caption = 'Seccionamiento Volumen'
        OnClick = MMAVolumeSectioningClick
      end
      object MATimeLapse: TMenuItem
        Caption = 'Time Lapse'
        OnClick = MATimeLapseClick
      end
    end
    object MMProcessing: TMenuItem
      Caption = 'Procesamiento'
      object MMPDeconvolution: TMenuItem
        Caption = 'Desconvoluci'#243'n'
        object MMPDNearestNeighbor: TMenuItem
          Caption = 'Planos Vecinos'
          Enabled = False
          OnClick = MMPDNearestNeighborClick
        end
        object MMPDLinearLeastSquare: TMenuItem
          Caption = 'M'#233'todo Lineal de los Cuadrados M'#237'nimos'
          Enabled = False
          OnClick = MMPDLinearLeastSquareClick
        end
        object MMPDConstrainedIterative: TMenuItem
          Caption = 'M'#233'todo Iterativo'
          Enabled = False
          OnClick = MMPDConstrainedIterativeClick
        end
        object MMPDWienerFilter2D: TMenuItem
          Caption = 'Filtro de Wiener 2D'
          Enabled = False
          OnClick = MMPDWienerFilter2DClick
        end
      end
      object MMPColoc2D: TMenuItem
        Caption = 'Colocalizaci'#243'n 2D'
        OnClick = MMPColoc2DClick
      end
      object MMPSegmentation3D: TMenuItem
        Caption = 'Segmentaci'#243'n 3D'
        Enabled = False
        OnClick = MMPSegmentation3DClick
      end
    end
    object MMVisualization: TMenuItem
      Caption = 'Visualizaci'#243'n'
      object MMV3DProjection: TMenuItem
        Caption = 'Proyecci'#243'n Tridimensional'
        OnClick = MMV3DProjectionClick
      end
    end
    object MMTools: TMenuItem
      Caption = 'Herramientas'
      object MMTCleanVolumes: TMenuItem
        Caption = 'Limpiar'
        object MMTCRaw: TMenuItem
          Caption = 'Volumen Crudo'
          OnClick = MMTCRawClick
        end
        object MMTCDesconv: TMenuItem
          Caption = 'Volumen Desconvolucionado'
          OnClick = MMTCDesconvClick
        end
        object MMTCSectioningData: TMenuItem
          Caption = 'Datos de Seccionamiento'
          OnClick = MMTCSectioningDataClick
        end
        object MMTCAll: TMenuItem
          Caption = 'Todas las Variables'
          OnClick = MMTCAllClick
        end
      end
      object MMTTemperatureControl: TMenuItem
        Caption = 'Control de Temperatura'
        OnClick = MMTTemperatureControlClick
      end
      object MMTControlOptions: TMenuItem
        Caption = 'Opciones de Control'
        OnClick = MMTControlOptionsClick
      end
    end
    object MMHelp: TMenuItem
      Caption = 'Ayuda'
      object MMHAbout: TMenuItem
        Caption = 'Acerca de SUMDD'
        OnClick = MMHAboutClick
      end
    end
  end
  object ODLoadSections: TOpenDialog
    Filter = 
      'sdf (Sectioning Data File)|*.sdf|tif, tiff (Tagged Image File Fo' +
      'rmat )|*.tif;*.tiff'
    FilterIndex = 2
    Left = 232
    Top = 27
  end
  object OPDLoadImage: TOpenPictureDialog
    Left = 264
    Top = 27
  end
  object TimerUpDate: TTimer
    OnTimer = TimerUpDateTimer
    Left = 165
    Top = 27
  end
end
