unit uAutenticacao;

interface

uses
  System.SysUtils,
  Horse,
  uConfig;

procedure MiddlewareAPIKey(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);

implementation

procedure MiddlewareAPIKey(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  lApiKey: string;
begin
  lApiKey := Req.Headers['X-API-KEY'];

  if (lApiKey = string.Empty) or (lApiKey <> TConfig.APIKey) then
    raise EHorseException.New.Status(THTTPStatus.Unauthorized).Error('API Key inválida ou não informada');

  Next;
end;

end.
