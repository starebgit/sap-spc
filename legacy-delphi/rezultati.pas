unit rezultati;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,sap, Vcl.ExtCtrls, Vcl.StdCtrls, Data.DB, deklar,
  Data.Win.ADODB;

type
  tResult = Class
    constructor Create ;
    Destructor Destroy ; override ;
    private
    public
      stPreg : integer ;
      stObrv : integer ;
      stPovp : single ;
      stStd  : single ;
      stMin : single ;
      stMax : single ;
      stCp : single ;
      stCpk : single ;
      stIzvSp : integer ;
      stIzvZg : integer ;
      stIzven : integer ;
      stBrez : integer ;
      stNic : integer ;
      predpis : single ;
      spmeja  : single ;
      zgmeja : single ;
      spraz : single ;
      zgraz : single ;
      stcol : integer ;
      korak : single ;
      maxcol : single ;
      histo : array[0..50] of integer ;
     // Procedure cps(spMeja,zgMeja : single) ;
  End;
  TFrezultati = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Image1: TImage;
    Panel4: TPanel;
    Panel5: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    pod1: TLabel;
    pod2: TLabel;
    Label4: TLabel;
    pod3: TLabel;
    Minimum: TLabel;
    pod4: TLabel;
    Label5: TLabel;
    pod5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    pod6: TLabel;
    pod7: TLabel;
    pod8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Panel6: TPanel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    pr1: TLabel;
    pr2: TLabel;
    pr3: TLabel;
    Label17: TLabel;
    pr4: TLabel;
    Label18: TLabel;
    pr5: TLabel;
    od1: TLabel;
    od2: TLabel;
    od3: TLabel;
    od4: TLabel;
    od5: TLabel;
    Button1: TButton;
    ADOTable1: TADOTable;
    procedure Button1Click(Sender: TObject);
  private
    rzz : Tresult ;
    procedure getRez(listr : tlist) ;
    procedure Histogram ;
    Procedure statistika ;
  public
    procedure pripravi(anl : analiza) ;
    Procedure Prikazi(listr : tlist) ;
  end;

var
  Frezultati: TFrezultati;

implementation

{$R *.dfm}

procedure Tfrezultati.pripravi(anl : analiza) ;
begin
   rzz := tresult.create ;
   rzz.spmeja := anl.spmeja ;
   rzz.zgmeja := anl.zgmeja ;
   rzz.predpis := anl.predpis ;
   rzz.spraz := anl.spmeja - anl.dodattol ;
   rzz.zgraz := anl.zgmeja + anl.dodattol ; ;
   rzz.maxcol := 50 ;
   label9.Caption := 'Koda : ' + anl.koda ;
   label10.Caption := 'Kontrolna serija: ' + anl.sarza ;
   label11.caption :=  'Karakteristika: ' + anl.naziv ;
   label12.caption :=  'Èasovni interval: ' + DateTostr(anl.zacdat) + ' - ' + DateTostr(anl.kondat) ;
end;

Procedure TFrezultati.Prikazi(listr : tlist) ;
begin
  //height := 800 ;
  getRez(listr) ;
  histogram ;
  statistika ;
  ShowModal ;
  rzz.Free ;
end;

procedure TFrezultati.Button1Click(Sender: TObject);
begin
  Adotable1.TableName := 'Tabela' ;
 // Adotable1.def
end;

procedure Tfrezultati.getRez(listr : tlist) ;
  var cp,cpk : single ;
       i,nn,j,kk,k1,k2: Integer;
       sum,sum2,xx,yy : double ;
       pp : ^rezultat ;
       min,max : single ;
       x1,x2 : single ;
       diff : single ;
begin
   nn := listr.count ;
   rzz.stPreg := nn ;
   sum := 0 ;
   sum2 := 0 ;
   kk := 0 ;
   k1 := 0 ;
   k2 := 0 ;
   min := 99999 ;
   max := -99999 ;
   for i := 0 to nn-1 do
   begin
     pp := listr[i] ;
     xx := pp^.vrednost ;
     if  (xx >= rzz.spRaz) and (xx <= rzz.zgRaz) then
     begin
       sum := sum + xx ;
       sum2 := sum2 + xx*xx ;
       if min > xx then min := xx ;
       if max < xx then max := xx ;
       if xx < rzz.spmeja then inc(k1) ;
       if xx > rzz.zgmeja then inc(k2) ;
       inc(kk) ;
     end;
   end;

   if kk > 0 then
   begin
     rzz.stPovp := sum/kk ;
     rzz.stStd := sqrt(sum2/kk - sqr(rzz.stPovp)) ;
   end;

   rzz.stMin := min ;
   rzz.stMax := max ;
   rzz.stObrv := kk ;
   rzz.stIzvSp := k1 ;
   rzz.stIzvZg := k2 ;
   rzz.stIzven := nn - kk ;

  if abs(rzz.stStd) > 10e-8 then
  begin
    rzz.stCp := (rzz.ZgMeja-rzz.SpMeja)/6/rzz.stStd ;
    x1 := rzz.ZgMeja - rzz.stPovp ;
    x2 := rzz.stPovp - rzz.SpMeja ;
    if x1 < x2 then rzz.stCpk := x1/3/rzz.stStd else rzz.stCpk := x2/3/rzz.stStd ;
  end else
  begin
    rzz.stCp := 0 ;
    rzz.stCpk := 0
  end ;

  diff := rzz.zgraz - rzz.spraz ;
  if diff >= 15 then rzz.korak := 5 ;
  if (diff >=4) and (diff < 15) then rzz.korak := 1  ;
  if (diff >=2) and (diff < 5) then rzz.korak := 0.5 ;
  If diff < 2 then rzz.korak := 0.2 ;
  If diff < 1 then rzz.korak := 0.02 ;

  rzz.stCol := Round(diff/rzz.korak) ;
  if rzz.stcol > rzz.maxcol then
  begin
    ShowMessage('preveliko število stolpcev') ;
    Exit
  end ;
  for i := 0 to rzz.stCol do rzz.histo[i] := 0 ;
  for j := 0 to listr.Count-1 do
  begin
    pp := Listr[j];
    xx := pp.vrednost ;
    if  (xx < rzz.spRaz) or (xx > rzz.zgRaz) then Continue ;
    yy := (xx-rzz.spRaz)/rzz.korak+0.001  ;
    i := Trunc(yy) ;
    rzz.histo[i] := rzz.histo[i] + 1 ;
   end ;


  { for i := 0 to 50 do rzz.histo[i] := TableStat1.histo[i] ;
   rzz.stIzvSp := stSp ;
   rzz.stIzvZg := stZg ;
   rzz.spmeja  := TableStat1.spmeja ;
   rzz.zgmeja := TableStat1.zgMeja ;
   rzz.spraz := TableStat1.spRaz ;
   rzz.zgraz := TableStat1.zgRaz ;
   rzz.korak := TableStat1.Korak  ;
   rzz.stIzven := stIzv ;
   rzz.stBrez := stBrez ;
   rzz.stNic := stNic ;   }
end;

// procedura za izris histograma
procedure TFrezultati.Histogram ;
  var i,zpx,zpy,isp,sir,sird,xpoz,izpy,vis,itol : integer ;
      x,ozn : single ;
      texOzn : string ;
      PravK : TRect ;
      imax : integer ;

  procedure crta(x1,y1,x2,y2 : integer) ;
  begin
    Image1.Canvas.MoveTo(x1,y1) ;
    Image1.Canvas.LineTo(x2,y2) ;
  end ;

begin
  //stCol := Ftemp.TableStat1.StCol ;
  imax := 0 ;
  for i := 0 to rzz.stCol do
    if imax < rzz.histo[i] then imax := rzz.histo[i] ;
//  if imax = 0 then exit ;
  with Image1 do
  begin
    Canvas.Brush.Color := clWhite ;
    Canvas.Rectangle(0,0,Image1.width,Image1.height);
    if imax = 0 then exit ;
    Canvas.Pen.color := clBlack ;
    Canvas.Font.name := 'Arial' ;
    Canvas.Font.Size := 8 ;

    // definicja roba in širine stolpca
    zpx := 32 ;    //28
    zpy := 24 ;
    isp := height - zpy ;
    vis := height - 2*zpy ;
    sir := round((Width-2*zpx)/rzz.stCol) ;
    sird := round(3*sir/4) ;

    // koordinatni sistem
    izpy := height - zpy + 5 ;
    crta(zpx-5,izpy, width, izpy) ;
    crta(zpx-5,izpy, zpx-5, zpy) ;

    // oznake na y osi
    crta(zpx-8,zpy,zpx-2,zpy) ;
    i := Image1.Canvas.TextWidth(IntToStr(imax)) ;
    Image1.Canvas.TextOut(zpx-i-8,zpy-5,IntToStr(imax)) ;
    crta(zpx-8,height div 2,zpx-2,height div 2) ;
    Image1.Canvas.TextOut(zpx-i-8,(height div 2)-5,IntToStr(imax div 2)) ;

    // izris posameznih stolpcev
    xPoz := zpx ;
    for i := 0 to rzz.StCol do
    begin
      // stolpec obravnavam kot pravokotnik
      x := rzz.histo[i]/imax ;
      Canvas.Brush.color := clBlue ;
      pravK.left := xpoz ;
      pravK.top := isp-round(vis*x) ;
      pravK.Right := xpoz+sird ;
      pravK.Bottom := isp ;
      Canvas.FillRect(pravK) ;

      Canvas.Brush.color := clWhite ;
      xpoz := xpoz + sir ;

      // oznake na x osi
      crta(pravk.left,izpy-3,pravK.left,izpy+3) ;
      if (i mod 2) = 0 then
      begin
        ozn := rzz.SpRaz + i*rzz.korak ;
        texOzn := FloatToStrF(ozn,ffFixed,6,2);

        Canvas.TextOut(pravk.Left-Canvas.Textwidth(texOzn)div 2,izpy+3,texOzn) ;
      end ;
    end ;
    // izris toleranènih meja
    Canvas.Pen.Style := psDot ;
    x := rzz.ZgRaz - rzz.SpRaz ;
    itol := round((rzz.SpMeja - rzz.SpRaz)*(sir*rzz.stCol)/x) ;
    crta(itol+zpx,izpy, itol+zpx, zpy) ;
    itol := round((rzz.ZgMeja - rzz.SpRaz)*(sir*rzz.stCol)/x) ;
    crta(itol+zpx,izpy, itol+zpx, zpy) ;
    Canvas.Pen.Style := psSolid ;
    Canvas.Pen.Color := clRed ;
    //itol := round((sir*rzz.stCol)/2) ;
    itol := round((rzz.predpis - rzz.SpRaz)*(sir*rzz.stCol)/x) ;
    crta(itol+zpx,izpy, itol+zpx, zpy) ;
    Canvas.Pen.Color := clBlack ; ;
  end ;
end ;

Procedure TFrezultati.statistika ;
  var vsi : integer ;
begin
  pod1.caption := IntTostr(rzz.stObrv) ;
  pod2.caption := FloatTostrF(rzz.stPovp,ffFixed,8,3) ;
  pod3.Caption := FloatTostrF(rzz.ststd,ffFixed,8,3) ;
  pod4.Caption := FloatTostrF(rzz.stmin,ffFixed,8,2) ;
  pod5.caption := FloatTostrF(rzz.stmax,ffFixed,8,2) ;
  pod6.caption := FloatTostrF(rzz.stmax-rzz.stmin,ffFixed,8,2) ;
  pod7.caption := FloatTostrF(rzz.stCp,ffFixed,8,3) ;
  pod8.caption := FloatTostrF(rzz.stcpk,ffFixed,8,3) ;

  vsi := rzz.stObrv + rzz.stizven ;
  if vsi > 0 then
  begin
    pr1.Caption :=  IntTostr(vsi) ;
    pr2.Caption :=  IntTostr(rzz.stobrv - rzz.stizvsp - rzz.stizvzg) ;
    pr3.Caption :=  IntTostr(rzz.stizvsp) ;
    pr4.Caption :=  IntTostr(rzz.stizvzg) ;
    pr5.Caption :=  IntTostr(rzz.stizven) ;
    od1.Caption := '100,00%' ;
    od2.Caption := FloatTostrF((rzz.stobrv - rzz.stizvsp - rzz.stizvzg)*100/vsi,ffFixed,6,2) + '%' ;
    od3.Caption := FloatTostrF(rzz.stizvsp*100/vsi,ffFixed,6,2) + '%' ;
    od4.Caption := FloatTostrF(rzz.stizvzg*100/vsi,ffFixed,6,2) + '%' ;
    od5.Caption := FloatTostrF(rzz.stizven*100/vsi,ffFixed,6,2) + '%' ;
  end;
end;



Constructor tResult.Create ;
begin
  Inherited Create ;
  stPreg := 0 ;
  stObrv := 0 ;
  stPovp := 0.0 ;
  stStd := 0.0 ;
  stCp := 0.0 ;
  stCpk := 0.0 ;
  stIzvSp := 0;
  stIzvZg := 0 ;
  stIzven := 0 ;
  stBrez := 0 ;
  stNic := 0 ;
end ;

Destructor tResult.Destroy ;
begin
  Inherited Destroy ;
end ;


end.
