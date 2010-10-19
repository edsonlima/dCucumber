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
    procedure ScenarioDeveriaSerInvalidoSeNaoPossuirAoMenosUmStepValido;
    procedure ScenarioDeveriaSerValidoSomenteSeStepsSaoValidos;
    procedure ScenarioDeveriaSerInvalidoSeNaoPossuiTitulo;
  end;

implementation

uses
  Step, StepIntf, ValidationRuleIntf;

procedure TestTScenario.ScenarioDeveriaSerValidoSomenteSeStepsSaoValidos;
begin
  FScenario.Steps.Add(TStep.Create);
  Specify.That((FScenario as IValidationRule).Valid).Should.Be.False;
end;

procedure TestTScenario.SetUp;
begin
  FScenario := TScenario.Create;
end;

procedure TestTScenario.TearDown;
begin
  FScenario := nil;
end;

procedure TestTScenario.ScenarioDeveriaSerInvalidoSeNaoPossuiTitulo;
begin
  FScenario.Steps.Add(TStep.Create);
  (FScenario.Steps.First as IStep).Descricao := 'Dado que tenho um step valido';
  Specify.That((FScenario as IValidationRule).Valid).Should.Be.False;
end;

procedure TestTScenario.ScenarioDeveriaSerInvalidoSeNaoPossuirAoMenosUmStepValido;
begin
  FScenario.Titulo := 'Um Cenário Valido';
  FScenario.Steps.Add(TStep.Create);
  (FScenario.Steps.First as IStep).Descricao := 'Dado que tenho um step valido';
  Specify.That((FScenario as IValidationRule).Valid).Should.Be.True;
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TestTScenario.Suite);
end.

