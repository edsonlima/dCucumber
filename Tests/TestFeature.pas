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
    procedure FeatureDeveriaSerInvalidaSeNaoPossuirAoMenosUmCenario;
    procedure FeatureDeveriaSerInvalidaSeCenariosNaoForemValidos;
  end;

implementation

uses
  Scenario;

procedure TestTFeature.FeatureDeveriaSerInvalidaSeCenariosNaoForemValidos;
begin
  FFeature.Scenarios.Add(TScenario.Create);
  Specify.That(FFeature.Valid).Should.Be.False;
end;

procedure TestTFeature.FeatureDeveriaSerInvalidaSeNaoPossuirAoMenosUmCenario;
begin
  Specify.That(FFeature.Valid).Should.Be.False;
  FFeature.Scenarios.Add(TScenario.Create);
  Specify.That(FFeature.Valid).Should.Be.True;
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

