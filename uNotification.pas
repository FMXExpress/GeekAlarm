unit uNotification;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts;

type
  TNotifyForm = class(TForm)
    ShutdownButton: TButton;
    Image1: TImage;
    Text10: TText;
    GridPanelLayout1: TGridPanelLayout;
    Rectangle2: TRectangle;
    Rectangle3: TRectangle;
    Rectangle4: TRectangle;
    Layout1: TLayout;
    Layout2: TLayout;
    MainBackgroundRect: TRectangle;
    procedure ShutdownButtonClick(Sender: TObject);
    procedure MainBackgroundRectMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  NotifyForm: TNotifyForm;

implementation

{$R *.fmx}

uses
  uMainForm;

procedure TNotifyForm.MainBackgroundRectMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  Self.StartWindowDrag;
end;

procedure TNotifyForm.ShutdownButtonClick(Sender: TObject);
begin
  if MainForm.PostPone=False then
    begin
      MainForm.CurrentCount := MainForm.CurrentCount-60;
      MainForm.PostPone := True;
    end;
  Self.Hide;
end;

end.
