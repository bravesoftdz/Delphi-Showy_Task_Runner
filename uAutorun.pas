{
  @title: uAutorun
  @author: scribe
  @date: 15.09.2015
  @version: 1.0
  @delphi: Delphi 2010

  @description: ��������� ��������� � ���������� ����� ������ �� �����
  �������� ������������.

}
unit uAutorun;

interface

uses
  Windows, Registry;

procedure Autorun(const aFlag: boolean; const aNameParam, aPath: String);

implementation

{ Autorun

  @title = � ����������� �� �����, ������������� ��� ������� �� �������
  @aFlag = type boolean true (����������) false (�������)
  @aNameParam = type string (��� ���������)
  @aPath = type string (���� � ���������) }
procedure Autorun(const aFlag: boolean; const aNameParam, aPath: String);
var
  Reg: TRegistry;
begin
  if aFlag then
  begin
    Reg := TRegistry.Create;
    Reg.RootKey := HKEY_CURRENT_USER;
    Reg.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Run', false);
    Reg.WriteString(aNameParam, aPath);
    Reg.Free;
  end
  else
  begin
    Reg := TRegistry.Create;
    Reg.RootKey := HKEY_CURRENT_USER;
    Reg.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Run', false);
    Reg.DeleteValue(aNameParam);
    Reg.Free;
  end;
end;

end.
