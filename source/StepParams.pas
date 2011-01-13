unit StepParams;

interface

uses
  StepParamsIntf, StepParamIntf, Classes;

type
  TStepParams = class(TInterfacedObject, IStepParams)
  private
    FParams: IInterfaceList;
    function GetParam(AParam: Variant): IStepParam;
    procedure SetParam(AParam: Variant; const Value: IStepParam);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    function Add(const AParam: string): IStepParam;
    function ByName(const AParamName: string): IStepParam;
    property Param[AParam: Variant]: IStepParam read GetParam write SetParam; default;
  end;

implementation

uses
  StepParam, TypeUtils, Constants;

procedure TStepParams.Clear;
begin
  FParams.Clear;
end;

constructor TStepParams.Create;
begin
  inherited Create;
  FParams := TInterfaceList.Create;
end;

destructor TStepParams.Destroy;
begin
  Clear;
  FParams := nil;
  inherited Destroy;
end;

function TStepParams.Add(const AParam: string): IStepParam;
begin
  Result := TStepParam.Create;
  Result.Name := AParam;
  Result.Value := AParam;
  FParams.Add(Result);
end;

function TStepParams.ByName(const AParamName: string): IStepParam;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to FParams.Count - 1 do
    if S((FParams[i] as IStepParam).Name).Equals(AParamName) then
    begin
      Result := (FParams[i] as IStepParam);
      Break;
    end;
end;

function TStepParams.GetParam(AParam: Variant): IStepParam;
begin
  case TVarData(AParam).VType of
    varString, varOleStr, varUString: Result := ByName(AParam)
  else
    Result := (FParams[AParam] as IStepParam);
  end
end;

procedure TStepParams.SetParam(AParam: Variant; const Value: IStepParam);
var
  LParam: IStepParam;
begin
  case TVarData(AParam).VType of
    varString, varOleStr, varUString: LParam := ByName(AParam)
  else
    if FParams.Count -1 >= AParam then
      LParam := (FParams[AParam] as IStepParam)
  end;
  if (LParam = nil) then
    if (Value <> nil) then
      LParam := Value
    else
    begin
      LParam := TStepParam.Create;
      LParam.Name := AParam;
      LParam.Value := AParam;
    end;

  if FParams.IndexOf(LParam) = NotFound then
    FParams.Add(LParam);
end;

end.
