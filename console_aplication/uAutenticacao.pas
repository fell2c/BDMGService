unit uAutenticacao;

interface

uses
  Horse,
  uConfig;

procedure MiddlewareAPIKey(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);

implementation

procedure MiddlewareAPIKey(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
begin
  if Req.Headers['X-API-KEY'] <> TConfig.APIKey then
  begin
    Res.Status(THTTPStatus.Unauthorized).Send('{"erro":"Não autorizado"}');
    Exit;
  end;

  Next;
end;

end.
