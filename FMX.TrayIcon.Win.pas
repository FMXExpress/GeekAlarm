unit FMX.TrayIcon.Win;

interface

uses
  System.SysUtils, System.Classes, System.UITypes,
  Winapi.ShellAPI, Winapi.Windows, Winapi.Messages,
  FMX.Types, FMX.Menus, FMX.Forms, FMX.Platform.Win;

const
  WM_SYSTEM_TRAY_MESSAGE = WM_USER + 1;

type
  TBalloonFlags = (bfNone = NIIF_NONE, bfInfo = NIIF_INFO, bfWarning = NIIF_WARNING, bfError = NIIF_ERROR);

  TCustomTrayIcon = class(TComponent)
  private
    FBalloonHint: string;
    FBalloonTitle: string;
    FBalloonFlags: TBalloonFlags;
    FIsClicked: Boolean;
    FData: PNotifyIconData;
    FPopupMenu: TPopupMenu;
    FHint: String;
    FVisible: Boolean;
    FOnBalloonClick: TNotifyEvent;
    FOnClick: TNotifyEvent;
    FOnDblClick: TNotifyEvent;
    FOnMouseDown: TMouseEvent;
    FOnMouseMove: TMouseMoveEvent;
    FOnMouseUp: TMouseEvent;
    FOnAnimate: TNotifyEvent;
    function GetData: TNotifyIconData;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure SetHint(const Value: string);
    procedure SetBalloonHint(const Value: string);
    function GetBalloonTimeout: Integer;
    procedure SetBalloonTimeout(Value: Integer);
    procedure SetBalloonTitle(const Value: string);
    procedure SetVisible(Value: Boolean); virtual;
    procedure WindowProc(var Message: TMessage); virtual;
    property Data: TNotifyIconData read GetData;
    function Refresh(Message: Integer): Boolean; overload;
  public
    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;
    procedure Refresh; overload;
    procedure ShowBalloonHint; virtual;
    property Hint: string read FHint write SetHint;
    property BalloonHint: string read FBalloonHint write SetBalloonHint;
    property BalloonTitle: string read FBalloonTitle write SetBalloonTitle;
    property BalloonTimeout: Integer read GetBalloonTimeout write SetBalloonTimeout default 10000;
    property BalloonFlags: TBalloonFlags read FBalloonFlags write FBalloonFlags default bfNone;
    property PopupMenu: TPopupMenu read FPopupMenu write FPopupMenu;
    property Visible: Boolean read FVisible write SetVisible default False;
    property OnBalloonClick: TNotifyEvent read FOnBalloonClick write FOnBalloonClick;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property OnDblClick: TNotifyEvent read FOnDblClick write FOnDblClick;
    property OnMouseMove: TMouseMoveEvent read FOnMouseMove write FOnMouseMove;
    property OnMouseUp: TMouseEvent read FOnMouseUp write FOnMouseUp;
    property OnMouseDown: TMouseEvent read FOnMouseDown write FOnMouseDown;
    property OnAnimate: TNotifyEvent read FOnAnimate write FOnAnimate;
  end;

  TTrayIcon = class(TCustomTrayIcon)
  published
    property Hint;
    property BalloonHint;
    property BalloonTitle;
    property BalloonTimeout;
    property BalloonFlags;
    property PopupMenu;
    property Visible;
    property OnBalloonClick;
    property OnClick;
    property OnDblClick;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseDown;
    property OnAnimate;
  end;

implementation

resourcestring
  STrayIconRemoveError = 'Cannot remove shell notification icon';

{ TTrayIcon}
constructor TCustomTrayIcon.Create(Owner: TComponent);
begin
  inherited;
  New(FData);
  FBalloonFlags := bfNone;
  BalloonTimeout := 10000;
  FVisible := False;
  FIsClicked := False;
  if not (csDesigning in ComponentState) then
  begin
    FillChar(FData^, SizeOf(FData^), 0);
    FData.cbSize := FData^.SizeOf; // Use SizeOf method to get platform specific size
    FData.Wnd := AllocateHwnd(WindowProc);
    StrPLCopy(FData.szTip, Application.Title, Length(FData.szTip) - 1);
    FData.uID := FData.Wnd;
    FData.uTimeout := 10000;
    FData.hIcon := GetClassLong(ApplicationHWND, GCL_HICONSM);
    FData.uFlags := NIF_ICON or NIF_MESSAGE;
    FData.uCallbackMessage := WM_SYSTEM_TRAY_MESSAGE;
    if Length(Application.Title) > 0 then
       FData.uFlags := FData.uFlags or NIF_TIP;
    Refresh;
  end;
end;

destructor TCustomTrayIcon.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    Refresh(NIM_DELETE);
    DeallocateHWnd(FData.Wnd);
  end;
  Dispose(FData);
  inherited;
end;

procedure TCustomTrayIcon.SetVisible(Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    if not (csDesigning in ComponentState) then
    begin
      if FVisible then
        Refresh(NIM_ADD)
      else if not (csLoading in ComponentState) then
      begin
        if not Refresh(NIM_DELETE) then
          raise EOutOfResources.Create(STrayIconRemoveError);
      end;
    end;
  end;
end;

procedure TCustomTrayIcon.SetHint(const Value: string);
begin
  if CompareStr(FHint, Value) <> 0 then
  begin
    FHint := Value;
    StrPLCopy(FData.szTip, FHint, Length(FData.szTip) - 1);
    if Length(Hint) > 0 then
      FData.uFlags := FData.uFlags or NIF_TIP
    else
      FData.uFlags := FData.uFlags and not NIF_TIP;
    Refresh;
  end;
end;

{ Message handler for the hidden shell notification window. Most messages
  use WM_SYSTEM_TRAY_MESSAGE as the Message ID, with WParam as the ID of the
  shell notify icon data. LParam is a message ID for the actual message, e.g.,
  WM_MOUSEMOVE. Another important message is WM_ENDSESSION, telling the shell
  notify icon to delete itself, so Windows can shut down.

  Send the usual events for the mouse messages. Also interpolate the OnClick
  event when the user clicks the left button, and popup the menu, if there is
  one, for right click events. }

procedure TCustomTrayIcon.WindowProc(var Message: TMessage);

  { Return the state of the shift keys. }
  function ShiftState: TShiftState;
  begin
    Result := [];
    if GetKeyState(VK_SHIFT) < 0 then
      Include(Result, ssShift);
    if GetKeyState(VK_CONTROL) < 0 then
      Include(Result, ssCtrl);
    if GetKeyState(VK_MENU) < 0 then
      Include(Result, ssAlt);
  end;

var
  Point: TPoint;
  Shift: TShiftState;
begin
  case Message.Msg of
    WM_QUERYENDSESSION: Message.Result := 1;
    WM_ENDSESSION:
      if TWMEndSession(Message).EndSession then
        Refresh(NIM_DELETE);
    WM_SYSTEM_TRAY_MESSAGE:
      begin
        case Int64(Message.lParam) of
          WM_MOUSEMOVE:
            if Assigned(FOnMouseMove) then
            begin
              Shift := ShiftState;
              GetCursorPos(Point);
              FOnMouseMove(Self, Shift, Point.X, Point.Y);
            end;
          WM_LBUTTONDOWN:
            begin
              if Assigned(FOnMouseDown) then
              begin
                Shift := ShiftState + [ssLeft];
                GetCursorPos(Point);
                FOnMouseDown(Self, TMouseButton.mbLeft, Shift, Point.X, Point.Y);
              end;
              FIsClicked := True;
            end;
          WM_LBUTTONUP:
            begin
              Shift := ShiftState + [ssLeft];
              GetCursorPos(Point);
              if FIsClicked and Assigned(FOnClick) then
              begin
                FOnClick(Self);
                FIsClicked := False;
              end;
              if Assigned(FOnMouseUp) then
                FOnMouseUp(Self, TMouseButton.mbLeft, Shift, Point.X, Point.Y);
            end;
          WM_RBUTTONDOWN:
            if Assigned(FOnMouseDown) then
            begin
              Shift := ShiftState + [ssRight];
              GetCursorPos(Point);
              FOnMouseDown(Self, TMouseButton.mbRight, Shift, Point.X, Point.Y);
            end;
          WM_RBUTTONUP:
            begin
              Shift := ShiftState + [ssRight];
              GetCursorPos(Point);
              if Assigned(FOnMouseUp) then
                FOnMouseUp(Self, TMouseButton.mbRight, Shift, Point.X, Point.Y);
              if Assigned(FPopupMenu) then
              begin
                SetForegroundWindow(ApplicationHWND);
                Application.ProcessMessages;
                FPopupMenu.PopupComponent := Owner;
                FPopupMenu.Popup(Point.x, Point.y);
              end;
            end;
          WM_LBUTTONDBLCLK, WM_MBUTTONDBLCLK, WM_RBUTTONDBLCLK:
            if Assigned(FOnDblClick) then
              FOnDblClick(Self);
          WM_MBUTTONDOWN:
            if Assigned(FOnMouseDown) then
            begin
              Shift := ShiftState + [ssMiddle];
              GetCursorPos(Point);
              FOnMouseDown(Self, TMouseButton.mbMiddle, Shift, Point.X, Point.Y);
            end;
          WM_MBUTTONUP:
            if Assigned(FOnMouseUp) then
            begin
              Shift := ShiftState + [ssMiddle];
              GetCursorPos(Point);
              FOnMouseUp(Self, TMouseButton.mbMiddle, Shift, Point.X, Point.Y);
            end;
          NIN_BALLOONHIDE, NIN_BALLOONTIMEOUT:
            FData.uFlags := FData.uFlags and not NIF_INFO;
          NIN_BALLOONUSERCLICK:
            if Assigned(FOnBalloonClick) then
              FOnBalloonClick(Self);
        end;
      end;
  end;
end;

procedure TCustomTrayIcon.Refresh;
begin
  if not (csDesigning in ComponentState) then
  begin
    if Visible then
      Refresh(NIM_MODIFY);
  end;
end;

function TCustomTrayIcon.Refresh(Message: Integer): Boolean;
begin
  Result := Shell_NotifyIcon(Message, FData);
end;

procedure TCustomTrayIcon.SetBalloonHint(const Value: string);
begin
  if CompareStr(FBalloonHint, Value) <> 0 then
  begin
    FBalloonHint := Value;
    StrPLCopy(FData.szInfo, FBalloonHint, Length(FData.szInfo) - 1);
    Refresh(NIM_MODIFY);
  end;
end;

procedure TCustomTrayIcon.SetBalloonTimeout(Value: Integer);
begin
  FData.uTimeout := Value;
end;

function TCustomTrayIcon.GetBalloonTimeout: Integer;
begin
  Result := FData.uTimeout;
end;

function TCustomTrayIcon.GetData: TNotifyIconData;
begin
  Result := FData^;
end;

procedure TCustomTrayIcon.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (AComponent = FPopupMenu) and (Operation = opRemove) then
    FPopupMenu := nil;
end;

procedure TCustomTrayIcon.ShowBalloonHint;
begin
  FData.uFlags := FData.uFlags or NIF_INFO;
  FData.dwInfoFlags := Cardinal(FBalloonFlags);
  Refresh(NIM_MODIFY);
end;

procedure TCustomTrayIcon.SetBalloonTitle(const Value: string);
begin
  if CompareStr(FBalloonTitle, Value) <> 0 then
  begin
    FBalloonTitle := Value;
    StrPLCopy(FData.szInfoTitle, FBalloonTitle, Length(FData.szInfoTitle) - 1);
    Refresh(NIM_MODIFY);
  end;
end;

end.
