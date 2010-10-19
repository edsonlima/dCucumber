unit ErrorIntf;

interface

type
  IError = interface(IInterface)
  ['{AB77CB0C-C18F-4F30-AD02-4C9E07DDA708}']
    function GetMessage: string;
    procedure SetMessage(const Value: string);

    property Message: string read GetMessage write SetMessage;
  end;

implementation

end.
