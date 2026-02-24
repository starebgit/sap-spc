object Fsemafor: TFsemafor
  Left = 1320
  Top = 0
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Semafor'
  ClientHeight = 873
  ClientWidth = 1432
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object DrawGrid1: TDrawGrid
    Left = 0
    Top = 0
    Width = 1432
    Height = 873
    Align = alClient
    ColCount = 3
    DefaultColWidth = 450
    DefaultRowHeight = 200
    FixedCols = 0
    RowCount = 3
    FixedRows = 0
    TabOrder = 0
    OnDrawCell = DrawGrid1DrawCell
  end
  object Button1: TButton
    Left = 1349
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Pomik'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Timer1: TTimer
    Interval = 10000
    OnTimer = Timer1Timer
    Left = 1336
    Top = 64
  end
end
