object MainView: TMainView
  Left = 0
  Top = 0
  Caption = 'Basic Bass Player'
  ClientHeight = 253
  ClientWidth = 455
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -20
  Font.Name = 'Bahnschrift SemiLight SemiConde'
  Font.Style = []
  Font.Quality = fqClearTypeNatural
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  TextHeight = 24
  object Btn_Click: TButton
    Left = 278
    Top = 24
    Width = 169
    Height = 65
    Cursor = crHandPoint
    Caption = 'Click Me'
    TabOrder = 0
    OnClick = Btn_ClickClick
  end
  object GrpBox_BGSound: TGroupBox
    Left = 8
    Top = 8
    Width = 264
    Height = 209
    Caption = 'BG Sound'
    TabOrder = 1
    object Btn_Switch_PlayStop: TSpeedButton
      Left = 24
      Top = 48
      Width = 185
      Height = 50
      Cursor = crHandPoint
      GroupIndex = 1
      Down = True
      Caption = 'SwitchTo <<Stop>>'
      OnClick = Btn_Switch_PlayStopClick
    end
    object Btn_Switch_PlayPause: TSpeedButton
      Left = 24
      Top = 128
      Width = 185
      Height = 50
      Cursor = crHandPoint
      GroupIndex = 1
      Caption = 'SwitchTo <<Pause>>'
      OnClick = Btn_Switch_PlayPauseClick
    end
  end
  object Pnl_Status: TPanel
    Left = 0
    Top = 226
    Width = 455
    Height = 27
    Align = alBottom
    Alignment = taLeftJustify
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitTop = 234
  end
end
