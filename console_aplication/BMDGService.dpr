program BMDGService;

uses
  System.Generics.Collections,
  System.JSON,
  System.SysUtils,
  Horse,
  uAutenticacao in 'uAutenticacao.pas',
  uFactoryInterfaces in 'uFactoryInterfaces.pas',
  iTarefaApi in 'iTarefaApi.pas',
  uModeloTarefa in 'uModeloTarefa.pas',
  uConfig in 'uConfig.pas',
  iConexao in 'iConexao.pas',
  uConexao in 'uConexao.pas',
  uTarefaAPI in 'uTarefaAPI.pas',
  uTarefaSerializer in 'uTarefaSerializer.pas',
  uValidacoes in 'uValidacoes.pas';

var
  lAPI: IAPITarefa;

begin
  lAPI := TFactoryInterfaces.CriarTarefaAPI;

  THorse.Use(MiddlewareApiKey);

  THorse.Get('/tarefas/indicadores', procedure(pReq: THorseRequest; pRes: THorseResponse)
  var
    lIndicadores: TIndicadoresTarefas;
    lJSONObject: TJSONObject;
  begin
    lIndicadores := lAPI.GetIndicadoresTarefas;
    try
      lJSONObject := TJSONObject.Create;
      try
        lJSONObject.AddPair('TotalTarefas', TJSONNumber.Create(lIndicadores.TotalTarefas));
        lJSONObject.AddPair('MediaPrioridadePendentes', TJSONNumber.Create(lIndicadores.MediaPrioridadePendentes));
        lJSONObject.AddPair('ConcluidasUltimos7Dias', TJSONNumber.Create(lIndicadores.ConcluidasUltimos7Dias));

        pRes.Send(lJSONObject.ToString);
      finally
        lJSONObject.Free;
      end;
    finally
      lIndicadores.Free;
    end;
  end);

  THorse.Get('/tarefas/:id', procedure(pReq: THorseRequest; pRes: THorseResponse)
  var
    lTarefa: TTarefa;
  begin
    lTarefa := lAPI.GetById(StrToIntDef(pReq.Params['id'], 0));

    if not Assigned(lTarefa) then
      raise EHorseException.New.Status(THTTPStatus.BadRequest).Error('Tarefa não encontrada');

    try
      pRes.Send(TTarefaSerializer.Serializar(lTarefa));
    finally
      lTarefa.Free;
    end;
  end);

  THorse.Get('/tarefas', procedure(pReq: THorseRequest; pRes: THorseResponse)
  var
    lTarefas: TObjectList<TTarefa>;
    lJSONArray: TJSONArray;
    lTarefa: TTarefa;
  begin
    lTarefas := lAPI.GetAll;
    try
      lJSONArray := TJSONArray.Create;
      try
        for lTarefa in lTarefas do
          lJSONArray.AddElement(TJSONObject.ParseJSONValue(TTarefaSerializer.Serializar(lTarefa)));

        pRes.Send(lJSONArray.ToString);
      finally
        lJSONArray.Free;
      end;
    finally
      lTarefas.Free;
    end;
  end);

  THorse.Post('/tarefas', procedure(pReq: THorseRequest; pRes: THorseResponse)
  var
    lJSON: TJSONObject;
    lTarefa: TTarefa;
  begin
    lJSON := TJSONObject.ParseJSONValue(pReq.Body) as TJSONObject;

    if not Assigned(lJSON) then
      raise EHorseException.New.Status(THTTPStatus.BadRequest).Error('Body inválido');

    try
      lTarefa := TTarefa.Create;
      try
        lTarefa.Titulo := lJSON.GetValue<string>('titulo');
        lTarefa.Descricao := lJSON.GetValue<string>('descricao', '');
        lTarefa.StatusId := lJSON.GetValue<Integer>('statusID');
        lTarefa.Prioridade := lJSON.GetValue<Integer>('prioridade');
        lTarefa.DataCriacao := StrToDate(lJSON.GetValue<string>('dataCriacao'));

        if lJSON.FindValue('dataConclusao') <> nil then
          lTarefa.DataConclusao := StrToDate(lJSON.GetValue<string>('dataConclusao'));

        TValidacoes.ValidarTarefa(lTarefa);
        lAPI.Add(lTarefa);

        pRes.Status(THTTPStatus.Created).Send('{"mensagem":"Tarefa criada com sucesso"}');
      finally
        lTarefa.Free;
      end;
    finally
      lJSON.Free;
    end;
  end);

  THorse.Put('/tarefas/:id', procedure(pReq: THorseRequest; pRes: THorseResponse)
  var
    lJSON: TJSONObject;
    lID: Integer;
    lTarefa: TTarefa;
  begin
    lID := StrToIntDef(pReq.Params['id'], 0);

    if lID = 0 then
      raise EHorseException.New.Status(THTTPStatus.BadRequest).Error('ID inválido');

    lJSON := TJSONObject.ParseJSONValue(pReq.Body) as TJSONObject;

    if not Assigned(lJSON) then
      raise EHorseException.New.Status(THTTPStatus.BadRequest).Error('Body inválido');

    try
      lTarefa := TTarefa.Create;
      try
        lTarefa.ID := lID;
        lTarefa.Titulo := lJSON.GetValue<string>('titulo');
        lTarefa.Descricao := lJSON.GetValue<string>('descricao');
        lTarefa.StatusId := lJSON.GetValue<Integer>('statusID');
        lTarefa.Prioridade := lJSON.GetValue<Integer>('prioridade');
        lTarefa.DataCriacao := StrToDate(lJSON.GetValue<string>('dataCriacao'));

        if Assigned(lJSON.FindValue('dataConclusao')) then
          lTarefa.DataConclusao := StrToDate(lJSON.GetValue<string>('dataConclusao'));

        TValidacoes.ValidarTarefa(lTarefa);
        lAPI.Update(lTarefa);

        pRes.Status(THTTPStatus.Ok).Send('{"mensagem":"Tarefa atualizada com sucesso"}');
      finally
        lTarefa.Free;
      end;
    finally
      lJSON.Free;
    end;
  end);

  THorse.Delete('/tarefas/:id', procedure(pReq: THorseRequest; pRes: THorseResponse)
  var
    lID: Integer;
  begin
    lID := StrToIntDef(pReq.Params['id'], 0);

    if lID = 0 then
      raise EHorseException.New.Status(THTTPStatus.BadRequest).Error('ID inválido');

    lAPI.Delete(lID);

    pRes.Status(THTTPStatus.Ok).Send('{"mensagem":"Tarefa removida com sucesso"}');
  end);

  THorse.Listen(9000,
    procedure
    begin
      Writeln('Servidor rodando em http://localhost:9000');
    end
  );
end.
