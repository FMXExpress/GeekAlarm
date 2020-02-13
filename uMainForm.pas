unit uMainForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Menus, FMX.Platform, AudioManager, System.IOUtils, System.Actions,
  FMX.ActnList, FMX.Controls.Presentation, FMX.StdCtrls, FMX.TabControl,
  FMX.Objects, FMX.Layouts, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.StorageBin, System.Rtti,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, DateUtils, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.Effects,
  FMX.Filter.Effects, FMX.ListView, FMX.MultiView, FMX.Edit,
  {$IF DEFINED(MSWINDOWS)}
  FMX.TrayIcon.Win, FMX.Platform.Win, Winapi.Windows, StrUtils, Hooks
  {$ENDIF}
  {$IF DEFINED(MACOS)}
  FMX.TrayIcon.Mac
  {$ENDIF}
  ;

type
  TMainForm = class(TForm)
    TrayIconMenu: TPopupMenu;
    ShowMenuItem: TMenuItem;
    CloseMenuItem: TMenuItem;
    TestMenuItem: TMenuItem;
    Timer: TTimer;
    ActionList1: TActionList;
    StartBreakAction: TAction;
    StyleBook1: TStyleBook;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    TabItem5: TTabItem;
    TabItem6: TTabItem;
    ResetButton: TButton;
    GroupBox1: TGroupBox;
    GridPanelLayout1: TGridPanelLayout;
    Layout1: TLayout;
    Layout2: TLayout;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    GroupBox2: TGroupBox;
    AlarmSetupTrackBar: TTrackBar;
    GroupBox3: TGroupBox;
    Layout3: TLayout;
    Text1: TText;
    GroupBox4: TGroupBox;
    AlarmSetupMinutesText: TText;
    Text3: TText;
    Text4: TText;
    BackgroundImage: TImage;
    Image2: TImage;
    Image3: TImage;
    Text5: TText;
    Text6: TText;
    GridPanelLayout2: TGridPanelLayout;
    Layout4: TLayout;
    Layout5: TLayout;
    Layout6: TLayout;
    Layout7: TLayout;
    Layout8: TLayout;
    Layout9: TLayout;
    AlarmSetupPresetBTN: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    FDMemTableSettings: TFDMemTable;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkControlToField1: TLinkControlToField;
    LinkPropertyToFieldText: TLinkPropertyToField;
    GroupBox5: TGroupBox;
    BreakSetupTrackBar: TTrackBar;
    GroupBox6: TGroupBox;
    GridPanelLayout3: TGridPanelLayout;
    Layout10: TLayout;
    BreakSetupPresetBTN: TButton;
    Layout11: TLayout;
    Button7: TButton;
    Layout12: TLayout;
    Button8: TButton;
    Layout13: TLayout;
    Button9: TButton;
    Layout14: TLayout;
    Button10: TButton;
    Layout15: TLayout;
    Button11: TButton;
    Layout16: TLayout;
    Text2: TText;
    Text7: TText;
    GroupBox7: TGroupBox;
    BreakSetupMinutesText: TText;
    Text9: TText;
    LinkPropertyToFieldText2: TLinkPropertyToField;
    LinkControlToField2: TLinkControlToField;
    GroupBox8: TGroupBox;
    GridPanelLayout4: TGridPanelLayout;
    Layout17: TLayout;
    Layout18: TLayout;
    Text10: TText;
    GroupBox10: TGroupBox;
    CurrentTimeText: TText;
    GroupBox9: TGroupBox;
    NextBreakText: TText;
    Text11: TText;
    Text12: TText;
    TestButton: TButton;
    ShutdownButton: TButton;
    CloseCPButton: TButton;
    MultiView1: TMultiView;
    FDMemTableTabs: TFDMemTable;
    ListView1: TListView;
    Image4: TImage;
    BindSourceDB2: TBindSourceDB;
    LinkListControlToField1: TLinkListControlToField;
    FillRGBEffect1: TFillRGBEffect;
    BackgroundRect: TRectangle;
    ChangeTabAction: TChangeTabAction;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    Rectangle3: TRectangle;
    Rectangle4: TRectangle;
    Rectangle5: TRectangle;
    ResetMenuItem: TMenuItem;
    MenuItem2: TMenuItem;
    GroupBox11: TGroupBox;
    GroupBox12: TGroupBox;
    GroupBox13: TGroupBox;
    ImageControl1: TImageControl;
    LinkControlToField3: TLinkControlToField;
    Label1: TLabel;
    Layout19: TLayout;
    Layout20: TLayout;
    StartAlarmEdit: TEdit;
    StartAudioButton: TButton;
    Label2: TLabel;
    Layout21: TLayout;
    EndAlarmEdit: TEdit;
    Button1: TButton;
    AlarmTypeEdit: TEdit;
    LinkControlToField4: TLinkControlToField;
    LinkControlToField5: TLinkControlToField;
    LinkControlToField6: TLinkControlToField;
    StartOpenDialog: TOpenDialog;
    EndOpenDialog: TOpenDialog;
    EndBreakAction: TAction;
    AlarmTypeAction: TAction;
    Image1: TImage;
    Rectangle6: TRectangle;
    MainBackgroundRect: TRectangle;
    GridPanelLayout5: TGridPanelLayout;
    Rectangle8: TRectangle;
    Rectangle9: TRectangle;
    Rectangle10: TRectangle;
    ForegroundImage: TImage;
    MenuItem1: TMenuItem;
    MenuItem3: TMenuItem;
    Label3: TLabel;
    Image5: TImage;
    Image6: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CloseMenuItemClick(Sender: TObject);
    procedure ShowMenuItemClick(Sender: TObject);
    procedure TestMenuItemClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure StartBreakActionExecute(Sender: TObject);
    procedure AlarmSetupPresetBTNClick(Sender: TObject);
    procedure BreakSetupPresetBTNClick(Sender: TObject);
    procedure CloseCPButtonClick(Sender: TObject);
    procedure TestButtonClick(Sender: TObject);
    procedure ResetButtonClick(Sender: TObject);
    procedure ListView1ItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
    procedure FormShow(Sender: TObject);
    procedure FormSaveState(Sender: TObject);
    procedure StartAudioButtonClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure AlarmTypeEditValidate(Sender: TObject; var Text: string);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure ImageControl1Change(Sender: TObject);
    procedure ShutdownButtonClick(Sender: TObject);
    procedure EndBreakActionExecute(Sender: TObject);
    procedure AlarmTypeActionExecute(Sender: TObject);
    procedure ResetMenuItemClick(Sender: TObject);
  private
    { Private declarations }
     MousePosX, MousePosY: Single;
     KeyboardHook: TLowLevelKeyboardHook;
     procedure KeyboardHookPREExecute(Hook: THook; var Hookmsg: THookMsg);
  public
    { Public declarations }
    H: THandle;
    RealClose: Boolean;
    TrayIcon: TTrayIcon;
    AudioManager: TAudioManager;
    CurrentCount: Integer;
    IdleCount: Integer;
    ScreenList: TStringList;
    BreakOn: Boolean;
    PostPone: Boolean;
    function RegisterSound(Filename: String): Integer;
    procedure TrayIconRightClick(Sender: TObject);
    procedure TrayIconLeftClick(Sender: TObject);
    procedure TrayIconBalloonClick(Sender: TObject);
    procedure SetAlarmSetup(Minutes: Integer);
    procedure SetBreakSetup(Minutes: Integer);
  end;
  const
    BEGIN_SOUND = 0;
    END_SOUND = 1;

var
  MainForm: TMainForm;
  MyW: Word = 0;
{$IF DEFINED(MSWINDOWS)}
  KeysOn : boolean = true;
{$ENDIF}

implementation

{$R *.fmx}

uses
  uNotification, uGeekForm;

{$IF DEFINED(MSWINDOWS)}
function LowLevelKeyboardProc(nCode: integer; wParam: WPARAM; lParam: LPARAM):
  LRESULT; stdcall;
type
  PKBDLLHOOKSTRUCT = ^TKBDLLHOOKSTRUCT;
  TKBDLLHOOKSTRUCT = record
    vkCode: cardinal;
    scanCode: cardinal;
    flags: cardinal;
    time: cardinal;
    dwExtraInfo: Cardinal;
  end;

  PKeyboardLowLevelHookStruct = ^TKeyboardLowLevelHookStruct;
  TKeyboardLowLevelHookStruct = TKBDLLHOOKSTRUCT;
const
  LLKHF_ALTDOWN = $20;
var
  hs: PKeyboardLowLevelHookStruct;
  ctrlDown: boolean;
begin

  if nCode = HC_ACTION then
  begin

    hs := PKeyboardLowLevelHookStruct(lParam);
    ctrlDown := GetAsyncKeyState(VK_CONTROL) and $8000 <> 0;
    if (hs^.vkCode = VK_ESCAPE) and ctrlDown then
      Exit(1);
    if (hs^.vkCode = VK_TAB) and ((hs^.flags and LLKHF_ALTDOWN) <> 0) then
      Exit(1);
    if (hs^.vkCode = VK_ESCAPE) and ((hs^.flags and LLKHF_ALTDOWN) <> 0) then
      Exit(1);
    if (hs^.vkCode = VK_LWIN) or (hs^.vkCode = VK_RWIN) then
      Exit(1);

  end;

  result := CallNextHookEx(0, nCode, wParam, lParam);

end;

procedure TMainForm.KeyboardHookPREExecute(Hook: THook; var Hookmsg: THookMsg);
var
  P : pKBDLLHOOKSTRUCT;
begin
  P := Pointer(Hookmsg.LParam);
  if ((P^.flags = 1) or (P^.flags = 129)) then begin
    {if ((P^.vkCode = VK_LWIN) or (P^.vkCode = VK_RWIN) or (P^.vkCode = VK_APPS)) then  begin
        Hookmsg.Result := IfThen(keyson, 1, 0)
    end
    else }
      Hookmsg.Result := 1;
  end;
end;
{$ENDIF}

procedure HideAppOnTaskbar(AMainForm : TForm);
{$IF DEFINED(MSWINDOWS)}
var
  AppHandle : HWND;
{$ENDIF}
begin
{$IF DEFINED(MSWINDOWS)}
  AppHandle := ApplicationHWND;
  ShowWindow(AppHandle, SW_HIDE);
  SetWindowLong(AppHandle, GWL_EXSTYLE, GetWindowLong(AppHandle, GWL_EXSTYLE) and (not     WS_EX_APPWINDOW) or WS_EX_TOOLWINDOW);
{$ENDIF}
end;

procedure TMainForm.TrayIconRightClick(Sender: TObject);
var
  Mouse: IFMXMouseService;
begin
  if TPlatformServices.Current.SupportsPlatformService(IFMXMouseService) then
  begin
    Mouse := TPlatformServices.Current.GetPlatformService(IFMXMouseService) as IFMXMouseService;
  end;
  TrayIconMenu.Popup(Mouse.GetMousePos.X,Mouse.GetMousePos.Y);
end;

procedure TMainForm.TimerTimer(Sender: TObject);
var
  Mouse: IFMXMouseService;
begin
  if ((CurrentCount=((Trunc(AlarmSetupTrackBar.Value)*60)-60)) AND (PostPone=False)) then //1740 then
   begin
     if AlarmTypeEdit.Text='0' then
       begin
        NotifyForm.Show;
       end
     else
       begin
         {$IF DEFINED(MSWINDOWS)}
         TrayIcon.BalloonTitle := 'GeekAlarm!';
         TrayIcon.BalloonHint := 'A break is coming! Save your work.';
         TrayIcon.BalloonFlags := TBalloonFlags.bfWarning;
         TrayIcon.BalloonTimeout := 30;
         TrayIcon.ShowBalloonHint;
         {$ENDIF}
       end;
     end;

  if CurrentCount>(AlarmSetupTrackBar.Value*60) then
    begin
      StartBreakAction.Execute;
      CurrentCount := 0;
    end;

  if TPlatformServices.Current.SupportsPlatformService(IFMXMouseService) then
  begin
    Mouse := TPlatformServices.Current.GetPlatformService(IFMXMouseService) as IFMXMouseService;
  end;

  if ((Mouse.GetMousePos.X<>MousePosX) OR (Mouse.GetMousePos.Y<>MousePosY)) then
   begin
     MousePosX := Mouse.GetMousePos.X;
     MousePosY := Mouse.GetMousePos.Y;
     IdleCount := 0;
   end
  else
   begin
     Inc(IdleCount);
   end;

   if IdleCount>10800 then
     begin
       CurrentCount := 0;
     end;

  if (IdleCount<=60) then
    begin
      Inc(CurrentCount);
    end;

  CurrentTimeText.Text := TimeToStr(Now);
  NextBreakText.Text := TimeToStr(IncSecond(Now,((Trunc(AlarmSetupTrackBar.Value)*60)-CurrentCount)));
end;

procedure TMainForm.TrayIconLeftClick(Sender: TObject);
begin
  MainForm.Show;
end;

procedure TMainForm.TrayIconBalloonClick(Sender: TObject);
begin
// hide balloon
end;


procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  {$IF DEFINED(MSWINDOWS)}
  TrayIcon.Visible := False;
  {$ENDIF}
  TrayIcon.Free;

  ScreenList.OwnsObjects := True;
  ScreenList.Free;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if RealClose=False then
    CanClose := False;
  MainForm.Hide;
end;

procedure TMainForm.RadioButton1Click(Sender: TObject);
begin
  AlarmTypeEdit.Text := '0';
  TLinkObservers.ControlChanged(AlarmTypeEdit);
end;

procedure TMainForm.RadioButton2Click(Sender: TObject);
begin
  AlarmTypeEdit.Text := '1';
  TLinkObservers.ControlChanged(AlarmTypeEdit);
end;

function TMainForm.RegisterSound(Filename: String): Integer;
begin
  if TFile.Exists(Filename) then
    Result := AudioManager.AddSound(Filename)
  else
    Result := -1;
end;


procedure TMainForm.ResetButtonClick(Sender: TObject);
begin
  PostPone := False;
  CurrentCount := 0;
end;

procedure TMainForm.StartAudioButtonClick(Sender: TObject);
begin
if StartOpenDialog.Execute then
 begin
   StartAlarmEdit.Text := StartOpenDialog.FileName;
   TLinkObservers.ControlChanged(StartAlarmEdit);
 end;
end;

procedure TMainForm.EndBreakActionExecute(Sender: TObject);
var
I: Integer;
begin
  if BreakOn=True then
    begin
      BreakOn := False;
      PostPone := False;

      //SystemParametersInfo(SPI_SCREENSAVERRUNNING,0,@MyW,0); // enable
      //UnhookWindowsHookEx(H);

      AudioManager.PlaySound(END_SOUND);

      for I := ScreenList.Count-1 downto 0 do
       begin
         TGeekForm(ScreenList.Objects[I]).FullScreen := False;
         TGeekForm(ScreenList.Objects[I]).Hide;
         TGeekForm(ScreenList.Objects[I]).Free;
         ScreenList.Delete(I);
       end;
    end;
end;

procedure TMainForm.StartBreakActionExecute(Sender: TObject);
var
I: Integer;
AIndex: Integer;
GF: TGeekForm;
begin
  BreakOn := True;
  NotifyForm.Hide;
  MainForm.Hide;
  for I := 0 to Screen.DisplayCount-1 do
   begin
     AIndex := ScreenList.AddObject(I.ToString,TGeekForm.Create(nil));
     TGeekForm(ScreenList.Objects[AIndex]).Top := Screen.Displays[I].WorkareaRect.CenterPoint.Y;
     TGeekForm(ScreenList.Objects[AIndex]).Left := Screen.Displays[I].WorkareaRect.CenterPoint.X;
     TGeekForm(ScreenList.Objects[AIndex]).Show;
     TGeekForm(ScreenList.Objects[AIndex]).FullScreen := True;
   end;

  AudioManager.PlaySound(BEGIN_SOUND);
 // H := SetWindowsHookEx(WH_KEYBOARD_LL, @LowLevelKeyboardProc, 0, 0);
  //SystemParametersInfo(SPI_SCREENSAVERRUNNING,1,@MyW,0); // disable
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  ForeGroundImage.Bitmap.Assign(BackgroundImage.Bitmap);

  AudioManager := TAudioManager.Create;
  RegisterSound(ExtractFilePath(ParamStr(0)) + 'beginsound.wav');
  RegisterSound(ExtractFilePath(ParamStr(0)) + 'endsound.wav');

  ScreenList := TStringList.Create;

  {$IF DEFINED(MSWINDOWS)}
  TrayIcon := TTrayIcon.Create(Self);
  TrayIcon.Visible := True;
  TrayIcon.OnClick := TrayIconLeftClick;
  TrayIcon.PopupMenu := TrayIconMenu;
//  TrayIcon.OnBalloonClick := TrayIconBalloonClick;

{  KeyboardHook := TLowLevelKeyboardHook.Create;
  KeyboardHook.OnPreExecute := KeyboardHookPREExecute;
  KeyboardHook.Active := True;     }
  {$ENDIF}
  {$IF DEFINED(MACOS)}
  TrayIcon := TTrayIcon.Create;
  {$ENDIF}

  if MainForm.SaveState.Stream.Size>0 then
    begin
      //FDMemTableSettings.LoadFromStream(MainForm.SaveState.Stream);
      AlarmTypeAction.Execute;
    end
  else
    begin
      AlarmTypeAction.Execute;
    end;
end;

procedure TMainForm.FormSaveState(Sender: TObject);
begin
FDMemTableSettings.SaveToStream(MainForm.SaveState.Stream);
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
HideAppOnTaskbar(Self);
TimerTimer(Self);
end;

procedure TMainForm.ImageControl1Change(Sender: TObject);
begin
TLinkObservers.ControlChanged(ImageControl1);
end;

procedure TMainForm.ListView1ItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
var
I: Integer;
begin
if ListView1.Selected<>nil then
 begin
    MultiView1.HideMaster;
    case ListView1.ItemIndex of
      0: I := 0;
      1: I := 1;
      2: I := 2;
      3: I := 3;
      4: I := 4;
    end;
    ChangeTabAction.Tab := TabControl1.Tabs[I];
    ChangeTabAction.ExecuteTarget(Self);
 end;
end;

procedure TMainForm.ResetMenuItemClick(Sender: TObject);
begin
  PostPone := False;
  CurrentCount := 0;
end;

procedure TMainForm.ShowMenuItemClick(Sender: TObject);
begin
  MainForm.Show;
end;

procedure TMainForm.ShutdownButtonClick(Sender: TObject);
begin
  RealClose := True;
  Close;
end;

procedure TMainForm.AlarmSetupPresetBTNClick(Sender: TObject);
begin
 SetAlarmSetup(TButton(Sender).Tag);
end;

procedure TMainForm.AlarmTypeActionExecute(Sender: TObject);
begin
  case AlarmTypeEdit.Text.ToInteger of
   0: RadioButton1.IsChecked := True;
   1: RadioButton2.IsChecked := False;
  end;
end;

procedure TMainForm.AlarmTypeEditValidate(Sender: TObject; var Text: string);
begin
  AlarmTypeAction.Execute;
end;

procedure TMainForm.BreakSetupPresetBTNClick(Sender: TObject);
begin
 SetBreakSetup(TButton(Sender).Tag);
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
if EndOpenDialog.Execute then
 begin
   EndAlarmEdit.Text := EndOpenDialog.FileName;
   TLinkObservers.ControlChanged(EndAlarmEdit);
 end;
end;

procedure TMainForm.CloseCPButtonClick(Sender: TObject);
begin
MainForm.Hide;
end;

procedure TMainForm.CloseMenuItemClick(Sender: TObject);
begin
  RealClose := True;
  Close;
end;

procedure TMainForm.TestButtonClick(Sender: TObject);
begin
  StartBreakAction.Execute;
end;

procedure TMainForm.TestMenuItemClick(Sender: TObject);
begin
  StartBreakAction.Execute;
end;

procedure TMainForm.SetAlarmSetup(Minutes: Integer);
begin
  AlarmSetupTrackBar.Value := Minutes;
  TLinkObservers.ControlChanged(AlarmSetupTrackBar);
end;

procedure TMainForm.SetBreakSetup(Minutes: Integer);
begin
  BreakSetupTrackBar.Value := Minutes;
  TLinkObservers.ControlChanged(BreakSetupTrackBar);
end;

end.
