unit TestFeature;

interface

uses
  TestFramework, Classes, FeatureIntf, Feature, TestBaseClasses;

type
  TestTFeature = class(TParseContext)
  strict private
    FFeature: IFeature;
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
  Scenario, ScenarioIntf, Step, StepIntf;

procedure TestTFeature.FeatureDeveriaSerInvalidaSeCenariosNaoForemValidos;
begin
  FFeature.Scenarios.Add(TScenario.Create);
  Specify.That(FFeature.Valid).Should.Be.False;
end;

procedure TestTFeature.FeatureDeveriaSerInvalidaSeNaoPossuirAoMenosUmCenarioValido;
begin
  Specify.That(FFeature.Valid).Should.Be.False;
  FFeature.Scenarios.Add(TScenario.Create);
  (FFeature.Scenarios.First as IScenario).Titulo := 'Um Cenário Válido';
  (FFeature.Scenarios.First as IScenario).Steps.Add(TStep.Create);
  ((FFeature.Scenarios.First as IScenario).Steps.First as IStep).Descricao := 'Dado que tenho um step valido';
  Specify.That(FFeature.Valid).Should.Be.True;
end;

procedure TestTFeature.FeatureDeveriaSerInvalidaSeNaoPossuirUmaClasseDeTestesParaCadaScenario;
begin
  Fail('TODO: Implementar o que falta...');
//  FFeature.Scenarios.Add(TScenario.Create);
//  (FFeature.Scenarios.First as IScenario).Steps.Add(TStep.Create);
//  ((FFeature.Scenarios.First as IScenario).Steps.First as IStep).Descricao := 'Dado que tenho um step valido';
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

