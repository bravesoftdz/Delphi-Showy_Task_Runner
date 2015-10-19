{
  uSetConvert
  @author: scribe
  @date: 15.09.2015
  Delphi 2010

  Description: Преобразовывание Set типа в строку

}
unit uSetConvert;

interface

uses
  TypInfo, SysUtils;

function SetToString(Info: PTypeInfo; const SetParam; Brackets: Boolean)
  : AnsiString;
procedure StringToSet(Info: PTypeInfo; var SetParam; const Value: AnsiString);

implementation

function GetOrdValue(Info: PTypeInfo; const SetParam): Integer;
begin
  Result := 0;
  case GetTypeData(Info)^.OrdType of
    otSByte, otUByte:
      Result := Byte(SetParam);
    otSWord, otUWord:
      Result := Word(SetParam);
    otSLong, otULong:
      Result := Integer(SetParam);
  end;
end;

procedure SetOrdValue(Info: PTypeInfo; var SetParam; Value: Integer);
begin
  case GetTypeData(Info)^.OrdType of
    otSByte, otUByte:
      Byte(SetParam) := Value;
    otSWord, otUWord:
      Word(SetParam) := Value;
    otSLong, otULong:
      Integer(SetParam) := Value;
  end;
end;

function SetToString(Info: PTypeInfo; const SetParam; Brackets: Boolean)
  : AnsiString;
var
  S: TIntegerSet;
  TypeInfo: PTypeInfo;
  I: Integer;
begin
  Result := '';
  Integer(S) := GetOrdValue(Info, SetParam);
  TypeInfo := GetTypeData(Info)^.CompType^;
  for I := 0 to SizeOf(Integer) * 8 - 1 do
    if I in S then
    begin
      if Result <> '' then
        Result := Result + ',';
      Result := Result + GetEnumName(TypeInfo, I);
    end;
  if Brackets then
    Result := '[' + Result + ']';
end;

procedure StringToSet(Info: PTypeInfo; var SetParam; const Value: AnsiString);
var
  P: PAnsiChar;
  EnumInfo: PTypeInfo;
  EnumName: AnsiString;
  EnumValue, SetValue: Longint;

  function NextWord(var P: PAnsiChar): AnsiString;
  var
    I: Integer;
  begin
    I := 0;
    // scan til whitespace
    while not(P[I] in [',', ' ', #0, ']']) do
      Inc(I);
    SetString(Result, P, I);
    // skip whitespace
    while P[I] in [',', ' ', ']'] do
      Inc(I);
    Inc(P, I);
  end;

begin
  SetOrdValue(Info, SetParam, 0);
  if Value = '' then
    Exit;

  SetValue := 0;
  P := PAnsiChar(Value);
  // skip leading bracket and whitespace
  while P^ in ['[', ' '] do
    Inc(P);
  EnumInfo := GetTypeData(Info)^.CompType^;
  EnumName := NextWord(P);
  while EnumName <> '' do
  begin
    EnumValue := GetEnumValue(EnumInfo, EnumName);
    if EnumValue < 0 then
    begin
      SetOrdValue(Info, SetParam, 0);
      Exit;
    end;
    Include(TIntegerSet(SetValue), EnumValue);
    EnumName := NextWord(P);
  end;
  SetOrdValue(Info, SetParam, SetValue);
end;

end.
