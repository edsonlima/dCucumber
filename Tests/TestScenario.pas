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
  Step, StepIntf, ValidationRuleIntf, DummyTests, SysUtils;

procedure TestTScenario.DeveriaSerValidoSomenteSeStepsSaoValidos;
begin
  FScenario.Steps.Add(TStep.Create);
  Specify.That((FScenario as IValidationRule).Valid).Should.Be.False;
end;

procedure TestTScenario.SetUp;
var
  LTest: ITest;
begin
//  FScenario := TUmCenarioValido.Create('');
//  LTest := TUmCenarioValido.Suite as ITest;
  LTest := TUmCenarioValido.Suite;
  FScenario := LTest.Tests[0] as IScenario;
//  FScenario := TUmCenarioValido.Create('DadoQueTenhoUmStepValido');
//  FScenario := TUmCenarioValido.Suite as IScenario;
end;

procedure TestTScenario.TearDown;
begin
  FScenario := nil;
end;

procedure TestTScenario.DeveriaSerValidoSePossuirUmaClasseDeTesteAssociadaAoTitulo;
begin
  FScenario.Titulo := 'Um Cenário Valido';
  FScenario.Steps.Add(TStep.Create);
  (FScenario.Steps.First as IStep).Descricao := 'Dado que tenho um step valido';
  Specify.That((FScenario as IValidationRule).Valid).Should.Be.True;
end;

procedure TestTScenario.DeveriaSerInvalidoSeNaoPossuiTitulo;
begin
  FScenario.Steps.Add(TStep.Create);
  (FScenario.Steps.First as IStep).Descricao := 'Dado que tenho um step valido';
  Specify.That((FScenario as IValidationRule).Valid).Should.Be.False;
end;

procedure TestTScenario.DeveriaSerInvalidoSeNaoPossuiTestesAssociadosAosSteps;
var
  LStep: IStep;
begin
  FScenario := nil;
  FScenario := (TUmCenarioInvalido.Suite.Tests[0] as IScenario);
  FScenario.Titulo := 'Um Cenário Invalido';
  FScenario.Steps.Add(TStep.Create);
  LStep := (FScenario.Steps.First as IStep);
  LStep.Descricao := 'Dado que tenho um step valido.';
  Specify.That((FScenario as IValidationRule).Valid).Should.Be.False;
  Specify.That((FScenario as ITest).Tests).Should.Not_.Be.Empty;
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
//  RegisterTest(LCenarioValido);
//  FScenario.TestSuite;
  FScenario.Titulo := 'Um Cenário Valido';
  FScenario.Steps.Add(TStep.Create);
  (FScenario.Steps.First as IStep).Descricao := 'Dado que tenho um step valido';
  Specify.That((FScenario as IValidationRule).Valid).Should.Be.True;
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TestTScenario.Suite);
end.

