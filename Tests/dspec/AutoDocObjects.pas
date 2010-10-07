unit AutoDocObjects;

interface

uses dSpecIntf;

type
  TBaseAutoDoc = class(TInterfacedObject, IAutoDoc)
  private
    FContext: IContext;
    FEnabled: Boolean;
    function GetEnabled : Boolean;
    procedure SetEnabled(Value : Boolean);
  protected
    function SplitCamelCaseString(const s : string) : string;
    function DoOutput(const s : string) : string;
  public
    constructor Create(const AContext: IContext);
    destructor Destroy; override;
    function BeginSpec(const ContextName, SpecName : string) : string;
    function DocSpec(const Spec : string) : string;
  end;

implementation

uses SysUtils;

{ TBaseAutoDoc }

function TBaseAutoDoc.BeginSpec(const ContextName, SpecName: string): string;
begin
  Result := DoOutput(ContextName + ' - ' + SplitCamelCaseString(SpecName));
end;

constructor TBaseAutoDoc.Create(const AContext: IContext);
begin
  FContext := AContext;
end;

destructor TBaseAutoDoc.Destroy;
begin
  FContext := nil;
  inherited;
end;

function TBaseAutoDoc.DocSpec(const Spec: string): string;
var
  ContextDescription: string;
begin
  if FContext.ContextDescription <> '' then
    ContextDescription := FContext.ContextDescription + ', '
  else
    ContextDescription := '';
  Result := DoOutput('  ' + ContextDescription + Spec);
end;

function TBaseAutoDoc.DoOutput(const s: string): string;
begin
  if FEnabled then
    Result := s
  else
    Result := '';
end;

function TBaseAutoDoc.GetEnabled: Boolean;
begin
  Result := FEnabled;
end;

procedure TBaseAutoDoc.SetEnabled(Value: Boolean);
begin
  FEnabled := Value;
end;

function TBaseAutoDoc.SplitCamelCaseString(const s: string): string;
var
  i: Integer;
begin
  i := 2;
  Result := s[1];
  while i <= Length(s) do begin
    if s[i] = UpperCase(s[i]) then
      Result := Result + ' ';
    Result := Result + LowerCase(s[i]);
    Inc(i);
  end;
end;

end.
