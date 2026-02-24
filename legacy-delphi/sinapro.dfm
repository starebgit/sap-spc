object Fsinapro: TFsinapro
  Left = 0
  Top = 0
  Caption = 'Fsinapro'
  ClientHeight = 412
  ClientWidth = 852
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ADOQuery1: TADOQuery
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=ticmis;Persist Security Info=True;U' +
      'ser ID=sinabit;Initial Catalog=SinaproNG;Data Source=mes'
    Parameters = <>
    Left = 576
    Top = 56
  end
  object ADOQuery2: TADOQuery
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=ticmis;Persist Security Info=True;U' +
      'ser ID=sinabit;Initial Catalog=SinaproNG;Data Source=mes'
    Parameters = <>
    Left = 704
    Top = 112
  end
end
