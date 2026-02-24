object FvpisUkrep: TFvpisUkrep
  Left = 0
  Top = 0
  Caption = 'FvpisUkrep'
  ClientHeight = 426
  ClientWidth = 923
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
    Width = 697
    Height = 426
    Align = alLeft
    Color = clSkyBlue
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 72
      Top = 64
      Width = 85
      Height = 18
      Caption = 'Izbor ukrepa'
    end
    object Label2: TLabel
      Left = 72
      Top = 264
      Width = 84
      Height = 18
      Caption = 'Vpis ukrepa'
      Visible = False
    end
    object Label3: TLabel
      Left = 176
      Top = 64
      Width = 4
      Height = 18
    end
    object ListBox1: TListBox
      Left = 88
      Top = 88
      Width = 225
      Height = 129
      ItemHeight = 18
      Items.Strings = (
        '1. ukrep'
        '2. ukrep'
        '3. ukrep')
      TabOrder = 0
      OnClick = ListBox1Click
    end
    object Edit1: TEdit
      Left = 88
      Top = 288
      Width = 545
      Height = 26
      TabOrder = 1
      Visible = False
      OnChange = Edit1Change
    end
  end
  object Panel2: TPanel
    Left = 697
    Top = 0
    Width = 226
    Height = 426
    Align = alClient
    TabOrder = 1
    object Button1: TButton
      Left = 64
      Top = 48
      Width = 75
      Height = 25
      Caption = 'V redu'
      Enabled = False
      ModalResult = 1
      TabOrder = 0
    end
  end
end
