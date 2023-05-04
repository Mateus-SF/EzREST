unit EzRest;

interface

uses
  Horse,

  System.JSON,
  System.SysUtils,
  System.Classes;

type

  TDataModuleClass = class of TDataModule;

  TDBCallback = reference to procedure(
                              Conn: TDataModule;
                              AReq: THorseRequest;
                              ARes: THorseResponse;
                              ANext: TProc
  );

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

end.
