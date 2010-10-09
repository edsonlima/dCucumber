unit FeatureParser;

interface

uses
  FeatureParserIntf, FeatureIntf, Classes;

type
  TFeatureParser = class(TInterfacedObject, IFeatureParser)
  private
    FFeatureFileName: string;
    FLoadedFeature: TStringList;

    function GetFeatureFileName: string;
    procedure SetFeatureFileName(const Value: string);

    function LoadedFeature: TStringList;
  public
    destructor Destroy; override;
    function Parse: IFeature;
    property FeatureFileName: string read GetFeatureFileName write SetFeatureFileName;
  end;

implementation

uses
  Feature, PerlRegEx, SysUtils, Types, TypeUtils, Scenario, ScenarioIntf, StepIntf, Step;

destructor TFeatureParser.Destroy;
begin
  if FLoadedFeature <> nil then
    FLoadedFeature.Free;
  inherited;
end;

function TFeatureParser.GetFeatureFileName: string;
begin
  Result := FFeatureFileName;
end;

function TFeatureParser.LoadedFeature: TStringList;
begin
  if FLoadedFeature = nil then
    FLoadedFeature := TStringList.Create;

  if FileExists(FFeatureFileName) and (FLoadedFeature.Count = 0) then
    FLoadedFeature.LoadFromFile(FFeatureFileName);
  Result := FLoadedFeature;
end;

procedure TFeatureParser.SetFeatureFileName(const Value: string);
begin
  FFeatureFileName := Value;
end;

function TFeatureParser.Parse: IFeature;
var
  LFeatureLine: string;
  LMatchData: IMatchData;
  LRegex: TPerlRegEx;
  LSection: IXString;
  LPrevSection: string;
  LScenario: IScenario;
  LStep: IStep;
begin
  Result := TFeature.Create;

  LRegex := TPerlRegEx.Create;
  try
    LSection := SX('');
    LPrevSection := '';
    for LFeatureLine in LoadedFeature do
    begin
      LRegex.Subject := LFeatureLine;
      // Encontrando o título da Feature
      LRegex.RegEx := '^Funcionalidade: ';
      if LRegex.Match then
      begin
        Result.Titulo := LRegex.SubjectRight;
        LPrevSection := LRegex.MatchedText;
        Continue;
      end;

      // Encontrando os cenários
      LRegex.RegEx := '^(.*)Cenário: ';
      if LRegex.Match then
      begin
        // Aproveita a passada e adiciona a descricao da feature
        if S(LPrevSection).Equals('Funcionalidade: ') then
        begin
          Result.Descricao := LSection.Ate(LSection.Length - 3).Value;
          LSection.Clear;
        end;
        LScenario := TScenario.Create;
        LScenario.Titulo := LRegex.SubjectRight;
        Result.Scenarios.Add(LScenario);
        LPrevSection := LRegex.MatchedText;
        Continue;
      end;
      LMatchData := S(LFeatureLine).MatchDataFor('^(.*)(Dado |Quando |Então |E |Mas )');
      if LMatchData <> nil then
      begin
        LStep := TStep.Create;
        LStep.Descricao := LMatchData.MatchedData.TrimLeft.Mais(LMatchData.PostMatch).Value;
        (Result.Scenarios.Last as IScenario).Steps.Add(LStep);
      end;

      if not SX(LFeatureLine).Trim.IsEmpty then
        LSection.Mais(LFeatureLine).Mais(#13#10);
    end;
  finally
    LRegex.Free;
  end;
end;

end.
