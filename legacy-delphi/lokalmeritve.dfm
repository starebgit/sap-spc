object FlokalMeritve: TFlokalMeritve
  Left = 0
  Top = 0
  Caption = 'FlokalMeritve'
  ClientHeight = 724
  ClientWidth = 1295
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
    Width = 1295
    Height = 57
    Align = alTop
    TabOrder = 0
    object Button1: TButton
      Left = 32
      Top = 17
      Width = 75
      Height = 25
      Caption = 'Excel'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 192
      Top = 17
      Width = 75
      Height = 25
      Caption = 'Izbri'#353'i'
      TabOrder = 1
      OnClick = Button2Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 57
    Width = 577
    Height = 667
    Align = alLeft
    TabOrder = 1
    object DBGrid1: TDBGrid
      Left = 1
      Top = 1
      Width = 575
      Height = 665
      Align = alClient
      DataSource = DataSource1
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
  end
  object Panel3: TPanel
    Left = 577
    Top = 57
    Width = 718
    Height = 667
    Align = alClient
    TabOrder = 2
    object DBGrid2: TDBGrid
      Left = 1
      Top = 1
      Width = 716
      Height = 665
      Align = alClient
      DataSource = DataSource2
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
    Left = 152
    Top = 185
  end
  object DataSource2: TDataSource
    DataSet = ADOQuery2
    Left = 849
    Top = 177
  end
  object ADOQuery1: TADOQuery
    ConnectionString = 'FILE NAME=D:\Emb_programi\PTC2\Generic\Win32\Debug\obdel.udl;'
    AfterScroll = ADOQuery1AfterScroll
    Parameters = <>
    Left = 256
    Top = 193
  end
  object ADOQuery2: TADOQuery
    ConnectionString = 'FILE NAME=D:\Emb_programi\PTC2\Generic\Win32\Debug\obdel.udl;'
    Parameters = <>
    Left = 969
    Top = 185
  end
  object MainMenu1: TMainMenu
    Left = 641
    Top = 153
    object Filter1: TMenuItem
      Caption = 'Filter'
      object Filternakontserijo1: TMenuItem
        Caption = 'Filter na kont. serijo'
        OnClick = Filternakontserijo1Click
      end
      object Filternaasdobo1: TMenuItem
        Caption = 'Filter na '#269'asovno dobo'
        OnClick = Filternaasdobo1Click
      end
      object Brezfiltra1: TMenuItem
        Caption = 'Brez filtra'
      end
    end
  end
end
