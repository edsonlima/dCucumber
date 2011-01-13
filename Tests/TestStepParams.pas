unit TestStepParams;

interface

uses
  TestFramework, StepParamIntf, StepParams, StepParamsIntf, TestBaseClasses;

type

  TestTStepParams = class(TParseContext)
  strict private
    FStepParams: IStepParams;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure ShouldAddSomeStepParams;
    procedure ShouldGetStepParamByName;
    procedure ShouldGetAndSetStepParamByName;
    procedure ShouldGetAndSetStepParamByIndex;
    procedure ShouldClearParams;
  end;

implementation

uses
  StepParam, Dialogs, dSpecUtils, Rtti, TypInfo;

procedure TestTStepParams.SetUp;
begin
  FStepParams := TStepParams.Create;
end;

procedure TestTStepParams.TearDown;
begin
  FStepParams := nil;
end;

procedure TestTStepParams.ShouldAddSomeStepParams;
begin
  Specify.That(FStepParams.Add('New param')).Should.Not_.Be.Nil_;
  Specify.That(FStepParams['New param']).Should.Not_.Be.Nil_;
end;

procedure TestTStepParams.ShouldClearParams;
begin
  FStepParams.Add('Test Param');
  FStepParams.Clear;
  Specify.That(FStepParams['Test Param']).Should.Be.Nil_;
end;

procedure TestTStepParams.ShouldGetAndSetStepParamByIndex;
var
  LParam: IStepParam;
begin
  LParam := TStepParam.Create;
  LParam.Name := 'Name';
  LParam.Value := 'Name';
  FStepParams[0] := LParam;
  Specify.That(FStepParams[0]).Should.Be.Assigned;
  Specify.That(FStepParams[0].Name).Should.Equal(LParam.Name);
end;

procedure TestTStepParams.ShouldGetAndSetStepParamByName;
var
  LParam: IStepParam;
begin
  LParam := TStepParam.Create;
  LParam.Name := 'Name';
  LParam.Value := 'Name';
  FStepParams['Name'] := LParam;
  Specify.That(FStepParams['Name']).Should.Be.Assigned;
  Specify.That(FStepParams['Name'].Name).Should.Equal(LParam.Name);
end;

procedure TestTStepParams.ShouldGetStepParamByName;
begin
  FStepParams.Add('New param');
  Specify.That(FStepParams.ByName('New param')).Should.Not_.Be.Nil_;
  Specify.That(FStepParams.ByName('New param')).Should.Support(IStepParam);
  Specify.That(FStepParams.ByName('New param').Name).Should.Equal('New param');
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TestTStepParams.Suite);
end.

