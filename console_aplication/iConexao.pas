unit iConexao;

interface

uses
  FireDAC.Comp.Client;

type
  IConexaoFactory = interface
    ['{0F8A865E-1160-464B-A2B3-7916E3152999}']

    function GetConexao: TFDConnection;
  end;

implementation

end.

