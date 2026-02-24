object Frezultati: TFrezultati
  Left = 0
  Top = 0
  Caption = 'Frezultati'
  ClientHeight = 662
  ClientWidth = 1195
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
    Width = 1195
    Height = 41
    Align = alTop
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label9: TLabel
      Left = 24
      Top = 12
      Width = 34
      Height = 17
      Caption = 'Koda'
    end
    object Label10: TLabel
      Left = 160
      Top = 12
      Width = 51
      Height = 17
      Caption = 'Label10'
    end
    object Label11: TLabel
      Left = 380
      Top = 12
      Width = 50
      Height = 17
      Caption = 'Label11'
    end
    object Label12: TLabel
      Left = 730
      Top = 12
      Width = 51
      Height = 17
      Caption = 'Label12'
    end
    object Button1: TButton
      Left = 977
      Top = 10
      Width = 75
      Height = 25
      Caption = 'Button1'
      TabOrder = 0
      Visible = False
      OnClick = Button1Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 41
    Width = 953
    Height = 621
    Align = alLeft
    TabOrder = 1
    object Image1: TImage
      Left = 1
      Top = 42
      Width = 951
      Height = 578
      Align = alClient
      ExplicitLeft = 128
      ExplicitTop = 144
      ExplicitWidth = 105
      ExplicitHeight = 105
    end
    object Panel3: TPanel
      Left = 1
      Top = 1
      Width = 951
      Height = 41
      Align = alTop
      Caption = 'HISTOGRAM'
      Font.Charset = EASTEUROPE_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
  end
  object Panel4: TPanel
    Left = 953
    Top = 41
    Width = 242
    Height = 621
    Align = alClient
    TabOrder = 2
    object Panel5: TPanel
      Left = 1
      Top = 1
      Width = 240
      Height = 296
      Align = alTop
      Font.Charset = EASTEUROPE_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object Label1: TLabel
        Left = 80
        Top = 12
        Width = 92
        Height = 19
        Caption = 'STATISTIKA'
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label2: TLabel
        Left = 16
        Top = 50
        Width = 95
        Height = 17
        Caption = #352'tevilo meritve'
      end
      object Label3: TLabel
        Left = 16
        Top = 80
        Width = 65
        Height = 17
        Caption = 'Povpre'#269'je'
      end
      object pod1: TLabel
        Left = 144
        Top = 50
        Width = 32
        Height = 17
        Caption = 'pod1'
      end
      object pod2: TLabel
        Left = 144
        Top = 80
        Width = 32
        Height = 17
        Caption = 'pod2'
      end
      object Label4: TLabel
        Left = 16
        Top = 110
        Width = 82
        Height = 17
        Caption = 'Std deviacija'
      end
      object pod3: TLabel
        Left = 144
        Top = 110
        Width = 32
        Height = 17
        Caption = 'pod3'
      end
      object Minimum: TLabel
        Left = 16
        Top = 140
        Width = 59
        Height = 17
        Caption = 'Minimum'
      end
      object pod4: TLabel
        Left = 144
        Top = 140
        Width = 32
        Height = 17
        Caption = 'pod4'
      end
      object Label5: TLabel
        Left = 16
        Top = 170
        Width = 71
        Height = 17
        Caption = 'Maksimum'
      end
      object pod5: TLabel
        Left = 144
        Top = 170
        Width = 32
        Height = 17
        Caption = 'pod5'
      end
      object Label6: TLabel
        Left = 16
        Top = 200
        Width = 50
        Height = 17
        Caption = 'Razmik'
      end
      object Label7: TLabel
        Left = 16
        Top = 230
        Width = 19
        Height = 17
        Caption = 'Cp'
      end
      object Label8: TLabel
        Left = 16
        Top = 260
        Width = 26
        Height = 17
        Caption = 'Cpk'
      end
      object pod6: TLabel
        Left = 144
        Top = 200
        Width = 32
        Height = 17
        Caption = 'pod6'
      end
      object pod7: TLabel
        Left = 144
        Top = 230
        Width = 32
        Height = 17
        Caption = 'pod7'
      end
      object pod8: TLabel
        Left = 144
        Top = 260
        Width = 32
        Height = 17
        Caption = 'pod8'
      end
    end
    object Panel6: TPanel
      Left = 1
      Top = 297
      Width = 240
      Height = 323
      Align = alClient
      Font.Charset = EASTEUROPE_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      object Label13: TLabel
        Left = 16
        Top = 40
        Width = 95
        Height = 17
        Caption = #352'tevilo meritev'
      end
      object Label14: TLabel
        Left = 16
        Top = 72
        Width = 35
        Height = 17
        Caption = 'Dobri'
      end
      object Label15: TLabel
        Left = 72
        Top = 8
        Width = 91
        Height = 19
        Caption = 'KONTROLA'
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label16: TLabel
        Left = 16
        Top = 104
        Width = 90
        Height = 17
        Caption = 'Izven sp. toler'
      end
      object pr1: TLabel
        Left = 128
        Top = 40
        Width = 21
        Height = 17
        Caption = 'pr1'
      end
      object pr2: TLabel
        Left = 128
        Top = 72
        Width = 21
        Height = 17
        Caption = 'pr2'
      end
      object pr3: TLabel
        Left = 128
        Top = 104
        Width = 21
        Height = 17
        Caption = 'pr3'
      end
      object Label17: TLabel
        Left = 16
        Top = 136
        Width = 93
        Height = 17
        Caption = 'Izven zg. toler.'
      end
      object pr4: TLabel
        Left = 128
        Top = 136
        Width = 21
        Height = 17
        Caption = 'pr4'
      end
      object Label18: TLabel
        Left = 16
        Top = 168
        Width = 94
        Height = 17
        Caption = 'Izven obmo'#269'ja'
      end
      object pr5: TLabel
        Left = 128
        Top = 168
        Width = 21
        Height = 17
        Caption = 'pr5'
      end
      object od1: TLabel
        Left = 176
        Top = 40
        Width = 24
        Height = 17
        Caption = 'od1'
      end
      object od2: TLabel
        Left = 176
        Top = 72
        Width = 24
        Height = 17
        Caption = 'od2'
      end
      object od3: TLabel
        Left = 176
        Top = 104
        Width = 24
        Height = 17
        Caption = 'od3'
      end
      object od4: TLabel
        Left = 176
        Top = 136
        Width = 24
        Height = 17
        Caption = 'od4'
      end
      object od5: TLabel
        Left = 176
        Top = 168
        Width = 24
        Height = 17
        Caption = 'od5'
      end
    end
  end
  object ADOTable1: TADOTable
    Left = 736
    Top = 169
  end
end
