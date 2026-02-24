object FDefAnaliza: TFDefAnaliza
  Left = 0
  Top = 0
  Caption = 'FDefAnaliza'
  ClientHeight = 551
  ClientWidth = 881
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
    Width = 681
    Height = 551
    Align = alLeft
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 40
      Top = 64
      Width = 96
      Height = 17
      Caption = 'Za'#269'etni datum '
    end
    object Label2: TLabel
      Left = 360
      Top = 64
      Width = 94
      Height = 17
      Caption = 'Kon'#269'ni datum '
    end
    object Picker1: TDateTimePicker
      Left = 64
      Top = 87
      Width = 186
      Height = 25
      Date = 44257.442967002320000000
      Time = 44257.442967002320000000
      TabOrder = 0
    end
    object Picker2: TDateTimePicker
      Left = 376
      Top = 87
      Width = 186
      Height = 25
      Date = 44257.443048043980000000
      Time = 44257.443048043980000000
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 681
    Top = 0
    Width = 200
    Height = 551
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object Button1: TButton
      Left = 56
      Top = 72
      Width = 75
      Height = 25
      Caption = 'V redu'
      ModalResult = 1
      TabOrder = 0
    end
    object Button2: TButton
      Left = 56
      Top = 144
      Width = 75
      Height = 25
      Caption = 'Prekini'
      ModalResult = 2
      TabOrder = 1
    end
  end
end
