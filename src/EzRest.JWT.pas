unit EzRest.JWT;

interface

uses
  System.SysUtils,
  System.DateUtils,
  System.JSON,
  System.Classes,

  Horse,
  Horse.JWT,
  JOSE.Core.JWT,
  JOSE.Core.Builder,
  JOSE.Core.JWK;

function CreateAccessToken(
  const ID: String;
  const Role: String;
  const Scopes: TArray<String>;
  out Expiration: TDateTime
): String; overload;

function CreateAccessToken(
  const ID: String;
  const EmpresaID: String;
  const EmpresaCNPJ: String;
  const Solucao: String;
  const Role: String;
  const Scopes: TArray<String>;
  out Expiration: TDateTime
): String; overload;

function ScopesArrayToStr(const pScopes: TArray<String>): String;

function ScopesStrToArray(const pScopes: String): TArray<String>;

function GetUsuario(Req: THorseRequest): String;

function GetEmpresa(Req: THorseRequest): String;

function GetRole(Req: THorseRequest): String;

function GetScopes(Req: THorseRequest): TArray<String>;

implementation

function GetEmpresa(Req: THorseRequest): String;
begin

  Result := Req.Session<TJSONObject>.GetValue<String>('empresaID');

end;

function ScopesArrayToStr(const pScopes: TArray<String>): String;
var
  I : Integer;

begin

  Result := pScopes[0];

  for I := 1 to Length(pScopes)-1 do
    Result := Result + ' ' + pScopes[I];

end;

function ScopesStrToArray(const pScopes: String): TArray<String>;
var
  Scopes : TStringList;

begin

  try

    Scopes := TStringList.Create();
    ExtractStrings([' '], [], PWideChar(pScopes), Scopes);

    Result := Scopes.ToStringArray();

  finally
    FreeAndNil(Scopes);

  end;

end;

function CreateAccessToken(
  const ID: String;
  const Role: String;
  const Scopes: TArray<String>;
  out Expiration: TDateTime
): String;
var
  Token : TJWT;
  Key   : TJWK;

begin

  try

    Token := TJWT.Create();

    Expiration := IncDay(Now(), 1);
    Token.Claims.Expiration := Expiration;
    Token.Claims.Subject := ID;
    Token.Claims.SetClaim('role', Role);
    Token.Claims.SetClaim('scopes', ScopesArrayToStr(Scopes));

    Result := TJOSE.SHA256CompactToken('Santana$oft.2007', Token);

  finally
    FreeAndNil(Token);

  end;

end;

function CreateAccessToken(
  const ID: String;
  const EmpresaID: String;
  const EmpresaCNPJ: String;
  const Solucao: String;
  const Role: String;
  const Scopes: TArray<String>;
  out Expiration: TDateTime
): String; overload;
var
  Token: TJWT;

begin

  try

    Token := TJWT.Create();

    Expiration := IncDay(Now(), 1);
    Token.Claims.Expiration := Expiration;
    Token.Claims.Subject := ID;
    Token.Claims.Audience := Solucao;
    Token.Claims.SetClaim('empresaID', EmpresaID);
    Token.Claims.SetClaim('empresaCNPJ', EmpresaCNPJ);
    Token.Claims.SetClaim('role', Role);
    Token.Claims.SetClaim('scopes', ScopesArrayToStr(Scopes));

    Result := TJOSE.SHA256CompactToken('Santana$oft.2007', Token);

  finally
    FreeAndNil(Token);

  end;

end;

function GetUsuario(Req: THorseRequest): String;
begin

  Result := Req.Session<TJSONObject>.GetValue<String>('sub');
//  Result := Req.Query.Field('requester-id').AsString;

end;

function GetRole(Req: THorseRequest): String;
begin

  Result := Req.Session<TJSONObject>.GetValue<String>('role');
//  Result := Req.Query.Field('requester-role').AsString;

end;

function GetScopes(Req: THorseRequest): TArray<String>;
begin

  Result := ScopesStrToArray( Req.Session<TJSONObject>.GetValue<String>('scopes') );

end;

end.
