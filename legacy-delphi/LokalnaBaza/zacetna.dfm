object Fzacetna: TFzacetna
  Left = 0
  Top = 0
  Caption = 'Fzacetna'
  ClientHeight = 942
  ClientWidth = 1485
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1485
    Height = 217
    Align = alTop
    BevelOuter = bvLowered
    Color = clBackground
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    object Label2: TLabel
      Left = 248
      Top = 8
      Width = 33
      Height = 17
      Caption = 'Stroji'
    end
    object Label3: TLabel
      Left = 888
      Top = 8
      Width = 34
      Height = 17
      Caption = 'Koda'
    end
    object Label4: TLabel
      Left = 1125
      Top = 8
      Width = 103
      Height = 17
      Caption = 'Kontrolna '#353'ar'#382'a'
      Visible = False
    end
    object List3: TListBox
      Left = 272
      Top = 31
      Width = 337
      Height = 180
      ItemHeight = 17
      TabOrder = 0
      OnClick = List3Click
    end
    object list4: TListBox
      Left = 904
      Top = 31
      Width = 161
      Height = 97
      ItemHeight = 17
      TabOrder = 1
      OnClick = list4Click
    end
    object list5: TListBox
      Left = 1137
      Top = 31
      Width = 161
      Height = 97
      ItemHeight = 17
      TabOrder = 2
      Visible = False
      OnClick = list5Click
    end
    object Button4: TButton
      Left = 56
      Top = 120
      Width = 145
      Height = 33
      Caption = 'Iz lokalne baze '
      TabOrder = 3
      OnClick = Button4Click
    end
    object Button8: TButton
      Left = 56
      Top = 31
      Width = 145
      Height = 33
      Caption = 'Iz baze na serverju '
      TabOrder = 4
      OnClick = Button8Click
    end
    object list6: TListBox
      Left = 640
      Top = 31
      Width = 121
      Height = 180
      ItemHeight = 17
      TabOrder = 5
      Visible = False
    end
    object Edit2: TEdit
      Left = 40
      Top = 176
      Width = 121
      Height = 25
      TabOrder = 6
      OnChange = Edit2Change
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 217
    Width = 1485
    Height = 475
    Align = alTop
    BevelOuter = bvLowered
    Color = clBtnHighlight
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 1
    object Panel3: TPanel
      Left = 1
      Top = 1
      Width = 1136
      Height = 473
      Align = alLeft
      BevelOuter = bvLowered
      TabOrder = 0
      object Karakti: TStringGrid
        Left = 1
        Top = 1
        Width = 1134
        Height = 471
        Align = alClient
        ColCount = 10
        FixedCols = 6
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goTabs]
        TabOrder = 0
        OnClick = KaraktiClick
        OnDblClick = KaraktiDblClick
        OnDrawCell = KaraktiDrawCell
        RowHeights = (
          24
          24
          24
          24
          24)
      end
    end
    object Panel5: TPanel
      Left = 1137
      Top = 1
      Width = 347
      Height = 473
      Align = alClient
      TabOrder = 1
      object Label6: TLabel
        Left = 178
        Top = 10
        Width = 94
        Height = 16
        Caption = #352'tevilo decimalk'
      end
      object Label5: TLabel
        Left = 13
        Top = 10
        Width = 59
        Height = 16
        Caption = #352't. kanala'
      end
      object Button7: TButton
        Left = 183
        Top = 180
        Width = 113
        Height = 33
        Caption = 'Lok. baza->SAP'
        TabOrder = 0
        OnClick = Button7Click
      end
      object Button5: TButton
        Left = 184
        Top = 272
        Width = 137
        Height = 45
        Caption = 'Prepis v lok. bazo'
        Enabled = False
        TabOrder = 1
        OnClick = Button5Click
      end
      object Button2: TButton
        Left = 14
        Top = 92
        Width = 114
        Height = 33
        Caption = 'Prenos meritev'
        TabOrder = 2
        OnClick = Button2Click
      end
      object Button10: TButton
        Left = 165
        Top = 340
        Width = 75
        Height = 25
        Caption = 'Vaga'
        TabOrder = 3
        Visible = False
        OnClick = Button10Click
      end
      object Button1: TButton
        Left = 14
        Top = 180
        Width = 114
        Height = 33
        Caption = 'Prepis v SAP'
        TabOrder = 4
        OnClick = Button1Click
      end
      object SpinEdit1: TSpinEdit
        Left = 38
        Top = 32
        Width = 82
        Height = 26
        MaxValue = 0
        MinValue = 0
        TabOrder = 5
        Value = 1
      end
      object SpinEdit2: TSpinEdit
        Left = 199
        Top = 32
        Width = 81
        Height = 26
        MaxValue = 0
        MinValue = 0
        TabOrder = 6
        Value = 2
      end
      object Button11: TButton
        Left = 181
        Top = 92
        Width = 131
        Height = 33
        Caption = 'Prenos s stopalko'
        TabOrder = 7
        OnClick = Button11Click
      end
      object Button12: TButton
        Left = 246
        Top = 344
        Width = 75
        Height = 25
        Caption = 'Button12'
        TabOrder = 8
        Visible = False
        OnClick = Button12Click
      end
      object Button13: TButton
        Left = 184
        Top = 131
        Width = 75
        Height = 25
        Caption = 'Prekini'
        TabOrder = 9
        OnClick = Button13Click
      end
      object Button14: TButton
        Left = 24
        Top = 336
        Width = 121
        Height = 49
        Caption = 'Prekini MinMax'
        TabOrder = 10
        OnClick = Button14Click
      end
      object Edit3: TEdit
        Left = 24
        Top = 400
        Width = 97
        Height = 24
        TabOrder = 11
      end
      object Button15: TButton
        Left = 248
        Top = 375
        Width = 75
        Height = 25
        Caption = 'Button15'
        TabOrder = 12
        Visible = False
        OnClick = Button15Click
      end
      object Edit4: TEdit
        Left = 24
        Top = 430
        Width = 313
        Height = 24
        TabOrder = 13
      end
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 692
    Width = 1485
    Height = 250
    Align = alClient
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object attri: TStringGrid
      Left = 1
      Top = 1
      Width = 704
      Height = 248
      Align = alLeft
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
      TabOrder = 0
    end
    object Button6: TButton
      Left = 1392
      Top = 224
      Width = 75
      Height = 25
      Caption = 'Button6'
      TabOrder = 1
      Visible = False
      OnClick = Button6Click
    end
    object Button3: TButton
      Left = 760
      Top = 32
      Width = 114
      Height = 33
      Caption = 'Konec '
      TabOrder = 2
      OnClick = Button3Click
    end
    object Button9: TButton
      Left = 992
      Top = 32
      Width = 107
      Height = 33
      Caption = 'Semafor'
      TabOrder = 3
      OnClick = Button9Click
    end
    object CheckBox1: TCheckBox
      Left = 1240
      Top = 32
      Width = 97
      Height = 17
      Caption = 'CheckBox1'
      TabOrder = 4
      Visible = False
      OnClick = CheckBox1Click
    end
    object Edit1: TEdit
      Left = 1008
      Top = 88
      Width = 161
      Height = 26
      TabOrder = 5
      Visible = False
    end
  end
  object MainMenu1: TMainMenu
    Left = 16
    Top = 248
    object Lokalnabaza1: TMenuItem
      Caption = 'Lokalna baza'
      object Linijekode1: TMenuItem
        Caption = 'Linije-kode'
        OnClick = Linijekode1Click
      end
      object Linijestrunice1: TMenuItem
        Caption = 'Linije-stru'#382'nice'
        OnClick = Linijestrunice1Click
      end
      object Kodaare1: TMenuItem
        Caption = 'Koda-'#353'ar'#382'e'
        OnClick = Kodaare1Click
      end
      object arekarakteristike1: TMenuItem
        Caption = #352'ar'#382'e-karakteristike'
        OnClick = arekarakteristike1Click
      end
      object Meritve1: TMenuItem
        Caption = 'Meritve'
        OnClick = Meritve1Click
      end
    end
    object Postaje1: TMenuItem
      Caption = 'Baza na serverju'
      object Postaje2: TMenuItem
        Caption = 'Postaje'
        OnClick = Postaje1Click
      end
      object Stroji2: TMenuItem
        Caption = 'Stroji'
        OnClick = Stroji1Click
      end
      object Kontrolniplani1: TMenuItem
        Caption = 'Kontrolni plani'
        OnClick = Kontrolniplani1Click
      end
    end
  end
  object Timer1: TTimer
    Interval = 10000
    OnTimer = Timer1Timer
    Left = 40
    Top = 32
  end
end
