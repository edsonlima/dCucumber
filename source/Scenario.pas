unit Scenario;

interface

uses
  ScenarioIntf, Classes, dCucuberListIntf, ValidationRuleIntf;

type
  TScenario = class(TInterfacedObject, IScenario, IValidationRule)
  private
    FSteps: ICucumberList;
    FTitulo: string;
    FValidationRule: IValidationRule;
    function GetSteps: ICucumberList;
    function GetTitulo: string;
    function GetValidationRule: IValidationRule;
    procedure SetSteps(const Value: ICucumberList);
    procedure SetTitulo(const Value: string);
    procedure SetValidationRule(const Value: IValidationRule);
  public
    constructor Create;
    property ValidationRule: IValidationRule read GetValidationRule write SetValidationRule implements IValidationRule;
    property Steps: ICucumberList read GetSteps write SetSteps;
    property Titulo: string read GetTitulo write SetTitulo;
  end;

implementation

uses
  dCucuberList, StepIntf, ValidationRule, TypeUtils;

constructor TScenario.Create;
begin
  FSteps := TCucumberList.Create;
  FSteps.ValidationRule.ValidateFunction := function: Boolean
  var i: Integer;
  begin
    Result := FSteps.Count > 0;
    for I := 0 to FSteps.Count - 1 do
    begin
      Result := Result and (FSteps[i] as IStep).ValidationRule.Valid;
      if not Result then
        Break;
    end;
  end;

  ValidationRule.ValidateFunction := function: Boolean
  begin
    Result := not S(FTitulo).Vazia;
    Result := Result and FSteps.ValidationRule.Valid;
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

function TScenario.GetValidationRule: IValidationRule;
begin
  if FValidationRule = nil then
    FValidationRule := TValidationRule.Create;
  Result := FValidationRule;
end;

procedure TScenario.SetSteps(const Value: ICucumberList);
begin
  FSteps := Value;
end;

procedure TScenario.SetTitulo(const Value: string);
begin
  FTitulo := Value;
end;

procedure TScenario.SetValidationRule(const Value: IValidationRule);
begin
  FValidationRule := Value;
end;

end.
