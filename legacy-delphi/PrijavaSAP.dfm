object FprijavaSAP: TFprijavaSAP
  Left = 0
  Top = 0
  Caption = 'FprijavaSAP'
  ClientHeight = 412
  ClientWidth = 852
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 852
    Height = 41
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 264
      Top = 12
      Width = 46
      Height = 19
      Caption = 'Label1'
    end
    object Button1: TButton
      Left = 40
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Vpis'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 152
      Top = 10
      Width = 75
      Height = 25
      Caption = 'Izbira'
      TabOrder = 1
      OnClick = Button2Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 41
    Width = 852
    Height = 371
    Align = alClient
    TabOrder = 1
    object DBGrid1: TDBGrid
      Left = 1
      Top = 1
      Width = 850
      Height = 369
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
  object DataSource1: TDataSource
    DataSet = ADOQuery1
    Left = 216
    Top = 145
  end
  object ADOQuery1: TADOQuery
    ConnectionString = 
      'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security In' +
      'fo=False;Initial Catalog=SAPkontrola;Data Source=172.20.11.155\t' +
      'sspica'
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from prijava')
    Left = 320
    Top = 145
    object ADOQuery1ident: TAutoIncField
      FieldName = 'ident'
      ReadOnly = True
    end
    object ADOQuery1uporab: TStringField
      FieldName = 'uporab'
      FixedChar = True
      Size = 12
    end
    object ADOQuery1sistem: TStringField
      FieldName = 'sistem'
      FixedChar = True
      Size = 8
    end
    object ADOQuery1client: TStringField
      FieldName = 'client'
      FixedChar = True
      Size = 3
    end
    object ADOQuery1streznik: TStringField
      FieldName = 'streznik'
      FixedChar = True
      Size = 30
    end
    object ADOQuery1sysnnum: TSmallintField
      FieldName = 'sysnnum'
    end
    object ADOQuery1pass: TStringField
      FieldName = 'pass'
      FixedChar = True
      Size = 12
    end
    object ADOQuery1jezik: TStringField
      FieldName = 'jezik'
      FixedChar = True
      Size = 2
    end
    object ADOQuery1glavni: TStringField
      FieldName = 'glavni'
      FixedChar = True
      Size = 1
    end
  end
end
