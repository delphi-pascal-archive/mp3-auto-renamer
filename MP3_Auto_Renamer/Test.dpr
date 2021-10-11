program Test;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  ID3v2 in 'ID3v2.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'MP3 Auto Renamer';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
