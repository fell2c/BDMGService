unit uTarefaSerializer;

interface

uses uModeloTarefa;

type
  TTarefaSerializer = class
  public
    class function Serializar(pTarefa: TTarefa): string;
  end;

implementation

uses
  System.JSON,
  System.SysUtils;

class function TTarefaSerializer.Serializar(pTarefa: TTarefa): string;
var
  lObj: TJSONObject;
begin
  lObj := TJSONObject.Create;
  try
    lObj.AddPair('id', TJSONNumber.Create(pTarefa.Id));
    lObj.AddPair('titulo', pTarefa.Titulo);
    lObj.AddPair('descricao', pTarefa.Descricao);
    lObj.AddPair('prioridade', TJSONNumber.Create(pTarefa.Prioridade));
    lObj.AddPair('statusID', TJSONNumber.Create(pTarefa.StatusID));
    lObj.AddPair('dataCriacao', FormatDateTime('dd/mm/yyyy', pTarefa.DataCriacao));

    if pTarefa.DataConclusao = 0 then
      lObj.AddPair('dataConclusao', TJSONNull.Create)
    else
      lObj.AddPair('dataConclusao', FormatDateTime('dd/mm/yyyy', pTarefa.DataConclusao));

    Result := lObj.ToString;
  finally
    lObj.Free;
  end;
end;

end.
