{
*****************************************************************************
*                                                                           *
*                                   Hooks                                   *
*                                                                           *
*                            By Jens Borrisholt                             *
*                           Jens@Borrisholt.com                             *
*                                                                           *
* This file may be distributed and/or modified under the terms of the GNU   *
* General Public License (GPL) version 2 as published by the Free Software  *
* Foundation.                                                               *
*                                                                           *
* This file has no warranty and is used at the users own peril              *
*                                                                           *
* Please report any bugs to Jens@Borrisholt.com or contact me if you want   *
* to contribute to this unit.  It will be deemed a breach of copyright if   *
* you publish any source code  (modified or not) herein under your own name *
* without the authors consent!!!!!                                          *
*                                                                           *
* CONTRIBUTIONS:-                                                           *
*      Jens Borrisholt (Jens@Borrisholt.com) [ORIGINAL AUTHOR]              *
*                                                                           *
* Published:  http://delphi.about.com/od/windowsshellapi/a/delphi-hooks.htm *
*****************************************************************************
}

unit hooks;

interface

uses
  Windows, Classes;

const
  WH_KEYBOARD_LL = 13;
  WH_MOUSE_LL = 14;

  (*
  * Low level hook flags
  *)
  LLKHF_EXTENDED = $01;
  LLKHF_INJECTED = $10;
  LLKHF_ALTDOWN = $20;
  LLKHF_UP = $80;

{$M+}
type
  TKeyState = (ksKeyDown, ksKeyIsDown, ksDummy, ksKeyUp);
  THookMsg = packed record
    Code: Integer;
    WParam: WPARAM;
    LParam: LPARAM;
    Result: LResult
  end;

  ULONG_PTR = ^DWORD;
  pKBDLLHOOKSTRUCT = ^KBDLLHOOKSTRUCT;
  KBDLLHOOKSTRUCT = packed record
    vkCode: DWORD;
    scanCodem: DWORD;
    flags: DWORD;
    time: DWORD;
    dwExtraInfo: ULONG_PTR;
  end;

  pMSLLHOOKSTRUCT = ^MSLLHOOKSTRUCT;
  MSLLHOOKSTRUCT = packed record
    Pt: TPoint;
    MouseData: DWORD;
    Flags: DWORD;
    Time: DWORD;
    dwExtraInfo: ULONG_PTR;
  end;

  TCustomHook = class;
  THook = class;

  THookMethod = procedure(var HookMsg: THookMsg) of object;
  THookNotify = procedure(Hook: THook; var Hookmsg: THookMsg) of object;

  TCustomHook = class
  private
    FHook: hHook;
    FHookProc: Pointer;
    FOnPreExecute: THookNotify;
    FOnPostExecute: THookNotify;
    FActive: Boolean;
    FLoadedActive: Boolean;
    FThreadID: Integer;

    procedure SetActive(NewState: Boolean);
    procedure SetThreadID(NewID: Integer);
    procedure HookProc(var HookMsg: THookMsg);
  protected
    procedure PreExecute(var HookMsg: THookMsg; var Handled: Boolean); virtual;
    procedure PostExecute(var HookMsg: THookMsg); virtual;
    function AllocateHook: hHook; virtual; abstract;
  public
    constructor Create;
    destructor Destroy; override;
    property ThreadID: Integer read FThreadID write SetThreadID stored False;
    property Active: Boolean read FActive write SetActive;
    property OnPreExecute: THookNotify read FOnPreExecute write FOnPreExecute;
    property OnPostExecute: THookNotify read FOnPostExecute write FOnPostExecute;
  end;

  THook = class(TCustomHook)
  published
    property Active;
    property OnPreExecute;
    property OnPostExecute;
  end;

  TCallWndProcHook = class(THook)
  public
    function AllocateHook: hHook; override;
  end;

  TCallWndProcRetHook = class(THook)
  public
    function AllocateHook: hHook; override;
  end;

  TCBTHook = class(THook)
  public
    function AllocateHook: hHook; override;
  end;

  TDebugHook = class(THook)
  public
    function AllocateHook: hHook; override;
  end;

  TGetMessageHook = class(THook)
  public
    function AllocateHook: hHook; override;
  end;

  TJournalPlaybackHook = class(THook)
  public
    function AllocateHook: hHook; override;
  end;

  TJournalRecordHook = class(THook)
  public
    function AllocateHook: hHook; override;
  end;

  TKeyboardHook = class(THook)
  private
    FKeyState: TKeyState;
  protected
    procedure PreExecute(var HookMsg: THookMsg; var Handled: Boolean); override;
    procedure PostExecute(var HookMsg: THookMsg); override;
  public
    function AllocateHook: hHook; override;
  published
    property KeyState : TKeyState read FKeyState;
  end;

  TMouseHook = class(THook)
  public
    function AllocateHook: hHook; override;
  end;

  TMsgHook = class(THook)
  public
    function AllocateHook: hHook; override;
  end;

  TShellHook = class(THook)
  public
    function AllocateHook: hHook; override;
  end;

  TSysMsgHook = class(THook)
  public
    function AllocateHook: hHook; override;
  end;

  TLowLevelKeyboardHook = class(THook)
  private
    FHookStruct: pKBDLLHOOKSTRUCT;
  protected
    procedure PreExecute(var HookMsg: THookMsg; var Handled: Boolean); override;
    procedure PostExecute(var HookMsg: THookMsg); override;
  public
    function AllocateHook: hHook; override;
    property HookStruct: pKBDLLHOOKSTRUCT read FHookStruct;
  end;

  TLowLevelMouseHook = class(THook)
  private
    FHookStruct: pMSLLHOOKSTRUCT;
  protected
    procedure PreExecute(var HookMsg: THookMsg; var Handled: Boolean); override;
    procedure PostExecute(var HookMsg: THookMsg); override;
  public
    function AllocateHook: hHook; override;
    property HookStruct: pMSLLHOOKSTRUCT read FHookStruct;
  end;

function MakeHookInstance(Method: THookMethod): Pointer;
procedure FreeHookInstance(ObjectInstance: Pointer);

implementation

uses
  SysUtils;

const
  InstanceCount = 313; // set so that sizeof (TInstanceBlock) < PageSize

type
  pObjectInstance = ^TObjectInstance;
  TObjectInstance = packed record
    Code: Byte;
    Offset: Integer;
    case Integer of
      0: (Next: pObjectInstance);
      1: (Method: THookMethod);
  end;

  pInstanceBlock = ^TInstanceBlock;
  TInstanceBlock = packed record
    Next: pInstanceBlock;
    Code: array[1..2] of Byte;
    WndProcPtr: Pointer;
    Instances: array[0..InstanceCount] of TObjectInstance;
  end;

var
  InstBlockList: pInstanceBlock = nil;
  InstFreeList: pObjectInstance = nil;

function StdHookProc(Code, WParam: WPARAM; LParam: LPARAM): LResult; stdcall; assembler;
asm
  XOR     EAX,EAX
  PUSH    EAX
  PUSH    LParam
  PUSH    WParam
  PUSH    Code
  MOV     EDX,ESP
  MOV     EAX,[ECX].Longint[4]
  CALL    [ECX].Pointer
  ADD     ESP,12
  POP     EAX
end;

{ Allocate a hook method instance }

function CalcJmpOffset(Src, Dest: Pointer): Longint;
begin
  Result := Longint(Dest) - (Longint(Src) + 5);
end;

function MakeHookInstance(Method: THookMethod): Pointer;
const
  BlockCode: array[1..2] of Byte = ($59, $E9);
  PageSize = 4096;
var
  Block: pInstanceBlock;
  Instance: pObjectInstance;
begin
  if InstFreeList = nil then
  begin
    Block := VirtualAlloc(nil, PageSize, MEM_COMMIT, PAGE_EXECUTE_READWRITE);
    Block^.Next := InstBlockList;
    Move(BlockCode, Block^.Code, SizeOf(BlockCode));
    Block^.WndProcPtr := Pointer(CalcJmpOffset(@Block^.Code[2], @StdHookProc));
    Instance := @Block^.Instances;

    repeat
      Instance^.Code := $E8;
      Instance^.Offset := CalcJmpOffset(Instance, @Block^.Code);
      Instance^.Next := InstFreeList;
      InstFreeList := Instance;
      Inc(Longint(Instance), SizeOf(TObjectInstance));
    until Longint(Instance) - Longint(Block) >= SizeOf(TInstanceBlock);

    InstBlockList := Block
  end;

  Result := InstFreeList;
  Instance := InstFreeList;
  InstFreeList := Instance^.Next;
  Instance^.Method := Method
end;

{ Free a hook method instance }

procedure FreeHookInstance(ObjectInstance: Pointer);
begin
  if ObjectInstance = nil then
    Exit;

  pObjectInstance(ObjectInstance)^.Next := InstFreeList;
  InstFreeList := ObjectInstance
end;

constructor TCustomHook.Create;
begin
  inherited;
  FHookProc := MakeHookInstance(HookProc);
  FActive := False;
  FLoadedActive := False;
  FHook := 0;
  ThreadID := GetCurrentThreadID;
end;

destructor TCustomHook.Destroy;
begin
  Active := False;
  FreeHookInstance(FHookProc);
  inherited;
end;

procedure TCustomHook.SetActive(NewState: Boolean);
begin
  if FActive = NewState then
    Exit;

  FActive := NewState;

  case Active of
    True:
      begin
        FHook := AllocateHook;
        if (FHook = 0) then
        begin
          FActive := False;
          raise Exception.Create(Classname + ' CREATION FAILED!');
        end;
      end;

    False:
      begin
        if (FHook <> 0) then
          UnhookWindowsHookEx(FHook);
        FHook := 0;
      end;
  end;
end;

procedure TCustomHook.SetThreadID(NewID: Integer);
var
  IsActive: Boolean;
begin
  IsActive := FActive;
  Active := False;
  FThreadID := NewID;
  Active := IsActive;
end;

procedure TCustomHook.HookProc(var HookMsg: THookMsg);
var
  Handled: Boolean;
begin
  Handled := False;
  PreExecute(HookMsg, Handled);
  if not Handled then
  begin
    with HookMsg do
      Result := CallNextHookEx(FHook, Code, wParam, lParam);
    PostExecute(HookMsg);
  end;
end;

procedure TCustomHook.PreExecute(var HookMsg: THookMsg; var Handled: Boolean);
begin
  if Assigned(FOnPreExecute) then
    FOnPreExecute(THook(Self), HookMsg);
  Handled := HookMsg.Result <> 0;
end;

procedure TCustomHook.PostExecute(var HookMsg: THookMsg);
begin
  if Assigned(FOnPostExecute) then
    FOnPostExecute(THook(Self), HookMsg);
end;

function TCallWndProcHook.AllocateHook: hHook;
begin
  Result := SetWindowsHookEx(WH_CALLWNDPROC, FHookProc, HInstance, ThreadID);
end;

function TCallWndProcRetHook.AllocateHook: hHook;
begin
  Result := SetWindowsHookEx(WH_CALLWNDPROCRET, FHookProc, hInstance, ThreadID);
end;

function TCBTHook.AllocateHook: hHook;
begin
  Result := SetWindowsHookEx(WH_CBT, FHookProc, hInstance, ThreadID);
end;

function TDebugHook.AllocateHook: hHook;
begin
  Result := SetWindowsHookEx(WH_DEBUG, FHookProc, hInstance, ThreadID);
end;

function TGetMessageHook.AllocateHook: hHook;
begin
  Result := SetWindowsHookEx(WH_GETMESSAGE, FHookProc, hInstance, ThreadID);
end;

function TJournalPlaybackHook.AllocateHook: hHook;
begin
  Result := SetWindowsHookEx(WH_JOURNALPLAYBACK, FHookProc, hInstance, ThreadID);
end;

function TJournalRecordHook.AllocateHook: hHook;
begin
  Result := SetWindowsHookEx(WH_JOURNALRECORD, FHookProc, hInstance, ThreadID);
end;

function TKeyboardHook.AllocateHook: hHook;
begin
  Result := SetWindowsHookEx(WH_KEYBOARD, FHookProc, hInstance, ThreadID);
end;

function TMouseHook.AllocateHook: hHook;
begin
  Result := SetWindowsHookEx(WH_MOUSE, FHookProc, hInstance, ThreadID);
end;

function TMsgHook.AllocateHook: hHook;
begin
  Result := SetWindowsHookEx(WH_MSGFILTER, FHookProc, hInstance, ThreadID);
end;

function TShellHook.AllocateHook: hHook;
begin
  Result := SetWindowsHookEx(WH_SHELL, FHookProc, hInstance, ThreadID);
end;

function TSysMsgHook.AllocateHook: hHook;
begin
  Result := SetWindowsHookEx(WH_SYSMSGFILTER, FHookProc, hInstance, ThreadID);
end;

function TLowLevelKeyboardHook.AllocateHook: hHook;
begin
  Result := SetWindowsHookEx(WH_KEYBOARD_LL, FHookProc, hInstance, 0);
end;

procedure TLowLevelKeyboardHook.PostExecute(var HookMsg: THookMsg);
begin
  inherited;
  FHookStruct := nil;
end;

procedure TLowLevelKeyboardHook.PreExecute(var HookMsg: THookMsg; var Handled: Boolean);
begin
  FHookStruct := pKBDLLHOOKSTRUCT(Hookmsg.LPARAM);
  inherited;
end;

{ TLowLevelMouseHook }

function TLowLevelMouseHook.AllocateHook: hHook;
begin
  Result := SetWindowsHookEx(WH_MOUSE_LL, FHookProc, hInstance, 0);
end;

procedure TLowLevelMouseHook.PostExecute(var HookMsg: THookMsg);
begin
  inherited;
  FHookStruct := nil;
end;

procedure TLowLevelMouseHook.PreExecute(var HookMsg: THookMsg; var Handled: Boolean);
begin
  FHookStruct := pMSLLHOOKSTRUCT(Hookmsg.LPARAM);
  inherited;
end;

procedure TKeyboardHook.PostExecute(var HookMsg: THookMsg);
begin
  inherited;
  FKeyState := ksDummy;
end;

procedure TKeyboardHook.PreExecute(var HookMsg: THookMsg; var Handled: Boolean);
begin
  FKeyState := TKeyState(Hookmsg.lParam shr 30);
  inherited;
end;

end.

