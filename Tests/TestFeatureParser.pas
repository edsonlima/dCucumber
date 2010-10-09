unit TestFeatureParser;

interface

uses
  TestFramework, FeatureParser, FeatureParserIntf, dSpec, dSpecIntf, TestBaseClasses;

type
  TestTFeatureParser = class(TParseContext)
  strict private
    FFeatureParser: IFeatureParser;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure ParseDeveriaRetornarUmaFeature;
    procedure ParseDeveriaTrazerOsCenariosDaFeature;
    procedure ParseDeveriaTrazerOTituloEADescricaoDaFeature;
    procedure ParseDeveriaTrazerOTituloDosCenarios;
    procedure ParserDeveriaTrazerOsPassosDosCenarios;
  end;

implementation

uses
  TypeUtils, TestConsts, FeatureIntf, ScenarioIntf, StepIntf;

procedure TestTFeatureParser.ParseDeveriaTrazerOsCenariosDaFeature;
var
  LFeature: IFeature;
begin
  LFeature := FFeatureParser.Parse;
  Specify.That(LFeature.Scenarios.Count).Should.Equal(1);
end;

procedure TestTFeatureParser.ParseDeveriaTrazerOTituloDosCenarios;
var
  LFeature: IFeature;
begin
  LFeature := FFeatureParser.Parse;
  Specify.That((LFeature.Scenarios[0] as IScenario).Titulo).Should.Equal('Primeiros Passos');
end;

procedure TestTFeatureParser.ParseDeveriaTrazerOTituloEADescricaoDaFeature;
var
  LFeature: IFeature;
begin
  LFeature := FFeatureParser.Parse;
  Specify.That(LFeature.Titulo).Should.Equal('Um modelo de teste');
  Specify.That(LFeature.Descricao).Should.Equal(DescricaoFeatureTeste);
end;

procedure TestTFeatureParser.ParserDeveriaTrazerOsPassosDosCenarios;
var
  LFeature: IFeature;
begin
  LFeature := FFeatureParser.Parse;
  Specify.That((LFeature.Scenarios.First as IScenario).Steps.Count).Should.Equal(3);
  Specify.That(((LFeature.Scenarios.First as IScenario).Steps.First as IStep).Descricao).Should.Equal(DescricaoPrimeiroStep)
end;

procedure TestTFeatureParser.SetUp;
begin
  FFeatureParser := TFeatureParser.Create;
  FFeatureParser.FeatureFileName := S(FeatureDir).Mais(FeatureCenarioSimples);
end;

procedure TestTFeatureParser.TearDown;
begin
  FFeatureParser := nil;
end;

procedure TestTFeatureParser.ParseDeveriaRetornarUmaFeature;
var
  LFeature: IFeature;
begin
  LFeature := FFeatureParser.Parse;
  Specify.That(LFeature).Should.Not_.Be.Nil_;
  LFeature := nil;
end;

initialization
  RegisterSpec(TestTFeatureParser.Suite);
end.

