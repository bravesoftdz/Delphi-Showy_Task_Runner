{
  Showy Task Runner v.0.1 alfa
  @author: scribe
  @date: 15.09.2015
  Delphi 2010

  Description: ��������� ��� ���������� ��������� �� ������ (�� ���� ���������)

  �������� ����
}
unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DateUtils, Menus, ComCtrls, ExtCtrls, Buttons, CommCtrl,
  IniFiles, AppEvnts, ImgList, ActnList,
  uTR, uTask, uEvent, uAutorun, uLangStorage;

type

  { TScrTreeView

    �������� ��������� ������� ������ (� �������� ��� �������, ��... ����� ������������=) ) }
  TScrTreeView = class(TTreeView)
  private
    procedure WMHScroll(var Message: TWMHScroll);
    message WM_HSCROLL;
    // procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
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
    miChangeGFont: TMenuItem;
    fdGroup: TFontDialog;
    tiTray: TTrayIcon;
    miInfo: TMenuItem;
    ppAuto: TPopupMenu;
    miAutorun: TMenuItem;
    lblPrgm: TLabel;
    lbNext: TListBox;
    miEditGroup: TMenuItem;
    lsMain: TLangStorage; // ��������� ��� ���������� ������
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
    procedure miChangeGFontClick(Sender: TObject);
    procedure btnChangeClick(Sender: TObject);
    procedure tiTrayClick(Sender: TObject);
    procedure miAutorunClick(Sender: TObject);
    procedure lbNextDrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
      State: TOwnerDrawState);
    procedure miEditGroupClick(Sender: TObject);
    procedure miInfoClick(Sender: TObject);
    procedure miLangListItemClick(Sender: TObject);
    procedure tvListGetImageIndex(Sender: TObject; Node: TTreeNode);
    procedure tvListGetSelectedIndex(Sender: TObject; Node: TTreeNode);
    procedure tvListExpanded(Sender: TObject; Node: TTreeNode);
    procedure tvListOnExit(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure miHelpClick(Sender: TObject);
    procedure actInfoExecute(Sender: TObject);
    procedure miRunInTrayClick(Sender: TObject);
    procedure ppAutoPopup(Sender: TObject);
    procedure lbNextClick(Sender: TObject);
  private
    TaskPanelVisible: Boolean; // ��������� ���������� � �������
    inTray: Boolean; // ��������� ���������� � ����?
    LastGroupIndex: Integer; // ��������� ������ ������
    EventSelected: Boolean; // ���� ������ �������
    GroupSelected: Boolean; // ���� ������ ������
    SelectedEvent: TEvent; // �������� �������
    SelectedGroup: TGroupItem; // �������� ������
    CurrentLanguage: string; // ������� ����
    function GetGroupIndex(const gId: Integer; var Tree: TTreeView): Integer;
    procedure ShowGroups(var Tree: TTreeView; var Groups: TGroupList);
    procedure ShowEvents(var Tree: TTreeView; var Events: TEventList);
    procedure ShowEvent(const Event: TEvent);
    procedure ShowNextEvents(var Events: TEventList);
    procedure ShowTaskPanel;
    procedure SaveFormPos(const FileName: TFileName = 'app_pos.data');
    procedure LoadFormPos(const FileName: TFileName = 'app_pos.data');
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
  public
    GroupList: TGroupList; // ������ �����
    EventList: TEventList; // ������ �������
    LangList: TStringList; // ������ ������
    tvList: TScrTreeView; // ������ ��� ����������� ����� � ���
    procedure UpdateList; // ���������� ������ � �������� � ���������
    procedure UpdateLang; // ���������� �������� �����
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

procedure TfmMain.actExitExecute(Sender: TObject);
begin
  fmMain.Close;
end;

procedure TfmMain.actInfoExecute(Sender: TObject);
begin
  ShowMessage('by scribe, 2015, Kyiv' + #13#10 + 'e-mail: _scribe_@ukr.net');
end;

// ��������� ������
procedure TfmMain.btnChangeClick(Sender: TObject);
begin
  miEditEvent.Click;
end;

// ������ ������ ����������
procedure TfmMain.btnDoneClick(Sender: TObject);
begin
  if EventSelected then
    SelectedEvent.eDone := true;
end;

{ TfmMain.CreateTVList

  ������� ������� ��� ����������� ����� � ����� }
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
  // tvList.DoubleBuffered:= true;
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
  // tvList.OnExit := tvListOnExit;
  tvList.Show;
end;

{ TfmMain.DeselectItems

  ������� ��������� ������ �/��� ������ }
procedure TfmMain.DeselectItems;
begin
  GroupSelected := false;
  EventSelected := false;
  SelectedGroup := nil;
  SelectedEvent := nil;
  UpdateList;
end;

{ TfmMain.DrawButton

  ��������� ����������� ��������� (����������� � �������) ��� TTreeView }
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
    // ������� � ��������, ������� ���� �� ���������, ����� � ���������� �� ��������
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
    // ������� ����� (���������, �� ������)
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
    // ������ ����� (���������, �� ������)
    if (((Node.GetNextVisible <> nil) and
          (Node.GetNextVisible.Level = Node.Level)) or
        (Node.GetNextSibling <> nil)) and not Node.HasChildren then
    begin
      PenPos := Point(cx, cy);
      LineTo(cx, ARect.Bottom);
    end;
    // ����� ������ ����������� (��� ���, � ���� ���� ����������)
    if Node.HasChildren then
    begin
      Pen.Color := clGray;
      Pen.Style := psSolid;
      Rectangle(cx - 5, cy - 5, cx + 6, cy + 6); // ��� ���������
      Pen.Color := clBlack;
      // �������������� �����
      PenPos := Point(cx - 5 + 2, cy);
      LineTo(cx + 5 - 1, cy);
      // ������ ������������ ���� �������
      if not Node.Expanded then
      begin
        PenPos := Point(cx, cy - 3);
        LineTo(cx, cy + 4);
      end;
    end;
    // ����������� ������� � �������� ��������
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

  ��������� �������� � ����� TTreeView (����� � ���. ��������) }
procedure TfmMain.DrawImage(NodeRect: TRect; ImageIndex: Integer);
var
  cy: Integer;
begin
  cy := NodeRect.Top + (NodeRect.Bottom - NodeRect.Top) div 2;
  // ������ �������� � ������ ����
  imlMain.Draw(tvList.Canvas, NodeRect.Left, cy - tvList.Images.Height div 2,
    ImageIndex, true);
end;

{ TfmMain.FormClose

  �������� ����� }
procedure TfmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  EventList.Stop; // ������������� �����
  EventList.SaveEvents; // ��������� ������ �����
  EventList.Free; // �����������
  GroupList.SaveGroups; // ��������� ������ �����
  GroupList.Free; // �����������
  LangList.Free; // ����������� ������ � ������
  SaveFormPos; // ��������� ��������� �����
  tvList.Free;
end;

{ TfmMain.FormCreate

  ������������� ����� ��� �������� }
procedure TfmMain.FormCreate(Sender: TObject);
begin
  CreateTVList; // ������� ��� ��������� TTreeView
  LoadFormPos(); // ��������� ��������� �����

  LangList := TStringList.Create; // ������� ������ ��� ������ ������
  lsMain.FileName := ExtractFilePath(ParamStr(0))
    + 'LS_' + CurrentLanguage + '.ini';
  lsMain.LoadLanguage; // ��������� ���� �� ��������
  lsMain.GetLanguageList(LangList); // ������ ������ ��������� ������
  UpdateLang; // ��������� ����

  stsBar.Panels.Add; // ��������� ������
  stsBar.Panels[0].Width := 150; // --//--
  stsBar.Font.Style := [fsBold]; // --//--

  GroupList := TGroupList.Create; // ������� ������ ��� ������ �����
  GroupList.LoadGroups; // ��������� �� �����
  GroupList.AutoSave := true; // ��������� ��������������

  EventList := TEventList.Create; // ������� ������ ��� ������ �����
  EventList.LoadEvents; // ��������� �� �����
  EventList.AutoSave := true; // ��������� ��������������
  UpdateList; // ��������� ������
  ShowTaskPanel; // ���������� ������

  Application.OnMinimize := tiTray.OnClick; // ��� ����������� � ��� ���� ���� ���������
end;

{ TfmMain.GetGroupIndex

  ������ ������ ������ � TTreeView �� ���� }
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
      if TGroupItem(Tree.Items[i].Data).gId = gId then
        Result := i;
  end;
end;

function TfmMain.GetNextItemDate(const aValue: string): TDateTime;
var
  s: string;
begin
  s := copy(aValue, 1, pos('-', aValue));
  Result := StrToDateTime(s);
end;

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

  ����������� ����� ��� ������� "���������" }
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

// �������� �������� �����
procedure TfmMain.LoadFormPos(const FileName: TFileName);
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

// ��������� ��������� � ����������
procedure TfmMain.miAutorunClick(Sender: TObject);
begin
  miAutorun.Checked := not miAutorun.Checked;
  SetAutoRun(miAutorun.Checked);
end;

// ��������� ������ � ������
procedure TfmMain.miChangeGFontClick(Sender: TObject);
begin
  try
    if GroupSelected and not EventSelected then
      if fdGroup.Execute then
        GroupList.Items[GroupList.GetGroupIndex(SelectedGroup.gId)].gFont.Assign
          (fdGroup.Font);
  finally
    GroupList.SaveGroups;
    DeselectItems;
  end;
end;

// �������� ������
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

// �������� ������
procedure TfmMain.miDeleteGroupClick(Sender: TObject);
begin
  try
    if GroupSelected then
      GroupList.DeleteGroup(SelectedGroup.gId);
  finally
    DeselectItems;
  end;
end;

// �������������� ������
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

// �������������� ������
procedure TfmMain.miEditGroupClick(Sender: TObject);
var
  gName: string;
begin
  if GroupSelected then
    try
      gName := SelectedGroup.gName;
      if InputQuery(lsMain.GetCaption(4), lsMain.GetCaption(9), gName) then
        SelectedGroup.gName := gName;
    finally
      DeselectItems;
    end;
end;

procedure TfmMain.miHelpClick(Sender: TObject);
begin

end;

// ��������
procedure TfmMain.miInfoClick(Sender: TObject);
begin
  ShowMessage('by scribe, 2015, Kyiv' + #13#10 + 'e-mail: _scribe_@ukr.net');
end;

// ���� �� ���� � �������
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

// ����� ������
procedure TfmMain.miNewEventClick(Sender: TObject);
begin
  try
    if EventSelected and not GroupSelected then
      if ShowEventCreationDialog(SelectedEvent.eGroup, EventList, GroupList)
        then
        ShowMessage(lsMain.GetCaption(15, 0));
    if GroupSelected and not EventSelected then
      if ShowEventCreationDialog(SelectedGroup.gId, EventList, GroupList) then
        ShowMessage(lsMain.GetCaption(15, 0));
    if not GroupSelected and not EventSelected then
      if ShowEventCreationDialog(0, EventList, GroupList) then
        ShowMessage(lsMain.GetCaption(15, 0));
  finally
    DeselectItems;
  end;
end;

// ����� ������
procedure TfmMain.miNewGroupClick(Sender: TObject);
var
  gName: string;
begin
  try
    if GroupSelected and not EventSelected then
      if InputQuery(lsMain.GetCaption(1), lsMain.GetCaption(5), gName) then
        GroupList.AddGroup(gName, SelectedGroup.gId);
    if EventSelected and not GroupSelected then
      if InputQuery(lsMain.GetCaption(1), lsMain.GetCaption(5), gName) then
        GroupList.AddGroup(gName, SelectedEvent.eGroup);
    if not GroupSelected and not EventSelected then
      if InputQuery(lsMain.GetCaption(1), lsMain.GetCaption(5), gName) then
        GroupList.AddGroup(gName);
  finally
    DeselectItems;
  end;
end;

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

procedure TfmMain.ppAutoPopup(Sender: TObject);
begin
  miRestore.Visible := inTray;
end;

{ TfmMain.ppListPopup

  ����� ���� ������ ���������� }
procedure TfmMain.ppListPopup(Sender: TObject);
begin
  if EventSelected and not GroupSelected then
  begin
    miNewGroup.Visible := true;
    miEditGroup.Visible := false;
    miChangeGFont.Visible := false;
    miDeleteGroup.Visible := false;
    miNewEvent.Visible := true;
    miEditEvent.Visible := true;
    miDeleteEvent.Visible := true;
  end
  else if GroupSelected and not EventSelected then
  begin
    miNewGroup.Visible := true;
    miEditGroup.Visible := true;
    miChangeGFont.Visible := true;
    miDeleteGroup.Visible := true;
    miNewEvent.Visible := true;
    miEditEvent.Visible := false;
    miDeleteEvent.Visible := false;
  end
  else
  begin
    miNewGroup.Visible := true;
    miEditGroup.Visible := false;
    miChangeGFont.Visible := false;
    miDeleteGroup.Visible := false;
    miNewEvent.Visible := true;
    miEditEvent.Visible := false;
    miDeleteEvent.Visible := false;
  end;
end;

{ TfmMain.SaveFormPos

  ���������� �������� }
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

// ��������� ��� ��������� ��������� � ����������
procedure TfmMain.SetAutoRun(const Auto: Boolean);
begin
  Autorun(Auto, '', Application.ExeName);
end;

// ��������� ��������� ������ ���� (������ ��������� ����� ������ ����, �.�. � 2 ���� 3,4... ������ ��������)
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

// ����������� ������
procedure TfmMain.ShowEvent(const Event: TEvent);
begin
  if not TaskPanelVisible then // ����� ���������, ���� �������
    ShowTaskPanel;
  lblHeader.Caption := Event.eHeader;
  lblTime.Caption := lsMain.GetCaption(24) + #32 + datetimetostr(Event.eTime);
  lblReminder.Caption := lsMain.GetCaption(54) + #32 + datetimetostr
    (Event.eReminder);

  if Event.eReminder > Event.eTime then // �����������, ��� ������
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
  if not Event.eDone then // ���������/����������� ������
    btnDone.Enabled := true
  else
    btnDone.Enabled := false;
  qmTask.Text := Event.eMsg;
end;

// ����� �����
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
    begin // ���� ��� ������, �� ������� ���� ��������� ������
      if (Tree.Items[n].Data <> nil) and
        (TObject(Tree.Items[n].Data) is TGroupItem) then
        if TGroupItem(Tree.Items[n].Data).gId = Events[i].eGroup then
        begin
          Tree.Items.AddChildObject(Tree.Items[n], Events[i].eHeader,
            Events[i]);
          eAdded := true;
        end;
    end; // ���� ������ �� ���������, ������� � �����
    if not eAdded then
    begin
      Tree.Items.AddObject(nil, Events[i].eHeader, Events[i]);
      Events[i].eGroup := 0;
    end;
  end;
  Tree.Items.EndUpdate;
end;

// ����� �����
procedure TfmMain.ShowGroups(var Tree: TTreeView; var Groups: TGroupList);
var
  i, n, ggI, max: Integer;
  inList: array of TPoint;
begin
  if not Groups.Loaded or (Groups.Count = 0) then
    Exit; // ���� �� �������� ������, �������...
  SetLength(inList, 0); // �������������� �� ������� ������
  Tree.Items.BeginUpdate;
  i := 0;
  max := Groups.Count - 1;
  repeat
    if Groups.Items[i].gParentId = 0 then // ��������� ���� �� ������������ ������
    begin
      Tree.Items.AddObject(nil, Groups.Items[i].gName, Groups.Items[i]);
      // ���� ���, ��������� � ������
      if length(inList) > 0 then // ��������� ����������� ������, �������� �������� �������� ��� ���
        for n := 0 to High(inList) do
        begin
          ggI := GetGroupIndex(inList[n].Y, Tree);
          if ggI <> -1 then // ���� �������� �������, ������ ����� �������� � ���� ������
          begin
            Tree.Items.AddChildObject(Tree.Items[ggI], Groups.Items[i].gName,
              Groups.Items[Groups.GetGroupIndex(inList[n].X)]);
            inList[n] := inList[ High(inList)];
            // ������� �� ������, ��� �������� ���
            SetLength(inList, High(inList));
          end;
        end;
    end
    else
    begin // ���� ������ ��������, ��������� ���� �� ��� ��������
      ggI := GetGroupIndex(Groups.Items[i].gParentId, Tree);
      if ggI = -1 then
      begin // �������� ���, ���� ������� ������ � ������, �������� �������� ��� ��������
        SetLength(inList, length(inList) + 1);
        inList[ High(inList)].X := Groups.Items[i].gId;
        inList[ High(inList)].Y := Groups.Items[i].gParentId;
      end
      else
      begin // ������� �������, ��������� ������ ��� ��������
        Tree.Items.AddChildObject(Tree.Items[ggI], Groups.Items[i].gName,
          Groups.Items[i]);
      end;
    end;
    LastGroupIndex := i;
    inc(i);
  until i > max;
  if length(inList) > 0 then // ���� � ����� ��� ���-�� �������, ������� ��� � ������
    for n := 0 to length(inList) - 1 do
    begin // ����� ����� ����� �������� ������ ��� ������ ������, �� �� ��������� =)
      Tree.Items.AddObject(nil, Groups.Items[Groups.GetGroupIndex(inList[n].X)]
          .gName, Groups.Items[Groups.GetGroupIndex(inList[n].X)]);
      Groups.Items[Groups.GetGroupIndex(inList[n].X)].gParentId := 0;
      // ������� ��������, ��� ��� ����� ���
      inList[n] := inList[ High(inList)];
      SetLength(inList, High(inList));
    end;
  Tree.Items.EndUpdate;
end;

// ����������� ������ �� ���������� �������� (������������ ��������� ����������)
procedure TfmMain.ShowNextEvents(var Events: TEventList);
var
  i: Integer;
begin
  lbNext.Clear;
  Events.SortByTimeMinFirst; // ���������� (��������� ������)
  for i := 0 to Events.Count - 1 do
  begin
    lbNext.Items.AddObject(datetimetostr(Events.Items[i].eTime)
        + ' - ' + Events.Items[i].eHeader, Events.Items[i]);
  end;
end;

// ����� ������ � ����������� ��� ������
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

// ���� �� ���� (��������/���������� ���������� ���� ������ ��������)
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
          // ���� ����� ��� ��� ������, ������� ���
          Application.Restore;
        Application.BringToFront;
      end;
  end;
end;

// ��� ����� ����������� ������ ��� ������� ������
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
    fdGroup.Font := SelectedGroup.gFont;
    if TaskPanelVisible then
      ShowTaskPanel;
  end;
end;

{ TfmMain.tvListCustomDrawItem

  ��������� ��������� ��������� (����� � ���. �������) }
procedure TfmMain.tvListCustomDrawItem(Sender: TCustomTreeView;
  Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  NodeRect: TRect;
  aIntegral: Integer;
begin
  DefaultDraw := true;
  with tvList.Canvas do
  begin
    // ��������� ��������� - �� ������������, ��� ��� ��������� (�� �����������)
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
        Font.Assign(TGroupItem(Node.Data).gFont);
        aIntegral := TGroupItem(Node.Data).gFont.Size div tvList.Font.Size;
        SetNodeHeight(Node, aIntegral); // ��������� ������ ��������
      end;
      if cdsSelected in State then
      begin
        Brush.Color := $00FFD2A6;
        if (Node.Data <> nil) and (TObject(Node.Data) is TGroupItem) then
        begin
          Font.Assign(TGroupItem(Node.Data).gFont);
          aIntegral := TGroupItem(Node.Data).gFont.Size div tvList.Font.Size;
          SetNodeHeight(Node, aIntegral); // ��������� ������ ��������
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
    // ��������� ������������ ����������
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
          Font.Assign(TGroupItem(Node.Data).gFont);
          aIntegral := TGroupItem(Node.Data).gFont.Size div tvList.Font.Size;
          SetNodeHeight(Node, aIntegral); // ��������� ������ ��������
        end;
      end
      else if cdsSelected in State then
        Brush.Color := $00FFD2A6;
    end;
  end;
end;

{ TfmMain.tvListExpanded

  ���������� ��� ��������� }
procedure TfmMain.tvListExpanded(Sender: TObject; Node: TTreeNode);
begin
  tvList.Repaint;
end;

{ TfmMain.tvListGetImageIndex

  � ����������� �� ���� ������� �������� ���� }
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

  ������ �� � � ������ ������ }
procedure TfmMain.tvListGetSelectedIndex(Sender: TObject; Node: TTreeNode);
begin
  Node.SelectedIndex := Node.ImageIndex;
end;

{ TfmMain.tvListOnExit

  ������� ���������� �������� ���� ������� �����
  �� ������������, ���� ��� ������ �� ��������� }
procedure TfmMain.tvListOnExit(Sender: TObject);
begin
  DeselectItems;
end;

{ TfmMain.UpdateLang

  ��������� �����
  (�������������� ����� �������� ����������, ��� ����� �� ������ � ���������) }
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
  miChangeGFont.Caption := lsMain.GetCaption(63, 5);
  miDeleteGroup.Caption := lsMain.GetCaption(63, 6);
  miAutorun.Caption := lsMain.GetCaption(64);
  miLanguage.Caption := lsMain.GetCaption(64, 1);
  miRunInTray.Caption := lsMain.GetCaption(67);
  // �������� ������ ������ ��� ������ � ����
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

  ���������� ������ }
procedure TfmMain.UpdateList;
begin
  if tvList.Items.Count > 0 then
    tvList.Items.Clear;
  ShowGroups(TTreeView(tvList), GroupList);
  ShowEvents(TTreeView(tvList), EventList);
  ShowNextEvents(EventList);
  tvList.FullExpand;
end;

{ TstrList }

{ TstrList.WMHScroll

  ��� ������ ���������
  �� ������������... }
procedure TScrTreeView.WMHScroll(var Message: TWMHScroll);
begin
  { inherited;
    Resize; }
end;

end.
