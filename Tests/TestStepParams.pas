unit TestStepParams;

interface

uses
  TestFramework, StepParamIntf, StepParams, StepParamsIntf, TestBaseClasses;

type

  TestTStepParams = class(TParseContext)
  strict private
    FStepParams: IStepParams;
    FParam: Variant;
  public
    procedure SetUp; override;
    procedure TearDown; override;
    procedure RaiseExceptionIfParamTypeIsInvalid;
    procedure RaiseExceptionIfTrySetInvalidParamType;
  published
    procedure ShouldAddSomeStepParams;
    procedure ShouldGetStepParamByName;
    procedure ShouldGetAndSetStepParamByName;
    procedure ShouldGetAndSetStepParamByIndex;
    procedure ShouldRaiseExceptionIfParamNotIsStringOrInteger;
    procedure ShouldRaiseExceptionIfTrySetInvalidParamType;
    procedure ShouldClearParams;
  end;

implementation

uses
  StepParam, Dialogs, dSpecUtils, Rtti, TypInfo, Variants, DB;

procedure TestTStepParams.RaiseExceptionIfParamTypeIsInvalid;
var
  LParam: IStepParam;
begin
  LParam := FStepParams[FParam];
end;

procedure TestTStepParams.RaiseExceptionIfTrySetInvalidParamType;
var
  LParam: IStepParam;
begin
  LParam := TStepParam.Create;
  LParam.Name := 'Name';
  LParam.Value := 'Name';
  FStepParams[FParam] := LParam;
end;

procedure TestTStepParams.SetUp;
begin
  FStepParams := TStepParams.Create;
end;

procedure TestTStepParams.TearDown;
begin
  FParam := null;
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

procedure TestTStepParams.ShouldRaiseExceptionIfParamNotIsStringOrInteger;
begin
  FParam := 1.89;
  CheckException(RaiseExceptionIfParamTypeIsInvalid, EInvalidParamType);
end;

procedure TestTStepParams.ShouldRaiseExceptionIfTrySetInvalidParamType;
begin
  FParam := 1.89;
  CheckException(RaiseExceptionIfTrySetInvalidParamType, EInvalidParamType);
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TestTStepParams.Suite);
end.

