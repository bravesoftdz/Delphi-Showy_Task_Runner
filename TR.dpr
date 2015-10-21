program TR;

uses
  Forms,
  uMain in 'uMain.pas' { fmMain } ,
  uTR in 'uTR.pas',
  uTask in 'uTask.pas' { fmTask } ,
  uEvent in 'uEvent.pas' { fmEvent } ,
  uSetConvert in 'uSetConvert.pas',
  uAutorun in 'uAutorun.pas',
  uGroup in 'uGroup.pas' { fmGroup } ;
{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := true; // Проверка на утечки памяти
  Application.Initialize;
  Application.CreateForm(TfmMain, fmMain);
  // SetWindowLong(Application.Handle, GWL_EXSTYLE, NOT WS_EX_APPWINDOW);
  Application.Title := fmMain.Caption;
  Application.Run;

end.
