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
, Vcl.Graphics
, Vcl.Controls
, Vcl.Forms
, Vcl.Dialogs
, Vcl.StdCtrls
, Vcl.Buttons
, Vcl.ExtCtrls
, Vcl.Imaging.jpeg
{$ENDREGION}

, API.SoundLib
, API.ThreadTimer
;

type
  TSoundWave = (sIntro, sBG, sClicked);

  TMainView = class(TForm)
    Btn_Click: TButton;
    Btn_Switch_PlayStop: TSpeedButton;
    Btn_Switch_PlayPause: TSpeedButton;
    Pnl_Status: TPanel;
    Img_Movie: TImage;
    Pnl_Tool: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Btn_ClickClick(Sender: TObject);
    procedure Btn_Switch_PlayPauseClick(Sender: TObject);
    procedure Btn_Switch_PlayStopClick(Sender: TObject);
  private
    fTimer: I_TimerThread;
    fSoundIntro,
    fSoundBG,
    fSoundClick: TResSoundPlayer;
    procedure PlaySound(const aSound: TSoundWave); inline;
    procedure PauseSound(const aSound: TSoundWave); inline;
    procedure StopSound(const aSound: TSoundWave); inline;

    procedure ExpandForm;
    { Timer Getter }
    function Get_Timer: I_TimerThread;
    { Get Sounds Getter }
  {$REGION '  [Sounds Getters] .. '}
    function GetIntroSound: TResSoundPlayer;
    function GetBGSound: TResSoundPlayer;
    function GetClickedSound: TResSoundPlayer;
  {$ENDREGION}
  public
    { Public declarations }
    property Timer: I_TimerThread read Get_Timer;

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

function TMainView.Get_Timer: I_TimerThread;
begin
  if not Assigned(fTimer) then begin
    fTimer := Create_TimerThread;

    fTimer
      .Init
      .Interval(50) // Set interval to 3 seconds
      .OnTask(ExpandForm);
  end;

  Result := fTimer;
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

  Timer.Enabled(True);
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

procedure TMainView.ExpandForm;
begin
  if Height >= 750 then
    Timer.Enabled(False);

  Height := Height +5;
//  Application.ProcessMessages;
end;

procedure TMainView.FormCreate(Sender: TObject);
begin
  fSoundIntro := nil;
  fSoundBG    := nil;
  fSoundClick := nil;

  Top := Screen.WorkAreaTop; Left := (Screen.WorkAreaWidth div 2)-(Width div 2);
end;

procedure TMainView.FormDestroy(Sender: TObject);
begin
  fSoundIntro.Free;
  fSoundBG.Free;
  fSoundClick.Free;
end;

end.
