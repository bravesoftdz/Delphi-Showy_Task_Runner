object fmEvent: TfmEvent
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = #1057#1086#1079#1076#1072#1090#1100' '#1079#1072#1076#1072#1095#1091
  ClientHeight = 626
  ClientWidth = 371
  Color = clBtnFace
  Constraints.MinHeight = 650
  Constraints.MinWidth = 379
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 371
    Height = 626
    Align = alClient
    AutoSize = True
    BevelOuter = bvNone
    TabOrder = 0
    object pnlTask: TPanel
      Left = 0
      Top = 0
      Width = 371
      Height = 626
      Align = alClient
      AutoSize = True
      BevelOuter = bvNone
      TabOrder = 0
      object lblTime: TLabel
        Left = 16
        Top = 44
        Width = 34
        Height = 13
        Hint = #1042#1088#1077#1084#1103': '
        Caption = #1042#1088#1077#1084#1103':'
      end
      object lblType: TLabel
        Left = 16
        Top = 124
        Width = 22
        Height = 13
        Hint = #1058#1080#1087': '
        Caption = #1058#1080#1087':'
      end
      object lblCircleTimeType: TLabel
        Left = 16
        Top = 151
        Width = 37
        Height = 13
        Hint = #1052#1077#1090#1086#1076' '#1089#1088#1072#1073#1072#1090#1099#1074#1072#1085#1080#1103': '
        Caption = #1052#1077#1090#1086#1076':'
      end
      object lblCircleDays: TLabel
        Left = 16
        Top = 178
        Width = 50
        Height = 13
        Hint = #1044#1085#1080': '
        Caption = #1044#1085#1080' '#1085#1077#1076'.:'
      end
      object lblCircleMonthDays: TLabel
        Left = 16
        Top = 207
        Width = 48
        Height = 13
        Hint = #1044#1077#1085#1100' '#1084#1077#1089#1103#1094#1072': '
        Caption = #1044#1085#1080' '#1084#1077#1089'.:'
      end
      object lblName: TLabel
        Left = 16
        Top = 16
        Width = 52
        Height = 13
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077':'
      end
      object lblDate: TLabel
        Left = 16
        Top = 71
        Width = 30
        Height = 13
        Hint = #1042#1088#1077#1084#1103': '
        Caption = #1044#1072#1090#1072':'
      end
      object lblGroup: TLabel
        Left = 16
        Top = 97
        Width = 40
        Height = 13
        Caption = #1043#1088#1091#1087#1087#1072':'
      end
      object lblStatus: TLabel
        Left = 16
        Top = 347
        Width = 40
        Height = 13
        Hint = #1057#1090#1072#1090#1091#1089': '
        Caption = #1057#1090#1072#1090#1091#1089':'
      end
      object lblPrgmPath: TLabel
        Left = 16
        Top = 320
        Width = 29
        Height = 13
        Caption = #1055#1091#1090#1100':'
      end
      object pnlButtons: TPanel
        Left = 0
        Top = 599
        Width = 371
        Height = 27
        Align = alBottom
        AutoSize = True
        TabOrder = 0
        object btnCreate: TBitBtn
          Left = 273
          Top = 1
          Width = 97
          Height = 25
          Align = alRight
          Caption = #1057#1086#1079#1076#1072#1090#1100
          Default = True
          DoubleBuffered = True
          Enabled = False
          Glyph.Data = {
            DE010000424DDE01000000000000760000002800000024000000120000000100
            0400000000006801000000000000000000001000000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
            3333333333333333333333330000333333333333333333333333F33333333333
            00003333344333333333333333388F3333333333000033334224333333333333
            338338F3333333330000333422224333333333333833338F3333333300003342
            222224333333333383333338F3333333000034222A22224333333338F338F333
            8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
            33333338F83338F338F33333000033A33333A222433333338333338F338F3333
            0000333333333A222433333333333338F338F33300003333333333A222433333
            333333338F338F33000033333333333A222433333333333338F338F300003333
            33333333A222433333333333338F338F00003333333333333A22433333333333
            3338F38F000033333333333333A223333333333333338F830000333333333333
            333A333333333333333338330000333333333333333333333333333333333333
            0000}
          ModalResult = 1
          NumGlyphs = 2
          ParentDoubleBuffered = False
          TabOrder = 0
        end
        object btnCancel: TBitBtn
          Left = 1
          Top = 1
          Width = 97
          Height = 25
          Align = alLeft
          Caption = #1054#1090#1084#1077#1085#1072
          DoubleBuffered = True
          Kind = bkCancel
          ParentDoubleBuffered = False
          TabOrder = 1
        end
      end
      object edName: TEdit
        Left = 74
        Top = 13
        Width = 285
        Height = 21
        TabOrder = 1
        OnChange = edNameChange
      end
      object dtpTime: TDateTimePicker
        Left = 74
        Top = 40
        Width = 95
        Height = 21
        Date = 42236.000000000000000000
        Time = 42236.000000000000000000
        DoubleBuffered = False
        Kind = dtkTime
        ParentDoubleBuffered = False
        TabOrder = 2
      end
      object dtpDate: TDateTimePicker
        Left = 74
        Top = 67
        Width = 95
        Height = 21
        Date = 42236.000000000000000000
        Time = 42236.000000000000000000
        DoubleBuffered = False
        ParentDoubleBuffered = False
        TabOrder = 3
        OnChange = dtpDateChange
      end
      object cbxType: TComboBox
        Left = 74
        Top = 121
        Width = 145
        Height = 21
        Style = csDropDownList
        CharCase = ecUpperCase
        ItemIndex = 0
        TabOrder = 4
        Text = #1053#1054#1056#1052#1040#1051#1068#1053#1054#1045
        Items.Strings = (
          #1053#1054#1056#1052#1040#1051#1068#1053#1054#1045
          #1042#1040#1046#1053#1054#1045)
      end
      object cbxCircleTimeType: TComboBox
        Left = 74
        Top = 148
        Width = 199
        Height = 21
        Style = csDropDownList
        CharCase = ecUpperCase
        ItemIndex = 0
        TabOrder = 5
        Text = #1054#1044#1048#1053' '#1056#1040#1047
        OnChange = cbxCircleTimeTypeChange
        Items.Strings = (
          #1054#1044#1048#1053' '#1056#1040#1047
          #1050#1040#1046#1044#1067#1049' '#1044#1045#1053#1068
          #1050#1040#1046#1044#1067#1049' '#1044#1045#1053#1068' '#1053#1045#1044#1045#1051#1048
          #1050#1040#1046#1044#1067#1049' '#1044#1045#1053#1068' '#1042' '#1052#1045#1057#1071#1062#1045
          #1055#1045#1056#1042#1067#1049' '#1056#1040#1041#1054#1063#1048#1049' '#1044#1045#1053#1068' '#1052#1045#1057#1071#1062#1040
          #1055#1054#1057#1051#1045#1044#1053#1048#1049' '#1056#1040#1041#1054#1063#1048#1049' '#1044#1045#1053#1068' '#1052#1045#1057#1071#1062#1040)
      end
      object gbDays: TGroupBox
        Left = 74
        Top = 170
        Width = 285
        Height = 26
        TabOrder = 6
        object chbMon: TCheckBox
          Tag = 1
          Left = 5
          Top = 7
          Width = 37
          Height = 17
          Caption = #1055#1085
          Enabled = False
          TabOrder = 0
        end
        object chbTue: TCheckBox
          Tag = 2
          Left = 45
          Top = 7
          Width = 37
          Height = 17
          Caption = #1042#1090
          Enabled = False
          TabOrder = 1
        end
        object chbWed: TCheckBox
          Tag = 3
          Left = 85
          Top = 7
          Width = 37
          Height = 17
          Caption = #1057#1088
          Enabled = False
          TabOrder = 2
        end
        object chbThu: TCheckBox
          Tag = 4
          Left = 125
          Top = 7
          Width = 37
          Height = 17
          Caption = #1063#1090
          Enabled = False
          TabOrder = 3
        end
        object chbFri: TCheckBox
          Tag = 5
          Left = 165
          Top = 7
          Width = 37
          Height = 17
          Caption = #1055#1090
          Enabled = False
          TabOrder = 4
        end
        object chbSat: TCheckBox
          Tag = 6
          Left = 205
          Top = 7
          Width = 37
          Height = 17
          Caption = #1057#1073
          Enabled = False
          TabOrder = 5
        end
        object chbSun: TCheckBox
          Tag = 7
          Left = 245
          Top = 7
          Width = 37
          Height = 17
          Caption = #1042#1089
          Enabled = False
          TabOrder = 6
        end
      end
      object gbMDays: TGroupBox
        Left = 74
        Top = 199
        Width = 285
        Height = 26
        TabOrder = 7
      end
      object pnlTaskMsg: TPanel
        Left = 0
        Top = 371
        Width = 371
        Height = 228
        Align = alBottom
        AutoSize = True
        BevelOuter = bvNone
        Constraints.MaxHeight = 228
        Constraints.MinHeight = 52
        Constraints.MinWidth = 52
        TabOrder = 8
        object pnlTaskName: TPanel
          Left = 0
          Top = 0
          Width = 371
          Height = 13
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          TabOrder = 0
          object lblTaskName: TLabel
            Left = 16
            Top = 0
            Width = 68
            Height = 13
            Caption = #1057#1086#1076#1077#1088#1078#1072#1085#1080#1077':'
          end
        end
        object qmTask: TMemo
          Left = 0
          Top = 13
          Width = 371
          Height = 215
          Align = alClient
          ScrollBars = ssVertical
          TabOrder = 1
        end
      end
      object cbxGroup: TComboBox
        Left = 74
        Top = 94
        Width = 145
        Height = 21
        Style = csDropDownList
        TabOrder = 9
      end
      object cbxDone: TComboBox
        Left = 74
        Top = 344
        Width = 145
        Height = 21
        Style = csDropDownList
        CharCase = ecUpperCase
        ItemIndex = 0
        TabOrder = 10
        Text = #1040#1050#1058#1048#1042#1053#1054
        Items.Strings = (
          #1040#1050#1058#1048#1042#1053#1054
          #1042#1067#1055#1054#1051#1053#1045#1053#1054)
      end
      object chbStartPrgm: TCheckBox
        Left = 16
        Top = 297
        Width = 281
        Height = 17
        Caption = #1047#1072#1087#1091#1089#1082#1072#1090#1100' '#1087#1088#1086#1075#1088#1072#1084#1084#1091' '#1087#1088#1080' '#1089#1088#1072#1073#1072#1090#1099#1074#1072#1085#1080#1080' '#1090#1072#1081#1084#1077#1088#1072'?'
        TabOrder = 11
        OnClick = chbStartPrgmClick
      end
      object edPrgmPath: TEdit
        Left = 74
        Top = 317
        Width = 263
        Height = 21
        Enabled = False
        ReadOnly = True
        TabOrder = 12
      end
      object btnChoosePath: TBitBtn
        Left = 332
        Top = 317
        Width = 27
        Height = 21
        Caption = '...'
        DoubleBuffered = False
        Enabled = False
        NumGlyphs = 2
        ParentDoubleBuffered = False
        TabOrder = 13
        OnClick = btnChoosePathClick
      end
    end
  end
  object odPrgm: TOpenDialog
    InitialDir = 'C:\'
    Options = [ofFileMustExist, ofEnableSizing]
    Left = 328
    Top = 48
  end
end
