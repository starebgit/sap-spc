object Fverzije: TFverzije
  Left = 0
  Top = 0
  Caption = 'Fverzije'
  ClientHeight = 559
  ClientWidth = 1043
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
    Width = 1043
    Height = 57
    Align = alTop
    TabOrder = 0
    object Button1: TButton
      Left = 144
      Top = 17
      Width = 113
      Height = 25
      Caption = 'Pravica do vpisa'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 57
    Width = 401
    Height = 502
    Align = alLeft
    TabOrder = 1
    object DBGrid1: TDBGrid
      Left = 1
      Top = 1
      Width = 399
      Height = 500
      Align = alClient
      DataSource = DataSource1
      Font.Charset = EASTEUROPE_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
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
    Left = 401
    Top = 57
    Width = 642
    Height = 502
    Align = alClient
    TabOrder = 2
    object DBGrid2: TDBGrid
      Left = 1
      Top = 1
      Width = 640
      Height = 500
      Align = alClient
      DataSource = DataSource2
      Font.Charset = EASTEUROPE_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
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
  object DataSource1: TDataSource
    DataSet = ADOQuery1
    Left = 64
    Top = 153
  end
  object DataSource2: TDataSource
    DataSet = ADOQuery2
    Left = 529
    Top = 169
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
      'select * from verzije')
    Left = 152
    Top = 161
    object ADOQuery1idver: TAutoIncField
      FieldName = 'idver'
      Visible = False
    end
    object ADOQuery1imever: TStringField
      FieldName = 'imever'
      FixedChar = True
      Size = 15
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
      'select * from novosti')
    Left = 625
    Top = 177
    object ADOQuery2idnov: TAutoIncField
      FieldName = 'idnov'
      Visible = False
    end
    object ADOQuery2idver: TIntegerField
      FieldName = 'idver'
      Visible = False
    end
    object ADOQuery2novost: TStringField
      FieldName = 'novost'
      FixedChar = True
      Size = 40
    end
  end
end
