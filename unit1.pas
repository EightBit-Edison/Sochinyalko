unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, PrintersDlgs, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Menus, ExtCtrls, Unit3, Unit4, Zipper, httpsend, Printers, INIFiles;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    PrintDialog1: TPrintDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);

  private
    { private declarations }
  public
    { public declarations }
    IniF:TINIFile;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

function DownloadHTTP(URL, TargetFile: string): Boolean;
var
  HTTPGetResult: Boolean;
  HTTPSender: THTTPSend;
begin
  Result := False;
  HTTPSender := THTTPSend.Create;
  try
    HTTPGetResult := HTTPSender.HTTPMethod('GET', URL);
    if (HTTPSender.ResultCode >= 100) and (HTTPSender.ResultCode<=299) then begin
      HTTPSender.Document.SaveToFile(TargetFile);
      Result := True;
    end;
  finally
    HTTPSender.Free;
  end;
end;


function GetString(URL: string): string;
var
  HTTPGetResult: Boolean;
  HTTPSender: THTTPSend;
begin
  Result := 'Error';
  HTTPSender := THTTPSend.Create;
  try
    HTTPGetResult := HTTPSender.HTTPMethod('GET', URL);
    if (HTTPSender.ResultCode >= 100) and (HTTPSender.ResultCode<=299) then begin
      Result := HTTPSender.Document.ToString;

    end;
  finally
    HTTPSender.Free;
  end;
end;

procedure unZipArch();
var
  UnZipper: TUnZipper;
 begin
   UnZipper := TUnZipper.Create;
   UnZipper.FileName := 'C:\tmp\1.zip';
   UnZipper.OutputPath := 'C:\tmp\1';
   UnZipper.UnZipAllFiles;
   UnZipper.Free;
 end;

procedure RenameAll(const ADirectory: String);
var
   Rec : TSearchRec;
   Result,sts : Integer ;
begin
   Result := 0;
   sts := FindFirst(ADirectory + '\*.*', faAnyFile, Rec);
   if sts = 0 then
     begin
       repeat
         if ((Rec.Attr and faDirectory) <> faDirectory) then
           begin
            Inc(Result);
            RenameFile(ADirectory + '\'+Rec.Name, ADirectory + '\'+IntToStr(Result)+'.png');
           end;

       until FindNext(Rec) <> 0;
       SysUtils.FindClose(Rec);
     end;
end;


function CountFiles(const ADirectory: String): Integer;
var
   Rec : TSearchRec;
   sts : Integer ;
begin
   Result := 0;
   sts := FindFirst(ADirectory + '\*.*', faAnyFile, Rec);
   if sts = 0 then
     begin
       repeat
         if ((Rec.Attr and faDirectory) <> faDirectory) then
            Inc(Result)
            else if (Rec.Name <> '.') and (Rec.Name <> '..') then
            Result := Result + CountFiles(ADirectory + '\'+ Rec.Name);
       until FindNext(Rec) <> 0;
       SysUtils.FindClose(Rec);
     end;
end;

procedure TForm1.MenuItem4Click(Sender: TObject);
begin
  Form2.Show;
end;

procedure TForm1.MenuItem5Click(Sender: TObject);
begin
  close;
end;

procedure TForm1.Button1Click(Sender: TObject);
var Png: TPortableNetworkGraphic;
     C:integer;
     i:integer;
     f:text;
     s,s2:string;
begin
  INiF.WriteString('Last','family',Edit1.Text);
  INiF.WriteString('Last','name',Edit2.Text);
  INiF.WriteString('Last','otchestvo',Edit3.Text);
  INiF.WriteString('Last','passport',Edit4.Text);
  CreateDir('C:\tmp');
  s:=INiF.ReadString('Credentials','login','Error');
  s2:=INiF.ReadString('Credentials','password','Error');
 if DownloadHTTP('http://myswsu.ru/arch.php?fam='+Edit1.Text+'&name='+Edit2.Text+'&otc='+Edit3.Text+'&doc='+Edit4.Text+'&login='+s+'&password='+s2, 'C:\tmp\1.txt') then
 begin
  DownloadHTTP('http://myswsu.ru/1.zip', 'C:\tmp\1.zip');
  UnzipArch();

 Png := TPortableNetworkGraphic.Create;
 RenameAll('C:\tmp\1');
 C:=CountFiles('C:\tmp\1');
 if printDialog1.Execute then
  begin
 For i:= 1 to C do
     begin
    Png.LoadFromFile('C:\tmp\1\'+ inttostr(i) +'.png');
    Printer.BeginDoc;
    Printer.Canvas.Rectangle(0,0,Printer.PageWidth-2, Printer.PageHeight-2);
    Printer.Canvas.StretchDraw(Rect(0,0,Printer.PageWidth-2, Printer.PageHeight-2), Png);
    Printer.EndDoc;
    end;
  end;
 end
 else
 begin
   showmessage('Ошибка доступа к сети');
 end;
 DeleteDirectory('C:\tmp',false);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Edit1.Text:=INiF.ReadString('Last','family','');
  Edit2.Text:=INiF.ReadString('Last','name','');
  Edit3.Text:=INiF.ReadString('Last','otchestvo','');
  Edit4.Text:=INiF.ReadString('Last','passport','');
end;

procedure TForm1.FormCreate(Sender: TObject);
var
     s:string;
begin
  if Application.HasOption('n','name') then
  begin
    Edit2.Text:=Application.GetOptionValue('n','name');
  end;
  if Application.HasOption('f','family') then
  begin
    Edit1.Text:=Application.GetOptionValue('f','family');
  end;
  if Application.HasOption('o','otchestvo') then
  begin
    Edit3.Text:=Application.GetOptionValue('o','otchestvo');
  end;
  if Application.HasOption('p','passport') then
  begin
    Edit4.Text:=Application.GetOptionValue('p','passport');
  end;
   IF(FileExists('settings.ini'))then
   begin
        Inif := TINIFile.Create('settings.ini');
        s:=INiF.ReadString('Last','family','Error');
        if s<>'Error' then Form1.Button2.Enabled:=true;;
   end;
end;

procedure TForm1.Image1Click(Sender: TObject);
begin

end;

procedure TForm1.MenuItem3Click(Sender: TObject);
begin
  Form3.Show;
end;

end.

