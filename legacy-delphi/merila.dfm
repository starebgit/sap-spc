object Fmerila: TFmerila
  Left = 0
  Top = 0
  Caption = 'Lista meril'
  ClientHeight = 746
  ClientWidth = 938
  Color = clBtnFace
  Constraints.MaxWidth = 954
  Constraints.MinWidth = 954
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 938
    Height = 54
    Align = alTop
    Color = clMoneyGreen
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 32
      Top = 17
      Width = 54
      Height = 19
      Caption = 'Label1'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object Button1: TButton
      Left = 544
      Top = 15
      Width = 137
      Height = 25
      Caption = 'Novo merilo'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 968
      Top = 15
      Width = 75
      Height = 25
      Caption = 'Konec'
      TabOrder = 1
      Visible = False
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 856
      Top = 15
      Width = 75
      Height = 25
      Caption = 'Bri'#353'i'
      TabOrder = 2
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 704
      Top = 15
      Width = 129
      Height = 25
      Caption = 'Osve'#382'i seznam'
      TabOrder = 3
      OnClick = Button4Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 54
    Width = 938
    Height = 692
    Align = alClient
    TabOrder = 1
    object DBGrid1: TDBGrid
      Left = 1
      Top = 1
      Width = 936
      Height = 690
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
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
  end
  object DataSource1: TDataSource
    DataSet = ADOQuery1
    Left = 328
    Top = 161
  end
  object ADOQuery1: TADOQuery
    ConnectionString = 
      'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security In' +
      'fo=False;Initial Catalog=strojna;Data Source=172.20.11.155\tsspi' +
      'ca'
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from merila')
    Left = 400
    Top = 161
    object ADOQuery1idmerila: TAutoIncField
      FieldName = 'idmerila'
      ReadOnly = True
      Visible = False
    end
    object ADOQuery1red: TWordField
      DisplayLabel = #352'tev.'
      DisplayWidth = 6
      FieldName = 'red'
    end
    object ADOQuery1idpost: TWordField
      FieldName = 'idpost'
      Visible = False
    end
    object ADOQuery1stevilka: TStringField
      DisplayLabel = 'ID merila'
      FieldName = 'stevilka'
      FixedChar = True
      Size = 6
    end
    object ADOQuery1naziv: TStringField
      DisplayLabel = 'Naziv merila'
      FieldName = 'naziv'
      FixedChar = True
      Size = 50
    end
    object ADOQuery1opis: TStringField
      DisplayLabel = 'Opis merila'
      FieldName = 'opis'
      FixedChar = True
      Size = 50
    end
  end
end
