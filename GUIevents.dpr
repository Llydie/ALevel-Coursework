program GUIevents;

uses
  Vcl.Forms,
  PDijkstra in 'PDijkstra.pas',
  PGUI in 'PGUI.pas' {MainForm},
  PJSONParser in 'PJSONParser.pas',
  PPlaceRoad in 'PPlaceRoad.pas',
  PPriorityQ in 'PPriorityQ.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
