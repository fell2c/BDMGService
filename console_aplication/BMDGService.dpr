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
    begin
      pRes.Status(THTTPStatus.NotFound).Send('{"erro":"Tarefa não encontrada"}');
      Exit;
    end;

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
    begin
      pRes.Status(THTTPStatus.BadRequest).Send('{"erro":"Body inválido"}');
      Exit;
    end;

    try
      lTarefa := TTarefa.Create;
      try
        lTarefa.Titulo := lJSON.GetValue<string>('titulo');
        lTarefa.Descricao := lJSON.GetValue<string>('descricao', '');
        lTarefa.Prioridade := lJSON.GetValue<Integer>('prioridade');

        lAPI.Add(lTarefa);

        TValidacoes.ValidarCamposTexto(lTarefa.Titulo, lTarefa.Descricao);
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
    lID, lStatusID: Integer;
  begin
    lID := StrToIntDef(pReq.Params['id'], 0);

    if lID = 0 then
    begin
      pRes.Status(THTTPStatus.BadRequest).Send('{"erro":"ID inválido"}');
      Exit;
    end;

    lJSON := TJSONObject.ParseJSONValue(pReq.Body) as TJSONObject;

    if not Assigned(lJSON) then
    begin
      pRes.Status(THTTPStatus.BadRequest).Send('{"erro":"Body inválido"}');
      Exit;
    end;

    TValidacoes.ValidarCamposTexto(lJSON.GetValue<string>('titulo'), lJSON.GetValue<string>('descricao'));

    try
      lStatusID := lJSON.GetValue<Integer>('statusId');

      if not (lStatusID in [1, 2, 3]) then
      begin
        pRes.Status(THTTPStatus.BadRequest).Send('{"erro":"StatusId deve ser 1, 2 ou 3"}');
        Exit;
      end;

      lAPI.UpdateStatus(lID, lStatusID);

      pRes.Status(THTTPStatus.Ok).Send('{"mensagem":"Status atualizado"}');
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
    begin
      pRes.Status(THTTPStatus.BadRequest).Send('{"erro":"ID inválido"}');
      Exit;
    end;

    lAPI.Delete(lID);

    pRes.Status(THTTPStatus.Ok).Send('{"mensagem":"Tarefa removida"}');
  end);

  THorse.Listen(9000,
    procedure
    begin
      Writeln('Servidor rodando em http://localhost:9000');
    end
  );
end.
