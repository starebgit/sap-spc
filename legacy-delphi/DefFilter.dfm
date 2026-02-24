object FDefFilter: TFDefFilter
  Left = 0
  Top = 0
  Caption = 'FDefFilter'
  ClientHeight = 477
  ClientWidth = 909
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
    Width = 713
    Height = 477
    Align = alLeft
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 72
      Top = 49
      Width = 92
      Height = 17
      Caption = 'Za'#269'etni datum'
    end
    object Label2: TLabel
      Left = 376
      Top = 49
      Width = 90
      Height = 17
      Caption = 'Kon'#269'ni datum'
    end
    object Label3: TLabel
      Left = 72
      Top = 176
      Width = 34
      Height = 17
      Caption = 'Koda'
    end
    object Label4: TLabel
      Left = 376
      Top = 176
      Width = 39
      Height = 17
      Caption = #352'ar'#382'a'
    end
    object Picker1: TDateTimePicker
      Left = 97
      Top = 72
      Width = 186
      Height = 25
      Date = 44299.382895949070000000
      Time = 44299.382895949070000000
      TabOrder = 0
    end
    object Picker2: TDateTimePicker
      Left = 392
      Top = 72
      Width = 186
      Height = 25
      Date = 44299.383035972220000000
      Time = 44299.383035972220000000
      TabOrder = 1
    end
    object Edit1: TEdit
      Left = 97
      Top = 199
      Width = 186
      Height = 25
      TabOrder = 2
    end
    object Edit2: TEdit
      Left = 392
      Top = 192
      Width = 186
      Height = 25
      TabOrder = 3
    end
  end
  object Panel2: TPanel
    Left = 713
    Top = 0
    Width = 196
    Height = 477
    Align = alClient
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object Button1: TButton
      Left = 64
      Top = 47
      Width = 75
      Height = 25
      Caption = 'V redu'
      ModalResult = 1
      TabOrder = 0
    end
    object Button2: TButton
      Left = 64
      Top = 120
      Width = 75
      Height = 25
      Caption = 'Prekini'
      ModalResult = 2
      TabOrder = 1
    end
  end
end
