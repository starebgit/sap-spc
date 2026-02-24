object FIzborSarza: TFIzborSarza
  Left = 0
  Top = 0
  Caption = 'Izbor '#353'ar'#382
  ClientHeight = 399
  ClientWidth = 491
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
    Width = 361
    Height = 399
    Align = alLeft
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    ExplicitHeight = 300
    object Label1: TLabel
      Left = 64
      Top = 32
      Width = 84
      Height = 18
      Caption = 'Seznam '#353'ar'#382
    end
    object ListBox1: TListBox
      Left = 80
      Top = 56
      Width = 193
      Height = 297
      ItemHeight = 18
      TabOrder = 0
    end
  end
  object Panel2: TPanel
    Left = 361
    Top = 0
    Width = 130
    Height = 399
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    ExplicitLeft = 392
    ExplicitTop = 96
    ExplicitWidth = 185
    ExplicitHeight = 41
    object Button1: TButton
      Left = 24
      Top = 72
      Width = 75
      Height = 25
      Caption = 'V redu'
      ModalResult = 1
      TabOrder = 0
    end
  end
end
