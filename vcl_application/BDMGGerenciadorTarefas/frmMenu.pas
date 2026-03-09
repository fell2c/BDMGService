unit frmMenu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, System.JSON, uModeloTarefa;

type
  TGerenciadorTarefas = class(TForm)
    btnIncluirTarefa: TButton;
    btnAtualizarTarefa: TButton;
    btnRemoverTarefa: TButton;
    btnIndicadoresTarefas: TButton;
    lvTarefas: TListView;
    procedure FormCreate(Sender: TObject);
    procedure btnRemoverTarefaClick(Sender: TObject);
    procedure btnIncluirTarefaClick(Sender: TObject);
    procedure btnAtualizarTarefaClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnIndicadoresTarefasClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FIndicadores: TIndicadoresTarefas;

    procedure CarregarTarefas;
    procedure PreencherListaTarefas(pJSON: TJSONArray);
    function GetIDTarefaSelecionada: Integer;
    procedure AbrirFormularioTarefa(const pIDTarefa: Integer = 0);
    procedure CarregarIndicadores;
    procedure AtualizarTelaComDadosAPI;
  public
    { Public declarations }
  end;

var
  GerenciadorTarefas: TGerenciadorTarefas;

implementation

uses
  System.Generics.Collections,
  System.UITypes,
  RESTRequest4D,
  uConfig,
  frmTarefa,
  frmIndicadores;

{$R *.dfm}

procedure TGerenciadorTarefas.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TGerenciadorTarefas.FormDestroy(Sender: TObject);
begin
  FIndicadores.Free;
end;

procedure TGerenciadorTarefas.FormCreate(Sender: TObject);
begin
  AtualizarTelaComDadosAPI;
end;

procedure TGerenciadorTarefas.AtualizarTelaComDadosAPI;
begin
  CarregarTarefas;
  CarregarIndicadores;
end;

procedure TGerenciadorTarefas.CarregarTarefas;
var
  lResponse: IResponse;
  lJSON: TJSONArray;
begin
  lResponse := TRequest.New
    .BaseURL('http://localhost:9000/tarefas')
    .AddHeader('X-API-KEY', TConfig.ApiKey)
    .Get;

  if lResponse.StatusCode = 200 then
  begin
    lJSON := TJSONObject.ParseJSONValue(lResponse.Content) as TJSONArray;
    try
      PreencherListaTarefas(lJSON);
    finally
      lJSON.Free;
    end;
  end
  else
    ShowMessage('Erro ao carregar tarefas: ' + lResponse.Content);
end;

procedure TGerenciadorTarefas.PreencherListaTarefas(pJSON: TJSONArray);
var
  lItem: TListItem;
  lObj: TJSONObject;
  lPrioridade: string;
  li: Integer;
begin
  lvTarefas.Items.BeginUpdate;
  try
    lvTarefas.Items.Clear;

    for li := 0 to pJSON.Count - 1 do
    begin
      lObj := pJSON.Items[li] as TJSONObject;

      case lObj.GetValue<Integer>('prioridade') of
        1: lPrioridade := 'Baixa';
        2: lPrioridade := 'Média';
        3: lPrioridade := 'Alta';
      end;

      lItem := lvTarefas.Items.Add;
      lItem.Caption := lObj.GetValue<string>('id');
      lItem.SubItems.Add(lObj.GetValue<string>('titulo'));
      lItem.SubItems.Add(lObj.GetValue<string>('descricao'));
      lItem.SubItems.Add(lObj.GetValue<string>('statusDescricao'));
      lItem.SubItems.Add(lPrioridade);
      lItem.SubItems.Add(lObj.GetValue<string>('dataCriacao'));

      if (lObj.FindValue('dataConclusao') <> nil) then
        lItem.SubItems.Add(lObj.GetValue<string>('dataConclusao'));
    end;
  finally
    lvTarefas.Items.EndUpdate;
  end;
end;

procedure TGerenciadorTarefas.CarregarIndicadores;
var
  lResponse: IResponse;
  lJSON: TJSONObject;
begin
  lResponse := TRequest.New
    .BaseURL('http://localhost:9000/tarefas/indicadores')
    .AddHeader('X-API-KEY', TConfig.ApiKey)
    .Get;

  lJSON := TJSONObject.ParseJSONValue(lResponse.Content) as TJSONObject;
  try
    FIndicadores := TIndicadoresTarefas.Create;

    FIndicadores.TotalTarefas := lJSON.GetValue<Integer>('TotalTarefas');
    FIndicadores.MediaPrioridadePendentes := lJSON.GetValue<Integer>('MediaPrioridadePendentes');
    FIndicadores.ConcluidasUltimos7Dias := lJSON.GetValue<Integer>('ConcluidasUltimos7Dias');
  finally
    lJSON.Free;
  end;
end;

procedure TGerenciadorTarefas.btnAtualizarTarefaClick(Sender: TObject);
begin
  if Assigned(lvTarefas.Selected) then
  begin
    AbrirFormularioTarefa(GetIDTarefaSelecionada);
    AtualizarTelaComDadosAPI;
  end
  else
  begin
    raise Exception.Create('Selecione uma tarefa!');
  end;
end;

procedure TGerenciadorTarefas.btnIncluirTarefaClick(Sender: TObject);
begin
  AbrirFormularioTarefa;
  AtualizarTelaComDadosAPI;
end;

function TGerenciadorTarefas.GetIDTarefaSelecionada: Integer;
begin
  Result := 0;

  if Assigned(lvTarefas.Selected) then
    Result := StrToIntDef(lvTarefas.Selected.Caption, 0);
end;

procedure TGerenciadorTarefas.AbrirFormularioTarefa(const pIDTarefa: Integer);
var
  lForm: TformTarefa;
begin
  lForm := TformTarefa.Create(nil);
  try
    lForm.TarefaID := pIDTarefa;

    if lForm.ShowModal = mrOk then
      AtualizarTelaComDadosAPI;
  finally
    lForm.Free;
  end;
end;

procedure TGerenciadorTarefas.btnIndicadoresTarefasClick(Sender: TObject);
var
  lForm: TformIndicadores;
begin
  lForm := TFormIndicadores.Create(Self);
  try
    lForm.PreencherIndicadores(
      FIndicadores.TotalTarefas,
      FIndicadores.MediaPrioridadePendentes,
      FIndicadores.ConcluidasUltimos7Dias
    );

    lForm.ShowModal;
  finally
    lForm.Free;
  end;
end;

procedure TGerenciadorTarefas.btnRemoverTarefaClick(Sender: TObject);
var
  lID: Integer;
  lResponse: IResponse;
begin
  lID := GetIDTarefaSelecionada;

  if lID = 0 then
    raise Exception.Create('Selecione uma tarefa!');

  if MessageDlg('Confirma remoção?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  lResponse := TRequest.New
    .BaseURL('http://localhost:9000/tarefas/' + IntToStr(lID))
    .AddHeader('X-API-KEY', TConfig.ApiKey)
    .Delete;

  if lResponse.StatusCode = 200 then
    AtualizarTelaComDadosAPI
  else
    ShowMessage('Erro ao remover: ' + lResponse.Content);
end;

end.
