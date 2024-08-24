unit Main.View;

interface

uses

{$REGION '  Import: Winapi''s .. '}
  Winapi.Windows
, Winapi.Messages
{$ENDREGION}
{$REGION '  Import: System''s .. '}
, System.SysUtils
, System.Variants
, System.Classes
{$ENDREGION}
{$REGION '  Import: Vcl''s .. '}
,  Vcl.Graphics
,  Vcl.Controls
,  Vcl.Forms
,  Vcl.Dialogs
{$ENDREGION}

, API.SoundLib, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls
;

type
  TSoundWave = (sIntro, sBG, sClicked);

  TMainView = class(TForm)
    Btn_Click: TButton;
    GrpBox_BGSound: TGroupBox;
    Btn_Switch_PlayStop: TSpeedButton;
    Btn_Switch_PlayPause: TSpeedButton;
    Pnl_Status: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Btn_ClickClick(Sender: TObject);
    procedure Btn_Switch_PlayPauseClick(Sender: TObject);
    procedure Btn_Switch_PlayStopClick(Sender: TObject);
  private
    fSoundIntro,
    fSoundBG,
    fSoundClick: TResSoundPlayer;
    procedure PlaySound(const aSound: TSoundWave); inline;
    procedure PauseSound(const aSound: TSoundWave); inline;
    procedure StopSound(const aSound: TSoundWave); inline;
    { Get Sounds Getter }
  {$REGION '  [Sounds Getters] .. '}
    function GetIntroSound: TResSoundPlayer;
    function GetBGSound: TResSoundPlayer;
    function GetClickedSound: TResSoundPlayer;
  {$ENDREGION}
  public
    { Public declarations }
    property SoundIntro:   TResSoundPlayer read GetIntroSound;
    property SoundBG:      TResSoundPlayer read GetBGSound;
    property SoundClicked: TResSoundPlayer read GetClickedSound;
  end;

//var
//  MainView: TMainView;

implementation

uses
  API.bass
;

{$R *.dfm}

{ TMainView }

{$REGION '  TSoundWave Inline Calls ... '}
procedure TMainView.PlaySound(const aSound: TSoundWave);
begin
  case aSound of
    sIntro: SoundIntro.Play;
    sBG: SoundBG.Play;
    sClicked: SoundClicked.Play;
  end;
end;

procedure TMainView.PauseSound(const aSound: TSoundWave);
begin
  case aSound of
    sIntro: SoundIntro.Pause;
    sBG: SoundBG.Pause;
    sClicked: SoundClicked.Pause;
  end;
end;

procedure TMainView.StopSound(const aSound: TSoundWave);
begin
  case aSound of
    sIntro: SoundIntro.Stop;
    sBG: SoundBG.Stop;
    sClicked: SoundClicked.Stop;
  end;
end;
{$ENDREGION}

{$REGION '  TSoundWave Objects Getters .. '}
function TMainView.GetIntroSound: TResSoundPlayer;
begin
  if not Assigned(fSoundIntro) then
    fSoundIntro := TResSoundPlayer.Create('WAVE_INTRO');

  Result := fSoundIntro;
end;

function TMainView.GetBGSound: TResSoundPlayer;
begin
  if not Assigned(fSoundBG) then
    fSoundBG := TResSoundPlayer.Create('WAVE_BG');

  Result := fSoundBG;
end;

function TMainView.GetClickedSound: TResSoundPlayer;
begin
  if not Assigned(fSoundClick) then
    fSoundClick := TResSoundPlayer.Create('WAVE_CLICKED');

  Result := fSoundClick;
end;
{$ENDREGION}

procedure TMainView.FormShow(Sender: TObject);
begin
  PlaySound(sIntro);
  PlaySound(sBG);
end;

procedure TMainView.Btn_ClickClick(Sender: TObject);
begin
  PlaySound(sClicked);
end;

procedure TMainView.Btn_Switch_PlayPauseClick(Sender: TObject);
begin
  case Btn_Switch_PlayPause.Tag of
    0: begin
       PauseSound(sBG);
       Btn_Switch_PlayPause.Tag := 1;
       Btn_Switch_PlayPause.Caption := 'SwitchTo <<Play>>';
       Btn_Switch_PlayStop.Tag := 1;
       Btn_Switch_PlayStop.Caption := 'SwitchTo <<Play>>';
    end;
    1: begin
       PlaySound(sBG);
       Btn_Switch_PlayPause.Tag := 0;
       Btn_Switch_PlayPause.Caption := 'SwitchTo <<Pause>>';
       Btn_Switch_PlayStop.Tag := 0;
       Btn_Switch_PlayStop.Caption := 'SwitchTo <<Stop>>';
    end;
  end;
end;

procedure TMainView.Btn_Switch_PlayStopClick(Sender: TObject);
begin
  case Btn_Switch_PlayStop.Tag of
    0: begin
       StopSound(sBG);
       Btn_Switch_PlayStop.Tag := 1;
       Btn_Switch_PlayStop.Caption := 'SwitchTo <<Play>>';
       Btn_Switch_PlayPause.Tag := 1;
       Btn_Switch_PlayPause.Caption := 'SwitchTo <<Play>>';
    end;
    1: begin
       PlaySound(sBG);
       Btn_Switch_PlayStop.Tag := 0;
       Btn_Switch_PlayStop.Caption := 'SwitchTo <<Stop>>';
       Btn_Switch_PlayPause.Tag := 0;
       Btn_Switch_PlayPause.Caption := 'SwitchTo <<Pause>>';
    end;
  end;
end;

procedure TMainView.FormCreate(Sender: TObject);
begin
  fSoundIntro := nil;
  fSoundBG    := nil;
  fSoundClick := nil;
end;

procedure TMainView.FormDestroy(Sender: TObject);
begin
  fSoundIntro.Free;
  fSoundBG.Free;
  fSoundClick.Free;
end;

end.
