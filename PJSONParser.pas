unit PJSONParser;

interface

uses
  Sysutils,
  classes,
  System.JSON.Builders,
  System.JSON.Readers,
  System.Rtti,
  Generics.Collections,
  PPlaceRoad;

type

  TMap = class
  protected
    AdjacencyList: TObjectList<TPlace>;
    Map: TextFile;
  public
    constructor Create;
    procedure Parse(MapName:string);
    procedure Print;
    procedure Clear;
    function ReturnList: TObjectList<TPlace>;
    destructor Destroy;
  end;

implementation
{ TMap }

procedure TMap.Clear;
begin
AdjacencyList.Clear;
end;

constructor TMap.Create;
//initialse the list
begin
  AdjacencyList := TObjectList<TPlace>.Create(true);
end;

destructor TMap.Destroy;
begin
AdjacencyList.Free;
end;

procedure TMap.Parse(MapName:string);
//Creates an adjacency list from a given JSON map file
var
  Iterator: TJSONIterator;
  Reader: TJSONTextReader;
  StringReader: TStringReader;
  MapData, ALine: string;
  i,n,NumberEdges,c,NumberVertices: integer;
  TempPlace: TPlace;
  TempRoad: TRoad;
begin
  MapData := '';
  AssignFile(Map, MapName);
  reset(Map);
  while not eof(Map) do
  begin
    readln(Map, ALine);
    MapData := MapData + ALine + sLineBreak ; //create a formatted string of JSON
  end;
  StringReader := TStringReader.Create(MapData); //Initialsing JSON reader
  Reader := TJSONTextReader.Create(StringReader); // requires text reader type
  Iterator := TJSONIterator.Create(Reader);
  Iterator.Recurse; //prep to enter object
  Iterator.Next;
  Iterator.Recurse; //enter vertices object
  Iterator.Recurse;
  Iterator.Next; //enter array
  Iterator.Recurse;
  Iterator.Next; //enter first object in array
  NumberVertices := Iterator.AsInteger;
  for i := 0 to NumberVertices -1 do    //for the number of places in the map
  begin
    tempPlace := TPlace.Create; //dynamically create a TPlace
    Iterator.Return; //return to array
    Iterator.Recurse;
    Iterator.Next;   //go to next object in array
    Iterator.Recurse;
    Iterator.Next;   //enter object
    TempPlace.SetName(Iterator.AsString); //read the name into TempPlace
    Iterator.Next; //go to next key-value pair within the object
    TempPlace.SetDist(Iterator.AsInteger); //read the distance
    Iterator.Next;
    Iterator.Recurse; //prep to enter edges array
    Iterator.Next;
    Iterator.Recurse; //enter edges array
    Iterator.Next;
    NumberEdges:=Iterator.AsInteger; //read the number of edges
    for n := 0 to NumberEdges -1 do  //for the number of edges of the place
    begin
      TempRoad := TRoad.Create; //dynamincally create a TRoad
      Iterator.Return; //return to edges array
      Iterator.Recurse;
      Iterator.Next;
      Iterator.Recurse; //go to next key-value pair in the array
      Iterator.Next;
      TempRoad.SetNode(Iterator.AsString); //read the name of the node
      Iterator.Next;
      TempRoad.SetWeight(Iterator.AsInteger); //read the weight
      TempPlace.AddEdge(tempRoad); //add TempRoad to TempPlace
    end;
    Iterator.Return; //return to edges array
    Iterator.Recurse;
    Iterator.Next;
    Iterator.Return; //return to object
    Iterator.Recurse;
    Iterator.Next;
    Iterator.Recurse; //prep to enter neighbours array
    Iterator.Next;
    for c := 0 to NumberEdges -1 do //for the number of neighbouring place
    begin
      Iterator.Recurse; //go to next key-value pair
      Iterator.Next;
      TempPlace.AddNeighbour(Iterator.AsString); //read the name
      Iterator.Return; //return to neighbours array
      Iterator.Recurse;
      Iterator.Next;
    end;
    Iterator.Return; //return to the object
    Iterator.Recurse;
    Iterator.Next; //reached the end of the object, prep to enter next object
    AdjacencyList.Add(TempPlace); //add fully build TempPlace to the list
  end;
end;

procedure TMap.Print;
//prints the contents of the list, for debugging use
var
I,n,c:integer;
begin
writeln(' ');
writeln('Contents of AdjacencyList: ');
for I := 0 to AdjacencyList.Count-1 do
  begin
    writeln(' ');
    writeln('Place: ' ,AdjacencyList[I].GetName);
    writeln('Edges: ');
    for n :=0 to AdjacencyList[I].Edges.Count -1 do
    begin
      writeln('  Node: ', AdjacencyList[I].Edges[n].GetName, ' Weight: ', AdjacencyList[I].Edges[n].GetWeight);
    end;
    writeln('Current Distance from source: ' ,AdjacencyList[I].GetDist);
    for c := 0 to AdjacencyList[I].Neighbours.Count -1 do
      begin
        writeln('Neighbours: ', AdjacencyList[I].Neighbours[c]);
      end;
  end;

end;


function TMap.ReturnList: TObjectList<TPlace>;
//perform deep copy of list
var
Copy:TObjectList<TPlace>;
i:integer;
begin
Copy := TObjectList<TPlace>.Create(False);
for i := 0 to AdjacencyList.Count -1 do
begin
  Copy.Add(AdjacencyList.List[i].Clone);
end;
result:=Copy;
end;

end.
