unit Scenario;

interface

uses
  ScenarioIntf, Classes, dCucuberListIntf, ValidationRuleIntf, TestFramework, StepIntf;

type
  TScenario = class(TTestCase, IScenario, IValidationRule)
  private
    FSteps: ICucumberList;
    FTitulo: string;
    FValidationRule: IValidationRule;
    function GetSteps: ICucumberList;
    function GetTestName: string;
    function GetTitulo: string;
    function GetValidationRule: IValidationRule;
    procedure SetSteps(const Value: ICucumberList);
    procedure SetTitulo(const Value: string);
    procedure SetValidationRule(const Value: IValidationRule);
    class function HasTestMethodFor(const AStep: IStep): Boolean;
  public
    constructor Create(MethodName: string); override;
    property ValidationRule: IValidationRule read GetValidationRule write SetValidationRule implements IValidationRule;
    property Steps: ICucumberList read GetSteps write SetSteps;
    property Titulo: string read GetTitulo write SetTitulo;
    property TestName: string read GetTestName;
  end;

implementation

uses
  dCucuberList, ValidationRule, TypeUtils;

constructor TScenario.Create(MethodName: string);
begin
  inherited Create(MethodName);
  FSteps := TCucumberList.Create;
  FSteps.ValidationRule.ValidateFunction := function: Boolean
  var
    i: Integer;
    LStep: IStep;
  begin
    Result := FSteps.Count > 0;
    for I := 0 to FSteps.Count - 1 do
    begin
      LStep := (FSteps[i] as IStep);
      Result := Result and LStep.ValidationRule.Valid;
      Result := Result and HasTestMethodFor(LStep);
      if not Result then
        Break;
    end;
  end;

  ValidationRule.ValidateFunction := function: Boolean
  begin
    Result := not S(FTitulo).IsEmpty(True);
    Result := Result and FSteps.ValidationRule.Valid;
  end;
end;

function TScenario.GetSteps: ICucumberList;
begin
  Result := FSteps;
end;

function TScenario.GetTestName: string;
begin
  Result := S(FTitulo).AsClassName;
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

class function TScenario.HasTestMethodFor(const AStep: IStep): Boolean;
var
  I: Integer;
  LTest: ITest;
begin
  Result := False;
  if Suite.Tests.Count > 0 then
    for I := 0 to Suite.Tests.Count - 1 do
    begin
      LTest := Suite.Tests[i] as ITest;
      Result := S(LTest.Name).Equals(AStep.MetodoDeTeste);
      if Result then
        Break;
    end;
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
