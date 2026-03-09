program BDMGGerenciadorTarefas;

uses
  Vcl.Forms,
  frmMenu in 'frmMenu.pas' {GerenciadorTarefas},
  frmIndicadores in 'frmIndicadores.pas' {formIndicadores},
  frmTarefa in 'frmTarefa.pas' {formTarefa};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TGerenciadorTarefas, GerenciadorTarefas);
  Application.CreateForm(TformIndicadores, formIndicadores);
  Application.CreateForm(TformTarefa, formTarefa);
  Application.Run;
end.
