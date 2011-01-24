unit Constants;

interface

const
  NotFound = -1;

  InvalidParamTypeError = 'O tipo do parâmetro informado (%s) é inválido.'#13#10'Utilize apenas os tipos varString, varOleStr, varUString, varSmallInt, varInteger, varBoolean, varShortInt, varByte, varWord, varLongWord, varInt64, varUInt64.';

  ScenarioRegex = '^(\s*)Cenário:\s';
  FeatureRegex: UTF8String = '^(\s|)*Funcionalidade:\s*';
  StepRegex: UTF8String = '^(\s*)(Dado|Quando|Então|E|Mas)\s.*';
  StepValidWord: UTF8String = '^(\s*)(Dado|Quando|Então|E|Mas)\b';
  FirstWordRegex: UTF8String = '\b\w*\b';
  InvalidStepIdentifierError = 'A linha %d começa com uma palavra chave desconhecida (%s).';
  SugestedActionToStepError = 'Os passos devem começar com: Dado, Quando, E, Então, e Mas';
  InvalidStepDefinition = 'O passo da linha %d deve conter mais do que apenas uma palavra.';
  InvalidFeature = 'A feature ''%s'' não começa com a palavra Funcionalidade: seguida de seu título na primeira linha.';
  SugestionToStepInitialize = '%s... ?!';
  SugestionToFeatureInitialize = 'Exemplo: Funcionalidade: Aqui vai o título da sua funcionalidade.';
  InvalidFeatureFileName = 'O arquivo que você tentou carregar (%s) não existe.';
  SugestionToInvalidFeatureName = 'Tente carregar um arquivo que exista :)';

implementation

    end.
