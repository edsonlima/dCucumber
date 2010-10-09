unit ScenarioIntf;

interface

uses
  Classes;

type
  IScenario = interface(IInterface)
  ['{9614E22D-0025-424C-9F49-F7D83085C2A9}']
    function GetSteps: IInterfaceList;
    function GetTitulo: string;
    procedure SetSteps(const Value: IInterfaceList);
    procedure SetTitulo(const Value: string);

    function Valid: Boolean;
    property Titulo: string read GetTitulo write SetTitulo;
    property Steps: IInterfaceList read GetSteps write SetSteps;
  end;

implementation

end.
