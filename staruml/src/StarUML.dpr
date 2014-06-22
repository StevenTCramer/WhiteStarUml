program StarUML;

uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  TWELauncherUnit,
  Forms,
  SysUtils,
  ActiveX;

{$R *.res}
var
  lTWELauncher: TTWELauncher;
begin
  ReportMemoryLeaksOnShutdown := True; //DebugHook <> 0;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'StarUML';
  Application.HelpFile := 'StarUML.chm';
  lTWELauncher := TTWELauncher.Create;
  try
    lTWELauncher.PackageFullFileName := '../Bin/StarUMLProject.dll';
    lTWELauncher.Path := ExpandFileName('../Bin');
    try
      lTWELauncher.LoadAndStart;
      Application.Run;
    finally
      lTWELauncher.StopAndUnload;
    end;
  finally
    lTWELauncher.Free;
  end;
end.
