unit frmTarefa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask;

type
  TformTarefa = class(TForm)
    edtID: TEdit;
    edtTitulo: TEdit;
    cbbStatus: TComboBox;
    cbbPrioridade: TComboBox;
    lblID: TLabel;
    lblTitulo: TLabel;
    lblDescricao: TLabel;
    lblStatus: TLabel;
    lblPrioridade: TLabel;
    lblDataCriacao: TLabel;
    lblDataConclusao: TLabel;
    btnCancelar: TButton;
    btnConfirmar: TButton;
    edtDataCriacao: TMaskEdit;
    edtDataConclusao: TMaskEdit;
    memDescricao: TMemo;
    procedure btnCancelarClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    FTarefaID: Integer;

    procedure CarregarTarefa;
    function GetDataPreenchida(pMaskedEdit: TMaskEdit): Boolean;
  public
    property TarefaID: Integer read FTarefaID write FTarefaID;
  end;

var
  formTarefa: TformTarefa;

implementation

uses
  System.JSON,
  RESTRequest4D,
  uModeloTarefa,
  uConfig,
  uTarefaSerializer;

{$R *.dfm}

procedure TformTarefa.btnConfirmarClick(Sender: TObject);
var
  lBody: TJSONObject;
  lResponse: IResponse;
  lTarefa: TTarefa;
begin
  lBody := TJSONObject.Create;
  try
    lTarefa := TTarefa.Create;

    lTarefa.Titulo := Trim(edtTitulo.Text);
    lTarefa.Descricao := Trim(memDescricao.Text);
    lTarefa.StatusID := cbbStatus.ItemIndex + 1;
    lTarefa.Prioridade := cbbPrioridade.ItemIndex + 1;

    if GetDataPreenchida(edtDataCriacao) then
      lTarefa.DataCriacao := StrToDate(edtDataCriacao.EditText);

    if GetDataPreenchida(edtDataConclusao) then
      lTarefa.DataConclusao := StrToDate(edtDataConclusao.EditText);

    if TarefaID > 0 then
    begin
       lResponse := TRequest.New
        .BaseURL('http://localhost:9000/tarefas/' + FTarefaID.ToString)
        .AddHeader('X-API-KEY', TConfig.ApiKey)
        .ContentType('application/json')
        .AddBody(TTarefaSerializer.Serializar(lTarefa))
        .Put;
    end
    else
    begin
      lResponse := TRequest.New
        .BaseURL('http://localhost:9000/tarefas')
        .AddHeader('X-API-KEY', TConfig.ApiKey)
        .ContentType('application/json')
        .AddBody(TTarefaSerializer.Serializar(lTarefa))
        .Post;
    end;

    if lResponse.StatusCode in [200, 201] then
    begin
      ShowMessage('Tarefa salva com sucesso!');
      ModalResult := mrOk;
    end
    else
    begin
      ShowMessage('Erro: ' + lResponse.Content);
    end;
  finally
    lBody.Free;
  end;
end;

procedure TformTarefa.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TformTarefa.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TformTarefa.FormShow(Sender: TObject);
begin
  edtDataConclusao.ReadOnly := FTarefaID = 0;
  cbbStatus.Enabled := FTarefaID > 0;

  if FTarefaID > 0 then
  begin
    CarregarTarefa;

    Self.Caption := 'Atualizar Tarefa';
  end
  else
  begin
    edtDataCriacao.Text := DateToStr(Now);
  end;
end;

function TformTarefa.GetDataPreenchida(pMaskedEdit: TMaskEdit): Boolean;
var
  lSomenteNumeros: string;
begin
  lSomenteNumeros := pMaskedEdit.EditText.Replace('/', '').Replace('_', '').Trim;
  Result := not lSomenteNumeros.IsEmpty;
end;

procedure TformTarefa.CarregarTarefa;
var
  lResponse: IResponse;
  lJSON: TJSONObject;
  lDataConclusao: TJSONValue;
begin
  lResponse := TRequest.New
    .BaseURL('http://localhost:9000/tarefas/' + FTarefaId.ToString)
    .AddHeader('X-API-KEY', TConfig.ApiKey)
    .Get;

  if lResponse.StatusCode = 200 then
  begin
    lJSON := TJSONObject.ParseJSONValue(lResponse.Content) as TJSONObject;
    try
      edtID.Text := lJSON.GetValue<Integer>('id').ToString;
      edtTitulo.Text := lJSON.GetValue<string>('titulo');
      memDescricao.Lines.Text := lJSON.GetValue<string>('descricao');
      cbbStatus.ItemIndex := lJSON.GetValue<Integer>('statusID') - 1;
      cbbPrioridade.ItemIndex := lJSON.GetValue<Integer>('prioridade') - 1;
      edtDataCriacao.Text :=  lJSON.GetValue<string>('dataCriacao');

      lDataConclusao := lJSON.GetValue('dataConclusao');

      if Assigned(lDataConclusao) then
        edtDataConclusao.Text := lJSON.GetValue<string>('dataConclusao');
    finally
      lJSON.Free;
    end;
  end;
end;

end.
