unit Feature;

interface

uses
  FeatureIntf, Classes;

type
  TFeature = class(TInterfacedObject, IFeature)
  private
    FCenarios: IInterfaceList;
    FDescricao: string;
    FTitulo: string;
    function GetCenarios: IInterfaceList;
    function GetDescricao: string;
    function GetTitulo: string;
    procedure SetDescricao(const Value: string);
    procedure SetTitulo(const Value: string);
  public
    constructor Create;
    property Cenarios: IInterfaceList read GetCenarios;
    property Descricao: string read GetDescricao write SetDescricao;
    property Titulo: string read GetTitulo write SetTitulo;
  end;

implementation

constructor TFeature.Create;
begin
  FCenarios := TInterfaceList.Create;
end;

function TFeature.GetCenarios: IInterfaceList;
begin
  Result := FCenarios;
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

end.
