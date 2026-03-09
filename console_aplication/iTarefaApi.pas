unit iTarefaAPI;

interface

uses
  System.Generics.Collections,
  uModeloTarefa;

type
  IAPITarefa = interface
    ['{F517A5E7-958C-4658-805D-197EAC15E724}']

    function GetAll: TObjectList<TTarefa>;
    function GetById(const pID: Integer): TTarefa;
    function GetIndicadoresTarefas: TIndicadoresTarefas;
    procedure Add(pTarefa: TTarefa);
    procedure Update(pTarefa: TTarefa);
    procedure Delete(const pIDTarefa: Integer);
  end;

implementation

end.
