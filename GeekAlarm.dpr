program GeekAlarm;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMainForm in 'uMainForm.pas' {MainForm},
  uGeekForm in 'uGeekForm.pas' {GeekForm},
  AudioManager in 'AudioManager.pas',
  uNotification in 'uNotification.pas' {NotifyForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TNotifyForm, NotifyForm);
  Application.Run;
end.
