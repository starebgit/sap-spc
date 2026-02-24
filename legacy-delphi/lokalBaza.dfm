object FlokalBaza: TFlokalBaza
  Left = 0
  Top = 0
  Caption = 'FlokalBaza'
  ClientHeight = 731
  ClientWidth = 1373
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1373
    Height = 57
    Align = alTop
    TabOrder = 0
    object Button1: TButton
      Left = 368
      Top = 16
      Width = 129
      Height = 25
      Caption = 'Prenos kontrolne '#353'ar'#382'e'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 536
      Top = 16
      Width = 113
      Height = 25
      Caption = 'Prenos karakteristik'
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 736
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Bri'#353'i'
      TabOrder = 2
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 944
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Konec'
      TabOrder = 3
      OnClick = Button4Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 57
    Width = 593
    Height = 674
    Align = alLeft
    TabOrder = 1
    object DBGrid1: TDBGrid
      Left = 1
      Top = 1
      Width = 591
      Height = 672
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
    Left = 593
    Top = 57
    Width = 780
    Height = 674
    Align = alClient
    TabOrder = 2
    object DBGrid2: TDBGrid
      Left = 1
      Top = 1
      Width = 778
      Height = 672
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
    Left = 176
    Top = 193
  end
  object DataSource2: TDataSource
    DataSet = ADOQuery2
    Left = 761
    Top = 217
  end
  object ADOQuery1: TADOQuery
    AfterScroll = ADOQuery1AfterScroll
    Parameters = <>
    Left = 256
    Top = 193
  end
  object ADOQuery2: TADOQuery
    ConnectionString = 'FILE NAME=D:\Emb_programi\PTC2\Generic\Win32\Debug\obdel.udl;'
    Parameters = <>
    Left = 841
    Top = 209
  end
end
