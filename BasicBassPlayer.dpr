program BasicBassPlayer;

{$R *.dres}

uses
  Vcl.Forms,
  API.BassResMgr in 'API\API.BassResMgr.pas',
  API.bass in 'API\API.bass.pas',
  API.SoundLib in 'API\API.SoundLib.pas',
  Main.View in 'Main.View.pas' {MainView};

{$R *.res}

var
  MainView: TMainView;
begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainView, MainView);
  Application.Run;
end.
