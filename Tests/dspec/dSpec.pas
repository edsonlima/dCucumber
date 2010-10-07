(*
 * The contents of this file are subject to the Mozilla Public
 * License Version 1.1 (the "License"); you may not use this file
 * except in compliance with the License. You may obtain a copy of
 * the License at http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS
 * IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
 * implied. See the License for the specific language governing
 * rights and limitations under the License.
 *
 * Contributor(s):
 * Jody Dawkins <jdawkins@delphixtreme.com>
 *)

unit dSpec;

interface

uses Specifiers, dSpecIntf, BaseObjects, TestFramework, AutoDocObjects;

type
  TSpecify = class(TObject)
  private
    FContext: Pointer;
  public
    constructor Create(const AContext: IContext);
    destructor Destroy; override;
    function That(Value : Integer; const ValueName : string = '') : ISpecifier; overload;
    function That(Value : Boolean; const ValueName : string = '') : ISpecifier; overload;
    function That(Value : Extended; const ValueName : string = '') : ISpecifier; overload;
    function That(Value : string; const ValueName : string = '') : ISpecifier; overload;
    function That(Value : TObject; const ValueName : string = '') : ISpecifier; overload;
    function That(Value : Pointer; const ValueName : string = '') : ISpecifier; overload;
    function That(Value : TClass; const ValueName : string = '') : ISpecifier; overload;
    function That(Value : TDateTime; const ValueName : string = '') : ISpecifier; overload;
    function That(Value : IInterface; const ValueName : string = '') : ISpecifier; overload;
  end;

  TAutoDocClass = class of TBaseAutoDoc;

  TContext = class(TTestCase, IContext)
  private
    FSpecify : TSpecify;
    FFailures: TFailureList;
    FTestResult: TTestResult;
    FSpecDocumentation : string;
    FContextDescription: string;
    FAutoDoc : IAutoDoc;
    { IContext }
    procedure AddFailure(const AMessage : string; ACallerAddress : Pointer);
    procedure NewSpecDox(const ValueName : string);
    procedure DocumentSpec(Value : Variant; const SpecName : string);
    procedure ReportFailures;
    procedure RepealLastFailure;
    function GetAutoDoc : IAutoDoc;
    procedure SetAutoDoc(const Value: IAutoDoc);
    function GetContextDescription : string;
    procedure SetContextDescription(const Value : string);
  protected
    property Specify : TSpecify read FSpecify;
    property ContextDescription : string read GetContextDescription write SetContextDescription;
    property AutoDoc : IAutoDoc read GetAutoDoc write SetAutoDoc; 
    procedure RunWithFixture(testResult: TTestResult); override;
    procedure Invoke(AMethod: TTestMethod); override;
    procedure DoStatus(const Msg : string);
    function CreateAutoDoc : IAutoDoc; dynamic;
  public
    constructor Create(MethodName : string); override;
    destructor Destroy; override;
  end;

procedure RegisterSpec(spec: ITest);

implementation

uses dSpecUtils, SysUtils, Variants;

procedure RegisterSpec(spec: ITest);
begin
  TestFramework.RegisterTest(spec);
end;

{ Specify }

constructor TSpecify.Create(const AContext: IContext);
begin
  inherited Create;
  FContext := Pointer(AContext);
end;

destructor TSpecify.Destroy;
begin
  FContext := nil;
  inherited Destroy;
end;

function TSpecify.That(Value: Integer; const ValueName : string = ''): ISpecifier;
begin
  Result := TIntegerSpecifier.Create(Value, CallerAddr, IContext(FContext), ValueName);
  IContext(FContext).NewSpecDox(GetValueName(Value, ValueName));
end;

function TSpecify.That(Value: Boolean; const ValueName : string = ''): ISpecifier;
begin
  Result := TBooleanSpecifier.Create(Value, CallerAddr, IContext(FContext), ValueName);
  IContext(FContext).NewSpecDox(GetValueName(Value, ValueName));
end;

function TSpecify.That(Value: Extended; const ValueName : string = ''): ISpecifier;
begin
  Result := TFloatSpecifier.Create(Value, CallerAddr, IContext(FContext), ValueName);
  IContext(FContext).NewSpecDox(GetValueName(Value, ValueName));
end;

function TSpecify.That(Value: string; const ValueName : string = ''): ISpecifier;
begin
  Result := TStringSpecifier.Create(Value, CallerAddr, IContext(FContext), ValueName);
  IContext(FContext).NewSpecDox(GetValueName(Value, ValueName));
end;

function TSpecify.That(Value: TObject; const ValueName : string = ''): ISpecifier;
begin
  Result := TObjectSpecifier.Create(Value, CallerAddr, IContext(FContext), ValueName);
  if ValueName <> '' then
    IContext(FContext).NewSpecDox(ValueName)
  else
  if Assigned(Value) then
    IContext(FContext).NewSpecDox(Value.ClassName)
  else
    IContext(FContext).NewSpecDox('TObject');
end;

function TSpecify.That(Value: Pointer; const ValueName : string = ''): ISpecifier;
begin
  Result := TPointerSpecifier.Create(Value, CallerAddr, IContext(FContext), ValueName);
  if ValueName <> '' then
    IContext(FContext).NewSpecDox(ValueName)
  else
    IContext(FContext).NewSpecDox('Pointer');
end;

function TSpecify.That(Value: TClass; const ValueName : string = ''): ISpecifier;
begin
  Result := TClassSpecifier.Create(Value, CallerAddr, IContext(FContext), ValueName);
  if ValueName <> '' then
    IContext(FContext).NewSpecDox(ValueName)
  else
    IContext(FContext).NewSpecDox(Value.ClassName);
end;

function TSpecify.That(Value: TDateTime; const ValueName : string = ''): ISpecifier;
begin
  Result := TDateTimeSpecifier.Create(Value, CallerAddr, IContext(FContext), ValueName);
  IContext(FContext).NewSpecDox(GetValueName(Value, ValueName));
end;

function TSpecify.That(Value: IInterface; const ValueName : string = ''): ISpecifier;
begin
  Result := TInterfaceSpecifier.Create(Value, CallerAddr, IContext(FContext), ValueName);
  IContext(FContext).NewSpecDox(GetValueName(Value, ValueName));
end;

{ TContext }

procedure TContext.AddFailure(const AMessage: string; ACallerAddress: Pointer);
begin
  FFailures.AddFailure(AMessage, ACallerAddress);
end;

constructor TContext.Create;
begin
  inherited Create(MethodName);
  FSpecify := TSpecify.Create(Self);
  FFailures := TFailureList.Create;
  FContextDescription := '';
  AutoDoc := CreateAutoDoc;
  AutoDoc.Enabled := False;
end;

destructor TContext.Destroy;
begin
  FreeAndNil(FSpecify);
  FreeAndNil(FFailures);
  AutoDoc := nil;
  inherited Destroy;
end;

procedure TContext.DocumentSpec(Value: Variant; const SpecName: string);
begin
  FSpecDocumentation := FSpecDocumentation + '.' + SpecName;
  if Value <> null then
    FSpecDocumentation := FSpecDocumentation + Format('(%s)', [VarToStr(Value)]);
end;

procedure TContext.DoStatus(const Msg: string);
begin
  if Msg <> '' then
    Status(Msg);
end;

function TContext.GetAutoDoc: IAutoDoc;
begin
  Result := FAutoDoc;
end;

function TContext.CreateAutoDoc: IAutoDoc;
begin
  Result := TBaseAutoDoc.Create(Self);
end;

function TContext.GetContextDescription: string;
begin
  Result := FContextDescription;
end;

procedure TContext.Invoke(AMethod: TTestMethod);
begin
  DoStatus(FAutoDoc.BeginSpec(ClassName, FTestName));
  inherited;
  DoStatus(FAutoDoc.DocSpec(FSpecDocumentation));
end;

procedure TContext.RepealLastFailure;
begin
  if FFailures.Count > 0 then
    FFailures.Delete(FFailures.Count - 1);
end;

procedure TContext.ReportFailures;
var
  c: Integer;
begin
  try
    for c := 0 to FFailures.Count - 1 do
      FTestResult.AddFailure(Self, ETestFailure.Create(FFailures[c].Message), FFailures[c].FailureAddress);
  finally
    FFailures.Clear;
  end;
end;

procedure TContext.NewSpecDox(const ValueName : string);
begin
  if FSpecDocumentation <> '' then
    DoStatus(FAutoDoc.DocSpec(FSpecDocumentation));
  FSpecDocumentation := Format('Specify.That(%s).Should', [ValueName]);
end;

procedure TContext.RunWithFixture(testResult: TTestResult);
begin
  FTestResult := testResult;
  inherited;
  FTestResult := nil;
end;

procedure TContext.SetAutoDoc(const Value: IAutoDoc);
begin
  FAutoDoc := Value;
  if not Assigned(FAutoDoc) then
    FAutoDoc := TBaseAutoDoc.Create(Self);
end;

procedure TContext.SetContextDescription(const Value: string);
begin
  FContextDescription := Value;
end;

end.
