object Form1: TForm1
  Left = 215
  Top = 222
  Width = 800
  Height = 553
  Caption = #1055#1088#1086#1093#1086#1078#1076#1077#1085#1080#1077' '#1089#1074#1077#1090#1072' '#1095#1077#1088#1077#1079' '#1073#1083#1077#1085#1076#1091
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    792
    519)
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 8
    Top = 136
    Width = 777
    Height = 378
    Anchors = [akLeft, akTop, akRight, akBottom]
  end
  object lblRaysCount: TLabel
    Left = 496
    Top = 72
    Width = 101
    Height = 13
    Caption = #1050#1086#1101#1092'. '#1087#1088#1086#1087#1091#1089#1082#1072#1085#1080#1103':'
  end
  object btnTrace: TButton
    Left = 496
    Top = 8
    Width = 153
    Height = 25
    Caption = #1055#1086#1089#1090#1088#1086#1080#1090#1100
    TabOrder = 0
    OnClick = btnTraceClick
  end
  object Button1: TButton
    Left = 496
    Top = 40
    Width = 153
    Height = 25
    Caption = #1050#1086#1101#1092'. '#1087#1088#1086#1087#1091#1089#1082#1072#1085#1080#1103' '#1086#1090' '#1091#1075#1083#1072
    TabOrder = 1
    OnClick = Button1Click
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 481
    Height = 121
    ActivePage = TabSheet1
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1073#1083#1077#1085#1076#1099
      object Label1: TLabel
        Left = 40
        Top = 6
        Width = 69
        Height = 13
        Caption = #1060#1086#1088#1084#1072' '#1103#1095#1077#1077#1082
      end
      object imgAperturePreview: TImage
        Left = 392
        Top = 0
        Width = 75
        Height = 75
      end
      object txtWidth: TLabeledEdit
        Left = 112
        Top = 24
        Width = 105
        Height = 21
        EditLabel.Width = 107
        EditLabel.Height = 13
        EditLabel.Caption = #1056#1072#1079#1084#1077#1088' '#1089#1090#1086#1088#1086#1085#1099', '#1084#1084
        LabelPosition = lpLeft
        TabOrder = 0
        Text = '2,5'
        OnChange = txtWidthChange
      end
      object cmbShape: TComboBox
        Left = 112
        Top = 0
        Width = 105
        Height = 21
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 1
        Text = #1064#1077#1089#1090#1080#1091#1075#1086#1083#1100#1085#1080#1082
        OnChange = cmbShapeChange
        Items.Strings = (
          #1064#1077#1089#1090#1080#1091#1075#1086#1083#1100#1085#1080#1082
          #1050#1074#1072#1076#1088#1072#1090
          #1058#1088#1077#1091#1075#1086#1083#1100#1085#1080#1082)
      end
      object txtDepth: TLabeledEdit
        Left = 112
        Top = 48
        Width = 105
        Height = 21
        EditLabel.Width = 63
        EditLabel.Height = 13
        EditLabel.Caption = #1043#1083#1091#1073#1080#1085#1072', '#1084#1084
        LabelPosition = lpLeft
        TabOrder = 2
        Text = '70'
        OnChange = txtDepthChange
      end
      object txtReflectance: TLabeledEdit
        Left = 352
        Top = 0
        Width = 33
        Height = 21
        EditLabel.Width = 132
        EditLabel.Height = 13
        EditLabel.Caption = #1053#1072#1087#1088#1072#1074#1083#1077#1085#1085#1086#1077' '#1086#1090#1088#1072#1078#1077#1085#1080#1077
        LabelPosition = lpLeft
        TabOrder = 3
        Text = '0,05'
        OnChange = txtReflectanceChange
      end
      object txtDiffusionReflectance: TLabeledEdit
        Left = 352
        Top = 24
        Width = 33
        Height = 21
        EditLabel.Width = 118
        EditLabel.Height = 13
        EditLabel.Caption = #1044#1080#1092#1092#1091#1079#1085#1086#1077' '#1086#1090#1088#1072#1078#1077#1085#1080#1077
        LabelPosition = lpLeft
        TabOrder = 4
        Text = '0'
        Visible = False
        OnChange = txtDiffusionReflectanceChange
      end
      object txtShapeAngle: TLabeledEdit
        Left = 112
        Top = 72
        Width = 105
        Height = 21
        EditLabel.Width = 107
        EditLabel.Height = 13
        EditLabel.Caption = #1059#1075#1086#1083' '#1087#1086#1074#1086#1088#1086#1090#1072', '#1075#1088#1072#1076'.'
        LabelPosition = lpLeft
        TabOrder = 5
        Text = '0'
        OnChange = txtShapeAngleChange
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1088#1080#1089#1086#1074#1082#1080
      ImageIndex = 1
      object txtSuperSample: TLabeledEdit
        Left = 296
        Top = 32
        Width = 33
        Height = 21
        EditLabel.Width = 151
        EditLabel.Height = 13
        EditLabel.Caption = #1055#1088#1077#1074#1099#1096#1077#1085#1080#1077' '#1080#1089#1093' '#1088#1072#1079#1088#1077#1096#1077#1085#1080#1103
        LabelPosition = lpLeft
        TabOrder = 0
        Text = '1'
      end
      object txtResX: TLabeledEdit
        Left = 104
        Top = 8
        Width = 33
        Height = 21
        EditLabel.Width = 88
        EditLabel.Height = 13
        EditLabel.Caption = #1056#1072#1079#1088#1077#1096#1077#1085#1080#1077' '#1087#1086' X'
        LabelPosition = lpLeft
        TabOrder = 1
        Text = '100'
      end
      object txtResY: TLabeledEdit
        Left = 296
        Top = 8
        Width = 33
        Height = 21
        EditLabel.Width = 88
        EditLabel.Height = 13
        EditLabel.Caption = #1056#1072#1079#1088#1077#1096#1077#1085#1080#1077' '#1087#1086' Y'
        LabelPosition = lpLeft
        TabOrder = 2
        Text = '100'
      end
      object txtAngleIter: TLabeledEdit
        Left = 104
        Top = 32
        Width = 33
        Height = 21
        EditLabel.Width = 97
        EditLabel.Height = 13
        EditLabel.Caption = #1048#1090#1077#1088#1072#1094#1080#1081' '#1087#1086' '#1091#1075#1083#1072#1084
        LabelPosition = lpLeft
        TabOrder = 3
        Text = '7'
      end
    end
    object TabSheet3: TTabSheet
      Caption = #1048#1089#1090#1086#1095#1085#1080#1082' '#1089#1074#1077#1090#1072
      ImageIndex = 2
      object txtAlpha: TLabeledEdit
        Left = 120
        Top = 8
        Width = 25
        Height = 21
        EditLabel.Width = 116
        EditLabel.Height = 13
        EditLabel.Caption = #1059#1075#1086#1083' '#1082' '#1086#1087#1090#1080#1095#1077#1089#1082#1086#1081' '#1086#1089#1080
        LabelPosition = lpLeft
        TabOrder = 0
        Text = '0'
      end
      object txtAngSize: TLabeledEdit
        Left = 288
        Top = 8
        Width = 41
        Height = 21
        EditLabel.Width = 139
        EditLabel.Height = 13
        EditLabel.Caption = #1059#1075#1083#1086#1074#1086#1081' '#1088#1072#1079#1084#1077#1088' '#1080#1089#1090#1086#1095#1085#1080#1082#1072
        LabelPosition = lpLeft
        TabOrder = 1
        Text = '0'
      end
      object txtFOV: TLabeledEdit
        Left = 120
        Top = 32
        Width = 25
        Height = 21
        EditLabel.Width = 64
        EditLabel.Height = 13
        EditLabel.Caption = #1059#1075#1086#1083' '#1079#1088#1077#1085#1080#1103
        LabelPosition = lpLeft
        TabOrder = 2
        Text = '2'
      end
      object txtRotation: TLabeledEdit
        Left = 288
        Top = 32
        Width = 41
        Height = 21
        EditLabel.Width = 101
        EditLabel.Height = 13
        EditLabel.Caption = #1055#1086#1074#1086#1088#1086#1090' '#1074#1086#1082#1088#1091#1075' '#1086#1089#1080
        LabelPosition = lpLeft
        TabOrder = 3
        Text = '0'
      end
    end
    object TabSheet4: TTabSheet
      Caption = #1055#1086#1089#1090#1088#1086#1077#1085#1080#1077' '#1075#1088#1072#1092#1080#1082#1072
      ImageIndex = 3
      object RadioGroup1: TRadioGroup
        Left = 0
        Top = 0
        Width = 225
        Height = 89
        Caption = #1045#1076#1080#1085#1080#1094#1099' '#1080#1079#1084#1077#1088#1077#1085#1080#1103
        TabOrder = 0
      end
      object rdTimes: TRadioButton
        Left = 8
        Top = 24
        Width = 81
        Height = 17
        Caption = '"'#1056#1072#1079#1099'"'
        Checked = True
        TabOrder = 1
        TabStop = True
      end
      object rdDb: TRadioButton
        Left = 8
        Top = 40
        Width = 193
        Height = 17
        Caption = #1044#1073' (-10 '#1044#1073'='#1086#1089#1083#1072#1073#1083#1077#1085#1080#1077' '#1074' 10 '#1088#1072#1079')'
        TabOrder = 2
      end
      object rdApMag: TRadioButton
        Left = 8
        Top = 56
        Width = 209
        Height = 17
        Caption = #1079#1074#1077#1079#1076#1085#1072#1103'  '#1074#1077#1083#1080#1095#1080#1085#1072' (5 '#1079#1074'. '#1074'=100 '#1088#1072#1079')'
        TabOrder = 3
      end
      object txtMaxAngle: TLabeledEdit
        Left = 320
        Top = 0
        Width = 65
        Height = 21
        EditLabel.Width = 87
        EditLabel.Height = 13
        EditLabel.Caption = #1052#1072#1082#1089'. '#1091#1075#1086#1083', '#1075#1088#1072#1076'.'
        LabelPosition = lpLeft
        TabOrder = 4
        Text = '20'
      end
      object chkRotIter: TCheckBox
        Left = 232
        Top = 24
        Width = 241
        Height = 17
        Caption = #1055#1086#1089#1090#1088#1086#1080#1090#1100' '#1076#1083#1103' '#1085#1077#1089#1082#1086#1083#1100#1082#1080#1093' '#1091#1075#1083#1086#1074' '#1087#1086#1074#1086#1088#1086#1090#1072
        TabOrder = 5
        OnClick = chkRotIterClick
      end
      object txtRotIter: TLabeledEdit
        Left = 344
        Top = 48
        Width = 65
        Height = 21
        EditLabel.Width = 109
        EditLabel.Height = 13
        EditLabel.Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1080#1090#1077#1088#1072#1094#1080#1081
        Enabled = False
        LabelPosition = lpLeft
        TabOrder = 6
        Text = '3'
      end
    end
  end
end
