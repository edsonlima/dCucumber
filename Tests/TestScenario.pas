unit TestScenario;

interface

uses
  TestFramework, Classes, Scenario, ScenarioIntf, TestBaseClasses;

type
  TestTScenario = class(TParseContext)
  strict private
    FScenario: IScenario;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure ScenarioDeveriaSerInvalidoSeNaoPossuirAoMenosUmStep;
    procedure ScenarioDeveriaSerValidoSomenteSeStepsSaoValidos;
  end;

implementation

uses
  Step;

procedure TestTScenario.ScenarioDeveriaSerValidoSomenteSeStepsSaoValidos;
begin

end;

procedure TestTScenario.SetUp;
begin
  FScenario := TScenario.Create;
end;

procedure TestTScenario.TearDown;
begin
  FScenario := nil;
end;

procedure TestTScenario.ScenarioDeveriaSerInvalidoSeNaoPossuirAoMenosUmStep;
begin
  Specify.That(FScenario.Valid).Should.Be.False;
  FScenario.Steps.Add(TStep.Create);
  Specify.That(FScenario.Valid).Should.Be.True;
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TestTScenario.Suite);
end.

