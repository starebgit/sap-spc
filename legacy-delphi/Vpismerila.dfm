object Fvpismerila: TFvpismerila
  Left = 0
  Top = 0
  Caption = 'Vpis merila'
  ClientHeight = 374
  ClientWidth = 697
  Color = clBtnFace
  Constraints.MaxHeight = 412
  Constraints.MaxWidth = 713
  Constraints.MinHeight = 412
  Constraints.MinWidth = 713
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
    Height = 65
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    ExplicitWidth = 838
    object Button1: TButton
      Left = 104
      Top = 21
      Width = 75
      Height = 25
      Caption = 'Shrani'
      ModalResult = 1
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 272
      Top = 21
      Width = 75
      Height = 25
      Caption = 'Prekini'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 65
    Width = 697
    Height = 309
    Align = alClient
    Color = clSkyBlue
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 1
    ExplicitWidth = 838
    ExplicitHeight = 258
    object Label1: TLabel
      Left = 64
      Top = 24
      Width = 56
      Height = 16
      Caption = 'Vrstni red'
    end
    object Label2: TLabel
      Left = 64
      Top = 88
      Width = 157
      Height = 16
      Caption = #352'tev. merila (max 6 '#353'tevilk)'
    end
    object Label3: TLabel
      Left = 64
      Top = 144
      Width = 148
      Height = 16
      Caption = 'Naziv merila (max 50 '#269'rk)'
    end
    object Label4: TLabel
      Left = 64
      Top = 208
      Width = 142
      Height = 16
      Caption = 'Opis merila (max 50 '#269'rk)'
    end
    object Label5: TLabel
      Left = 199
      Top = 114
      Width = 86
      Height = 16
      Caption = 'Obvezen vnos'
      Font.Charset = EASTEUROPE_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object Label6: TLabel
      Left = 503
      Top = 169
      Width = 86
      Height = 16
      Caption = 'Obvezen vnos'
      Font.Charset = EASTEUROPE_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object Label7: TLabel
      Left = 503
      Top = 238
      Width = 86
      Height = 16
      Caption = 'Obvezen vnos'
      Font.Charset = EASTEUROPE_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object Edit1: TEdit
      Left = 88
      Top = 46
      Width = 105
      Height = 24
      TabOrder = 0
    end
    object Edit2: TEdit
      Left = 88
      Top = 110
      Width = 105
      Height = 24
      MaxLength = 6
      TabOrder = 1
      OnEnter = Edit2Enter
    end
    object Edit3: TEdit
      Left = 88
      Top = 166
      Width = 409
      Height = 24
      MaxLength = 50
      TabOrder = 2
      OnEnter = Edit3Enter
    end
    object Edit4: TEdit
      Left = 88
      Top = 230
      Width = 410
      Height = 24
      MaxLength = 50
      TabOrder = 3
      OnEnter = Edit4Enter
    end
  end
end
