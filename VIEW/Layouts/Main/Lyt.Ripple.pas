unit Lyt.Ripple;

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
, Vcl.ExtCtrls
{$ENDREGION}
, API.RippleEffects
;

type
  TLytRipple = class(TForm)
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormDestroy(Sender: TObject);

  private
    fRipple: TWaterEffect;
    { Private declarations }
    function GetRipple: TWaterEffect;
  public
    procedure LoadRipple;
    { Public declarations }
    property Ripple: TWaterEffect read GetRipple;
  end;

//var
//  LytRipple: TLytRipple;

implementation

uses
  API.RippleHeader
, System.Threading
;

{$R *.dfm}

{$REGION '  Ripple Getter .. '}
function TLytRipple.GetRipple: TWaterEffect;
begin
  if not Assigned(fRipple) then begin
    fRipple := TWaterEffect.Create(Self, 'CRISTO', 0, 0);

  end;

  Result := fRipple;
end;

procedure TLytRipple.LoadRipple;
var
  LTask: ITask;
begin
  Ripple;

  LTask := TTask.Run(procedure begin
      TThread.Synchronize(nil, procedure begin
        fRipple.InitBitmap;
      end);
  end);
end;

{$ENDREGION}


procedure TLytRipple.FormDestroy(Sender: TObject);
begin
  fRipple.Free;
end;

procedure TLytRipple.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  fRipple.MouseAction(X, Y, 30, 5000);
end;

procedure TLytRipple.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  fRipple.MouseAction(X, Y, 10, 100);
end;

end.
