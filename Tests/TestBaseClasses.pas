unit TestBaseClasses;

interface

uses
  dSpec;

type
  TParseContext = class(TContext)
  public
    constructor Create(MethodName: string); override;
  end;

implementation

constructor TParseContext.Create(MethodName: string);
begin
  inherited Create(MethodName);
  AutoDoc.Enabled := True;
end;

end.
