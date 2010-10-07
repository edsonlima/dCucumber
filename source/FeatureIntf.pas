unit FeatureIntf;

interface

uses
  Classes;

type
  IFeature = interface(IInterface)
  ['{862178A4-5ACE-44C5-8990-4D96133984C1}']
    function GetScenarios: IInterfaceList;
    function GetDescricao: string;
    function GetTitulo: string;
    procedure SetDescricao(const Value: string);
    procedure SetTitulo(const Value: string);

    property Scenarios: IInterfaceList read GetScenarios;
    property Descricao: string read GetDescricao write SetDescricao;
    property Titulo: string read GetTitulo write SetTitulo;
  end;

implementation

end.
