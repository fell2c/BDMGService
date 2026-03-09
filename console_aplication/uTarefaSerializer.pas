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
    lObj.AddPair('id', pTarefa.Id.ToString);
    lObj.AddPair('titulo', pTarefa.Titulo);
    lObj.AddPair('descricao', pTarefa.Descricao);
    lObj.AddPair('prioridade', pTarefa.Prioridade.ToString);
    lObj.AddPair('statusID', pTarefa.StatusID.ToString);
    lObj.AddPair('statusDescricao', pTarefa.StatusDescricao);
    lObj.AddPair('dataCriacao', FormatDateTime('dd/mm/yyyy', pTarefa.DataCriacao));

    if pTarefa.DataConclusao > 0 then
      lObj.AddPair('dataConclusao', FormatDateTime('dd/mm/yyyy', pTarefa.DataConclusao));

    Result := lObj.ToString;
  finally
    lObj.Free;
  end;
end;

end.
