unit Scenario;

interface

uses
  ScenarioIntf, Classes, dCucuberListIntf;

type
  TScenario = class(TInterfacedObject, IScenario)
  private
    FSteps: ICucumberList;
    FTitulo: string;
    function GetSteps: ICucumberList;
    function GetTitulo: string;
    procedure SetSteps(const Value: ICucumberList);
    procedure SetTitulo(const Value: string);
  public
    constructor Create;
    function Valid: Boolean;
    property Steps: ICucumberList read GetSteps write SetSteps;
    property Titulo: string read GetTitulo write SetTitulo;
  end;

implementation

uses
  dCucuberList;

constructor TScenario.Create;
begin
  FSteps := TCucumberList.Create;
  FSteps.ValidateFunction := function: Boolean
  begin
    Result := FSteps.Count > 0;
  end;
end;

function TScenario.GetSteps: ICucumberList;
begin
  Result := FSteps;
end;

function TScenario.GetTitulo: string;
begin
  Result := FTitulo;
end;

procedure TScenario.SetSteps(const Value: ICucumberList);
begin
  FSteps := Value;
end;

procedure TScenario.SetTitulo(const Value: string);
begin
  FTitulo := Value;
end;

function TScenario.Valid: Boolean;
begin
  Result := FSteps.Valid;
end;

end.
