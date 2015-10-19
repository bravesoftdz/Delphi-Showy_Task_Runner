object fmTask: TfmTask
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  ClientHeight = 100
  ClientWidth = 428
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 428
    Height = 100
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object pnlMsg: TPanel
      Left = 0
      Top = 0
      Width = 428
      Height = 65
      Align = alClient
      TabOrder = 0
      object mmMsg: TMemo
        Left = 1
        Top = 1
        Width = 426
        Height = 63
        Align = alClient
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object pnlButtons: TPanel
      Left = 0
      Top = 65
      Width = 428
      Height = 35
      Align = alBottom
      Color = clActiveBorder
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 1
      VerticalAlignment = taAlignTop
      object lblCurrTime: TLabel
        Left = 5
        Top = 9
        Width = 188
        Height = 18
        AutoSize = False
        Caption = '16:00:01'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMaroon
        Font.Height = -16
        Font.Name = 'Verdana'
        Font.Style = [fsBold, fsUnderline]
        ParentFont = False
        Transparent = True
      end
      object bbDone: TBitBtn
        Left = 199
        Top = 5
        Width = 88
        Height = 25
        Caption = '&'#1042#1099#1087#1086#1083#1085#1077#1085#1086
        DoubleBuffered = True
        Kind = bkYes
        ParentDoubleBuffered = False
        TabOrder = 0
      end
      object bbReminder: TBitBtn
        Left = 293
        Top = 5
        Width = 88
        Height = 25
        Caption = '&'#1055#1086#1079#1078#1077
        DoubleBuffered = False
        Kind = bkIgnore
        ParentDoubleBuffered = False
        TabOrder = 1
      end
      object cmbReminder: TComboBox
        Left = 382
        Top = 5
        Width = 43
        Height = 24
        Hint = #1042#1088#1077#1084#1103' '#1074' '#1089#1077#1082#1091#1085#1076#1072#1093
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        Text = '300'
        Items.Strings = (
          '30'
          '60'
          '300'
          '1800'
          '3600')
      end
    end
  end
end
