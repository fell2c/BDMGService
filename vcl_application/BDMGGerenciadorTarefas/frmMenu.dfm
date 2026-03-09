object GerenciadorTarefas: TGerenciadorTarefas
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Gerenciador Tarefas'
  ClientHeight = 410
  ClientWidth = 928
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object btnIncluirTarefa: TButton
    Left = 4
    Top = 9
    Width = 75
    Height = 25
    Caption = 'Incluir'
    TabOrder = 0
    OnClick = btnIncluirTarefaClick
  end
  object btnAtualizarTarefa: TButton
    Left = 91
    Top = 9
    Width = 75
    Height = 25
    Caption = 'Atualizar'
    TabOrder = 1
    OnClick = btnAtualizarTarefaClick
  end
  object btnRemoverTarefa: TButton
    Left = 179
    Top = 9
    Width = 75
    Height = 25
    Caption = 'Remover'
    TabOrder = 2
    OnClick = btnRemoverTarefaClick
  end
  object btnIndicadoresTarefas: TButton
    Left = 845
    Top = 377
    Width = 75
    Height = 25
    Caption = 'Indicadores'
    TabOrder = 3
    OnClick = btnIndicadoresTarefasClick
  end
  object lvTarefas: TListView
    Left = 4
    Top = 40
    Width = 916
    Height = 330
    Columns = <
      item
        Caption = 'ID'
      end
      item
        Caption = 'Titulo'
        Width = 200
      end
      item
        Caption = 'Descri'#231#227'o'
        Width = 450
      end
      item
        Caption = 'Status'
        Width = 110
      end
      item
        Caption = 'Prioridade'
        Width = 120
      end
      item
        Caption = 'Data Cria'#231#227'o'
        Width = 100
      end
      item
        Caption = 'Data Conclus'#227'o'
        Width = 100
      end>
    GridLines = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 4
    ViewStyle = vsReport
  end
end
