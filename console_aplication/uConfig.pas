unit uConfig;

interface

type

  TConfigBanco = record
    Server: string;
    Porta: string;
    Database: string;
    Autenticacao: string;
    Usuario: string;
    Senha: string;
  end;

  TConfig = class
  private
    class function GetCaminhoArquivo: string;
  public
    class function APIKey: string;
    class function PreencherDadosBanco: TConfigBanco;
  end;

implementation

uses
  IniFiles, SysUtils;

class function TConfig.GetCaminhoArquivo: string;
begin
  // Busca o config.ini na mesma pasta do executável
  Result := ExtractFilePath(ParamStr(0)) + 'config.ini';
end;

class function TConfig.APIKey: string;
var
  lIni: TIniFile;
begin
  lIni := TIniFile.Create(GetCaminhoArquivo);
  try
    Result := lIni.ReadString('Seguranca', 'ApiKey', '');
  finally
    lIni.Free;
  end;
end;

class function TConfig.PreencherDadosBanco: TConfigBanco;
var
  lIni: TIniFile;
begin
  lIni := TIniFile.Create(GetCaminhoArquivo);
  try
    Result.Server := lIni.ReadString('Banco', 'Server', 'localhost');
    Result.Porta := lIni.ReadString('Banco', 'Porta', '1433');
    Result.Database := lIni.ReadString('Banco', 'Database', 'BDMG');
    Result.Autenticacao := lIni.ReadString('Banco', 'Autenticacao', 'Windows');
    Result.Usuario := lIni.ReadString('Banco', 'Usuario', '');
    Result.Senha := lIni.ReadString('Banco', 'Senha', '');
  finally
    lIni.Free;
  end;
end;

end.
