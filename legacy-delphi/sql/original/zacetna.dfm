object Fzacetna: TFzacetna
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  Caption = 'Program merilnega mesta'
  ClientHeight = 806
  ClientWidth = 1330
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
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1330
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
      Left = 275
      Top = 8
      Width = 41
      Height = 17
      Caption = 'Stroji :'
    end
    object Label3: TLabel
      Left = 660
      Top = 8
      Width = 42
      Height = 17
      Caption = 'Koda :'
    end
    object Label1: TLabel
      Left = 1017
      Top = 139
      Width = 43
      Height = 17
      Caption = 'Label1'
      Visible = False
    end
    object Label10: TLabel
      Left = 768
      Top = 200
      Width = 4
      Height = 17
      Font.Charset = EASTEUROPE_CHARSET
      Font.Color = clRed
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 13
      Top = 8
      Width = 95
      Height = 17
      Caption = 'Merilno mesto:'
    end
    object Label5: TLabel
      Left = 13
      Top = 62
      Width = 62
      Height = 17
      Caption = 'Operater:'
    end
    object Label6: TLabel
      Left = 13
      Top = 116
      Width = 62
      Height = 17
      Caption = 'Prijavljen:'
    end
    object Label11: TLabel
      Left = 32
      Top = 32
      Width = 54
      Height = 18
      Caption = 'Label11'
      Color = clAqua
      Font.Charset = EASTEUROPE_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object Label12: TLabel
      Left = 32
      Top = 85
      Width = 76
      Height = 18
      Caption = '(ni prijave)'
      Font.Charset = EASTEUROPE_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label13: TLabel
      Left = 32
      Top = 139
      Width = 55
      Height = 18
      Caption = 'Label13'
      Font.Charset = EASTEUROPE_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label14: TLabel
      Left = 872
      Top = 8
      Width = 102
      Height = 17
      Caption = 'Dodatna izbira :'
      Visible = False
    end
    object List3: TListBox
      Left = 272
      Top = 31
      Width = 337
      Height = 172
      ItemHeight = 17
      TabOrder = 0
      OnClick = List3Click
    end
    object list4: TListBox
      Left = 660
      Top = 31
      Width = 161
      Height = 170
      ItemHeight = 17
      TabOrder = 1
      OnClick = list4Click
    end
    object Button4: TButton
      Left = 81
      Top = 172
      Width = 145
      Height = 33
      Caption = 'Iz lokalne baze '
      TabOrder = 2
      OnClick = Button4Click
    end
    object Button8: TButton
      Left = 287
      Top = 1
      Width = 145
      Height = 33
      Caption = 'Iz baze na serverju '
      TabOrder = 3
      Visible = False
      OnClick = Button8Click
    end
    object Edit2: TEdit
      Left = 40
      Top = 176
      Width = 121
      Height = 25
      TabOrder = 4
      OnChange = Edit2Change
    end
    object Button19: TButton
      Left = 81
      Top = 176
      Width = 116
      Height = 25
      Caption = 'Prijava admin'
      TabOrder = 5
      OnClick = Button19Click
    end
    object DodIzbor: TListBox
      Left = 872
      Top = 31
      Width = 161
      Height = 170
      ItemHeight = 17
      TabOrder = 6
      Visible = False
    end
    object Panel7: TPanel
      Left = 1108
      Top = 1
      Width = 221
      Height = 215
      Align = alRight
      Color = clBackground
      ParentBackground = False
      TabOrder = 7
      object Image1: TImage
        Left = 1
        Top = 1
        Width = 219
        Height = 213
        Align = alClient
        ExplicitLeft = -43
        ExplicitWidth = 264
        ExplicitHeight = 152
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 217
    Width = 1330
    Height = 589
    Align = alClient
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
    object panel3: TPanel
      Left = 1
      Top = 1
      Width = 1107
      Height = 587
      Align = alClient
      BevelOuter = bvLowered
      TabOrder = 1
      object Button14: TButton
        Left = 39
        Top = 159
        Width = 138
        Height = 57
        Caption = 'Prekini MinMax'
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = Button14Click
      end
      object Button5: TButton
        Left = 166
        Top = 159
        Width = 153
        Height = 57
        Caption = 'Prepis v lok. bazo'
        Enabled = False
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = Button5Click
      end
      object Panel4: TPanel
        Left = 1
        Top = 329
        Width = 1105
        Height = 257
        Align = alBottom
        Color = clMedGray
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentBackground = False
        ParentFont = False
        TabOrder = 2
        object attri: TStringGrid
          Left = 1
          Top = 36
          Width = 1103
          Height = 220
          Align = alClient
          DefaultColWidth = 80
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
          TabOrder = 0
          OnDrawCell = attriDrawCell
        end
        object Edit1: TEdit
          Left = 904
          Top = 0
          Width = 161
          Height = 26
          TabOrder = 1
          Visible = False
        end
        object Panel10: TPanel
          Left = 1
          Top = 1
          Width = 1103
          Height = 35
          Align = alTop
          Caption = 'Atributivne karakteristike'
          Color = clGradientActiveCaption
          Font.Charset = EASTEUROPE_CHARSET
          Font.Color = clWhite
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 2
        end
      end
      object Panel8: TPanel
        Left = 1
        Top = 1
        Width = 1105
        Height = 328
        Align = alClient
        Caption = 'Panel8'
        TabOrder = 3
        object Karakti: TStringGrid
          Left = 1
          Top = 36
          Width = 1103
          Height = 291
          Align = alClient
          ColCount = 12
          FixedCols = 6
          Font.Charset = EASTEUROPE_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goTabs]
          ParentFont = False
          TabOrder = 0
          OnClick = KaraktiClick
          OnDblClick = KaraktiDblClick
          OnDrawCell = KaraktiDrawCell
          OnKeyDown = KaraktiKeyDown
          RowHeights = (
            24
            24
            24
            24
            24)
        end
        object Panel6: TPanel
          Left = 1
          Top = 327
          Width = 1103
          Height = 0
          Align = alBottom
          Color = clMedGray
          ParentBackground = False
          TabOrder = 1
          object Label7: TLabel
            Left = 121
            Top = 12
            Width = 86
            Height = 16
            Caption = 'Izven tolerance'
          end
          object Label8: TLabel
            Left = 408
            Top = 12
            Width = 121
            Height = 16
            Caption = 'Izven kontrolnih meja'
          end
          object Label9: TLabel
            Left = 710
            Top = 12
            Width = 100
            Height = 16
            Caption = 'Normalna meritev'
          end
          object Edit5: TEdit
            Left = 16
            Top = 6
            Width = 89
            Height = 24
            TabOrder = 0
          end
          object Edit6: TEdit
            Left = 304
            Top = 8
            Width = 89
            Height = 24
            TabOrder = 1
          end
          object Edit7: TEdit
            Left = 575
            Top = 6
            Width = 121
            Height = 24
            TabOrder = 2
          end
        end
        object Panel9: TPanel
          Left = 1
          Top = 1
          Width = 1103
          Height = 35
          Align = alTop
          Caption = 'Variabilne karakteristike'
          Color = clOlive
          Font.Charset = EASTEUROPE_CHARSET
          Font.Color = clWhite
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 2
        end
      end
    end
    object Panel5: TPanel
      Left = 1108
      Top = 1
      Width = 221
      Height = 587
      Align = alRight
      Color = clMoneyGreen
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 0
      object Button15: TButton
        Left = 248
        Top = 375
        Width = 75
        Height = 25
        Caption = 'Button15'
        TabOrder = 0
        Visible = False
      end
      object Button1: TButton
        Left = 34
        Top = 167
        Width = 153
        Height = 38
        Caption = 'Prepis v SAP'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = Button1Click
      end
      object Button11: TButton
        Left = 49
        Top = 81
        Width = 124
        Height = 33
        Caption = 'Prenos s stopalko'
        TabOrder = 2
        OnClick = Button11Click
      end
      object Button13: TButton
        Left = 74
        Top = 120
        Width = 73
        Height = 23
        Caption = 'Prekini'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnClick = Button13Click
      end
      object Button2: TButton
        Left = 49
        Top = 24
        Width = 123
        Height = 33
        Caption = 'Prenos meritev'
        TabOrder = 4
        OnClick = Button2Click
      end
      object Button7: TButton
        Left = 62
        Top = 326
        Width = 113
        Height = 33
        Caption = 'Lok. baza->SAP'
        TabOrder = 5
        Visible = False
        OnClick = Button7Click
      end
      object Edit3: TEdit
        Left = 222
        Top = 344
        Width = 97
        Height = 26
        TabOrder = 6
      end
      object Edit4: TEdit
        Left = 6
        Top = 376
        Width = 313
        Height = 26
        TabOrder = 7
      end
      object Button3: TButton
        Left = 49
        Top = 536
        Width = 105
        Height = 33
        Caption = 'Konec '
        TabOrder = 8
        OnClick = Button3Click
      end
      object Button9: TButton
        Left = 49
        Top = 422
        Width = 105
        Height = 33
        Caption = 'Semafor'
        TabOrder = 9
        OnClick = Button9Click
      end
      object Button17: TButton
        Left = 49
        Top = 479
        Width = 105
        Height = 33
        Caption = 'Grafi'
        Enabled = False
        TabOrder = 10
        OnClick = Button17Click
      end
      object Button12: TButton
        Left = 49
        Top = 365
        Width = 105
        Height = 32
        Caption = 'Legenda'
        TabOrder = 11
        OnClick = Button12Click
      end
    end
  end
  object MainMenu1: TMainMenu
    Left = 112
    Top = 416
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
        Caption = 'Merilna mesta'
        OnClick = Postaje1Click
      end
      object Stroji2: TMenuItem
        Caption = 'Stroji'
        OnClick = Stroji1Click
      end
      object Merilnemetode1: TMenuItem
        Caption = 'Merilne metode'
        OnClick = Merilnemetode1Click
      end
      object Ukrepi1: TMenuItem
        Caption = 'Ukrepi'
        OnClick = Ukrepi1Click
      end
      object Kontrolniplani1: TMenuItem
        Caption = 'Kontrolni plani'
        OnClick = Kontrolniplani1Click
      end
      object Meritve: TMenuItem
        Caption = 'Meritve'
        OnClick = MeritveClick
      end
    end
    object Nastavitve1: TMenuItem
      Caption = 'Nastavitve'
      object t1: TMenuItem
        Caption = 'Vpis '#353'tev. kanala'
        OnClick = t1Click
      end
      object kanala1: TMenuItem
        Caption = 'Decimalke'
        OnClick = kanala1Click
      end
    end
    object Operacije1: TMenuItem
      Caption = 'Operacije'
      object Vaga1: TMenuItem
        Caption = 'Vaga'
        Visible = False
        OnClick = Vaga1Click
      end
      object Dodatnekode1: TMenuItem
        Caption = 'Dodatne kode'
        OnClick = Dodatnekode1Click
      end
    end
    object Info1: TMenuItem
      Caption = 'Informacije'
      object Verzija1: TMenuItem
        Caption = 'Vizitka'
        OnClick = Verzija1Click
      end
      object Verzije1: TMenuItem
        Caption = 'Verzije'
        OnClick = Verzije1Click
      end
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 858
    Top = 283
  end
end
