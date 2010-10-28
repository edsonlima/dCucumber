unit TypeUtils;

interface

{
  fazer mÈtodo onde È passado um arquivo xsd para validar o conte˙do da string supondo que seja um xml
}

uses
  SysUtils, Classes, DISystemCompat, DIUtils, DIRegEx;

const
  NOME_ARQUIVO = 'c:\arquivo.txt';
  QUEBRA_DE_LINHA = #13#10;
  FILTRO_PADRAO_DE_ARQUIVO = '*.*';
  ACCENTED_CHARS: array [0 .. 56] of Char = '¿¡¬√ƒ≈∆«»… ÀÃÕŒœ–—“”‘’÷Ÿ⁄€‹›‡·‚„‰ÂÊÁËÈÍÎÏÌÓÔÒÚÛÙıˆ˘˙˚¸˝ˇ';
  UNACCENTED_CHARS: array [0 .. 56] of Char = 'AAAAAAACEEEEIIIIDNOOOOOUUUUYaaaaaaaceeeeiiiinooooouuuuyy';
  // ACCENTED_CHARS_SET: set of Char = [#192 .. #255] - [#215, #216, #222, #223, #247, #248];

  REGEX_PRIMEIRA_LETRA_DE_CADA_PALAVRA = '\b(\w)';
  REGEX_ACCENTED_CHARS = '[¿¡¬√ƒ≈∆«»… ÀÃÕŒœ–—“”‘’÷Ÿ⁄€‹›‡·‚„‰ÂÊÁËÈÍÎÏÌÓÔÒÚÛÙıˆ˘˙˚¸˝ˇ]';

  // Evita possÌveis problemas ao executar regex em string muito grandes;
{$MAXSTACKSIZE $00200000}

type

  TProcedureString = procedure(Valor: string) of object;

  IMatchData = interface;

  IString = interface
    ['{09850B99-B6B6-4A59-9054-A2866B5C83F4}']
    function AdicionarAntesDaString(AValue: string; Repetir: Integer = 1): string;
    function AdicionarDepoisDaString(AValue: string; Repetir: Integer = 1): string;
    function GetValue: string;
    function GetAt(De, Ate: Integer): string;
    procedure SetAt(De, Ate: Integer; const Value: string);
    function GetAtStr(De, Ate: string): string;
    procedure SetAtStr(De, Ate: string; const Value: string);
    function Vezes(AValue: Integer): string;
    function Menos(AValue: string): string; overload;
    function Menos(AValues: array of string): string; overload;
    function Mais(AValue: string): string; overload;
    function Mais(const AValue: IString): string; overload;
    function Centralizado(ATamanho: Integer = 38): string;
    function AlinhadoADireita(ATamanho: Integer = 38): string;
    function AlinhadoAEsquerda(ATamanho: Integer = 38): string;
    function ComZerosAEsquerda(ATamanho: Integer): string;
    function Contem(AValue: string): Boolean; overload;
    function Encripta(AChave: string): string;
    function EncriptSimples: string;
    function Decripta(AChave: string): string;
    function Format(AValues: array of const ): string;
    function EstaContidoEm(AValue: string): Boolean; overload;
    function EstaContidoEm(AValue1, AValue2: string): Boolean; overload;
    function EstaContidoEm(AValue1, AValue2, AValue3: string): Boolean; overload;
    function EstaContidoEm(AValue1, AValue2, AValue3, AValue4: string): Boolean; overload;
    function EstaContidoEm(AValue: array of string): Boolean; overload;
    function Trim: string;
    function TrimLeft: string;
    function TrimRight: string;
    function GetChave(ANome: string): string;
    procedure SetChave(ANome: string; const Value: string);
    function Replace(AOldPattern, ANewPattern: string): string; overload;
    function Replace(ARegexPattern: UTF8String; ANewPattern: string): string; overload;
    function Replace(AOldPattern, ANewPattern: string; Flags: TReplaceFlags): string; overload;
    function Replace(AOldPatterns, ANewPatterns: array of string): string; overload;
    function Replace(AOldPatterns, ANewPatterns: array of string; Flags: TReplaceFlags): string; overload;
    function Replace(AOldPatterns: array of string; ANewPattern: string): string; overload;
    function Replace(AOldPatterns: array of string; ANewPattern: string; Flags: TReplaceFlags): string; overload;
    function ReplaceAll(AOldPattern, ANewPattern: string): string; overload;
    function Reverter: string;
    function Ate(APosicao: Integer): string; overload;
    function Ate(APosicao: string): string; overload;
    function AteAntesDe(APosicao: string): string;
    procedure SaveToFile(AArquivo: string = NOME_ARQUIVO);
    function ShowConfirmation: Boolean;
    procedure ShowError;
    procedure ShowWarning;
    procedure Show;
    function Modulo10: string;
    function Modulo11(Base: Integer = 9; Resto: Boolean = false): string;
    function Length: Integer;
    function Copy(AIndex, ACount: Integer): string;
    function ValidarComXSD(AArquivo: string): string;
    function LowerCase: string;
    function UpperCase: string;
    function IndexOf(ASubstring: string): Integer; overload;
    function IndexOf(ASubstring: string; AOffSet: Integer): Integer; overload;
    function ComAspas: string;
    function Aspas: string;
    function UTF8Decode: string;
    function UTF8Encode: string;
    function Humanize: string;
    function Desumanize: string;
    function Camelize: string;
    function Underscore: string;
    function AsInteger: Integer;
    function IndiceNoArray(AArray: array of string): Integer;
    function ListarArquivos(AFiltro: string = FILTRO_PADRAO_DE_ARQUIVO; AMostrarCaminhoCompleto: Boolean = True;
      ASeparador: string = QUEBRA_DE_LINHA): string;
    function ListarArquivosComPrefixoParaCopy(AFiltro: string = FILTRO_PADRAO_DE_ARQUIVO; AMostrarCaminhoCompleto: Boolean = True;
      ASeparador: string = QUEBRA_DE_LINHA): string;
    function ListarPastas(AFiltro: string = FILTRO_PADRAO_DE_ARQUIVO; AMostrarCaminhoCompleto: Boolean = True;
      ASeparador: string = QUEBRA_DE_LINHA): string;
    function ListarPastasEArquivos(AFiltro: string = FILTRO_PADRAO_DE_ARQUIVO; AMostrarCaminhoCompleto: Boolean = True;
      ASeparador: string = QUEBRA_DE_LINHA; Recursividade: Boolean = false): string;
    function AsStringList: TStringList; // o programador precisa controlar o tempo de vida do retorno
    function LoadFromFile: string;
    function Equals(AValor: string): Boolean; overload;
    function Equals(AValor: IString): Boolean; overload;
    function IgualA(AValor: string): Boolean; overload;
    function IgualA(AValor: IString): Boolean; overload;
    property Chave[ANome: string]: string read GetChave write SetChave;
    property Get[De, Ate: Integer]: string read GetAt write SetAt; default;
    property Str[De, Ate: string]: string read GetAtStr write SetAtStr;
    function Contem(AValues: array of string): Boolean; overload;
    function GetVazia: Boolean;
    procedure SetValue(const Value: string);
    property Value: string read GetValue write SetValue;
    property Vazia: Boolean read GetVazia;
    function After(AIndex: Integer): string;
    procedure Clear;
    function Match(ARegex: UTF8String): Boolean;
    function MatchDataFor(ARegex: UTF8String): IMatchData;
    function AsClassName(AUnsingPrefix: string = 'T'): string;
    function WithoutAccents: string;
  end;

  TString = class(TInterfacedObject, IString)
  private
    FValue: string;
    FRegex: TDIPerlRegEx;
    function Regex: TDIPerlRegEx;
  protected
    function GetAtStr(De, Ate: string): string;
    procedure SetAtStr(De, Ate: string; const AValue: string);
    function GetAt(De, Ate: Integer): string;
    procedure SetAt(De, Ate: Integer; const AValue: string);
    function GetVazia: Boolean;
    function GetValue: string;
    procedure SetValue(const Value: string);
    function GetChave(ANome: string): string;
    procedure SetChave(ANome: string; const Value: string);
  public
    function IndiceNoArray(AArray: array of string): Integer;
    function Vezes(AValue: Integer): string;
    function Menos(AValue: string): string; overload;
    function Menos(AValues: array of string): string; overload;
    function Mais(AValue: string): string; overload;
    function Mais(const AValue: IString): string; overload;
    function Centralizado(ATamanho: Integer = 38): string;
    function AlinhadoADireita(ATamanho: Integer = 38): string;
    function AlinhadoAEsquerda(ATamanho: Integer = 38): string;
    function ComZerosAEsquerda(ATamanho: Integer): string;
    function Contem(AValue: string): Boolean; overload;
    function EstaContidoEm(AValue: string): Boolean; overload;
    function EstaContidoEm(AValue1, AValue2: string): Boolean; overload;
    function EstaContidoEm(AValue1, AValue2, AValue3: string): Boolean; overload;
    function EstaContidoEm(AValue1, AValue2, AValue3, AValue4: string): Boolean; overload;
    function EstaContidoEm(AValues: array of string): Boolean; overload;
    function EncriptSimples: string;
    function Encripta(AChave: string): string;
    function Decripta(AChave: string): string;
    function Format(AValues: array of const ): string;
    function Modulo10: string;
    function Modulo11(Base: Integer = 9; Resto: Boolean = false): string;
    function Trim: string;
    function TrimLeft: string;
    function TrimRight: string;
    function Replace(AOldPattern, ANewPattern: string): string; overload;
    function Replace(ARegexPattern: UTF8String; ANewPattern: string): string; overload;
    function Replace(AOldPattern, ANewPattern: string; Flags: TReplaceFlags): string; overload;
    function Replace(AOldPatterns, ANewPatterns: array of string): string; overload;
    function Replace(AOldPatterns, ANewPatterns: array of string; Flags: TReplaceFlags): string; overload;
    function Replace(AOldPatterns: array of string; ANewPattern: string): string; overload;
    function Replace(AOldPatterns: array of string; ANewPattern: string; Flags: TReplaceFlags): string; overload;
    function ReplaceAll(AOldPattern, ANewPattern: string): string; overload;
    function AdicionarAntesDaString(AValue: string; Repetir: Integer = 1): string;
    function AdicionarDepoisDaString(AValue: string; Repetir: Integer = 1): string;
    function Reverter: string;
    function Copy(AIndex, ACount: Integer): string;
    procedure SaveToFile(AArquivo: string = NOME_ARQUIVO);
    function ValidarComXSD(AArquivo: string): string;
    procedure Show;
    procedure ShowWarning;
    procedure ShowError;
    procedure Clear;
    function ShowConfirmation: Boolean;
    function Length: Integer;
    function LowerCase: string;
    function UpperCase: string;
    function IndexOf(ASubstring: string): Integer; overload;
    function IndexOf(ASubstring: string; AOffSet: Integer): Integer; overload;
    function ComAspas: string;
    function Aspas: string;
    function UTF8Decode: string;
    function UTF8Encode: string;
    function Humanize: string;
    function Camelize: string;
    function Desumanize: string;
    function Underscore: string;
    function AsInteger: Integer;
    function LoadFromFile: string;
    function ListarArquivos(AFiltro: string = FILTRO_PADRAO_DE_ARQUIVO; AMostrarCaminhoCompleto: Boolean = True;
      ASeparador: string = QUEBRA_DE_LINHA): string;
    function ListarArquivosComPrefixoParaCopy(AFiltro: string = FILTRO_PADRAO_DE_ARQUIVO; AMostrarCaminhoCompleto: Boolean = True;
      ASeparador: string = QUEBRA_DE_LINHA): string;
    function ListarPastas(AFiltro: string = FILTRO_PADRAO_DE_ARQUIVO; AMostrarCaminhoCompleto: Boolean = True;
      ASeparador: string = QUEBRA_DE_LINHA): string;
    function ListarPastasEArquivos(AFiltro: string = FILTRO_PADRAO_DE_ARQUIVO; AMostrarCaminhoCompleto: Boolean = True;
      ASeparador: string = QUEBRA_DE_LINHA; IncluirSubPastas: Boolean = false): string;
    function Ate(APosicao: Integer): string; overload;
    function Ate(APosicao: string): string; overload;
    function AteAntesDe(APosicao: string): string;
    function AsStringList: TStringList; // o programador precisa controlar o tempo de vida do retorno
    function Equals(AValor: string): Boolean; overload;
    function Equals(AValor: IString): Boolean; overload;
    function IgualA(AValor: string): Boolean; overload;
    function IgualA(AValor: IString): Boolean; overload;
    property Get[De, Ate: Integer]: string read GetAt write SetAt; default;
    property Str[De, Ate: string]: string read GetAtStr write SetAtStr;
    property Value: string read GetValue write SetValue;
    property Vazia: Boolean read GetVazia;
    property Chave[ANome: string]: string read GetChave write SetChave;
    constructor Create(AValue: string);
    destructor Destroy; override;
    function After(AIndex: Integer): string;
    function Contem(AValues: array of string): Boolean; overload;
    function Match(ARegex: UTF8String): Boolean;
    function MatchDataFor(ARegex: UTF8String): IMatchData;
    function AsClassName(AUsingPrefix: string = 'T'): string;
    function WithoutAccents: string;
  end;

  IXString = interface
    ['{296B0DD1-9E84-47EE-9211-F05E4604EEA9}']
    function GetAt(De, Ate: Integer): IXString;
    procedure SetAt(De, Ate: Integer; const AValue: IXString);
    function AdicionarAntesDaString(AValue: string; Repetir: Integer = 1): IXString;
    function AdicionarDepoisDaString(AValue: string; Repetir: Integer = 1): IXString;
    function GetValue: string;
    function Vezes(AValue: Integer): IXString;
    function Menos(AValue: string): IXString; overload;
    function Menos(AValues: array of string): IXString; overload;
    function Mais(AValue: string): IXString; overload;
    function Mais(const AValue: IXString): IXString; overload;
    function Centralizado(ATamanho: Integer = 38): IXString;
    function AlinhadoADireita(ATamanho: Integer = 38): IXString;
    function AlinhadoAEsquerda(ATamanho: Integer = 38): IXString;
    function AsInteger: Integer;
    function ComZerosAEsquerda(ATamanho: Integer): IXString;
    function Contem(AValue: string): Boolean; overload;
    function Contem(AValues: array of string): Boolean; overload;
    function Encripta(AChave: string): IXString;
    function Decripta(AChave: string): IXString;
    function Format(AValues: array of const ): IXString;
    function EstaContidoEm(AValue: string): Boolean; overload;
    function EstaContidoEm(AValue1, AValue2: string): Boolean; overload;
    function EstaContidoEm(AValue1, AValue2, AValue3: string): Boolean; overload;
    function EstaContidoEm(AValue1, AValue2, AValue3, AValue4: string): Boolean; overload;
    function EstaContidoEm(AValue: array of string): Boolean; overload;
    function Trim: IXString;
    function TrimLeft: IXString;
    function TrimRight: IXString;
    function Show: IXString;
    function ShowWarning: IXString;
    function ShowError: IXString;
    function ShowConfirmation: Boolean;
    function Reverter: IXString;
    function AsStringList: TStringList; // o programador precisa controlar o tempo de vida do retorno
    function Replace(AOldPattern, ANewPattern: string): IXString; overload;
    function Replace(ARegexPattern: UTF8String; ANewPattern: string): IXString; overload;
    function Replace(AOldPattern, ANewPattern: string; Flags: TReplaceFlags): IXString; overload;
    function Replace(AOldPatterns, ANewPatterns: array of string): IXString; overload;
    function Replace(AOldPatterns, ANewPatterns: array of string; Flags: TReplaceFlags): IXString; overload;
    function Replace(AOldPatterns: array of string; ANewPattern: string): IXString; overload;
    function Replace(AOldPatterns: array of string; ANewPattern: string; Flags: TReplaceFlags): IXString; overload;
    function ReplaceAll(AOldPattern, ANewPattern: string): IXString;
    function SaveToFile(AArquivo: string = NOME_ARQUIVO): IXString;
    function ValidarComXSD(AArquivo: string): IXString;
    function Copy(AIndex, ACount: Integer): IXString;
    function Length: Integer;
    function LowerCase: IXString;
    function UpperCase: IXString;
    function ComAspas: IXString;
    function UTF8Decode: IXString;
    function UTF8Encode: IXString;
    function IndexOf(ASubstring: string): Integer; overload;
    function IndexOf(ASubstring: string; AOffSet: Integer): Integer; overload;
    function Ate(APosicao: Integer): IXString; overload;
    function Ate(APosicao: string): IXString; overload;
    function AteAntesDe(APosicao: string): IXString;
    function Humanize: IXString;
    function Desumanize: IXString;
    function Camelize: IXString;
    function Underscore: IXString;
    function LoadFromFile: IXString;
    function ListarPastas(AFiltro: string = '*.*'; AMostrarCaminhoCompleto: Boolean = True): IXString;
    function ListarArquivos(AFiltro: string = '*.*'; AMostrarCaminhoCompleto: Boolean = True; ASeparador: string = #13#10): IXString;
    function ListarArquivosComPrefixoParaCopy(AFiltro: string = '*.*'; AMostrarCaminhoCompleto: Boolean = True): IXString;
    function ListarPastasEArquivos(AFiltro: string = FILTRO_PADRAO_DE_ARQUIVO; AMostrarCaminhoCompleto: Boolean = True;
      ASeparador: string = QUEBRA_DE_LINHA; Recursividade: Boolean = false): IXString;
    procedure SetValue(const Value: string);

    function Equals(AValor: string): Boolean; overload;
    function Equals(AValor: IString): Boolean; overload;
    function Equals(AValor: IXString): Boolean; overload;
    function IgualA(AValor: string): Boolean; overload;
    function IgualA(AValor: IString): Boolean; overload;
    function IgualA(AValor: IXString): Boolean; overload;
    function IsEmpty: Boolean;
    function Match(ARegex: UTF8String): Boolean;
    procedure Clear;

    property Get[De, Ate: Integer]: IXString read GetAt write SetAt; default;
    property Value: string read GetValue write SetValue;
    function After(AIndex: Integer): IXString;
    function MatchDataFor(ARegex: UTF8String): IMatchData;
    function AsClassName(AUsingPrefix: string = 'T'): IXString;
    function WithoutAccents: IXString;
  end;

  TXString = class(TInterfacedObject, IXString)
  private
    FRegex: TDIPerlRegEx;
    FValue: IString;
    function Regex: TDIPerlRegEx;
  protected
    function GetAt(De, Ate: Integer): IXString;
    procedure SetAt(De, Ate: Integer; const AValue: IXString);
    function GetValue: string;
    procedure SetValue(const AValue: string);
  public
    constructor Create(AValue: string);
    destructor Destroy; override;

    function AdicionarAntesDaString(AValue: string; Repetir: Integer = 1): IXString;
    function AdicionarDepoisDaString(AValue: string; Repetir: Integer = 1): IXString;
    function Vezes(AValue: Integer): IXString;
    function Menos(AValue: string): IXString; overload;
    function Menos(AValues: array of string): IXString; overload;
    function Mais(AValue: string): IXString; overload;
    function Mais(const AValue: IXString): IXString; overload;
    function Centralizado(ATamanho: Integer = 38): IXString;
    function AlinhadoADireita(ATamanho: Integer = 38): IXString;
    function AlinhadoAEsquerda(ATamanho: Integer = 38): IXString;
    function ComZerosAEsquerda(ATamanho: Integer): IXString;
    function Contem(AValue: string): Boolean; overload;
    function Contem(AValues: array of string): Boolean; overload;
    function Encripta(AChave: string): IXString;
    function Decripta(AChave: string): IXString;
    function Format(AValues: array of const ): IXString;
    function EstaContidoEm(AValue: string): Boolean; overload;
    function EstaContidoEm(AValue1, AValue2: string): Boolean; overload;
    function EstaContidoEm(AValue1, AValue2, AValue3: string): Boolean; overload;
    function EstaContidoEm(AValue1, AValue2, AValue3, AValue4: string): Boolean; overload;
    function EstaContidoEm(AValues: array of string): Boolean; overload;
    function Trim: IXString;
    function TrimLeft: IXString;
    function TrimRight: IXString;
    function ShowWarning: IXString;
    function ShowError: IXString;
    function ShowConfirmation: Boolean;
    function Show: IXString;
    function LoadFromFile: IXString;
    function AsStringList: TStringList; // o programador precisa controlar o tempo de vida do retorno
    function Replace(AOldPattern, ANewPattern: string): IXString; overload;
    function Replace(ARegexPattern: UTF8String; ANewPattern: string): IXString; overload;
    function Replace(AOldPattern, ANewPattern: string; Flags: TReplaceFlags): IXString; overload;
    function Replace(AOldPatterns, ANewPatterns: array of string): IXString; overload;
    function Replace(AOldPatterns, ANewPatterns: array of string; Flags: TReplaceFlags): IXString; overload;
    function Replace(AOldPatterns: array of string; ANewPattern: string): IXString; overload;
    function Replace(AOldPatterns: array of string; ANewPattern: string; Flags: TReplaceFlags): IXString; overload;
    function ReplaceAll(AOldPattern, ANewPattern: string): IXString;
    function Reverter: IXString;
    function SaveToFile(AArquivo: string = NOME_ARQUIVO): IXString;
    function ValidarComXSD(AArquivo: string): IXString;
    function Copy(AIndex, ACount: Integer): IXString;
    function UTF8Decode: IXString;
    function UTF8Encode: IXString;
    function Length: Integer;
    function LowerCase: IXString;
    function UpperCase: IXString;
    function IndexOf(ASubstring: string): Integer; overload;
    function IndexOf(ASubstring: string; AOffSet: Integer): Integer; overload;
    function ComAspas: IXString;
    function Humanize: IXString;
    function Desumanize: IXString;
    function Camelize: IXString;
    function Underscore: IXString;
    function Ate(APosicao: Integer): IXString; overload;
    function Ate(APosicao: string): IXString; overload;
    function AteAntesDe(APosicao: string): IXString;
    function ListarArquivos(AFiltro: string = FILTRO_PADRAO_DE_ARQUIVO; AMostrarCaminhoCompleto: Boolean = True;
      ASeparador: string = QUEBRA_DE_LINHA): IXString;
    function ListarArquivosComPrefixoParaCopy(AFiltro: string = FILTRO_PADRAO_DE_ARQUIVO;
      AMostrarCaminhoCompleto: Boolean = True): IXString;
    function ListarPastas(AFiltro: string = FILTRO_PADRAO_DE_ARQUIVO; AMostrarCaminhoCompleto: Boolean = True): IXString;
    function ListarPastasEArquivos(AFiltro: string = FILTRO_PADRAO_DE_ARQUIVO; AMostrarCaminhoCompleto: Boolean = True;
      ASeparador: string = QUEBRA_DE_LINHA; Recursividade: Boolean = false): IXString;

    function Equals(AValor: string): Boolean; overload;
    function Equals(AValor: IString): Boolean; overload;
    function Equals(AValor: IXString): Boolean; overload;
    function IgualA(AValor: string): Boolean; overload;
    function IgualA(AValor: IString): Boolean; overload;
    function IgualA(AValor: IXString): Boolean; overload;
    procedure Clear;
    function Match(ARegex: UTF8String): Boolean;
    function MatchDataFor(ARegex: UTF8String): IMatchData;

    property Value: string read GetValue write SetValue;
    property Get[De, Ate: Integer]: IXString read GetAt write SetAt; default;
    function After(AIndex: Integer): IXString;
    function AsInteger: Integer;
    function IsEmpty: Boolean;
    function AsClassName(AUsingPrefix: string = 'T'): IXString;
    function WithoutAccents: IXString;
  end;

  IInteger = interface;

  IMatchData = interface(IInterface)
    ['{65DA766B-1565-489F-9389-9D5968CDE346}']
    function GetMatchedData: IXString;
    function GetPostMatch: IXString;
    function GetPreMatch: IXString;
    function GetSize: IInteger;
    procedure SetMatchedData(const Value: IXString);
    procedure SetPostMatch(const Value: IXString);
    procedure SetPreMatch(const Value: IXString);
    procedure SetSize(const Value: IInteger);

    property MatchedData: IXString read GetMatchedData write SetMatchedData;
    property PostMatch: IXString read GetPostMatch write SetPostMatch;
    property PreMatch: IXString read GetPreMatch write SetPreMatch;
    property Size: IInteger read GetSize write SetSize;
  end;

  TIntegerProc = reference to procedure;

  IInteger = interface(IInterface)
    ['{5F187942-611A-4DE2-9DC4-169BCC98E2C2}']
    function GetValue: Integer;
    procedure SetValue(const Value: Integer);

    function AsString: string;
    function Format(AFormat: string = '000000'): string;
    procedure Times(AMetodo: TIntegerProc);
    property Value: Integer read GetValue write SetValue;
  end;

  TInteger = class(TInterfacedObject, IInteger)
  private
    FValue: Integer;
  protected
    function GetValue: Integer;
    procedure SetValue(const Value: Integer);
  public
    procedure Times(AMetodo: TIntegerProc);
    function AsString: string;
    function Format(AFormat: string = '000000'): string;
    property Value: Integer read GetValue write SetValue;
    constructor Create(AValue: Integer);
  end;

  TMatchData = class(TInterfacedObject, IMatchData)

  private
    FMatchedData: IXString;
    FPostMatch: IXString;
    FPreMatch: IXString;
    FSize: IInteger;
    function GetMatchedData: IXString;
    function GetPostMatch: IXString;
    function GetPreMatch: IXString;
    function GetSize: IInteger;
    procedure SetMatchedData(const Value: IXString);
    procedure SetPostMatch(const Value: IXString);
    procedure SetPreMatch(const Value: IXString);
    procedure SetSize(const Value: IInteger);
  public
    property MatchedData: IXString read GetMatchedData write SetMatchedData;
    property PostMatch: IXString read GetPostMatch write SetPostMatch;
    property PreMatch: IXString read GetPreMatch write SetPreMatch;
    property Size: IInteger read GetSize write SetSize;
  end;

function I(AIntegerValue: Integer): IInteger;

function S(Value: string): IString;
function SX(Value: string): IXString;
function SDoArquivo(AArquivo: string): IString;
function SXDoArquivo(AArquivo: string): IXString;
function Concatenar(AStrings: array of string; AFormat: string = '"%s"'; ASeparador: string = ', '): string;

function Aspas(AStr: string): string;
procedure ArrayExecute(AValores: array of string; AMetodo: TProcedureString);
function ReplaceMany(S: string; OldPatterns: array of string; NewPatterns: array of string; Flags: TReplaceFlags): string; overload;
function ReplaceMany(S: string; OldPatterns: array of string; NewPattern: string; Flags: TReplaceFlags): string; overload;
function CreateStringGUID: string;
function NovoGUIDParaRegistro: string;

function AddCharNaString(Texto: string; Tamanho: Integer; Caracter: Char = ' '; Esquerda: Boolean = True): string;
function AlinhaTX(Texto: string; Alinhar: Char; Espaco: Integer): string;
function AlinhaEsquerda(Texto: string; Tamanho: Integer): string;
function AlinhaDireita(Texto: string; Tamanho: Integer): string;
function EncriptSimples(Str: string): string; // criptografia de dados

function GetFileList(FDirectory, Filter: TFileName; ShowFolder: Boolean; AUsaPrefixoCopy: Boolean = false): TStringList;

function IndexOf(AValor: string; AArray: array of string): Integer;

implementation

uses
  Dialogs, Windows, Registry, StrUtils, forms, Math;

function IndexOf(AValor: string; AArray: array of string): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to High(AArray) do
  begin
    if AValor = AArray[I] then
      Result := I;
  end;
end;

function TemAtributo(Attr, Val: Integer): Boolean;
begin
  Result := Attr and Val = Val;
end;

function ListarPastas(Diretorio: string; CaminhoCompleto: Boolean = True; AFiltro: string = '*.*';
  ASeparador: string = #13#10): TStringList;
var
  F: TSearchRec;
  Ret: Integer;
begin
  Result := TStringList.Create;
  Ret := FindFirst(Diretorio + '\' + AFiltro, faAnyFile, F);
  try
    while Ret = 0 do
    begin
      if TemAtributo(F.Attr, faDirectory) then
      begin
        if (F.Name <> '.') and (F.Name <> '..') then
        begin
          if CaminhoCompleto then
            Result.Add(Diretorio + '\' + F.Name)
          else
            Result.Add(F.Name);
        end;
      end;
      Ret := FindNext(F);
    end;
  finally
    SysUtils.FindClose(F);
  end;
end;

function ListarPastasEArquivos(Diretorio: string; Sub: Boolean = True; AFiltro: string = '*.*';
  AMostrarCaminhoCompleto: Boolean = True): TStrings;
var
  F: TSearchRec;
  Ret: Integer;
  TempNome: string;
  LSubPasta: TStrings;
begin
  Result := TStringList.Create;
  Ret := FindFirst(Diretorio + '\' + AFiltro, faAnyFile, F);
  try
    while Ret = 0 do
    begin
      if TemAtributo(F.Attr, faDirectory) then
      begin
        if (F.Name <> '.') and (F.Name <> '..') then
        begin
          if Sub then
          begin
            if AMostrarCaminhoCompleto then
              TempNome := Diretorio + '\' + F.Name
            else
              TempNome := F.Name;
            Result.Add(TempNome);
            LSubPasta := ListarPastasEArquivos(Diretorio + '\' + F.Name, True, AFiltro, AMostrarCaminhoCompleto);
            Result.Add(LSubPasta.Text);
            LSubPasta.Free;
          end;
        end;
      end
      else
      begin
        if AMostrarCaminhoCompleto then
          Result.Add(Diretorio + '\' + F.Name)
        else
          Result.Add(F.Name);
      end;
      Ret := FindNext(F);
    end;
  finally
    SysUtils.FindClose(F);
  end;
end;

function EncriptSimples(Str: string): string; // criptografia de dados
var
  I, j, k, tam: Integer;
  straux, Ret: string;
begin
  tam := Length(Str); // pega tamanho da string
  Ret := ''; // atribui vlr nulo ao retorno
  I := 1; // incializa variavel
  for k := 1 to tam do
  begin
    straux := Copy(Str, I, 6); // pega de 6 em 6 chr's
    for j := 1 to Length(straux) do
    begin
      if j = 1 then
        Ret := Ret + Chr(ord(straux[j]) + 76 + k + j) // primeiro caracter
      else if j = 2 then
        Ret := Ret + Chr(ord(straux[j]) + 69 + k + j) // segundo caracter
      else if j = 3 then
        Ret := Ret + Chr(ord(straux[j]) + 79 + k + j) // terceiro caracter
      else if j = 4 then
        Ret := Ret + Chr(ord(straux[j]) + 78 + k + j) // quarto caracter
      else if j = 5 then
        Ret := Ret + Chr(ord(straux[j]) + 73 + k + j) // quinto caracter
      else if j = 6 then
        Ret := Ret + Chr(ord(straux[j]) + 82 + k + j) // sexto caracter
    end;
    I := I + 6; // pula de 6 em 6
    if I > tam then
    begin
      Result := Copy(Ret, 1, tam); // devolve resultado
      exit; // e sai da funcao
    end;
  end;
  Result := Copy(Ret, 1, tam); // devolve resultado
end;

function Aspas(AStr: string): string;
begin
  Result := QuotedStr(AStr);
end;

function GetFileList(FDirectory, Filter: TFileName; ShowFolder: Boolean; AUsaPrefixoCopy: Boolean = false): TStringList;
var
  ARec: TSearchRec;
  Res: Integer;
begin
{$WARNINGS off}
  if FDirectory[Length(FDirectory)] <> '\' then
    FDirectory := FDirectory + '\';
  Result := TStringList.Create;
  try
    Res := FindFirst(FDirectory + Filter, faAnyFile or faArchive, ARec);
    while Res = 0 do
    begin
      if ((ARec.Attr and faArchive) = faAnyFile) or ((ARec.Attr and faArchive) = faArchive) then
      begin
        if ShowFolder then
          if AUsaPrefixoCopy then
            Result.Add('\COPY ' + StringReplace(LowerCase(ARec.Name), '.copy', '',
                [rfReplaceAll]) + ' FROM ''' + FDirectory + ARec.Name + '''')
          else
            Result.Add(FDirectory + ARec.Name)
          else if AUsaPrefixoCopy then
            Result.Add('\COPY ' + StringReplace(LowerCase(ARec.Name), '.copy', '', [rfReplaceAll]) + ' FROM ''' + ARec.Name + '''')
          else
            Result.Add(ARec.Name);
      end;
      Res := FindNext(ARec);
    end;
    SysUtils.FindClose(ARec);
  except
    Result.Free;
  end;
{$WARNINGS on}
end;

function Concatenar(AStrings: array of string; AFormat: string = '"%s"'; ASeparador: string = ', '): string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to High(AStrings) do
  begin
    Result := Result + Format(AFormat, [AStrings[I]]);
    if I <> High(AStrings) then
      Result := Result + ASeparador;
  end;
end;

procedure ArrayExecute(AValores: array of string; AMetodo: TProcedureString);
var
  I: Integer;
begin
  for I := 0 to High(AValores) do
    AMetodo(AValores[I]);
end;

function S(Value: string): IString;
begin
  Result := TString.Create(Value);
end;

function SX(Value: string): IXString;
begin
  Result := TXString.Create(Value);
end;

function CarregarStringDoArquivo(AArquivo: string): string;
var
  LArquivo: TStringList;
begin
  Result := '';
  LArquivo := TStringList.Create;
  try
    LArquivo.LoadFromFile(AArquivo);
    Result := LArquivo.Text;
  finally
    LArquivo.Free;
  end;
end;

function SDoArquivo(AArquivo: string): IString;
begin
  Result := S(CarregarStringDoArquivo(AArquivo));
end;

function SXDoArquivo(AArquivo: string): IXString;
begin
  Result := SX(CarregarStringDoArquivo(AArquivo));
end;

function AlinhaDireita(Texto: string; Tamanho: Integer): string;
begin
  Result := AddCharNaString(Texto, Tamanho);
end;

function AlinhaEsquerda(Texto: string; Tamanho: Integer): string;
begin
  Result := AddCharNaString(Texto, Tamanho, ' ', false);
end;

function ReplaceMany(S: string; OldPatterns: array of string; NewPatterns: array of string; Flags: TReplaceFlags): string;
var
  I: Integer;
begin
  Result := S;
  for I := 0 to High(NewPatterns) do
    Result := StringReplace(Result, OldPatterns[I], NewPatterns[I], Flags);
end;

function ReplaceMany(S: string; OldPatterns: array of string; NewPattern: string; Flags: TReplaceFlags): string;
var
  I: Integer;
begin
  Result := S;
  for I := 0 to High(OldPatterns) do
    Result := StringReplace(Result, OldPatterns[I], NewPattern, Flags);
end;

function CreateStringGUID: string;
var
  LGUID: TGUID;
begin
  CreateGUID(LGUID);
  Result := GUIDToString(LGUID);
end;

function NovoGUIDParaRegistro: string;
begin
  Result := ReplaceMany(CreateStringGUID, ['-', '{', '}'], ['', '', ''], [rfReplaceAll]);
end;

function AddCharNaString(Texto: string; Tamanho: Integer; Caracter: Char = ' '; Esquerda: Boolean = True): string;
begin
  Result := Texto;
  if Length(Result) > Tamanho then
  begin
    Delete(Result, Tamanho + 1, Length(Result) - Tamanho);
    exit;
  end;
  if Esquerda then
    while Length(Result) < Tamanho do
      Result := Caracter + Result
    else
    begin
      while Length(Result) < Tamanho do
        Result := Result + Caracter;
    end;
end;

function AlinhaTX(Texto: string; Alinhar: Char; Espaco: Integer): string;
// alinha textos
var
  Retorno: string;
begin
  Retorno := '';
  if Length(Trim(Texto)) > Espaco then
    Retorno := Copy(Trim(Texto), 1, Espaco)
  else
  begin
    case Alinhar of
      'D', 'd':
        Retorno := StringOfChar(' ', Espaco - Length(Trim(Texto))) + Trim(Texto);
      'E', 'e':
        Retorno := Trim(Texto) + StringOfChar(' ', Espaco - Length(Trim(Texto)));
      'C', 'c':
        Retorno := StringOfChar(' ', Trunc(Int((Espaco - Length(Trim(Texto))) / 2))) + Trim(Texto) + StringOfChar(' ',
          Trunc(Int((Espaco - Length(Trim(Texto))) / 2)));
    end;
  end;
  AlinhaTX := Retorno
end;

{ TString }

function TString.AdicionarAntesDaString(AValue: string; Repetir: Integer = 1): string;
begin
  Result := S(AValue).Vezes(Repetir) + Value;
end;

function TString.AdicionarDepoisDaString(AValue: string; Repetir: Integer = 1): string;
begin
  Result := Value + S(AValue).Vezes(Repetir);
end;

function TString.AlinhadoADireita(ATamanho: Integer = 38): string;
begin
  Result := AlinhaTX(Value, 'D', ATamanho);
end;

function TString.AlinhadoAEsquerda(ATamanho: Integer = 38): string;
begin
  Result := AlinhaTX(Value, 'E', ATamanho);
end;

function TString.Centralizado(ATamanho: Integer = 38): string;
begin
  Result := AlinhaTX(Value, 'C', ATamanho);
end;

procedure TString.Clear;
begin
  Value := '';
end;

function TString.Contem(AValue: string): Boolean;
begin
  Result := Pos(AValue, Value) > 0;
end;

constructor TString.Create(AValue: string);
begin
  FValue := AValue;
end;

destructor TString.Destroy;
begin
  if Assigned(FRegex) then
    FreeAndNil(FRegex);
  inherited;
end;

function TString.After(AIndex: Integer): string;
begin
  Result := Copy(AIndex, Length);
end;

function TString.AsClassName(AUsingPrefix: string = 'T'): string;
begin
  Result := SX(Value).Humanize.Camelize.WithoutAccents.Replace(StrEncodeUtf8('[[:punct:]]|\s'), '').AdicionarAntesDaString
    (AUsingPrefix).Value;
end;

function TString.EstaContidoEm(AValue: string): Boolean;
begin
  Result := S(AValue).Contem(Value);
end;

function TString.EstaContidoEm(AValue1, AValue2: string): Boolean;
begin
  Result := Self.EstaContidoEm([AValue1, AValue2]);
end;

function TString.EstaContidoEm(AValue1, AValue2, AValue3: string): Boolean;
begin
  Result := Self.EstaContidoEm([AValue1, AValue2, AValue3]);
end;

function TString.EstaContidoEm(AValue1, AValue2, AValue3, AValue4: string): Boolean;
begin
  Result := Self.EstaContidoEm([AValue1, AValue2, AValue3, AValue4]);
end;

function TString.EstaContidoEm(AValues: array of string): Boolean;
var
  I: Integer;
begin
  Result := false;
  for I := 0 to High(AValues) do
  begin
    Result := AValues[I] = Value;
    if Result then
      Break;
  end;
end;

function TString.GetValue: string;
begin
  Result := FValue;
end;

function TString.Mais(AValue: string): string;
begin
  Result := Value + AValue;
end;

function TString.Mais(const AValue: IString): string;
begin
  Result := S(Value).Mais(AValue.Value);
end;

function TString.Match(ARegex: UTF8String): Boolean;
begin
  Regex.MatchPatternRaw := ARegex;
  Regex.SetSubjectStr(StrEncodeUtf8(Value));
  Result := Regex.Match(0) > 0;
end;

function TString.MatchDataFor(ARegex: UTF8String): IMatchData;
begin
  Result := SX(Value).MatchDataFor(ARegex);
end;

function TString.Menos(AValue: string): string;
begin
  Result := StringReplace(Value, AValue, '', [rfReplaceAll]);
end;

function TString.Menos(AValues: array of string): string;
begin
  Result := ReplaceMany(Value, AValues, '', [rfReplaceAll]);
end;

procedure TString.SetValue(const Value: string);
begin
  FValue := Value;
end;

function TString.Trim: string;
begin
  Result := SysUtils.Trim(Value);
end;

function TString.TrimLeft: string;
begin
  Result := SysUtils.TrimLeft(Value);
end;

function TString.TrimRight: string;
begin
  Result := SysUtils.TrimRight(Value);
end;

function TString.Vezes(AValue: Integer): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to AValue do
    Result := Value + Result;
end;

function TString.WithoutAccents: string;
var
  LAccentedChar: UTF8String;
  LIndex: Integer;
  LResult: IXString;
begin
  Regex.MatchPatternRaw := StrEncodeUtf8(REGEX_ACCENTED_CHARS);
  Regex.SetSubjectStr(StrEncodeUtf8(Value));
  LResult := SX(Value);
  if Regex.Match(0) > 0 then
  begin
    repeat
      LAccentedChar := StrDecodeUtf8(Regex.MatchedStr);
      LIndex := S(ACCENTED_CHARS).IndexOf(LAccentedChar);
      if LIndex >= 0 then
        LResult.ReplaceAll(LAccentedChar, UNACCENTED_CHARS[LIndex]);
    until Regex.MatchNext < 0;
  end;
  Value := LResult.Value;
  Result := LResult.Value;
end;

function TString.ComZerosAEsquerda(ATamanho: Integer): string;
begin
  Result := Self.AdicionarAntesDaString('0', ATamanho - Length);
end;

function TString.Decripta(AChave: string): string;
begin
  Result := ''; // Criptografia.Encripta('D', Value, AChave)
end;

function TString.Encripta(AChave: string): string;
begin
  Result := ''; // Criptografia.Encripta('E', Value, AChave)
end;

function TString.Format(AValues: array of const ): string;
begin
  Result := SysUtils.Format(Value, AValues);
end;

procedure TString.Show;
begin
  ShowMessage(Value);
end;

procedure TString.ShowWarning;
var
  LTitulo: string;
begin
  LTitulo := Application.Title;
  Application.MessageBox(Pchar(Value), Pchar(LTitulo), mb_ok + mb_iconwarning);
end;

procedure TString.ShowError;
var
  LTitulo: string;
begin
  LTitulo := Application.Title;
  Application.MessageBox(Pchar(Value), Pchar(LTitulo), mb_ok + mb_iconerror);
end;

function TString.ShowConfirmation: Boolean;
var
  LTitulo: string;
begin
  Result := false;
  LTitulo := Application.Title;
  if Application.MessageBox(Pchar(Value), Pchar(LTitulo), mb_yesno + mb_iconquestion) = idYes then
    Result := True;
end;

function TString.Reverter: string;
begin
  Result := ReverseString(Value);
end;

procedure TString.SaveToFile(AArquivo: string = NOME_ARQUIVO);
var
  LArquivo: TStringList;
begin
  LArquivo := TStringList.Create;
  try
    LArquivo.Text := Value;
    LArquivo.SaveToFile(AArquivo);
  finally
    LArquivo.Free;
  end;
end;

function TString.ValidarComXSD(AArquivo: string): string;
begin
  raise Exception.Create('Ainda n„o implementado');
end;

function TString.Copy(AIndex, ACount: Integer): string;
begin
  Result := System.Copy(Value, AIndex + 1, ACount);
end;

function TString.GetAt(De, Ate: Integer): string;
begin
  Result := S(Value).Copy(De, Ate - De + 1);
end;

function TString.Replace(AOldPattern, ANewPattern: string): string;
begin
  Result := Replace(AOldPattern, ANewPattern, []);
end;

function TString.Replace(AOldPattern, ANewPattern: string; Flags: TReplaceFlags): string;
begin
  Result := StringReplace(Value, AOldPattern, ANewPattern, Flags);
end;

function TString.Regex: TDIPerlRegEx;
begin
  if FRegex = nil then
  begin
    FRegex := TDIPerlRegEx.Create(nil);
    FRegex.CompileOptions := FRegex.CompileOptions + [coUtf8];
  end;
  Result := FRegex;
end;

function TString.Replace(ARegexPattern: UTF8String; ANewPattern: string): string;
begin
  Regex.SetSubjectStr(StrEncodeUtf8(Value));
  Regex.MatchPatternRaw := StrEncodeUtf8(ARegexPattern);
  Regex.FormatPattern := StrEncodeUtf8(ANewPattern);
  Regex.Match;
  Result := StrDecodeUtf8(Regex.Replace(0, -1));
end;

function TString.Replace(AOldPatterns: array of string; ANewPattern: string; Flags: TReplaceFlags): string;
begin
  Result := ReplaceMany(Value, AOldPatterns, ANewPattern, Flags);
end;

function TString.Replace(AOldPatterns, ANewPatterns: array of string; Flags: TReplaceFlags): string;
begin
  Result := ReplaceMany(Value, AOldPatterns, ANewPatterns, Flags);
end;

function TString.Replace(AOldPatterns: array of string; ANewPattern: string): string;
begin
  Result := ReplaceMany(Value, AOldPatterns, ANewPattern, []);
end;

function TString.Replace(AOldPatterns, ANewPatterns: array of string): string;
begin
  Result := ReplaceMany(Value, AOldPatterns, ANewPatterns, []);
end;

procedure TString.SetAt(De, Ate: Integer; const AValue: string);
begin
  Value := S(Value).Replace(S(Value).Get[De, Ate], AValue);
end;

function TString.Length: Integer;
begin
  Result := System.Length(Value);
end;

function TString.LowerCase: string;
begin
  Result := SysUtils.LowerCase(Value);
end;

function TString.IndexOf(ASubstring: string): Integer;
begin
  Result := System.Pos(ASubstring, Value) - 1;
end;

function TString.IndexOf(ASubstring: string; AOffSet: Integer): Integer;
begin
  Result := StrUtils.PosEx(ASubstring, Value, AOffSet + 1) - 1;
end;

function TString.ComAspas: string;
begin
  Result := QuotedStr(Value);
end;

function TString.UpperCase: string;
begin
  Result := SysUtils.UpperCase(Value);
end;

function TString.UTF8Decode: string;
begin
  Result := System.UTF8Decode(Value);
end;

function TString.UTF8Encode: string;
begin
  Result := System.UTF8Encode(Value);
end;

function TString.Humanize: string;
begin
  Result := Value;
  if Value <> '' then
  begin
    Result := SX(Value).ReplaceAll('_', ' ').LowerCase.Value;
    Result[1] := System.UpCase(Result[1]);
  end
end;

function TString.Camelize: string;
var
  LOffset: Cardinal;
begin
  Result := Value;
  Regex.SetSubjectStr(StrEncodeUtf8(Result));
  Regex.MatchPatternRaw := REGEX_PRIMEIRA_LETRA_DE_CADA_PALAVRA;
  if Regex.Match(0) > 0 then
  begin
    repeat
      LOffset := BufCountUtf8Chars(PAnsiChar(StrEncodeUtf8(Result)), Regex.MatchedStrFirstCharPos);
      Result[LOffset + 1] := SysUtils.AnsiUpperCase(StrDecodeUtf8(Regex.MatchedStr))[1];
    until Regex.MatchNext < 0;
  end;
end;

function TString.Underscore: string;
begin
  raise Exception.Create('Ainda n„o implementado');
end;

function TString.Desumanize: string;
begin
  raise Exception.Create('Ainda n„o implementado');
end;

function TString.Modulo10: string;
var
  Auxiliar: string;
  Contador, Peso: Integer;
  Digito: Integer;
begin
  Auxiliar := '';
  Peso := 2;
  for Contador := S(Value).Length downto 1 do
  begin
    Auxiliar := IntToStr(StrToInt(Value[Contador]) * Peso) + Auxiliar;
    if Peso = 1 then
      Peso := 2
    else
      Peso := 1;
  end;

  Digito := 0;
  for Contador := 1 to S(Auxiliar).Length do
  begin
    Digito := Digito + StrToInt(Auxiliar[Contador]);
  end;
  Digito := 10 - (Digito mod 10);
  if (Digito > 9) then
    Digito := 0;
  Result := IntToStr(Digito);
end;

function TString.Modulo11(Base: Integer = 9; Resto: Boolean = false): string;
var
  Soma: Integer;
  Contador, Peso, Digito: Integer;
begin
  Soma := 0;
  Peso := 2;
  for Contador := S(Value).Length downto 1 do
  begin
    Soma := Soma + (StrToInt(Value[Contador]) * Peso);
    if Peso < Base then
      Peso := Peso + 1
    else
      Peso := 2;
  end;

  if Resto then
    Result := IntToStr(Soma mod 11)
  else
  begin
    Digito := 11 - (Soma mod 11);
    if (Digito > 9) then
      Digito := 0;
    Result := IntToStr(Digito);
  end
end;

function TString.AsInteger: Integer;
begin
  Result := StrToInt(Value);
end;

function TString.GetVazia: Boolean;
begin
  Result := System.Length(Value) = 0;
end;

function TString.ReplaceAll(AOldPattern, ANewPattern: string): string;
begin
  Result := S(Value).Replace(AOldPattern, ANewPattern, [rfReplaceAll]);
end;

function TString.ListarArquivos(AFiltro: string = '*.*'; AMostrarCaminhoCompleto: Boolean = True; ASeparador: string = #13#10): string;
var
  LArquivos: TStringList;
  I: Integer;
begin
  LArquivos := GetFileList(Value, AFiltro, AMostrarCaminhoCompleto);
  Result := '';
  for I := 0 to LArquivos.Count - 1 do
  begin
    Result := Result + LArquivos[I];
    if I <> LArquivos.Count - 1 then
      Result := Result + ASeparador;
  end;
  LArquivos.Free;
end;

function TString.ListarArquivosComPrefixoParaCopy(AFiltro: string = '*.*'; AMostrarCaminhoCompleto: Boolean = True;
  ASeparador: string = #13#10): string;
var
  LArquivos: TStringList;
  I: Integer;
begin
  LArquivos := GetFileList(Value, AFiltro, AMostrarCaminhoCompleto, True);
  Result := '';
  for I := 0 to LArquivos.Count - 1 do
  begin
    Result := Result + LArquivos[I];
    if I <> LArquivos.Count - 1 then
      Result := Result + ASeparador;
  end;
  LArquivos.Free;
end;

function TString.ListarPastas(AFiltro: string = '*.*'; AMostrarCaminhoCompleto: Boolean = True; ASeparador: string = #13#10): string;
var
  LPastas: TStringList;
  I: Integer;
begin
  LPastas := TypeUtils.ListarPastas(Value, AMostrarCaminhoCompleto, AFiltro);
  Result := '';
  for I := 0 to LPastas.Count - 1 do
  begin
    Result := Result + LPastas[I];
    if I <> LPastas.Count - 1 then
      Result := Result + ASeparador;
  end;
  LPastas.Free;
end;

function TString.ListarPastasEArquivos(AFiltro: string = '*.*'; AMostrarCaminhoCompleto: Boolean = True; ASeparador: string = #13#10;
  IncluirSubPastas: Boolean = false): string;
var
  LItems: TStrings;
  I: Integer;
begin
  LItems := TypeUtils.ListarPastasEArquivos(Value, IncluirSubPastas, AFiltro, AMostrarCaminhoCompleto);
  Result := '';
  for I := 0 to LItems.Count - 1 do
  begin
    Result := Result + LItems[I];
    if I <> LItems.Count - 1 then
      Result := Result + ASeparador;
  end;
  LItems.Free;
end;

function TString.Aspas: string;
begin
  Result := S(Value).ComAspas;
end;

function TString.GetAtStr(De, Ate: string): string;
begin
  Result := Self[IndexOf(De), IndexOf(Ate)];
end;

procedure TString.SetAtStr(De, Ate: string; const AValue: string);
begin
  Self[IndexOf(De), IndexOf(Ate)] := AValue;
end;

function TString.Ate(APosicao: Integer): string;
begin
  Result := Self[0, APosicao];
end;

function TString.Ate(APosicao: string): string;
begin
  Result := Self[0, IndexOf(APosicao)];
end;

function TString.AteAntesDe(APosicao: string): string;
begin
  Result := Self[0, IndexOf(APosicao) - 1];
end;

function TString.EncriptSimples: string;
begin
  Result := ''; // Encript(Value);
end;

function TString.LoadFromFile: string;
var
  LArquivo: TStringList;
begin
  LArquivo := TStringList.Create;
  try
    LArquivo.LoadFromFile(Value);
    Result := LArquivo.Text;
  finally
    LArquivo.Free
  end;
end;

function TString.AsStringList: TStringList;
begin
  Result := TStringList.Create;
  Result.Text := Value;
end;

function TString.Contem(AValues: array of string): Boolean;
var
  I: Integer;
begin
  Result := false;
  for I := 0 to High(AValues) do
    if S(Value).Contem(AValues[I]) then
    begin
      Result := True;
      Break;
    end;
end;

function TString.IndiceNoArray(AArray: array of string): Integer;
begin
  Result := TypeUtils.IndexOf(Value, AArray);
end;

function TString.Equals(AValor: IString): Boolean;
begin
  Result := Equals(AValor.Value);
end;

function TString.Equals(AValor: string): Boolean;
begin
  Result := Value = AValor;
end;

function TString.IgualA(AValor: IString): Boolean;
begin
  Result := Equals(AValor.Value);
end;

function TString.IgualA(AValor: string): Boolean;
begin
  Result := Equals(AValor);
end;

function TString.GetChave(ANome: string): string;
var
  LArquivo: TStringList;
  I: Integer;
begin
  Result := '';
  LArquivo := TStringList.Create;
  try
    LArquivo.LoadFromFile(Value);
    for I := 0 to LArquivo.Count - 1 do
    begin
      if S(LArquivo[I]).Contem(ANome) then
      begin
        Result := SX(LArquivo[I]).Reverter.AteAntesDe(':').Reverter.Trim.Value;
        Break;
      end;
    end;
  finally
    LArquivo.Free;
  end
end;

procedure TString.SetChave(ANome: string; const Value: string);
begin
  //
end;

{ TXString }

function TXString.AdicionarAntesDaString(AValue: string; Repetir: Integer): IXString;
begin
  Value := S(Value).AdicionarAntesDaString(AValue, Repetir);
  Result := Self;
end;

function TXString.AdicionarDepoisDaString(AValue: string; Repetir: Integer): IXString;
begin
  Value := S(Value).AdicionarDepoisDaString(AValue, Repetir);
  Result := Self;
end;

function TXString.AlinhadoADireita(ATamanho: Integer): IXString;
begin
  Value := S(Value).AlinhadoADireita(ATamanho);
  Result := Self;
end;

function TXString.AlinhadoAEsquerda(ATamanho: Integer): IXString;
begin
  Value := S(Value).AlinhadoAEsquerda(ATamanho);
  Result := Self;
end;

function TXString.Camelize: IXString;
begin
  Value := S(Value).Camelize;
  Result := Self;
end;

function TXString.Centralizado(ATamanho: Integer): IXString;
begin
  Value := S(Value).Centralizado(ATamanho);
  Result := Self;
end;

procedure TXString.Clear;
begin
  Value := '';
end;

function TXString.ComAspas: IXString;
begin
  Value := S(Value).ComAspas;
  Result := Self;
end;

function TXString.ComZerosAEsquerda(ATamanho: Integer): IXString;
begin
  Value := S(Value).ComZerosAEsquerda(ATamanho);
  Result := Self;
end;

function TXString.Contem(AValue: string): Boolean;
begin
  Result := S(Self.Value).Contem(AValue);
end;

function TXString.Copy(AIndex, ACount: Integer): IXString;
begin
  Value := S(Value).Copy(AIndex, ACount);
  Result := Self;
end;

constructor TXString.Create(AValue: string);
begin
  FValue := TString.Create(AValue);
end;

function TXString.After(AIndex: Integer): IXString;
begin
  Result := Copy(AIndex, Length);
end;

function TXString.AsClassName(AUsingPrefix: string = 'T'): IXString;
begin
  Value := S(Value).AsClassName(AUsingPrefix);
  Result := Self;
end;

function TXString.AsInteger: Integer;
begin
  Result := StrToInt(Value);
end;

function TXString.Decripta(AChave: string): IXString;
begin
  Value := S(Value).Decripta(AChave);
  Result := Self;
end;

function TXString.Encripta(AChave: string): IXString;
begin
  Value := S(Value).Encripta(AChave);
  Result := Self;
end;

function TXString.EstaContidoEm(AValue: string): Boolean;
begin
  Result := S(Self.Value).EstaContidoEm(AValue);
end;

function TXString.EstaContidoEm(AValues: array of string): Boolean;
begin
  Result := S(Self.Value).EstaContidoEm(AValues);
end;

function TXString.Format(AValues: array of const ): IXString;
begin
  Value := S(Value).Format(AValues);
  Result := Self;
end;

function TXString.GetAt(De, Ate: Integer): IXString;
begin
  Value := S(Value)[De, Ate];
  Result := Self;
end;

function TXString.GetValue: string;
begin
  Result := FValue.Value;
end;

function TXString.IndexOf(ASubstring: string): Integer;
begin
  Result := S(Value).IndexOf(ASubstring);
end;

function TXString.Humanize: IXString;
begin
  Value := S(Value).Humanize;
  Result := Self;
end;

function TXString.IndexOf(ASubstring: string; AOffSet: Integer): Integer;
begin
  Result := S(Value).IndexOf(ASubstring, AOffSet);
end;

function TXString.IsEmpty: Boolean;
begin
  Result := System.Length(Value) = 0;
end;

function TXString.Length: Integer;
begin
  Result := S(Value).Length;
end;

function TXString.LowerCase: IXString;
begin
  Value := S(Value).LowerCase;
  Result := Self;
end;

function TXString.Mais(AValue: string): IXString;
begin
  Value := S(Value).Mais(AValue);
  Result := Self;
end;

function TXString.Mais(const AValue: IXString): IXString;
begin
  Result := Self.Mais(AValue.Value);
end;

function TXString.Match(ARegex: UTF8String): Boolean;
begin
  Result := S(Value).Match(ARegex);
end;

function TXString.MatchDataFor(ARegex: UTF8String): IMatchData;
var
  LFirstMatchedCharPos: Integer;
  LLastMatchedCharPos: Integer;
begin
  Result := nil;
  Regex.SetSubjectStr(StrEncodeUtf8(Value));
  Regex.MatchPatternRaw := ARegex;
  if Regex.Match(0) > 0 then
  begin
    Result := TMatchData.Create;
    LFirstMatchedCharPos := BufCountUtf8Chars(PAnsiChar(StrEncodeUtf8(Value)), Regex.MatchedStrFirstCharPos);
    LLastMatchedCharPos := BufCountUtf8Chars(PAnsiChar(StrEncodeUtf8(Value)), Regex.MatchedStrAfterLastCharPos);
    Result.MatchedData := SX(StrDecodeUtf8(Regex.MatchedStr));
    if LFirstMatchedCharPos > 1 then
      Result.PreMatch := SX(Value).Ate(LFirstMatchedCharPos - 1)
    else
      Result.PreMatch := SX('');
    Result.PostMatch := SX(Value).After(LLastMatchedCharPos);
    Result.Size := I(BufCountUtf8Chars(PAnsiChar(StrEncodeUtf8(Value)), Regex.MatchedStrLength));
  end;
end;

function TXString.Menos(AValues: array of string): IXString;
begin
  Value := S(Value).Menos(AValues);
  Result := Self;
end;

function TXString.Menos(AValue: string): IXString;
begin
  Value := S(Value).Menos(AValue);
  Result := Self;
end;

function TXString.Replace(AOldPattern, ANewPattern: string): IXString;
begin
  Value := S(Value).Replace(AOldPattern, ANewPattern);
  Result := Self;
end;

function TXString.Replace(AOldPattern, ANewPattern: string; Flags: TReplaceFlags): IXString;
begin
  Value := S(Value).Replace(AOldPattern, ANewPattern, Flags);
  Result := Self;
end;

function TXString.Replace(AOldPatterns: array of string; ANewPattern: string; Flags: TReplaceFlags): IXString;
begin
  Value := S(Value).Replace(AOldPatterns, ANewPattern, Flags);
  Result := Self;
end;

function TXString.Replace(ARegexPattern: UTF8String; ANewPattern: string): IXString;
begin
  Value := S(Value).Replace(ARegexPattern, ANewPattern);
  Result := Self;
end;

function TXString.Replace(AOldPatterns, ANewPatterns: array of string; Flags: TReplaceFlags): IXString;
begin
  Value := S(Value).Replace(AOldPatterns, ANewPatterns, Flags);
  Result := Self;
end;

function TXString.Replace(AOldPatterns: array of string; ANewPattern: string): IXString;
begin
  Value := S(Value).Replace(AOldPatterns, ANewPattern, []);
  Result := Self;
end;

function TXString.Replace(AOldPatterns, ANewPatterns: array of string): IXString;
begin
  Value := S(Value).Replace(AOldPatterns, ANewPatterns, []);
  Result := Self;
end;

function TXString.Reverter: IXString;
begin
  Value := S(Value).Reverter;
  Result := Self;
end;

function TXString.SaveToFile(AArquivo: string = NOME_ARQUIVO): IXString;
begin
  S(Value).SaveToFile(AArquivo);
  Result := Self;
end;

procedure TXString.SetAt(De, Ate: Integer; const AValue: IXString);
begin
  S(Value)[De, Ate] := Value;
end;

procedure TXString.SetValue(const AValue: string);
begin
  FValue.Value := AValue;
end;

function TXString.Show: IXString;
begin
  S(Value).Show;
  Result := Self;
end;

function TXString.ShowWarning: IXString;
begin
  S(Value).ShowWarning;
  Result := Self;
end;

function TXString.ShowError: IXString;
begin
  S(Value).ShowWarning;
  Result := Self;
end;

function TXString.ShowConfirmation: Boolean;
begin
  Result := S(Value).ShowConfirmation; ;
end;

function TXString.Trim: IXString;
begin
  Value := S(Value).Trim;
  Result := Self;
end;

function TXString.TrimLeft: IXString;
begin
  Value := S(Value).TrimLeft;
  Result := Self;
end;

function TXString.TrimRight: IXString;
begin
  Value := S(Value).TrimRight;
  Result := Self;
end;

function TXString.UpperCase: IXString;
begin
  Value := S(Value).UpperCase;
  Result := Self;
end;

function TXString.UTF8Decode: IXString;
begin
  Value := S(Value).UTF8Decode;
  Result := Self;
end;

function TXString.UTF8Encode: IXString;
begin
  Value := S(Value).UTF8Encode;
  Result := Self;
end;

function TXString.ValidarComXSD(AArquivo: string): IXString;
begin
  S(Value).ValidarComXSD(AArquivo);
  Result := Self;
end;

function TXString.Vezes(AValue: Integer): IXString;
begin
  Value := S(Value).Vezes(AValue);
  Result := Self;
end;

function TXString.WithoutAccents: IXString;
begin
  Value := S(Value).WithoutAccents;
  Result := Self;
end;

function TXString.Underscore: IXString;
begin
  Value := S(Value).Underscore;
  Result := Self;
end;

destructor TXString.Destroy;
begin
  inherited;
  if Assigned(FRegex) then
    FreeAndNil(FRegex);
end;

function TXString.Desumanize: IXString;
begin
  Value := S(Value).Desumanize;
  Result := Self;
end;

function TXString.ReplaceAll(AOldPattern, ANewPattern: string): IXString;
begin
  Value := S(Value).ReplaceAll(AOldPattern, ANewPattern);
  Result := Self;
end;

function TXString.ListarArquivos(AFiltro: string = '*.*'; AMostrarCaminhoCompleto: Boolean = True;
  ASeparador: string = #13#10): IXString;
begin
  Value := S(Value).ListarArquivos(AFiltro, AMostrarCaminhoCompleto, ASeparador);
  Result := Self;
end;

function TXString.ListarArquivosComPrefixoParaCopy(AFiltro: string; AMostrarCaminhoCompleto: Boolean): IXString;
begin
  Value := S(Value).ListarArquivosComPrefixoParaCopy(AFiltro, AMostrarCaminhoCompleto);
  Result := Self;
end;

function TXString.Ate(APosicao: Integer): IXString;
begin
  Value := S(Value).Ate(APosicao);
  Result := Self;
end;

function TXString.Ate(APosicao: string): IXString;
begin
  Value := S(Value).Ate(APosicao);
  Result := Self;
end;

function TXString.AteAntesDe(APosicao: string): IXString;
begin
  Value := S(Value).AteAntesDe(APosicao);
  Result := Self;
end;

function TXString.LoadFromFile: IXString;
begin
  Value := S(Value).LoadFromFile;
  Result := Self;
end;

function TXString.EstaContidoEm(AValue1, AValue2: string): Boolean;
begin
  Result := S(Self.Value).EstaContidoEm(AValue1, AValue2);
end;

function TXString.EstaContidoEm(AValue1, AValue2, AValue3: string): Boolean;
begin
  Result := S(Self.Value).EstaContidoEm(AValue1, AValue2, AValue3);
end;

function TXString.EstaContidoEm(AValue1, AValue2, AValue3, AValue4: string): Boolean;
begin
  Result := S(Self.Value).EstaContidoEm(AValue1, AValue2, AValue3, AValue4);
end;

function TXString.ListarPastas(AFiltro: string; AMostrarCaminhoCompleto: Boolean): IXString;
begin
  Value := S(Value).ListarPastas(AFiltro, AMostrarCaminhoCompleto);
  Result := Self;
end;

function TXString.ListarPastasEArquivos(AFiltro: string = FILTRO_PADRAO_DE_ARQUIVO; AMostrarCaminhoCompleto: Boolean = True;
  ASeparador: string = QUEBRA_DE_LINHA; Recursividade: Boolean = false): IXString;
begin
  Value := S(Value).ListarPastasEArquivos(AFiltro, AMostrarCaminhoCompleto, ASeparador, Recursividade);
  Result := Self;
end;

function TXString.AsStringList: TStringList;
begin
  Result := S(Value).AsStringList;
end;

function TXString.Equals(AValor: IXString): Boolean;
begin
  Result := Equals(AValor.Value);
end;

function TXString.Equals(AValor: IString): Boolean;
begin
  Result := Equals(AValor.Value);
end;

function TXString.Equals(AValor: string): Boolean;
begin
  Result := Value = AValor;
end;

function TXString.IgualA(AValor: IXString): Boolean;
begin
  Result := Equals(AValor.Value);
end;

function TXString.IgualA(AValor: IString): Boolean;
begin
  Result := Equals(AValor.Value);
end;

function TXString.IgualA(AValor: string): Boolean;
begin
  Result := Equals(AValor);
end;

function TXString.Contem(AValues: array of string): Boolean;
begin
  Result := S(Value).Contem(AValues);
end;

function TXString.Regex: TDIPerlRegEx;
begin
  if FRegex = nil then
    FRegex := TDIPerlRegEx.Create(nil);
  Result := FRegex;
end;

function I(AIntegerValue: Integer): IInteger;
begin
  Result := TInteger.Create(AIntegerValue);
end;

{ TInteger }

function TInteger.AsString: string;
begin
  Result := IntToStr(FValue);
end;

constructor TInteger.Create(AValue: Integer);
begin
  FValue := AValue;
end;

function TInteger.Format(AFormat: string = '000000'): string;
begin
  Result := FormatFloat(AFormat, FValue);
end;

function TInteger.GetValue: Integer;
begin
  Result := FValue;
end;

procedure TInteger.SetValue(const Value: Integer);
begin
  FValue := Value;
end;

procedure TInteger.Times(AMetodo: TIntegerProc);
var
  I: Integer;
begin
  for I := 0 to Value - 1 do
    AMetodo;
end;

function TMatchData.GetMatchedData: IXString;
begin
  Result := FMatchedData;
end;

function TMatchData.GetPostMatch: IXString;
begin
  Result := FPostMatch;
end;

function TMatchData.GetPreMatch: IXString;
begin
  Result := FPreMatch;
end;

function TMatchData.GetSize: IInteger;
begin
  Result := FSize;
end;

procedure TMatchData.SetMatchedData(const Value: IXString);
begin
  FMatchedData := Value;
end;

procedure TMatchData.SetPostMatch(const Value: IXString);
begin
  FPostMatch := Value;
end;

procedure TMatchData.SetPreMatch(const Value: IXString);
begin
  FPreMatch := Value;
end;

procedure TMatchData.SetSize(const Value: IInteger);
begin
  FSize := Value;
end;

end.
