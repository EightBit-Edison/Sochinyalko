unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Unit1;

type

  { TSplashScreen }

  TSplashScreen = class(TForm)
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  SplashScreen: TSplashScreen;

implementation

{$R *.lfm}

{ TSplashScreen }



procedure TSplashScreen.Timer1Timer(Sender: TObject);
begin
  Form1.Show;
  Form1.Update;
  SplashScreen.Hide;
 SplashScreen.Free;
end;

procedure TSplashScreen.FormCreate(Sender: TObject);
begin

end;

end.

