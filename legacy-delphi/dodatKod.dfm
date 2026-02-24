object FDodatKod: TFDodatKod
  Left = 0
  Top = 0
  Caption = 'Dodatne opredelitve kode'
  ClientHeight = 457
  ClientWidth = 719
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
    Width = 719
    Height = 49
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 32
      Top = 16
      Width = 46
      Height = 19
      Caption = 'Label1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Button1: TButton
      Left = 280
      Top = 12
      Width = 75
      Height = 25
      Caption = 'Vpis'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 408
      Top = 13
      Width = 75
      Height = 25
      Caption = 'Prenos'
      TabOrder = 1
      Visible = False
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 528
      Top = 13
      Width = 75
      Height = 25
      Caption = 'Bri'#353'i'
      TabOrder = 2
      OnClick = Button3Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 49
    Width = 719
    Height = 408
    Align = alClient
    TabOrder = 1
    object DBGrid1: TDBGrid
      Left = 1
      Top = 1
      Width = 717
      Height = 406
      Align = alClient
      DataSource = DataSource1
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
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
    Left = 288
    Top = 185
  end
  object ADOQuery1: TADOQuery
    ConnectionString = 
      'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security In' +
      'fo=False;Initial Catalog=strojna;Data Source=172.20.11.155\tsspi' +
      'ca'
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from dodatkod')
    Left = 384
    Top = 185
    object ADOQuery1zaopored: TAutoIncField
      FieldName = 'zaopored'
      ReadOnly = True
      Visible = False
    end
    object ADOQuery1koda: TStringField
      FieldName = 'koda'
      Visible = False
      FixedChar = True
      Size = 18
    end
    object ADOQuery1naziv: TStringField
      FieldName = 'naziv'
      FixedChar = True
      Size = 40
    end
  end
end
