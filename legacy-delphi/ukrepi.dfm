object Fukrepi: TFukrepi
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Ukrepi'
  ClientHeight = 426
  ClientWidth = 862
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
    Width = 862
    Height = 50
    Align = alTop
    Color = clSkyBlue
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
      Top = 17
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
      Left = 120
      Top = 17
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
      Left = 248
      Top = 14
      Width = 75
      Height = 25
      Caption = 'Vpis'
      TabOrder = 0
      Visible = False
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 432
      Top = 14
      Width = 75
      Height = 25
      Caption = 'Bri'#353'i'
      TabOrder = 1
      Visible = False
      OnClick = Button2Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 50
    Width = 862
    Height = 376
    Align = alClient
    TabOrder = 1
    object DBGrid1: TDBGrid
      Left = 1
      Top = 1
      Width = 860
      Height = 374
      Align = alClient
      DataSource = DataSource1
      Font.Charset = EASTEUROPE_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Microsoft Sans Serif'
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
    Left = 208
    Top = 169
  end
  object ADOQuery1: TADOQuery
    ConnectionString = 
      'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security In' +
      'fo=False;Initial Catalog=strojna;Data Source=172.20.11.155\tsspi' +
      'ca'
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from ukrepi')
    Left = 304
    Top = 169
    object ADOQuery1idukr: TAutoIncField
      FieldName = 'idukr'
      ReadOnly = True
    end
    object ADOQuery1idpost: TIntegerField
      FieldName = 'idpost'
    end
    object ADOQuery1ukrep: TStringField
      FieldName = 'ukrep'
      FixedChar = True
      Size = 40
    end
  end
  object MainMenu1: TMainMenu
    Left = 64
    Top = 162
    object Urejanje1: TMenuItem
      Caption = 'Urejanje'
      object Vpisukrepa1: TMenuItem
        Caption = 'Vpis ukrepa'
        OnClick = Vpisukrepa1Click
      end
      object Briiukrep1: TMenuItem
        Caption = 'Bri'#353'i ukrep'
        OnClick = Briiukrep1Click
      end
    end
  end
end
