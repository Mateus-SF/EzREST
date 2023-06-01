unit EzRest;

interface

uses
  Horse,

  System.JSON,
  System.SysUtils,
  System.Classes,

  Utils.Errors;

type

  TDataModuleClass = class of TDataModule;

  TDBCallback = reference to procedure(
                              Conn: TDataModule;
                              AReq: THorseRequest;
                              ARes: THorseResponse;
                              ANext: TProc
  );

  TJsonUtils = class

  public

    class function RequireValue<T>(const Json: TJSONObject; const Key: String): T;

  end;

function RequireJson(const Req: THorseRequest; const Error: Exception): TJSONObject;
function DBCallback(
  const DataModule: TDataModuleClass;
  const Callback: TDBCallback
): THorseCallback;

implementation

function RequireJson(const Req: THorseRequest; const Error: Exception): TJSONObject;
begin

  Result := Req.Body<TJSONObject>();
  if not Assigned(Result) then
    raise Error
  else
    FreeAndNil(Error);

end;

function DBCallback(
  const DataModule: TDataModuleClass;
  const Callback: TDBCallback
): THorseCallback;
begin

  Result := procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
  var
    Conn  : TDataModule;

  begin

    try

      Conn := DataModule.Create(nil);
      Callback(Conn, Req, Res, Next);

    finally
      FreeAndNil(Conn);

    end;

  end;

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
