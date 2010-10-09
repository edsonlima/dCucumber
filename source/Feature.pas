unit Feature;

interface

uses
  FeatureIntf, Classes;

type
  TFeature = class(TInterfacedObject, IFeature)
  private
    FScenarios: IInterfaceList;
    FDescricao: string;
    FTitulo: string;
    function GetScenarios: IInterfaceList;
    function GetDescricao: string;
    function GetTitulo: string;
    procedure SetDescricao(const Value: string);
    procedure SetTitulo(const Value: string);
  public
    constructor Create;
    function Valid: Boolean;
    property Scenarios: IInterfaceList read GetScenarios;
    property Descricao: string read GetDescricao write SetDescricao;
    property Titulo: string read GetTitulo write SetTitulo;
  end;

implementation

constructor TFeature.Create;
begin
  FScenarios := TInterfaceList.Create;
end;

function TFeature.GetScenarios: IInterfaceList;
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
  Result := FScenarios.Count > 0;
end;

end.
