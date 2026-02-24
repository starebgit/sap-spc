object FGrafi: TFGrafi
  Left = 0
  Top = 0
  Caption = 'Prikaz grafov'
  ClientHeight = 672
  ClientWidth = 1325
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1325
    Height = 57
    Align = alTop
    TabOrder = 0
    object Legen: TImage
      Left = 1
      Top = 1
      Width = 1323
      Height = 55
      Align = alClient
      ExplicitLeft = 72
      ExplicitTop = 8
      ExplicitWidth = 105
      ExplicitHeight = 105
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 57
    Width = 1325
    Height = 615
    Align = alClient
    TabOrder = 1
    object Panel3: TPanel
      Left = 1
      Top = 1
      Width = 656
      Height = 613
      Align = alLeft
      BevelOuter = bvLowered
      BorderWidth = 3
      TabOrder = 0
      object Image3: TImage
        Left = 4
        Top = 284
        Width = 648
        Height = 325
        Align = alClient
        ExplicitLeft = 128
        ExplicitTop = 344
        ExplicitWidth = 105
        ExplicitHeight = 105
      end
      object Panel5: TPanel
        Left = 4
        Top = 4
        Width = 648
        Height = 280
        Align = alTop
        BevelOuter = bvLowered
        BorderWidth = 3
        TabOrder = 0
        object Image1: TImage
          Left = 4
          Top = 4
          Width = 640
          Height = 272
          Align = alClient
          ExplicitLeft = 88
          ExplicitTop = 40
          ExplicitWidth = 105
          ExplicitHeight = 105
        end
      end
    end
    object Panel4: TPanel
      Left = 657
      Top = 1
      Width = 667
      Height = 613
      Align = alClient
      TabOrder = 1
      object Panel6: TPanel
        Left = 1
        Top = 1
        Width = 665
        Height = 611
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 3
        TabOrder = 0
        object Panel7: TPanel
          Left = 3
          Top = 3
          Width = 659
          Height = 279
          Align = alTop
          BevelOuter = bvLowered
          TabOrder = 0
          object Image2: TImage
            Left = 1
            Top = 1
            Width = 657
            Height = 277
            Align = alClient
            ExplicitLeft = 64
            ExplicitTop = 56
            ExplicitWidth = 105
            ExplicitHeight = 105
          end
        end
        object Panel8: TPanel
          Left = 3
          Top = 282
          Width = 659
          Height = 326
          Align = alClient
          BevelOuter = bvLowered
          BorderWidth = 3
          TabOrder = 1
          object Image4: TImage
            Left = 4
            Top = 4
            Width = 651
            Height = 318
            Align = alClient
            ExplicitLeft = 80
            ExplicitTop = 40
            ExplicitWidth = 105
            ExplicitHeight = 105
          end
        end
      end
    end
  end
end
