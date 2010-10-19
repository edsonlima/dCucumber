unit dCucuberList;

interface

uses
  ValidationRuleIntf, Classes, dCucuberListIntf;

type
  TCucumberList = class(TInterfaceList, ICucumberList, IValidationRule)
  private
    FValidationRule: IValidationRule;
    function GetValidationRule: IValidationRule;
  public
    property ValidationRule: IValidationRule read GetValidationRule implements IValidationRule;
  end;

implementation

uses
  ValidationRule;

{ TCucumberList }

function TCucumberList.GetValidationRule: IValidationRule;
begin
  if FValidationRule = nil then
    FValidationRule := TValidationRule.Create;
  Result := FValidationRule;
end;

end.
