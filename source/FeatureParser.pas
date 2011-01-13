unit FeatureParser;

interface

uses
  FeatureParserIntf, FeatureIntf, Classes;

type
  TFeatureParser = class(TInterfacedObject, IFeatureParser)
  private
    FErrors: IInterfaceList;
    FFeatureFileName: string;
    FLoadedFeature: TStringList;

    function GetErrors: IInterfaceList;
    function GetFeatureFileName: string;
    procedure SetFeatureFileName(const Value: string);

    function LoadedFeature: TStringList;
    procedure SetErrors(const Value: IInterfaceList);
  public
    destructor Destroy; override;
    function Parse: IFeature;
    property Errors: IInterfaceList read GetErrors write SetErrors;
    property FeatureFileName: string read GetFeatureFileName write SetFeatureFileName;
  end;

implementation

uses
  Feature, SysUtils, Types, TypeUtils, Scenario, ScenarioIntf, StepIntf, Step, Constants, Error, FeatureError;

destructor TFeatureParser.Destroy;
begin
  if FLoadedFeature <> nil then
    FLoadedFeature.Free;
  if FErrors <> nil then
  begin
    FErrors.Clear;
    FErrors := nil;
  end;
  inherited;
end;

function TFeatureParser.GetErrors: IInterfaceList;
begin
  if FErrors = nil then
    FErrors := TInterfaceList.Create;
  Result := FErrors;
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
  I, LFirstScenarioLine: Integer;
  LFeatureLine: IXString;
  LMatchData: IMatchData;
  LSection: IXString;
  LPrevSection: IXString;
  LScenario: IScenario;
  LStep: IStep;
begin
  Result := TFeature.Create;
  Errors.Clear;
  if not FileExists(FFeatureFileName) then
  begin
    Errors.Add(TFeatureError.NewError(Format(InvalidFeatureFileName, [FFeatureFileName]), 0, SugestionToInvalidFeatureName));
    Exit;
  end;

  LSection := SX('');
  LPrevSection := SX('');
  LFeatureLine := SX('');

  LFeatureLine.Value := LoadedFeature[0];
  LMatchData := LFeatureLine.MatchDataFor(FeatureRegex);
  LFirstScenarioLine := 0;
  if LMatchData <> nil then
  begin
    Result.Titulo := LMatchData.PostMatch.Value;
    for I := 1 to LoadedFeature.Count - 1 do
    begin
      LFeatureLine.Value := LoadedFeature[I];
      if not LFeatureLine.Match(ScenarioRegex) and not LFeatureLine.Trim.IsEmpty then
      begin
        LSection.Mais(LFeatureLine).Mais(#13#10);
        Inc(LFirstScenarioLine);
      end else
        Break;
    end;
    Result.Descricao := LSection.Ate(LSection.Length - 3).Value;
  end
  else
  begin
    Errors.Add(TFeatureError.NewError(Format(InvalidFeature, [FFeatureFileName]), 1, SugestionToFeatureInitialize));
    Exit;
  end;

  Inc(LFirstScenarioLine);
  for I := LFirstScenarioLine to LoadedFeature.Count - 1 do
  begin
    LFeatureLine.Value := LoadedFeature[I];

    if LFeatureLine.Trim.IsEmpty then
      Continue;

    LMatchData := LFeatureLine.MatchDataFor(ScenarioRegex);
    if LMatchData <> nil then
    begin
      LScenario := TScenario.Create;
      LScenario.Titulo := LMatchData.PostMatch.Value;
      Result.Scenarios.Add(LScenario);
      Continue;
    end;

    LMatchData := LFeatureLine.MatchDataFor(StepRegex);
    if LMatchData <> nil then
    begin
      LStep := TStep.Create;
      LStep.Descricao := LMatchData.MatchedData.TrimLeft.Value;
      (Result.Scenarios.Last as IScenario).Steps.Add(LStep);
      Continue;
    end;

    if LFeatureLine.Match(StepValidWord) then
    begin
      Errors.Add(TFeatureError.NewError(Format(InvalidStepDefinition, [I + 1]), I + 1, Format(SugestionToStepInitialize, [LFeatureLine.MatchDataFor(FirstWordRegex).MatchedData.Value])));
      Continue;
    end;

    if (LMatchData = nil) then
      Errors.Add(TFeatureError.NewError(Format(InvalidStepIdentifierError, [I + 1, LFeatureLine.MatchDataFor(FirstWordRegex).MatchedData.Value]), I + 1, SugestedActionToStepError));
  end;
end;

procedure TFeatureParser.SetErrors(const Value: IInterfaceList);
begin
  FErrors := Value;
end;

end.
