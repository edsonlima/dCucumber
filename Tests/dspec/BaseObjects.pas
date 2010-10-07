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
 
unit BaseObjects;

interface

uses Classes, SysUtils, dSpecIntf;

type
  TFailureListItem = class(TCollectionItem)
  public
    Message : string;
    FailureAddress : Pointer;
  end;

  TFailureList = class(TCollection)
  protected
    function GetItem(Index : Integer) : TFailureListItem;
    procedure SetItem(Index : Integer; Value : TFailureListItem);
  public
    constructor Create;
    function Add : TFailureListItem;
    property Items[Index : Integer] : TFailureListItem read GetItem write SetItem; default;
    procedure AddFailure(const AMessage : string; AFailureAddress : Pointer);
  end;

  ESpecificationFailure = class(Exception);

  TFailureReportingObject = class(TInterfacedObject)
  protected
    FContext : IContext;
    FCallerAddress: Pointer;
    procedure Fail(const AMessage : string);
  public
    constructor Create(ACallerAddress: Pointer; const AContext: IContext); virtual;
    destructor Destroy; override;
  end;

implementation

uses dSpecUtils;

{ TFailureList }

function TFailureList.Add: TFailureListItem;
begin
  Result := TFailureListItem(inherited Add);
end;

procedure TFailureList.AddFailure(const AMessage: string;
  AFailureAddress: Pointer);
begin
  with Add do begin
    Message := AMessage;
    FailureAddress := AFailureAddress;
  end;
end;

constructor TFailureList.Create;
begin
  inherited Create(TFailureListItem);
end;

function TFailureList.GetItem(Index: Integer): TFailureListItem;
begin
  Result := TFailureListItem(inherited GetItem(Index));
end;

procedure TFailureList.SetItem(Index: Integer; Value: TFailureListItem);
begin
  inherited SetItem(Index, Value);
end;

{ TFailureReportingObject }

constructor TFailureReportingObject.Create(ACallerAddress: Pointer; const AContext: IContext);
begin
  inherited Create;
  FCallerAddress := ACallerAddress;
  FContext := AContext;
end;

destructor TFailureReportingObject.Destroy;
begin
  FCallerAddress := nil;
  FContext := nil;
  inherited Destroy;
end;

procedure TFailureReportingObject.Fail(const AMessage: string);
begin
  if FCallerAddress <> nil then
    FContext.AddFailure(AMessage, FCallerAddress)
  else
    FContext.AddFailure(AMessage, CallerAddr);
end;

end.
