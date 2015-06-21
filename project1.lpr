program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, printer4lazarus, Unit1, Unit2, Unit3
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  SplashScreen := TSplashScreen.Create(nil) ;
 SplashScreen.Show;
 SplashScreen.Update;
   Application.CreateForm(TForm1, Form1);
   SplashScreen.Hide;
 SplashScreen.Free;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.

