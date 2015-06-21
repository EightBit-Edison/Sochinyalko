unit UnZip;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Zipper;

implementation
procedure unZipArch();
var
  UnZipper: TUnZipper;
 begin
   UnZipper := TUnZipper.Create;
   UnZipper.FileName := 'tmp\1.zip';
   UnZipper.OutputPath := 'temp\1';
   UnZipper.Examine;
   UnZipper.UnZipAllFiles;
   UnZipper.Free;
 end;

end.

