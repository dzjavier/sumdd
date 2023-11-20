object FActivityProgress: TFActivityProgress
  Left = 307
  Top = 218
  Cursor = crArrow
  BorderStyle = bsDialog
  ClientHeight = 127
  ClientWidth = 331
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 120
  TextHeight = 16
  object Panel1: TPanel
    Left = 1
    Top = 2
    Width = 328
    Height = 123
    BorderStyle = bsSingle
    TabOrder = 0
    object LProgress: TLabel
      Left = 152
      Top = 46
      Width = 3
      Height = 16
    end
    object PBActivityProgress: TProgressBar
      Left = 6
      Top = 5
      Width = 311
      Height = 36
      Min = 0
      Max = 100
      Smooth = True
      Step = 1
      TabOrder = 0
    end
    object BBProcessCancel: TBitBtn
      Left = 109
      Top = 71
      Width = 96
      Height = 42
      Caption = 'Cancelar'
      ModalResult = 2
      TabOrder = 1
      OnClick = BBProcessCancelClick
    end
  end
end
