unit PDijkstra;

interface

uses
  PPriorityQ, Sysutils, Generics.Collections, PPlaceRoad, Vcl.Dialogs;

type
  TDijkstra = class(TMinHeap)
  public
    function ShortestPath(s, d: string; Map: TObjectList<TPlace>)
      : TObjectList<TPlace>;
    function ReturnPath(List: TObjectList<TPlace>; Current, Source: string;
      Map: TObjectList<TPlace>): TObjectList<TPlace>;
  end;

implementation

{ TDijkstra }

function TDijkstra.ShortestPath(s, d: string; Map: TObjectList<TPlace>)
  : TObjectList<TPlace>;
// find shortest route between two points on a map
// s and d being the name of the source and destination vertex
// the function returns the min distance
// and prints the shortest path
var
  ShortestRoute: TObjectList<TPlace>; // holds vertices in shortest path
  i, idx, k: integer;
  Current, Neighbour: TPlace;
begin
  Current := TPlace.Create;
  Neighbour := TPlace.Create;
  ShortestRoute := TObjectList<TPlace>.Create;
  if not ContainsPlace(s, MinHeap) or not ContainsPlace(d, MinHeap) then
  // check if source or destination has been removed
  begin
    result := nil;
  end
  else
  begin
    for k := 0 to Count - 1 do // loops through MinHeap
    begin
      if MinHeap.List[k].GetName <> s then
      // Initialise all non source vertices to a distance of 1000
      begin
        MinHeap.List[k].SetDist(1000);
        Update(1000, MinHeap.Items[k].GetName, '', Map);
      end
      else
      begin
        MinHeap.List[k].SetDist(0);
        // Initialise the source vertex to a distance of 0
        MinHeap.List[k].SetParent(s);
        GetPlace(MinHeap.List[k].GetName, Map).SetDist(0);
        GetPlace(MinHeap.List[k].GetName, Map).SetParent(s);
      end;
    end;
    Build_Heap; // Initialise the heap
    extract_mini(Current);
    // extract the neighbouring vertex with lowest distance
    while Current.GetName <> d do
    // loop until the destination vertex is reached
    begin
      for i := 0 to (Current.edges.Count) - 1 do
      // loop through neighbouring edges
      begin
        Neighbour := GetPlace(Current.Neighbours[i], Map);
        if (Current.edges[i].GetWeight + Current.GetDist < Neighbour.GetDist)
          and ContainsPlace(Neighbour.GetName, MinHeap) then
        // check if new distance to neighbour is less than the current distance to neighbour
        begin
          idx := FindIndex(Neighbour);
          Neighbour.SetParent(Current.GetName);
          DecreaseKey(idx, Current.edges[i].GetWeight + Current.GetDist);
          // Decrease distance of Neighbour in MinHeap
          Update(Current.edges[i].GetWeight + Current.GetDist,
            Current.Neighbours[i], Current.GetName, Map);
          // Updates the distance in all instances of the objects
        end;
      end;
      extract_mini(Current);
    end;
    result := ReturnPath(ShortestRoute, d, s, Map);
    // return the Shortest Route list
  end;
end;

function TDijkstra.ReturnPath(List: TObjectList<TPlace>;
  Current, Source: string; Map: TObjectList<TPlace>): TObjectList<TPlace>;
// Recurses through the parents of the shortest path and outputs the Shortest Path in a list
// Starts at the Destination and works backwards using parents
begin
  if Current = Source then // check whether it has reached the source
  begin
    List.Add(GetPlace(Current, Map)); // add to list
  end
  else
  begin
    ReturnPath(List, GetPlace(Current, Map).GetParent, Source, Map);
    // use current places' parent for each recursive call
    List.Add(GetPlace(Current, Map));
    // add current to list as it unwinds the recursion
  end;
  result := List;
end;

end.
