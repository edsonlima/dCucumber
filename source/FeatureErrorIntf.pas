unit FeatureErrorIntf;

interface

uses
  ErrorIntf;

type
  IFeatureError = interface(IError)
  ['{0BA0638C-53C1-41A8-9EB2-6DC94244E2E6}']
    function GetLine: Integer;
    function GetSugestedAction: string;
    procedure SetLine(const Value: Integer);
    procedure SetSugestedAction(const Value: string);

    property Line: Integer read GetLine write SetLine;
    property SugestedAction: string read GetSugestedAction write SetSugestedAction;
  end;

implementation

end.
