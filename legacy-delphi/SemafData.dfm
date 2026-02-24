object Fsemafdata: TFsemafdata
  Left = 0
  Top = 0
  Caption = 'Fsemafdata'
  ClientHeight = 300
  ClientWidth = 635
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
    ConnectionString = 'FILE NAME=D:\Emb_programi\PTC2\Generic\Win32\Debug\strojna.udl;'
    Parameters = <>
    Left = 296
    Top = 40
  end
  object ADOQuery2: TADOQuery
    ConnectionString = 
      'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security In' +
      'fo=False;Initial Catalog=rsp;Data Source=172.20.11.155\tsspica'
    Parameters = <>
    Left = 160
    Top = 40
  end
end
