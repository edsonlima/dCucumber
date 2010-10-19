unit Feature;

interface

uses
  FeatureIntf, Classes, dCucuberListIntf;

type
  TFeature = class(TInterfacedObject, IFeature)
  private
    FScenarios: ICucumberList;
    FDescricao: string;
    FTitulo: string;
    function GetScenarios: ICucumberList;
    function GetDescricao: string;
    function GetTitulo: string;
    procedure SetDescricao(const Value: string);
    procedure SetTitulo(const Value: string);
  public
    constructor Create;
    function Valid: Boolean;
    property Scenarios: ICucumberList read GetScenarios;
    property Descricao: string read GetDescricao write SetDescricao;
    property Titulo: string read GetTitulo write SetTitulo;
  end;

implementation

uses
  dCucuberList, ScenarioIntf, ValidationRuleIntf;

constructor TFeature.Create;
begin
  FScenarios := TCucumberList.Create;
  FScenarios.ValidationRule.ValidateFunction := function: Boolean
  var
    I: Integer;
  begin
    Result := FScenarios.Count > 0;
    if Result then
      for I := 0 to FScenarios.Count - 1 do
      begin
        Result := (FScenarios[i] as IValidationRule).Valid;
        if not Result then
          Exit;
      end;
  end;
end;

function TFeature.GetScenarios: ICucumberList;
begin
  Result := FScenarios;
end;

function TFeature.GetDescricao: string;
begin
  Result := FDescricao;
end;

function TFeature.GetTitulo: string;
begin
  Result := FTitulo;
end;

procedure TFeature.SetDescricao(const Value: string);
begin
  FDescricao := Value;
end;

procedure TFeature.SetTitulo(const Value: string);
begin
  FTitulo := Value;
end;

function TFeature.Valid: Boolean;
begin
  Result := FScenarios.ValidationRule.Valid;
end;

end.
