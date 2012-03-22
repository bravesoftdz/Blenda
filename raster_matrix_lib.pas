unit raster_matrix_lib;

interface
uses types,graphics,math,windows;
type

raster_matrix=class
  private
    pixels: array of array of Real;
    _left: Real; //левая граница
    _right: Real; //правая граница
    _top: Real; //верхняя граница
    _bottom: Real; //нижняя граница
    _width,_height: Integer;
    s: Real; //масштаб
    _rect: TRect; //хранение размеров окна в пикс, куда пойдет отобр.
    changed: Boolean; //отсл. изменения
    procedure SetWidth(w: Integer);
    procedure SetHeight(h: Integer);
    procedure SetRect(r: TRect);
    procedure update_scale;
    procedure Set_left(a: Real);
    procedure Set_right(a: Real);
    procedure Set_top(a: Real);
    procedure Set_bottom(a: Real);
  public

    Img: TCanvas;
    procedure Clear;
    function Xpix2mm(X: Integer): Real;
    function Ypix2mm(Y: Integer): Real;
    function Xmm2pix(X: Real): Integer;
    function Ymm2pix(Y: Real): Integer;
    property width: Integer read _width write SetWidth;
    property height: Integer read _height write SetHeight;
    property rect: TRect read _rect write SetRect;

    property left: Real read _left write set_left;
    property right: Real read _right write set_right;
    property top: Real read _top write set_top;
    property bottom: Real read _bottom write set_bottom;

    procedure addvalue(x:Real;y:Real;val: Real);
    procedure draw;
  end;


implementation
function gamma(x: Real): Integer;
begin
  if x<0.0031308 then gamma:=Round(x*12.92*255)
  else gamma:=Round(((1+0.055)*power(x,1/2.4)-0.055)*255);
end;


procedure raster_matrix.update_scale;
var    sx,sy: Real;
begin
  if (_rect.Right<>_rect.Left) and (_rect.Bottom<>_rect.Top) and (_right<>_left) and (_bottom<>_top) then begin
    sx:=(_right-_left)/(_rect.Right-_rect.Left);
    sy:=(_bottom-_top)/(_rect.Bottom-_rect.Top);
    s:=max(sx,sy);
    _rect.Right:=Xmm2Pix(_right);
    _rect.Bottom:=Ymm2Pix(_bottom);
  end;
end;

function raster_matrix.Xpix2mm(X: Integer): Real;
begin
  Xpix2mm:=_left+(X-_rect.Left)*s;
end;

function raster_matrix.Ypix2mm(Y: Integer): Real;
begin
  Ypix2mm:=_top+(Y-_rect.Top)*s;
end;

function raster_matrix.Xmm2pix(X: Real): Integer;
begin
  Xmm2pix:=_rect.Left+Round((X-_left)/s);
end;

function raster_matrix.Ymm2pix(Y: Real): Integer;
begin
  Ymm2pix:=_rect.Top+Round((Y-_top)/s);
end;


procedure raster_matrix.SetWidth(w: Integer);
begin
  _width:=w;
  SetLength(pixels,_width,_height);
  _rect.Right:=_rect.Left+_width;
  update_scale;
end;

procedure raster_matrix.SetHeight(h: Integer);
begin
  _height:=h;
  SetLength(pixels,_width,_height);
  _rect.Bottom:=_rect.Top+_height;
  update_scale;
end;

procedure raster_matrix.SetRect(r: TRect);
begin
  _Rect:=r;
  _width:=_rect.Right-_rect.Left;
  _height:=_rect.Bottom-_rect.Top;
  SetLength(pixels,_width,_height);
  update_scale;
end;

procedure raster_matrix.Clear;
var i,j: Integer;
begin
  for i:=0 to width-1 do begin
    for j:=0 to height-1 do begin
      pixels[i,j]:=0;
    end;
  end;
end;

procedure raster_matrix.Set_left(a: Real);
begin
  _left:=a;
  update_scale;
end;

procedure raster_matrix.Set_right(a: Real);
begin
  _right:=a;
  update_scale;
end;

procedure raster_matrix.Set_top(a: Real);
begin
  _top:=a;
  update_scale;
end;

procedure raster_matrix.Set_bottom(a: Real);
begin
  _bottom:=a;
  update_scale;
end;

procedure raster_matrix.addvalue(x:Real;y:Real;val: Real);
var pix_x,pix_y: Real;
    px,py: Integer;
    a,b :Real;
begin
  pix_x:=(X-_left)/s;
  pix_y:=(Y-_top)/s;
  px:=floor(pix_x);
  py:=floor(pix_y);
  if (px>=0) and (py>=0) and (px<(_width-1)) and (py<(_height-1)) then begin
    a:=pix_x-px;
    b:=pix_y-py;
    pixels[px,py]:=pixels[px,py]+val*(1-a)*(1-b);
    pixels[px+1,py]:=pixels[px+1,py]+val*a*(1-b);
    pixels[px,py+1]:=pixels[px,py+1]+val*(1-a)*b;
    pixels[px+1,py+1]:=pixels[px+1,py+1]+val*a*b;
  end;
end;

procedure raster_matrix.draw;
var i,j,p: Integer;
    max_val: Real;
begin
  max_val:=pixels[0,0];
  for i:=0 to _width-1 do begin
    for j:=0 to _height-1 do begin
      if pixels[i,j]>max_val then max_val:=pixels[i,j];
    end;
  end;

  if max_val>0 then begin
    for i:=0 to _width-1 do begin
      for j:=0 to _height-1 do begin
        p:=gamma(pixels[i,j]/max_val);
        img.Pixels[i+_rect.Left,j+_rect.top]:=RGB(p,p,p);
      end;
    end;
  end;

end;


end.
