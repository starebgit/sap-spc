object Fvpismetoda: TFvpismetoda
  Left = 0
  Top = 0
  Caption = 'Vpis metode'
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 653
    Height = 412
    Align = alLeft
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 48
      Top = 80
      Width = 109
      Height = 19
      Caption = 'Merilna metoda'
    end
    object Label2: TLabel
      Left = 360
      Top = 80
      Width = 103
      Height = 19
      Caption = #352'tevilka merila'
    end
    object Label3: TLabel
      Left = 48
      Top = 196
      Width = 32
      Height = 19
      Caption = 'Opis'
    end
    object Combo1: TComboBox
      Left = 72
      Top = 105
      Width = 169
      Height = 27
      TabOrder = 0
      Items.Strings = (
        'MP003'
        'MP006'
        'MP004')
    end
    object Edit1: TEdit
      Left = 392
      Top = 105
      Width = 121
      Height = 27
      TabOrder = 1
    end
    object Edit2: TEdit
      Left = 72
      Top = 221
      Width = 521
      Height = 27
      TabOrder = 2
    end
  end
  object Panel2: TPanel
    Left = 653
    Top = 0
    Width = 199
    Height = 412
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object Button1: TButton
      Left = 56
      Top = 56
      Width = 97
      Height = 33
      Caption = 'Zapis'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
end
