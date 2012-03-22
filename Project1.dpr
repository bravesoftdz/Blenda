program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  tubus_lib in 'tubus_lib.pas',
  Unit2 in 'Unit2.pas' {Form2},
  raster_matrix_lib in 'raster_matrix_lib.pas',
  table_func_lib in 'table_func_lib.pas',
  colorimetry_lib in 'colorimetry_lib.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
