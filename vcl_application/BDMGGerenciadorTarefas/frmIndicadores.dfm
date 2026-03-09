object formIndicadores: TformIndicadores
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Indicadores de Tarefas'
  ClientHeight = 196
  ClientWidth = 285
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnClose = FormClose
  TextHeight = 15
  object pnlIndicadores: TPanel
    Left = 8
    Top = 8
    Width = 265
    Height = 185
    TabOrder = 0
    object lblTotalTarefas: TLabel
      Left = 14
      Top = 40
      Width = 85
      Height = 15
      Caption = 'Total de Tarefas:'
    end
    object lblMediaTarefas: TLabel
      Left = 14
      Top = 80
      Width = 109
      Height = 15
      Caption = 'M'#233'dia de Prioridade:'
    end
    object lblConcluidas7d: TLabel
      Left = 14
      Top = 120
      Width = 187
      Height = 15
      Caption = 'Tarefas Conclu'#237'das ('#218'ltimos 7 dias):'
    end
    object lblValorTotalTarefas: TLabel
      Left = 120
      Top = 38
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
    object lblValorMediaPrioridade: TLabel
      Left = 144
      Top = 78
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
    object lblValorTarefasConcluidas7d: TLabel
      Left = 216
      Top = 118
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
  end
end
