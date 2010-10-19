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
    procedure ParseDeveriaCarregarOErroDaFeature;
    procedure ParseDeveriaIdentificarSePassoContemApenasUmaPalavra;
    procedure ParseFeatureDeveriaInicializarComAPalavraFuncionalidade;
    procedure ArquivoDaFeatureDeveriaExistir;
  end;

implementation

uses
  TypeUtils, TestConsts, FeatureIntf, ScenarioIntf, StepIntf, FeatureErrorIntf, Constants, SysUtils;

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

procedure TestTFeatureParser.ParseFeatureDeveriaInicializarComAPalavraFuncionalidade;
var
  LError: IFeatureError;
begin
  FFeatureParser.FeatureFileName := S(FeatureDir).Mais(FeatureSemFuncionalidade);
  FFeatureParser.Parse;
  Specify.That(FFeatureParser.Errors.Count).Should.Equal(1);
  LError := FFeatureParser.Errors.First as IFeatureError;

  Specify.That(LError.Line).Should.Equal(1);
  Specify.That(LError.Message).Should.Equal(Format(InvalidFeature, [FFeatureParser.FeatureFileName]));
  Specify.That(LError.SugestedAction).Should.Equal('Exemplo: Funcionalidade: Aqui vai o título da sua funcionalidade.');

  FFeatureParser.FeatureFileName := S(FeatureDir).Mais(FeatureComPrimeiraLinhaEmBranco);
  FFeatureParser.Parse;
  Specify.That(FFeatureParser.Errors.Count).Should.Equal(1);
  LError := FFeatureParser.Errors.First as IFeatureError;

  Specify.That(LError.Line).Should.Equal(1);
  Specify.That(LError.Message).Should.Equal(Format(InvalidFeature, [FFeatureParser.FeatureFileName]));
  Specify.That(LError.SugestedAction).Should.Equal('Exemplo: Funcionalidade: Aqui vai o título da sua funcionalidade.');
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

procedure TestTFeatureParser.ArquivoDaFeatureDeveriaExistir;
var
  LError: IFeatureError;
begin
  FFeatureParser.FeatureFileName := 'InvalidFileName.feature';
  FFeatureParser.Parse;
  Specify.That(FFeatureParser.Errors.Count).Should.Equal(1);
  LError := FFeatureParser.Errors.First as IFeatureError;
  Specify.That(LError.Message).Should.Equal('O arquivo que você tentou carregar (InvalidFileName.feature) não existe.');
  Specify.That(LError.SugestedAction).Should.Equal('Tente carregar um arquivo que exista :)');
end;

procedure TestTFeatureParser.ParseDeveriaCarregarOErroDaFeature;
var
  LError: IFeatureError;
begin
  FFeatureParser.FeatureFileName := S(FeatureDir).Mais(FeatureComUmErro);
  FFeatureParser.Parse;
  Specify.That(FFeatureParser.Errors).Should.Not_.Be.Empty;
  LError := FFeatureParser.Errors.First as IFeatureError;

  Specify.That(LError.Line).Should.Equal(8);
  Specify.That(LError.Message).Should.Equal('A linha 8 começa com uma palavra chave desconhecida (Essa).');
  Specify.That(LError.SugestedAction).Should.Equal(SugestedActionToStepError)
end;

procedure TestTFeatureParser.ParseDeveriaIdentificarSePassoContemApenasUmaPalavra;
var
  LError: IFeatureError;
begin
  FFeatureParser.FeatureFileName := S(FeatureDir).Mais(FeatureComUmErro);
  FFeatureParser.Parse;
  Specify.That(FFeatureParser.Errors).Should.Not_.Be.Empty;
  LError := FFeatureParser.Errors.Last as IFeatureError;

  Specify.That(LError.Line).Should.Equal(13);
  Specify.That(LError.Message).Should.Equal('O passo da linha 13 deve conter mais do que apenas uma palavra.');
  Specify.That(LError.SugestedAction).Should.Equal('Quando... ?!');
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

