object formIndicadores: TformIndicadores
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Indicadores de Tarefas'
  ClientHeight = 135
  ClientWidth = 261
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  TextHeight = 15
  object lblTotalTarefas: TLabel
    Left = 22
    Top = 16
    Width = 85
    Height = 15
    Caption = 'Total de Tarefas:'
  end
  object lblValorTarefasConcluidas7d: TLabel
    Left = 224
    Top = 94
    Width = 20
    Height = 17
    Caption = 'N'#186' '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clDarkblue
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblValorMediaPrioridade: TLabel
    Left = 152
    Top = 54
    Width = 38
    Height = 17
    Caption = 'Media'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clDarkblue
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblValorTotalTarefas: TLabel
    Left = 128
    Top = 14
    Width = 51
    Height = 17
    Caption = 'Total N'#186
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clDarkblue
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblMediaTarefas: TLabel
    Left = 22
    Top = 56
    Width = 109
    Height = 15
    Caption = 'M'#233'dia de Prioridade:'
  end
  object lblConcluidas7d: TLabel
    Left = 22
    Top = 96
    Width = 187
    Height = 15
    Caption = 'Tarefas Conclu'#237'das ('#218'ltimos 7 dias):'
  end
end
