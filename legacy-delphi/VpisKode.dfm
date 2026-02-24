object FVpisKode: TFVpisKode
  Left = 0
  Top = 0
  Caption = 'Vpis kode'
  ClientHeight = 514
  ClientWidth = 998
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
    Width = 785
    Height = 514
    Align = alLeft
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 72
      Top = 80
      Width = 35
      Height = 19
      Caption = 'Koda'
    end
    object Label2: TLabel
      Left = 416
      Top = 80
      Width = 111
      Height = 19
      Caption = 'Kontrolna serija'
    end
    object Label3: TLabel
      Left = 72
      Top = 168
      Width = 172
      Height = 19
      Caption = 'Frekvenca meritev (min)'
    end
    object Label4: TLabel
      Left = 72
      Top = 264
      Width = 147
      Height = 19
      Caption = #268'as za meritev (min)'
    end
    object Edit1: TEdit
      Left = 88
      Top = 105
      Width = 185
      Height = 27
      TabOrder = 0
      OnExit = Edit1Exit
    end
    object List1: TListBox
      Left = 440
      Top = 105
      Width = 217
      Height = 136
      ItemHeight = 19
      TabOrder = 1
    end
    object Edit2: TEdit
      Left = 88
      Top = 192
      Width = 121
      Height = 27
      TabOrder = 2
      Text = '120'
    end
    object Edit3: TEdit
      Left = 88
      Top = 289
      Width = 121
      Height = 27
      TabOrder = 3
      Text = '15'
    end
    object CheckBox1: TCheckBox
      Left = 88
      Top = 40
      Width = 172
      Height = 17
      Caption = 'Preverjanje '#353'ar'#382'e'
      Checked = True
      State = cbChecked
      TabOrder = 4
    end
  end
  object Panel2: TPanel
    Left = 785
    Top = 0
    Width = 213
    Height = 514
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object Button1: TButton
      Left = 72
      Top = 74
      Width = 75
      Height = 31
      Caption = 'Zapis'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
end
