unit FeatureError;

interface

uses
  FeatureErrorIntf, Error;

type
  TFeatureError = class(TError, IFeatureError)
  private
    FLine: Integer;
    FSugestedAction: string;
    function GetLine: Integer;
    function GetSugestedAction: string;
    procedure SetLine(const Value: Integer);
    procedure SetSugestedAction(const Value: string);
  public
    class function NewError(const AMessage: string; const ALine: Integer; const ASugestedAction: string): IFeatureError;
    property Line: Integer read GetLine write SetLine;
    property SugestedAction: string read GetSugestedAction write SetSugestedAction;
  end;

implementation

function TFeatureError.GetLine: Integer;
begin
  Result := FLine;
end;

function TFeatureError.GetSugestedAction: string;
begin
  Result := FSugestedAction;
end;

class function TFeatureError.NewError(const AMessage: string; const ALine: Integer; const ASugestedAction: string): IFeatureError;
begin
  Result := Self.Create;
  Result.Message := AMessage;
  Result.Line := ALine;
  Result.SugestedAction := ASugestedAction;
end;

procedure TFeatureError.SetLine(const Value: Integer);
begin
  FLine := Value;
end;

procedure TFeatureError.SetSugestedAction(const Value: string);
begin
  FSugestedAction := Value;
end;

end.
