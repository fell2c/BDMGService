unit uConexao;

interface

uses
  FireDAC.DApt,
  FireDAC.Stan.Async,
  FireDAC.Comp.Client,
  FireDAC.Phys.MSAcc,
  FireDAC.Phys.MSSQL,
  FireDAC.Phys.MSSQLDef,
  iConexao,
  uConfig;

type
  TSQLServerConnectionFactory = class(TInterfacedObject, IConexaoFactory)
  private
    FConexao: TConfigBanco;
  public
    constructor Create(const pConexao: TConfigBanco);

    function GetConexao: TFDConnection;
  end;

implementation

uses
  SysUtils;

constructor TSQLServerConnectionFactory.Create(const pConexao: TConfigBanco);
begin
  FConexao := pConexao;
end;

function TSQLServerConnectionFactory.GetConexao: TFDConnection;
var
  lMSSQLDriver: TFDPhysMSSQLDriverLink;
begin
  lMSSQLDriver := TFDPhysMSSQLDriverLink.Create(nil);
  try
    Result := TFDConnection.Create(nil);
    try
      Result.LoginPrompt := False;
      Result.DriverName := 'MSSQL';

      Result.Params.Values['Database'] := FConexao.Database;
      Result.Params.Values['Server'] := FConexao.Server;
      Result.Params.Values['Porta'] := FConexao.Porta;
      Result.Params.Values['Encrypt'] := 'No';
      Result.Params.Values['TrustServerCertificate'] := 'Yes';

      if FConexao.Autenticacao = 'Windows' then
      begin
        Result.Params.Values['OSAuthent'] := 'Yes';
        Result.Params.Values['Usuario'] := '';
        Result.Params.Values['Senha'] := '';
      end
      else
      begin
        Result.Params.Values['OSAuthent'] := 'No';
        Result.Params.Values['Usuario'] := FConexao.Usuario;
        Result.Params.Values['Senha'] := FConexao.Senha;
      end;

      lMSSQLDriver.Name := 'MSSQLDriverLink';
      Result.Params.Values['DriverLink'] := lMSSQLDriver.Name;

      Result.Open;
    except
      on E: Exception do
      begin
        Result.Free;
        raise Exception.CreateFmt('Erro ao conectar ao banco: %s', [E.Message]);
      end;
    end;
  finally
    lMSSQLDriver.Free;
  end;
end;

end.
