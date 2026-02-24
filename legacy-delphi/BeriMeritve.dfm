object FBeriMeritve: TFBeriMeritve
  Left = 0
  Top = 0
  Caption = 'FBeriMeritve'
  ClientHeight = 233
  ClientWidth = 451
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 313
    Height = 233
    Align = alLeft
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    ExplicitLeft = -6
    object RadioButton1: TRadioButton
      Left = 64
      Top = 56
      Width = 113
      Height = 17
      Caption = 'Beri meritve'
      TabOrder = 0
    end
    object RadioButton2: TRadioButton
      Left = 64
      Top = 109
      Width = 153
      Height = 17
      Caption = 'Ne beri meritev'
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 313
    Top = 0
    Width = 138
    Height = 233
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    ExplicitLeft = 360
    ExplicitTop = 64
    ExplicitWidth = 185
    ExplicitHeight = 41
    object Button1: TButton
      Left = 32
      Top = 48
      Width = 75
      Height = 25
      Caption = 'V redu'
      ModalResult = 1
      TabOrder = 0
    end
    object Button2: TButton
      Left = 32
      Top = 105
      Width = 75
      Height = 25
      Caption = 'Prekini'
      ModalResult = 2
      TabOrder = 1
    end
  end
end
