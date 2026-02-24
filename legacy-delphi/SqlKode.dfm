object FsqlKode: TFsqlKode
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Kontrolni plani'
  ClientHeight = 544
  ClientWidth = 1207
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1207
    Height = 50
    Align = alTop
    Color = clActiveCaption
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 1136
      Top = 30
      Width = 134
      Height = 16
      Caption = 'Dvoklik za oznako grafa'
    end
    object Label2: TLabel
      Left = 33
      Top = 15
      Width = 95
      Height = 17
      Caption = 'Merilno mesto:'
      Font.Charset = EASTEUROPE_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 140
      Top = 15
      Width = 47
      Height = 18
      Caption = 'Label3'
      Font.Charset = EASTEUROPE_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Button3: TButton
      Left = 642
      Top = 13
      Width = 75
      Height = 25
      Caption = 'Konec'
      TabOrder = 0
      OnClick = Button3Click
    end
    object Button1: TButton
      Left = 792
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Button1'
      TabOrder = 1
      Visible = False
      OnClick = Button1Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 50
    Width = 561
    Height = 494
    Align = alLeft
    TabOrder = 1
    object DBGrid1: TDBGrid
      Left = 1
      Top = 1
      Width = 559
      Height = 492
      Align = alClient
      DataSource = DataSource1
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
  end
  object Panel3: TPanel
    Left = 561
    Top = 50
    Width = 646
    Height = 494
    Align = alClient
    TabOrder = 2
    object DBGrid2: TDBGrid
      Left = 1
      Top = 1
      Width = 644
      Height = 492
      Align = alClient
      DataSource = DataSource2
      Font.Charset = EASTEUROPE_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnDblClick = DBGrid2DblClick
    end
  end
  object DataSource1: TDataSource
    DataSet = ADOQuery1
    Left = 160
    Top = 137
  end
  object DataSource2: TDataSource
    DataSet = ADOQuery2
    Left = 705
    Top = 145
  end
  object ADOQuery1: TADOQuery
    CursorType = ctStatic
    AfterScroll = ADOQuery1AfterScroll
    Parameters = <>
    SQL.Strings = (
      'select * from konsar')
    Left = 256
    Top = 137
    object ADOQuery1ident: TSmallintField
      FieldName = 'ident'
      ReadOnly = True
      Visible = False
    end
    object ADOQuery1idpost: TSmallintField
      DisplayWidth = 6
      FieldName = 'idpost'
    end
    object ADOQuery1koda: TStringField
      FieldName = 'koda'
      FixedChar = True
      Size = 18
    end
    object ADOQuery1sarza: TStringField
      FieldName = 'sarza'
      FixedChar = True
      Size = 12
    end
    object ADOQuery1razmik: TSmallintField
      DisplayWidth = 6
      FieldName = 'razmik'
    end
    object ADOQuery1koncan: TStringField
      DisplayLabel = 'Aktivnost'
      FieldName = 'koncan'
      FixedChar = True
      Size = 1
    end
    object ADOQuery1merdiff: TSmallintField
      DisplayLabel = 'Frek. meritev'
      FieldName = 'merdiff'
    end
    object ADOQuery1mertraj: TSmallintField
      DisplayLabel = #268'as za meritev'
      FieldName = 'mertraj'
    end
  end
  object ADOQuery2: TADOQuery
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT * from konplan')
    Left = 785
    Top = 161
    object ADOQuery2idplan: TAutoIncField
      FieldName = 'idplan'
      ReadOnly = True
      Visible = False
    end
    object ADOQuery2idsar: TSmallintField
      FieldName = 'idsar'
      Visible = False
    end
    object ADOQuery2pozicija: TStringField
      FieldName = 'pozicija'
      FixedChar = True
      Size = 4
    end
    object ADOQuery2operacija: TStringField
      FieldName = 'operacija'
      FixedChar = True
      Size = 4
    end
    object ADOQuery2stvz: TWordField
      DisplayLabel = 'Vel. vzorca'
      FieldName = 'stvz'
    end
    object ADOQuery2naziv: TStringField
      FieldName = 'naziv'
      FixedChar = True
      Size = 40
    end
    object ADOQuery2tip: TIntegerField
      DisplayWidth = 6
      FieldName = 'tip'
    end
    object ADOQuery2predpis: TFloatField
      FieldName = 'predpis'
    end
    object ADOQuery2spmeja: TFloatField
      FieldName = 'spmeja'
    end
    object ADOQuery2zgmeja: TFloatField
      FieldName = 'zgmeja'
    end
    object ADOQuery2kanal: TStringField
      DisplayLabel = 'Metoda'
      FieldName = 'kanal'
      FixedChar = True
      Size = 8
    end
    object ADOQuery2stkanal: TWordField
      DisplayLabel = #352't. kanala'
      DisplayWidth = 8
      FieldName = 'stkanal'
    end
    object ADOQuery2com: TWordField
      FieldName = 'com'
      Visible = False
    end
    object ADOQuery2oznaka: TStringField
      DisplayLabel = 'Graf'
      FieldName = 'oznaka'
      FixedChar = True
      Size = 1
    end
  end
  object ADOQuery3: TADOQuery
    ConnectionString = 'l'
    Parameters = <>
    Left = 240
    Top = 273
  end
  object MainMenu1: TMainMenu
    Left = 24
    Top = 145
    object Urejanje1: TMenuItem
      Caption = 'Urejanje kode'
      object Novakoda1: TMenuItem
        Caption = 'Nova koda'
        OnClick = Novakoda1Click
      end
      object Prepiskode1: TMenuItem
        Caption = 'Sprememba kontrolne sar'#382'e'
        OnClick = Prepiskode1Click
      end
      object Briikodo1: TMenuItem
        Caption = 'Bri'#353'i kodo'
        OnClick = Briikodo1Click
      end
      object Frekvencameritev1: TMenuItem
        Caption = 'Frekvenca meritev'
        OnClick = Frekvencameritev1Click
      end
    end
    object Urejanjekontplana1: TMenuItem
      Caption = 'Urejanje kont. plana'
      object Prenoskontplana1: TMenuItem
        Caption = 'Prenos kont. plana'
        OnClick = Prenoskontplana1Click
      end
      object Spremembakanala1: TMenuItem
        Caption = 'Sprememba kanala'
        OnClick = Spremembakanala1Click
      end
      object Briikarakteristiko1: TMenuItem
        Caption = 'Bri'#353'i karakteristiko'
        OnClick = Briikarakteristiko1Click
      end
      object Briikontrolniplan1: TMenuItem
        Caption = 'Bri'#353'i kontrolni plan'
        OnClick = Briikontrolniplan1Click
      end
    end
    object Vpogled1: TMenuItem
      Caption = 'Vpogled'
      object Dodatki1: TMenuItem
        Caption = 'Dodatki '
        OnClick = Dodatki1Click
      end
      object Arhiv1: TMenuItem
        Caption = 'Arhiv'
        OnClick = Arhiv1Click
      end
      object Normalno1: TMenuItem
        Caption = 'Normalno'
        OnClick = Normalno1Click
      end
    end
    object Operacije1: TMenuItem
      Caption = 'Operacije'
      object Histogram1: TMenuItem
        Caption = 'Histogram'
        OnClick = Histogram1Click
      end
      object Preveriaro1: TMenuItem
        Caption = 'Preveri '#353'ar'#382'o'
        OnClick = Preveriaro1Click
      end
    end
  end
end
