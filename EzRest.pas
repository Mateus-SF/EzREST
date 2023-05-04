unit EzRest;

interface

uses
  Horse,

  System.JSON,
  System.SysUtils;

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

end.
