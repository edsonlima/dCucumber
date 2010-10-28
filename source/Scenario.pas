unit Scenario;

interface

uses
  ScenarioIntf, Classes, dCucuberListIntf, ValidationRuleIntf, TestFramework, StepIntf;

type
  TScenario = class(TInterfacedObject, IScenario, IValidationRule)
  private
    FSteps: ICucumberList;
    FTestSuite: ITestSuite;
    FTitulo: string;
    FValidationRule: IValidationRule;
    function GetSteps: ICucumberList;
    function GetTestName: string;
    function GetTestSuite: ITestSuite;
    function GetTitulo: string;
    function GetValidationRule: IValidationRule;
    procedure SetSteps(const Value: ICucumberList);
    procedure SetTitulo(const Value: string);
    procedure SetValidationRule(const Value: IValidationRule);
    function HasTestMethodFor(const AStep: IStep): Boolean;
  public
    constructor Create;

    property ValidationRule: IValidationRule read GetValidationRule write SetValidationRule implements IValidationRule;
    property Steps: ICucumberList read GetSteps write SetSteps;
    property Titulo: string read GetTitulo write SetTitulo;
    property TestSuite: ITestSuite read GetTestSuite;
    property TestName: string read GetTestName;
  end;

implementation

uses
  dCucuberList, ValidationRule, TypeUtils;

constructor TScenario.Create;
begin
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
    Result := not S(FTitulo).Vazia;
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

function TScenario.GetTestSuite: ITestSuite;
var
  I: Integer;
  LTestName: string;
begin
  if (FTestSuite = nil) then
  begin
    LTestName := TestName;
    for I := 0 to RegisteredTests.Tests.Count - 1 do
      if (RegisteredTests.Tests[i] as ITestSuite).Name = LTestName then
        FTestSuite := RegisteredTests.Tests[i] as ITestSuite;
  end;
  Result := FTestSuite;
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

function TScenario.HasTestMethodFor(const AStep: IStep): Boolean;
var
  I: Integer;
  LTest: ITest;
begin
  Result := False;
  if TestSuite <> nil then
    for I := 0 to TestSuite.Tests.Count - 1 do
    begin
      LTest := TestSuite.Tests[i] as ITest;
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
