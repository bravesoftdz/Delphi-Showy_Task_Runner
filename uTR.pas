{
  Showy Task Runner v.0.2 alfa
  @author: scribe
  @date: 15.09.2015
  Delphi 2010

  Description: ��������� ��� ���������� ��������� �� ������ (�� ���� ���������)

  ���� � �������� �������
}
unit uTR;

interface

uses
  Variants, Graphics, Generics.Defaults, Generics.Collections, Classes,
  IniFiles, Forms, DateUtils, ShellAPI;

type
  { TGroupItem

    ����� �������� ������ }
  TGroupItem = class
  private
    FId: integer;
    FName: string;
    FParentId: integer;
    FFont: TFont;
    FExpanded: boolean;
  public
    constructor Create(const aName: string; const aId, aParentId: integer;
      aFont: TFont; aExpanded: boolean = true);
    destructor Destroy; override;
    procedure SetGroupFont(aFont: TFont);
    procedure GetGroupFont(aFont: TFont);
    property Id: integer read FId;
    property Name: string read FName write FName;
    property ParentId: integer read FParentId write FParentId;
    property Expanded: boolean read FExpanded write FExpanded;
  end;

  { TGroupList

    ����� ������� ������ ����� }
  TGroupList = class(TObjectList<TGroupItem>)
  private
    FAutoSave: boolean;
    FFileName: string;
    FLoaded: boolean;
    FDefFont: TFont;
    function GetUnsedgId: integer;
    function GetGroupItem(const aId: integer): TGroupItem;
    function GroupExists(const aId: integer): boolean;
    class function SerializeFont(aFont: TFont; const aSep: char = chr(2))
      : string;
    class procedure UnSerializeFont(aFont: TFont; const strFont: string;
      const aSep: char = chr(2));
    procedure Add(Value: TGroupItem);
    procedure Delete(const Value: integer);
    function HasChild(const aId: integer): boolean;
  public
    constructor Create(const aFileName: string = '');
    destructor Destroy; override;
    function AddGroup(const aName: string; const aParentId: integer = 0)
      : integer;
    function GetGroupIndex(const aId: integer): integer;
    function GetMaxGroupId: integer;
    procedure SaveGroups(const aFileName: string = 'group_list.data');
    procedure LoadGroups(const aFileName: string = 'group_list.data');
    procedure DeleteGroup(const aId: integer);
    property AutoSave: boolean read FAutoSave write FAutoSave;
    property FileName: string read FFileName write FFileName;
    property Loaded: boolean read FLoaded;
    property MaxGroupId: integer read GetMaxGroupId;
  end;

  // ���� �������
  TEventType = (etNormal, etWarning); // ������� ��� ������ (������� � �����������)
  { ��� ������������ �������
    �ttSingle - ���� ���
    �ttDay - ������ ����
    �ttWeek - ������ ���� ������
    �ttMonth - ������ ���� � ������
    �ttYear - ������ ���� � ����
    cttFirstWDMonth - ������ ������� ���� ������
    cttLastWDMonth - ��������� ������� ���� ������
    }
  TCircleTimeType = (�ttSingle, �ttDay, �ttWeek, �ttMonth, cttFirstWDMonth,
    cttLastWDMonth);
  { TCircleDays = set of (cdMonday, cdTuesday, cdWednesday, cdThursday, cdFriday, cdSaturday, cdSunday);
    PCircleDays = ^TCircleDays;
    TCircleMDays = set of (d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15, d16, d17, d18, d19, d20, d21, d22, d23, d24, d25, d26, d27, d28, d29, d30, d31);
    PCircleMDays = ^TCircleMDays; }
  //
  TCircleArrDays = array [1 .. 7] of boolean;
  TCircleMArrDays = array [1 .. 31] of boolean;

  { TEvent

    ����� ������� ������� }
  TEvent = class
  private
    FId: integer; // ���� ������
    FType: TEventType;
    FTime: TDateTime;
    FCircleTimeType: TCircleTimeType;
    FCircleDays: TCircleArrDays;
    FCircleMonthDays: TCircleMArrDays;
    FReminder: TDateTime;
    FHeader: string;
    FMsg: String;
    FGroup: integer;
    FDone: boolean;
    FPrgmPath: string;
    FStartPrgm: boolean;
    FOnChangeEvent: TNotifyEvent;
    procedure SetEType(const Value: TEventType);
    procedure SetFCircleArrDays(const Value: TCircleArrDays);
    procedure SetFCircleMonthdays(const Value: TCircleMArrDays);
    procedure SetFCircleTimeType(const Value: TCircleTimeType);
    procedure SetFDone(const Value: boolean);
    procedure SetFGroup(const Value: integer);
    procedure SetFHeader(const Value: string);
    procedure SetFMasg(const Value: string);
    procedure SetFPrgmPath(const Value: string);
    procedure SetFReminder(const Value: TDateTime);
    procedure SetFStartPrgm(const Value: boolean);
    procedure SetFTime(const Value: TDateTime);
    procedure EventChange(Sender: TObject);
  public
    property eType: TEventType read FType write SetEType; // ��� �������
    property eTime: TDateTime read FTime write SetFTime;
    property eCircleTimeType: TCircleTimeType read FCircleTimeType write
      SetFCircleTimeType; // ��� ������������ ������� (������ ����, ������ ������ � �.�.)
    property eCircleDays: TCircleArrDays read FCircleDays write
      SetFCircleArrDays; // ��� ������
    property eCircleMonthDays: TCircleMArrDays read FCircleMonthDays write
      SetFCircleMonthdays; // ��� ������
    property eReminder: TDateTime read FReminder write SetFReminder; // "����������� �����", ���� �� �������� ��� ������� (� ��������) 0 - �� ����������
    property eHeader: string read FHeader write SetFHeader;
    property eMsg: string read FMsg write SetFMasg; // ��������� �������
    property eGroup: integer read FGroup write SetFGroup; // ������
    property eDone: boolean read FDone write SetFDone; // ���������?
    property ePrgmPath: string read FPrgmPath write SetFPrgmPath;
    property eStartPrgm: boolean read FStartPrgm write SetFStartPrgm;
    property Id: integer read FId;
  published
    property OnChange: TNotifyEvent read FOnChangeEvent write FOnChangeEvent;
  end;

  { TEventList

    ����� ������ ������� }
  TEventList = class(TObjectList<TEvent>)
  private
    FLoaded: boolean;
    FFileName: string;
    FAutoSave: boolean;
    procedure Add(Value: TEvent);
    procedure Delete(Value: integer);
    function GetUnusedeId: integer;
    class function CDToLine(var eCircleDays: TCircleArrDays;
      const sep: char = chr(3)): string;
    class function LineToCD(const Line: string; sep: char = chr(3))
      : TCircleArrDays;
    class function CMDToLine(var eCircleMDays: TCircleMArrDays;
      const sep: char = chr(3)): string;
    class function LineToCMD(const Line: string; sep: char = chr(3))
      : TCircleMArrDays;
  public
    constructor Create(const aFileName: string = '');
    destructor Destroy; override;
    procedure AddEvent(var Groups: TGroupList; const eHeader, eMsg: string;
      const eTime: TDateTime; const eCircleDays: TCircleArrDays;
      const eCircleMonthDays: TCircleMArrDays;
      const eType: TEventType = etNormal;
      const eCircleTimeType: TCircleTimeType = �ttSingle;
      const eGroup: integer = 0; const eDone: boolean = false;
      const eStartPrgm: boolean = false; const ePrgmPath: string = '');
    procedure DeleteEvent(const eId: integer);
    procedure SaveEvents;
    procedure LoadEvents;
    procedure SortByTimeMinFirst;
    procedure SortByTimeMaxFirst;
    property AutoSave: boolean read FAutoSave write FAutoSave;
    property Loaded: boolean read FLoaded;
    property FileName: string read FFileName write FFileName;
  end;

  { TEventThread

    ����� ������ ��� �������� ����������� ������� }
  TEventThread = class(TThread)
  private
    FTime: TDateTime;
    FEvent: TEvent;
    FList: Pointer;
    FInitiated: boolean;
    procedure DoSingle;
    procedure DoDay;
    procedure DoWeek;
    procedure DoMonth;
    procedure DoFirstWDMonth;
    procedure DoLastWDMonth;
    procedure UpdateWindow;
  protected
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy; override;
    procedure InitList(aList: Pointer);
  end;

function ETypeToStr(const eType: TEventType): string;
function ECTTypeToStr(const eCircleTimeType: TCircleTimeType): string;
function ECDaysToStr(const eCircleDays: TCircleArrDays): string;
function ECMDaysToStr(const eCircleMDays: TCircleMArrDays): string;
function EDoneToStr(const eDone: boolean): string;
procedure Explode(var a: array of string; Border, S: string);
function GetTimeOfWeek(const eTime: TDateTime; const CircleDays: TCircleArrDays)
  : TDateTime;
function GetTimeOfMonth(const eTime: TDateTime;
  const CircleMDays: TCircleMArrDays): TDateTime;
function GetTimeOfFWDMonth(const eTime: TDateTime): TDateTime;
function GetTimeOfLWDMonth(const eTime: TDateTime): TDateTime;
function LastPos(SubStr, S: string): integer;
procedure ODS(const S: string);

implementation

uses
  SysUtils, Dialogs, Windows,
  uMain, uTask, uSetConvert;

//
procedure EventChange(Sender: TObject);
begin
  if fmMain.EventList.AutoSave then
    fmMain.EventList.SaveEvents;
end;

// ��������� ��� �������
procedure ODS(const S: string);
begin
  OutputDebugString(PWideChar(S));
end;

// ��������� ������ �� ������ �����
procedure Explode(var a: array of string; Border, S: string);
var
  S2: string;
  i: integer;
begin
  i := 0;
  S2 := S + Border;
  repeat
    a[i] := Copy(S2, 0, Pos(Border, S2) - 1);
    Delete(S2, 1, Length(a[i] + Border));
    Inc(i);
  until S2 = '';
end;

// ���������� �� ������� (�� ������������ ���)
{ function SortByTime(item1, item2: TEvent): integer;
  begin
  if item1.eTime > item2.eTime then Result:= -1
  else if item1.eTime < item2.eTime then Result:= 1
  else Result:= 0;
  //if Result = 0 then
  //  Result:= CompareDateTime(item1.eTime, item2.eTime);
  end; }

{ GetTimeOfWeek

  ��������� ���� � ������������ � ������� ���� ������ }
function GetTimeOfWeek(const eTime: TDateTime; const CircleDays: TCircleArrDays)
  : TDateTime;
var
  arrDays: array [1 .. 7] of TDateTime;
  preDate: TDateTime;
  i, DoW: integer;
begin
  Result := eTime;
  if (eTime >= now) and (DayOfTheWeek(now) = DayOfTheWeek(eTime)) then
    Exit; // ���� ��������� ���� ������ �������, �� ���������
  DoW := DayOfTheWeek(date); // ������ ������� ���� ������ �� �������
  preDate := IncWeek(date); // ������ ���� � ��������� �������� � ����
  for i := 1 to 7 do
  begin
    arrDays[i] := 0; // ������ � ����
    if CircleDays[i] then // �������� ��������� ��������� ������������, ���� ���� ������
      if i <= DoW then // � ���� ���� ������ ������ ��� ����� ��� ������� ���� ������
        arrDays[i] := IncDay(eTime, i - DoW + 7) // ����� ��������� �� ��������� ������, � ��������� ������� ����
      else
        arrDays[i] := IncDay(eTime, i - DoW); // ����� ��� ������� ������, ������ ������� ������� ����
    if (preDate > arrDays[i] - eTime) and (arrDays[i] <> 0) and
      (arrDays[i] > eTime) then
      preDate := arrDays[i] - eTime;
  end;
  Result := preDate + eTime;
end;

{ GetTimeOfMonth

  ��������� ���� � ������������ � ������� ���� ������ }
function GetTimeOfMonth(const eTime: TDateTime;
  const CircleMDays: TCircleMArrDays): TDateTime;
var
  arrMDays: array [1 .. 31] of TDateTime;
  preDate, mDate: TDateTime;
  i, DoM: integer;
begin
  Result := eTime;
  DoM := DayOfTheMonth(now);
  preDate := IncMonth(now);
  for i := 1 to 31 do
  begin
    arrMDays[i] := 0;
    if CircleMDays[i] then
      if i <= DoM then
        arrMDays[i] := IncDay
          (eTime, i - DoM + MonthDays[IsLeapYear(YearOf(now))][MonthOf(now)])
      else
        arrMDays[i] := IncDay(eTime, i - DoM);
  end;
  mDate := preDate;
  for i := 1 to 31 do
  begin
    if arrMDays[i] <> 0 then
    begin
      preDate := arrMDays[i] - now;
      if (preDate > 0) and (mDate > preDate) then
      begin
        mDate := preDate;
        Result := arrMDays[i];
      end;
    end;
  end;
end;

{ GetTimeOfFWDMonth

  ������ ������ ������� ���� ������ (����������!) }
function GetTimeOfFWDMonth(const eTime: TDateTime): TDateTime;
var
  maxNDays, i, aYear, aMonth, aDay, aHour, aMin, aSec, aMSec: word;
begin
  if eTime > now then
  begin
    Result := eTime;
    Exit;
  end;
  Result := StartOfTheMonth(IncMonth(eTime));
  DecodeTime(eTime, aHour, aMin, aSec, aMSec);
  maxNDays := DaysInMonth(IncMonth(eTime));
  for i := 1 to maxNDays do
  begin
    if DayOfTheWeek(Result) <= 5 then
      break;
    IncDay(Result);
  end;
  DecodeDate(Result, aYear, aMonth, aDay);
  Result := EncodeDateTime(aYear, aMonth, aDay, aHour, aMin, aSec, aMSec);
end;

{ GetTimeOfLWDMonth

  ������ ��������� ������� ���� ������ }
function GetTimeOfLWDMonth(const eTime: TDateTime): TDateTime;
var
  maxNDays, i, aYear, aMonth, aDay, aHour, aMin, aSec, aMSec: word;
begin
  if eTime > now then
  begin
    Result := eTime;
    Exit;
  end;
  Result := EndOfTheMonth(IncMonth(eTime));
  DecodeTime(eTime, aHour, aMin, aSec, aMSec);
  maxNDays := DaysInMonth(IncMonth(eTime));
  for i := maxNDays downto 1 do
  begin
    if DayOfTheWeek(Result) <= 5 then
      break;
    IncDay(Result, -1);
  end;
  DecodeDate(Result, aYear, aMonth, aDay);
  Result := EncodeDateTime(aYear, aMonth, aDay, aHour, aMin, aSec, aMSec);
end;

{ LastPos

  ��������� ��������� ��������� � ������ }
function LastPos(SubStr, S: string): integer;
var
  Found, Len, Pos: integer;
begin
  Pos := Length(S);
  Len := Length(SubStr);
  Found := 0;
  while (Pos > 0) and (Found = 0) do
  begin
    if Copy(S, Pos, Len) = SubStr then
      Found := Pos;
    Dec(Pos);
  end;
  Result := Found;
end;

{ FontStyletoStr

  ������������ ����� ������ (����� � torry.net) }
function FontStyletoStr(St: TFontStyles): string;
var
  S: string;
begin
  S := '';
  if St = [fsbold] then
    S := 'Bold'
  else if St = [fsItalic] then
    S := 'Italic'
  else if St = [fsStrikeOut] then
    S := 'StrikeOut'
  else if St = [fsUnderline] then
    S := 'UnderLine'

  else if St = [fsbold, fsItalic] then
    S := 'BoldItalic'
  else if St = [fsbold, fsStrikeOut] then
    S := 'BoldStrike'
  else if St = [fsbold, fsUnderline] then
    S := 'BoldUnderLine'
  else if St = [fsbold .. fsStrikeOut] then
    S := 'BoldItalicStrike'
  else if St = [fsbold .. fsUnderline] then
    S := 'BoldItalicUnderLine'
  else if St = [fsbold .. fsItalic, fsStrikeOut] then
    S := 'BoldItalicStrike'
  else if St = [fsbold, fsUnderline .. fsStrikeOut] then
    S := 'BoldStrikeUnderLine'

  else if St = [fsItalic, fsStrikeOut] then
    S := 'ItalicStrike'
  else if St = [fsItalic .. fsUnderline] then
    S := 'ItalicUnderLine'
  else if St = [fsUnderline .. fsStrikeOut] then
    S := 'UnderLineStrike'
  else if St = [fsItalic .. fsStrikeOut] then
    S := 'ItalicUnderLineStrike';
  Result := S;
end;

{ StrtoFontStyle

  �������� ������������ ����� ������ (����� � torry.net) }
function StrtoFontStyle(St: string): TFontStyles;
var
  S: TFontStyles;
begin
  S := [];
  St := UpperCase(St);
  if St = 'BOLD' then
    S := [fsbold]
  else if St = 'ITALIC' then
    S := [fsItalic]
  else if St = 'STRIKEOUT' then
    S := [fsStrikeOut]
  else if St = 'UNDERLINE' then
    S := [fsUnderline]

  else if St = 'BOLDITALIC' then
    S := [fsbold, fsItalic]
  else if St = 'BOLDSTRIKE' then
    S := [fsbold, fsStrikeOut]
  else if St = 'BOLDUNDERLINE' then
    S := [fsbold, fsUnderline]
  else if St = 'BOLDITALICSTRIKE' then
    S := [fsbold .. fsStrikeOut]
  else if St = 'BOLDITALICUNDERLINE' then
    S := [fsbold .. fsUnderline]
  else if St = 'BOLDITALICSTRIKE' then
    S := [fsbold .. fsItalic, fsStrikeOut]
  else if St = 'BOLDSTRIKEUNDERLINE' then
    S := [fsbold, fsUnderline .. fsStrikeOut]

  else if St = 'ITALICSTRIKE' then
    S := [fsItalic, fsStrikeOut]
  else if St = 'ITALICUNDERLINE' then
    S := [fsItalic .. fsUnderline]
  else if St = 'UNDERLINESTRIKE' then
    S := [fsUnderline .. fsStrikeOut]
  else if St = 'ITALICUNDERLINESTRIKE' then
    S := [fsItalic .. fsStrikeOut];
  Result := S;
end;

{ ETypeToStr

  ���������������� ���� ������ � ������ }
function ETypeToStr(const eType: TEventType): string;
begin
  Result := '';
  case integer(eType) of
    0:
      begin
        Result := fmMain.lsMain.GetCaption(40);
      end;
    1:
      begin
        Result := fmMain.lsMain.GetCaption(40, 1);
      end;
  end;
end;

{ ECTTypeToStr

  ���������������� ���� ������������ ������ � ������ }
function ECTTypeToStr(const eCircleTimeType: TCircleTimeType): string;
begin
  Result := '��� ������';
  case integer(eCircleTimeType) of
    0:
      Result := fmMain.lsMain.GetCaption(41, integer(eCircleTimeType));
    1:
      Result := fmMain.lsMain.GetCaption(41, integer(eCircleTimeType));
    2:
      Result := fmMain.lsMain.GetCaption(41, integer(eCircleTimeType));
    3:
      Result := fmMain.lsMain.GetCaption(41, integer(eCircleTimeType));
    4:
      Result := fmMain.lsMain.GetCaption(41, integer(eCircleTimeType));
    5:
      Result := fmMain.lsMain.GetCaption(41, integer(eCircleTimeType));
  end;
end;

{ ECDaysToStr

  ��������������� ����� ���� � ������ }
function ECDaysToStr(const eCircleDays: TCircleArrDays): string;
var
  i: integer;
begin
  Result := '|';
  for i := 1 to 7 do
    if eCircleDays[i] = true then
      Result := Result + '-' + inttostr(i);
end;

{ ECMDaysToStr

  ��������������� ����� ���� ������ � ������ }
function ECMDaysToStr(const eCircleMDays: TCircleMArrDays): string;
var
  i: integer;
begin
  Result := '|';
  for i := 1 to 31 do
    if eCircleMDays[i] = true then
      Result := Result + '-' + inttostr(i);
end;

{ EMsgToLine

  ���������������� ��������� ����� � ������ �������, ����� �� ��������� ��������� ���� }
function EMsgToLine(const eMsg: string): string;
var
  i: integer;
begin
  Result := '';
  for i := 1 to Length(eMsg) do
    if eMsg[i] = #13 then
      Result := Result + chr(2)
    else if eMsg[i] = #10 then
      Result := Result + chr(3)
    else
      Result := Result + eMsg[i];
end;

{ LineToEMsg

  ��������������� ���� ������� ����� � �������� ����� }
function LineToEMsg(const Line: string): string;
var
  i: integer;
begin
  Result := '';
  for i := 1 to Length(Line) do
    if Line[i] = chr(2) then
      Result := Result + #13
    else if Line[i] = chr(3) then
      Result := Result + #10
    else
      Result := Result + Line[i];
end;

{ EDoneToStr

  ����������� ������� }
function EDoneToStr(const eDone: boolean): string;
begin
  Result := '';
  case eDone of
    true:
      begin
        Result := fmMain.lsMain.GetCaption(56, 1);
      end;
    false:
      begin
        Result := fmMain.lsMain.GetCaption(56);
      end;
  end;
end;

{ TEventList }

{ TEventList.Add

  ������ ����� ����� private }
procedure TEventList.Add(Value: TEvent);
begin
  inherited Add(Value);
  if Self.Count > 0 then
    FLoaded := true
  else
    FLoaded := false;
end;

{ TEventList.AddEvent

  ���������� ������ }
procedure TEventList.AddEvent(var Groups: TGroupList; const eHeader,
  eMsg: string; const eTime: TDateTime; const eCircleDays: TCircleArrDays;
  const eCircleMonthDays: TCircleMArrDays; const eType: TEventType = etNormal;
  const eCircleTimeType: TCircleTimeType = �ttSingle;
  const eGroup: integer = 0; const eDone: boolean = false;
  const eStartPrgm: boolean = false; const ePrgmPath: string = '');
var
  Event: TEvent;
begin
  try
    Event := TEvent.Create;
    Event.FId := Self.GetUnusedeId;
    Event.FType := eType;
    Event.FTime := eTime;
    Event.FCircleTimeType := eCircleTimeType;
    Event.FCircleDays := eCircleDays;
    Event.FCircleMonthDays := eCircleMonthDays;
    Event.FReminder := eTime;
    Event.FHeader := eHeader;
    Event.FMsg := eMsg;
    Event.FStartPrgm := eStartPrgm;
    Event.OnChange := Event.EventChange;
    if eStartPrgm then
      Event.ePrgmPath := ePrgmPath
    else
      Event.ePrgmPath := '';
    if (eGroup > Groups.MaxGroupId) or (eGroup < 0) then
      Event.eGroup := 0
    else
      Event.eGroup := eGroup;
    Event.eDone := eDone;
    Add(Event);
    if FAutoSave then
      SaveEvents; // ��������� ���� �������
  except
    on E: Exception do
      MessageBox(Application.Handle, PChar(fmMain.lsMain.GetCaption(18)
            + #13#10 + fmMain.lsMain.GetCaption(3) + E.Message), PChar
          (fmMain.lsMain.GetCaption(13)), 48);
  end;
end;

{ TEventList.CDToLine

  ������������ TCircleArrDays }
class function TEventList.CDToLine(var eCircleDays: TCircleArrDays;
  const sep: char = chr(3)): string;
var
  i: integer;
begin
  Result := '';
  for i := 1 to 7 do
    if eCircleDays[i] = true then
      Result := Result + '1' + sep
    else
      Result := Result + '0' + sep;
end;

{ TEventList.CMDToLine

  ������������ TCircleMArrDays }
class function TEventList.CMDToLine(var eCircleMDays: TCircleMArrDays;
  const sep: char): string;
var
  i: integer;
begin
  Result := '';
  for i := 1 to 31 do
    if eCircleMDays[i] = true then
      Result := Result + '1' + sep
    else
      Result := Result + '0' + sep;
end;

{ TEventList.Create

  ������� ������, ��������� ����� �������� }
constructor TEventList.Create(const aFileName: string = '');
begin
  inherited Create;
  FFileName := aFileName;
end;

{ TEventList.Delete

  �������� ������ �� �� ���� � ������ }
procedure TEventList.Delete(Value: integer);
begin
  inherited Delete(Value);
  if Self.Count > 0 then
    FLoaded := true
  else
    FLoaded := false;
end;

{ TEventList.DeleteEvent

  ������� ������ �� �� ���������� ���� }
procedure TEventList.DeleteEvent(const eId: integer);
var
  i: integer;
begin
  try
    for i := 0 to Self.Count - 1 do
    begin
      if Items[i].FId = eId then
      begin
        Delete(i);
        break;
      end;
    end;
  finally
    if FAutoSave then
      SaveEvents;
  end;
end;

{ TEventList.Destroy

  ������������� �����, ����������� ������� }
destructor TEventList.Destroy;
begin
  inherited;
end;

{ TEventList.GetUnusedeId

  ���������� ����������� ���������������� ���� }
function TEventList.GetUnusedeId: integer;
var
  i: integer;
label restart;
begin
  Result := 1;
restart :
  for i := 0 to Self.Count - 1 do
  begin
    if Result = Self.Items[i].FId then
    begin
      Inc(Result);
      goto restart;
    end;
  end;
end;

{ TEventList.LineToCD

  �������������� � TCircleArrDays }
class function TEventList.LineToCD(const Line: string; sep: char = chr(3))
  : TCircleArrDays;
var
  arrLine: array of string;
  i: integer;
begin
  SetLength(arrLine, 8);
  Explode(arrLine, sep, Line);
  for i := 1 to 7 do
    if arrLine[i - 1] = '1' then
      Result[i] := true
    else
      Result[i] := false;
end;

{ TEventList.LineToCMD

  �������������� � TCircleMArrDays }
class function TEventList.LineToCMD(const Line: string; sep: char)
  : TCircleMArrDays;
var
  arrLine: array of string;
  i: integer;
begin
  SetLength(arrLine, 32);
  Explode(arrLine, sep, Line);
  for i := 1 to 31 do
    if arrLine[i - 1] = '1' then
      Result[i] := true
    else
      Result[i] := false;
end;

{ TEventList.LoadEvents

  �������� ����� }
procedure TEventList.LoadEvents;
var
  eFile: TextFile;
  eLine: string;
  eSep: char;
  eArrLine: array of string;
  eEvent: TEvent;
  numLine: integer;
begin
  if FFileName = '' then
    FFileName := ExtractFilePath(ParamStr(0)) + 'event_list.data';
  if not FileExists(FFileName) then
    Exit;
  eSep := chr(1);
  SetLength(eArrLine, 13);
  numLine := 0;
  try
    Clear;
    FLoaded := false;
    try
      AssignFile(eFile, FFileName);
      Reset(eFile);
    except
      on E: Exception do
      begin
        MessageBox(Application.Handle, PChar(fmMain.lsMain.GetCaption(18)
              + #13#10 + fmMain.lsMain.GetCaption(3) + E.Message), PChar
            (fmMain.lsMain.GetCaption(13)), 48);
      end;
    end;
    try
      while not Eof(eFile) do
      begin
        Readln(eFile, eLine);
        if Trim(eLine) = '' then
          Exit;
        Explode(eArrLine, eSep, eLine);
        eEvent := TEvent.Create;
        eEvent.FId := StrToInt(eArrLine[0]);
        eEvent.FType := TEventType(StrToInt(eArrLine[1]));
        eEvent.FTime := strtofloat(eArrLine[2]);
        eEvent.FCircleTimeType := TCircleTimeType(StrToInt(eArrLine[3]));
        eEvent.FCircleDays := LineToCD(eArrLine[4]);
        eEvent.FCircleMonthDays := LineToCMD(eArrLine[5]);
        eEvent.FReminder := strtofloat(eArrLine[6]);
        eEvent.FHeader := eArrLine[7];
        eEvent.FMsg := LineToEMsg(eArrLine[8]);
        eEvent.FGroup := StrToInt(eArrLine[9]);
        eEvent.FDone := boolean(StrToInt(eArrLine[10]));
        eEvent.FStartPrgm := boolean(StrToInt(eArrLine[11]));
        eEvent.FPrgmPath := eArrLine[12];
        eEvent.OnChange := eEvent.EventChange;
        Self.Add(eEvent);
        Inc(numLine);
      end;
    except
      on E: Exception do
      begin
        Clear;
        FLoaded := false;
        MessageBox(Application.Handle, PChar(fmMain.lsMain.GetCaption(19)
              + #13#10 + fmMain.lsMain.GetCaption(20) + inttostr(numLine)
              + ': ' + E.Message), PChar(fmMain.lsMain.GetCaption(13)), 48);
      end;
    end;
  finally
    SetLength(eArrLine, 0);
    CloseFile(eFile);
    if Self.Count > 0 then
      FLoaded := true;
  end;
end;

// ���������� ������ �������
procedure TEventList.SaveEvents;
var
  eFile: TextFile;
  i: integer;
  eLine: string;
  eSep: char;
  numLine: integer;
begin
  if FFileName = '' then
    FFileName := ExtractFilePath(ParamStr(0)) + 'event_list.data';
  eSep := chr(1);
  numLine := 0;
  try
    try
      AssignFile(eFile, FFileName);
      Rewrite(eFile);
    except
      on E: Exception do
      begin
        MessageBox(Application.Handle, PChar(fmMain.lsMain.GetCaption(21)
              + #13#10 + fmMain.lsMain.GetCaption(3) + E.Message), PChar
            (fmMain.lsMain.GetCaption(13, 1)), 48);
      end;
    end;
    try
      for i := 0 to Self.Count - 1 do
      begin
        eLine := inttostr(Self.Items[i].FId) + eSep + inttostr
          (ord(Self.Items[i].FType)) + eSep + floattostr(Self.Items[i].FTime)
          + eSep + inttostr(ord(Self.Items[i].FCircleTimeType))
          + eSep + CDToLine(Self.Items[i].FCircleDays) + eSep + CMDToLine
          (Self.Items[i].FCircleMonthDays) + eSep + floattostr
          (Self.Items[i].FReminder) + eSep + Self.Items[i].FHeader + eSep +
          EMsgToLine(Self.Items[i].FMsg) + eSep + inttostr
          (Self.Items[i].FGroup) + eSep + inttostr(ord(Self.Items[i].FDone))
          + eSep + inttostr(ord(Self.Items[i].FStartPrgm))
          + eSep + Self.Items[i].FPrgmPath;
        Writeln(eFile, eLine);
        Inc(numLine);
      end;
    except
      on E: Exception do
      begin
        MessageBox(Application.Handle, PChar(fmMain.lsMain.GetCaption(22)
              + #13#10 + fmMain.lsMain.GetCaption(20) + inttostr(numLine)
              + ': ' + E.Message), PChar(fmMain.lsMain.GetCaption(13, 1)), 48);
      end;
    end;
  finally
    CloseFile(eFile);
  end;
end;

// ���������� ����� (��������� �����)
procedure TEventList.SortByTimeMaxFirst;
begin
  if not Loaded then
    Exit;
  Self.Sort(TComparer<TEvent>.Construct( function(const L, R: TEvent)
        : integer begin if L.eDone and not R.eDone then
      // ������� ��������� ������ �� ������������
        Result := 1 // �������� ���������� ������
        else if not L.eDone and R.eDone then Result :=
        -1 else if L.eDone and R.eDone then // ��������� ���������� ������
        begin if L.eTime = R.eTime then Result :=
        0 else if L.eTime > R.eTime then Result := -1 else Result := 1;
      end else if not L.eDone and not R.eDone then // ��������� �������� ������
        begin if L.eTime = R.eTime then Result :=
        0 else if L.eTime > R.eTime then Result := -1 else Result := 1; end;
      { if L.eTime = R.eTime then Result:= 0
        else
        if L.eTime > R.eTime then Result:= -1
        else
        Result:=1; }
      end));
end;

// ���������� ����� (��������� ������)
procedure TEventList.SortByTimeMinFirst;
begin
  if not Loaded then
    Exit;
  Self.Sort(TComparer<TEvent>.Construct( function(const L, R: TEvent)
        : integer begin if L.eDone and not R.eDone then
      // ������� ��������� ������ �� ������������
        Result := 1 // �������� ���������� ������
        else if not L.eDone and R.eDone then Result :=
        -1 else if L.eDone and R.eDone then // ��������� ���������� ������
        begin if L.eTime = R.eTime then Result :=
        0 else if L.eTime < R.eTime then Result := -1 else Result := 1;
      end else if not L.eDone and not R.eDone then // ��������� �������� ������
        begin if L.eTime = R.eTime then Result :=
        0 else if L.eTime < R.eTime then Result := -1 else Result := 1; end;
      { if L.eTime = R.eTime then Result:= 0
        else
        if L.eTime < R.eTime then Result:= -1
        else
        Result:= 1; }
      end));
end;

{ TGroupItem }

// ������������� �������� ������
constructor TGroupItem.Create(const aName: string; const aId,
  aParentId: integer; aFont: TFont; aExpanded: boolean);
begin
  inherited Create;
  Self.FId := aId;
  Self.FName := aName;
  Self.FParentId := aParentId;
  Self.FExpanded := aExpanded;
  Self.FFont := TFont.Create;
  Self.FFont.Assign(aFont);
end;

{ TGroupList }

// ������ ����� ����� private
procedure TGroupList.Add(Value: TGroupItem);
begin
  inherited Add(Value);
  if Self.Count > 0 then
    FLoaded := true
  else
    FLoaded := false;
end;

// ���������� ����� ������ � ������
function TGroupList.AddGroup(const aName: string; const aParentId: integer = 0)
  : integer;
var
  gFilteredName: string;
  gUnusedId: integer;
begin
  Result := 0;
  try
    gFilteredName := aName;
    gFilteredName := StringReplace(gFilteredName, chr(1), '',
      [rfReplaceAll, rfIgnoreCase]);
    gFilteredName := StringReplace(gFilteredName, chr(2), '',
      [rfReplaceAll, rfIgnoreCase]);
    gUnusedId := GetUnsedgId;
    Self.Add(TGroupItem.Create(gFilteredName, gUnusedId, aParentId, FDefFont));
    if FAutoSave then
      SaveGroups;
    Result := gUnusedId;
  except
    on E: Exception do
      MessageBox(Application.Handle, PChar(fmMain.lsMain.GetCaption(23, 1)
            + #13#10 + fmMain.lsMain.GetCaption(3) + E.Message), PChar
          (fmMain.lsMain.GetCaption(13, 2)), 48);
  end;
end;

{ TGroupList.Create

  ����������� }
constructor TGroupList.Create(const aFileName: string = '');
begin
  inherited Create;
  FFileName := aFileName;
  FLoaded := false;
  FDefFont := TFont.Create;
  FDefFont.Name := 'Verdana';
  FDefFont.Size := 9;
  FDefFont.Color := clBlack;
end;

{ TGroupList.Delete

  ������� ������ ������ � ��������� }
procedure TGroupList.Delete(const Value: integer);
begin
  inherited Delete(Value);
  if Self.Count > 0 then
    FLoaded := true
  else
    FLoaded := false;
  if FAutoSave then
    SaveGroups;
end;

{ TGroupList.DeleteGroup

  �������� ������ �� �� ���� }
procedure TGroupList.DeleteGroup(const aId: integer);
var
  i: integer;
begin
  try
    i := 0;
    if not GroupExists(aId) then
      Exit;
    repeat
      if Items[i].ParentId = aId then
      begin
        DeleteGroup(Items[i].Id);
        i := -1;
      end
      else if Items[i].Id = aId then
      begin
        Self.Delete(i);
        i := -1;
      end;
      Inc(i);
    until i > Self.Count - 1;
  except
    on E: Exception do
      MessageBox(Application.Handle, PChar(fmMain.lsMain.GetCaption(23)
            + #13#10 + fmMain.lsMain.GetCaption(3) + E.Message), PChar
          (fmMain.lsMain.GetCaption(13, 2)), 48);
  end;
end;

// ����������� ��������� ����� �� ���������
destructor TGroupList.Destroy;
begin
  FDefFont.Free;
  inherited;
end;

// ������ ������ � ������ �� �� ����
function TGroupList.GetGroupIndex(const aId: integer): integer;
var
  i: integer;
begin
  Result := -1;
  for i := 0 to Self.Count - 1 do
    if Self.Items[i].FId = aId then
      Result := i;
end;

// ���������� ������� ������
function TGroupList.GetGroupItem(const aId: integer): TGroupItem;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to Self.Count - 1 do
  begin
    if aId = Self.Items[i].FId then
      Result := Self.Items[i];
  end;
end;

// ������ ������������ ��������� ���� ������
function TGroupList.GetMaxGroupId: integer;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to Self.Count - 1 do
    if Result < Self.Items[i].FId then
      Result := Self.Items[i].FId;
end;

// ���������� ����������� ���� ������
function TGroupList.GetUnsedgId: integer;
var
  i: integer;
label restart;
begin
  Result := 1;
restart :
  for i := 0 to Self.Count - 1 do
  begin
    if Result = Self.Items[i].FId then
    begin
      Inc(Result);
      goto restart;
    end;
  end;
end;

// �������� ������������� ������ �� ����
function TGroupList.GroupExists(const aId: integer): boolean;
var
  i: integer;
begin
  Result := false;
  for i := 0 to Self.Count - 1 do
    if Self.Items[i].FId = aId then
      Result := true;
end;

// �������� ������������� �������� ������
function TGroupList.HasChild(const aId: integer): boolean;
var
  i: integer;
begin
  Result := false;
  for i := 0 to Self.Count - 1 do
  begin
    if Self.Items[i].FParentId = aId then
      Result := true;
  end;
end;

// �������� ������ ����� �� �����
procedure TGroupList.LoadGroups(const aFileName: string);
var
  gFile: TextFile;
  gLine: string;
  gSep: char;
  gArrLine: array of string;
  numLine: integer;
  gFont: TFont;
begin
  if FFileName = '' then
    FFileName := ExtractFilePath(ParamStr(0)) + aFileName;
  if not FileExists(FFileName) then
    Exit;
  gSep := chr(1);
  SetLength(gArrLine, 5);
  numLine := 0;
  try
    try
      AssignFile(gFile, FFileName);
      Reset(gFile);
    except
      on E: Exception do
      begin
        Self.Clear;
        FLoaded := false;
        MessageBox(Application.Handle, PChar(fmMain.lsMain.GetCaption(34)
              + #13#10 + fmMain.lsMain.GetCaption(3) + E.Message), PChar
            (fmMain.lsMain.GetCaption(13)), 48);
      end;
    end;
    try
      gFont := TFont.Create;
      while not Eof(gFile) do
      begin
        Readln(gFile, gLine);
        if Trim(gLine) = '' then
          Exit;
        Explode(gArrLine, gSep, gLine);
        Self.UnSerializeFont(gFont, gArrLine[4]);
        Self.Add(TGroupItem.Create(gArrLine[1], StrToInt(gArrLine[0]), StrToInt
              (gArrLine[2]), gFont, strtobool(gArrLine[3])));
        Inc(numLine);
      end;
    except
      on E: Exception do
      begin
        Self.Clear;
        FLoaded := false;
        MessageBox(Application.Handle, PChar(fmMain.lsMain.GetCaption(35)
              + #13#10 + fmMain.lsMain.GetCaption(20) + inttostr(numLine)
              + ': ' + E.Message), PChar(fmMain.lsMain.GetCaption(13)), 48);
      end;
    end;
  finally
    gFont.Free;
    SetLength(gArrLine, 0);
    if Self.Count <> 0 then
      FLoaded := true;
    CloseFile(gFile);
  end;
end;

// ���������� ������ ����� � ����
procedure TGroupList.SaveGroups(const aFileName: string);
var
  gFile: TextFile;
  i: integer;
  gLine: string;
  gSep: char;
  numLine: integer;
begin
  if FFileName = '' then
    FFileName := ExtractFilePath(ParamStr(0)) + aFileName;
  gSep := chr(1);
  numLine := 0;
  try
    try
      AssignFile(gFile, FFileName);
      Rewrite(gFile);
    except
      on E: Exception do
      begin
        MessageBox(Application.Handle, PChar(fmMain.lsMain.GetCaption(51)
              + #13#10 + fmMain.lsMain.GetCaption(3) + E.Message), PChar
            (fmMain.lsMain.GetCaption(13, 1)), 48);
      end;
    end;
    try
      for i := 0 to Self.Count - 1 do
      begin
        gLine := inttostr(Self.Items[i].FId) + gSep + Self.Items[i]
          .FName + gSep + inttostr(Self.Items[i].FParentId) + gSep + booltostr
          (Self.Items[i].FExpanded) + gSep + Self.SerializeFont
          (Self.Items[i].FFont);
        Writeln(gFile, gLine);
        Inc(numLine);
      end;
    except
      on E: Exception do
      begin
        MessageBox(Application.Handle, PChar(fmMain.lsMain.GetCaption(52)
              + #13#10 + fmMain.lsMain.GetCaption(20) + inttostr(numLine)
              + ': ' + E.Message), PChar(fmMain.lsMain.GetCaption(13, 1)), 48);
      end;
    end;
  finally
    CloseFile(gFile);
  end;
end;

{ TGroupList.SerializeFont

  �������������� ������ � ������ }
class function TGroupList.SerializeFont(aFont: TFont; const aSep: char = chr(2))
  : string;
begin
  Result := '';
  Result := inttostr(aFont.PixelsPerInch) + aSep + inttostr(aFont.Charset)
    + aSep + ColorToString(aFont.Color) + aSep + inttostr(aFont.Height)
    + aSep + aFont.Name + aSep + inttostr(aFont.Charset) + aSep + inttostr
    (ord(aFont.Pitch)) + aSep + FontStyletoStr(aFont.Style) + aSep + inttostr
    (aFont.Size);
end;

{ TGroupList.UnSerializeFont

  �������������� ������ � ����� }
class procedure TGroupList.UnSerializeFont(aFont: TFont; const strFont: string;
  const aSep: char = chr(2));
var
  arrStr: array of string;
begin
  SetLength(arrStr, 9);
  Explode(arrStr, aSep, strFont);
  aFont.PixelsPerInch := StrToInt(arrStr[0]);
  aFont.Charset := StrToInt(arrStr[1]);
  aFont.Color := StringToColor(arrStr[2]);
  aFont.Height := StrToInt(arrStr[3]);
  aFont.Name := arrStr[4];
  aFont.Charset := StrToInt(arrStr[5]);
  aFont.Pitch := TFontPitch(StrToInt(arrStr[6]));
  aFont.Style := StrtoFontStyle(arrStr[7]);
  aFont.Size := StrToInt(arrStr[8]);
end;

{ TGroupItem.Destroy

  ����������� ��������� ����� ���� }
destructor TGroupItem.Destroy;
begin
  FFont.Free;
  inherited;
end;

{ TGroupItem.GetGroupFont
  ���������� ������ ������ }
procedure TGroupItem.GetGroupFont(aFont: TFont);
begin
  if FFont <> nil then
    aFont.Assign(FFont);
end;

{ TGroupItem.SetGroupFont

  ��������� ������ ������ }
procedure TGroupItem.SetGroupFont(aFont: TFont);
begin
  if aFont <> nil then
    FFont.Assign(aFont);
end;

{ TEventThread }

{ TEventThread.Create

  ������� ���������������� ����� }
constructor TEventThread.Create;
begin
  inherited Create(true);
end;

{ TEventThread.Destroy

  ������� }
destructor TEventThread.Destroy;
begin
  inherited;
end;

{ TEventThread.DoDay

  ������ ���� }
procedure TEventThread.DoDay;
var
  defReminder: integer;
begin
  if (FEvent.eTime <= FTime) and not FEvent.eDone then
  begin
    if (FEvent.eReminder > FEvent.eTime) and (FEvent.eReminder <= FTime) then
    begin
      if FEvent.eStartPrgm then
        if FileExists(FEvent.ePrgmPath) then
          ShellExecute(Handle, 'open', PChar(FEvent.ePrgmPath), nil, nil,
            SW_SHOWNORMAL);
      if ShowTaskDialog(FEvent.eHeader + fmMain.lsMain.GetCaption(37),
        FEvent.eMsg, defReminder, FEvent.eType) then
      begin
        FEvent.eReminder := FEvent.eTime;
        FEvent.eTime := IncDay(FEvent.eTime, 1);
      end
      else
      begin
        FEvent.eReminder := IncSecond(FTime, defReminder);
      end;
    end
    else if FEvent.eReminder <= FEvent.eTime then
    begin
      if FEvent.eStartPrgm then
        if FileExists(FEvent.ePrgmPath) then
          ShellExecute(Handle, 'open', PChar(FEvent.ePrgmPath), nil, nil,
            SW_SHOWNORMAL);
      if ShowTaskDialog(FEvent.eHeader, FEvent.eMsg, defReminder, FEvent.eType)
        then
      begin
        FEvent.eReminder := FEvent.eTime;
        FEvent.eTime := IncDay(FEvent.eTime, 1);
      end
      else
      begin
        FEvent.eReminder := IncSecond(FTime, defReminder);
      end;
    end;
    fmMain.UpdateList;
  end;
end;

{ TEventThread.DoFirstWDMonth

  ������ ������ ������� ���� ������ }
procedure TEventThread.DoFirstWDMonth;
var
  defReminder: integer;
begin
  if (FEvent.eTime <= FTime) and not FEvent.eDone then
  begin
    if (FEvent.eReminder > FEvent.eTime) and (FEvent.eReminder <= FTime) then
    begin
      if FEvent.eStartPrgm then
        if FileExists(FEvent.ePrgmPath) then
          ShellExecute(Handle, 'open', PChar(FEvent.ePrgmPath), nil, nil,
            SW_SHOWNORMAL);
      if ShowTaskDialog(FEvent.eHeader + fmMain.lsMain.GetCaption(37),
        FEvent.eMsg, defReminder, FEvent.eType) then
      begin
        FEvent.eReminder := FEvent.eTime;
        FEvent.eTime := GetTimeOfFWDMonth(FEvent.eTime);
      end
      else
      begin
        FEvent.eDone := false;
        FEvent.eReminder := IncSecond(FTime, defReminder);
      end;
    end
    else if (FEvent.eReminder <= FEvent.eTime) then
    begin
      if FEvent.eStartPrgm then
        if FileExists(FEvent.ePrgmPath) then
          ShellExecute(Handle, 'open', PChar(FEvent.ePrgmPath), nil, nil,
            SW_SHOWNORMAL);
      if ShowTaskDialog(FEvent.eHeader, FEvent.eMsg, defReminder, FEvent.eType)
        then
      begin
        FEvent.eReminder := FEvent.eTime;
        FEvent.eTime := GetTimeOfFWDMonth(FEvent.eTime);
      end
      else
      begin
        FEvent.eReminder := IncSecond(FTime, defReminder);
      end;
    end;
    fmMain.UpdateList;
  end;
end;

{ TEventThread.DoLastWDMonth

  ������ �������� ���� �������� ������ }
procedure TEventThread.DoLastWDMonth;
var
  defReminder: integer;
begin
  if (FEvent.eTime <= FTime) and not FEvent.eDone then
  begin
    if (FEvent.eReminder > FEvent.eTime) and (FEvent.eReminder <= FTime) then
    begin
      if FEvent.eStartPrgm then
        if FileExists(FEvent.ePrgmPath) then
          ShellExecute(Handle, 'open', PChar(FEvent.ePrgmPath), nil, nil,
            SW_SHOWNORMAL);
      if ShowTaskDialog(FEvent.eHeader + fmMain.lsMain.GetCaption(37),
        FEvent.eMsg, defReminder, FEvent.eType) then
      begin
        FEvent.eReminder := FEvent.eTime;
        FEvent.eTime := GetTimeOfLWDMonth(FTime);
      end
      else
      begin
        FEvent.eDone := false;
        FEvent.eReminder := IncSecond(FTime, defReminder);
      end;
    end
    else if (FEvent.eReminder <= FEvent.eTime) then
    begin
      if FEvent.eStartPrgm then
        if FileExists(FEvent.ePrgmPath) then
          ShellExecute(Handle, 'open', PChar(FEvent.ePrgmPath), nil, nil,
            SW_SHOWNORMAL);
      if ShowTaskDialog(FEvent.eHeader, FEvent.eMsg, defReminder, FEvent.eType)
        then
      begin
        FEvent.eReminder := FEvent.eTime;
        FEvent.eTime := GetTimeOfLWDMonth(FTime);
      end
      else
      begin
        FEvent.eReminder := IncSecond(FTime, defReminder);
      end;
    end;
    fmMain.UpdateList;
  end;
end;

{ TEventThread.DoMonth

  ������ ���� ������ }
procedure TEventThread.DoMonth;
var
  defReminder: integer;
begin
  if (FEvent.eTime <= FTime) and not FEvent.eDone then
  begin
    if (FEvent.eReminder > FEvent.eTime) and (FEvent.eReminder <= FTime) then
    begin
      if FEvent.eStartPrgm then
        if FileExists(FEvent.ePrgmPath) then
          ShellExecute(Handle, 'open', PChar(FEvent.ePrgmPath), nil, nil,
            SW_SHOWNORMAL);
      if ShowTaskDialog(FEvent.eHeader + fmMain.lsMain.GetCaption(37),
        FEvent.eMsg, defReminder, FEvent.eType) then
      begin
        FEvent.eReminder := FEvent.eTime;
        FEvent.eTime := GetTimeOfMonth(FEvent.eTime, FEvent.eCircleMonthDays);
      end
      else
      begin
        FEvent.eDone := false;
        FEvent.eReminder := IncSecond(FTime, defReminder);
      end;
    end
    else if (FEvent.eReminder <= FEvent.eTime) then
    begin
      if FEvent.eStartPrgm then
        if FileExists(FEvent.ePrgmPath) then
          ShellExecute(Handle, 'open', PChar(FEvent.ePrgmPath), nil, nil,
            SW_SHOWNORMAL);
      if ShowTaskDialog(FEvent.eHeader, FEvent.eMsg, defReminder, FEvent.eType)
        then
      begin
        FEvent.eReminder := FEvent.eTime;
        FEvent.eTime := GetTimeOfMonth(FEvent.eTime, FEvent.eCircleMonthDays);
      end
      else
      begin
        FEvent.eReminder := IncSecond(FTime, defReminder);
      end;
    end;
    fmMain.UpdateList;
  end;
end;

{ TEventThread.DoSingle

  ������� ������� }
procedure TEventThread.DoSingle;
var
  defReminder: integer;
begin
  if (FEvent.eTime <= FTime) and not FEvent.eDone then
  begin
    if (FEvent.eReminder > FEvent.eTime) and (FEvent.eReminder <= FTime) then
    begin
      if FEvent.eStartPrgm then
        if FileExists(FEvent.ePrgmPath) then
          ShellExecute(Handle, 'open', PChar(FEvent.ePrgmPath), nil, nil,
            SW_SHOWNORMAL);
      if ShowTaskDialog(FEvent.eHeader + fmMain.lsMain.GetCaption(37),
        FEvent.eMsg, defReminder, FEvent.eType) then
      begin
        FEvent.eDone := true;
        FEvent.eReminder := FEvent.eTime;
      end
      else
      begin
        FEvent.eDone := false;
        FEvent.eReminder := IncSecond(FTime, defReminder);
      end;
    end
    else if (FEvent.eReminder <= FEvent.eTime) then
    begin
      if FEvent.eStartPrgm then
        if FileExists(FEvent.ePrgmPath) then
          ShellExecute(Handle, 'open', PChar(FEvent.ePrgmPath), nil, nil,
            SW_SHOWNORMAL);
      if ShowTaskDialog(FEvent.eHeader, FEvent.eMsg, defReminder, FEvent.eType)
        then
      begin
        FEvent.eDone := true;
        FEvent.eReminder := FEvent.eTime;
      end
      else
      begin
        FEvent.eDone := false;
        FEvent.eReminder := IncSecond(FTime, defReminder);
      end;
    end;
    fmMain.UpdateList;
  end;
end;

{ TEventThread.DoWeek

  ������ ���� ������ }
procedure TEventThread.DoWeek;
var
  defReminder: integer;
begin
  if (FEvent.eTime <= FTime) and not FEvent.eDone then
  begin
    if (FEvent.eReminder > FEvent.eTime) and (FEvent.eReminder <= FTime) then
    begin
      if FEvent.eStartPrgm then
        if FileExists(FEvent.ePrgmPath) then
          ShellExecute(Handle, 'open', PChar(FEvent.ePrgmPath), nil, nil,
            SW_SHOWNORMAL);
      if ShowTaskDialog(FEvent.eHeader + fmMain.lsMain.GetCaption(37),
        FEvent.eMsg, defReminder, FEvent.eType) then
      begin
        FEvent.eReminder := FEvent.eTime;
        FEvent.eTime := GetTimeOfWeek(FEvent.eTime, FEvent.eCircleDays);
      end
      else
      begin
        FEvent.eDone := false;
        FEvent.eReminder := IncSecond(FTime, defReminder);
      end;
    end
    else if (FEvent.eReminder <= FEvent.eTime) then
    begin
      if FEvent.eStartPrgm then
        if FileExists(FEvent.ePrgmPath) then
          ShellExecute(Handle, 'open', PChar(FEvent.ePrgmPath), nil, nil,
            SW_SHOWNORMAL);
      if ShowTaskDialog(FEvent.eHeader, FEvent.eMsg, defReminder, FEvent.eType)
        then
      begin
        FEvent.eReminder := FEvent.eTime;
        FEvent.eTime := GetTimeOfWeek(FEvent.eTime, FEvent.eCircleDays);
      end
      else
      begin
        FEvent.eReminder := IncSecond(FTime, defReminder);
      end;
    end;
    fmMain.UpdateList;
  end;
end;

{ TEventThread.Execute

  ��������� ������� }
procedure TEventThread.Execute;
var
  i: integer;
begin
  while not Terminated and FInitiated do
  begin
    try
      FTime := now(); // ������� �����
      Synchronize(UpdateWindow);
      sleep(1000); // �������� � �������
      for i := 0 to TEventList(FList^).Count - 1 do
      begin
        FEvent := TEventList(FList^).Items[i];
        case FEvent.eCircleTimeType of
          �ttSingle:
            begin // ���� ���
              Synchronize(DoSingle);
            end;
          �ttDay:
            begin // ������ ����
              Synchronize(DoDay);
            end;
          �ttWeek:
            begin // ������ ���� ������
              Synchronize(DoWeek);
            end;
          �ttMonth:
            begin // ������ ���� � ������
              Synchronize(DoMonth);
            end;
          cttFirstWDMonth:
            begin // ������ ������� ���� ������
              Synchronize(DoFirstWDMonth);
            end;
          cttLastWDMonth:
            begin // ��������� ������� ���� ������
              Synchronize(DoLastWDMonth);
            end;
        end;
      end;
    except
      on E: Exception do
        MessageBox(fmMain.Handle, PChar(fmMain.lsMain.GetCaption(42)
              + #13#10 + fmMain.lsMain.GetCaption(3) + E.Message), PChar
            (fmMain.lsMain.GetCaption(13, 2)), 48);
    end;
  end;
end;

procedure TEventThread.InitList(aList: Pointer);
begin
  try
    if aList <> nil then
    begin
      FList := aList;
      FInitiated := true;
    end
    else
    begin
      if FList <> nil then
        FInitiated := true
      else
        FInitiated := false;
    end;
  except
    on E: Exception do
      MessageBox(fmMain.Handle, PChar(fmMain.lsMain.GetCaption(42)
            + #13#10 + fmMain.lsMain.GetCaption(3) + E.Message), PChar
          (fmMain.lsMain.GetCaption(13, 2)), 48);
  end;
end;

// ����������� �������� �������
procedure TEventThread.UpdateWindow;
begin
  fmMain.stsBar.Panels[0].Text := FormatDateTime('dddddd - tt', FTime);
end;

{ TEvent }

procedure TEvent.EventChange(Sender: TObject);
begin
  if fmMain.EventList.AutoSave then
    fmMain.EventList.SaveEvents;
end;

procedure TEvent.SetEType(const Value: TEventType);
begin
  FType := Value;
  if Assigned(FOnChangeEvent) then
    FOnChangeEvent(Self);
end;

procedure TEvent.SetFCircleArrDays(const Value: TCircleArrDays);
begin
  FCircleDays := Value;
  if Assigned(FOnChangeEvent) then
    FOnChangeEvent(Self);
end;

procedure TEvent.SetFCircleMonthdays(const Value: TCircleMArrDays);
begin
  FCircleMonthDays := Value;
  if Assigned(FOnChangeEvent) then
    FOnChangeEvent(Self);
end;

procedure TEvent.SetFCircleTimeType(const Value: TCircleTimeType);
begin
  FCircleTimeType := Value;
  if Assigned(FOnChangeEvent) then
    FOnChangeEvent(Self);
end;

procedure TEvent.SetFDone(const Value: boolean);
begin
  FDone := Value;
  if Assigned(FOnChangeEvent) then
    FOnChangeEvent(Self);
end;

procedure TEvent.SetFGroup(const Value: integer);
begin
  FGroup := Value;
  if Assigned(FOnChangeEvent) then
    FOnChangeEvent(Self);
end;

procedure TEvent.SetFHeader(const Value: string);
begin
  FHeader := Value;
  if Assigned(FOnChangeEvent) then
    FOnChangeEvent(Self);
end;

procedure TEvent.SetFMasg(const Value: string);
begin
  FMsg := Value;
  if Assigned(FOnChangeEvent) then
    FOnChangeEvent(Self);
end;

procedure TEvent.SetFPrgmPath(const Value: string);
begin
  FPrgmPath := Value;
  if Assigned(FOnChangeEvent) then
    FOnChangeEvent(Self);
end;

procedure TEvent.SetFReminder(const Value: TDateTime);
begin
  FReminder := Value;
  if Assigned(FOnChangeEvent) then
    FOnChangeEvent(Self);
end;

procedure TEvent.SetFStartPrgm(const Value: boolean);
begin
  FStartPrgm := Value;
  if Assigned(FOnChangeEvent) then
    FOnChangeEvent(Self);
end;

procedure TEvent.SetFTime(const Value: TDateTime);
begin
  FTime := Value;
  if Assigned(FOnChangeEvent) then
    FOnChangeEvent(Self);
end;

end.
