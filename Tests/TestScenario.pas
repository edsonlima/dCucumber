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
    procedure DeveriaSerInvalidoSeNaoPossuirAoMenosUmStepValido;
    procedure DeveriaSerValidoSomenteSeStepsSaoValidos;
    procedure DeveriaSerInvalidoSeNaoPossuiTitulo;
    procedure DeveriaSerValidoSePossuirUmaClasseDeTesteAssociadaAoTitulo;
    procedure DeveriaRetornarONomeDaClasseDeTesteCorretamente;
    procedure DeveriaSerInvalidoSeNaoPossuiTestesAssociadosAosSteps;
  end;

implementation

uses
  Step, StepIntf, ValidationRuleIntf, DummyTests;

procedure TestTScenario.DeveriaSerValidoSomenteSeStepsSaoValidos;
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

procedure TestTScenario.DeveriaSerValidoSePossuirUmaClasseDeTesteAssociadaAoTitulo;
var
  LCenarioValidoSuite: ITestSuite;
begin
  LCenarioValidoSuite := TUmCenarioValido.Suite;
  RegisterTest(LCenarioValidoSuite);
  FScenario.Titulo := 'Um Cenário Valido';
  FScenario.Steps.Add(TStep.Create);
  (FScenario.Steps.First as IStep).Descricao := 'Dado que tenho um step valido';
  Specify.That(FScenario.TestSuite).Should.Not_.Be.Nil_;
  Specify.That((FScenario as IValidationRule).Valid).Should.Be.True;
  RegisteredTests.Tests.Remove(LCenarioValidoSuite);
end;

procedure TestTScenario.DeveriaSerInvalidoSeNaoPossuiTitulo;
begin
  FScenario.Steps.Add(TStep.Create);
  (FScenario.Steps.First as IStep).Descricao := 'Dado que tenho um step valido';
  Specify.That((FScenario as IValidationRule).Valid).Should.Be.False;
end;

procedure TestTScenario.DeveriaSerInvalidoSeNaoPossuiTestesAssociadosAosSteps;
var
  LCenarioValido: ITestSuite;
  LStep: IStep;
begin
  LCenarioValido := TUmCenarioInvalido.Suite;
  RegisterTest(LCenarioValido);
  FScenario.Titulo := 'Um Cenário Invalido';
  FScenario.Steps.Add(TStep.Create);
  LStep := (FScenario.Steps.First as IStep);
  LStep.Descricao := 'Dado que tenho um step valido.';
  Specify.That(FScenario.TestSuite).Should.Not_.Be.Nil_;
  Specify.That((FScenario as IValidationRule).Valid).Should.Be.False;
  Specify.That(FScenario.TestSuite.Tests).Should.Not_.Be.Empty;

  RegisteredTests.Tests.Remove(LCenarioValido);
end;

procedure TestTScenario.DeveriaRetornarONomeDaClasseDeTesteCorretamente;
begin
  FScenario.Titulo := 'Um Cenário Valido';
  Specify.That(FScenario.TestName).Should.Equal('TUmCenarioValido');
end;

procedure TestTScenario.DeveriaSerInvalidoSeNaoPossuirAoMenosUmStepValido;
var
  LCenarioValido: ITestSuite;
begin
  LCenarioValido := TUmCenarioValido.Suite;
  RegisterTest(LCenarioValido);
  FScenario.TestSuite;
  FScenario.Titulo := 'Um Cenário Valido';
  FScenario.Steps.Add(TStep.Create);
  (FScenario.Steps.First as IStep).Descricao := 'Dado que tenho um step valido';
  Specify.That((FScenario as IValidationRule).Valid).Should.Be.True;
  RegisteredTests.Tests.Remove(LCenarioValido);
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TestTScenario.Suite);
end.

