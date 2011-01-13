unit StepParamsIntf;

interface

uses
  Classes, StepParamIntf;

type
  IStepParams = interface(IInterface)
  ['{74097CFC-21AA-402D-BECA-2AD9F1B7810B}']
    function GetParam(AParam: variant): IStepParam;
    procedure SetParam(AParam: variant; const Value: IStepParam);

    procedure Clear;
    function ByName(const AParamName: string): IStepParam;
    function Add(const AParam: string): IStepParam;
    property Param[AParam: variant]: IStepParam read GetParam write SetParam; default;
  end;

implementation

end.
