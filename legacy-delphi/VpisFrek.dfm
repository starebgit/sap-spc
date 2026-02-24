object FvpisFrek: TFvpisFrek
  Left = 0
  Top = 0
  Caption = 'Vpis frekvence meritev'
  ClientHeight = 412
  ClientWidth = 598
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 449
    Height = 412
    Align = alLeft
    BevelOuter = bvLowered
    Color = clGradientActiveCaption
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 56
      Top = 64
      Width = 172
      Height = 19
      Caption = 'Frekvenca meritev (min)'
    end
    object Label2: TLabel
      Left = 56
      Top = 176
      Width = 161
      Height = 19
      Caption = 'Trajanje meritev (min)'
    end
    object Edit1: TEdit
      Left = 72
      Top = 89
      Width = 177
      Height = 27
      TabOrder = 0
    end
    object Edit2: TEdit
      Left = 72
      Top = 201
      Width = 177
      Height = 27
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 449
    Top = 0
    Width = 149
    Height = 412
    Align = alClient
    BevelOuter = bvLowered
    TabOrder = 1
    object Button1: TButton
      Left = 40
      Top = 64
      Width = 75
      Height = 25
      Caption = 'V redu'
      ModalResult = 1
      TabOrder = 0
    end
    object Button2: TButton
      Left = 40
      Top = 120
      Width = 75
      Height = 25
      Caption = 'Prekini'
      ModalResult = 2
      TabOrder = 1
    end
  end
end
