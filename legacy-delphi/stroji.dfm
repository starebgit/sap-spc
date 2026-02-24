object Fstroji: TFstroji
  Left = 0
  Top = 0
  Caption = 'Stroji'
  ClientHeight = 572
  ClientWidth = 944
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 944
    Height = 50
    Align = alTop
    BevelOuter = bvLowered
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
      Left = 16
      Top = 18
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
    object Label2: TLabel
      Left = 115
      Top = 18
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
      Left = 272
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Vpis'
      TabOrder = 0
      Visible = False
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 416
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Izbri'#353'i'
      TabOrder = 1
      Visible = False
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 536
      Top = 14
      Width = 97
      Height = 25
      Caption = 'Dodaj Kodo'
      TabOrder = 2
      Visible = False
      OnClick = Button3Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 50
    Width = 944
    Height = 522
    Align = alClient
    BevelOuter = bvLowered
    TabOrder = 1
    object DBGrid1: TDBGrid
      Left = 1
      Top = 1
      Width = 942
      Height = 520
      Align = alClient
      DataSource = DataSource1
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -15
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
  end
  object DataSource1: TDataSource
    DataSet = ADOQuery1
    Left = 224
    Top = 121
  end
  object ADOQuery1: TADOQuery
    ConnectionString = 
      'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security In' +
      'fo=False;Initial Catalog=strojna;Data Source=172.20.11.155\tsspi' +
      'ca'
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from stroji')
    Left = 328
    Top = 121
    object ADOQuery1zapored: TAutoIncField
      FieldName = 'zapored'
      ReadOnly = True
      Visible = False
    end
    object ADOQuery1stPost: TIntegerField
      FieldName = 'stPost'
    end
    object ADOQuery1idstroja: TStringField
      DisplayLabel = 'Ident stroja'
      FieldName = 'idstroja'
      FixedChar = True
      Size = 15
    end
    object ADOQuery1sifstroja: TStringField
      DisplayLabel = #352'ifra stroja'
      FieldName = 'sifstroja'
      FixedChar = True
    end
    object ADOQuery1naziv: TStringField
      DisplayLabel = 'Naziv stroja'
      FieldName = 'naziv'
      FixedChar = True
      Size = 50
    end
    object ADOQuery1koda: TStringField
      FieldName = 'koda'
      FixedChar = True
      Size = 18
    end
  end
  object MainMenu1: TMainMenu
    Left = 112
    Top = 226
    object Urejanje1: TMenuItem
      Caption = 'Urejanje'
      object Vpisstroja1: TMenuItem
        Caption = 'Vpis stroja'
        OnClick = Vpisstroja1Click
      end
      object Izbriistroj1: TMenuItem
        Caption = 'Izbri'#353'i stroj'
        OnClick = Izbriistroj1Click
      end
    end
  end
end
