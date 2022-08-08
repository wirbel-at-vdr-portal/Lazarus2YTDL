unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  process, inifiles;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    PageControl1: TPageControl;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormClose(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  cmd: string;
  ini: Tinifile;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var opt:string;
begin
  cmd := '';
  if RadioButton1.Checked      then opt := ' --ignore-errors'
  else if RadioButton2.Checked then opt := ' --abort-on-error'
  else                              opt := ' --no-abort-on-error';
  ini.WriteString('Last','Errors',opt);
  cmd += opt;

  if RadioButton4.Checked then opt := ' --force-generic-extractor'


//  memo1.Clear;


end;

procedure TForm1.Button3Click(Sender: TObject);
var
{  s:string;
  a:Array of string;

  i:integer;
begin
  b[0]:='-o '+Edit2.Text;
  b[1]:=Edit1.Text;
  Memo2.Lines.Clear();
  ini.WriteString('File','Template',Edit2.Text);
  RunCommand('yt-dlp.exe', b, s);
  s := StringReplace(s, #13, '^', [rfReplaceAll]);
  s := StringReplace(s, #10, '^', [rfReplaceAll]);
  s := StringReplace(s, '^^', '^', [rfReplaceAll]);
  a := s.Split('^');
  Memo2.Lines.Clear;
  for i:=0 to length(a) do
     if length(a[i]) > 0 then
        Memo2.Lines.Add(a[i]);
}
  b:TStringList;
  process: TProcess;
  stream: TMemoryStream;
  strings: TStringList;
  n: Integer;
  ErrMsg: PChar;
const streamsize = 16384;
begin
  b := TStringList.Create;
  b[0]:='-o '+Edit2.Text;
  b[1]:=Edit1.Text;

  process := TProcess.Create(nil);
  stream  := TMemoryStream.Create;
  strings := TStringList.Create;
  stream.SetSize(streamsize);


  try
     process.Options:=[poUsePipes,poStderrToOutput];
     process.Executable:='yt-dlp.exe';
     process.Parameters:=b;
     process.ShowWindow:=swoHide;
     process.Execute;
     while process.Running do
        begin
        n := process.Output.Read(stream.Memory^,streamsize);
          if n > 0 then
             begin
             strings.LoadFromStream(stream);
             Memo2.Lines.Add(strings.Text);
             stream.Clear;
             end
          else
             Sleep(200);
          end;

    except
       on e: EProcess do
         begin
         {$IFDEF Windows}
           //FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER or FORMAT_MESSAGE_FROM_SYSTEM,nil,GetLastError,MAKELANGID(LANG_NEUTRAL,SUBLANG_DEFAULT),@ErrMsg,0,nil);
         {$ELSE}
           ErrMsg:=@e.Message[1];
         {$ENDIF}
           WriteLn(ErrMsg);
         exit;
         end;
       on e: Exception do
         begin
           MessageDlg('Error',e.Message,mtError,[mbOK],0);
         exit;
       end;
    end;

  b.Free;

  repeat
     n := process.Output.Read(stream.Memory^,streamsize);
     if n > 0 then
        begin
        strings.LoadFromStream(stream);
        Memo2.Lines.Add(strings.Text);
        stream.Clear;
        end;
  until n<=0;

  strings.Free;
  stream.Free;
  process.Free;
end;

procedure TForm1.FormClose(Sender: TObject);
begin
  ini.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
  var s:string;
      a:Array of string;
      i:integer;
      b:Array[0..0] of string;
begin
  ini:=Tinifile.Create('settings.ini');
  Edit2.Text:=ini.ReadString('File','Template','%(title)s/s%(resolution)s.%(ext)s');



  s:=ini.ReadString('ComboBox1','Extractors','');
  if length(s) < 1 then
     begin
     b[0]:='--list-extractors';
     RunCommand('yt-dlp.exe', b, s);
     s := StringReplace(s, #13, '', [rfReplaceAll]);
     s := StringReplace(s, #10, '^', [rfReplaceAll]);
     ini.WriteString('ComboBox1','Extractors',s);
     end;

  a := s.Split('^');
  ComboBox1.Items.Clear;
  for i:=0 to length(a) do
     ComboBox1.Items.Add(a[i]);

  i:=ini.ReadInteger('ComboBox1','Selected',1);
  ComboBox1.SelLength:=1;
  ComboBox1.ItemIndex:=i;
  ComboBox1.Text:=ComboBox1.Items[ComboBox1.ItemIndex];

  s:=ini.ReadString('Last','Errors','');
  if      s = ' --ignore-errors'  then RadioButton1.Checked:=true
  else if s = ' --abort-on-error' then RadioButton2.Checked:=true
  else                                 RadioButton3.Checked:=true;


end;

procedure TForm1.RadioButton1Change(Sender: TObject);
begin

end;

end.

