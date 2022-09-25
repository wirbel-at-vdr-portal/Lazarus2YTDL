unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  process, inifiles;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button3: TButton;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Memo2: TMemo;
    procedure Button3Click(Sender: TObject);
    procedure FormClose(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure YtdlpUpdate;
  private
  public
  end;

  TStringPair = record
    arg:string;
    comment:string;
  end;

const
  YT_Formats: array[0..6] of TStringPair = (
       (arg:' ';               comment:'default'),
       (arg:'-f "bv+ba/b"';    comment:'merge best video, best audio'),
       (arg:'-S "+res"';       comment:'best video with smallest resolution'),
       (arg:'-S "+size,+br"';  comment:'smallest video available'),
       (arg:'-S "height:480"'; comment:'best video no better than 480p'),
       (arg:'-f ba';           comment:'best audio only'),
       (arg:'-f "mp3/aac"';    comment:'best mp3 or aac audio')
    );

var
  Form1: TForm1;
  cmd: string;
  ini: Tinifile;
  AProcess: TProcess;

const
  streamsize = 4194304;



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
     ini.WriteString('File','Last',Edit1.Text);
     ini.WriteString('File','Template',Edit2.Text);
     if ComboBox1.ItemIndex<>-1 then
        begin
        ini.WriteInteger('Format','Selection',ComboBox1.ItemIndex);
        ini.WriteString('Format','Description',ComboBox1.Items[ComboBox1.ItemIndex]);
        end;
     Memo2.Lines.Clear;
     Memo2.Lines.Add(Edit1.Text);
     AProcess.Parameters.Clear;
     AProcess.Parameters.Add('-o '+Edit2.Text);
     AProcess.Parameters.Add(Edit1.Text);
     if ComboBox1.ItemIndex<>-1 then
        AProcess.Parameters.Add(YT_Formats[ComboBox1.ItemIndex].arg);
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
  i:integer;
  d,interval:TDateTime;
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

  Edit1.Text:=ini.ReadString('File','Last','');
  Edit2.Text:=ini.ReadString('File','Template','%(title)s/%(resolution)s.%(ext)s');

  for i:=0 to length(YT_Formats)-1 do
     ComboBox1.Items.Add(YT_Formats[i].comment);
  ComboBox1.ItemIndex:=ini.ReadInteger('Format','Selection',0);
  if ComboBox1.ItemIndex<>-1 then
     ComboBox1.Text:=ComboBox1.Items[ComboBox1.ItemIndex];

  d:=ini.ReadDateTime('Update','yt-dlp',now-365);
  interval:=ini.ReadFloat('Update','CheckInterval',0.0);
  if interval < 1.0 then
     begin
     interval := 7.0;
     ini.WriteFloat('Update','CheckInterval',interval);
     end;
  if (now-d) > interval then
     begin
     if MessageDlg('Last yp-dlp Update check older than one week. Should i check for an Update?',
                   mtConfirmation, mbOkCancel , 0) = mrOk then YtdlpUpdate;
     ini.WriteDateTime('Update','yt-dlp',now);
     end;
end;


procedure TForm1.FormClose(Sender: TObject);
begin
  AProcess.Free;
  ini.Free;
end;

procedure TForm1.YtdlpUpdate;
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
  Memo2.Lines.Add('Start yt-dlp update.');

  try
     AProcess.Parameters.Add('--update');
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
end;



end.

