unit PGUI;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Menus, PPlaceRoad,
  PJSONParser, PPriorityQ,
  PDijkstra, Generics.Collections;

type
  TMainForm = class(TForm)
    MapCombo: TComboBox;
    MapLabel: TLabel;
    TitleLabel: TLabel;
    StartLabel: TLabel;
    DestLabel: TLabel;
    RouteBox: TListBox;
    MainMenu: TMainMenu;
    Menu: TMenuItem;
    New: TMenuItem;
    CalculateButton: TButton;
    AddLabel: TLabel;
    AddButton: TButton;
    RemoveLabel: TLabel;
    RemoveButton: TButton;
    MenuExit: TMenuItem;
    StartCombo: TComboBox;
    DestCombo: TComboBox;
    AddCombo: TComboBox;
    RemoveCombo: TComboBox;
    procedure CalculateButtonClick(Sender: TObject);
    procedure MapComboChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure NewClick(Sender: TObject);
    procedure AddButtonClick(Sender: TObject);
    procedure RemoveButtonClick(Sender: TObject);
    procedure MenuExitClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  LoadMap: TMap;
  Route: TDijkstra;

implementation

{$R *.dfm}

procedure TMainForm.AddButtonClick(Sender: TObject);
// adds a place to the map (providing it was already in the map before removal)
begin
  if MapCombo.Text = 'Please Select a Map' then
    ShowMessage('Please choose a map')
  else
  begin
  Route.Insert(AddCombo.Items[AddCombo.ItemIndex], LoadMap.ReturnList);
  RemoveCombo.AddItem(AddCombo.Items[AddCombo.ItemIndex], nil);
  AddCombo.Items.Delete(AddCombo.ItemIndex);
  AddCombo.Text := 'Please Select';
  end;
end;

procedure TMainForm.CalculateButtonClick(Sender: TObject);
// Prints the calculated shortest path and distance when the button is clicked
var
  ShortestPath: TObjectList<TPlace>;
  i,n: Integer;
begin
  if MapCombo.Text = 'Please Select a Map' then
    ShowMessage('Please choose a map')
  else
  begin
  ShortestPath := TObjectList<TPlace>.Create;
  ShortestPath := Route.ShortestPath(StartCombo.Items[StartCombo.ItemIndex],
    DestCombo.Items[DestCombo.ItemIndex], LoadMap.ReturnList);
  if ShortestPath = nil then
    RouteBox.Items.Add('No Shortest Route Available')
  else
  begin
    RouteBox.Items.Add('Shortest Route: ');
    for i := 0 to ShortestPath.Count - 1 do
    begin
      RouteBox.Items.Add(ShortestPath.Items[i].GetName);
    end;
    RouteBox.Items.Add('Shortest Distance: ' +
      inttostr(ShortestPath.Items[ShortestPath.Count - 1].GetDist));
    RouteBox.Items.Add('');
  end;
  Route := TDijkstra.Create(LoadMap.ReturnList); //preps for next button click
  if AddCombo.Items.Count > 0 then
    begin
    for n := 0 to AddCombo.Items.Count -1 do
      Route.RemovePlace(AddCombo.Items[n],LoadMap.ReturnList);
    end;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  LoadMap := TMap.Create;
  MapCombo.AddItem('TestMap2', nil);
  MapCombo.AddItem('Scotland', nil);
  MapCombo.AddItem('LondonTube', nil);
end;

procedure TMainForm.MapComboChange(Sender: TObject);
// Loads the correct map when the user selects one
var
  MapName: string;
  i: Integer;
begin
  MapName := '';
  NewClick(self);
  MapName := MapCombo.Items[MapCombo.ItemIndex];
  LoadMap.Parse(MapName + '.json');
  for i := 0 to LoadMap.ReturnList.Count - 1 do
  begin
    StartCombo.AddItem(LoadMap.ReturnList.Items[i].GetName, nil);
    DestCombo.AddItem(LoadMap.ReturnList.Items[i].GetName, nil);
    RemoveCombo.AddItem(LoadMap.ReturnList.Items[i].GetName, nil);
  end;
  Route := TDijkstra.Create(LoadMap.ReturnList);
end;

procedure TMainForm.MenuExitClick(Sender: TObject);
// frees objects
begin
  Route.Destroy;
  LoadMap.Destroy;
  MainForm.DestroyWnd;
end;

procedure TMainForm.NewClick(Sender: TObject);
// clears the edits and boxes
begin
  LoadMap.Clear;
  RouteBox.Clear;
  AddCombo.Items.Clear;
  RemoveCombo.Items.Clear;
  StartCombo.Items.Clear;
  DestCombo.Items.Clear;
  StartCombo.Text := 'Please Select';
  DestCombo.Text := 'Please Select';
  MapCombo.Text := 'Please Select Map';
  RemoveCombo.Text := 'Please Select';
  AddCombo.Text := 'Please Select';
end;

procedure TMainForm.RemoveButtonClick(Sender: TObject);
// removes a place from the map (providing that it exists in the map)
begin
  if MapCombo.Text = 'Please Select a Map' then
    ShowMessage('Please choose a map')
  else
  begin
  Route.RemovePlace(RemoveCombo.Items[RemoveCombo.ItemIndex],
    LoadMap.ReturnList);
  AddCombo.AddItem(RemoveCombo.Items[RemoveCombo.ItemIndex], nil);
  RemoveCombo.Items.Delete(RemoveCombo.ItemIndex);
  RemoveCombo.Text := 'Please Select';
  end;
end;

end.
