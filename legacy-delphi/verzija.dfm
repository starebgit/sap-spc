object Fverzija: TFverzija
  Left = 0
  Top = 0
  Caption = 'Vizitka'
  ClientHeight = 395
  ClientWidth = 562
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
    Width = 562
    Height = 321
    Align = alTop
    Color = clActiveCaption
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 184
      Top = 151
      Width = 86
      Height = 18
      Caption = 'Verzija 1.2.3'
    end
    object Label2: TLabel
      Left = 184
      Top = 96
      Width = 176
      Height = 19
      Caption = 'Program merilna mesta'
      Font.Charset = EASTEUROPE_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 184
      Top = 200
      Width = 127
      Height = 18
      Caption = 'ETA d.o.o. Cerkno'
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 321
    Width = 562
    Height = 74
    Align = alClient
    TabOrder = 1
    object Button1: TButton
      Left = 224
      Top = 32
      Width = 75
      Height = 25
      Caption = 'V redu'
      Font.Charset = EASTEUROPE_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = []
      ModalResult = 1
      ParentFont = False
      TabOrder = 0
    end
  end
end
