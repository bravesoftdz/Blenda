unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TeEngine, Series, ExtCtrls, TeeProcs, Chart, StdCtrls, ExtDlgs,table_func_lib;

type
  TForm2 = class(TForm)
    Chart1: TChart;
    btnSaveBmp: TButton;
    btnSaveTxt: TButton;
    SavePictureDialog1: TSavePictureDialog;
    SaveDialog1: TSaveDialog;
    procedure btnSaveBmpClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSaveTxtClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;
  data: table_func;
  ser: array of TLineSeries;
implementation

{$R *.dfm}

procedure TForm2.btnSaveBmpClick(Sender: TObject);
begin
  if SavePictureDialog1.Execute then
    Chart1.SaveToBitmapFile(SavePictureDialog1.FileName);
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  data:=table_func.Create;
  data.order:=1;
//  data.chart_series:=series1;
end;

procedure TForm2.btnSaveTxtClick(Sender: TObject);
begin
  if SaveDialog1.Execute then
    data.SaveToFile(SaveDialog1.FileName); 
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin
   data.Free;
end;

end.
