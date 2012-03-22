unit tubus_lib;

interface
uses graphics,types,math;

type
  TPlane=record //ориентированная плоскость, заданная уравнением
    A,B,C,D :Real;//Внутренней полуплоскостью считается та,
    //для которой Ax+By+Cz+D>0
  end;
  TRay=record //"луч" для рейтрейсинга.
    x: Real; //коорд. X
    y: Real; //коорд. Y
    z: Real; //коорд. Z
    nx: Real; //x-комп. нормали
    ny: Real; //y-комп. нормали
    nz: Real; //z-комп. нормали
    I: Real; //яркость
  end;
  TTubus=class
    private
      _left: Real; //левая граница
      _right: Real; //правая граница
      _top: Real; //верхняя граница
      _bottom: Real; //нижняя граница
      s: Real; //масштаб
      _rect: TRect; //хранение размеров окна в пикс, куда пойдет отобр.
      changed: Boolean; //отсл. изменения
      _full_rect: TRect;
 //пересчет размеров
      procedure update_values;
      procedure update_scale;
      function get_left: Real;
      function get_right: Real;
      function get_top: Real;
      function get_bottom: Real;
      function square(X:Real): Real;
      procedure set_rect(n: TRect);
    public
      planes: array of TPlane;
      epsilon: Real; //длина достаточно малого вектора, чтобы не застрять в плоскостях.
      refl: Real; //коэфф. отражения
      diffusion_refl: Real; //коэфф. диффузного отражения
      tubus_length: Real; //длина тубуса
      Img: TCanvas;
      function input_aperture(x:Real;y:Real): Boolean;
      //попадает ли данная точка во входн. зрачок.
      function paranoia_input_aperture (x: Real; y:Real): Boolean;
      function frame_inclusive_input_aperture (x: Real; y: Real): Boolean;
      function output_aperture(x:Real;y:Real): Boolean;
      //попадает ли данная точка в выходной зрачок
      procedure add_plane(A: real; B:real; C: real; D: real);
      procedure add_simple(x1: real;y1: real; x2: Real; y2: Real);
      //плоскость, паралл. оси z, построить по 2 точкам.
      //внутренняя сторона - по часовой стрелке.
      procedure delete_planes;
      //удалить все плоскости
      procedure draw_input_aperture;
      //нарисовать входной зрачок в выбранном месте

      function Xpix2mm(x: Integer): Real;
      function Ypix2mm(y: Integer): Real;
      function Xmm2pix(x: Real): Integer;
      function Ymm2pix(y: Real): Integer;

      function trace(incident: TRay): TRay;

      property left: Real read get_left;
      property right: Real read get_right;
      property top: Real read get_top;
      property bottom: Real read get_bottom;
      property rect: TRect read _rect write set_rect;
      property full_rect: TRect read _full_rect;
      property scale: Real read s;
  end;

implementation

function TTubus.square(X: Real): Real;
begin
  square:=X*X;
end;

function TTubus.get_left: Real;
begin
  update_values;
  get_left:=_left;
end;

function TTubus.get_right: Real;
begin
  update_values;
  get_right:=_right;
end;

function TTubus.get_top: Real;
begin
  update_values;
  get_top:=_top;
end;

function TTubus.get_bottom: Real;
begin
  update_values;
  get_bottom:=_bottom;
end;

procedure TTubus.set_rect(n: TRect);
begin
  _rect:=n;
  _full_rect:=n;
  update_scale;
end;

procedure TTubus.update_scale;
var    sx,sy: Real;
begin
  if (_rect.Right<>_rect.Left) and (_rect.Bottom<>_rect.Top) and (right<>left) and (bottom<>top) then begin
    sx:=(right-left)/(_rect.Right-_rect.Left);
    sy:=(bottom-top)/(_rect.Bottom-_rect.Top);
    s:=max(sx,sy);
    _rect.Right:=Xmm2Pix(right);
    _rect.Bottom:=Ymm2Pix(bottom);
  end;
end;

function TTubus.Xpix2mm(X: Integer): Real;
begin
  Xpix2mm:=left+(X-_rect.Left)*s;
end;

function TTubus.Ypix2mm(Y: Integer): Real;
begin
  Ypix2mm:=top+(Y-_rect.Top)*s;
end;

function TTubus.Xmm2pix(X: Real): Integer;
begin
  Xmm2pix:=rect.Left+Round((X-left)/s);
end;

function TTubus.Ymm2pix(Y: Real): Integer;
begin
  Ymm2pix:=rect.Top+Round((Y-top)/s);
end;

procedure TTubus.update_values;
var p_X,p_Y :array of Real;
    i,j,k,n,n1: Integer;
    delta,delta1,delta2,tx,ty: Real;
begin
  if changed then begin
    n:=Length(planes);
    n1:=n*(n-1);
    SetLength(p_X,n1);
    SetLength(p_Y,n1); //так заведомо хватит
    k:=-1;
    for i:=0 to n-1 do begin  //внеш. цикл по плоскостям
      for j:=i+1 to n-1 do begin //внут. цикл
         //ищем пересечение j-той плоскости с i-ой
         delta:=planes[i].A*planes[j].B-planes[j].A*planes[i].B;
         if delta=0 then continue; //плоскости параллельны
         delta1:=-planes[i].D*planes[j].B+planes[j].D*planes[i].B;
         delta2:=-planes[i].A*planes[j].D+planes[j].A*planes[i].D;
          tx:=delta1/delta;
          ty:=delta2/delta;
          if frame_inclusive_input_aperture(tx,ty) then begin
             inc(k);
             p_X[k]:=tx;
             p_Y[k]:=ty;
          end;


         delta1:=delta1-(planes[i].C*planes[j].B+planes[j].C*planes[i].B)*tubus_length;
         delta2:=delta2-(planes[i].A*planes[j].C+planes[j].A*planes[i].C)*tubus_length;

         tx:=delta1/delta;
         ty:=delta2/delta;
         if output_aperture(tx,ty) then begin
            inc(k);
           p_X[k]:=delta1/delta;
           p_Y[k]:=delta2/delta;
         end;
      end;
    end;
    //получили набор "подозрительных" точек, теперь из них выберем максимумы.
    _left:=p_X[0];
    _right:=p_X[0];
    _top:=p_Y[0];
    _bottom:=p_Y[0];
    for i:=1 to k do begin
      if p_X[i]<_left then _left:=p_X[i];
      if p_X[i]>_right then _right:=p_X[i];
      if p_Y[i]<_top then _top:=p_Y[i];
      if p_Y[i]>_bottom then _bottom:=p_Y[i];
    end;
    changed:=false;
    update_scale;
  end;
end;

function TTubus.input_aperture(X:Real;Y:Real): Boolean;
var i: Integer;
    res: Boolean;
begin
  res:=true;
  for i:=0 to High(planes) do begin
//чтобы быть вх. зрачком, точка должна быть в правильной полуплоскости для каждой плоскости
    if planes[i].A*x+planes[i].B*y+planes[i].D<0 then begin
      res:=false;
      break;
    end;
  end;
  input_aperture:=res;
end;

function TTubus.paranoia_input_aperture(X: Real; Y:Real): Boolean;
var i: Integer;
    res: Boolean;
begin
  res:=true;
  for i:=0 to High(planes) do begin
//чтобы быть вх. зрачком, точка должна быть в правильной полуплоскости для каждой плоскости
    if planes[i].A*x+planes[i].B*y+planes[i].D<epsilon then begin
      res:=false;
      break;
    end;
  end;
  paranoia_input_aperture:=res;
end;

function TTubus.frame_inclusive_input_aperture(x: Real; y:Real): Boolean;
var i: Integer;
    res: Boolean;
begin
  res:=true;
  for i:=0 to High(planes) do begin
//чтобы быть вх. зрачком, точка должна быть в правильной полуплоскости для каждой плоскости
    if planes[i].A*x+planes[i].B*y+planes[i].D<-epsilon then begin
      res:=false;
      break;
    end;
  end;
  frame_inclusive_input_aperture:=res;
end;

function TTubus.output_aperture(X:Real;Y:Real): Boolean;
var i: Integer;
    res: Boolean;
begin
  res:=true;
  for i:=0 to High(planes) do begin
//чтобы быть вх. зрачком, точка должна быть в правильной полуплоскости для каждой плоскости
    if planes[i].A*x+planes[i].B*y+planes[i].C*tubus_length+planes[i].D<0 then begin
      res:=false;
      break;
    end;
  end;
  output_aperture:=res;
end;

procedure TTubus.add_plane(A:real; B:real; C:real; D:real);
var i: Integer;
    len: Real;
begin
  i:=Length(planes);
  SetLength(planes,i+1);
  len:=sqrt(A*A+B*B+C*C);
  planes[i].A:=A/len;
  planes[i].B:=B/len;
  planes[i].C:=C/len;
  planes[i].D:=D/len;
  changed:=true;
end;

procedure TTubus.add_simple(x1:real;y1:Real;x2:Real;y2: Real);
var a,b,d :Real;
begin
  a:=y2-y1;
  b:=x1-x2;
  d:=x2*y1-x1*y2;
  add_plane(a,b,0,d);
end;

procedure TTubus.draw_input_aperture;
var i,j: Integer;
begin
  Img.Brush.Color:=clWhite;
  Img.FillRect(_full_rect);
  for i:=_rect.Left to _rect.Right do begin
    for j:=_rect.Top to _rect.Bottom do begin
      if input_aperture(Xpix2mm(i),Ypix2mm(j)) then
        Img.Pixels[i,j]:=clGray;
    end;
  end;
end;

function TTubus.trace(incident: TRay): TRay;
//ради нее все и затевалось
//расчет прохождения луча через нагромождение плоскостей.
var t,tmin,norm,z: Real;
    i,pmin: Integer;
    ray: TRay;
label start;
begin
  ray:=incident;
  //следующий код впоследствии будет зациклен

start:
  tmin:=1.0/0; //плюс бесконечность
  pmin:=-1;
  for i:=0 to High(planes) do begin
    norm:=(ray.nx*planes[i].A+ray.ny*planes[i].B+ray.nz*planes[i].C);
    if norm<>0 then begin //он равняется нулю, если прямая параллельна плоскости
      t:=-(ray.x*planes[i].A+ray.y*planes[i].B+ray.z*planes[i].C+planes[i].D)/norm;
      if (t>epsilon) and (t<tmin) then begin
        tmin:=t;
        pmin:=i;
      end;
    end;
  end;
  //нашли ближайшую точку пересеч. с плоскостью.
  //или ее нет (прямая паралл ко всем)
  //или есть, но после выход. зрачка
  //или есть где-то внутри
  if pmin=-1 then begin
    //все, выбрались
    t:=(tubus_length-ray.z)/ray.nz;
    ray.x:=ray.x+t*ray.nx;
    ray.y:=ray.y+t*ray.ny;
    ray.z:=tubus_length;
  end
  else begin
    z:=ray.z+tmin*ray.nz;
    if z>tubus_length then begin
      t:=(tubus_length-ray.z)/ray.nz;
      ray.x:=ray.x+t*ray.nx;
      ray.y:=ray.y+t*ray.ny;
      ray.z:=tubus_length;
    end
    else begin
      //сначала "дотянем" до точки пересечения
      ray.x:=ray.x+tmin*ray.nx;
      ray.y:=ray.y+tmin*ray.ny;
      ray.z:=ray.z+tmin*ray.nz;
      //отражение от плоскости pmin
      norm:=(ray.nx*planes[pmin].A+ray.ny*planes[pmin].B+ray.nz*planes[pmin].C)/(square(planes[pmin].A)+square(planes[pmin].B)+square(planes[pmin].C));
      //проекция луча на нормаль в единицах его вектора нормали
      //поменяли направление
      ray.nx:=ray.nx-2*norm*planes[pmin].A;
      ray.ny:=ray.ny-2*norm*planes[pmin].B;
      ray.nz:=ray.nz-2*norm*planes[pmin].C;
      //снизили яркость на коэф. отражения
      ray.I:=refl*ray.I;

      goto start; //и продолжили трассировку
    end;
  end;
  trace:=ray;

end;

procedure TTubus.delete_planes;
begin
  SetLength(planes,0);
  changed:=true;
end;

end.
