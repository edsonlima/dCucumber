unit dCucuberList;

interface

uses
  Classes, dCucuberListIntf;

type
  TCucumberList = class(TInterfaceList, ICucumberList)
  private
    FValidateFunction: TValidateFunction;
    function GetValidateFunction: TValidateFunction;
    procedure SetValidateFunction(const Value: TValidateFunction);
  public
    function Valid: Boolean;
    property ValidateFunction: TValidateFunction read GetValidateFunction write SetValidateFunction;
  end;

implementation

function TCucumberList.GetValidateFunction: TValidateFunction;
begin
  Result := FValidateFunction;
end;

procedure TCucumberList.SetValidateFunction(const Value: TValidateFunction);
begin
  FValidateFunction := Value;
end;

function TCucumberList.Valid: Boolean;
begin
  Result := True;
  if Assigned(FValidateFunction) then
    Result := FValidateFunction;
end;

end.
