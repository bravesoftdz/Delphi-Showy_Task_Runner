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
{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := true; // �������� �� ������ ������
{$ENDIF}
  Application.Initialize;
  Application.CreateForm(TfmMain, fmMain);
  Application.Title := fmMain.Caption;
  Application.Run;

end.
