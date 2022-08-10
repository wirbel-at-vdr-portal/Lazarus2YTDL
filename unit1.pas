unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  process, inifiles;

type

  TForm1 = class(TForm)
    Button3: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Memo2: TMemo;
    procedure Button3Click(Sender: TObject);
    procedure FormClose(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
  public
  end;

var
  Form1: TForm1;
  cmd: string;
  ini: Tinifile;
  AProcess: TProcess;

const streamsize = 4194304;

{ forward declarations. }


implementation

{$R *.lfm}


procedure TForm1.Button3Click(Sender: TObject);
var
  strings:TStringList;
  BytesAvailable:Cardinal;
  i:integer;
  buffer:array[0..4194303] of char;
begin
  strings:=TStringList.Create;
  strings.StrictDelimiter:=true;
  strings.Delimiter:=#13;
  buffer[0]:=#0; // silence compiler.

  try
     ini.WriteString('File','Template',Edit2.Text);
     Memo2.Lines.Clear;
     Memo2.Lines.Add(Edit1.Text);
     AProcess.Parameters.Clear;
     AProcess.Parameters.Add('-o '+Edit2.Text);
     AProcess.Parameters.Add(Edit1.Text);
     AProcess.Execute;
     while AProcess.Running do
        begin
        Application.ProcessMessages;
        BytesAvailable := AProcess.Output.NumBytesAvailable;
        if BytesAvailable > 0 then
           begin
           AProcess.Output.Read(buffer, BytesAvailable);
           strings.DelimitedText:=buffer;
           for i:=0 to strings.Count-1 do
              begin
              if length(strings[i]) > 0 then
                 Memo2.Lines.Add(strings[i]);
              end;
           end;
        end;
    except
      on e : Exception do Memo2.Lines.Add(e.Message);
    end;

  strings.Free;

  if (AProcess.ExitStatus <> 0) then
     Memo2.Lines.Add('yt-dlp.exe exited with status ' + IntToHex(AProcess.ExitStatus,8))
  else
     Memo2.Lines.Add('yt-dlp.exe exited sucessfully.');
end;


procedure TForm1.FormCreate(Sender: TObject);
var
  AppConfigDir:string;
  AppConfigFile:string;
begin
  AProcess := TProcess.Create(nil);
  AProcess.Executable:='yt-dlp.exe';
  AProcess.ShowWindow:=swoHide;
  AProcess.PipeBufferSize:=streamsize;
  AProcess.Options:=[poUsePipes,poStderrToOutput];

  AppConfigDir:=GetAppConfigDir(false);
  if not DirectoryExists(AppConfigDir) then
     begin
     if not CreateDir(AppConfigDir)  then
        ShowMessage('Could not create ' + AppConfigDir);
     end;

  AppConfigFile:=AppConfigDir + '\settings.ini';
  DoDirSeparators(AppConfigFile);
  ini:=Tinifile.Create(AppConfigFile);
  Edit2.Text:=ini.ReadString('File','Template','%(title)s/%(resolution)s.%(ext)s');
end;


procedure TForm1.FormClose(Sender: TObject);
begin
  AProcess.Free;
  ini.Free;
end;


end.

