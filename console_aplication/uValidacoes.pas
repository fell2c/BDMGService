unit uValidacoes;

interface

type

  TPrioridade = (Baixa, Media, Alta);
  TStatus = (Pendente, EmAndamento, Concluido);

  TValidacoes = class
  public
    // Usado no POST
//    class procedure ValidarCriacaoTarefa(const pTitulo, pDescricao: string; const pPrioridade: TPrioridade);
//    // Usado no PUT
//    class procedure ValidarAtualizacaoStatus(const pTitulo, pDescricao: string; const pStatusID: TStatus);
//    // Regras compartilhadas entre POST e PUT
    class procedure ValidarCamposTexto(const pTitulo, pDescricao: string);
  end;

implementation

uses
  SysUtils;

class procedure TValidacoes.ValidarCamposTexto(const pTitulo, pDescricao: string);
begin
  if Trim(pTitulo) = '' then
    raise Exception.Create('Título é obrigatório');

  if Length(pTitulo) > 100 then
    raise Exception.Create('Título excede o limite de 100 caracteres (%d informados)');

  if Length(pDescricao) > 200 then
    raise Exception.Create('Descrição excede o limite de 200 caracteres (%d informados)');
end;

//class procedure TValidacoes.ValidarCriacaoTarefa(const pTitulo, pDescricao: string; const pPrioridade: TPrioridade);
//begin
//  ValidarCamposTexto(pTitulo, pDescricao);
//
//  if not (pPrioridade in [Baixa, Media, Alta]) then
//    raise Exception.Create('Prioridade deve ser Baixa, Media ou Alta');
//end;
//
//class procedure TValidacoes.ValidarAtualizacaoStatus(const pTitulo, pDescricao: string; const pStatusID: TStatus);
//begin
//  ValidarCamposTexto(pTitulo, pDescricao);
//
//  if not (pStatusID in [Pendente, EmAndamento, Concluido]) then
//    raise Exception.Create('StatusId deve ser Pendente, Em Andamento ou Concluído');
//end;

end.
