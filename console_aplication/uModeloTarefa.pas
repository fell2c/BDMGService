unit uModeloTarefa;

interface

type
  TStatusTarefa = record
    ID: Integer;
    Descricao: string;
  end;

  TTarefa = class
  private
    FID: Integer;
    FTitulo: string;
    FDescricao: string;
    FStatusID: Integer;
    FStatusDescricao: string;
    FPrioridade: Integer;
    FDataCriacao: TDateTime;
    FDataConclusao: TDateTime;
  public
    property Id: Integer read FID write FID;
    property Titulo: string read FTitulo write FTitulo;
    property Descricao: string read FDescricao write FDescricao;
    property StatusId: Integer read FStatusID write FStatusID;
    property StatusDescricao: string read FStatusDescricao write FStatusDescricao;
    property Prioridade: Integer read FPrioridade write FPrioridade;  // 1, 2 ou 3
    property DataCriacao: TDateTime read FDataCriacao write FDataCriacao;
    property DataConclusao: TDateTime read FDataConclusao write FDataConclusao;
  end;

  TIndicadoresTarefas = class
  private
    FTotalTarefas: Integer;
    FMediaPrioridadePendentes: Integer;
    FConcluidasUltimos7Dias: Integer;
  public
    property TotalTarefas: Integer read FTotalTarefas write FTotalTarefas;
    property MediaPrioridadePendentes: Integer read FMediaPrioridadePendentes write FMediaPrioridadePendentes;
    property ConcluidasUltimos7Dias: Integer read FConcluidasUltimos7Dias write FConcluidasUltimos7Dias;
  end;

implementation
end.
