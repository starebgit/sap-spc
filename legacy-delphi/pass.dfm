object FPassw: TFPassw
  Left = 0
  Top = 0
  Caption = 'Geslo'
  ClientHeight = 241
  ClientWidth = 524
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
    Width = 393
    Height = 241
    Align = alLeft
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 88
      Top = 72
      Width = 35
      Height = 18
      Caption = 'Geslo'
    end
    object Edit1: TEdit
      Left = 112
      Top = 96
      Width = 121
      Height = 26
      PasswordChar = '*'
      TabOrder = 0
      OnKeyPress = Edit1KeyPress
    end
  end
  object Panel2: TPanel
    Left = 393
    Top = 0
    Width = 131
    Height = 241
    Align = alClient
    TabOrder = 1
    object Button1: TButton
      Left = 32
      Top = 48
      Width = 75
      Height = 25
      Caption = 'V redu'
      ModalResult = 1
      TabOrder = 0
    end
  end
end
