unit TestFeature;

interface

uses
  TestFramework, Classes, FeatureIntf, Feature, TestBaseClasses, StepIntf;

type
  TestTFeature = class(TParseContext)
  strict private
    FFeature: IFeature;
  private
    function NovoStep(ADescricao: string): IStep;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure FeatureDeveriaSerInvalidaSeNaoPossuirAoMenosUmCenarioValido;
    procedure FeatureDeveriaSerInvalidaSeCenariosNaoForemValidos;
    procedure FeatureDeveriaSerInvalidaSeNaoPossuirUmaClasseDeTestesParaCadaScenario;
  end;

implementation

uses
  Scenario, ScenarioIntf, Step, DummyTests;

procedure TestTFeature.FeatureDeveriaSerInvalidaSeCenariosNaoForemValidos;
begin
  FFeature.Scenarios.Add(TScenario.Create);
  Specify.That(FFeature.Valid).Should.Be.False;
end;

procedure TestTFeature.FeatureDeveriaSerInvalidaSeNaoPossuirAoMenosUmCenarioValido;
var
  LCenarioValido: ITestSuite;
begin
  LCenarioValido := TUmCenarioValido.Suite;
  RegisterTest(LCenarioValido);
  Specify.That(FFeature.Valid).Should.Be.False;
  FFeature.Scenarios.Add(TScenario.Create);
  (FFeature.Scenarios.First as IScenario).Titulo := 'Um Cenário Válido';
  (FFeature.Scenarios.First as IScenario).Steps.Add(TStep.Create);
  ((FFeature.Scenarios.First as IScenario).Steps.First as IStep).Descricao := 'Dado que tenho um step valido';
  Specify.That(FFeature.Valid).Should.Be.True;
  RegisteredTests.Tests.Remove(LCenarioValido);
end;

procedure TestTFeature.FeatureDeveriaSerInvalidaSeNaoPossuirUmaClasseDeTestesParaCadaScenario;
var
  LCenarioCom3Passos: ITestSuite;
  LCenarioValidoSuite: ITestSuite;
  LScenario: IScenario;
begin
  LCenarioValidoSuite := TUmCenarioValido.Suite;
  RegisterTest(LCenarioValidoSuite);
  LCenarioCom3Passos := TUmCenarioCom3Passos.Suite;
  RegisterTest(LCenarioCom3Passos);
  LScenario := TScenario.Create;
  LScenario.Titulo := 'Um cenário com 3 passos';
  LScenario.Steps.Add(NovoStep('Dado que tenho 3 passos nesse cenário'));
  LScenario.Steps.Add(NovoStep('Quando eu validar a Featuare'));
  LScenario.Steps.Add(NovoStep('Então ela deve ser válida.'));

  FFeature.Scenarios.Add(LScenario);

  LScenario := TScenario.Create;
  LScenario.Titulo := 'Um cenário Válido';
  LScenario.Steps.Add(NovoStep('Dado Que Tenho Um Step Valido'));

  FFeature.Scenarios.Add(LScenario);

  Specify.That(FFeature.Valid).Should.Be.True;
  RegisteredTests.Tests.Remove(LCenarioValidoSuite);
  RegisteredTests.Tests.Remove(LCenarioCom3Passos);
end;

function TestTFeature.NovoStep(ADescricao: string): IStep;
begin
  Result := TStep.Create;
  Result.Descricao := ADescricao;
end;

procedure TestTFeature.SetUp;
begin
  FFeature := TFeature.Create;
end;

procedure TestTFeature.TearDown;
begin
  FFeature := nil;
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TestTFeature.Suite);
end.

