unit ScenarioIntf;

interface

uses
  Classes, dCucuberListIntf, TestFramework;

type
//  IStepParam = interface
//    property Name;
//    property Value;
//    property StepName;
//  end;

  IScenario = interface(IInterface)
  ['{9614E22D-0025-424C-9F49-F7D83085C2A9}']
    function GetSteps: ICucumberList;
    function GetTestName: string;
    function GetTitulo: string;
    procedure SetSteps(const Value: ICucumberList);
    procedure SetTitulo(const Value: string);

    property Titulo: string read GetTitulo write SetTitulo;
    property Steps: ICucumberList read GetSteps write SetSteps;
    property TestName: string read GetTestName;
//    property StepParams: IInterfaceList;
  end;

implementation

end.
