unit StepIntf;

interface

uses
  ValidationRuleIntf, StepParamsIntf;

type
  IStep = interface(IInterface)
  ['{E1A03301-32F2-4A7B-886D-2B4188982A5B}']
    function GetDescricao: string;
    function GetMetodoDeTeste: string;
    function GetParams: IStepParams;
    function GetParamsRegex: string;
    function GetValidationRule: IValidationRule;
    procedure SetDescricao(const Value: string);
    procedure SetParamsRegex(const Value: string);

    property Descricao: string read GetDescricao write SetDescricao;
    property MetodoDeTeste: string read GetMetodoDeTeste;
    property ValidationRule: IValidationRule read GetValidationRule;
    property Params: IStepParams read GetParams;
    property ParamsRegex: string read GetParamsRegex write SetParamsRegex;
  end;

implementation

end.
