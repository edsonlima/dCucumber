unit dCucuberListIntf;

interface

uses
  Classes;

type
  TValidateFunction = reference to function: Boolean;

  ICucumberList = interface(IInterfaceList)
  ['{BEAB0C2D-9DA5-4E6C-8E05-838646208B98}']
    function GetValidateFunction: TValidateFunction;
    procedure SetValidateFunction(const Value: TValidateFunction);

    property ValidateFunction: TValidateFunction read GetValidateFunction write SetValidateFunction;
    function Valid: Boolean;
  end;

implementation

end.
