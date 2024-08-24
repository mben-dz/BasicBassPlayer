program BasicBassPlayer;

{$R *.dres}

uses
  Vcl.Forms,
  API.BassResMgr in 'API\API.BassResMgr.pas',
  API.bass in 'API\API.bass.pas',
  API.SoundLib in 'API\API.SoundLib.pas',
  Main.View in 'Main.View.pas' {MainView},
  API.Logger in 'API\Timer\API.Logger.pas',
  API.ThreadTimer in 'API\Timer\API.ThreadTimer.pas',
  API.Controls.Hack in 'API\Timer\API.Controls.Hack.pas';

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
