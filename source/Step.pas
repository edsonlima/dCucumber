unit Step;

interface

uses
  StepIntf, ValidationRuleIntf, StepParamsIntf;

type
  TStep = class(TInterfacedObject, IStep, IValidationRule)
  private
    FChanged: Boolean;
    FDescricao: string;
    FParams: IStepParams;
    FParamsRegex: string;
    FValidationRule: IValidationRule;
    procedure SetDescricao(const Value: string);
    function GetDescricao: string;
    function GetMetodoDeTeste: string;
    function GetParams: IStepParams;
    function GetValidationRule: IValidationRule;
    procedure ClearAndSetParams;
    function GetParamsRegex: string;
    procedure SetParamsRegex(const Value: string);
  public
    constructor Create;
    destructor Destroy; override;

    property Descricao: string read GetDescricao write SetDescricao;
    property MetodoDeTeste: string read GetMetodoDeTeste;
    property ValidationRule: IValidationRule read GetValidationRule implements IValidationRule;
    property ParamsRegex: string read GetParamsRegex write SetParamsRegex;
    property Params: IStepParams read GetParams;
  end;

implementation

uses
  ValidationRule, TypeUtils, Constants, StepParams;

constructor TStep.Create;
begin
  FParams := TStepParams.Create;
  ValidationRule.ValidateFunction := function: Boolean
  begin
    Result := S(FDescricao).Match(StepRegex);
  end;
end;

destructor TStep.Destroy;
begin
  FParams := nil;
  inherited;
end;

procedure TStep.ClearAndSetParams;
var
  I: Integer;
  LDescription: IXString;
  LMatchedParams: IMatchData;
begin
  if not S(FParamsRegex).IsEmpty(True) and not S(FDescricao).IsEmpty(True) and FChanged then
  begin
    FParams.Clear;
    LDescription := SX(FDescricao);
    LMatchedParams := LDescription.MatchDataFor(FParamsRegex);
    for I := 0 to LMatchedParams.Size.Value - 1 do
      FParams.Add(LMatchedParams[I].Value);
  end;
end;

function TStep.GetDescricao: string;
begin
  Result := FDescricao;
end;

function TStep.GetMetodoDeTeste: string;
begin
  Result := S(Descricao).AsClassName('');
end;

function TStep.GetParams: IStepParams;
begin
  if FChanged then
    ClearAndSetParams;
  Result := FParams;
end;

function TStep.GetParamsRegex: string;
begin
  Result := FParamsRegex;
end;

function TStep.GetValidationRule: IValidationRule;
begin
  if FValidationRule = nil then
    FValidationRule := TValidationRule.Create;
  Result := FValidationRule;
end;

procedure TStep.SetDescricao(const Value: string);
begin
  FChanged := True;
  FDescricao := Value;
end;

procedure TStep.SetParamsRegex(const Value: string);
begin
  FChanged := True;
  FParamsRegex := Value;
end;

end.
