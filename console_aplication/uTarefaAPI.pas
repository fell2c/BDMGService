unit uTarefaAPI;

interface

uses
  System.Generics.Collections,
  FireDAC.Comp.Client,
  iConexao,
  iTarefaAPI,
  uModeloTarefa;

type
  TTarefaAPI = class(TInterfacedObject, IAPITarefa)
  private
    FConexao: IConexaoFactory;

    function CreateConnection: TFDConnection;
    function PreencherClasseComTarefa(pQry: TFDQuery): TTarefa;
  public
    constructor Create(AFactory: IConexaoFactory);

    function GetAll: TObjectList<TTarefa>;
    function GetById(const pID: Integer): TTarefa;
    function GetIndicadoresTarefas: TIndicadoresTarefas;
    procedure Add(pTarefa: TTarefa);
    procedure UpdateStatus(const pID, pStatusID: Integer);
    procedure Delete(const pID: Integer);
  end;

implementation

uses
  SysUtils,
  FireDAC.Stan.Def,
  FireDac.Stan.Param,
  Data.DB;

constructor TTarefaAPI.Create(AFactory: IConexaoFactory);
begin
  FConexao := AFactory;
end;

function TTarefaAPI.CreateConnection: TFDConnection;
begin
  Result := FConexao.GetConexao;
end;

function TTarefaAPI.GetAll: TObjectList<TTarefa>;
var
  lConexao: TFDConnection;
  lQry: TFDQuery;
begin
  Result := TObjectList<TTarefa>.Create;

  lConexao := CreateConnection;
  try
    lQry := TFDQuery.Create(nil);
    try
      lQry.Connection := lConexao;

      lQry.SQL.Text :=
        ' SELECT t.ID, t.Titulo, t.Descricao, t.StatusId, t.Prioridade, t.DataCriacao, t.DataConclusao ' + sLineBreak +
        ' FROM Tarefas t ';

      lQry.Open;
      while not lQry.Eof do
      begin
        Result.Add(PreencherClasseComTarefa(lQry));

        lQry.Next;
      end;
    finally
      lQry.Free;
    end;
  finally
    lConexao.Free;
  end;
end;

function TTarefaAPI.PreencherClasseComTarefa(pQry: TFDQuery): TTarefa;
var
  lTarefa: TTarefa;
begin
  lTarefa := TTarefa.Create;

  lTarefa.Id := pQry.FieldByName('ID').AsInteger;
  lTarefa.Titulo := pQry.FieldByName('Titulo').AsString;
  lTarefa.Descricao := pQry.FieldByName('Descricao').AsString;
  lTarefa.StatusId := pQry.FieldByName('StatusId').AsInteger;
  lTarefa.Prioridade := pQry.FieldByName('Prioridade').AsInteger;
  lTarefa.DataCriacao := pQry.FieldByName('DataCriacao').AsDateTime;

  if pQry.FieldByName('DataConclusao').IsNull then
    lTarefa.DataConclusao := 0
  else
    lTarefa.DataConclusao := pQry.FieldByName('DataConclusao').AsDateTime;

  Result := lTarefa;
end;

function TTarefaAPI.GetById(const pID: Integer): TTarefa;
var
  lConexao: TFDConnection;
  lQry: TFDQuery;
begin
  Result := nil;

  lConexao := CreateConnection;
  try
    lQry := TFDQuery.Create(nil);
    try
      lQry.Connection := lConexao;

      lQry.SQL.Text :=
        ' SELECT t.ID, t.Titulo, t.Descricao, t.StatusId, t.Prioridade, t.DataCriacao, t.DataConclusao ' + sLineBreak +
        ' FROM Tarefas t ' + sLineBreak +
        ' WHERE t.ID = :ID';

      lQry.ParamByName('ID').AsInteger := pID;
      lQry.Open;

      if not lQry.IsEmpty then
        Result := PreencherClasseComTarefa(lQry);
    finally
      lQry.Free;
    end;
  finally
    lConexao.Free;
  end;
end;

procedure TTarefaAPI.Add(pTarefa: TTarefa);
var
  lConexao: TFDConnection;
  lQry: TFDQuery;
begin
  lConexao := CreateConnection;
  try
    lQry := TFDQuery.Create(nil);
    try
      lQry.Connection := lConexao;

      lQry.SQL.Text :=
        ' INSERT INTO Tarefas (Titulo, Descricao, StatusId, Prioridade) ' + sLineBreak +
        ' VALUES (:Titulo, :Descricao, :StatusId, :Prioridade)';

      lQry.ParamByName('Titulo').AsString := pTarefa.Titulo;
      lQry.ParamByName('Descricao').AsString := pTarefa.Descricao;

      // StatusID = 1 "Pendente", uma tarefa nova sempre começará com status "Pendente"
      lQry.ParamByName('StatusId').AsInteger  := 1;
      lQry.ParamByName('Prioridade').AsInteger := pTarefa.Prioridade;

      lQry.ExecSQL;
    finally
      lQry.Free;
    end;
  finally
    lConexao.Free;
  end;
end;

procedure TTarefaAPI.UpdateStatus(const pID, pStatusID: Integer);
var
  lConexao: TFDConnection;
  lQry: TFDQuery;
begin
  lConexao := CreateConnection;
  try
    lQry := TFDQuery.Create(nil);
    try
      lQry.Connection := lConexao;

      //Se o pStatusID for 3 é atualizado a DataConclusao
      lQry.SQL.Text :=
        ' UPDATE Tarefas ' + sLineBreak +
        ' SET StatusId = :StatusId, ' + sLineBreak +
        '    DataConclusao = CASE WHEN :StatusId2 = 3 ' + sLineBreak +
        '                        THEN GETDATE() ' + sLineBreak +
        '                        ELSE NULL END ' + sLineBreak +
        ' WHERE ID = :ID';

      lQry.ParamByName('StatusId').AsInteger := pStatusID;
      lQry.ParamByName('StatusId2').AsInteger := pStatusID;
      lQry.ParamByName('ID').AsInteger := pID;

      lQry.ExecSQL;
    finally
      lQry.Free;
    end;
  finally
    lConexao.Free;
  end;
end;

procedure TTarefaAPI.Delete(const pID: Integer);
var
  lConexao: TFDConnection;
  lQry: TFDQuery;
begin
  lConexao := CreateConnection;
  try
    lQry := TFDQuery.Create(nil);
    try
      lQry.Connection := lConexao;
      lQry.SQL.Text := 'DELETE FROM Tarefas WHERE ID = :ID';
      lQry.ParamByName('ID').AsInteger := pID;
      lQry.ExecSQL;
    finally
      lQry.Free;
    end;
  finally
    lConexao.Free;
  end;
end;

function TTarefaAPI.GetIndicadoresTarefas: TIndicadoresTarefas;
var
  lConexao: TFDConnection;
  lQry: TFDQuery;
begin
  Result := TIndicadoresTarefas.Create;

  lConexao := CreateConnection;
  try
    lQry := TFDQuery.Create(nil);
    try
      lQry.Connection := lConexao;

      lQry.SQL.Text :=
        ' SELECT TotalTarefas, MediaPrioridadePendentes, ConcluidasUltimos7Dias ' + sLineBreak +
        ' FROM Vw_IndicadoresTarefas';

      lQry.Open;

      Result.TotalTarefas := lQry.FieldByName('TotalTarefas').AsInteger;
      Result.MediaPrioridadePendentes := lQry.FieldByName('MediaPrioridadePendentes').AsInteger;
      Result.ConcluidasUltimos7Dias := lQry.FieldByName('ConcluidasUltimos7Dias').AsInteger;
    finally
      lQry.Free;
    end;
  finally
    lConexao.Free;
  end;
end;

end.
