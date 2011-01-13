unit TestStepParam;

interface

uses
  TestBaseClasses, TestFramework, StepParam, StepParamIntf;

type
  TestTStepParam = class(TParseContext)
  strict private
    FStepParam: IStepParam;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure ShouldHaveAName;
    procedure ShouldHaveAValue;
  end;

implementation

procedure TestTStepParam.SetUp;
begin
  FStepParam := TStepParam.Create;
end;

procedure TestTStepParam.ShouldHaveAName;
begin
  FStepParam.Name := 'Hello';
  Specify.That(FStepParam.Name).Should.Not_.Be.Empty;
  Specify.That(FStepParam.Name).Should.Equal('Hello');
end;

procedure TestTStepParam.ShouldHaveAValue;
begin
  FStepParam.Value := 'World!';
  Specify.That(FStepParam.Value).Should.Not_.Be.Empty;
  Specify.That(FStepParam.Value).Should.Equal('World!');
end;

procedure TestTStepParam.TearDown;
begin
  FStepParam := nil;
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TestTStepParam.Suite);

end.
