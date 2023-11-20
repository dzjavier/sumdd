object FActivityProgress: TFActivityProgress
  Left = 307
  Top = 218
  Cursor = crArrow
  BorderStyle = bsDialog
  ClientHeight = 103
  ClientWidth = 269
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 1
    Top = 2
    Width = 266
    Height = 100
    BorderStyle = bsSingle
    TabOrder = 0
    object LProgress: TLabel
      Left = 124
      Top = 37
      Width = 3
      Height = 13
    end
    object PBActivityProgress: TProgressBar
      Left = 5
      Top = 4
      Width = 253
      Height = 29
      Smooth = True
      Step = 1
      TabOrder = 0
    end
    object BBProcessCancel: TBitBtn
      Left = 89
      Top = 58
      Width = 78
      Height = 34
      Caption = 'Cancelar'
      ModalResult = 2
      TabOrder = 1
      OnClick = BBProcessCancelClick
    end
  end
end
