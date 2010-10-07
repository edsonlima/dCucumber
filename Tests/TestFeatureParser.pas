unit TestFeatureParser;

interface

uses
  TestFramework, FeatureParser, FeatureParserIntf, dSpec, dSpecIntf;

type
  TParseContext = class(TContext)
  public
    constructor Create(MethodName: string); override;
  end;

  TestTFeatureParser = class(TParseContext)
  strict private
    FFeatureParser: IFeatureParser;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure ParseDeveriaRetornarUmaFeature;
    procedure ParseDeveriaTrazerOsCenariosDaFeature;
  end;

implementation

uses
  TypeUtils, TestConsts, FeatureIntf;

procedure TestTFeatureParser.ParseDeveriaTrazerOsCenariosDaFeature;
var
  LFeature: IFeature;
begin
  LFeature := FFeatureParser.Parse;
  Specify.That(LFeature.Descricao).Should.Equal('Opa, no caminho certo!');
  Specify.That(LFeature.Cenarios.Count).Should.Equal(1);
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

constructor TParseContext.Create(MethodName: string);
begin
  inherited Create(MethodName);
  AutoDoc.Enabled := True;
end;

initialization
  RegisterSpec(TestTFeatureParser.Suite);
end.

