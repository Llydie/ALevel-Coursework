object MainForm: TMainForm
  Left = 510
  Top = 317
  Caption = 'Shortest Route Finder'
  ClientHeight = 416
  ClientWidth = 545
  Color = clGradientInactiveCaption
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = [fsBold]
  Menu = MainMenu
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object MapLabel: TLabel
    Left = 16
    Top = 90
    Width = 36
    Height = 16
    Caption = 'Map: '
  end
  object TitleLabel: TLabel
    Left = 8
    Top = 24
    Width = 408
    Height = 45
    Caption = 'Shortest Route Finder'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -37
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object StartLabel: TLabel
    Left = 16
    Top = 144
    Width = 102
    Height = 16
    Caption = 'Start Location: '
  end
  object DestLabel: TLabel
    Left = 16
    Top = 192
    Width = 83
    Height = 16
    Caption = 'Destination: '
  end
  object AddLabel: TLabel
    Left = 329
    Top = 112
    Width = 87
    Height = 16
    Caption = 'Place to Add:'
  end
  object RemoveLabel: TLabel
    Left = 329
    Top = 167
    Width = 113
    Height = 16
    Caption = 'Place to Remove:'
  end
  object MapCombo: TComboBox
    Left = 72
    Top = 88
    Width = 145
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    Text = 'Please Select a Map'
    OnChange = MapComboChange
    OnSelect = MapComboChange
  end
  object RouteBox: TListBox
    Left = 16
    Top = 240
    Width = 289
    Height = 153
    TabOrder = 1
  end
  object CalculateButton: TButton
    Left = 311
    Top = 360
    Width = 97
    Height = 33
    Caption = 'Calculate'
    TabOrder = 2
    OnClick = CalculateButtonClick
  end
  object AddButton: TButton
    Left = 476
    Top = 137
    Width = 61
    Height = 25
    Caption = 'Add'
    TabOrder = 3
    OnClick = AddButtonClick
  end
  object RemoveButton: TButton
    Left = 476
    Top = 189
    Width = 61
    Height = 25
    Caption = 'Remove'
    TabOrder = 4
    OnClick = RemoveButtonClick
  end
  object StartCombo: TComboBox
    Left = 136
    Top = 137
    Width = 145
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    Text = 'Select Start'
  end
  object DestCombo: TComboBox
    Left = 136
    Top = 189
    Width = 145
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    Text = 'Select Destination'
  end
  object AddCombo: TComboBox
    Left = 325
    Top = 137
    Width = 145
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    Text = 'Select Place '
  end
  object RemoveCombo: TComboBox
    Left = 325
    Top = 189
    Width = 145
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 8
    Text = 'Select Place'
  end
  object MainMenu: TMainMenu
    Left = 8
    object Menu: TMenuItem
      Caption = 'Menu'
      object New: TMenuItem
        Caption = 'New'
        OnClick = NewClick
      end
      object MenuExit: TMenuItem
        Caption = 'Exit'
        OnClick = MenuExitClick
      end
    end
  end
end
