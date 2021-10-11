unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FileCtrl, ExtCtrls, ID3v2, XPMan, Menus;

type
  TMainForm = class(TForm)
    DriveList: TDriveComboBox;
    FolderList: TDirectoryListBox;
    FileList: TFileListBox;
    XPManifest1: TXPManifest;
    GroupBox1: TGroupBox;
    TitleLabel: TLabel;
    TitleEdit: TEdit;
    ArtistLabel: TLabel;
    ArtistEdit: TEdit;
    AlbumLabel: TLabel;
    AlbumEdit: TEdit;
    TrackLabel: TLabel;
    TrackEdit: TEdit;
    YearLabel: TLabel;
    YearEdit: TEdit;
    GenreLabel: TLabel;
    GenreEdit: TEdit;
    SaveButton: TButton;
    GroupBox2: TGroupBox;
    Button3: TButton;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Edit3: TEdit;
    Edit4: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Edit5: TEdit;
    Label6: TLabel;
    Edit6: TEdit;
    Edit7: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    Edit8: TEdit;
    Edit9: TEdit;
    Label9: TLabel;
    Edit10: TEdit;
    Label10: TLabel;
    Button1: TButton;
    CheckBox1: TCheckBox;
    CheckBox3: TCheckBox;
    Edit11: TEdit;
    Label11: TLabel;
    Edit12: TEdit;
    CheckBox4: TCheckBox;
    Label12: TLabel;
    Label13: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FileListChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SaveButtonClick(Sender: TObject);
    function ChangeLowToUpper(s: string): string;
    function ChangeStringToString(str,str1,str2: string):string;
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CheckBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CheckBox3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CheckBox4MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    FileTag: TID3v2;
    procedure ClearAll;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.ClearAll;
begin
  { Clear all captions }
  TitleEdit.Text := '';
  ArtistEdit.Text := '';
  AlbumEdit.Text := '';
  TrackEdit.Text := '';
  YearEdit.Text := '';
  GenreEdit.Text := '';
  Edit5.Text := '';
  Edit6.Text := '';
  Edit7.Text := '';
  Edit8.Text := '';
  Edit9.Text := '';
  Edit10.Text := '';
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  { Create object and clear captions }
  FileTag := TID3v2.Create;
  ClearAll;
end;

procedure TMainForm.FileListChange(Sender: TObject);
begin
  ClearAll;
  if FileList.FileName = '' then exit;
  if FileExists(FileList.FileName) then
    if FileTag.ReadFromFile(FileList.FileName) then
      if FileTag.Exists then
      begin
        TitleEdit.Text := FileTag.Title;
        ArtistEdit.Text := FileTag.Artist;
        Edit1.Text:=FileTag.Artist;
        AlbumEdit.Text := FileTag.Album;
        Edit2.Text := FileTag.Album;
        if FileTag.Track > 0 then TrackEdit.Text := IntToStr(FileTag.Track);
        YearEdit.Text := FileTag.Year;
        Edit3.Text := FileTag.Year;
        GenreEdit.Text := FileTag.Genre;
        Edit4.Text := FileTag.Genre;
        Edit5.Text := FileTag.Comment;
        Edit6.Text := FileTag.Composer;
        Edit7.Text := FileTag.Encoder;
        Edit8.Text := FileTag.Copyright;
        Edit9.Text := FileTag.Language;
        Edit10.Text := FileTag.Link;
      end
      else
    else
      ShowMessage('Can not read tag from the file: ' + FileList.FileName)
  else
    ShowMessage('The file does not exist: ' + FileList.FileName);
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FileTag.Free;
end;

procedure TMainForm.SaveButtonClick(Sender: TObject);
var
  Value, Code: Integer;
begin
  FileTag.Title := TitleEdit.Text;
  FileTag.Artist := ArtistEdit.Text;
  FileTag.Album := AlbumEdit.Text;
  Val(TrackEdit.Text, Value, Code);
  if (Code = 0) and (Value > 0) then FileTag.Track := Value
  else FileTag.Track := 0;
  FileTag.Year := YearEdit.Text;
  FileTag.Genre := GenreEdit.Text;
  if (not FileExists(FileList.FileName)) or
    (not FileTag.SaveToFile(FileList.FileName)) then
    ShowMessage('Can not save tag to the file: ' + FileList.FileName);
  FileListChange(Self);
end;

function TMainForm.ChangeLowToUpper(s: string): string;
const
  Symbols = ' _;.,1234567890';
var
  X: Integer;
begin
  Result := '';
  if Length(s) = 0 then
    exit;
  S[1] := AnsiUpperCase(s[1])[1];
  for X := 1 to length(s) do
    if POS(S[x], Symbols) <> 0 then begin
      if X <> Length(s) then
        S[x + 1] := AnsiUpperCase(s[x + 1])[1];
    end
    else
      S[x + 1] := AnsiLowerCase(S[x + 1])[1];
  Result := S;
end;

function TMainForm.ChangeStringToString(str, str1, str2: string): string;
var
  P, L: Integer;
begin
  Result := str;
  L := Length(Str1);
  repeat
    P := Pos(Str1, Result);
    if P > 0 then
    begin
      Delete(Result, P, L);
      Insert(Str2, Result, P);
    end;
  until P = 0;
end;

procedure TMainForm.Button3Click(Sender: TObject);
var
  FT: TID3v2;
  i,j,num,len: integer;
  Title: string;
begin
  FT:=TID3v2.Create;
  i:=FileList.Count;
  if CheckBox3.Checked then begin
    for j:=0 to i-1 do begin
      FT.ReadFromFile(FileList.Items.Strings[j]);
      Title:=ChangeStringToString(FT.Title,Edit11.Text,Edit12.Text);
      FT.Title:=Title;
      FT.SaveToFile(FileList.Items.Strings[j])
    end;
  end;
  if CheckBox1.Checked then begin
    for j:=0 to i-1 do begin
      FT.ReadFromFile(FileList.Items.Strings[j]);
      Title:=ChangeLowToUpper(FT.Title);
      FT.Title:=Title;
      FT.SaveToFile(FileList.Items.Strings[j])
    end;
  end;
  FT:=TID3v2.Create;
  for j:=0 to i-1 do begin
    FT.ReadFromFile(FileList.Items.Strings[j]);
    Title:=FT.Title;
    num:=FT.Track;
    len:=Length(IntToStr(num));
    if len=1 then
      Title:='0' + IntToStr(num) + ' ' + Title + '.mp3'
    else
      Title:=IntToStr(num) + ' ' + Title + '.mp3';
    RenameFile(FileList.Items.Strings[j],Title)
  end;
end;

procedure TMainForm.Button1Click(Sender: TObject);
var
  FT: TID3v2;
  i,j: integer;
begin
  FT:=TID3v2.Create;
  i:=FileList.Count;
  for j:=0 to i-1 do begin
    FT.ReadFromFile(FileList.Items.Strings[j]);
    FT.Artist:=Edit1.Text;
    FT.Album:=Edit2.Text;
    FT.Year:=Edit3.Text;
    FT.Genre:=Edit4.Text;
    FT.Comment:=Edit5.Text;
    FT.Composer:=Edit6.Text;
    FT.Encoder:=Edit7.Text;
    FT.Copyright:=Edit8.Text;
    FT.Language:=Edit9.Text;
    FT.Link:=Edit10.Text;
    FT.SaveToFile(FileList.Items.Strings[j])
  end;
end;

procedure TMainForm.CheckBox1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  CheckBox4.Checked:=False;
end;

procedure TMainForm.CheckBox3MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  CheckBox4.Checked:=False;
end;

procedure TMainForm.CheckBox4MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  CheckBox1.Checked:=False;
  CheckBox3.Checked:=False;
end;

end.
