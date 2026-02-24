object FcasDoba: TFcasDoba
  Left = 0
  Top = 0
  Caption = 'FcasDoba'
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
    Width = 505
    Height = 300
    Align = alLeft
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 24
      Top = 48
      Width = 51
      Height = 18
      Caption = 'Za'#269'etek'
    end
    object Label2: TLabel
      Left = 296
      Top = 48
      Width = 40
      Height = 18
      Caption = 'Konec'
    end
    object Picker1: TDateTimePicker
      Left = 40
      Top = 72
      Width = 186
      Height = 26
      Date = 44145.552819039350000000
      Time = 44145.552819039350000000
      TabOrder = 0
    end
    object Picker2: TDateTimePicker
      Left = 304
      Top = 72
      Width = 186
      Height = 26
      Date = 44145.552852361110000000
      Time = 44145.552852361110000000
      TabOrder = 1
    end
  end
  object Button1: TButton
    Left = 536
    Top = 47
    Width = 75
    Height = 25
    Caption = 'V redu'
    ModalResult = 1
    TabOrder = 1
  end
end
