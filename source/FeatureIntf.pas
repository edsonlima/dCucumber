unit FeatureIntf;

interface

uses
  Classes, dCucuberListIntf;

type
  IFeature = interface(IInterface)
  ['{862178A4-5ACE-44C5-8990-4D96133984C1}']
    function GetScenarios: ICucumberList;
    function GetDescricao: string;
    function GetTitulo: string;
    procedure SetDescricao(const Value: string);
    procedure SetTitulo(const Value: string);

    function Valid: Boolean;

    property Scenarios: ICucumberList read GetScenarios;
    property Descricao: string read GetDescricao write SetDescricao;
    property Titulo: string read GetTitulo write SetTitulo;
  end;

implementation

end.
