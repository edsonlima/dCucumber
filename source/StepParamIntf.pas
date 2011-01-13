unit StepParamIntf;

interface

type
  IStepParam = interface(IInterface)
  ['{7A685760-0757-4A0F-B4AF-4DBB3513D061}']
    function GetName: string;
    function GetValue: string;
    procedure SetName(const Value: string);
    procedure SetValue(const Value: string);

    property Name: string read GetName write SetName;
    property Value: string read GetValue write SetValue;
  end;

implementation

end.
