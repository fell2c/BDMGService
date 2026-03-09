unit frmIndicadores;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TformIndicadores = class(TForm)
    pnlIndicadores: TPanel;
    lblTotalTarefas: TLabel;
    lblMediaTarefas: TLabel;
    lblConcluidas7d: TLabel;
    lblValorTotalTarefas: TLabel;
    lblValorMediaPrioridade: TLabel;
    lblValorTarefasConcluidas7d: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    procedure PreencherIndicadores(const pTotal, pMedia, pConcluidas: Integer);
  end;

var
  formIndicadores: TformIndicadores;

implementation

{$R *.dfm}

procedure TformIndicadores.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TformIndicadores.PreencherIndicadores(const pTotal, pMedia, pConcluidas: Integer);
begin
  lblValorTotalTarefas.Caption := pTotal.ToString;
  lblValorMediaPrioridade.Caption := pMedia.ToString;
  lblValorTarefasConcluidas7d.Caption := pConcluidas.ToString;
end;

end.
