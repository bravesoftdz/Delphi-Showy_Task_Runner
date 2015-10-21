{
  Showy Task Runner v.0.2 alfa
  @author: scribe
  @date: 15.09.2015
  Delphi 2010

  Description: программа для управления заданиями на работе (по сути будильник)

  Юнит для создания/редактирования задачи
}
unit uEvent;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, uTR, DateUtils;

type
  TfmEvent = class(TForm)
    pnlMain: TPanel;
    pnlTask: TPanel;
    lblTime: TLabel;
    lblType: TLabel;
    lblCircleTimeType: TLabel;
    lblCircleDays: TLabel;
    lblCircleMonthDays: TLabel;
    pnlButtons: TPanel;
    btnCreate: TBitBtn;
    qmTask: TMemo;
    edName: TEdit;
    lblName: TLabel;
    pnlTaskName: TPanel;
    lblTaskName: TLabel;
    dtpTime: TDateTimePicker;
    lblDate: TLabel;
    dtpDate: TDateTimePicker;
    cbxType: TComboBox;
    cbxCircleTimeType: TComboBox;
    gbDays: TGroupBox;
    chbMon: TCheckBox;
    chbTue: TCheckBox;
    chbWed: TCheckBox;
    chbThu: TCheckBox;
    chbFri: TCheckBox;
    chbSat: TCheckBox;
    chbSun: TCheckBox;
    gbMDays: TGroupBox;
    pnlTaskMsg: TPanel;
    btnCancel: TBitBtn;
    lblGroup: TLabel;
    cbxGroup: TComboBox;
    lblStatus: TLabel;
    cbxDone: TComboBox;
    lblPrgmPath: TLabel;
    chbStartPrgm: TCheckBox;
    odPrgm: TOpenDialog;
    edPrgmPath: TEdit;
    btnChoosePath: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cbxCircleTimeTypeChange(Sender: TObject);
    procedure dtpDateChange(Sender: TObject);
    procedure edNameChange(Sender: TObject);
    procedure btnChoosePathClick(Sender: TObject);
    procedure chbStartPrgmClick(Sender: TObject);
  private
    procedure ClearMDays;
    procedure ShowMDays;
    function GetCircleDays: TCircleArrDays;
    function GetCircleMDays: TCircleMArrDays;
    procedure SetDaysState(const eCircleDays: TCircleArrDays);
    procedure SetMdaysState(const eCircleMDays: TCircleMArrDays);
    function GetGroupIdByIndex(const Index: integer): integer;
    function GetEventTime(const CTType: TCircleTimeType): TDateTime;
  public
    procedure UpdateLang;
  end;

function ShowEventCreationDialog(const gId: integer; var eList: TEventList;
  var eGroups: TGroupList): boolean;
function ShowEventEditingDialog(var eEvent: TEvent; var eList: TEventList;
  var eGroups: TGroupList): boolean;

implementation

uses
  uMain;
{$R *.dfm}

// Создание задачи
function ShowEventCreationDialog(const gId: integer; var eList: TEventList;
  var eGroups: TGroupList): boolean;
var
  i: integer;
  nextTime: TDateTime;
begin
  with TfmEvent.Create(Application) do
    try
      Result := false;
      UpdateLang;
      Caption := fmMain.lsMain.GetCaption(6);
      btnCreate.Caption := fmMain.lsMain.GetCaption(7);
      edName.Text := fmMain.lsMain.GetCaption(8);
      dtpTime.DateTime := now;
      dtpDate.DateTime := now;
      ClearMDays;
      for i := 0 to eGroups.Count - 1 do
      begin
        cbxGroup.Items.Add(eGroups.Items[i].Name + ' |' + inttostr
            (eGroups.Items[i].Id));
        if eGroups.Items[i].Id = gId then
          cbxGroup.ItemIndex := i;
      end;
      if ShowModal = mrOk then
      begin
        nextTime := GetEventTime(TCircleTimeType(cbxCircleTimeType.ItemIndex));
        eList.AddEvent(eGroups, edName.Text, qmTask.Text, nextTime,
          GetCircleDays, GetCircleMDays, TEventType(cbxType.ItemIndex),
          TCircleTimeType(cbxCircleTimeType.ItemIndex), gId, boolean
            (cbxDone.ItemIndex), chbStartPrgm.Checked, edPrgmPath.Text);
        Result := true;
      end;
    finally
      Free;
    end;
end;

// Редактирование задачи
function ShowEventEditingDialog(var eEvent: TEvent; var eList: TEventList;
  var eGroups: TGroupList): boolean;
var
  i: integer;
begin
  with TfmEvent.Create(Application) do
    try
      Result := false;
      UpdateLang; // обновили язык
      Caption := fmMain.lsMain.GetCaption(6, 1);
      btnCreate.Caption := fmMain.lsMain.GetCaption(7, 1);
      edName.Text := eEvent.eHeader;
      qmTask.Text := eEvent.eMsg;
      dtpTime.DateTime := eEvent.eTime;
      dtpDate.DateTime := eEvent.eTime;
      cbxDone.ItemIndex := integer(eEvent.eDone);
      for i := 0 to eGroups.Count - 1 do
      begin
        cbxGroup.Items.Add(eGroups.Items[i].Name + ' |' + inttostr
            (eGroups.Items[i].Id));
        if eGroups.Items[i].Id = eEvent.eGroup then
          cbxGroup.ItemIndex := i;
      end;
      cbxType.ItemIndex := integer(eEvent.eType);
      cbxCircleTimeType.ItemIndex := integer(eEvent.eCircleTimeType);
      cbxCircleTimeType.OnChange(nil);
      if cbxCircleTimeType.ItemIndex = 2 then
        SetDaysState(eEvent.eCircleDays);
      if cbxCircleTimeType.ItemIndex = 3 then
        SetMdaysState(eEvent.eCircleMonthDays);
      chbStartPrgm.Checked := eEvent.eStartPrgm;
      if eEvent.eStartPrgm then
      begin
        edPrgmPath.Text := eEvent.ePrgmPath;
        if not FileExists(edPrgmPath.Text) then
          btnCreate.Enabled := false
        else
          btnCreate.Enabled := true;
      end;
      if ShowModal = mrOk then
      begin
        eEvent.eHeader := edName.Text;
        eEvent.eMsg := qmTask.Text;
        eEvent.eGroup := GetGroupIdByIndex(cbxGroup.ItemIndex);
        eEvent.eType := TEventType(cbxType.ItemIndex);
        eEvent.eCircleTimeType := TCircleTimeType(cbxCircleTimeType.ItemIndex);
        eEvent.eCircleDays := GetCircleDays;
        eEvent.eCircleMonthDays := GetCircleMDays;
        eEvent.eDone := boolean(cbxDone.ItemIndex);
        eEvent.eTime := GetEventTime
          (TCircleTimeType(cbxCircleTimeType.ItemIndex));
        if chbStartPrgm.Checked then
        begin
          eEvent.eStartPrgm := chbStartPrgm.Checked;
          eEvent.ePrgmPath := edPrgmPath.Text;
        end
        else
        begin
          eEvent.eStartPrgm := chbStartPrgm.Checked;
          eEvent.ePrgmPath := '';
        end;
        Result := true;
      end;
    finally
      Free;
    end;
end;

// Выбираем путь
procedure TfmEvent.btnChoosePathClick(Sender: TObject);
begin
  if odPrgm.Execute then
  begin
    edPrgmPath.Text := odPrgm.FileName;
    if FileExists(edPrgmPath.Text) then
      btnCreate.Enabled := true;
  end;
end;

// Изменяем тип задачи
procedure TfmEvent.cbxCircleTimeTypeChange(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to gbDays.ControlCount - 1 do
    if gbDays.Controls[i] is TCheckBox then
      TCheckBox(gbDays.Controls[i]).Enabled := false;
  case cbxCircleTimeType.ItemIndex of
    0:
      begin // ОДИН РАЗ
        dtpTime.Enabled := true;
        dtpDate.Enabled := true;
        ClearMDays;
      end;
    1:
      begin // КАЖДЫЙ ДЕНЬ
        dtpTime.Enabled := true;
        dtpDate.Enabled := false;
        ClearMDays;
      end;
    2:
      begin // КАЖДЫЙ ДЕНЬ НЕДЕЛИ
        dtpTime.Enabled := true;
        dtpDate.Enabled := true;
        ClearMDays;
        for i := 0 to gbDays.ControlCount - 1 do
          if gbDays.Controls[i] is TCheckBox then
            TCheckBox(gbDays.Controls[i]).Enabled := true;
      end;
    3:
      begin // КАЖДЫЙ ДЕНЬ В МЕСЯЦЕ
        dtpTime.Enabled := true;
        dtpDate.Enabled := false;
        ClearMDays;
        ShowMDays;
        for i := 0 to gbMDays.ControlCount - 1 do
          if gbMDays.Controls[i] is TCheckBox then
            TCheckBox(gbMDays.Controls[i]).Enabled := true;
      end;
    4:
      begin // ПЕРВЫЙ РАБОЧИЙ ДЕНЬ МЕСЯЦА
        dtpTime.Enabled := true;
        dtpDate.Enabled := false;
        ClearMDays;
      end;
    5:
      begin // ПОСЛЕДНИЙ РАБОЧИЙ ДЕНЬ МЕСЯЦА
        dtpTime.Enabled := true;
        dtpDate.Enabled := false;
        ClearMDays;
      end
    else
      cbxCircleTimeType.ItemIndex := 0;
  end;
end;

// Пробуем ограничить пользователя от выстрелов в ногу
procedure TfmEvent.chbStartPrgmClick(Sender: TObject);
begin
  if chbStartPrgm.Checked then
  begin
    if not FileExists(edPrgmPath.Text) then
      btnCreate.Enabled := false
    else
      btnCreate.Enabled := true;
    edPrgmPath.Enabled := true;
    btnChoosePath.Enabled := true;
  end
  else if (edName.Text <> '') and not chbStartPrgm.Checked then
  begin
    btnCreate.Enabled := true;
    edPrgmPath.Enabled := false;
    btnChoosePath.Enabled := false;
  end
  else
  begin
    btnCreate.Enabled := false;
    edPrgmPath.Enabled := false;
    btnChoosePath.Enabled := false;
  end;
end;

// Удаляем динамически созданные чекбоксы
procedure TfmEvent.ClearMDays;
var
  i, m, woChb: integer;
begin
  m := 0;
  for i := 0 to gbMDays.ControlCount - 1 do
  begin
    if gbMDays.Controls[i] is TCheckBox then
      inc(m);
  end;
  woChb := gbMDays.ControlCount - m;
  if m = 0 then
    Exit;
  repeat
    if gbMDays.Controls[0] is TCheckBox then
      TCheckBox(gbMDays.Controls[0]).Free;
  until gbMDays.ControlCount = woChb;
  gbMDays.Height := 26;
end;

// Взаимодополнение даты и времени
procedure TfmEvent.dtpDateChange(Sender: TObject);
begin
  dtpTime.Date := dtpDate.Date;
end;

// Проверка на пустое имя задания
procedure TfmEvent.edNameChange(Sender: TObject);
begin
  if (edName.Text <> '') and not chbStartPrgm.Checked then
    btnCreate.Enabled := true
  else if (edName.Text <> '') and chbStartPrgm.Checked and FileExists
    (edPrgmPath.Text) then
    btnCreate.Enabled := true
  else
    btnCreate.Enabled := false;
end;

// Освобождние ресурсов при закрытии
procedure TfmEvent.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

// Заполняет переменную TCircleArrDays в зависимости от выбранных дней
function TfmEvent.GetCircleDays: TCircleArrDays;
var
  i: integer;
begin
  for i := 1 to 7 do
    Result[i] := false;
  for i := 0 to gbDays.ControlCount - 1 do
    if gbDays.Controls[i] is TCheckBox then
      if TCheckBox(gbDays.Controls[i]).Checked then
        Result[TCheckBox(gbDays.Controls[i]).Tag] := true
      else
        Result[TCheckBox(gbDays.Controls[i]).Tag] := false;
end;

// Заполняет переменную TCircleMArrDays в зависимости от выбранных дней
function TfmEvent.GetCircleMDays: TCircleMArrDays;
var
  i: integer;
begin
  for i := 1 to 31 do
    Result[i] := false;
  for i := 0 to gbMDays.ControlCount - 1 do
    if gbMDays.Controls[i] is TCheckBox then
      if TCheckBox(gbMDays.Controls[i]).Checked then
        Result[TCheckBox(gbMDays.Controls[i]).Tag] := true
      else
        Result[TCheckBox(gbMDays.Controls[i]).Tag] := false;
end;

// Узнаем следующую дату срабатывания задачи
function TfmEvent.GetEventTime(const CTType: TCircleTimeType): TDateTime;
begin
  case CTType of
    сttSingle:
      begin
        Result := dtpTime.DateTime;
      end;
    сttDay:
      begin
        if dtpTime.DateTime < now then
          Result := IncDay(dtpTime.DateTime)
        else
          Result := dtpTime.DateTime;
      end;
    сttWeek:
      begin
        if dtpTime.DateTime < now then
          Result := GetTimeOfWeek(dtpTime.DateTime, GetCircleDays)
        else
          Result := dtpTime.DateTime;
      end;
    сttMonth:
      begin
        if dtpTime.DateTime < now then
          Result := GetTimeOfMonth(dtpTime.DateTime, GetCircleMDays)
        else
          Result := dtpTime.DateTime;
      end;
    cttFirstWDMonth:
      begin
        if dtpTime.DateTime < now then
          Result := GetTimeOfFWDMonth(dtpTime.DateTime)
        else
          Result := dtpTime.DateTime;
      end;
    cttLastWDMonth:
      begin
        if dtpTime.DateTime < now then
          Result := GetTimeOfLWDMonth(dtpTime.DateTime)
        else
          Result := dtpTime.DateTime;
      end
    else
    begin
      Result := dtpTime.DateTime;
    end;
  end;
end;

// Возвращает айди по индексу в объектном списке
function TfmEvent.GetGroupIdByIndex(const Index: integer): integer;
var
  aline: string;
  pos1: integer;
begin
  Result := -1;
  try
    aline := cbxGroup.Items.Strings[Index];
    pos1 := LastPos('|', aline);
    Result := strtoint(copy(aline, pos1 + 1, Length(aline) - pos1));
  except
    on E: Exception do
      Result := -1;
  end;
end;

// Отображает состояние переменной TCircleArrDays
procedure TfmEvent.SetDaysState(const eCircleDays: TCircleArrDays);
var
  i, n: integer;
begin
  for i := 1 to 7 do
    for n := 0 to gbDays.ControlCount - 1 do
      if gbDays.Controls[n] is TCheckBox then
        if TCheckBox(gbDays.Controls[n]).Tag = i then
          if eCircleDays[i] = true then
            TCheckBox(gbDays.Controls[n]).Checked := true
          else
            TCheckBox(gbDays.Controls[n]).Checked := false;
end;

// Отображает состояние переменной TCircleMArrDays
procedure TfmEvent.SetMdaysState(const eCircleMDays: TCircleMArrDays);
var
  i, n: integer;
begin
  for i := 1 to 31 do
    for n := 0 to gbMDays.ControlCount - 1 do
      if gbMDays.Controls[n] is TCheckBox then
        if TCheckBox(gbMDays.Controls[n]).Tag = i then
          if eCircleMDays[i] = true then
            TCheckBox(gbMDays.Controls[n]).Checked := true
          else
            TCheckBox(gbMDays.Controls[n]).Checked := false;
end;

// Динамическое создание чекбоксов в зависимости от количества дней
procedure TfmEvent.ShowMDays;
var
  i, maxday, leftSep, topSep: integer;
  fchb: TCheckBox;
  chbCaption: string;
begin
  maxday := MonthDays[IsLeapYear(YearOf(dtpDate.DateTime))]
    [MonthOf(dtpDate.DateTime)];
  leftSep := 5;
  topSep := 7;
  chbCaption := fmMain.lsMain.GetCaption(10);
  for i := 1 to maxday do
  begin
    fchb := TCheckBox.Create(Self);
    fchb.Parent := gbMDays;
    fchb.Name := 'chbD' + inttostr(i);
    fchb.Caption := chbCaption + inttostr(i);
    fchb.Tag := i;
    fchb.Width := 37;
    fchb.Height := 17;
    fchb.Left := leftSep;
    fchb.Top := topSep;
    fchb.Enabled := false;
    inc(leftSep, 40);
    if leftSep > 245 then
      leftSep := 5;
    if (i mod 7) = 0 then
    begin
      inc(topSep, 16);
      gbMDays.Height := gbMDays.Height + 16;
    end;
  end;
end;

// Обновлнеие языка
procedure TfmEvent.UpdateLang;
begin
  if not fmMain.lsMain.LangLoaded then
    Exit;
  lblName.Caption := fmMain.lsMain.GetCaption(29);
  lblTime.Caption := fmMain.lsMain.GetCaption(24);
  lblDate.Caption := fmMain.lsMain.GetCaption(30);
  lblGroup.Caption := fmMain.lsMain.GetCaption(31);
  lblType.Caption := fmMain.lsMain.GetCaption(25);
  lblCircleTimeType.Caption := fmMain.lsMain.GetCaption(26);
  lblCircleDays.Caption := fmMain.lsMain.GetCaption(27);
  lblCircleMonthDays.Caption := fmMain.lsMain.GetCaption(28);
  chbStartPrgm.Caption := fmMain.lsMain.GetCaption(57);
  chbMon.Caption := fmMain.lsMain.GetCaption(43);
  chbTue.Caption := fmMain.lsMain.GetCaption(44);
  chbWed.Caption := fmMain.lsMain.GetCaption(45);
  chbThu.Caption := fmMain.lsMain.GetCaption(46);
  chbFri.Caption := fmMain.lsMain.GetCaption(47);
  chbSat.Caption := fmMain.lsMain.GetCaption(48);
  chbSun.Caption := fmMain.lsMain.GetCaption(49);
  lblPrgmPath.Caption := fmMain.lsMain.GetCaption(33);
  lblStatus.Caption := fmMain.lsMain.GetCaption(32);
  lblTaskName.Caption := fmMain.lsMain.GetCaption(53);
  btnCancel.Caption := fmMain.lsMain.GetCaption(36);
  cbxDone.Items.Clear;
  cbxDone.Items.Add(fmMain.lsMain.GetCaption(56));
  cbxDone.Items.Add(fmMain.lsMain.GetCaption(56, 1));
  cbxDone.ItemIndex := 0;
  cbxType.Items.Clear;
  cbxType.Items.Add(fmMain.lsMain.GetCaption(40));
  cbxType.Items.Add(fmMain.lsMain.GetCaption(40, 1));
  cbxType.ItemIndex := 0;
  cbxCircleTimeType.Items.Clear;
  cbxCircleTimeType.Items.Add(fmMain.lsMain.GetCaption(41));
  cbxCircleTimeType.Items.Add(fmMain.lsMain.GetCaption(41, 1));
  cbxCircleTimeType.Items.Add(fmMain.lsMain.GetCaption(41, 2));
  cbxCircleTimeType.Items.Add(fmMain.lsMain.GetCaption(41, 3));
  cbxCircleTimeType.Items.Add(fmMain.lsMain.GetCaption(41, 4));
  cbxCircleTimeType.Items.Add(fmMain.lsMain.GetCaption(41, 5));
  cbxCircleTimeType.ItemIndex := 0;
end;

end.
