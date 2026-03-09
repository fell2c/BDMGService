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
    function GetById(const pIDTarefa: Integer): TTarefa;
    function GetIndicadoresTarefas: TIndicadoresTarefas;
    procedure Add(pTarefa: TTarefa);
    procedure Update(pTarefa: TTarefa);
    procedure Delete(const pIDTarefa: Integer);
  end;

implementation

uses
  System.SysUtils,
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
        ' SELECT t.ID, t.Titulo, t.Descricao, t.StatusID, t.Prioridade, t.DataCriacao, ' + sLineBreak +
        '   t.DataConclusao, s.Descricao as StatusDescricao ' + sLineBreak +
        ' FROM Tarefas t ' + sLineBreak +
        ' LEFT JOIN StatusTarefas s on s.ID = t.StatusID ' + sLineBreak;

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
  lTarefa.StatusID := pQry.FieldByName('StatusID').AsInteger;
  lTarefa.StatusDescricao := pQry.FieldByName('StatusDescricao').AsString;
  lTarefa.Prioridade := pQry.FieldByName('Prioridade').AsInteger;
  lTarefa.DataCriacao := pQry.FieldByName('DataCriacao').AsDateTime;

  if pQry.FieldByName('DataConclusao').IsNull then
    lTarefa.DataConclusao := 0
  else
    lTarefa.DataConclusao := pQry.FieldByName('DataConclusao').AsDateTime;

  Result := lTarefa;
end;

function TTarefaAPI.GetById(const pIDTarefa: Integer): TTarefa;
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
        ' SELECT t.ID, t.Titulo, t.Descricao, t.StatusID, t.Prioridade, t.DataCriacao, ' + sLineBreak +
        '   t.DataConclusao, s.Descricao as StatusDescricao ' + sLineBreak +
        ' FROM Tarefas t ' + sLineBreak +
        ' LEFT JOIN StatusTarefas s on s.ID = t.StatusID ' + sLineBreak +
        ' WHERE t.ID = :ID';

      lQry.ParamByName('ID').AsInteger := pIDTarefa;
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
        ' INSERT INTO Tarefas (Titulo, Descricao, StatusID, Prioridade, DataCriacao) ' + sLineBreak +
        ' VALUES (:Titulo, :Descricao, :StatusID, :Prioridade, :DataCriacao)';

      lQry.ParamByName('Titulo').AsString := pTarefa.Titulo;
      lQry.ParamByName('Descricao').AsString := pTarefa.Descricao;

      // StatusID = 1 "Pendente", uma tarefa nova sempre começará com status "Pendente"
      lQry.ParamByName('StatusID').AsInteger := 1;
      lQry.ParamByName('Prioridade').AsInteger := pTarefa.Prioridade;
      lQry.ParamByName('DataCriacao').AsDateTime := pTarefa.DataCriacao;

      lQry.ExecSQL;
    finally
      lQry.Free;
    end;
  finally
    lConexao.Free;
  end;
end;

procedure TTarefaAPI.Update(pTarefa: TTarefa);
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
        ' UPDATE Tarefas ' + sLineBreak +
        ' SET Titulo        = :Titulo, ' + sLineBreak +
        '     Descricao     = :Descricao, ' + sLineBreak +
        '     Prioridade    = :Prioridade, ' + sLineBreak +
        '     StatusID      = :StatusID, ' + sLineBreak +
        '     DataCriacao   = :DataCriacao, ' + sLineBreak +
        '     DataConclusao = :DataConclusao ' + sLineBreak +
        ' WHERE ID = :ID';

      lQry.ParamByName('Titulo').AsString := pTarefa.Titulo;
      lQry.ParamByName('Descricao').AsString := pTarefa.Descricao;
      lQry.ParamByName('Prioridade').AsInteger := pTarefa.Prioridade;
      lQry.ParamByName('StatusID').AsInteger := pTarefa.StatusID;
      lQry.ParamByName('DataCriacao').AsDateTime := pTarefa.DataCriacao;

      if pTarefa.DataConclusao <> 0 then
      begin
        lQry.ParamByName('DataConclusao').AsDateTime := pTarefa.DataConclusao;
      end
      else
      begin
        lQry.ParamByName('DataConclusao').DataType := ftDateTime;
        lQry.ParamByName('DataConclusao').Clear;
      end;

      lQry.ParamByName('ID').AsInteger := pTarefa.Id;

      lQry.ExecSQL;
    finally
      lQry.Free;
    end;
  finally
    lConexao.Free;
  end;
end;

procedure TTarefaAPI.Delete(const pIDTarefa: Integer);
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
      lQry.ParamByName('ID').AsInteger := pIDTarefa;
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

      if not lQry.IsEmpty then
      begin
        Result.TotalTarefas := lQry.FieldByName('TotalTarefas').AsInteger;
        Result.MediaPrioridadePendentes := lQry.FieldByName('MediaPrioridadePendentes').AsInteger;
        Result.ConcluidasUltimos7Dias := lQry.FieldByName('ConcluidasUltimos7Dias').AsInteger;
      end;
    finally
      lQry.Free;
    end;
  finally
    lConexao.Free;
  end;
end;

end.
