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

  EInvalidBody = class(EHorseException)

  public

    constructor Create(); reintroduce;

  end;

  ERequiredField = class(EHorseException)

  public

    constructor Create(const pError: String); reintroduce;

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

{ EInvalidBody }

constructor EInvalidBody.Create;
begin

  inherited Create();

  Error('Invalid body');
  Status(THTTPStatus.BadRequest);

end;

{ ERequiredField }

constructor ERequiredField.Create(const pError: String);
begin

  inherited Create();

  Error(pError);
  Status(THTTPStatus.BadRequest);

end;

end.
