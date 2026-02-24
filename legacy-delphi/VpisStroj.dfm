object FvpisStroj: TFvpisStroj
  Left = 0
  Top = 0
  Caption = 'Izbor stroja'
  ClientHeight = 544
  ClientWidth = 1219
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1219
    Height = 449
    Align = alTop
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 48
      Top = 25
      Width = 93
      Height = 17
      Caption = 'Delovne enote'
    end
    object Label2: TLabel
      Left = 288
      Top = 25
      Width = 64
      Height = 17
      Caption = 'Delavnice'
    end
    object Label3: TLabel
      Left = 672
      Top = 25
      Width = 33
      Height = 17
      Caption = 'Stroji'
    end
    object List1: TListBox
      Left = 48
      Top = 48
      Width = 145
      Height = 97
      ItemHeight = 17
      TabOrder = 0
      OnClick = List1Click
    end
    object List2: TListBox
      Left = 288
      Top = 48
      Width = 289
      Height = 337
      ItemHeight = 17
      TabOrder = 1
      OnClick = List2Click
    end
    object List3: TListBox
      Left = 672
      Top = 48
      Width = 465
      Height = 337
      ItemHeight = 17
      MultiSelect = True
      TabOrder = 2
    end
  end
  object Button1: TButton
    Left = 360
    Top = 488
    Width = 75
    Height = 25
    Caption = 'V redu'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 592
    Top = 488
    Width = 75
    Height = 25
    Caption = 'Prekini'
    TabOrder = 2
    OnClick = Button2Click
  end
end
