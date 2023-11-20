object FColoc2DView: TFColoc2DView
  Left = 318
  Top = 178
  Caption = 'Colocalizaci'#243'n'
  ClientHeight = 370
  ClientWidth = 660
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  Menu = MMColocview
  OldCreateOrder = False
  DesignSize = (
    660
    370)
  PixelsPerInch = 96
  TextHeight = 13
  object PColocresults: TPanel
    Left = 332
    Top = 2
    Width = 208
    Height = 297
    Anchors = [akTop, akRight, akBottom]
    BorderStyle = bsSingle
    TabOrder = 0
    object LPearsonCoef: TLabel
      Left = 20
      Top = 56
      Width = 113
      Height = 13
      Caption = 'Coeficiente de Pearson:'
    end
    object LCorrelationCoef: TLabel
      Left = 5
      Top = 85
      Width = 127
      Height = 13
      Caption = 'Coeficiente de Correlaci'#243'n:'
    end
    object LK1Coef: TLabel
      Left = 30
      Top = 113
      Width = 106
      Height = 13
      Caption = 'Coficiente de Corr. K1:'
    end
    object LK2Coef: TLabel
      Left = 24
      Top = 141
      Width = 112
      Height = 13
      Caption = 'Coeficiente de Corr. K2:'
    end
    object LcoloccoefMm1: TLabel
      Left = 13
      Top = 170
      Width = 121
      Height = 13
      Caption = 'Coeficiente de Coloc. m1:'
    end
    object LColocCoefMm2: TLabel
      Left = 13
      Top = 198
      Width = 121
      Height = 13
      Caption = 'Coeficiente de Coloc. m2:'
    end
    object LColocCoefM1: TLabel
      Left = 13
      Top = 224
      Width = 122
      Height = 13
      Caption = 'Coeficiente de Coloc. M1:'
    end
    object LColocCoefM2: TLabel
      Left = 13
      Top = 250
      Width = 122
      Height = 13
      Caption = 'Coeficiente de Coloc. M2:'
    end
    object PResults: TPanel
      Left = 2
      Top = 2
      Width = 200
      Height = 35
      BorderStyle = bsSingle
      Caption = 'Resultados Colocalizaci'#243'n'
      TabOrder = 0
    end
    object EPearsonCoef: TEdit
      Left = 137
      Top = 53
      Width = 54
      Height = 24
      Color = clInactiveCaptionText
      ReadOnly = True
      TabOrder = 1
    end
    object ECorrCoef: TEdit
      Left = 137
      Top = 81
      Width = 54
      Height = 24
      Color = clInactiveCaptionText
      ReadOnly = True
      TabOrder = 2
    end
    object EK1CorrCoef: TEdit
      Left = 137
      Top = 110
      Width = 54
      Height = 24
      Color = clInactiveCaptionText
      ReadOnly = True
      TabOrder = 3
    end
    object EK2CorrCoef: TEdit
      Left = 137
      Top = 138
      Width = 54
      Height = 24
      Color = clInactiveCaptionText
      ReadOnly = True
      TabOrder = 4
    end
    object EColocCoefMm1: TEdit
      Left = 137
      Top = 167
      Width = 54
      Height = 24
      Color = clInactiveCaptionText
      TabOrder = 5
    end
    object EColocCoefMm2: TEdit
      Left = 137
      Top = 195
      Width = 54
      Height = 24
      Color = clInactiveCaptionText
      TabOrder = 6
    end
    object EColocCoefM1: TEdit
      Left = 137
      Top = 221
      Width = 54
      Height = 24
      Color = clInactiveCaptionText
      ReadOnly = True
      TabOrder = 7
    end
    object EColocCoefM2: TEdit
      Left = 137
      Top = 247
      Width = 54
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
