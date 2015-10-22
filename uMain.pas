{
  Showy Task Runner v.0.2 alfa
  @author: scribe
  @date: 15.09.2015
  Delphi 2010

  Description: программа для управления заданиями на работе (по сути будильник)

  Основной юнит
}
unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DateUtils, Menus, ComCtrls, ExtCtrls, Buttons, CommCtrl,
  IniFiles, AppEvnts, ImgList, ActnList,
  uTR, uTask, uEvent, uGroup, uAutorun, uLangStorage;

type

  { TScrTreeView

    Добавили обработку события скрола (в принцыпе уже незачем, но... много переписывать=) ) }
  TScrTreeView = class(TTreeView)
  private
    // procedure WMHScroll(var Message: TWMHScroll);
    // message WM_HSCROLL;
    // procedure WMVScroll(var Message: TWMVScroll);
    // message WM_VSCROLL;
  end;

  TfmMain = class(TForm)
    pcMain: TPageControl;
    tsMain: TTabSheet;
    mmMain: TMainMenu;
    miFile: TMenuItem;
    miExit: TMenuItem;
    miHelp: TMenuItem;
    pnlTask: TPanel;
    pnlButtons: TPanel;
    qmTask: TMemo;
    tsNext: TTabSheet;
    stList: TSplitter;
    lblTime: TLabel;
    lblReminder: TLabel;
    lblType: TLabel;
    lblCircleTimeType: TLabel;
    ostTask: TSplitter;
    lblHeader: TLabel;
    lblCircleDays: TLabel;
    lblCircleMonthDays: TLabel;
    btnDone: TBitBtn;
    btnChange: TBitBtn;
    lblStatus: TLabel;
    ppList: TPopupMenu;
    miNewEvent: TMenuItem;
    miNewGroup: TMenuItem;
    miDeleteEvent: TMenuItem;
    miDeleteGroup: TMenuItem;
    stsBar: TStatusBar;
    miEditEvent: TMenuItem;
    tiTray: TTrayIcon;
    miInfo: TMenuItem;
    ppAuto: TPopupMenu;
    miAutorun: TMenuItem;
    lblPrgm: TLabel;
    lbNext: TListBox;
    miEditGroup: TMenuItem;
    lsMain: TLangStorage; // Компонент для управления языком
    miLanguage: TMenuItem;
    pnlTaskInfo: TPanel;
    imlMain: TImageList;
    alMain: TActionList;
    actExit: TAction;
    Exit1: TMenuItem;
    actInfo: TAction;
    Info1: TMenuItem;
    actLang: TAction;
    miRunInTray: TMenuItem;
    miRestore: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tvListClick(Sender: TObject);
    procedure tvListCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure btnDoneClick(Sender: TObject);
    procedure ppListPopup(Sender: TObject);
    procedure miNewGroupClick(Sender: TObject);
    procedure miDeleteGroupClick(Sender: TObject);
    procedure miDeleteEventClick(Sender: TObject);
    procedure miNewEventClick(Sender: TObject);
    procedure miEditEventClick(Sender: TObject);
    procedure tiTrayClick(Sender: TObject);
    procedure miAutorunClick(Sender: TObject);
    procedure lbNextDrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
      State: TOwnerDrawState);
    procedure miEditGroupClick(Sender: TObject);
    procedure miLangListItemClick(Sender: TObject);
    procedure tvListGetImageIndex(Sender: TObject; Node: TTreeNode);
    procedure tvListGetSelectedIndex(Sender: TObject; Node: TTreeNode);
    procedure tvListExpanded(Sender: TObject; Node: TTreeNode);
    procedure tvListOnExit(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actInfoExecute(Sender: TObject);
    procedure miRunInTrayClick(Sender: TObject);
    procedure ppAutoPopup(Sender: TObject);
    procedure lbNextClick(Sender: TObject);
    procedure tvListExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure tvListCollapsing(Sender: TObject; Node: TTreeNode;
      var AllowCollapse: Boolean);
  private
    TaskPanelVisible: Boolean; // Видимость информации о задании
    inTray: Boolean; // Программа находиться в трее?
    LastGroupIndex: Integer; // Последний индекс группы
    EventSelected: Boolean; // Флаг выбора задания
    GroupSelected: Boolean; // Флаг выбора группы
    SelectedEvent: TEvent; // Выбраное задание
    SelectedGroup: TGroupItem; // Выбраная группа
    CurrentLanguage: string; // Текущий язык
    FHotkey, FMainHotKey: Integer;
    function GetGroupIndex(const gId: Integer; var Tree: TTreeView): Integer;
    procedure ShowGroups(var Tree: TTreeView; var Groups: TGroupList);
    procedure ExpandGroups(var Tree: TTreeView);
    procedure ShowEvents(var Tree: TTreeView; var Events: TEventList);
    procedure ShowEvent(const Event: TEvent);
    procedure ShowNextEvents(var Events: TEventList);
    procedure ShowTaskPanel;
    procedure SaveFormPos(const FileName: TFileName = 'app_pos.data');
    procedure LoadFormState(const FileName: TFileName = 'app_pos.data');
    procedure SetAutoRun(const Auto: Boolean);
    procedure DeselectItems;
    procedure DrawButton(ARect: TRect; Node: TTreeNode);
    procedure DrawImage(NodeRect: TRect; ImageIndex: Integer);
    procedure SetNodeHeight(Node: TTreeNode; Integral: Integer);
    procedure CreateTVList;
    function GetNextItemDate(const aValue: string): TDateTime;
    function GetTextDateDiff(const aValue: real): string;
    function Num2Day(const aNum: Integer; const aSpaces: Boolean = true)
      : string;
    function Num2Hour(const aNum: Integer; const aSpaces: Boolean = true)
      : string;
    function Num2Minute(const aNum: Integer; const aSpaces: Boolean = true)
      : string;
    function Num2Second(const aNum: Integer; const aSpaces: Boolean = true)
      : string;
    procedure WMHotKey(var aMsg: TWMHotKey);
    message WM_HOTKEY;
    procedure ShortCutToHotKey(aHotKey: TShortCut; var aKey: Word;
      var aModifiers: Uint);
    procedure RegisterMainHotKey(const aKey: TShortCut);
  public
    GroupList: TGroupList; // Список групп
    EventList: TEventList; // Список заданий
    LangList: TStringList; // Список языков
    tvList: TScrTreeView; // Список для отображения всего и вся
    procedure UpdateList; // Обновление списка с группами и заданиями
    procedure UpdateLang; // Обновление текущего языка
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

{ TfmMain.actExitExecute

  Закрытие формы }
procedure TfmMain.actExitExecute(Sender: TObject);
begin
  fmMain.Close;
end;

{ TfmMain.actInfoExecute

  Немножко инфо о создателе }
procedure TfmMain.actInfoExecute(Sender: TObject);
begin
  ShowMessage('by scribe, 2015, Kyiv' + #13#10 + 'e-mail: _scribe_@ukr.net');
end;

{ TfmMain.actInfoExecute

  Делаем задачу выполненной (навсегда) }
procedure TfmMain.btnDoneClick(Sender: TObject);
begin
  if EventSelected then
    SelectedEvent.eDone := true;
end;

{ TfmMain.CreateTVList

  Создаем контрол для отображения групп и задач }
procedure TfmMain.CreateTVList;
begin
  tvList := TScrTreeView.Create(fmMain);
  tvList.Name := 'tvList';
  tvList.Left := 0;
  tvList.Top := 0;
  tvList.Width := 177;
  tvList.Height := 514;
  tvList.Align := alCustom;
  stList.Align := alCustom;
  tvList.Align := alLeft;
  stList.Align := alLeft;
  tvList.Parent := tsMain;
  tvList.BevelEdges := [];
  tvList.BorderStyle := bsNone;
  tvList.Color := clWhite;
  tvList.Ctl3D := false;
  // tvList.DoubleBuffered := true;
  tvList.Images := imlMain;
  tvList.PopupMenu := ppList;
  tvList.ReadOnly := true;
  tvList.SortType := stText;
  tvList.TabOrder := 0;
  tvList.OnClick := tvListClick;
  tvList.OnCollapsed := tvListExpanded;
  tvList.OnCustomDrawItem := tvListCustomDrawItem;
  tvList.OnExpanded := tvListExpanded;
  tvList.OnGetImageIndex := tvListGetImageIndex;
  tvList.OnGetSelectedIndex := tvListGetSelectedIndex;
  tvList.OnExpanding := tvListExpanding;
  tvList.OnCollapsing := tvListCollapsing;
  // tvList.OnExit := tvListOnExit;
  tvList.Show;
end;

{ TfmMain.DeselectItems

  Убираем выделение группы и/или задачи }
procedure TfmMain.DeselectItems;
begin
  GroupSelected := false;
  EventSelected := false;
  SelectedGroup := nil;
  SelectedEvent := nil;
  UpdateList;
end;

{ TfmMain.DrawButton

  Отрисовка управляющих элементов (квадратиков с линиями) для TTreeView }
procedure TfmMain.DrawButton(ARect: TRect; Node: TTreeNode);
var
  cx, cy: Integer;
begin
  cx := ARect.Left + tvList.Indent div 2;
  cy := ARect.Top + (ARect.Bottom - ARect.Top) div 2;
  with tvList.Canvas do
  begin
    Pen.Color := clSilver;
    Pen.Style := psDot;
    // Длинная и короткая, зависит есть ли наследник, чтобы в квадратике не рисовать
    if Node.HasChildren then
    begin
      PenPos := Point(cx + 5, cy);
      LineTo(ARect.Left + tvList.Indent + 5, cy);
    end
    else
    begin
      PenPos := Point(cx, cy);
      LineTo(ARect.Left + tvList.Indent + 5, cy);
    end;
    // Верхняя линия (половинка, от центра)
    if (Node.Parent <> nil) and Node.HasChildren then
    begin
      PenPos := Point(cx, cy - 6);
      LineTo(cx, ARect.Top - 1);
    end
    else if (Node.Parent = nil) and not Node.HasChildren then
    begin
      PenPos := Point(cx, cy);
      LineTo(cx, ARect.Top - 1);
    end
    else if Node.Parent <> nil then
    begin
      PenPos := Point(cx, cy);
      LineTo(cx, ARect.Top - 1);
    end;
    // Нижняя линия (половинка, от центра)
    if (((Node.GetNextVisible <> nil) and
          (Node.GetNextVisible.Level = Node.Level)) or
        (Node.GetNextSibling <> nil)) and not Node.HasChildren then
    begin
      PenPos := Point(cx, cy);
      LineTo(cx, ARect.Bottom);
    end;
    // Линии внутри квадратиков (для тех, у кого есть наследники)
    if Node.HasChildren then
    begin
      Pen.Color := clGray;
      Pen.Style := psSolid;
      Rectangle(cx - 5, cy - 5, cx + 6, cy + 6); // Сам квадратик
      Pen.Color := clBlack;
      // горизонтальная линия
      PenPos := Point(cx - 5 + 2, cy);
      LineTo(cx + 5 - 1, cy);
      // рисуем вертикальную если раскрыт
      if not Node.Expanded then
      begin
        PenPos := Point(cx, cy - 3);
        LineTo(cx, cy + 4);
      end;
    end;
    // Соединяемся линиями с верхними уровнями
    Pen.Color := clSilver;
    Pen.Style := psDot;
    Node := Node.Parent;
    while Node <> nil do
    begin
      cx := cx - tvList.Indent;
      if Node.GetNextSibling <> nil then
      begin
        PenPos := Point(cx, ARect.Top);
        LineTo(cx, ARect.Bottom);
      end;
      Node := Node.Parent;
    end;
  end;
end;

{ TfmMain.DrawImage

  Отрисовка картинок в нодах TTreeView (взято с офф. примеров) }
procedure TfmMain.DrawImage(NodeRect: TRect; ImageIndex: Integer);
var
  cy: Integer;
begin
  cy := NodeRect.Top + (NodeRect.Bottom - NodeRect.Top) div 2;
  // рисуем картинку в центре ноды
  imlMain.Draw(tvList.Canvas, NodeRect.Left, cy - tvList.Images.Height div 2,
    ImageIndex, true);
end;

{ TfmMain.ExpandGroups

  Раскрытие/сворачивание групп }
procedure TfmMain.ExpandGroups(var Tree: TTreeView);
var
  i: Integer;
begin
  if not GroupList.Loaded then
    Exit;
  for i := 0 to Tree.Items.Count - 1 do
  begin
    if TObject(Tree.Items[i].Data) is TGroupItem then
      Tree.Items[i].Expanded := TGroupItem(Tree.Items[i].Data).Expanded;
  end;
end;

{ TfmMain.FormClose

  Закрытие формы }
procedure TfmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  EventList.Stop; // Останавливаем поток
  EventList.SaveEvents; // Сохраняем список задач
  EventList.Free; // Освобождаем
  GroupList.SaveGroups; // Сохраняем список групп
  GroupList.Free; // Освобождаем
  LangList.Free; // Освобождаем список с языком
  SaveFormPos; // Сохраняем настройки формы
  tvList.Free;
end;

{ TfmMain.FormCreate

  Инициализация всего при создании }
procedure TfmMain.FormCreate(Sender: TObject);
begin
  CreateTVList; // Создаем наш кастомный TTreeView
  LoadFormState(); // Загружаем настройки формы

  LangList := TStringList.Create; // Создаем объект для списка языков
  lsMain.FileName := ExtractFilePath(ParamStr(0))
    + 'LS_' + CurrentLanguage + '.ini';
  lsMain.LoadLanguage; // Загружаем язык из настроек
  lsMain.GetLanguageList(LangList); // Узнаем список доступных языков
  UpdateLang; // Обновляем язык

  stsBar.Panels.Add; // Настройка панели
  stsBar.Panels[0].Width := 150; // --//--
  stsBar.Font.Style := [fsBold]; // --//--

  GroupList := TGroupList.Create; // Создаем объект для списка групп
  GroupList.LoadGroups; // Загружаем из файла
  GroupList.AutoSave := true; // Разрешаем автосохранение

  EventList := TEventList.Create; // Создаем объект для списка задач
  EventList.LoadEvents; // Загружаем из файла
  EventList.AutoSave := true; // Разрешаем автосохранение
  UpdateList; // Обновляем список
  ShowTaskPanel; // Показываем панель

  Application.OnMinimize := tiTray.OnClick; // Для минимизации у нас есть своя процедура
end;

{ TfmMain.GetGroupIndex

  Узнаем индекс группы в TTreeView по айди }
function TfmMain.GetGroupIndex(const gId: Integer; var Tree: TTreeView)
  : Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Tree.Items.Count - 1 do
  begin
    if (Tree.Items[i].Data <> nil) and (TObject(Tree.Items[i].Data)
        is TGroupItem) then
      if TGroupItem(Tree.Items[i].Data).Id = gId then
        Result := i;
  end;
end;

{ TfmMain.GetNextItemDate

  Извлекаем дату из строки в следующих задачах }
function TfmMain.GetNextItemDate(const aValue: string): TDateTime;
var
  s: string;
begin
  s := copy(aValue, 1, pos('-', aValue));
  Result := StrToDateTime(s);
end;

{ TfmMain.GetTextDateDiff

  Преобразоываем разницу во времени до тесктовго представления }
function TfmMain.GetTextDateDiff(const aValue: real): string;
var
  days, hours, minutes, seconds: Integer;
  rtime: real;
begin
  Result := '';
  days := trunc(aValue);
  rtime := Frac(aValue);
  hours := trunc(rtime / (1 / 24));
  minutes := trunc((rtime - (hours * (1 / 24))) / (1 / (24 * 60)));
  seconds := trunc((rtime - (hours * (1 / 24)) - (minutes * (1 / (24 * 60)))) /
      (1 / (24 * 3600)));
  Result := IntToStr(days) + Num2Day(days) + IntToStr(hours) + Num2Hour(hours)
    + IntToStr(minutes) + Num2Minute(minutes) + IntToStr(seconds) + Num2Second
    (seconds);
end;

{ TfmMain.lbNextClick

  Отображение преобразованной разницы во времени через хинт }
procedure TfmMain.lbNextClick(Sender: TObject);
begin
  if (lbNext.Count > 0) and (lbNext.ItemIndex >= 0) and
    (lbNext.ItemIndex <= lbNext.Count - 1) then
  begin
    lbNext.Hint := GetTextDateDiff
      (GetNextItemDate(lbNext.Items.Strings[lbNext.ItemIndex]) - now);
    lbNext.ShowHint := true;
  end
  else
    lbNext.ShowHint := false;
end;

{ TfmMain.lbNextDrawItem

  Отображение задач для вкладки "следующие" }
procedure TfmMain.lbNextDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  with (Control as TListBox).Canvas do
  begin
    if (odSelected in State) then
    begin
      Brush.Color := $00FFD2A6;
      FillRect(Rect);
      TextOut(Rect.Left, Rect.Top, (Control as TListBox).Items[Index]);
    end
    else if not(odSelected in State) then
    begin
      if ((Control as TListBox).Items.Objects[Index] is TEvent) then
      begin
        FillRect(Rect);
        if TEvent((Control as TListBox).Items.Objects[Index]).eDone = true then
        begin
          if TEvent((Control as TListBox).Items.Objects[Index])
            .eType = etWarning then
            Brush.Color := RGB(255, 128, 128)
          else
            Brush.Color := clWhite;
          Font.Style := Font.Style + [fsItalic];
          Font.Color := clGray;
          TextOut(Rect.Left, Rect.Top, '*' + (Control as TListBox)
              .Items.Strings[Index]);
        end
        else
        begin
          if TEvent((Control as TListBox).Items.Objects[Index])
            .eType = etWarning then
            Brush.Color := clRed
          else
            Brush.Color := clWhite;
          Font.Style := Font.Style - [fsItalic];
          Font.Color := clBlack;
          TextOut(Rect.Left, Rect.Top, (Control as TListBox)
              .Items.Strings[Index]);
        end;
      end;
    end;
    if (odFocused in State) then
    begin
      Brush.Color := (Control as TListBox).Color;
      DrawFocusRect(Rect);
    end;
  end;
end;

{ TfmMain.LoadFormState

  Загрузка настроек формы }
procedure TfmMain.LoadFormState(const FileName: TFileName);
var
  F: TIniFile;
begin
  F := TIniFile.Create(ExtractFilePath(ParamStr(0)) + FileName);
  try
    tvList.Width := F.ReadInteger('Main_list', 'Width', 177);
    miAutorun.Checked := F.ReadBool('Program', 'Autorun', false);
    CurrentLanguage := F.ReadString('Program', 'Language', 'UA');
    fmMain.Width := F.ReadInteger('Program', 'Width', 530);
    fmMain.Height := F.ReadInteger('Program', 'Height', 720);
    miRunInTray.Checked := F.ReadBool('Program', 'RunInTray', false);
    if miRunInTray.Checked then
    begin
      Application.ShowMainForm := false;
      inTray := true;
    end;
  finally
    F.Free;
  end;
end;

{ TfmMain.miAutorunClick

  Установка программы в автозапуск }
procedure TfmMain.miAutorunClick(Sender: TObject);
begin
  miAutorun.Checked := not miAutorun.Checked;
  SetAutoRun(miAutorun.Checked);
end;

{ TfmMain.miDeleteEventClick

  Удаление задачи }
procedure TfmMain.miDeleteEventClick(Sender: TObject);
begin
  try
    if EventSelected then
      EventList.DeleteEvent(SelectedEvent.Id);
  finally
    DeselectItems;
    ShowTaskPanel;
  end;
end;

{ TfmMain.miDeleteGroupClick

  Удалнеие группы }
procedure TfmMain.miDeleteGroupClick(Sender: TObject);
begin
  try
    if GroupSelected then
      GroupList.DeleteGroup(SelectedGroup.Id);
  finally
    DeselectItems;
  end;
end;

{ TfmMain.miEditEventClick

  Редактирование задачи }
procedure TfmMain.miEditEventClick(Sender: TObject);
begin
  try
    if EventSelected and not GroupSelected then
      if ShowEventEditingDialog(SelectedEvent, EventList, GroupList) then
        ShowMessage(lsMain.GetCaption(0, 0));
    if GroupSelected and not EventSelected then
      ShowMessage(lsMain.GetCaption(2));
    if not GroupSelected and not EventSelected then
      ShowMessage(lsMain.GetCaption(2));
  finally
    DeselectItems;
    ShowTaskPanel;
  end;
end;

{ TfmMain.miEditGroupClick

  Редактирование группы }
procedure TfmMain.miEditGroupClick(Sender: TObject);
begin
  if GroupSelected then
    try
      ShowGroupEditingDialog(GroupList, SelectedGroup.Id);
    finally
      DeselectItems;
    end;
end;

{ TfmMain.miLangListItemClick

  Клик по меню с языками }
procedure TfmMain.miLangListItemClick(Sender: TObject);
begin
  if Sender is TMenuItem then
  begin
    lsMain.FileName := ExtractFilePath(ParamStr(0)) + 'LS_' + copy
      (TMenuItem(Sender).Name, 3, 255) + '.ini';
    lsMain.LoadLanguage;
    CurrentLanguage := lsMain.CurrentLanguage;
    UpdateLang;
  end;
end;

{ TfmMain.miNewEventClick

  Новая задача }
procedure TfmMain.miNewEventClick(Sender: TObject);
begin
  try
    if EventSelected and not GroupSelected then
      if ShowEventCreationDialog(SelectedEvent.eGroup, EventList, GroupList)
        then
        ShowMessage(lsMain.GetCaption(15, 0));
    if GroupSelected and not EventSelected then
      if ShowEventCreationDialog(SelectedGroup.Id, EventList, GroupList) then
        ShowMessage(lsMain.GetCaption(15, 0));
    if not GroupSelected and not EventSelected then
      if ShowEventCreationDialog(0, EventList, GroupList) then
        ShowMessage(lsMain.GetCaption(15, 0));
  finally
    DeselectItems;
  end;
end;

{ TfmMain.miNewGroupClick

  Новая группа }
procedure TfmMain.miNewGroupClick(Sender: TObject);
begin
  try
    if GroupSelected and not EventSelected then
      ShowGroupCreationDialog(GroupList, SelectedGroup.Id);
    if EventSelected and not GroupSelected then
      ShowGroupCreationDialog(GroupList, SelectedEvent.eGroup);
    if not GroupSelected and not EventSelected then
      ShowGroupCreationDialog(GroupList);
  finally
    DeselectItems;
  end;
end;

{ TfmMain.miRunInTrayClick

  Запуск программы свернутой }
procedure TfmMain.miRunInTrayClick(Sender: TObject);
begin
  miRunInTray.Checked := not miRunInTray.Checked;
  SaveFormPos;
end;

function TfmMain.Num2Day(const aNum: Integer; const aSpaces: Boolean): string;
var
  numTxt: string;
begin
  Result := '';
  numTxt := IntToStr(aNum);
  numTxt := copy(numTxt, length(numTxt), 1);
  if numTxt = '1' then
    Result := lsMain.GetCaption(68)
  else if (numTxt = '2') or (numTxt = '3') or (numTxt = '4') then
    Result := lsMain.GetCaption(68, 1)
  else
    Result := lsMain.GetCaption(68, 2);
  if aSpaces then
    Result := ' ' + Result + ' ';
end;

{ TfmMain.Num2Hour

  Преобразовать количество дней в тесктовое представление }
function TfmMain.Num2Hour(const aNum: Integer; const aSpaces: Boolean): string;
var
  numTxt: string;
begin
  Result := '';
  numTxt := IntToStr(aNum);
  numTxt := copy(numTxt, length(numTxt), 1);
  if numTxt = '1' then
    Result := lsMain.GetCaption(68, 3)
  else if (numTxt = '2') or (numTxt = '3') or (numTxt = '4') then
    Result := lsMain.GetCaption(68, 4)
  else
    Result := lsMain.GetCaption(68, 5);
  if aSpaces then
    Result := ' ' + Result + ' ';
end;

{ TfmMain.Num2Minute

  Преобразовать количество минут в тесктовое представление }
function TfmMain.Num2Minute(const aNum: Integer; const aSpaces: Boolean)
  : string;
var
  numTxt: string;
begin
  Result := '';
  numTxt := IntToStr(aNum);
  numTxt := copy(numTxt, length(numTxt), 1);
  if numTxt = '1' then
    Result := lsMain.GetCaption(68, 6)
  else if (numTxt = '2') or (numTxt = '3') or (numTxt = '4') then
    Result := lsMain.GetCaption(68, 7)
  else
    Result := lsMain.GetCaption(68, 8);
  if aSpaces then
    Result := ' ' + Result + ' ';
end;

{ TfmMain.Num2Second

  Преобразовать количество секунд в тесктовое представление }
function TfmMain.Num2Second(const aNum: Integer; const aSpaces: Boolean)
  : string;
var
  numTxt: string;
begin
  Result := '';
  numTxt := IntToStr(aNum);
  numTxt := copy(numTxt, length(numTxt), 1);
  if numTxt = '1' then
    Result := lsMain.GetCaption(68, 9)
  else if (numTxt = '2') or (numTxt = '3') or (numTxt = '4') then
    Result := lsMain.GetCaption(68, 10)
  else
    Result := lsMain.GetCaption(68, 11);
  if aSpaces then
    Result := ' ' + Result + ' ';
end;

{ TfmMain.ppAutoPopup

  Отображение меню развертывания окна в зависимости от его статуса }
procedure TfmMain.ppAutoPopup(Sender: TObject);
begin
  miRestore.Visible := inTray;
end;

{ TfmMain.ppListPopup

  Какое меню именно отображать }
procedure TfmMain.ppListPopup(Sender: TObject);
begin
  if EventSelected and not GroupSelected then
  begin
    miNewGroup.Visible := true;
    miEditGroup.Visible := false;
    miDeleteGroup.Visible := false;
    miNewEvent.Visible := true;
    miEditEvent.Visible := true;
    miDeleteEvent.Visible := true;
  end
  else if GroupSelected and not EventSelected then
  begin
    miNewGroup.Visible := true;
    miEditGroup.Visible := true;
    miDeleteGroup.Visible := true;
    miNewEvent.Visible := true;
    miEditEvent.Visible := false;
    miDeleteEvent.Visible := false;
  end
  else
  begin
    miNewGroup.Visible := true;
    miEditGroup.Visible := false;
    miDeleteGroup.Visible := false;
    miNewEvent.Visible := true;
    miEditEvent.Visible := false;
    miDeleteEvent.Visible := false;
  end;
end;

procedure TfmMain.RegisterMainHotKey(const aKey: TShortCut);
var
  Key: Word;
  Modifiers: Uint;
begin
  UnRegisterHotKey(Handle, FHotkey);
  GlobalDeleteAtom(FHotkey);
  ShortCutToHotKey(aKey, Key, Modifiers);
  FHotkey := GlobalAddAtom('STR_v.0.2_Hotkey');
  RegisterHotKey(Handle, FHotkey, Modifiers, Key);
end;

{ TfmMain.SaveFormPos

  Сохранение настроек }
procedure TfmMain.SaveFormPos(const FileName: TFileName);
var
  F: TIniFile;
begin
  F := TIniFile.Create(ExtractFilePath(ParamStr(0)) + FileName);
  try
    F.WriteInteger('Main_list', 'Width', tvList.Width);
    F.WriteBool('Program', 'Autorun', miAutorun.Checked);
    F.WriteString('Program', 'Language', CurrentLanguage);
    F.WriteInteger('Program', 'Width', fmMain.Width);
    F.WriteInteger('Program', 'Height', fmMain.Height);
    F.WriteBool('Program', 'RunInTray', miRunInTray.Checked);
  finally
    F.Free;
  end;
end;

{ TfmMain.SetAutoRun

  Процедура для установки программы в автозапуск }
procedure TfmMain.SetAutoRun(const Auto: Boolean);
begin
  Autorun(Auto, '', Application.ExeName);
end;

{ TfmMain.SetNodeHeight

  Процедура установки высоты нода (правда указывать можно только разы,
  т.е. в 2 раза 3,4... больше обычного) }
procedure TfmMain.SetNodeHeight(Node: TTreeNode; Integral: Integer);
var
  ItemEx: TTVItemEx;
begin
  if not Node.Deleting then
  begin
    ItemEx.mask := TVIF_HANDLE or TVIF_INTEGRAL;
    ItemEx.hItem := Node.ItemId;
    ItemEx.iIntegral := Integral;
    TreeView_SetItem(Node.Handle, ItemEx);
  end;
end;

{ TfmMain.ShortCutToHotKey

  Преобразовывает TShortCut в HotKey}
procedure TfmMain.ShortCutToHotKey(aHotKey: TShortCut; var aKey: Word;
  var aModifiers: Uint);
var
  Shift: TShiftState;
begin
  ShortCutToKey(aHotKey, aKey, Shift);
  aModifiers := 0;
  if (ssShift in Shift) then
    aModifiers := aModifiers or MOD_SHIFT;
  if (ssAlt in Shift) then
    aModifiers := aModifiers or MOD_ALT;
  if (ssCtrl in Shift) then
    aModifiers := aModifiers or MOD_CONTROL;
end;

{ TfmMain.ShowEvent

  Отображение задачи }
procedure TfmMain.ShowEvent(const Event: TEvent);
begin
  if not TaskPanelVisible then // показ контролов, если скрытые
    ShowTaskPanel;
  lblHeader.Caption := Event.eHeader;
  lblTime.Caption := lsMain.GetCaption(24) + #32 + datetimetostr(Event.eTime);
  lblReminder.Caption := lsMain.GetCaption(54) + #32 + datetimetostr
    (Event.eReminder);

  if Event.eReminder > Event.eTime then // определение, кто раньше
  begin
    lblReminder.Font.Color := clGreen;
    lblTime.Font.Color := clBlack;
  end
  else
  begin
    lblTime.Font.Color := clGreen;
    lblReminder.Font.Color := clBlack;
    lblReminder.Caption := lsMain.GetCaption(54);
  end;

  lblType.Caption := lsMain.GetCaption(25) + #32 + ETypeToStr(Event.eType);
  lblCircleTimeType.Caption := lsMain.GetCaption(26) + #32 + ECTTypeToStr
    (Event.eCircleTimeType);
  lblCircleDays.Caption := lsMain.GetCaption(27) + #32 + ECDaysToStr
    (Event.eCircleDays);
  lblCircleMonthDays.Caption := lsMain.GetCaption(28) + #32 + ECMDaysToStr
    (Event.eCircleMonthDays);
  lblStatus.Caption := lsMain.GetCaption(32) + #32 + EDoneToStr(Event.eDone);

  if Event.eStartPrgm then
    lblPrgm.Caption := lsMain.GetCaption(55) + #32 + ExtractFileName
      (Event.ePrgmPath)
  else
    lblPrgm.Caption := lsMain.GetCaption(55) + #32 + '|';
  if not Event.eDone then // активация/деактивация кнопки
    btnDone.Enabled := true
  else
    btnDone.Enabled := false;
  qmTask.Text := Event.eMsg;
end;

{ TfmMain.ShowEvents

  Показ задач }
procedure TfmMain.ShowEvents(var Tree: TTreeView; var Events: TEventList);
var
  i, n: Integer;
  eAdded: Boolean;
begin
  if not EventList.Loaded then
    Exit;
  Tree.Items.BeginUpdate;
  for i := 0 to Events.Count - 1 do
  begin
    eAdded := false;
    for n := 0 to Tree.Items.Count - 1 do
    begin // если это группа, то пробуем сюда прицепить задачу
      if (Tree.Items[n].Data <> nil) and
        (TObject(Tree.Items[n].Data) is TGroupItem) then
        if TGroupItem(Tree.Items[n].Data).Id = Events[i].eGroup then
        begin
          Tree.Items.AddChildObject(Tree.Items[n], Events[i].eHeader,
            Events[i]);
          eAdded := true;
        end;
    end; // если никуда не прицепили, цепляем в конец
    if not eAdded then
    begin
      Tree.Items.AddObject(nil, Events[i].eHeader, Events[i]);
      Events[i].eGroup := 0;
    end;
  end;
  Tree.Items.EndUpdate;
end;

{ TfmMain.ShowGroups

  Показ групп }
procedure TfmMain.ShowGroups(var Tree: TTreeView; var Groups: TGroupList);
var
  i, n, ggI, max: Integer;
  inList: array of TPoint;
begin
  if not Groups.Loaded or (Groups.Count = 0) then
    Exit; // если не загружен список, выходим...
  SetLength(inList, 0); // инициализипуем на поздний список
  Tree.Items.BeginUpdate;
  i := 0;
  max := Groups.Count - 1;
  repeat
    if Groups.Items[i].ParentId = 0 then // проверяем есть ли родительская группа
    begin
      Tree.Items.AddObject(nil, Groups.Items[i].Name, Groups.Items[i]);
      // если нет, добавляем в корень
      if length(inList) > 0 then // проверяем сохраненный список, возможно появился родитель для них
        for n := 0 to High(inList) do
        begin
          ggI := GetGroupIndex(inList[n].Y, Tree);
          if ggI <> -1 then // если родитель нашелся, пришло время добавить к нему группу
          begin
            Tree.Items.AddChildObject(Tree.Items[ggI], Groups.Items[i].Name,
              Groups.Items[Groups.GetGroupIndex(inList[n].X)]);
            inList[n] := inList[ High(inList)];
            // удаляем из списка, ибо добавили уже
            SetLength(inList, High(inList));
          end;
        end;
    end
    else
    begin // если группа дочерняя, проверяем есть ли уже родитель
      ggI := GetGroupIndex(Groups.Items[i].ParentId, Tree);
      if ggI = -1 then
      begin // родителя нет, надо занести группу в список, возможно родитель еще появится
        SetLength(inList, length(inList) + 1);
        inList[ High(inList)].X := Groups.Items[i].Id;
        inList[ High(inList)].Y := Groups.Items[i].ParentId;
      end
      else
      begin // роитель нашелся, добавляем группу как дочернюю
        Tree.Items.AddChildObject(Tree.Items[ggI], Groups.Items[i].Name,
          Groups.Items[i]);
      end;
    end;
    LastGroupIndex := i;
    inc(i);
  until i > max;
  if length(inList) > 0 then // если в спике еще кто-то остался, бросаем его в корень
    for n := 0 to length(inList) - 1 do
    begin // такое думаю может случится только при ручной правке, но мы справимся =)
      Tree.Items.AddObject(nil, Groups.Items[Groups.GetGroupIndex(inList[n].X)]
          .Name, Groups.Items[Groups.GetGroupIndex(inList[n].X)]);
      // Groups.Items[Groups.GetGroupIndex(inList[n].X)].ParentId := 0;
      // убираем родителя, его все равно нет -отменено
      inList[n] := inList[ High(inList)];
      SetLength(inList, High(inList));
    end;
  Tree.Items.EndUpdate;
end;

{ TfmMain.ShowNextEvents

  Отображение списка со следующими задачами (используется кастомная сортировка) }
procedure TfmMain.ShowNextEvents(var Events: TEventList);
var
  i: Integer;
begin
  lbNext.Clear;
  Events.SortByTimeMinFirst; // Сортировка (ближайшие вверху)
  for i := 0 to Events.Count - 1 do
  begin
    lbNext.Items.AddObject(datetimetostr(Events.Items[i].eTime)
        + ' - ' + Events.Items[i].eHeader, Events.Items[i]);
  end;
end;

{ TfmMain.ShowTaskPanel

  Показ панели с информацией про задачу }
procedure TfmMain.ShowTaskPanel;
var
  i: Integer;
begin
  for i := 0 to pnlTask.ControlCount - 1 do
  begin
    pnlTask.Controls[i].Visible := not pnlTask.Controls[i].Visible;
    TaskPanelVisible := pnlTask.Controls[i].Visible;
  end;
  ostTask.Align := alCustom;
  ostTask.Align := alBottom;
end;

{ TfmMain.tiTrayClick

  Клик по трею (скрываем/раскрываем приложение если просто свернуть) }
procedure TfmMain.tiTrayClick(Sender: TObject);
begin
  inTray := not inTray;
  case inTray of
    true:
      begin
        fmMain.Hide;
      end;
    false:
      begin
        fmMain.Show;
        if IsIconic(Application.Handle) then
          // этот чувак нам это сказал, спасибо ему
          Application.Restore;
        Application.BringToFront;
      end;
  end;
end;

{ TfmMain.tvListClick

  При клике выбираеться задачи или элемент группы }
procedure TfmMain.tvListClick(Sender: TObject);
begin
  if (tvList.Selected <> nil) and (TObject(tvList.Selected.Data) is TEvent) then
  begin
    EventSelected := true;
    GroupSelected := false;
    SelectedEvent := TEvent(tvList.Selected.Data);
    ShowEvent(SelectedEvent);
  end
  else if (tvList.Selected <> nil) and (TObject(tvList.Selected.Data)
      is TGroupItem) then
  begin
    GroupSelected := true;
    EventSelected := false;
    SelectedGroup := TGroupItem(tvList.Selected.Data);
    // ShowMessage(BoolToStr(SelectedGroup.Expanded));
    // ShowMessage(BoolToStr(tvList.Selected.Expanded));
    if TaskPanelVisible then
      ShowTaskPanel;
  end;
end;

{ TfmMain.tvListCollapsing

  При свертывании группы, запоминаем состояние }
procedure TfmMain.tvListCollapsing(Sender: TObject; Node: TTreeNode;
  var AllowCollapse: Boolean);
begin
  if (Node.Data <> nil) and (TObject(Node.Data) is TGroupItem) then
    TGroupItem(Node.Data).Expanded := false;
end;

{ TfmMain.tvListCustomDrawItem

  Кастомная отрисовка элементов (взято с офф. примера) }
procedure TfmMain.tvListCustomDrawItem(Sender: TCustomTreeView;
  Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  NodeRect: TRect;
  aIntegral: Integer;
begin
  DefaultDraw := true;
  with tvList.Canvas do
  begin
    // Кастомная отрисовка - не используется, баг при прокрутке (не обновляется)
    if not DefaultDraw then
    begin
      if (Node.Data <> nil) and (TObject(Node.Data) is TEvent) then
      begin
        Font.Style := Font.Style + [fsItalic];
        if TEvent(Node.Data).eDone = false then
        begin
          Font.Color := clRed;
          Font.Style := Font.Style + [fsUnderline]
        end
        else
        begin
          Font.Color := clBlack;
          Font.Style := Font.Style - [fsUnderline];
        end;
      end
      else if (Node.Data <> nil) and (TObject(Node.Data) is TGroupItem) then
      begin
        Font.Assign(TGroupItem(Node.Data).GetGroupFont);
        aIntegral := Font.Size div tvList.Font.Size;
        SetNodeHeight(Node, aIntegral); // Установка высоты элемента
      end;
      if cdsSelected in State then
      begin
        Brush.Color := $00FFD2A6;
        if (Node.Data <> nil) and (TObject(Node.Data) is TGroupItem) then
        begin
          Font.Assign(TGroupItem(Node.Data).GetGroupFont);
          aIntegral := Font.Size div tvList.Font.Size;
          SetNodeHeight(Node, aIntegral); // Установка высоты элемента
        end
        else
        begin
          Font.Assign(tvList.Font);
        end;
        NodeRect := Node.DisplayRect(false);
        FillRect(NodeRect);
      end;
      NodeRect := Node.DisplayRect(false);
      Brush.Style := bsClear;
      NodeRect.Left := NodeRect.Left + (Node.Level * tvList.Indent);
      DrawButton(NodeRect, Node);
      NodeRect.Left := NodeRect.Left + tvList.Indent + 7;
      DrawImage(NodeRect, Node.ImageIndex);
      NodeRect.Left := NodeRect.Left + imlMain.Width;
      TextOut(NodeRect.Left, NodeRect.Top, Node.Text);
    end
    else
    // Отрисовка стандартными средствами
    begin
      if not(cdsSelected in State) then
      begin
        if (Node.Data <> nil) and (TObject(Node.Data) is TEvent) then
        begin
          Font.Style := Font.Style + [fsItalic];
          if TEvent(Node.Data).eDone = false then
          begin
            Font.Color := clRed;
            Font.Style := Font.Style + [fsUnderline]
          end
          else
          begin
            Font.Color := clBlack;
            Font.Style := Font.Style - [fsUnderline];
          end;
        end
        else if (Node.Data <> nil) and (TObject(Node.Data) is TGroupItem) then
        begin
          Font.Assign(TGroupItem(Node.Data).GetGroupFont);
          aIntegral := Font.Size div tvList.Font.Size;
          SetNodeHeight(Node, aIntegral); // Установка высоты элемента
        end;
      end
      else if cdsSelected in State then
        Brush.Color := $00FFD2A6;
    end;
  end;
end;

{ TfmMain.tvListExpanded

  Перерисуем при раскрытии }
procedure TfmMain.tvListExpanded(Sender: TObject; Node: TTreeNode);
begin
  tvList.Repaint;
end;

{ TfmMain.tvListExpanding

  При раскрытии группы, запоминаем состояние }
procedure TfmMain.tvListExpanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
begin
  if (Node.Data <> nil) and (TObject(Node.Data) is TGroupItem) then
    TGroupItem(Node.Data).Expanded := true;
end;

{ TfmMain.tvListGetImageIndex

  В зависимости от типа сменяем картинку тоже }
procedure TfmMain.tvListGetImageIndex(Sender: TObject; Node: TTreeNode);
begin
  if Node.HasChildren then
    if Node.Expanded then
      Node.ImageIndex := 1
    else
      Node.ImageIndex := 0
    else if TObject(Node.Data) is TGroupItem then
      Node.ImageIndex := 0
    else
      Node.ImageIndex := 2;
end;

{ TfmMain.tvListGetSelectedIndex

  Индекс он и в Африке индекс }
procedure TfmMain.tvListGetSelectedIndex(Sender: TObject; Node: TTreeNode);
begin
  Node.SelectedIndex := Node.ImageIndex;
end;

{ TfmMain.tvListOnExit

  Убираем выделенные элементы если потерли фокус
  Не используется, баги при выходе из программы }
procedure TfmMain.tvListOnExit(Sender: TObject);
begin
  DeselectItems;
end;

{ TfmMain.UpdateLang

  Обновлние языка
  (автоматическое через контролы невозможно, ибо текст не только в контролах) }
procedure TfmMain.UpdateLang;
var
  i: Integer;
  mItem: TMenuItem;
begin
  if not fmMain.lsMain.LangLoaded then
    Exit;
  lblTime.Caption := lsMain.GetCaption(24);
  lblReminder.Caption := lsMain.GetCaption(54);
  lblType.Caption := lsMain.GetCaption(25);
  lblCircleTimeType.Caption := lsMain.GetCaption(26);
  lblCircleDays.Caption := lsMain.GetCaption(27);
  lblCircleMonthDays.Caption := lsMain.GetCaption(28);
  lblPrgm.Caption := lsMain.GetCaption(55);
  lblStatus.Caption := lsMain.GetCaption(32);
  btnChange.Caption := lsMain.GetCaption(17);
  btnDone.Caption := lsMain.GetCaption(16);
  tsMain.Caption := lsMain.GetCaption(58);
  tsNext.Caption := lsMain.GetCaption(58, 1);
  miFile.Caption := lsMain.GetCaption(59);
  miExit.Caption := lsMain.GetCaption(60);
  actExit.Caption := lsMain.GetCaption(60);
  miHelp.Caption := lsMain.GetCaption(61);
  actInfo.Caption := lsMain.GetCaption(62);
  miNewEvent.Caption := lsMain.GetCaption(63);
  miEditEvent.Caption := lsMain.GetCaption(63, 1);
  miDeleteEvent.Caption := lsMain.GetCaption(63, 2);
  miNewGroup.Caption := lsMain.GetCaption(63, 3);
  miEditGroup.Caption := lsMain.GetCaption(63, 4);
  miDeleteGroup.Caption := lsMain.GetCaption(63, 6);
  miAutorun.Caption := lsMain.GetCaption(64);
  miLanguage.Caption := lsMain.GetCaption(64, 1);
  miRunInTray.Caption := lsMain.GetCaption(67);
  // Создание списка языков для выбора в трее
  miLanguage.Clear;
  for i := 0 to LangList.Count - 1 do
  begin
    mItem := TMenuItem.Create(miLanguage);
    mItem.Name := 'mi' + LangList.Strings[i];
    mItem.Caption := LangList.Strings[i];
    mItem.OnClick := miLangListItemClick;
    miLanguage.Add(mItem);
  end;
end;

{ TfmMain.UpdateList

  Обновлнеие списка }
procedure TfmMain.UpdateList;
begin
  if tvList.Items.Count > 0 then
    tvList.Items.Clear;
  ShowGroups(TTreeView(tvList), GroupList);
  ShowEvents(TTreeView(tvList), EventList);
  ShowNextEvents(EventList);
  ExpandGroups(TTreeView(tvList));
  // tvList.FullExpand;
end;

{ TfmMain.WMHotKey

  Обработка нажатия горячей клавиши для сворачивания }
procedure TfmMain.WMHotKey(var aMsg: TWMHotKey);
begin
  if aMsg.HotKey = FHotkey then
    tiTray.OnClick(Self);
end;

{ TstrList }

{ TScrTreeView.WMHScroll

  При скроле обновимся, не используется... }
{ procedure TScrTreeView.WMHScroll(var Message: TWMHScroll);
  begin
  inherited;
  Resize;
  end; }

end.
