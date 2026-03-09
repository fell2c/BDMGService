unit uValidacoes;

interface

uses
  uModeloTarefa;

type
  TValidacoes = class
  public
    class procedure ValidarTarefa(pTarefa: TTarefa);
  end;

implementation

uses
  SysUtils;

class procedure TValidacoes.ValidarTarefa(pTarefa: TTarefa);
begin
  if Trim(pTarefa.Titulo) = '' then
    raise Exception.Create('Título é obrigatório.');

  if Length(Trim(pTarefa.Titulo)) > 100 then
    raise Exception.Create('Título excede o limite de 100 caracteres.');

  if Length(Trim(pTarefa.Descricao)) > 200 then
    raise Exception.Create('Descrição excede o limite de 200 caracteres.');

  if pTarefa.DataCriacao = 0 then
    raise Exception.Create('Obrigatório informar Data de Criação.');

  if (pTarefa.StatusID = 3) and (pTarefa.DataConclusao = 0) then
    raise Exception.Create('Obrigatório informar Data de Conclusão.');

end;

end.
