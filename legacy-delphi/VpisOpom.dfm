object FvpisOpom: TFvpisOpom
  Left = 0
  Top = 0
  Caption = 'Vpis opombe'
  ClientHeight = 420
  ClientWidth = 1103
  Color = clBtnFace
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
    Width = 921
    Height = 420
    Align = alLeft
    Color = clMoneyGreen
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    object Grid1: TStringGrid
      Left = 1
      Top = 1
      Width = 919
      Height = 344
      Align = alTop
      ColCount = 3
      DefaultColWidth = 250
      FixedColor = clAqua
      RowCount = 3
      Options = [goFixedVertLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
      TabOrder = 0
      RowHeights = (
        24
        24
        24)
    end
    object Button1: TButton
      Left = 72
      Top = 360
      Width = 201
      Height = 42
      Caption = 'Izbor za pos. karakteristiko'
      TabOrder = 1
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 368
      Top = 360
      Width = 201
      Height = 42
      Caption = 'Izbor za vse karakteristike'
      TabOrder = 2
      OnClick = Button2Click
    end
  end
  object Panel2: TPanel
    Left = 921
    Top = 0
    Width = 182
    Height = 420
    Align = alClient
    Color = clTeal
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 1
    object Button3: TButton
      Left = 48
      Top = 32
      Width = 89
      Height = 33
      Caption = 'V redu'
      Enabled = False
      ModalResult = 1
      TabOrder = 0
    end
    object Button4: TButton
      Left = 48
      Top = 96
      Width = 89
      Height = 33
      Caption = 'Prekini'
      Enabled = False
      ModalResult = 2
      TabOrder = 1
    end
  end
end
