unit EzRest.Errors;

interface

uses
  Horse.Exception,
  Horse;

type

  EInsufficientPermission = class(EHorseException)

  public

    constructor Create(); reintroduce; overload;
    constructor Create(const Scope: String); reintroduce; overload;

  end;

implementation

{ EInsufficientPermission }

constructor EInsufficientPermission.Create;
begin

  inherited Create();

  Error('Insufficient Permission');
  Status(THTTPStatus.Unauthorized);

end;

constructor EInsufficientPermission.Create(const Scope: String);
begin

  inherited Create();

  Error('Insufficient Permission: ' + Scope);
  Status(THTTPStatus.Unauthorized);

end;

end.
