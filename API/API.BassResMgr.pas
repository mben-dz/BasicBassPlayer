unit API.BassResMgr;

interface

uses
  Winapi.Windows
, System.Classes
, System.SysUtils
;

type

  TBassResMgr = class
  public
    class function GetHStream(const aResourceName: String; aResType: PChar = nil): DWORD; inline; static;
  end;


implementation

uses
  API.bass
;

const
  RT_RCWAVE = 'WAVE';

{ TResMgr }

class function TBassResMgr.GetHStream(const aResourceName: String;
  aResType: PChar): DWORD;
var
  LResStream: TResourceStream;
begin
  if aResType = nil then
    aResType := RT_RCWAVE;

  // Load sound from resource
  LResStream := TResourceStream.Create(HInstance, aResourceName, aResType);
  try
    Result := BASS_StreamCreateFile(True, LResStream.Memory, 0, LResStream.Size, 0);
  finally
    LResStream.Free;
  end;
end;

end.
