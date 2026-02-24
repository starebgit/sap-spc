object FvpisStev: TFvpisStev
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Vpis '#353'tev. kanala'
  ClientHeight = 265
  ClientWidth = 417
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
    Width = 417
    Height = 209
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    ExplicitWidth = 477
    object Label1: TLabel
      Left = 112
      Top = 64
      Width = 46
      Height = 19
      Caption = 'Label1'
    end
    object SpinEdit1: TSpinEdit
      Left = 136
      Top = 96
      Width = 113
      Height = 29
      MaxValue = 0
      MinValue = 0
      TabOrder = 0
      Value = 0
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 209
    Width = 417
    Height = 56
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    ExplicitWidth = 477
    ExplicitHeight = 69
    object Button1: TButton
      Left = 152
      Top = 16
      Width = 75
      Height = 25
      Caption = 'V redu'
      ModalResult = 1
      TabOrder = 0
    end
  end
end
