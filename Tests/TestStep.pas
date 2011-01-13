unit TestStep;

interface

uses
  TestFramework, StepIntf, ValidationRuleIntf, Step, TestBaseClasses;

type
  TestTStep = class(TParseContext)
  strict private
    FStep: IStep;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure DeveriaRetornarONomeDoMetodoCorrespondente;
    procedure ShouldIdentifyMethodWithParams;
    procedure ShouldCaptureStringParams;
  end;

implementation

procedure TestTStep.DeveriaRetornarONomeDoMetodoCorrespondente;
begin
  FStep.Descricao := 'Dado que meu step é válido.';
  Specify.That(FStep.MetodoDeTeste).Should.Equal('DadoQueMeuStepEValido');
end;

procedure TestTStep.SetUp;
begin
  FStep := TStep.Create;
end;

procedure TestTStep.ShouldIdentifyMethodWithParams;
begin
  FStep.Descricao := 'Given I have a parameter "test" in my step and 1';
  Specify.That(FStep.MetodoDeTeste).Should.Equal('GivenIHaveAParameterTestInMyStepAnd1')
end;

procedure TestTStep.ShouldCaptureStringParams;
begin
  FStep.Descricao := 'Given I have a parameter "test" in my step and 1';
  FStep.ParamsRegex := '(".*"|\d)';
  Specify.That(FStep.Params['1']).Should.Not_.Be.Nil_;
  Specify.That(FStep.Params['"test"']).Should.Not_.Be.Nil_;
end;

procedure TestTStep.TearDown;
begin
  FStep := nil;
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TestTStep.Suite);
end.

