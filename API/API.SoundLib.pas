unit API.SoundLib;

interface

uses
  Windows
, Classes
, SysUtils
, System.Generics.Collections
;

type
  TResSoundPlayer = class
  private
    fChannel: DWORD;
    class var InstancesCount: Integer;  // count of created instances ...
    class var Channels: TList<DWORD>;   // Used to Add chanels when instance created ..
    class var IsBASSInitialized: Boolean;
    class procedure InitializeBASS;
    class procedure FinalizeBASS;
  public
    constructor Create(const aResourceName: string);
    destructor Destroy; override;
    procedure Play; inline;
    procedure Pause; inline;
    procedure Stop; inline;
  end;

implementation

uses
  API.bass
, API.BassResMgr
;

{ TResSoundPlayer }

class procedure TResSoundPlayer.InitializeBASS;
begin
  if not IsBASSInitialized then
  begin
    if not BASS_Init(-1, 44100, 0, 0, nil) then
      raise Exception.Create('Error initializing BASS library.');

    IsBASSInitialized := True;
    Channels := TList<DWORD>.Create;
  end;
end;

class procedure TResSoundPlayer.FinalizeBASS;
begin
  if IsBASSInitialized and (InstancesCount = 0) then
  begin
    Channels.Free;
    BASS_Free;
    IsBASSInitialized := False;
  end;
end;

constructor TResSoundPlayer.Create(const aResourceName: string);
begin inherited Create;

  InitializeBASS; // Will work just once no matter instances is created ..

  // Load sound from resource
  fChannel := TBassResMgr.GetHStream(aResourceName);

  if fChannel = 0 then
    raise Exception.CreateFmt('Error loading sound from resource "%s".', [aResourceName]);

  Channels.Add(fChannel);
  Inc(InstancesCount);
end;

destructor TResSoundPlayer.Destroy;
begin
  if fChannel <> 0 then
  begin
    Channels.Remove(fChannel);
    BASS_StreamFree(fChannel);
  end;

  Dec(InstancesCount);

  // Finalize BASS only when the last instance is going to destroyed ..
  // Ensuring to call {finalize BASS] just when all sound instances are destroyed !!
  FinalizeBASS;

  inherited Destroy;
end;

procedure TResSoundPlayer.Play;
begin
  if fChannel <> 0 then
    BASS_ChannelPlay(fChannel, False)
  else
    raise Exception.Create('Error: No sound channel available to play.');
end;

procedure TResSoundPlayer.Pause;
begin
  if fChannel <> 0 then
    BASS_ChannelPause(fChannel)
  else
    raise Exception.Create('Error: No sound channel available to pause.');
end;

procedure TResSoundPlayer.Stop;
begin
  if fChannel <> 0 then
  begin
    BASS_ChannelStop(fChannel);
    BASS_ChannelSetPosition(fChannel, 0, 0);
  end
  else
    raise Exception.Create('Error: No sound channel available to stop.');
end;

end.
