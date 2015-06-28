unit Unit5;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, PrintersDlgs, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, INIFiles, printers;

type

  { TForm4 }

  TForm4 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    CheckGroup1: TCheckGroup;
    GroupBox1: TGroupBox;
    Image1: TImage;
    Label1: TLabel;
    PrintDialog1: TPrintDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PrintDialog1Close(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    IniF:TINIFile;
  end;

var
  Form4: TForm4;
        p:integer;
        C:integer;

implementation

{$R *.lfm}

{ TForm4 }


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

procedure TForm4.Button3Click(Sender: TObject);
var Png: TPortableNetworkGraphic;
     i:integer;
begin
 Png := TPortableNetworkGraphic.Create;
 C:=CountFiles('C:\tmp\1');
 if printDialog1.Execute then
  begin
 For i:= 1 to C do
     if CheckGroup1.Checked[i-1] = true then
     begin
    Png.LoadFromFile('C:\tmp\1\'+ inttostr(i) +'.png');
    Printer.BeginDoc;
    Printer.Canvas.Rectangle(0,0,Printer.PageWidth-2, Printer.PageHeight-2);
    Printer.Canvas.StretchDraw(Rect(0,0,Printer.PageWidth-2, Printer.PageHeight-2), Png);
    Printer.EndDoc;
    end;
  end;
 DeleteDirectory('C:\tmp',false);
 Form4.Close;
end;

procedure TForm4.Button2Click(Sender: TObject);
begin
 p:=p+1;
 if p > CountFiles('C:\tmp\1') then p:=1;
 Image1.Picture.LoadFromFile('C:\tmp\1\'+ inttostr(p) +'.png');
 Label1.Caption:='Изображение:' + inttostr(p);

end;

procedure TForm4.Button1Click(Sender: TObject);
begin
   p:=p-1;
   if p < 1  then p:=CountFiles('C:\tmp\1');
 Image1.Picture.LoadFromFile('C:\tmp\1\'+ inttostr(p) +'.png');
 Label1.Caption:='Изображение:' + inttostr(p);

end;

procedure TForm4.Button4Click(Sender: TObject);
begin
 CheckGroup1.Items.Clear;
   DeleteDirectory('C:\tmp',false);
   Form4.Close;
end;


procedure TForm4.FormShow(Sender: TObject);
Var i:integer;
begin
 p:=1;
  Image1.Picture.LoadFromFile('C:\tmp\1\'+ inttostr(p) +'.png');
  C:=CountFiles('C:\tmp\1');
       For i:= 1 to C do
         begin
          CheckGroup1.Items.Add('Изображение: ' + inttostr(i));
         end;
end;

procedure TForm4.PrintDialog1Close(Sender: TObject);
begin

end;

end.

