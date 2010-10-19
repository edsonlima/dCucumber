unit Step;

interface

uses
  StepIntf, ValidationRuleIntf;

type
  TStep = class(TInterfacedObject, IStep, IValidationRule)
  private
    FDescricao: string;
    FValidationRule: IValidationRule;
    function GetDescricao: string;
    function GetValidationRule: IValidationRule;
    procedure SetDescricao(const Value: string);
  public
    constructor Create;
    property Descricao: string read GetDescricao write SetDescricao;
    property ValidationRule: IValidationRule read GetValidationRule implements IValidationRule;
  end;

implementation

uses
  ValidationRule, TypeUtils, Constants;

constructor TStep.Create;
begin
  ValidationRule.ValidateFunction := function: Boolean
  begin
    Result := S(FDescricao).Match(StepRegex);
  end;
end;

function TStep.GetDescricao: string;
begin
  Result := FDescricao;
end;

{ TStep }

function TStep.GetValidationRule: IValidationRule;
begin
  if FValidationRule = nil then
    FValidationRule := TValidationRule.Create;
  Result := FValidationRule;
end;

procedure TStep.SetDescricao(const Value: string);
begin
  FDescricao := Value;
end;

end.
