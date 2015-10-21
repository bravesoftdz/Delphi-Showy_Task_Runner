{
  Showy Task Runner v.0.2 alfa
  @author: scribe
  @date: 15.09.2015
  Delphi 2010

  Description: программа для управления заданиями на работе (по сути будильник)

  Юнит для создания/редактирования группы
}
unit uGroup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls,
  uTR;

type
  TfmGroup = class(TForm)
    pnlMain: TPanel;
    pnlControl: TPanel;
    btnOk: TBitBtn;
    btnCancel: TBitBtn;
    edName: TEdit;
    lblName: TLabel;
    lblGroup: TLabel;
    cmbGroup: TComboBox;
    lblFont: TLabel;
    btnFont: TButton;
    fdGroup: TFontDialog;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnFontClick(Sender: TObject);
  private
    FFont: TFont;
    function GetGroupIdByIndex(const Index: integer): integer;
  public
    procedure UpdateLang;
  end;

function ShowGroupCreationDialog(var aGroups: TGroupList;
  const aParentId: integer = 0): boolean;
function ShowGroupEditingDialog(var aGroups: TGroupList; const aId: integer)
  : boolean;

implementation

uses
  uMain;
{$R *.dfm}

function ShowGroupCreationDialog(var aGroups: TGroupList;
  const aParentId: integer): boolean;
var
  i, gId: integer;
begin
  with TfmGroup.Create(Application) do
    try
      Result := false;
      UpdateLang;
      Caption := fmMain.lsMain.GetCaption(69);
      for i := 0 to aGroups.Count - 1 do
      begin
        cmbGroup.Items.Add(aGroups.Items[i].Name + ' |' + inttostr
            (aGroups.Items[i].Id));
        if aGroups.Items[i].Id = aParentId then
          cmbGroup.ItemIndex := i;
      end;
      if ShowModal = mrOk then
      begin
        gId := aGroups.AddGroup(edName.Text, GetGroupIdByIndex
            (cmbGroup.ItemIndex));
        if gId <> 0 then
          aGroups.Items[aGroups.GetGroupIndex(gId)].SetGroupFont(fdGroup.Font);
        Result := true;
      end;
    finally
      Free;
    end;
end;

function ShowGroupEditingDialog(var aGroups: TGroupList; const aId: integer)
  : boolean;
var
  i: integer;
begin
  with TfmGroup.Create(Application) do
    try
      Result := false;
      UpdateLang;
      Caption := fmMain.lsMain.GetCaption(69, 1);
      edName.Text := aGroups.Items[aGroups.GetGroupIndex(aId)].Name;
      fdGroup.Font.Assign(aGroups.Items[aGroups.GetGroupIndex(aId)]
          .GetGroupFont);
      for i := 0 to aGroups.Count - 1 do
      begin
        cmbGroup.Items.Add(aGroups.Items[i].Name + ' |' + inttostr
            (aGroups.Items[i].Id));
        if aGroups.Items[i].Id = aGroups.Items[aGroups.GetGroupIndex(aId)]
          .ParentId then
          cmbGroup.ItemIndex := i;
      end;
      if ShowModal = mrOk then
      begin
        aGroups.Items[aGroups.GetGroupIndex(aId)].Name := edName.Text;
        aGroups.Items[aGroups.GetGroupIndex(aId)].ParentId := GetGroupIdByIndex
          (cmbGroup.ItemIndex);
        aGroups.Items[aGroups.GetGroupIndex(aId)].SetGroupFont(fdGroup.Font);
        Result := true;
      end;
    finally
      Free;
    end;
end;

procedure TfmGroup.btnFontClick(Sender: TObject);
begin
  fdGroup.Execute(Self.Handle);
end;

procedure TfmGroup.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

// Возвращает айди по индексу в объектном списке
function TfmGroup.GetGroupIdByIndex(const Index: integer): integer;
var
  aline: string;
  pos1: integer;
begin
  Result := -1;
  try
    aline := cmbGroup.Items.Strings[Index];
    pos1 := LastPos('|', aline);
    Result := strtoint(copy(aline, pos1 + 1, Length(aline) - pos1));
  except
    on E: Exception do
      Result := -1;
  end;
end;

procedure TfmGroup.UpdateLang;
begin
  if not fmMain.lsMain.LangLoaded then
    Exit;
  lblName.Caption := fmMain.lsMain.GetCaption(29);
  edName.Text := fmMain.lsMain.GetCaption(1);
  lblGroup.Caption := fmMain.lsMain.GetCaption(31);
  lblFont.Caption := fmMain.lsMain.GetCaption(69, 3);
end;

end.
