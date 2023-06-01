program EzRestProject;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  EzRest in '..\src\EzRest.pas',
  EzRest.Auth in '..\src\EzRest.Auth.pas',
  EzRest.JWT in '..\src\EzRest.JWT.pas',
  EzRest.Errors in '..\src\EzRest.Errors.pas';

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
