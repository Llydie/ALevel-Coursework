unit PPlaceRoad;

interface

uses
Generics.Collections,
classes;

type

  TRoad = class
  protected
    Node: string; // name of node it connects to
    Weight: integer; // weight of the edge
  public
    constructor Create;
    destructor Destroy;
    procedure SetNode(NewNode:string);
    procedure SetWeight(NewWeight:integer);
    function Clone:TRoad;
    property GetName : string read Node;
    property GetWeight : integer read Weight;
  end;

  TPlace = class
  protected
    Name: string;
    Distance: integer; // distance from source node
    Parent: string;
  public
    Edges:  TObjectList<TRoad>; // Array of roads connecting to that place
    Neighbours: TList<string>; // Array of neighbouring nodes
    constructor Create;
    destructor Destroy;
    procedure SetName(NewName:string);
    procedure SetDist(NewDist:integer);
    procedure SetParent(NewParent:string);
    procedure AddEdge(Road:TRoad);
    procedure AddNeighbour(Place:string);
    procedure ClearEdges;
    procedure ClearNeighbours;
    function Clone:TPlace;
    property GetName : string read Name;
    property GetDist : integer read Distance;
    property GetParent : string read Parent;
  end;

implementation

{ TPlace }

procedure TPlace.AddEdge(Road: TRoad);
begin
self.Edges.Add(Road);
end;

procedure TPlace.AddNeighbour(Place: string);
begin
self.Neighbours.Add(Place);
end;

procedure TPlace.ClearEdges;
var
  i: Integer;
begin
self.Edges.Clear;
end;

procedure TPlace.ClearNeighbours;
var
  i: Integer;
begin
self.Neighbours.Clear;
end;

function TPlace.Clone: TPlace;
//creates a deep copy of the place
var
Copy:TPlace;
i,n:integer;
begin
Copy:=TPlace.Create;
Copy.SetName(self.GetName);
Copy.SetDist(self.GetDist);
Copy.SetParent(self.GetParent);
for i := 0 to self.Edges.Count -1 do
  begin
  Copy.Edges.Add(self.Edges.List[i].Clone)
  end;
for n := 0 to self.Neighbours.Count -1 do
  begin
  Copy.Neighbours.Add(self.Neighbours.List[n])
  end;
result:=Copy;
end;

constructor TPlace.Create;
//initialise null values and create lists
begin
self.Name := 'Null';
self.Distance := -1;
self.Parent := 'Null';
self.Edges := TObjectList<TRoad>.Create;
self.Neighbours := TList<string>.Create;
end;

destructor TPlace.Destroy;
begin
self.Free;
end;

procedure TPlace.SetDist(NewDist: integer);
begin
self.Distance := NewDist;
end;


procedure TPlace.SetName(NewName: string);
begin
self.Name := NewName;
end;


procedure TPlace.SetParent(NewParent: string);
begin
self.Parent := NewParent;
end;


{ TRoad }

function TRoad.Clone: TRoad;
//creates a deep copy of the road
var
Copy:TRoad;
begin
Copy:=TRoad.Create;
Copy.Node := self.Node;
Copy.Weight := self.Weight;
result:=Copy;
end;

constructor TRoad.Create;
//initialise null values
begin
self.Node := 'Null';
self.Weight := -1;
end;

destructor TRoad.Destroy;
begin
self.Free;
end;

procedure TRoad.SetNode(NewNode: string);
begin
self.Node := NewNode;
end;

procedure TRoad.SetWeight(NewWeight: integer);
begin
self.Weight := NewWeight;
end;

end.
