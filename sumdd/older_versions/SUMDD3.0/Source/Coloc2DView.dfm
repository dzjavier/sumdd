object FColoc2DView: TFColoc2DView
  Left = 318
  Top = 178
  Width = 676
  Height = 426
  Caption = 'Colocalizaci'#243'n'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  Menu = MMColocview
  OldCreateOrder = False
  DesignSize = (
    668
    370)
  PixelsPerInch = 120
  TextHeight = 16
  object ImColocView: TImgView32
    Left = 1
    Top = 1
    Width = 404
    Height = 364
    Anchors = [akLeft, akTop, akRight, akBottom]
    Scale = 1
    ScrollBars.Color = clScrollBar
    ScrollBars.ShowHandleGrip = True
    ScrollBars.Style = rbsDefault
    SizeGrip = sgAuto
    TabOrder = 0
  end
  object PColocresults: TPanel
    Left = 409
    Top = 2
    Width = 256
    Height = 366
    Anchors = [akTop, akRight, akBottom]
    BorderStyle = bsSingle
    TabOrder = 1
    object LPearsonCoef: TLabel
      Left = 24
      Top = 69
      Width = 143
      Height = 16
      Caption = 'Coeficiente de Pearson:'
    end
    object LCorrelationCoef: TLabel
      Left = 6
      Top = 104
      Width = 161
      Height = 16
      Caption = 'Coeficiente de Correlaci'#243'n:'
    end
    object LK1Coef: TLabel
      Left = 37
      Top = 139
      Width = 130
      Height = 16
      Caption = 'Coficiente de Corr. K1:'
    end
    object LK2Coef: TLabel
      Left = 29
      Top = 174
      Width = 138
      Height = 16
      Caption = 'Coeficiente de Corr. K2:'
    end
    object LcoloccoefMm1: TLabel
      Left = 16
      Top = 209
      Width = 151
      Height = 16
      Caption = 'Coeficiente de Coloc. m1:'
    end
    object LColocCoefMm2: TLabel
      Left = 16
      Top = 244
      Width = 151
      Height = 16
      Caption = 'Coeficiente de Coloc. m2:'
    end
    object LColocCoefM1: TLabel
      Left = 16
      Top = 276
      Width = 151
      Height = 16
      Caption = 'Coeficiente de Coloc. M1:'
    end
    object LColocCoefM2: TLabel
      Left = 16
      Top = 308
      Width = 151
      Height = 16
      Caption = 'Coeficiente de Coloc. M2:'
    end
    object PResults: TPanel
      Left = 3
      Top = 3
      Width = 246
      Height = 42
      BorderStyle = bsSingle
      Caption = 'Resultados Colocalizaci'#243'n'
      TabOrder = 0
    end
    object EPearsonCoef: TEdit
      Left = 168
      Top = 65
      Width = 67
      Height = 24
      Color = clInactiveCaptionText
      ReadOnly = True
      TabOrder = 1
    end
    object ECorrCoef: TEdit
      Left = 168
      Top = 100
      Width = 67
      Height = 24
      Color = clInactiveCaptionText
      ReadOnly = True
      TabOrder = 2
    end
    object EK1CorrCoef: TEdit
      Left = 168
      Top = 135
      Width = 67
      Height = 24
      Color = clInactiveCaptionText
      ReadOnly = True
      TabOrder = 3
    end
    object EK2CorrCoef: TEdit
      Left = 168
      Top = 170
      Width = 67
      Height = 24
      Color = clInactiveCaptionText
      ReadOnly = True
      TabOrder = 4
    end
    object EColocCoefMm1: TEdit
      Left = 168
      Top = 205
      Width = 67
      Height = 24
      Color = clInactiveCaptionText
      TabOrder = 5
    end
    object EColocCoefMm2: TEdit
      Left = 168
      Top = 240
      Width = 67
      Height = 24
      Color = clInactiveCaptionText
      TabOrder = 6
    end
    object EColocCoefM1: TEdit
      Left = 168
      Top = 272
      Width = 67
      Height = 24
      Color = clInactiveCaptionText
      ReadOnly = True
      TabOrder = 7
    end
    object EColocCoefM2: TEdit
      Left = 168
      Top = 304
      Width = 67
      Height = 24
      Color = clInactiveCaptionText
      ReadOnly = True
      TabOrder = 8
    end
  end
  object MMColocview: TMainMenu
    Left = 8
    Top = 8
    object MMFile: TMenuItem
      Caption = 'File'
      object MMFSave: TMenuItem
        Caption = 'Guardar'
        OnClick = MMFSaveClick
      end
    end
  end
  object SDColoc: TSaveDialog
    Filter = 'Tagged Image File Format (*.tif; *.tiff)|*.tif; *.tiff'
    Left = 40
    Top = 8
  end
end
