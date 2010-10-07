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
 
unit Specifiers;

interface

uses SysUtils, Variants, Modifiers, BaseObjects, dSpecIntf;

type
  TBaseSpecifier = class(TFailureReportingObject, ISpecifier, IShouldHelper, IBeHelper)
  private
    FValueName: string;
  protected
    FNegated: Boolean;
    function DoEvaluation(Failed : Boolean; const FailureMessage, SpecName : string; SpecValue : Variant) : IModifier;
    function CreateModifier(RemoveLastFailure: Boolean; FailureMessage: string) : IModifier; virtual;
    function CreateNewShouldHelper(Negated : Boolean) : IShouldHelper; dynamic;
    procedure NegateMessage(var Msg : string);
  public
    constructor Create(ACallerAddress: Pointer; const AContext: IContext; const AValueName: string; Negated: Boolean = False); reintroduce;
    destructor Destroy; override;
   { ISpecifier }
    function Should : IShouldHelper;
    function Not_ : IShouldHelper;
    function Be : IBeHelper;
    { IShouldHelper }
    function Equal(Expected : Variant) : IModifier; virtual;
    function DescendFrom(Expected : TClass) : IModifier; virtual;
    function Implement(Expected : TGUID) : IModifier; virtual;
    function Support(Expected : TGUID) : IModifier; virtual;
    function StartWith(Expected : Variant) : IModifier; virtual;
    function Contain(Expected : Variant) : IModifier; virtual;
    function EndWith(Expected : Variant) : IModifier; virtual;
    { IBeHelper }
    function OfType(Expected : TClass) : IModifier; virtual;
    function Nil_ : IModifier; virtual;
    function True : IModifier; virtual;
    function False : IModifier; virtual;
    function GreaterThan(Expected : Variant) : IModifier; virtual;
    function LessThan(Expected : Variant) : IModifier; virtual;
    function AtLeast(Expected : Variant) : IModifier; virtual;
    function AtMost(Expected : Variant) : IModifier; virtual;
    function Assigned : IModifier; virtual;
    function ImplementedBy(Expected : TClass) : IModifier; virtual;
    function Numeric : IModifier; virtual;
    function Alpha : IModifier; virtual;
    function AlphaNumeric : IModifier; virtual;
    function Odd : IModifier; virtual;
    function Even : IModifier; virtual;
    function Positive : IModifier; virtual;
    function Negative : IModifier; virtual;
    function Prime : IModifier; virtual;
    function Composite : IModifier; virtual;
    function Zero : IModifier; virtual;
    function Empty : IModifier; virtual;
  end;

  TIntegerSpecifier = class(TBaseSpecifier)
  private
    FActual: Integer;
  public
    constructor Create(Actual: Integer; ACallerAddress: Pointer; const AContext: IContext; const AValueName: string); reintroduce;
    function Equal(Expected : Variant) : IModifier; override;
    function GreaterThan(Expected : Variant) : IModifier; override;
    function LessThan(Expected : Variant) : IModifier; override;
    function AtLeast(Expected : Variant) : IModifier; override;
    function AtMost(Expected : Variant) : IModifier; override;
    function Odd : IModifier; override;
    function Even : IModifier; override;
    function Positive : IModifier; override;
    function Negative : IModifier; override;
    function Prime : IModifier; override;
    function Composite : IModifier; override;
    function Zero : IModifier; override;
  end;

  TBooleanSpecifier = class(TBaseSpecifier)
  private
    FActual: Boolean;
  public
    constructor Create(Actual: Boolean; ACallerAddress: Pointer; const AContext: IContext; const AValueName: string); reintroduce;
    function Equal(Expected : Variant) : IModifier; override;
    function True : IModifier; override;
    function False : IModifier; override;
  end;

  TFloatSpecifier = class(TBaseSpecifier)
  private
    FExpected: Extended;
    FActual: Extended;
  protected
    function CreateModifier(RemoveLastFailure: Boolean; FailureMessage: string) : IModifier; override;
  public
    constructor Create(Actual: Extended; ACallerAddress: Pointer; const AContext: IContext; const AValueName: string); reintroduce;
    function Equal(Expected : Variant) : IModifier; override;
    function GreaterThan(Expected : Variant) : IModifier; override;
    function LessThan(Expected : Variant) : IModifier; override;
    function AtLeast(Expected : Variant) : IModifier; override;
    function AtMost(Expected : Variant) : IModifier; override;
    function Positive : IModifier; override;
    function Negative : IModifier; override;
    function Zero : IModifier; override;
  end;

  TStringSpecifier = class(TBaseSpecifier)
  private
    FActual: string;
    FExpected: string;
  protected
    function CreateModifier(RemoveLastFailure: Boolean; FailureMessage: string) : IModifier; override;
  public
    constructor Create(Actual: string; ACallerAddress: Pointer; const AContext: IContext; const AValueName: string); reintroduce;
    function Equal(Expected : Variant) : IModifier; override;
    function Numeric : IModifier; override;
    function Alpha : IModifier; override;
    function AlphaNumeric : IModifier; override;
    function StartWith(Expected : Variant) : IModifier; override;
    function Contain(Expected : Variant) : IModifier; override;
    function EndWith(Expected : Variant) : IModifier; override;
    function Empty : IModifier; override;
  end;

  TObjectSpecifier = class(TBaseSpecifier)
  private
    FActual: TObject;
  public
    constructor Create(Actual: TObject; ACallerAddress: Pointer; const AContext: IContext; const AValueName: string); reintroduce;
    function OfType(Expected : TClass) : IModifier; override;
    function Nil_ : IModifier; override;
    function DescendFrom(Expected : TClass) : IModifier; override;
    function Assigned : IModifier; override;
    function Implement(Expected : TGUID) : IModifier; override;
    function Support(Expected : TGUID) : IModifier; override;
  end;

  TPointerSpecifier = class(TBaseSpecifier)
  private
    FActual: Pointer;
  public
    constructor Create(Actual, ACallerAddress: Pointer; const AContext: IContext; const AValueName: string); reintroduce;
    function Nil_ : IModifier; override;
    function Assigned : IModifier; override;
  end;

  TClassSpecifier = class(TBaseSpecifier)
  private
    FActual: TClass;
  public
    constructor Create(Actual: TClass; ACallerAddress: Pointer; const AContext: IContext; const AValueName: string); reintroduce;
    function OfType(Value : TClass) : IModifier; override;
    function DescendFrom(Expected : TClass) : IModifier; override;
  end;

  TDateTimeSpecifier = class(TBaseSpecifier)
  private
    FActual: TDateTime;
  public
    constructor Create(Actual: TDateTime; ACallerAddress: Pointer; const AContext: IContext; const AValueName: string); reintroduce;
    function Equal(Expected : Variant) : IModifier; override;
    function LessThan(Expected : Variant) : IModifier; override;
    function GreaterThan(Expected : Variant) : IModifier; override;
    function AtLeast(Expected : Variant) : IModifier; override;
    function AtMost(Expected : Variant) : IModifier; override;
  end;

  TInterfaceSpecifier = class(TBaseSpecifier)
  private
    FActual: IInterface;
  public
    constructor Create(Actual: IInterface; ACallerAddress: Pointer; const AContext: IContext; const AValueName: string); reintroduce;
    destructor Destroy; override;
    function Support(Expected : TGUID) : IModifier; override;
    function Assigned : IModifier; override;
    function Nil_ : IModifier; override;
    function ImplementedBy(Expected : TClass) : IModifier; override;
  end;

implementation

uses dSpecUtils, FailureMessages;

{ TBaseSpecifier }

function TBaseSpecifier.Composite: IModifier;
begin
  Result := DoEvaluation(System.True, SpecNotApplicable, 'Composite', null);
end;

function TBaseSpecifier.Contain(Expected: Variant): IModifier;
begin
  Result := DoEvaluation(System.True, SpecNotApplicable, 'Containt', Expected);
end;

constructor TBaseSpecifier.Create(ACallerAddress: Pointer; const AContext: IContext; const AValueName: string; Negated: Boolean =
    False);
begin
  inherited Create(ACallerAddress, AContext);
  FNegated := Negated;
  FValueName := AValueName;
end;

function TBaseSpecifier.CreateModifier(RemoveLastFailure: Boolean; FailureMessage: string): IModifier;
begin
  Result := TModifier.Create(Self, RemoveLastFailure, FailureMessage, FCallerAddress, FContext);
end;

function TBaseSpecifier.CreateNewShouldHelper(Negated: Boolean): IShouldHelper;
begin
  Result := Self.Create(FCallerAddress, FContext, FValueName, Negated);
end;

destructor TBaseSpecifier.Destroy;
begin
  FCallerAddress := nil;
  try
    FContext.ReportFailures
  finally
    inherited Destroy;
  end;
end;

function TBaseSpecifier.DoEvaluation(Failed: Boolean;
  const FailureMessage, SpecName: string; SpecValue : Variant): IModifier;
var
  Msg: string;
begin
  Msg := FailureMessage;
  if FNegated then begin
    Failed := not Failed;
    NegateMessage(Msg);
  end;
  if FValueName <> '' then
    Msg := FValueName + ' ' + Msg;
  if Failed then
    Fail(Msg);
  Result := CreateModifier(Failed = System.True, Msg);
  FContext.DocumentSpec(SpecValue, SpecName);
end;

function TBaseSpecifier.Should: IShouldHelper;
begin
  Result := Self;
end;

function TBaseSpecifier.StartWith(Expected : Variant): IModifier;
begin
  Result := DoEvaluation(System.True, SpecNotApplicable, 'StartWith', Expected);
end;

function TBaseSpecifier.Support(Expected: TGUID): IModifier;
begin
  Result := DoEvaluation(System.True, SpecNotApplicable, 'Support', GUIDToString(Expected));
end;

function TBaseSpecifier.Alpha: IModifier;
begin
  Result := DoEvaluation(System.True, SpecNotApplicable, 'Alpha', null);
end;

function TBaseSpecifier.AlphaNumeric: IModifier;
begin
  Result := DoEvaluation(System.True, SpecNotApplicable, 'AlphaNumeric', null);
end;

function TBaseSpecifier.Assigned: IModifier;
begin
  Result := DoEvaluation(System.True, SpecNotApplicable, 'Assigned', null);
end;

function TBaseSpecifier.AtLeast(Expected: Variant): IModifier;
begin
  Result := DoEvaluation(System.True, SpecNotApplicable, 'AtLeast', Expected);
end;

function TBaseSpecifier.AtMost(Expected: Variant): IModifier;
begin
  Result := DoEvaluation(System.True, SpecNotApplicable, 'AtMost', Expected);
end;

function TBaseSpecifier.Be: IBeHelper;
begin
  Result := Self;
  FContext.DocumentSpec(null, 'Be');
end;

function TBaseSpecifier.False : IModifier;
begin
  Result := DoEvaluation(System.True, SpecNotApplicable, 'False', null);
end;

procedure TBaseSpecifier.NegateMessage(var Msg: string);
var
  NegatedMsg: string;
begin
  NegatedMsg := StringReplace(Msg, 'should ', 'should not ', [rfReplaceAll]);
  NegatedMsg := StringReplace(NegatedMsg, 'didn''t', 'did', [rfReplaceAll]);
  NegatedMsg := StringReplace(NegatedMsg, 'wasn''t', 'was', [rfReplaceAll]);
  Msg := NegatedMsg;
end;

function TBaseSpecifier.Negative: IModifier;
begin
  Result := DoEvaluation(System.True, SpecNotApplicable, 'Negative', null);
end;

function TBaseSpecifier.Nil_ : IModifier;
begin
  Result := DoEvaluation(System.True, SpecNotApplicable, 'Nil', null);
end;

function TBaseSpecifier.Odd: IModifier;
begin
  Result := DoEvaluation(System.True, SpecNotApplicable, 'Odd', null);
end;

function TBaseSpecifier.OfType(Expected: TClass) : IModifier;
begin
  Result := DoEvaluation(System.True, SpecNotApplicable, 'OfType', Expected.ClassName);
end;

function TBaseSpecifier.Positive: IModifier;
begin
  Result := DoEvaluation(System.True, SpecNotApplicable, 'Positive', null);
end;

function TBaseSpecifier.Prime: IModifier;
begin
  Result := DoEvaluation(System.True, SpecNotApplicable, 'Prime', null);
end;

function TBaseSpecifier.True : IModifier;
begin
  Result := DoEvaluation(System.True, SpecNotApplicable, 'True', null);
end;

function TBaseSpecifier.Zero: IModifier;
begin
  Result := DoEvaluation(System.True, SpecNotApplicable, 'Zero', null);
end;

function TBaseSpecifier.DescendFrom(Expected: TClass) : IModifier;
begin
  Result := DoEvaluation(System.True, SpecNotApplicable, 'DecendFrom', Expected.ClassName);
end;

function TBaseSpecifier.Empty: IModifier;
begin
  Result := DoEvaluation(System.True, SpecNotApplicable, 'Empty', null);
end;

function TBaseSpecifier.EndWith(Expected: Variant): IModifier;
begin
  Result := DoEvaluation(System.True, SpecNotApplicable, 'EndWith', Expected);
end;

function TBaseSpecifier.Equal(Expected: Variant) : IModifier;
begin
  Result := DoEvaluation(System.True, SpecNotApplicable, 'Equal', Expected);
end;

function TBaseSpecifier.Even: IModifier;
begin
  Result := DoEvaluation(System.True, SpecNotApplicable, 'Even', null);
end;

function TBaseSpecifier.GreaterThan(Expected: Variant): IModifier;
begin
  Result := DoEvaluation(System.True, SpecNotApplicable, 'GreaterThan', Expected);
end;

function TBaseSpecifier.Implement(Expected: TGUID): IModifier;
begin
  Result := DoEvaluation(System.True, SpecNotApplicable, 'Implement', GUIDToString(Expected));
end;

function TBaseSpecifier.ImplementedBy(Expected: TClass): IModifier;
begin
  Result := DoEvaluation(System.True, SpecNotApplicable, 'ImplementedBy', Expected.ClassName);
end;

function TBaseSpecifier.LessThan(Expected: Variant): IModifier;
begin
  Result := DoEvaluation(System.True, SpecNotApplicable, 'LessThan', Expected);
end;

function TBaseSpecifier.Not_: IShouldHelper;
begin
  Result := CreateNewShouldHelper(System.True);
  FContext.DocumentSpec(null, 'Not');
end;

function TBaseSpecifier.Numeric: IModifier;
begin
  Result := DoEvaluation(System.True, SpecNotApplicable, 'Numeric', null);
end;

{ TIntegerSpecifier }

function TIntegerSpecifier.AtLeast(Expected: Variant): IModifier;
var
  Msg: string;
begin
  Msg := Format(SpecIntegerShouldBeAtLeast, [FActual, Integer(Expected)]);
  Result := DoEvaluation(FActual < Integer(Expected), Msg, 'AtLeast', Expected);
end;

function TIntegerSpecifier.AtMost(Expected: Variant): IModifier;
var
  Msg: string;
begin
  Msg := Format(SpecIntegerShouldBeAtMost, [FActual, Integer(Expected)]);
  Result := DoEvaluation(FActual > Integer(Expected), Msg, 'AtMost', Expected);
end;

function TIntegerSpecifier.Composite: IModifier;
var
  Msg: string;
  IsComposite: Boolean;
begin
  IsComposite := not IsPrime(FActual);
  Msg := Format(SpecIntegerShouldBeComposite, [FActual]);
  Result := DoEvaluation(not IsComposite, Msg, 'Composite', null);
end;

constructor TIntegerSpecifier.Create(Actual: Integer; ACallerAddress: Pointer; const AContext: IContext; const AValueName: string);
begin
  inherited Create(ACallerAddress, AContext, AValueName);
  FActual := Actual;
end;

function TIntegerSpecifier.Equal(Expected : Variant) : IModifier;
var
  Msg : string;
begin
  Msg := Format(SpecIntegerShouldEqual, [FActual, Integer(Expected)]);
  Result := DoEvaluation(Expected <> FActual, Msg, 'Equal', Expected);
end;

function TIntegerSpecifier.Even: IModifier;
var
  IsEven: Boolean;
  Msg: string;
begin
  IsEven := FActual mod 2 = 0;
  Msg := Format(SpecIntegerShouldBeEven, [FActual]);
  Result := DoEvaluation(not IsEven, Msg, 'Even', null);
end;

function TIntegerSpecifier.GreaterThan(Expected: Variant): IModifier;
var
  Msg: string;
begin
  Msg := Format(SpecIntegerShouldBeGreaterThan, [FActual, Integer(Expected)]);
  Result := DoEvaluation(FActual <= Expected, Msg, 'GreaterThan', Expected);
end;

function TIntegerSpecifier.LessThan(Expected: Variant): IModifier;
var
  Msg: string;
begin
  Msg := Format(SpecIntegerShouldBeLessThan, [FActual, Integer(Expected)]);
  Result := DoEvaluation(FActual >= Expected, Msg, 'LessThan', Expected);
end;

function TIntegerSpecifier.Negative: IModifier;
var
  IsNegative: Boolean;
  Msg: string;
begin
  IsNegative := FActual < 0;
  Msg := Format(SpecIntegerShouldBeNegative, [FActual]);
  Result := DoEvaluation(not IsNegative, Msg, 'Negative', null);
end;

function TIntegerSpecifier.Odd: IModifier;
var
  Msg: string;
  IsOdd: Boolean;
begin
  IsOdd := FActual mod 2 <> 0;
  Msg := Format(SpecIntegerShouldBeOdd, [FActual]);
  Result := DoEvaluation(not IsOdd, Msg, 'Odd', null);
end;

function TIntegerSpecifier.Positive: IModifier;
var
  IsPositive: Boolean;
  Msg: string;
begin
  IsPositive := FActual > 0;
  Msg := Format(SpecIntegerShouldBePositive, [FActual]);
  Result := DoEvaluation(not IsPositive, Msg, 'Positive', null);
end;

function TIntegerSpecifier.Prime: IModifier;
var
  ValueIsPrime: Boolean;
  Msg: string;
begin
  ValueIsPrime := IsPrime(FActual);
  Msg := Format(SpecIntegerShouldBePrime, [FActual]);
  Result := DoEvaluation(not ValueIsPrime, Msg, 'Prime', null);
end;

function TIntegerSpecifier.Zero: IModifier;
var
  Msg: string;
begin
  Msg := Format(SpecIntegerShouldBeZero, [FActual]);
  Result := DoEvaluation(FActual <> 0, Msg, 'Zero', null);
end;

{ TBooleanSpecifier }

constructor TBooleanSpecifier.Create(Actual: Boolean; ACallerAddress: Pointer; const AContext: IContext; const AValueName: string);
begin
  inherited Create(ACallerAddress, AContext, AValueName);
  FActual := Actual;
end;

function TBooleanSpecifier.False : IModifier;
var
  Msg: string;
begin
  Msg := Format(SpecStringShouldEqual, [BoolToStr(FActual, System.True), BoolToStr(System.False, System.True)]);
  Result := DoEvaluation(FActual <> System.False, Msg, 'False', null);
end;

function TBooleanSpecifier.True : IModifier;
var
  Msg: string;
begin
  Msg := Format(SpecStringShouldEqual, [BoolToStr(FActual, System.True), BoolToStr(System.True, System.True)]);
  Result := DoEvaluation(FActual <> System.True, Msg, 'True', null);
end;

function TBooleanSpecifier.Equal(Expected : Variant) : IModifier;
var
  Msg: string;
begin
  Msg := Format(SpecStringShouldEqual, [BoolToStr(FActual, System.True), BoolToStr(Boolean(Expected), System.True)]);
  Result := DoEvaluation(Expected <> FActual, Msg, 'Equal', Expected);
end;

{ TFloatSpecifier }

function TFloatSpecifier.AtLeast(Expected: Variant): IModifier;
var
  Msg: string;
begin
  Msg := Format(SpecFloatShouldBeAtLeast, [FActual, Extended(Expected)]);
  FExpected := Expected;
  Result := DoEvaluation(FActual < Extended(Expected), Msg, 'AtLeast', Expected)
end;

function TFloatSpecifier.AtMost(Expected: Variant): IModifier;
var
  Msg: string;
begin
  Msg := Format(SpecFloatShouldBeAtMost, [FActual, Extended(Expected)]);
  FExpected := Expected;
  Result := DoEvaluation(FActual > Extended(Expected), Msg, 'AtMost', Expected)
end;

constructor TFloatSpecifier.Create(Actual: Extended; ACallerAddress: Pointer; const AContext: IContext; const AValueName: string);
begin
  inherited Create(ACallerAddress, AContext, AValueName);
  FActual := Actual;
end;

function TFloatSpecifier.CreateModifier(RemoveLastFailure: Boolean;
  FailureMessage: string): IModifier;
begin
  Result := TFloatModifier.Create(FExpected, FActual, Self, RemoveLastFailure, FailureMessage, FCallerAddress, FContext);
end;

function TFloatSpecifier.Equal(Expected : Variant) : IModifier;
var
  Msg: string;
begin
  Msg := Format(SpecFloatShouldEqual, [FActual, Extended(Expected)]);
  FExpected := Expected;
  Result := DoEvaluation(Expected <> FActual, Msg, 'Equal', Expected);
end;

function TFloatSpecifier.GreaterThan(Expected: Variant): IModifier;
var
  Msg: string;
begin
  Msg := Format(SpecFloatShouldBeGreaterThan, [FActual, Extended(Expected)]);
  FExpected := Expected;
  Result := DoEvaluation(FActual <= Extended(Expected), Msg, 'GreaterThan', Expected);
end;

function TFloatSpecifier.LessThan(Expected: Variant): IModifier;
var
  Msg: string;
begin
  Msg := Format(SpecFloatShouldBeLessThan, [FActual, Extended(Expected)]);
  FExpected := Expected;
  Result := DoEvaluation(FActual >= Extended(Expected), Msg, 'LessThan', Expected);
end;

function TFloatSpecifier.Negative: IModifier;
var
  Msg: string;
  IsNegative: Boolean;
begin
  IsNegative := FActual < 0;
  Msg := Format(SpecFloatShouldBeNegative, [FActual]);
  Result := DoEvaluation(not IsNegative, Msg, 'Negative', null);
end;

function TFloatSpecifier.Positive: IModifier;
var
  Msg: string;
  IsPositive: Boolean;
begin
  IsPositive := FActual > 0;
  Msg := Format(SpecFloatShouldBePositive, [FActual]);
  Result := DoEvaluation(not IsPositive, Msg, 'Positive', null);
end;

function TFloatSpecifier.Zero: IModifier;
var
  Msg: string;
begin
  Msg := Format(SpecFloatShouldBeZero, [FActual]);
  DoEvaluation(FActual <> 0, Msg, 'Zero', null);
end;

{ TStringSpecifier }

function TStringSpecifier.Alpha: IModifier;
var
  Msg: string;
begin
  Msg := Format(SpecStringShouldBeAlpha, [FActual]);
  Result := DoEvaluation(not IsAlpha(FActual), Msg, 'Alpha', null);
end;

function TStringSpecifier.AlphaNumeric: IModifier;
var
  Msg: string;
begin
  Msg := Format(SpecStringShouldBeAlphaNumeric, [FActual]);
  Result := DoEvaluation(not IsAlphaNumeric(FActual), Msg, 'AlphaNumeric', null);
end;

function TStringSpecifier.Contain(Expected: Variant): IModifier;
var
  StringFound: Boolean;
  Msg: string;
begin
  StringFound := Pos(string(Expected), FActual) <> 0;
  Msg := Format(SpecStringShouldContain, [FActual, string(Expected)]);
  FExpected := Expected;
  Result := DoEvaluation(not StringFound, Msg, 'Contain', Expected);
end;

constructor TStringSpecifier.Create(Actual: string; ACallerAddress: Pointer; const AContext: IContext; const AValueName: string);
begin
  inherited Create(ACallerAddress, AContext, AValueName);
  FActual := Actual;
end;

function TStringSpecifier.CreateModifier(RemoveLastFailure: Boolean;
  FailureMessage: string): IModifier;
begin
    Result := TStringModifier.Create(FExpected, FActual, Self, RemoveLastFailure, FailureMessage, FCallerAddress, FContext);
end;

function TStringSpecifier.Empty: IModifier;
var
  Msg: string;
begin
  Msg := Format(SpecStringShouldBeEmpty, [FActual]);
  Result := DoEvaluation(FActual <> '', Msg, 'Empty', null)
end;

function TStringSpecifier.EndWith(Expected: Variant): IModifier;
var
  EndOfString: string;
  Msg: string;
begin
  EndOfString := Copy(FActual, (Length(FActual) - Length(string(Expected))) + 1, Length(string(Expected)));
  Msg := Format(SpecStringShouldEndWith, [FActual, string(Expected)]);
  FExpected := Expected;
  Result := DoEvaluation(EndOfString <> Expected, Msg, 'EndWith', Expected);
end;

function TStringSpecifier.Equal(Expected : Variant) : IModifier;
var
  Msg: string;
begin
  Msg := Format(SpecStringShouldEqual, [FActual, Expected]);
  FExpected := Expected;
  Result := DoEvaluation(Expected <> FActual, Msg, 'Equal', Expected)
end;

function TStringSpecifier.Numeric: IModifier;
var
  Msg: string;
begin
  Msg := Format(SpecStringShouldBeNumeric, [FActual]);
  Result := DoEvaluation(not IsNumeric(FActual), Msg, 'Numeric', null);
end;

function TStringSpecifier.StartWith(Expected : Variant): IModifier;
var
  BeginningOfString: string;
  Msg: string;
begin
  BeginningOfString := Copy(FActual, 1, Length(string(Expected)));
  Msg := Format(SpecStringShouldStartWith, [FActual,  string(Expected)]);
  FExpected := Expected;
  Result := DoEvaluation(BeginningOfString <> string(Expected), Msg, 'StartWith', Expected);
end;

{ TObjectSpecifier }

function TObjectSpecifier.Assigned: IModifier;
begin
  Result := DoEvaluation(not System.Assigned(FActual), SpecObjectShouldBeAssigned, 'Assigned', null);
end;

constructor TObjectSpecifier.Create(Actual: TObject; ACallerAddress: Pointer; const AContext: IContext; const AValueName: string);
begin
  inherited Create(ACallerAddress, AContext, AValueName);
  FActual := Actual;
end;

function TObjectSpecifier.Nil_ : IModifier;
begin
  Result := DoEvaluation(System.Assigned(FActual), SpecPointerShouldBeNil, 'Nil', null);
end;

function TObjectSpecifier.OfType(Expected: TClass) : IModifier;
var
  Msg: string;
begin
  if not System.Assigned(FActual) then
    Result := DoEvaluation(System.True, 'Actual must be assigned for this specification', 'OfType', 'Unassigned')
  else begin
    Msg := Format(SpecObjectShouldBeOfType, [FActual.ClassName, Expected.ClassName]);
    Result := DoEvaluation(FActual.ClassType <> Expected, Msg, 'OfType', Expected.ClassName);
  end;
end;

function TObjectSpecifier.Support(Expected: TGUID): IModifier;
var
  InterfaceFound: Boolean;
  obj: IInterface;
  Msg: string;
begin
  if not System.Assigned(FActual) then
    Result := DoEvaluation(System.True, 'Actual must be assigned for this specification', 'Support', 'Unassigned')
  else begin
    InterfaceFound := FActual.GetInterface(Expected, obj);
    obj := nil;
    Msg := Format(SpecObjectShouldSupport, [FActual.ClassName, GUIDToString(Expected)]);
    Result := DoEvaluation(not InterfaceFound, Msg, 'Support', GUIDToString(Expected));
  end;
end;

function TObjectSpecifier.DescendFrom(Expected: TClass) : IModifier;
var
  Msg: string;
begin
  if not System.Assigned(FActual) then
    Result := DoEvaluation(System.True, 'Actual must be assigned for this specification', 'DescendFrom', 'Unassigned')
  else begin
    Msg := Format(SpecObjectShouldDescendFrom, [FActual.ClassName, Expected.ClassName]);
    Result := DoEvaluation(not FActual.InheritsFrom(Expected), Msg, 'DecendFrom', Expected.ClassName);
  end;
end;

function TObjectSpecifier.Implement(Expected: TGUID): IModifier;
var
  InterfaceFound: Boolean;
  obj: IInterface;
  Msg: string;
begin
  if not System.Assigned(FActual) then
    Result := DoEvaluation(System.True, 'Actual must be assigned for this specification', 'Implement', 'Unassigned')
  else begin
    InterfaceFound := FActual.GetInterface(Expected, obj);
    obj := nil;
    Msg := Format(SpecObjectShouldImplement, [FActual.ClassName, GUIDToString(Expected)]);
    Result := DoEvaluation(not InterfaceFound, Msg, 'Implement', GUIDToString(Expected));
  end;
end;

{ TPointerSpecifier }

function TPointerSpecifier.Assigned: IModifier;
begin
  Result := DoEvaluation(not System.Assigned(FActual), SpecPointerShouldBeAssigned, 'Assigned', null);
end;

constructor TPointerSpecifier.Create(Actual, ACallerAddress: Pointer; const AContext: IContext; const AValueName: string);
begin
  inherited Create(ACallerAddress, AContext, AValueName);
  FActual := Actual;
end;

function TPointerSpecifier.Nil_ : IModifier;
begin
  Result := DoEvaluation(System.Assigned(FActual), SpecPointerShouldBeNil, 'Nil', null);
end;

{ TClassSpecifier }

constructor TClassSpecifier.Create(Actual: TClass; ACallerAddress: Pointer; const AContext: IContext; const AValueName: string);
begin
  inherited Create(ACallerAddress, AContext, AValueName);
  FActual := Actual;
end;

function TClassSpecifier.OfType(Value: TClass) : IModifier;
var
  Msg: string;
begin
  Msg := Format(SpecObjectShouldBeOfType, [FActual.ClassName, Value.ClassName]);
  Result := DoEvaluation(FActual <> Value, Msg, 'OfType', Value.ClassName);
end;

function TClassSpecifier.DescendFrom(Expected: TClass) : IModifier;
var
  Msg: string;
begin
  Msg := Format(SpecObjectShouldDescendFrom, [FActual.ClassName, Expected.ClassName]);
  Result := DoEvaluation(not FActual.InheritsFrom(Expected), Msg, 'DescendFrom', Expected.ClassName);
end;

{ TDateTimeSpecifier }

function TDateTimeSpecifier.AtLeast(Expected: Variant): IModifier;
var
  Msg: string;
begin
  Msg := Format(SpecDateTimeShouldBeAtLeast, [DateTimeToStr(FActual), DateTimeToStr(TDateTime(Expected))]);
  Result := DoEvaluation(FActual < TDateTime(Expected), Msg, 'AtLeast', Expected);
end;

function TDateTimeSpecifier.AtMost(Expected: Variant): IModifier;
var
  Msg: string;
begin
  Msg := Format(SpecDateTimeShouldBeAtMost, [DateTimeToStr(FActual), DateTimeToStr(TDateTime(Expected))]);
  Result := DoEvaluation(FActual > TDateTime(Expected), Msg, 'AtMost', Expected);
end;

constructor TDateTimeSpecifier.Create(Actual: TDateTime; ACallerAddress: Pointer; const AContext: IContext; const AValueName: string);
begin
  inherited Create(ACallerAddress, AContext, AValueName);
  FActual := Actual;
end;

function TDateTimeSpecifier.Equal(Expected: Variant): IModifier;
var
  Msg: string;
begin
  Msg := Format(SpecStringShouldEqual, [DateTimeToStr(FActual), DateTimeToStr(TDateTime(Expected))]);
  Result := DoEvaluation(FActual <> Expected, Msg, 'Equal', Expected)
end;

function TDateTimeSpecifier.GreaterThan(Expected: Variant): IModifier;
var
  Msg: string;
begin
  Msg := Format(SpecDateTimeShouldBeGreaterThan, [DateTimeToStr(FActual), DateTimeToStr(TDateTime(Expected))]);
  Result := DoEvaluation(FActual <= TDateTime(Expected), Msg, 'GreaterThan', Expected)
end;

function TDateTimeSpecifier.LessThan(Expected: Variant): IModifier;
var
  Msg: string;
begin
  Msg := Format(SpecDateTimeShouldBeLessThan, [DateTimeToStr(FActual), DateTimeToStr(TDateTime(Expected))]);
  Result := DoEvaluation(FActual >= TDateTime(Expected), Msg, 'LessThan', Expected)
end;

{ TInterfaceSpecifier }

function TInterfaceSpecifier.Assigned: IModifier;
begin
  Result := DoEvaluation(not System.Assigned(FActual), SpecInterfaceShouldBeAssigned, 'Assigned', null);
end;

constructor TInterfaceSpecifier.Create(Actual: IInterface; ACallerAddress: Pointer; const AContext: IContext; const AValueName:
    string);
begin
  inherited Create(ACallerAddress, AContext, AValueName);
  FActual := Actual;
end;

destructor TInterfaceSpecifier.Destroy;
begin
  FActual := nil;
  inherited Destroy;
end;

function TInterfaceSpecifier.ImplementedBy(Expected: TClass): IModifier;
var
  Obj: TObject;
  Msg: string;
  MatchesExpectedClass: Boolean;
begin
  if not System.Assigned(FActual) then
    Result := DoEvaluation(System.True, 'Actual must be assigned for this specification', 'ImplementedBy', 'Unassigned')
  else begin
    Obj := GetImplementingObjectFor(FActual);
    if System.Assigned(Obj) then begin
      MatchesExpectedClass := Obj.ClassType = Expected;
      Msg := Format(SpecInterfaceShouldBeImplementedBy, [Expected.ClassName]);
      Result := DoEvaluation(not MatchesExpectedClass, Msg, 'ImplementedBy', Expected.ClassName);
    end else
      Result := DoEvaluation(System.True, SpecInterfaceImplementingObjectNotFound, 'ImplementedBy', Expected.ClassName);
  end;
end;

function TInterfaceSpecifier.Nil_: IModifier;
begin
  Result := DoEvaluation(System.Assigned(FActual), SpecInterfaceShouldBeNil, 'Nil', null);
end;

function TInterfaceSpecifier.Support(Expected: TGUID): IModifier;
var
  obj: IInterface;
  InterfaceFound: Boolean;
  Msg: string;
begin
  if not System.Assigned(FActual) then
    Result := DoEvaluation(System.True, 'Actual must be assigned for this specification', 'Support', 'Unassinged')
  else begin
    InterfaceFound := FActual.QueryInterface(Expected, obj) = 0;
    obj := nil;
    Msg := Format(SpecInterfaceShouldSupport, [GuidToString(Expected)]);
    Result := DoEvaluation(not InterfaceFound, Msg, 'Support', GUIDToString(Expected));
  end;
end;

end.
