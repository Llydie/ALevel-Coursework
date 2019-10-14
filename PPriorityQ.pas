unit PPriorityQ;

interface

uses
  sysutils, Generics.Collections, PPlaceRoad,Vcl.Dialogs;

type
  TMinHeap = class
  protected
    MinHeap: TObjectList<TPlace>; // list of TPlace
    function GetCount: integer;
  public
    constructor Create(List: TObjectList<TPlace>);
    destructor Destroy;
    procedure Build_Heap;
    procedure Print;
    procedure BubbleUp(i,n: integer);
    procedure DecreaseKey(v: integer; new: integer);
    procedure Update(newDist: integer; name,NewParent: string;Map: TObjectList<TPlace>);
    procedure extract_mini(u: TPlace);
    procedure Insert(Name:string;Map:TObjectList<TPlace>);
    procedure RemovePlace(Name:string;Map:TObjectList<TPlace>);
    function ContainsPlace(Place:string;List:TObjectList<TPlace>):boolean;
    function GetPlace(name: string;Map: TObjectList<TPlace>): TPlace;
    function FindIndex(p: TPlace): integer;
    function isEmpty: boolean;
    property Count: integer read GetCount;

  end;

implementation

{ TMinHeap }

procedure TMinHeap.Insert(Name:string;Map:TObjectList<TPlace>);
//inserts a place into the correct place in the heap
var
i:integer;
begin
  if not ContainsPlace(Name,MinHeap) then
  begin
    MinHeap.Add(GetPlace(Name,Map));
    for i := 0 to Map.Count-1 do
    begin
    if (Map.Items[i].Neighbours.Count =1) and (Map.Items[i].Neighbours[0] = Name) then
    //check if the place has orphaned any other places that need to be added again
      MinHeap.Add(GetPlace(Map.Items[i].GetName,Map));
    end;
    Build_Heap;
  end
  else
    Showmessage('Place is already in the map or does not exist');
end;

function TMinHeap.isEmpty: boolean;
//checks and returns whether the heap is empty
begin
  if MinHeap.Count = 0 then
    result := true
  else
    result := false;
end;

procedure TMinHeap.Build_Heap;
//Builds the heap by reordering it
var
  n, i: integer;
begin
  n := Count;
  for i := (n - 1) div 2 downto 0 do
    BubbleUp(i, n);
end;

function TMinHeap.ContainsPlace(Place:string;List:TObjectList<TPlace>):boolean;
var
i:integer;
begin
result:=false;
for i := 0 to List.Count -1 do
begin
  if List.Items[i].GetName = Place then
  begin
    result := True;
  end;
end;
end;

constructor TMinHeap.Create(List: TObjectList<TPlace>);
var
  i: Integer;
// initialises and fills the list
begin
  MinHeap := TObjectList<TPlace>.Create(true);
  for i := 0 to List.Count -1 do
  begin
    MinHeap.Add(List.List[i]);
  end;
  Build_Heap;
end;

procedure TMinHeap.DecreaseKey(v: integer; new: integer);
// Decreases the distance value of an item in the list
begin
  if new > MinHeap.Items[v].GetDist then
    showmessage('Error: new key value too large');
  MinHeap.List[v].SetDist(new);
  Build_Heap; //maintain MinHeap order
end;

destructor TMinHeap.Destroy;
// frees list after use
begin
MinHeap.free;
end;

procedure TMinHeap.extract_mini(u: TPlace);
// deletes and returns the TPlace with minimum distance from the source
var
  n, i, c, m: integer;
begin
  u.ClearEdges;
  u.ClearNeighbours;
  u.SetName(MinHeap.Items[0].GetName);  //sets up u as the minimum place
  u.SetDist(MinHeap.Items[0].GetDist);
  for c := 0 to (MinHeap.Items[0].Edges.Count) - 1 do
    u.AddEdge(MinHeap.Items[0].Edges[c]);
  for m := 0 to (MinHeap.Items[0].Neighbours.Count) - 1 do
    u.AddNeighbour(MinHeap.Items[0].Neighbours[m]);
  MinHeap.Exchange(0, Count - 1); //swaps first and last items
  MinHeap.Delete(Count - 1); //deletes last item
  n := Count;
  for i := 0 to (n - 1) div 2 do
    BubbleUp(i, n);  //Keep the queue in correct MinHeap form
end;

function TMinHeap.FindIndex(p: TPlace): integer;
// Finds the index of an item in the list
var
  i: integer;
begin
  for i := 0 to Count - 1 do
  begin
    if MinHeap[i].GetName = p.GetName then
     begin
      result := i;
      exit
     end
    else
    begin
      result := -1; // return null if the item is not found
    end;
  end;
  if result = -1 then
    ShowMessage('Error: Item not in list, returned Nil');  //raise error

end;

function TMinHeap.GetCount: integer;
// returns the number of items in the list
begin
  result := MinHeap.Count;
end;

function TMinHeap.GetPlace(name: string; Map: TObjectList<TPlace>): TPlace;
// takes in the name of a place and returns that place from the Map
var
  i: integer;
begin
  for i := 0 to Map.Count -1 do // loop through array to find it
  begin
    if Map.Items[i].GetName = Name then
    begin
      result := Map.Items[i];
      exit
    end
    else
    begin
      result := nil; // return nil if it is not found
    end;
  end;
  if result = nil then
    ShowMessage('GetPlace Error: Item not in list, returned Nil'); //raise error
end;

procedure TMinHeap.BubbleUp(i, n: integer);
// Corrects the order of the heap to keep it as a min heap by moving items up
// builds it in terms of distance from the source vertex
var
  left, right, smallest: integer;
begin
  left := 2 * i + 1; // Find Left Child for list indexed from 0
  right := 2 * i + 2; // Find Right Child for list indexed from 0
  smallest := i;
  if (left < n) then
  begin
    if (MinHeap[left].GetDist < MinHeap[i].GetDist) then
      smallest := MinHeap.Indexof(MinHeap[left]);
      // check whether left child is smallest
  end;
  if (right < n) then
  begin
    if (MinHeap[right].GetDist < MinHeap[smallest].GetDist) then
      smallest := MinHeap.Indexof(MinHeap[right]);
    // check whether right child is smallest
  end;
  if smallest <> i then
  begin
    MinHeap.Exchange(i, smallest); // swap positions of current smallest and i
    BubbleUp(smallest, n); // recurse until smallest = i
                          // i.e neither left or right is smaller
  end;
end;

procedure TMinHeap.Print;
// Print function for debugging use
var
  i, n, c: integer;
begin
writeln('MinHeap: ');
  for i := 0 to MinHeap.Count - 1 do
  begin
    writeln('Place: ', MinHeap[i].GetName);
    writeln('Edges: ');
    for n := 0 to MinHeap[i].Edges.Count - 1 do
    begin
      writeln('  Node: ', MinHeap[i].Edges[n].GetName, ' Weight: ',
        MinHeap[i].Edges[n].GetWeight);
    end;
    writeln('Current Distance from source: ', MinHeap[i].GetDist);
    for c := 0 to MinHeap[i].Neighbours.Count - 1 do
    begin
      writeln('Neighbours: ', MinHeap[i].Neighbours[c]);
    end;
    writeln(' ');
  end;
writeln(' ');
end;

procedure TMinHeap.RemovePlace(Name: string; Map: TObjectList<TPlace>);
var
Place:TPlace;
Index,i:integer;
begin
if ContainsPlace(Name,MinHeap) then
  begin
  Place:= GetPlace(Name,Map);
  Index := FindIndex(Place);
  MinHeap.Delete(Index);
  for i := 0 to Count-1 do
  begin
    if (MinHeap.Items[i].Neighbours.Count =1) and (MinHeap.Items[i].Neighbours[0] = Name) then
      MinHeap.Delete(i);
  end;
  for i := 0 to (Count - 1) div 2 do
    BubbleUp(i, Count);  //Keep the queue in correct MinHeap form
  end
  else
    Showmessage('Place is not in the map or does not exist');
end;

procedure TMinHeap.Update(NewDist: integer; name,NewParent: string;Map: TObjectList<TPlace>);
//Updates the distance value for all neighbouring places in MinHeap and Map
var
  i, n: integer;
begin
  for i := 0 to GetCount - 1 do
  begin
    for n := 0 to MinHeap.Items[i].Neighbours.Count - 1 do
    begin
      if name = MinHeap.Items[i].Neighbours[n] then
      begin
        GetPlace(MinHeap.List[i].Neighbours[n],Map).SetDist(NewDist);
        GetPlace(MinHeap.List[i].Neighbours[n],Map).SetParent(NewParent);
      end;
    end;
  end;
  for i := 0 to Map.Count -1 do
    begin
    for n := 0 to Map.Items[i].Neighbours.Count - 1 do
    begin
      if name = Map.Items[i].Neighbours[n] then
      begin
        GetPlace(Map.List[i].Neighbours[n],Map).SetDist(NewDist);
        GetPlace(Map.List[i].Neighbours[n],Map).SetParent(NewParent);
      end;
    end;
  end;

end;

end.
