unit Unit1;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Pbx: TImage;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
implementation

{$R *.lfm}

{ TForm1 }

procedure DrawClock(var centr ,r:integer); //процедура рис. часов с черточками
var rCh,i:integer;        //до куда будет черточка
    u:real;             //угол с черточкой
begin
     Form1.Pbx.Width:=Form1.Pbx.Height;   //чтобы нарисовать ровные часы
     centr:=Form1.pbx.Height div 2;
     r:=centr-50;  //радиус окружности часов
     rCh:=r-10;
     with Form1.pbx.Canvas do
     begin
          brush.Color:=clWhite;     //поле, на котором рисуем часы
          rectangle(0, 0, Form1.Pbx.Width, Form1.Pbx.Height);
          pen.Color:=clBlack;
          pen.Width:=3;
          ellipse(centr-r, centr-r, centr+r, centr+r);  //окружность часов
          ellipse(centr-2, centr-2, centr+2, centr+2); //точка центра
          pen.Width:=1;
          u:=pi/2;
          for i:=1 to 12 do  //рисуем 12 черточек
          begin
               moveto(centr+round(rCh*cos(u)), centr-round(rCh*sin(u)));
               lineto(centr+round(r*cos(u)), centr-round(r*sin(u)));
               u:=u+pi/6;
          end;
     end;
end;


procedure TForm1.FormCreate(Sender: TObject);  //рисуются часы сразу при запуске
var
    centr, r: integer;
begin
     DrawClock(centr, r);
end;


procedure Ugli(var chas, min, sec: real; H, M, S:integer);//проц-ра расчета углов
begin
  min := M * pi/30 - pi/2;//Угол c. стрелки(в часах 2П радиан и 60 минут)
  sec := S * pi/30 - pi/2;//Угол м. стрелки(в часах 2П радиан и 60 минут)
  chas := ((((H mod 12)*60) + M)/60) * (pi/6) - pi/2;
  //Угол ч. стрелки (переводим часы в
  //формат до 11, переводим в минуты и делим на 60,
  //далее переводим в радианы (в часе П/6 радиан))
  ///// (-pi/2), т.к. отсчет времени не от 0, а от pi/2 (90 градусов)
end;


procedure Drawing(chas, min, sec: real; r, centr: integer);//пр-ра рисования стрелок
var
    r1:integer;
begin
  with Form1.Pbx.Canvas do
  begin
    Clear;       //очистка и создание новых часов при каждом изменении времени
    DrawClock(centr, r);

    pen.Width:=2;

    pen.Color:=clNavy;
    r1:=r-20;       //длина минутной стрелки
    Moveto(centr, centr);
    Lineto(centr+round(r1*cos(min)), centr+round(r1*sin(min)));

    pen.Color:=clHotLight;
    r1:=r-50;    //длина часовой стрелки
    Moveto(centr, centr);
    Lineto(centr+round(r1*cos(chas)), centr+round(r1*sin(chas)));

    pen.Width:=1;
    pen.Color:=clRed;
    r1:=r-20;    //длина секундной стрелки
    Moveto(centr, centr);
    Lineto(centr+round(r1*cos(sec)), centr+round(r1*sin(sec)));

    pen.Color:=clBlack;
    ellipse(centr-2, centr-2, centr+2, centr+2); //точка центра
  end;
end;


procedure TForm1.Timer1Timer(Sender: TObject);
var
    chas, min, sec, mSec: Word;
    r, centr: integer;
    Uchas, Umin, Usec: real;
begin
  DecodeTime(Time, chas, min, sec, mSec);
  ugli(Uchas, Umin, Usec, chas, min, sec);
  Drawing(Uchas, Umin, Usec, r, centr);   //рисование
end;


end.

