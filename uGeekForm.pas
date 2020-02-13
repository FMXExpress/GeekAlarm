unit uGeekForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, System.Rtti, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components,
  FMX.Edit, FMX.Layouts;

type
  TGeekForm = class(TForm)
    GeekImage: TImage;
    Timer: TTimer;
    AlarmLabel: TLabel;
    AlarmMinutesEdit: TEdit;
    BindingsList1: TBindingsList;
    LinkControlToField1: TLinkControlToField;
    BackgroundRect: TRectangle;
    MessageLabel: TLabel;
    GridPanelLayout1: TGridPanelLayout;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    Rectangle4: TRectangle;
    CursorTimer: TTimer;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure TimerTimer(Sender: TObject);
    procedure CursorTimerTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    CurrentCount: Integer;
    Cursor: String;
  end;
  const
    Message1 = 'stand up';
    Message2 = 'walk around';
    Message3 = 'stretch and exercise';
    Message4 = 'focus on a distant object';

var
  GeekForm: TGeekForm;

implementation

{$R *.fmx}

uses
  uMainForm;

procedure TGeekForm.CursorTimerTimer(Sender: TObject);
begin
  if Cursor='' then
    Cursor := '_'
  else
    Cursor := '';
  case MessageLabel.Tag of
    0: MessageLabel.Text := Message1 + Cursor;
    1: MessageLabel.Text := Message1 + #13#10 + Message2 + Cursor;
    2: MessageLabel.Text := Message1 + #13#10 + Message2 + #13#10 + Message3 + Cursor;
    3: MessageLabel.Text := Message1 + #13#10 + Message2 + #13#10 + Message3 + #13#10 + Message4 + Cursor;
  end;

end;

procedure TGeekForm.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
//  GeekForm.FullScreen := not GeekForm.FullScreen;
end;

procedure TGeekForm.TimerTimer(Sender: TObject);
var
AlarmDuration: Integer;
begin
  if Self.Visible=True then
   begin
      AlarmDuration := AlarmMinutesEdit.Text.ToInteger*60;

      if CurrentCount=0 then
        begin
          MessageLabel.Tag := 0;
        end
      else
      if CurrentCount=Trunc(AlarmDuration/4) then
        begin
          MessageLabel.Tag := 1;
        end
      else
      if CurrentCount=Trunc(AlarmDuration/2) then
        begin
          MessageLabel.Tag := 2;
        end
      else
      if CurrentCount=Trunc((AlarmDuration/4)*3) then
        begin
          MessageLabel.Tag := 3;
        end;

      if CurrentCount>(AlarmDuration) then
        begin
          CurrentCount := 0;
          Timer.Enabled := False;
          MainForm.EndBreakAction.Execute;
          Exit;
        end;
      AlarmLabel.Text := 'Your GeekAlarm will complete in '+Format('%.2d:%.2d', [(AlarmDuration-CurrentCount) div 60, (AlarmDuration-CurrentCount) mod 60]) + '.';
      Inc(CurrentCount);
      Self.Show;
   end;
end;

end.
