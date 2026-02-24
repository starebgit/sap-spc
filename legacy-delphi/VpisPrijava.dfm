object FVpisPrijava: TFVpisPrijava
  Left = 0
  Top = 0
  Caption = 'FVpisPrijava'
  ClientHeight = 412
  ClientWidth = 852
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
    Width = 705
    Height = 412
    Align = alLeft
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Reference Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 48
      Top = 32
      Width = 51
      Height = 19
      Caption = 'Sistem'
    end
    object Label2: TLabel
      Left = 280
      Top = 32
      Width = 41
      Height = 19
      Caption = 'Client'
    end
    object Label3: TLabel
      Left = 51
      Top = 128
      Width = 131
      Height = 19
      Caption = 'Application server'
    end
    object Label4: TLabel
      Left = 432
      Top = 128
      Width = 113
      Height = 19
      Caption = 'Sistem number'
    end
    object Label5: TLabel
      Left = 51
      Top = 216
      Width = 75
      Height = 19
      Caption = 'Uporabnik'
    end
    object Label6: TLabel
      Left = 280
      Top = 216
      Width = 42
      Height = 19
      Caption = 'Geslo'
    end
    object Label7: TLabel
      Left = 488
      Top = 216
      Width = 37
      Height = 19
      Caption = 'Jezik'
    end
    object Label8: TLabel
      Left = 51
      Top = 304
      Width = 52
      Height = 19
      Caption = 'Default'
    end
    object Edit1: TEdit
      Left = 72
      Top = 57
      Width = 121
      Height = 27
      TabOrder = 0
    end
    object Edit2: TEdit
      Left = 296
      Top = 57
      Width = 121
      Height = 27
      TabOrder = 1
    end
    object Edit3: TEdit
      Left = 72
      Top = 153
      Width = 313
      Height = 27
      TabOrder = 2
    end
    object Edit4: TEdit
      Left = 464
      Top = 152
      Width = 121
      Height = 27
      TabOrder = 3
    end
    object Edit5: TEdit
      Left = 72
      Top = 241
      Width = 153
      Height = 27
      TabOrder = 4
    end
    object Edit6: TEdit
      Left = 296
      Top = 241
      Width = 121
      Height = 27
      TabOrder = 5
    end
    object Edit7: TEdit
      Left = 496
      Top = 240
      Width = 73
      Height = 27
      TabOrder = 6
      Text = 'SL'
    end
    object CheckBox1: TCheckBox
      Left = 72
      Top = 329
      Width = 137
      Height = 17
      Caption = 'Default izbira'
      TabOrder = 7
    end
  end
  object Panel2: TPanel
    Left = 705
    Top = 0
    Width = 147
    Height = 412
    Align = alClient
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Reference Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    ExplicitLeft = 736
    ExplicitTop = 50
    ExplicitWidth = 185
    ExplicitHeight = 41
    object Button1: TButton
      Left = 32
      Top = 30
      Width = 75
      Height = 25
      Caption = 'V redu'
      ModalResult = 1
      TabOrder = 0
    end
    object Button2: TButton
      Left = 32
      Top = 88
      Width = 75
      Height = 25
      Caption = 'Prekini'
      ModalResult = 2
      TabOrder = 1
    end
  end
end
