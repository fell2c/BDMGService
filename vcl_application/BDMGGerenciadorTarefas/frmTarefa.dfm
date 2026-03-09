object formTarefa: TformTarefa
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Incluir Tarefa'
  ClientHeight = 345
  ClientWidth = 526
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnClose = FormClose
  OnShow = FormShow
  TextHeight = 15
  object lblID: TLabel
    Left = 16
    Top = 19
    Width = 11
    Height = 15
    Caption = 'ID'
  end
  object lblTitulo: TLabel
    Left = 16
    Top = 69
    Width = 31
    Height = 15
    Caption = 'T'#237'tulo'
  end
  object lblDescricao: TLabel
    Left = 16
    Top = 119
    Width = 51
    Height = 15
    Caption = 'Descri'#231#227'o'
  end
  object lblStatus: TLabel
    Left = 16
    Top = 240
    Width = 32
    Height = 15
    Caption = 'Status'
  end
  object lblPrioridade: TLabel
    Left = 143
    Top = 240
    Width = 54
    Height = 15
    Caption = 'Prioridade'
  end
  object lblDataCriacao: TLabel
    Left = 270
    Top = 240
    Width = 67
    Height = 15
    Caption = 'Data Cria'#231#227'o'
  end
  object lblDataConclusao: TLabel
    Left = 397
    Top = 240
    Width = 78
    Height = 15
    Caption = 'Data Conclu'#227'o'
  end
  object edtID: TEdit
    Left = 16
    Top = 40
    Width = 51
    Height = 23
    TabStop = False
    Alignment = taRightJustify
    Enabled = False
    ReadOnly = True
    TabOrder = 0
  end
  object edtTitulo: TEdit
    Left = 16
    Top = 90
    Width = 502
    Height = 23
    TabOrder = 1
  end
  object cbbStatus: TComboBox
    Left = 16
    Top = 261
    Width = 121
    Height = 23
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 3
    Text = 'Pendente'
    Items.Strings = (
      'Pendente'
      'Em Andamento'
      'Conclu'#237'da')
  end
  object cbbPrioridade: TComboBox
    Left = 143
    Top = 261
    Width = 121
    Height = 23
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 4
    Text = 'Baixa'
    Items.Strings = (
      'Baixa'
      'M'#233'dia'
      'Alta')
  end
  object btnCancelar: TButton
    Left = 355
    Top = 305
    Width = 75
    Height = 25
    Caption = 'Cancelar'
    TabOrder = 7
    OnClick = btnCancelarClick
  end
  object btnConfirmar: TButton
    Left = 443
    Top = 305
    Width = 75
    Height = 25
    Caption = 'Confirmar'
    TabOrder = 8
    OnClick = btnConfirmarClick
  end
  object edtDataCriacao: TMaskEdit
    Left = 270
    Top = 261
    Width = 120
    Height = 23
    EditMask = '!99/99/0000;1;_'
    MaxLength = 10
    TabOrder = 5
    Text = '  /  /    '
  end
  object edtDataConclusao: TMaskEdit
    Left = 397
    Top = 261
    Width = 120
    Height = 23
    EditMask = '!99/99/0000;1;_'
    MaxLength = 10
    TabOrder = 6
    Text = '  /  /    '
  end
  object memDescricao: TMemo
    Left = 16
    Top = 140
    Width = 502
    Height = 89
    TabOrder = 2
  end
end
