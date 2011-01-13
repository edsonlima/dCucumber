unit StepParam;

interface

uses
  StepParamIntf;

type
  TStepParam = class(TInterfacedObject, IStepParam)
  private
    FName: string;
    FValue: string;
    function GetName: string;
    function GetValue: string;
    procedure SetName(const Value: string);
    procedure SetValue(const Value: string);
  public
    property Name: string read GetName write SetName;
    property Value: string read GetValue write SetValue;
  end;

implementation

function TStepParam.GetName: string;
begin
  Result := FName;
end;

function TStepParam.GetValue: string;
begin
  Result := FValue;
end;

procedure TStepParam.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TStepParam.SetValue(const Value: string);
begin
  FValue := Value;
end;

end.
