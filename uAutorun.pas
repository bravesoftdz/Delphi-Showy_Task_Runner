{
  @title: uAutorun
  @author: scribe
  @date: 15.09.2015
  @version: 1.0
  @delphi: Delphi 2010

  @description: Занесение программы в автозапуск через реестр от имени
  текущего пользователя.

}
unit uAutorun;

interface

uses
  Windows, Registry;

procedure Autorun(const aFlag: boolean; const aNameParam, aPath: String);

implementation

{ Autorun

  @title = В зависимости от флага, устанавливаем или удаляем из реестра
  @aFlag = type boolean true (установить) false (удалить)
  @aNameParam = type string (имя программы)
  @aPath = type string (путь к программе) }
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
