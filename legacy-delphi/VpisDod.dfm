object FVpisDod: TFVpisDod
  Left = 0
  Top = 0
  Caption = 'FVpisDod'
  ClientHeight = 236
  ClientWidth = 546
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 417
    Height = 236
    Align = alLeft
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    ExplicitHeight = 296
    object Label1: TLabel
      Left = 32
      Top = 56
      Width = 38
      Height = 19
      Caption = 'Naziv'
    end
    object Edit1: TEdit
      Left = 48
      Top = 81
      Width = 345
      Height = 27
      TabOrder = 0
    end
  end
  object Panel2: TPanel
    Left = 417
    Top = 0
    Width = 129
    Height = 236
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    ExplicitLeft = 448
    ExplicitTop = 88
    ExplicitWidth = 185
    ExplicitHeight = 41
    object Button1: TButton
      Left = 32
      Top = 40
      Width = 75
      Height = 25
      Caption = 'V redu'
      ModalResult = 1
      TabOrder = 0
    end
    object Button2: TButton
      Left = 32
      Top = 97
      Width = 75
      Height = 25
      Caption = 'Prekini'
      ModalResult = 2
      TabOrder = 1
    end
  end
end
