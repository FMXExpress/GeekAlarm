// Source: https://forums.embarcadero.com/thread.jspa?threadID=108449

unit FMX.TrayIcon.Mac;

interface

uses
  Macapi.ObjectiveC, Macapi.CocoaTypes, Macapi.Foundation, Macapi.AppKit,
  Macapi.Helpers, Macapi.ObjcRuntime, System.TypInfo, FMX.Platform, FMX.Platform.Mac;

type
IFMXTrayItem = interface(NSObject)
['{0D6D28FA-5ABD-4146-ADA9-5E22B671DD4A}']
  procedure call_mymethod; cdecl;
end;

TTrayIcon = class(TOCLocal)
private
NSStatItem : NSStatusItem;
public
constructor Create;
destructor Destroy; override;
function GetObjectiveCClass: PTypeInfo; override;
procedure call_mymethod; cdecl;
end;

implementation

constructor TTrayIcon.Create;
var
NSContMenu : NSMenu;
NSContItem : NSMenuItem;
NSStatBar : NSStatusBar;
NSImg : NSImage;
AppBundle : NSBundle;
NSpImg: Pointer;
Path: String;
begin
inherited Create;

NSStatBar := TNSStatusBar.Create;
NSStatBar := TNSStatusBar.Wrap(TNSStatusBar.OCClass.systemStatusBar);
NSStatItem:= NSStatBar.statusItemWithLength(NSVariableStatusItemLength);
NSStatItem.setTarget(GetObjectID);

// Create context menu
NSContMenu := TNSMenu.Create;
NSContMenu := TNSMenu.Wrap(NSContMenu.initWithTitle(StrToNSStr('GeekAlarm!')));

NSContItem:=TNSMenuItem.Create;
NSContItem:=TNSMenuItem.Wrap(NSContItem.initWithTitle(StrToNSStr('1. menuitem'),sel_getUid(PAnsiChar('call_mymethod')),StrToNSStr('')));
NSContItem.setTarget(GetObjectID);
NSContMenu.addItem(NSContItem);
NSContItem.release;


// Add menu
NSStatItem.retain;
NSStatItem.setHighlightMode(true);
NSStatItem.setMenu(NSContMenu);
NSContMenu.release;

// Get path to dir
AppBundle := TNSBundle.Wrap(TNSBundle.OCClass.mainBundle);
Path:=AppBundle.bundlePath.UTF8String+'/Contents/yourimage16x16.png';
NSpImg := TNSImage.Alloc.initWithContentsOfFile(StrToNSStr(Path));
// Create Icon
NSImg := TNSImage.Create;
NSImg := TNSImage.Wrap(NSpImg);
NSStatItem.setImage(NSImg);
NSImg.release;
end;

destructor TTrayIcon.Destroy;
begin
NSStatItem.release;
inherited;
end;

function TTrayIcon.GetObjectiveCClass: PTypeInfo;
begin
Result :=TypeInfo(IFMXTrayItem);
end;

procedure TTrayIcon.call_mymethod;
begin
// your event code of the menu item
end;

end.
