unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  process, inifiles, math;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button3: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
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

implementation

{$R *.lfm}

{ TForm1 }



procedure TForm1.Button3Click(Sender: TObject);

var
  stream: TMemoryStream;
  strings: TStringList;
  BytesAvailable: Cardinal;
  i:integer;
begin

  stream  := TMemoryStream.Create;
  strings := TStringList.Create;
  stream.SetSize(streamsize);


  try
     Memo2.Lines.Add(Edit1.Text);
     AProcess.Executable:='yt-dlp.exe';
     AProcess.Parameters.Add('-o '+Edit2.Text);
     AProcess.Parameters.Add(Edit1.Text);
     AProcess.PipeBufferSize:=streamsize;
     //AProcess.ShowWindow:=swoHide;
     AProcess.Options:=[poUsePipes,poStderrToOutput];
     AProcess.Execute;
     while AProcess.Running { or (AProcess.Output.NumBytesAvailable > 0) } do
        begin
        Application.ProcessMessages;
        BytesAvailable := AProcess.Output.NumBytesAvailable;
        if BytesAvailable > 0 then
           begin
           AProcess.Output.Read(stream.Memory^, BytesAvailable);
           strings.LoadFromStream(stream);
           stream.Clear;
           for i:=0 to strings.Count-1 do
              begin
              {if length(strings[i]) > 0 then
                 Memo2.Lines.Add(strings[i]);}
              ShowMessage(strings[i]);
              end;

           end;
        end;

    except
      on e : Exception do Memo2.Lines.Add(e.Message);
    end;

  Memo2.Lines.Add('yt-dlp.exe exited with status ' + IntToStr(AProcess.ExitStatus));

  strings.Free;
  stream.Free;
end;

procedure TForm1.FormClose(Sender: TObject);
begin
  AProcess.Free;
  ini.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  AProcess := TProcess.Create(nil);
  ini:=Tinifile.Create('settings.ini');
  Edit2.Text:=ini.ReadString('File','Template','%(title)s/s%(resolution)s.%(ext)s');
end;


end.

