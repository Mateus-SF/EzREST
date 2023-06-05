unit EzRest;

interface

uses
  Horse,

  System.JSON,
  System.SysUtils,
  System.Classes,

  EzRest.Errors;

type

  TJsonUtils = class

  public

    class function RequireValue<T>(const Json: TJSONObject; const Key: String): T;

  end;

function RequireJson(const Req: THorseRequest; const Error: Exception): TJSONObject;

implementation

function RequireJson(const Req: THorseRequest; const Error: Exception): TJSONObject;
begin

  Result := Req.Body<TJSONObject>();
  if not Assigned(Result) then
    raise Error
  else
    FreeAndNil(Error);

end;

{$REGION 'TJsonUtils'}

class function TJsonUtils.RequireValue<T>(const Json: TJSONObject;
  const Key: String): T;
begin

  if not Json.TryGetValue<T>(Key, Result) then
    raise ERequiredField.Create(Key);

end;

{$ENDREGION}

end.
