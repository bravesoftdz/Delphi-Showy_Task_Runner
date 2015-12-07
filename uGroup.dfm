object fmGroup: TfmGroup
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  ClientHeight = 140
  ClientWidth = 242
  Color = clBtnFace
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
    Width = 242
    Height = 140
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitHeight = 145
    object lblName: TLabel
      Left = 8
      Top = 5
      Width = 31
      Height = 13
      Caption = 'Name:'
    end
    object lblGroup: TLabel
      Left = 8
      Top = 51
      Width = 33
      Height = 13
      Caption = 'Group:'
    end
    object lblFont: TLabel
      Left = 200
      Top = 51
      Width = 26
      Height = 13
      Caption = 'Font:'
    end
    object pnlControl: TPanel
      Left = 0
      Top = 101
      Width = 242
      Height = 39
      Align = alBottom
      TabOrder = 0
      ExplicitTop = 106
      object btnOk: TBitBtn
        Left = 8
        Top = 8
        Width = 80
        Height = 25
        DoubleBuffered = True
        Kind = bkOK
        ParentDoubleBuffered = False
        TabOrder = 0
      end
      object btnCancel: TBitBtn
        Left = 153
        Top = 8
        Width = 80
        Height = 25
        DoubleBuffered = True
        Kind = bkCancel
        ParentDoubleBuffered = False
        TabOrder = 1
      end
    end
    object edName: TEdit
      Left = 8
      Top = 24
      Width = 225
      Height = 21
      TabOrder = 1
      Text = 'default'
    end
    object cmbGroup: TComboBox
      Left = 8
      Top = 70
      Width = 186
      Height = 21
      TabOrder = 2
    end
    object btnFont: TButton
      Left = 200
      Top = 70
      Width = 33
      Height = 21
      Caption = '...'
      TabOrder = 3
      OnClick = btnFontClick
    end
  end
  object fdGroup: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    MinFontSize = 5
    MaxFontSize = 120
    Left = 64
    Top = 8
  end
end
