program BasicBassPlayer;

{$R *.dres}

uses
  Vcl.Forms,
  API.BassResMgr in 'API\API.BassResMgr.pas',
  API.bass in 'API\API.bass.pas',
  API.SoundLib in 'API\API.SoundLib.pas',
  API.RippleEffects in 'API\Ripple\API.RippleEffects.pas',
  API.RippleHeader in 'API\Ripple\API.RippleHeader.pas',
  Main.View in 'Main.View.pas' {MainView},
  Lyt.Ripple in 'VIEW\Layouts\Main\Lyt.Ripple.pas' {LytRipple},
  Layout.Dimmer in 'VIEW\Layouts\Dimmer\Layout.Dimmer.pas' {LytDimmer};

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
