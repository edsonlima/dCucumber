unit Scenario;

interface

uses
  ScenarioIntf, Classes;

type
  TScenario = class(TInterfacedObject, IScenario)
  private
    FSteps: IInterfaceList;
    FTitulo: string;
    function GetSteps: IInterfaceList;
    function GetTitulo: string;
    procedure SetSteps(const Value: IInterfaceList);
    procedure SetTitulo(const Value: string);
  public

    constructor Create;
    function Valid: Boolean;
    property Steps: IInterfaceList read GetSteps write SetSteps;
    property Titulo: string read GetTitulo write SetTitulo;
  end;

implementation

constructor TScenario.Create;
begin
  FSteps := TInterfaceList.Create;
end;

function TScenario.GetSteps: IInterfaceList;
begin
  Result := FSteps;
end;

function TScenario.GetTitulo: string;
begin
  Result := FTitulo;
end;

procedure TScenario.SetSteps(const Value: IInterfaceList);
begin
  FSteps := Value;
end;

procedure TScenario.SetTitulo(const Value: string);
begin
  FTitulo := Value;
end;

function TScenario.Valid: Boolean;
begin
  Result := FSteps.Count > 0;
end;

end.
