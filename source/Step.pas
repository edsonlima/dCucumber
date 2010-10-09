unit Step;

interface

uses
  StepIntf;

type
  TStep = class(TInterfacedObject, IStep)
  private
    FDescricao: string;
    function GetDescricao: string;
    procedure SetDescricao(const Value: string);
  public
    property Descricao: string read GetDescricao write SetDescricao;
  end;

implementation

function TStep.GetDescricao: string;
begin
  Result := FDescricao;
end;

procedure TStep.SetDescricao(const Value: string);
begin
  FDescricao := Value;
end;

end.
