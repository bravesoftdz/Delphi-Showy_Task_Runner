{
  Showy Task Runner v.0.1 alfa
  @author: scribe
  @date: 15.09.2015
  Delphi 2010

  Description: программа для управления заданиями на работе (по сути будильник)

  Юнит для отображения наступившего задания!
}
unit uTask;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uTR, Buttons, ExtCtrls, StdCtrls;

type
  TfmTask = class(TForm)
    mmMsg: TMemo;
    pnlMain: TPanel;
    pnlMsg: TPanel;
    pnlButtons: TPanel;
    bbDone: TBitBtn;
    bbReminder: TBitBtn;
    lblCurrTime: TLabel;
    cmbReminder: TComboBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  public
    procedure UpdateLang;
  end;

function ShowTaskDialog(const tHeader, tMsg: string; var dReminder: integer;
  const tType: TEventType = etNormal): boolean;

implementation

uses
  uMain;
{$R *.dfm}
{ TfmTask }

// Освобождаем ресурсы при закрытии
procedure TfmTask.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

// Отображение сообщения о наступлении выполнения задачи
function ShowTaskDialog(const tHeader, tMsg: string; var dReminder: integer;
  const tType: TEventType = etNormal): boolean;
begin
  with TfmTask.Create(Application) do
    try
      UpdateLang;
      Caption := tHeader;
      mmMsg.Text := tMsg;
      lblCurrTime.Caption := DateTimeTostr(now);
      case tType of
        etNormal:
          begin
            mmMsg.Color := clWhite;
          end;
        etWarning:
          begin
            mmMsg.Color := RGB(255, 113, 0);
          end;
      end;
      Result := false;
      if ShowModal = mrYes then
        Result := true;
    finally
      dReminder := strtoint(cmbReminder.Text);
      Free;
    end;
end;

// Обновление языка
procedure TfmTask.UpdateLang;
begin
  bbDone.Caption := fmMain.lsMain.GetCaption(65);
  bbReminder.Caption := fmMain.lsMain.GetCaption(66);
  cmbReminder.Items.Clear;
  fmMain.lsMain.GetLangCaptions(50, fmMain.lsMain.CurrentLanguage,
    cmbReminder.Items);
  cmbReminder.ItemIndex := 2;
end;

end.
