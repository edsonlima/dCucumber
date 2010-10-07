unit FeatureParser;

interface

uses
  FeatureParserIntf, FeatureIntf;

type
  TFeatureParser = class(TInterfacedObject, IFeatureParser)
  private
    FFeatureFileName: string;
    function GetFeatureFileName: string;
    procedure SetFeatureFileName(const Value: string);

    function LoadFeature: string;
  public
    function Parse: IFeature;
    property FeatureFileName: string read GetFeatureFileName write SetFeatureFileName;
  end;

implementation

uses
  Feature, PerlRegEx, SysUtils, Types, TypeUtils;

function TFeatureParser.GetFeatureFileName: string;
begin
  Result := FFeatureFileName;
end;

function TFeatureParser.LoadFeature: string;
begin
  Result := '';
  if FileExists(FFeatureFileName) then
    Result := S(FFeatureFileName).LoadFromFile;
end;

function TFeatureParser.Parse: IFeature;
var
  LRegex: TPerlRegEx;
  LTitulo: string;
begin
  Result := TFeature.Create;

  LRegex := TPerlRegEx.Create;
  try
    LRegex.RegEx := '^Funcionalidade:';
    LRegex.Subject := LoadFeature;
    if LRegex.Match then
    begin
      LTitulo := LRegex.MatchedText;
      Result.Descricao := LRegex.SubjectRight;
    end;
  finally
    LRegex.Free;
  end;
end;

procedure TFeatureParser.SetFeatureFileName(const Value: string);
begin
  FFeatureFileName := Value;
end;

end.
