unit Error;

interface

uses
  ErrorIntf;

type
  TError = class(TInterfacedObject, IError)
  private
    FMessage: string;
    function GetMessage: string;
    procedure SetMessage(const Value: string);
  public
    property Message: string read GetMessage write SetMessage;
  end;

implementation

function TError.GetMessage: string;
begin
  Result := FMessage;
end;

procedure TError.SetMessage(const Value: string);
begin
  FMessage := Value;
end;

end.
