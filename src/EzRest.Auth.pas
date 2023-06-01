unit EzRest.Auth;

interface

uses
  System.SysUtils,
  System.Classes,

  Horse,
  Horse.JWT,

  System.JSON,

  EzRest.JWT,
  EzRest.Errors;

procedure Auth(Req: THorseRequest; Res: THorseResponse; Next: TProc);
function RequireRole(
  const Callback: THorseCallback;
  const Role: String
): THorseCallback;

function VerifyScope(
  const RequiredScope : String;
  const pScopes       : TArray<String>
): Boolean;

function GetNivel(const pScope: String): String;

function GetPermissao(const pScope: String): String;

function RequireScopes(
  const Callback: THorseCallback;
  const Scopes: TArray<String>
): THorseCallback;

implementation

function GetPermissao(const pScope: String): String;
var
  Scope : TStringList;

begin

  try

    Scope := TStringList.Create();
    ExtractStrings([':'], [], PWideChar(pScope), Scope);

    Result := Scope[0];

  finally
    FreeAndNil(Scope);

  end;

end;

function GetNivel(const pScope: String): String;
var
  Scope : TStringList;

begin

  try

    Scope := TStringList.Create();
    ExtractStrings([':'], [], PWideChar(pScope), Scope);

    Result := Scope[1];

  finally
    FreeAndNil(Scope);

  end;

end;

procedure Auth(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin

  HorseJWT(
    'Santana$oft.2007',
    THorseJWTConfig.New
      .SkipRoutes(['auth/usuario', 'auth/login'])
  )(Req, Res, Next);

end;

function RequireRole(
  const Callback: THorseCallback;
  const Role: String
): THorseCallback;
begin

  Result := procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
  begin

    if GetRole(Req) <> Role then
      raise EInsufficientPermission.Create();

    Callback(Req, Res, Next);

  end;

end;

function RequireScopes(
  const Callback: THorseCallback;
  const Scopes: TArray<String>
): THorseCallback;
begin

  Result := procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
  var
    Scope: String;

  begin

    for Scope in Scopes do
    begin

      if not VerifyScope(Scope, GetScopes(Req)) then
        raise EInsufficientPermission.Create(Scope);

    end;

    Callback(Req, Res, Next);

  end;

end;

function VerifyScope(
  const RequiredScope : String;
  const pScopes       : TArray<String>
): Boolean;
var
  Scope : String;

begin


  Result := True;

  for Scope in pScopes do
    if
      (GetPermissao(Scope) = GetPermissao(RequiredScope)) and
      (GetNivel(Scope) = GetNivel(RequiredScope))
    then Exit();

  Result := False;

end;

end.
