object Form2: TForm2
  Left = 235
  Top = 267
  Width = 870
  Height = 640
  Caption = #1043#1088#1072#1092#1080#1082
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    862
    606)
  PixelsPerInch = 96
  TextHeight = 13
  object Chart1: TChart
    Left = 8
    Top = 8
    Width = 849
    Height = 561
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    Title.Text.Strings = (
      #1047#1072#1074#1080#1089#1080#1084#1086#1089#1090#1100' '#1082#1086#1101#1092'. '#1087#1088#1086#1087#1091#1089#1082#1072#1085#1080#1103' '#1086#1090' '#1091#1075#1083#1072' '#1082' '#1086#1087#1090#1080#1095#1077#1089#1082#1086#1081' '#1086#1089#1080)
    BottomAxis.Title.Caption = #1091#1075#1086#1083', '#1075#1088#1072#1076#1091#1089#1099
    LeftAxis.Title.Caption = #1086#1089#1083#1072#1073#1083#1077#1085#1080#1077', '#1044#1073
    Legend.Visible = False
    View3D = False
    BevelOuter = bvNone
    Color = clWhite
    TabOrder = 0
    Anchors = [akLeft, akTop, akRight, akBottom]
  end
  object btnSaveBmp: TButton
    Left = 8
    Top = 576
    Width = 89
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1074' Bmp'
    TabOrder = 1
    OnClick = btnSaveBmpClick
  end
  object btnSaveTxt: TButton
    Left = 104
    Top = 576
    Width = 153
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1074' '#1090#1077#1082#1089#1090#1086#1074#1099#1081' '#1092#1072#1081#1083
    TabOrder = 2
    OnClick = btnSaveTxtClick
  end
  object SavePictureDialog1: TSavePictureDialog
    DefaultExt = 'bmp'
    Left = 272
    Top = 576
  end
  object SaveDialog1: TSaveDialog
    Left = 312
    Top = 576
  end
end
