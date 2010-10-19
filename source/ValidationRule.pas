unit ValidationRule;

interface

uses
  ValidationRuleIntf;

type
  TValidationRule = class(TInterfacedObject, IValidationRule)
  private
    FValidateFunction: TValidateFunction;
    function GetValidateFunction: TValidateFunction;
    procedure SetValidateFunction(const Value: TValidateFunction);
  public
    function Valid: Boolean;
    property ValidateFunction: TValidateFunction read GetValidateFunction write SetValidateFunction;
  end;

implementation

function TValidationRule.GetValidateFunction: TValidateFunction;
begin
  Result := FValidateFunction;
end;

procedure TValidationRule.SetValidateFunction(const Value: TValidateFunction);
begin
  FValidateFunction := Value;
end;

function TValidationRule.Valid: Boolean;
begin
  Result := True;
  if Assigned(FValidateFunction) then
    Result := FValidateFunction;
end;

end.
