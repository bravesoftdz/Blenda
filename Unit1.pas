unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls,tubus_lib, StdCtrls,colorimetry_lib,math,unit2,raster_matrix_lib,
  ComCtrls,chart,TeeProcs,Series;

type
  TForm1 = class(TForm)
    Image1: TImage;
    btnTrace: TButton;
    lblRaysCount: TLabel;
    Button1: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    txtWidth: TLabeledEdit;
    Label1: TLabel;
    cmbShape: TComboBox;
    txtDepth: TLabeledEdit;
    txtReflectance: TLabeledEdit;
    TabSheet2: TTabSheet;
    txtSuperSample: TLabeledEdit;
    txtResX: TLabeledEdit;
    txtResY: TLabeledEdit;
    txtAngleIter: TLabeledEdit;
    TabSheet3: TTabSheet;
    txtAlpha: TLabeledEdit;
    txtAngSize: TLabeledEdit;
    txtFOV: TLabeledEdit;
    txtRotation: TLabeledEdit;
    TabSheet4: TTabSheet;
    imgAperturePreview: TImage;
    txtDiffusionReflectance: TLabeledEdit;
    txtShapeAngle: TLabeledEdit;
    RadioGroup1: TRadioGroup;
    rdTimes: TRadioButton;
    rdDb: TRadioButton;
    rdApMag: TRadioButton;
    txtMaxAngle: TLabeledEdit;
    chkRotIter: TCheckBox;
    txtRotIter: TLabeledEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnTraceClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure txtDepthChange(Sender: TObject);
    procedure txtReflectanceChange(Sender: TObject);
    procedure cmbShapeChange(Sender: TObject);
    procedure txtWidthChange(Sender: TObject);
    procedure txtShapeAngleChange(Sender: TObject);
    procedure txtDiffusionReflectanceChange(Sender: TObject);
    procedure chkRotIterClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  

var
  Form1: TForm1;
  tubus: TTubus;
  colorimetry: colorimetry_funcs;
  cmos: raster_matrix;
implementation

{$R *.dfm}


function ToFloat(s: string): Real;
var y: Extended;
begin
  if TryStrToFloat(s,y) then
    ToFloat:=y;
end;

procedure assemble_tubus;
var i,sh: Integer;
    size,a,b,init_angle: Real;
begin
  tubus.delete_planes;
  Case form1.cmbShape.ItemIndex of
    0: sh:=6;
    1: sh:=4;
    2: sh:=3;
  end;
  size:=ToFloat(form1.txtWidth.Text);
  init_angle:=ToFloat(form1.txtShapeAngle.Text)*pi/180;
  a:=size/2/sin(pi/sh);
  b:=2*pi/sh;
  for i:=0 to sh-1 do begin
    tubus.add_simple(a*cos(i*2*pi/sh+init_angle),a*sin(i*2*pi/sh+init_angle),a*cos((i-1)*2*pi/sh+init_angle),a*sin((i-1)*2*pi/sh+init_angle));
  end;
  tubus.rect:=form1.ImgAperturePreview.ClientRect;
  tubus.draw_input_aperture;
end;



procedure TForm1.FormCreate(Sender: TObject);
var i: Integer;
begin
  colorimetry:=colorimetry_funcs.Create;
  cmos:=raster_matrix.Create;

  tubus:=TTubus.Create;
  tubus.tubus_length:=70;
  tubus.refl:=0.05;
  tubus.epsilon:=0.01;

(*
//рисование квадрата
  tubus.add_simple(1,1,1,-1);
  tubus.add_simple(1,-1,-1,-1);
  tubus.add_simple(-1,-1,-1,1);
  tubus.add_simple(-1,1,1,1);
*)
//  tubus.delete_planes;
  for i:=0 to 5 do begin
    tubus.add_simple(2.5*cos(i*2*pi/6),2.5*sin(i*2*pi/6),2.5*cos((i-1)*2*pi/6),2.5*sin((i-1)*2*pi/6));
  end;

  


end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  tubus.Free;
  colorimetry.Free;
  cmos.Free;
end;

procedure TForm1.btnTraceClick(Sender: TObject);
var alpha_0,alpha,angsize,alpha_inc,alpha_max: Real;
    beta,beta_max,beta_inc :Real;
    rotate,fov: Real;
    initial,incident,output: TRay;
    i,j,angle_iter :Integer;
    x,y,superscale,ss,inv_s,a,b: Real;
    rays_count: Integer;
    lum_count: Real;
    out_aperture: array of array of Real;
    out_xr,out_yr: Real;
    out_x,out_y: Integer;
    w,h,sw,sh :Integer;
begin
//  w:=tubus.rect.Right-tubus.rect.Left;
//  h:=tubus.rect.Bottom-tubus.rect.Top;
  w:=StrToInt(txtResX.Text);
  h:=StrToInt(txtResY.Text);
  fov:=StrToFloat(txtFov.Text)*pi/360;
  //светоприемная матрица
  cmos.left:=-fov;
  cmos.right:=fov;
  cmos.top:=-fov;
  cmos.bottom:=fov;
  cmos.Rect:=Rect(w+20,0,2*w+20,h);
  cmos.Img:=Image1.Canvas;
  //тем самым мы привязали "матрицу" к положенному месту на экране
  //и к диапазону углов, который она должна отобразить
  cmos.Clear;
  //сбросили старое изображение

  tubus.rect:=Rect(0,0,w,h);
  //теперь tubus.rect содержит усеченный прямоугольник,
  //чтобы не делать лишних усилий. Масштаб и коорд. надо взять
  //именно отсюда.
  w:=tubus.rect.Right;
  h:=tubus.rect.Bottom;
  superscale:=StrToFloat(txtSuperSample.Text);
  sw:=Round(w*superscale);
  sh:=Round(h*superscale);
  ss:=tubus.scale/superscale;
  inv_s:=1/tubus.scale;
  SetLength(out_aperture,w,h);
  image1.Canvas.Brush.Color:=clblack;
  image1.Canvas.FillRect(image1.ClientRect);
  alpha_0:=StrToFloat(txtAlpha.Text)*pi/180;
  angsize:=StrToFloat(txtAngSize.Text)*pi/360; //т.е +-angsize
  //пока опустим цикл по углам, только по апертуре

  angle_iter:=StrToInt(txtAngleIter.Text);

  alpha_max:=alpha_0+angsize;
  alpha_0:=alpha_0-angsize;
  alpha_inc:=2*angsize/(angle_iter-1);
  if alpha_inc=0 then alpha_inc:=1; //если точ. источник, цикл вырождается в одну итер.


  beta_max:=angsize;
  beta:=-angsize;
  beta_inc:=2*angsize/(angle_iter-1);
  if beta_inc=0 then beta_inc:=1;



  rotate:=StrToFloat(txtRotation.Text)*pi/180;

  rays_count:=0;
  lum_count:=0;

  while beta<=beta_max do begin
    alpha:=alpha_0;
    while alpha<=alpha_max do begin

      initial.nx:=sin(alpha);
      initial.ny:=sin(beta)*cos(alpha);
      initial.nz:=cos(beta)*cos(alpha);

      incident.nx:=initial.nx*cos(rotate)+initial.ny*sin(rotate);
      incident.ny:=-initial.nx*sin(rotate)+initial.ny*cos(rotate);
      incident.nz:=initial.nz;

      incident.I:=incident.nz;
      incident.z:=0;



      for i:=1 to sw-1 do begin
        x:=tubus.left+ss*i;
        for j:=1 to sh-1 do begin
          y:=tubus.top+ss*j;
          if tubus.paranoia_input_aperture(x,y) then begin
            inc(rays_count);
            incident.x:=x;
            incident.y:=y;
            output:=tubus.trace(incident);
            lum_count:=lum_count+output.I;

            out_xr:=(output.x-tubus.left)*inv_s;
            out_yr:=(output.y-tubus.top)*inv_s;
            out_x:=Floor(out_xr);
            out_y:=Floor(out_yr);
            if (out_x>=0) and (out_y>=0) and (out_x<(w-1)) and (out_y<(h-1)) then begin

              a:=out_xr-out_x;
              b:=out_yr-out_y;
              out_aperture[out_x,out_y]:=out_aperture[out_x,out_y]+output.I*(1-a)*(1-b);
              out_aperture[out_x+1,out_y]:=out_aperture[out_x+1,out_y]+output.I*a*(1-b);
              out_aperture[out_x,out_y+1]:=out_aperture[out_x,out_y+1]+output.I*(1-a)*b;
              out_aperture[out_x+1,out_y+1]:=out_aperture[out_x+1,out_y+1]+output.I*a*b;

    //          out_aperture[out_x,out_y]:=out_aperture[out_x,out_y]+output.I;
            end;
            cmos.addvalue(output.nx,output.ny,output.I);


          end;
        end;
      end;
      alpha:=alpha+alpha_inc;
    end;

    beta:=beta+beta_inc;
  end;


  lblRaysCount.Caption:='Коэф. пропускания: '+FloatToStr(lum_count/rays_count);

  lum_count:=-1;
  for i:=0 to w-1 do begin
    for j:=0 to h-1 do begin
      if out_aperture[i,j]>lum_count then lum_count:=out_aperture[i,j];
    end;
  end;

//  lum_count:=1;
  if lum_count>0 then begin
    for i:=0 to w-1 do begin
      for j:=0 to h-1 do begin
        rays_count:=colorimetry.gamma(out_aperture[i,j]/lum_count);
        image1.Canvas.Pixels[i+tubus.rect.Left,j+tubus.rect.top]:=RGB(rays_count,rays_count,rays_count);
      end;
    end;
  end;
//  cmos.draw;

end;

procedure TForm1.FormShow(Sender: TObject);
begin
  Form1.WindowState:=wsMaximized;
  tubus.Img:=imgAperturePreview.Canvas;
  tubus.rect:=imgAperturePreview.ClientRect;
  tubus.draw_input_aperture;
//  assemble_tubus;
end;

procedure TForm1.Button1Click(Sender: TObject);
var alpha_0,alpha,angsize,alpha_inc,alpha_max,max_angle: Real;
    beta,beta_max,beta_inc :Real;
    rotate: Real;
    initial,incident,output: TRay;
    i,j,angle_iter :Integer;
    x,y,superscale,ss,inv_s,a,b: Real;
    rays_count: Integer;
    lum_count: Real;
    out_xr,out_yr: Real;
    out_x,out_y: Integer;
    w,h,sw,sh :Integer;
    deg_alpha: Integer;
    coeff: Real;
    cas: Integer;
    rot,rot_max,rot_incr :Real;
    iterator: Integer;
begin
  //выбор единиц измерения
  if rdTimes.Checked then cas:=0
    else if rdDb.Checked then cas:=1
      else if rdApMag.Checked then cas:=2;

  //разрешение, с каким идет моделирование
  w:=StrToInt(txtResX.Text);
  h:=StrToInt(txtResY.Text);
  tubus.rect:=Rect(0,0,w,h);
  //теперь tubus.rect содержит усеченный прямоугольник,
  //чтобы не делать лишних усилий. Масштаб и коорд. надо взять
  //именно отсюда.
  w:=tubus.rect.Right;
  h:=tubus.rect.Bottom;

  //увеличение разрешения на входе - для наилучшего качества
  //очень прожорливо
  superscale:=StrToFloat(txtSuperSample.Text);
  sw:=Round(w*superscale);
  sh:=Round(h*superscale);
  ss:=tubus.scale/superscale;
  inv_s:=1/tubus.scale;

  //  alpha_0:=StrToFloat(txtAlpha.Text)*pi/180;
  angsize:=StrToFloat(txtAngSize.Text)*pi/360; //т.е +-angsize

  //итерации по углам, для моделирования протяженных источников
  angle_iter:=StrToInt(txtAngleIter.Text);

  //итерации по повороту, но только если включена галочка
  rot:=0;
  rot_max:=pi/Length(tubus.planes);
  if chkRotIter.Checked then
    rot_incr:=rot_max/(StrToInt(txtRotIter.Text)-1)
  else rot_incr:=2*rot_max; //заведомо одна итерация
  form2.Chart1.Legend.Visible:=chkRotIter.Checked;
  for iterator:=0 to High(unit2.ser) do unit2.ser[iterator].Free;
  SetLength(unit2.ser,0); //стираем старые графики

  while rot<=rot_max do begin


  //опустошаем старые данные
    unit2.data.Clear;
  //создаем новый график, чтобы его заполнить
    iterator:=Length(unit2.ser);
    SetLength(unit2.ser,iterator+1);
    unit2.ser[iterator]:=TLineSeries.Create(form2.Chart1);
    unit2.ser[iterator].ParentChart:=form2.Chart1;
    unit2.ser[iterator].Title:='Поворот '+IntToStr(Round(rot*180/pi))+' градусов';

  max_angle:=StrToFloat(txtMaxAngle.Text);
  if max_angle>=90 then begin
    application.MessageBox('Недопустимы углы, больше или равные 90 градусов','Неверные данные',MB_OK);
    Exit;
  end;

  for deg_alpha:=0 to 100 do begin
    alpha_0:=deg_alpha*max_angle*pi/18000;
  alpha_max:=alpha_0+angsize;
  alpha_0:=alpha_0-angsize;
  alpha_inc:=2*angsize/(angle_iter-1);
  if alpha_inc=0 then alpha_inc:=1; //если точ. источник, цикл вырождается в одну итер.


  beta_max:=angsize;
  beta:=-angsize;
  beta_inc:=2*angsize/(angle_iter-1);
  if beta_inc=0 then beta_inc:=1;



  rotate:=StrToFloat(txtRotation.Text)*pi/180;


  rays_count:=0;
  lum_count:=0;

  while beta<=beta_max do begin
    alpha:=alpha_0;
    while alpha<=alpha_max do begin

      initial.nx:=sin(alpha);
      initial.ny:=sin(beta)*cos(alpha);
      initial.nz:=cos(beta)*cos(alpha);

      incident.nx:=initial.nx*cos(rot)+initial.ny*sin(rot);
      incident.ny:=-initial.nx*sin(rot)+initial.ny*cos(rot);
      incident.nz:=initial.nz;

      incident.I:=incident.nz;
      incident.z:=0;

      for i:=1 to sw-1 do begin
        x:=tubus.left+ss*i;
        for j:=1 to sh-1 do begin
          y:=tubus.top+ss*j;
          if tubus.paranoia_input_aperture(x,y) then begin
            inc(rays_count);
            incident.x:=x;
            incident.y:=y;
            output:=tubus.trace(incident);
            lum_count:=lum_count+output.I;
          end;
        end;
      end;
      alpha:=alpha+alpha_inc;
    end;

    beta:=beta+beta_inc;
  end;

  coeff:=lum_count/rays_count;
//  form2.Series1.AddXY(deg_alpha,10*log10(coeff));
//  unit2.data.addpoint(deg_alpha,10*log10(coeff));
    Case cas of
      0: begin unit2.data.addpoint(deg_alpha*max_angle/100,coeff); unit2.data.addpoint(-deg_alpha*max_angle/100,coeff); end; 
      1: begin
      if coeff=0 then break
      else unit2.data.addpoint(deg_alpha*max_angle/100,10*log10(coeff));
      end;
      2: begin
      if coeff=0 then break
      else unit2.data.addpoint(deg_alpha*max_angle/100,log10(coeff)/log10(2.512));
      end;
    end;


  end;
  //конец внут. циклов для построения одной линии графика
  unit2.data.chart_series:=unit2.ser[iterator];
  unit2.data.draw;

  rot:=rot+rot_incr;
    
  end;
  //построены все графики




  Case cas of
    0:  form2.Chart1.LeftAxis.Title.Caption:='Коэф. пропускания';
    1: form2.Chart1.LeftAxis.Title.Caption:='Коэф. пропускания, Дб';
    2: form2.chart1.LeftAxis.Title.Caption:='Коэф. пропускания, зв. вел';
  end;

//  unit2.data.draw;
  form2.ShowModal;
end;

procedure TForm1.txtDepthChange(Sender: TObject);
begin
  tubus.tubus_length:=ToFloat(txtDepth.Text);
end;

procedure TForm1.txtReflectanceChange(Sender: TObject);
begin
  tubus.refl:=ToFloat(txtReflectance.Text);
end;

procedure TForm1.cmbShapeChange(Sender: TObject);
begin
  assemble_tubus;
end;

procedure TForm1.txtWidthChange(Sender: TObject);
begin
  assemble_tubus;
end;

procedure TForm1.txtShapeAngleChange(Sender: TObject);
begin
  assemble_tubus;
end;

procedure TForm1.txtDiffusionReflectanceChange(Sender: TObject);
begin
  tubus.diffusion_refl:=ToFloat(txtDiffusionReflectance.Text);
end;

procedure TForm1.chkRotIterClick(Sender: TObject);
begin
  txtRotIter.Enabled:=chkRotIter.Checked;
end;

end.
