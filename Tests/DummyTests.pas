unit DummyTests;

interface

uses
  TestFramework, Scenario;

type
  TUmCenarioValido = class(TScenario)
    published
    procedure DadoQueTenhoUmStepValido;
  end;

  TUmCenarioInvalido = class(TScenario)
    published
  end;

  TUmCenarioCom3Passos = class(TScenario)
    published
    procedure DadoQueTenho3PassosNesseCenario;
    procedure QuandoEuValidarAFeatuare;
    procedure EntaoElaDeveSerValida;
  end;

implementation

{ TUmCenarioValido }

procedure TUmCenarioValido.DadoQueTenhoUmStepValido;
begin
  CheckTrue(True);
end;

{ TUmCenarioCom3Passos }

procedure TUmCenarioCom3Passos.DadoQueTenho3PassosNesseCenario;
begin
  CheckTrue(True);
end;

procedure TUmCenarioCom3Passos.EntaoElaDeveSerValida;
begin
  CheckTrue(True);
end;

procedure TUmCenarioCom3Passos.QuandoEuValidarAFeatuare;
begin
  CheckTrue(True);
end;

end.
