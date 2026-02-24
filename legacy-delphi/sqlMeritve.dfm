object FSqlMeritve: TFSqlMeritve
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Meritve'
  ClientHeight = 881
  ClientWidth = 1504
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
    Width = 1504
    Height = 50
    Align = alTop
    Color = clActiveCaption
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 24
      Top = 16
      Width = 95
      Height = 17
      Caption = 'Merilno mesto:'
    end
    object Label2: TLabel
      Left = 126
      Top = 16
      Width = 47
      Height = 18
      Caption = 'Label2'
      Font.Charset = EASTEUROPE_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Button1: TButton
      Left = 496
      Top = 13
      Width = 75
      Height = 25
      Caption = 'Popravi'
      TabOrder = 0
      Visible = False
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 592
      Top = 13
      Width = 75
      Height = 25
      Caption = 'Bri'#353'i'
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 320
      Top = 13
      Width = 75
      Height = 25
      Caption = 'Filter'
      TabOrder = 2
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 440
      Top = 13
      Width = 113
      Height = 25
      Caption = 'Merilna mesta'
      TabOrder = 3
      OnClick = Button4Click
    end
    object Button5: TButton
      Left = 696
      Top = 13
      Width = 161
      Height = 25
      Caption = 'Nazivi karakteristik'
      TabOrder = 4
      Visible = False
      OnClick = Button5Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 50
    Width = 753
    Height = 831
    Align = alLeft
    BevelOuter = bvLowered
    TabOrder = 1
    object DBGrid1: TDBGrid
      Left = 1
      Top = 1
      Width = 751
      Height = 829
      Align = alClient
      DataSource = DataSource1
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
  end
  object Panel3: TPanel
    Left = 753
    Top = 50
    Width = 751
    Height = 831
    Align = alClient
    BevelOuter = bvLowered
    TabOrder = 2
    object DBGrid2: TDBGrid
      Left = 1
      Top = 1
      Width = 749
      Height = 829
      Align = alClient
      DataSource = DataSource2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
  end
  object DataSource1: TDataSource
    DataSet = ADOQuery1
    Left = 64
    Top = 137
  end
  object DataSource2: TDataSource
    DataSet = ADOQuery2
    Left = 841
    Top = 137
  end
  object ADOQuery1: TADOQuery
    ConnectionString = 
      'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security In' +
      'fo=False;Initial Catalog=strojna;Data Source=172.20.11.155\tsspi' +
      'ca'
    CursorType = ctStatic
    AfterScroll = ADOQuery1AfterScroll
    Parameters = <>
    SQL.Strings = (
      'select * from glavmer')
    Left = 144
    Top = 137
    object ADOQuery1idmer: TAutoIncField
      DisplayLabel = 'Zap. '#353't. '
      FieldName = 'idmer'
      ReadOnly = True
    end
    object ADOQuery1idpost: TIntegerField
      FieldName = 'idpost'
      Visible = False
    end
    object ADOQuery1datum: TDateTimeField
      FieldName = 'datum'
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
    object ADOQuery1dodatno: TStringField
      FieldName = 'dodatno'
      Visible = False
      FixedChar = True
      Size = 10
    end
    object ADOQuery1idstroj: TStringField
      FieldName = 'idstroj'
      FixedChar = True
      Size = 15
    end
    object ADOQuery1merilec: TStringField
      FieldName = 'merilec'
      FixedChar = True
      Size = 30
    end
    object ADOQuery1orodja: TStringField
      FieldName = 'orodja'
      FixedChar = True
      Size = 40
    end
  end
  object ADOQuery2: TADOQuery
    ConnectionString = 
      'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security In' +
      'fo=False;Initial Catalog=strojna;Data Source=172.20.11.155\tsspi' +
      'ca'
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from karmer')
    Left = 929
    Top = 145
    object ADOQuery2idkarm: TAutoIncField
      FieldName = 'idkarm'
      ReadOnly = True
      Visible = False
    end
    object ADOQuery2idmer: TIntegerField
      FieldName = 'idmer'
      Visible = False
    end
    object ADOQuery2karakt: TStringField
      DisplayLabel = 'Pozicija'
      FieldName = 'karakt'
      FixedChar = True
      Size = 4
    end
    object ADOQuery2naziv: TStringField
      FieldName = 'naziv'
      FixedChar = True
      Size = 40
    end
    object ADOQuery2zapvz: TSmallintField
      DisplayLabel = #352't. vzorca'
      FieldName = 'zapvz'
    end
    object ADOQuery2vrednost: TFloatField
      DisplayLabel = 'Meritev'
      FieldName = 'vrednost'
    end
    object ADOQuery2slabi: TSmallintField
      FieldName = 'slabi'
    end
    object ADOQuery2ukrep: TStringField
      FieldName = 'ukrep'
      FixedChar = True
      Size = 40
    end
  end
end
