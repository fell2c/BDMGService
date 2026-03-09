unit uFactoryInterfaces;

interface

uses
  iConexao,
  iTarefaApi,
  uConfig;

type
  TFactoryInterfaces = class
  public
    class function CriarConexao: IConexaoFactory;
    class function CriarTarefaAPI: IAPITarefa;
  end;

implementation

uses
  uConexao,
  uTarefaAPI;

class function TFactoryInterfaces.CriarConexao: IConexaoFactory;
begin
  Result := TSQLServerConnectionFactory.Create(TConfig.PreencherDadosBanco);
end;

class function TFactoryInterfaces.CriarTarefaAPI: IAPITarefa;
begin
  Result := TTarefaAPI.Create(CriarConexao);
end;

end.
