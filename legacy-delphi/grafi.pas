unit grafi;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls;

type
   rezultat = record
    vrednost : single ;
    dd : TdateTime ;
    tt : TdateTime ;
    vzorec : Integer
  end ;
  TFGrafi = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Legen: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    Procedure IniImag(sp,zg,sr,dif,avr,std : single;Imag : Timage;var zx,zy,zz : integer) ;
    procedure brisi ;
    procedure legenda ;
    Procedure cps(spmeja,zgmeja,povp, std : single; var cp,cpk : single) ;
  public
    procedure Izris(nz: string;imm,stvz : integer; sr,sp,zg,avr,std : single; listr : Tlist) ;
  end;

var
  FGrafi: TFGrafi;

implementation

{$R *.dfm}

procedure TFgrafi.Izris(nz: string;imm,stvz : integer; sr,sp,zg,avr,std : single; listr : Tlist) ;
  var korak,ii,ix,ll,d1,iy : integer ;
      zx,zy,zz,rb,z2 : Integer ;
      pp : ^rezultat ;
      xx : single ;
      tx : string ;
      imag : Timage ;
      dif1,dif2,dif : single ;
begin
  legenda ;
  case imm of
    1 : imag := Image1 ;
    2 : imag := Image2 ;
    3 : imag := Image3 ;
    4 : imag := Image4 ;
  end;
    dif1 := zg -sr ;
    dif2 := sr -sp ;
    if dif1 < dif2 then dif := 2*dif2 else dif := 2*dif1 ;
    dif := dif/2 ;
    IniImag(sp,zg,sr,dif,avr,std,imag,zx,zy,zz) ;
    Imag.Canvas.Pen.Color := clBlack ;
    rb := Imag.Width div 2 - 50 ;
    Imag.Canvas.TextOut(rb,0,nz) ;
    korak := 36 div stvz ;
    for ii := 0 to listr.Count-1 do
    begin
      pp := listr[ii] ;
      xx := pp^.vrednost ;
      z2 := zy div 2 ;
     // ix := Round((2*zz-zy)*(xx-sp)/dif+zy-zz)  ;
      ix := round((z2-zz)*(xx-sr+dif)/dif)  + zz ;

      if ii = 0 then Imag.Canvas.MoveTo(zx,zy-ix)
                else
                begin
                  Imag.Canvas.MoveTo(zx+(ii-1)*korak,zy-iy) ;
                  Imag.Canvas.LineTo(zx+ii*korak,zy-ix) ;
                end;
      if ii mod stvz = 0 then
      begin
        tx := TimeToStr(pp^.dd) ;
        ll := length(tx) ;
        if ll = 8 then d1 := 4 else d1 := 7 ;

        tx := copy(tx,1,ll-3) ;
        d1 := Imag.Canvas.TextWidth(tx) div 2 ;
       // Imag.Canvas.Textout(ii*korak+d1+zx ,zy+5,tx) ;
         Imag.Canvas.Textout(ii*korak+zx-d1 ,zy+5,tx) ;

        tx := dateToStr(pp^.dd) ;
        ll := length(tx) ;
        if ll > 9 then d1 := 4 else d1 := 7 ;
        d1 := ll div 2 ;
        tx := copy(tx,1,ll-5) ;
        d1 := Imag.Canvas.TextWidth(tx) div 2 ;
       // Imag.Canvas.Textout(ii*korak+d1+zx ,zy+20,tx) ;
         Imag.Canvas.Textout(ii*korak+zx-d1 ,zy+20,tx) ;
        if ii > 0 then
        begin
          Imag.Canvas.Pen.Style := psDot ;
          Imag.Canvas.MoveTo(zx+ii*korak,zy) ;
          Imag.Canvas.LineTo(zx+ii*korak,zz) ;
          Imag.Canvas.Pen.Style := psSolid ;
        end;
      end;
      iy := ix ;
    end;
end ;

procedure Tfgrafi.brisi ;
begin
  Image1.Canvas.FillRect(Image1.Canvas.Cliprect) ;
  Image2.Canvas.FillRect(Image2.Canvas.Cliprect) ;
  Image3.Canvas.FillRect(Image3.Canvas.Cliprect) ;
  Image4.Canvas.FillRect(Image4.Canvas.Cliprect) ;
end;

procedure TFGrafi.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  brisi ;
end;

procedure TFgrafi.legenda ;
  var ix : integer ;
begin
  ix := 23 ;
  legen.Canvas.Pen.Color := clGreen ;
  legen.Canvas.MoveTo(20,30) ;
  legen.Canvas.LineTo(90,30) ;
  legen.Canvas.Textout(95 ,ix,'Predpisana vrednost') ;
  legen.Canvas.Pen.Color :=  clBlue ;
  legen.Canvas.MoveTo(250,30) ;
  legen.Canvas.LineTo(320,30) ;
  legen.Canvas.Textout(325 ,ix,'Povpreèje') ;
  legen.Canvas.Pen.Color := clRed ;
  legen.Canvas.MoveTo(470,30) ;
  legen.Canvas.LineTo(540,30) ;
  legen.Canvas.Textout(545 ,ix,'Toleranène meje') ;
  legen.Canvas.Pen.Color :=  $0200c0c0 ;
  legen.Canvas.MoveTo(700,30) ;
  legen.Canvas.LineTo(770,30) ;
  legen.Canvas.Textout(775 ,ix,'Kontrolne meje') ;
end;

Procedure TFGrafi.cps(spmeja,zgmeja,povp, std : single; var cp,cpk : single) ;
  var x1,x2 : single ;
begin
  if abs(std) > 10e-8 then
  begin
    cp := (ZgMeja-SpMeja)/6/std ;
    x1 := ZgMeja - povp ;
    x2 := povp - SpMeja ;
    if x1 < x2 then cpk := x1/3/std else cpk := x2/3/std ;
  end else
  begin
    cp := 0 ;
    cpk := 0
  end ;
end;

Procedure TFgrafi.IniImag(sp,zg,sr,dif,avr,std : single;Imag : Timage;var zx,zy,zz : integer) ;
  var tenp,z2 : integer ;
      y1,y2,zf : integer ;
      cp,cpk : single ;
      cp1,cp2 : string;
begin

    Imag.Canvas.Unlock ;
//  Image1.Invalidate ;
    Imag.Canvas.FillRect(Imag.Canvas.Cliprect) ;
    zx := 35 ;
    zy := Imag.Height - 40 ;
    zz := 20 ;
    z2 := zy div 2 ;
    zf := Imag.Width ;
    // koordinatni sistem
    Imag.Canvas.MoveTo(zx,zy) ;
    Imag.Canvas.LineTo(Imag.width,zy) ;
    Imag.Canvas.MoveTo(zx,zy) ;
    Imag.Canvas.LineTo(zx,0) ;

    cps(sp,zg,avr, std,cp,cpk) ;
    cp1 := FloattostrF(cp,ffFixed,4,2) ;
    cp2 := FloattostrF(cpk,ffFixed,4,2) ;
    Imag.canvas.TextOut(zf-120,0,'cp = ' +cp1) ;
    Imag.canvas.TextOut(zf-60,0,'cpk = ' +cp2) ;

   // kontrolne meje
    Imag.Canvas.Pen.Color := clRed ;
    y1 := round((z2-zz)*(sp-sr+dif)/dif)  + zz ;
    Imag.Canvas.MoveTo(zx,zy-y1) ;
    Imag.Canvas.LineTo(Imag.width,zy-y1) ;
    Imag.canvas.TextOut(0,zy-y1-7,FloatTostrf(sp,ffFixed,4,2)) ;

    y2 := round((z2-zz)*(zg-sr+dif)/dif) + zz ;
    Imag.Canvas.MoveTo(zx,zy-y2) ;
    Imag.Canvas.LineTo(Imag.width,zy-y2) ;
    Imag.canvas.TextOut(0,zy-y2-7,FloatTostrf(zg,ffFixed,4,2)) ;

    // procesne meje
    Imag.Canvas.Pen.Color :=  clBlue ;
    y1 := round((z2-zz)*(avr-sr+dif)/dif)  + zz ;
    Imag.Canvas.MoveTo(zx,zy-y1) ;
    Imag.Canvas.LineTo(Imag.width,zy-y1) ;

    Imag.Canvas.Pen.Color :=  $0200c0c0 ;
    tenp := Round(0.1*(zy-2*zz)) ;
    y1 := round((z2-zz)*(avr+3*std-sr+dif)/dif)  + zz ;
   // y1 := round((z2-zz)*((sp-sr)*0.8+dif)/dif)  + zz ;
    Imag.Canvas.MoveTo(zx,zy-y1) ;
    Imag.Canvas.LineTo(Imag.width,zy-y1) ;
   // y2 := round((z2-zz)*((zg-sr)*0.8+dif)/dif)  + zz ;
    y2 := round((z2-zz)*(avr-3*std-sr+dif)/dif)  + zz ;
    Imag.Canvas.MoveTo(zx,zy-y2) ;
    Imag.Canvas.LineTo(Imag.width,zy-y2) ;

    // sredina
    Imag.Canvas.Pen.Color := clGreen ;
    Imag.Canvas.MoveTo(zx,z2) ;
    Imag.Canvas.LineTo(Imag.width,z2) ;
    Imag.canvas.TextOut(0,z2-7,FloatTostrf(sr,ffFixed,4,2)) ;

   // Image1.Canvas.Textout(0,zy-zz-8,edit9.text) ;
   // Image1.Canvas.Textout(0,zz-8,edit10.text) ;

end ;


end.
