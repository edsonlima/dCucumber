unit ValidationRuleIntf;

interface

type
  TValidateFunction = reference to function: Boolean;

  IValidationRule = interface(IInterface)
    ['{5E44704E-3C00-4E22-A7BA-3579C1094EB2}']
    function GetValidateFunction: TValidateFunction;
    procedure SetValidateFunction(const Value: TValidateFunction);

    function Valid: boolean;
    property ValidateFunction: TValidateFunction read GetValidateFunction write SetValidateFunction;
  end;

implementation

end.
