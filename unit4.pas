unit Unit4;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, INIFiles;

type

  { TForm3 }

  TForm3 = class(TForm)
    Button1: TButton;
    GroupBox1: TGroupBox;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    { private declarations }
  public
    { public declarations }
    IniF:TINIFile;
  end;

var
  Form3: TForm3;

implementation

{$R *.lfm}

{ TForm3 }

procedure TForm3.FormCreate(Sender: TObject);
begin
  IF(FileExists('settings.ini'))then
   begin
        Inif := TINIFile.Create('settings.ini');
        LabeledEdit1.Text:=INiF.ReadString('Credentials','login','Error');
         LabeledEdit2.Text:=INiF.ReadString('Credentials','password','Error');
   end;
end;

procedure TForm3.Button1Click(Sender: TObject);
begin
  INiF.WriteString('Credentials','login',LabeledEdit1.Text);
  INiF.WriteString('Credentials','password',LabeledEdit2.Text);
  Close;
end;

end.

