object Fdefkanal: TFdefkanal
  Left = 0
  Top = 0
  Caption = 'Vpis '#353't. kanala'
  ClientHeight = 300
  ClientWidth = 635
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
    Width = 433
    Height = 300
    Align = alLeft
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 80
      Top = 80
      Width = 85
      Height = 19
      Caption = #352'tev. kanala'
    end
    object SpinEdit1: TSpinEdit
      Left = 112
      Top = 105
      Width = 121
      Height = 29
      MaxValue = 8
      MinValue = 1
      TabOrder = 0
      Value = 1
    end
  end
  object Panel2: TPanel
    Left = 433
    Top = 0
    Width = 202
    Height = 300
    Align = alClient
    TabOrder = 1
    object Button1: TButton
      Left = 48
      Top = 56
      Width = 75
      Height = 25
      Caption = 'V redu'
      ModalResult = 1
      TabOrder = 0
    end
    object Button2: TButton
      Left = 48
      Top = 120
      Width = 75
      Height = 25
      Caption = 'Prekini'
      ModalResult = 2
      TabOrder = 1
    end
  end
end
