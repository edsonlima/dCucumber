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

unit Modifiers;

interface

uses BaseObjects, dSpecIntf, Variants;

type
  TModifier = class(TFailureReportingObject, IModifier)
  private
    FRemoveLastFailure: Boolean;
    FShouldHelper: IShouldHelper;
  protected
    FFailureMessage: string;
    function CreateModifier(RemoveLastFailure : Boolean; AFailureMessage : string) : IModifier; virtual;
    function DoNotApplicableFailure : IModifier;
    function DoEvaluation(Failed: Boolean; const Msg, ModName: string; ModValue : Variant) : IModifier;
  public
    constructor Create(const SpecHelper: IShouldHelper; RemoveLastFailure: Boolean; AFailureMessage: string; ACallerAddress: Pointer;
        const AContext: IContext); reintroduce; virtual;
    destructor Destroy; override;
    function Unless(Condition : Boolean) : IModifier;
    function WithAToleranceOf(Value : Extended) : IModifier; virtual;
    function Percent : IModifier; virtual;
    function IgnoringCase : IModifier; virtual;
    function And_ : IShouldHelper;
  end;

  TFloatModifier = class(TModifier)
  private
    FExpected: Extended;
    FActual: Extended;
  protected
    function CreateModifier(RemoveLastFailure : Boolean; AFailureMessage : string) : IModifier; override;
  public
    constructor Create(Expected, Actual: Extended; const SpecHelper: IShouldHelper; RemoveLastFailure: Boolean; AFailureMessage: string;
        ACallerAddress: Pointer; const AContext: IContext); reintroduce;
    function WithAToleranceOf(Value : Extended) : IModifier; override;
    function Percent : IModifier; override;
  end;

  TStringModifier = class(TModifier)
  private
    FActual: string;
    FExpected: string;
  protected
    function CreateModifier(RemoveLastFailure : Boolean; AFailureMessage : string) : IModifier; override;
  public
    constructor Create(Expected, Actual: string; const SpecHelper: IShouldHelper; RemoveLastFailure: Boolean; AFailureMessage: string;
        ACallerAddress: Pointer; const AContext: IContext); reintroduce;
    function IgnoringCase : IModifier; override;
  end;

implementation

uses dSpecUtils, SysUtils, FailureMessages, Math;

{ TModifier }

constructor TModifier.Create(const SpecHelper: IShouldHelper; RemoveLastFailure: Boolean; AFailureMessage: string; ACallerAddress:
    Pointer; const AContext: IContext);
begin
  inherited Create(ACallerAddress, AContext);
  FShouldHelper := SpecHelper;
  FRemoveLastFailure := RemoveLastFailure;
  FFailureMessage := AFailureMessage;
end;

function TModifier.CreateModifier(RemoveLastFailure: Boolean;
  AFailureMessage: string): IModifier;
begin
  Result := TModifier.Create(FShouldHelper, RemoveLastFailure, AFailureMessage, FCallerAddress, FContext);
end;

destructor TModifier.Destroy;
begin
//  FShouldHelper := nil;
  inherited Destroy;
end;

function TModifier.DoEvaluation(Failed: Boolean; const Msg, ModName: string;
  ModValue : Variant): IModifier;
begin
  if FRemoveLastFailure then
    FContext.RepealLastFailure;
  if Failed then
    Fail(Msg);
  Result := CreateModifier(Failed, Msg);
  FContext.DocumentSpec(ModValue, ModName);
end;

function TModifier.DoNotApplicableFailure : IModifier;
begin
  if FRemoveLastFailure then
    FContext.RepealLastFailure;
  Fail(ModNotApplicable);
  Result := CreateModifier(True, ModNotApplicable);
end;

function TModifier.IgnoringCase: IModifier;
begin
  Result := DoNotApplicableFailure;
end;

function TModifier.Percent: IModifier;
begin
  Result := DoNotApplicableFailure;
end;

function TModifier.Unless(Condition: Boolean) : IModifier;
var
  Msg: string;
begin
  if Condition then
    Msg := FFailureMessage + ' - because "unless" condition was true'
  else
    Msg := FFailureMessage;
  Result := DoEvaluation(Condition = True, Msg, 'Unless', Condition);
end;

function TModifier.WithAToleranceOf(Value: Extended) : IModifier;
begin
  Result := DoNotApplicableFailure;
end;

function TModifier.And_: IShouldHelper;
begin
  Result := FShouldHelper.CreateNewShouldHelper(False);
  FContext.DocumentSpec(null, 'And');
end;

{ TFloatModifier }

constructor TFloatModifier.Create(Expected, Actual: Extended; const SpecHelper: IShouldHelper; RemoveLastFailure: Boolean;
    AFailureMessage: string; ACallerAddress: Pointer; const AContext: IContext);
begin
  inherited Create(SpecHelper, RemoveLastFailure, AFailureMessage, ACallerAddress, AContext);
  FExpected := Expected;
  FActual := Actual;
end;

function TFloatModifier.CreateModifier(RemoveLastFailure: Boolean;
  AFailureMessage: string): IModifier;
begin
  Result := TFloatModifier.Create(FExpected, FActual, FShouldHelper, RemoveLastFailure, AFailureMessage, FCallerAddress, FContext);
end;

function TFloatModifier.Percent: IModifier;
var
  Percentage: Extended;
  Msg: string;
  Mismatch : Boolean;
begin
  Percentage := FActual * 100;
  MisMatch := not SameValue(FExpected, Percentage);
  if Mismatch then
    Msg := Format(ModPercentFailure, [FFailureMessage])
  else
    Msg := FFailureMessage + ' - percentage matched';
  Result := DoEvaluation(Mismatch, Msg, 'Percent', null);
end;

function TFloatModifier.WithAToleranceOf(Value: Extended) : IModifier;
var
  ToleranceFailed: Boolean;
  Msg: string;
begin
  ToleranceFailed := Abs(FExpected - FActual) > Value;
  if ToleranceFailed then
    Msg := Format(ModToleranceExceeded, [FFailureMessage, Value])
  else
    Msg := FFailureMessage + ' - tolerance met';
  Result := DoEvaluation(ToleranceFailed, Msg, 'WithAToleranceOf', Value);
end;

{ TStringModifier }

constructor TStringModifier.Create(Expected, Actual: string; const SpecHelper: IShouldHelper; RemoveLastFailure: Boolean;
    AFailureMessage: string; ACallerAddress: Pointer; const AContext: IContext);
begin
  inherited Create(SpecHelper, RemoveLastFailure, AFailureMessage, ACallerAddress, AContext);
  FActual := Actual;
  FExpected := Expected;
end;

function TStringModifier.CreateModifier(RemoveLastFailure: Boolean;
  AFailureMessage: string): IModifier;
begin
  Result := TStringModifier.Create(FExpected, FActual, FShouldHelper, FRemoveLastFailure, FFailureMessage, FCallerAddress, FContext);
end;

function TStringModifier.IgnoringCase: IModifier;
var
  CaseInsenstiveMatch: Boolean;
  Msg: string;
begin
  CaseInsenstiveMatch := CompareText(FActual, FExpected) = 0;
  if not CaseInsenstiveMatch then 
    Msg := Format(ModCaseInsenstiveMatch, [FFailureMessage])
  else
    Msg := FFailureMessage + ' - case insenstive match';
  Result := DoEvaluation(not CaseInsenstiveMatch, Msg, 'IgnoringCase', null);
end;

end.
