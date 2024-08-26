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
, Vcl.Imaging.pngimage, API.Images
{$ENDREGION}

, API.SoundLib
, Lyt.Ripple
, Layout.Dimmer;

type
  TSoundWave = (sIntro, sBG, sClicked);

  TMainView = class(TForm)
    Btn_Click: TButton;
    Btn_Switch_PlayStop: TSpeedButton;
    Btn_Switch_PlayPause: TSpeedButton;
    Pnl_Status: TPanel;
    Pnl_Tool: TPanel;
    ImgCristo: TImage;
    TimerExpand: TTimer;
    Pnl_Ripple: TPanel;
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Btn_ClickClick(Sender: TObject);
    procedure Btn_Switch_PlayPauseClick(Sender: TObject);
    procedure Btn_Switch_PlayStopClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TimerExpandTimer(Sender: TObject);
  private
    fSoundIntro,
    fSoundBG,
    fSoundClick: TResSoundPlayer;
    fLytRipple: TLytRipple;
    fDimmer: TLytDimmer;
    procedure PlaySound(const aSound: TSoundWave); inline;
    procedure PauseSound(const aSound: TSoundWave); inline;
    procedure StopSound(const aSound: TSoundWave); inline;
    { Get Sounds Getter }
  {$REGION '  [Sounds Getters] .. '}
    function GetIntroSound: TResSoundPlayer;
    function GetBGSound: TResSoundPlayer;
    function GetClickedSound: TResSoundPlayer;
  {$ENDREGION}
//    function GetLytRipple: TLytRipple;
    function GetDimmer: TLytDimmer;
  public
    { Public declarations }

    property SoundIntro:   TResSoundPlayer read GetIntroSound;
    property SoundBG:      TResSoundPlayer read GetBGSound;
    property SoundClicked: TResSoundPlayer read GetClickedSound;

//    property LytRipple: TLytRipple read GetLytRipple;
    property Dimmer: TLytDimmer read GetDimmer;
  end;

//var
//  MainView: TMainView;

implementation
uses
  API.bass
  , System.Threading
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
    fSoundIntro := TResSoundPlayer.Create('SOUND_INTRO');

  Result := fSoundIntro;
end;

function TMainView.GetBGSound: TResSoundPlayer;
begin
  if not Assigned(fSoundBG) then
    fSoundBG := TResSoundPlayer.Create('SOUND_BG');

  Result := fSoundBG;
end;

function TMainView.GetClickedSound: TResSoundPlayer;
begin
  if not Assigned(fSoundClick) then
    fSoundClick := TResSoundPlayer.Create('SOUND_CLICKED');

  Result := fSoundClick;
end;
function TMainView.GetDimmer: TLytDimmer;
begin
  if not Assigned(fDimmer) then  begin
    fDimmer := TLytDimmer.Create(Self, Pnl_Ripple);
  end;

  Result := fDimmer;
end;

{$ENDREGION}

//function TMainView.GetLytRipple: TLytRipple;
//var
//  LTask: ITask;
//begin
//  if not Assigned(fLytRipple) then  begin
//    fLytRipple := TLytRipple.Create(Self);
//    try

//
//    finally
//
//    end;
//  end;
//
//  Result := fLytRipple;
//end;

procedure TMainView.TimerExpandTimer(Sender: TObject);
var
  LTask: ITask;
begin
  if Height >= 640 then begin
    TimerExpand.Enabled := False;
    fLytRipple := TLytRipple.Create(Self);
    try
      fLytRipple.Parent := Pnl_Ripple;
      fLytRipple.Top := Pnl_Tool.Height;
      fLytRipple.Left := 0;
      fLytRipple.LoadRipple;
      LTask := TTask.run(procedure begin
         repeat
           Application.ProcessMessages;
           Sleep(10);
         until fLytRipple.Ripple.IsResBitmapLoaded;

        FreeAndNil(ImgCristo);

      end);
    finally
      Pnl_Status.Caption := 'Loading Ripple ..';
      try
        while not (LTask.Status in [TTaskStatus.Completed, TTaskStatus.Canceled, TTaskStatus.Exception]) do
          Application.ProcessMessages;
      finally
        Pnl_Status.Caption := '';
      end;

      fLytRipple.Show;
    end;
  end;

  Height := Height +15;
  Application.ProcessMessages;
end;

procedure TMainView.Btn_ClickClick(Sender: TObject);
begin
  PlaySound(sClicked);
end;

{$REGION '  Buttons [Play|Pause|Stop] .. '}
procedure TMainView.Btn_Switch_PlayPauseClick(Sender: TObject);
begin
  case Btn_Switch_PlayPause.Tag of
    0: begin
       PauseSound(sBG);
       Btn_Switch_PlayPause.Tag := 1;
       Btn_Switch_PlayPause.Caption := 'Play';
       Btn_Switch_PlayStop.Tag := 1;
       Btn_Switch_PlayStop.Caption := 'Play';
    end;
    1: begin
       PlaySound(sBG);
       Btn_Switch_PlayPause.Tag := 0;
       Btn_Switch_PlayPause.Caption := 'Pause';
       Btn_Switch_PlayStop.Tag := 0;
       Btn_Switch_PlayStop.Caption := 'Stop';
    end;
  end;
end;

procedure TMainView.Btn_Switch_PlayStopClick(Sender: TObject);
begin
  case Btn_Switch_PlayStop.Tag of
    0: begin
       StopSound(sBG);
       Btn_Switch_PlayStop.Tag := 1;
       Btn_Switch_PlayStop.Caption := 'Play';
       Btn_Switch_PlayPause.Tag := 1;
       Btn_Switch_PlayPause.Caption := 'Play';
    end;
    1: begin
       PlaySound(sBG);
       Btn_Switch_PlayStop.Tag := 0;
       Btn_Switch_PlayStop.Caption := 'Stop';
       Btn_Switch_PlayPause.Tag := 0;
       Btn_Switch_PlayPause.Caption := 'Pause';
    end;
  end;
end;
{$ENDREGION}

procedure TMainView.FormCreate(Sender: TObject);
begin
//  fLytRipple  := nil;
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

//  fLytRipple.Free;
end;

procedure TMainView.FormShow(Sender: TObject);
begin
  PlaySound(sIntro);
  PlaySound(sBG);

  TimerExpand.Enabled := True;

end;

end.
