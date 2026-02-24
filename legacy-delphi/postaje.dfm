object Fpostaje: TFpostaje
  Left = 0
  Top = 0
  Caption = 'Merilna mesta'
  ClientHeight = 439
  ClientWidth = 1027
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
    Width = 1027
    Height = 50
    Align = alTop
    BevelOuter = bvLowered
    Color = clTeal
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    object Label2: TLabel
      Left = 18
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
    object Label3: TLabel
      Left = 552
      Top = 10
      Width = 37
      Height = 16
      Caption = 'Label3'
    end
    object Label4: TLabel
      Left = 552
      Top = 30
      Width = 37
      Height = 16
      Caption = 'Label4'
    end
    object Label1: TLabel
      Left = 119
      Top = 18
      Width = 47
      Height = 18
      Caption = 'Label1'
      Font.Charset = EASTEUROPE_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Button1: TButton
      Left = 497
      Top = 18
      Width = 75
      Height = 25
      Caption = 'Vpis'
      TabOrder = 0
      Visible = False
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 416
      Top = 51
      Width = 75
      Height = 25
      Caption = 'Bri'#353'i'
      TabOrder = 1
      Visible = False
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 335
      Top = 12
      Width = 75
      Height = 25
      Caption = 'Izbor'
      TabOrder = 2
      Visible = False
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 416
      Top = 12
      Width = 75
      Height = 25
      Caption = 'Konec'
      TabOrder = 3
      Visible = False
      OnClick = Button4Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 50
    Width = 1027
    Height = 389
    Align = alClient
    BevelOuter = bvLowered
    TabOrder = 1
    object DBGrid1: TDBGrid
      Left = 1
      Top = 1
      Width = 1025
      Height = 387
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
      OnCellClick = DBGrid1CellClick
    end
  end
  object DataSource1: TDataSource
    DataSet = ADOQuery1
    Left = 256
    Top = 137
  end
  object ADOQuery1: TADOQuery
    ConnectionString = 
      'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security In' +
      'fo=False;Initial Catalog=strojna;Data Source=172.20.11.155\tsspi' +
      'ca'
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from postaje')
    Left = 376
    Top = 153
    object ADOQuery1stPost: TAutoIncField
      DisplayLabel = 'Zap. '#353't. postaje'
      DisplayWidth = 8
      FieldName = 'stPost'
      ReadOnly = True
    end
    object ADOQuery1imerac: TStringField
      DisplayLabel = 'Ime ra'#269'unalnika'
      DisplayWidth = 18
      FieldName = 'imerac'
      FixedChar = True
      Size = 15
    end
    object ADOQuery1opis: TStringField
      DisplayLabel = 'Opis merilnega mesta'
      FieldName = 'opis'
      FixedChar = True
      Size = 40
    end
    object ADOQuery1com: TWordField
      DisplayLabel = 'COM port'
      DisplayWidth = 7
      FieldName = 'com'
    end
    object ADOQuery1lokal: TWordField
      DisplayWidth = 7
      FieldName = 'lokal'
    end
    object ADOQuery1imekon: TStringField
      DisplayLabel = 'Ime kontrolne to'#269'ke'
      FieldName = 'Imekon'
      FixedChar = True
      Size = 18
    end
    object ADOQuery1postkoda: TStringField
      FieldName = 'postkoda'
      FixedChar = True
      Size = 9
    end
    object ADOQuery1stevrsta: TWordField
      FieldName = 'stevrsta'
    end
    object ADOQuery1izbiraKd: TWordField
      FieldName = 'izbiraKd'
    end
  end
  object MainMenu1: TMainMenu
    Left = 120
    Top = 233
    object Urejanje1: TMenuItem
      Caption = 'Urejanje'
      object Vpismerilnegamesta1: TMenuItem
        Caption = 'Vpis merilnega mesta'
        OnClick = Vpismerilnegamesta1Click
      end
      object Briimerilnomesto1: TMenuItem
        Caption = 'Bri'#353'i merilno mesto'
        OnClick = Briimerilnomesto1Click
      end
    end
  end
end
