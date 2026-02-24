unit semafor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.ExtCtrls, Vcl.StdCtrls,deklar;

type
  TFsemafor = class(TForm)
    DrawGrid1: TDrawGrid;
    Timer1: TTimer;
    Button1: TButton;
    procedure DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    lista : tlist ;
    adm : boolean ;
    ilos : integer ;
  public
    frk : integer ;
    Procedure setborder(admin : boolean) ;
    Procedure Prikazi(admin: boolean;listStr : Tlist) ;
  end;

var
  Fsemafor: TFsemafor;

implementation

{$R *.dfm}

uses zacetna, postaje;

procedure TFsemafor.Button1Click(Sender: TObject);
  var kx : integer ;
begin
  kx := drawgrid1.ColWidths[3] ;
  //ShowMessage(left) ;
//  left := screen.width;
 //showMessage(intTostr(Screen.Monitors[0].BoundsRect.height))  ;
 //showMessage(intTostr(Screen.Monitors[1].BoundsRect.height))
 showMessage(intTostr(drawgrid1.rowcount))
end;

procedure TFsemafor.DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);

   var kl,iy,iy1,rowh,ix,kk,iz : integer ;
   stt,st1,nz,nz1 : string ;
   tt : TDateTime ;
   ims,imt : array[0..MSTROJ] of string ;
   jms: array[0..MSTROJ] of integer ;
   ii,ipl, ll,fsize,fsizf : Integer;
   pp : ^zapis ;

   function xpos(stt : string) : integer ;
     var iix : integer ;
   begin
      iix := (drawGrid1.ColWidths[2] - DrawGrid1.Canvas.Textwidth(stt)) div 2 ;
      result := DrawGrid1.colwidths[0] + DrawGrid1.colwidths[1] + iix ;
   end;
begin
  if aRow > lista.count-1 then exit ;

  // po vseh strojih
  for ii := 0 to lista.Count-1 do
  begin
    pp := lista[ii] ;
    nz := trim(pp^.naziv) ;
    ll := length(nz) ;

    nz1 := Copy(nz,15,ll) ;     // 1. vrstica
    ipl := pos(' ',nz1) ;
    jms[ii] := pp^.diff ;
    if ipl > 0 then
    begin
      ims[ii] := copy(nz,1,14+ipl) ;
      imt[ii] := copy(nz,15+ipl,ll-15-ipl+1) ;
      //jms[ii] := pp^.diff
    end else
    begin
       ipl := pos('.',nz1) ;
       if ipl > 0 then
       begin
        ims[ii] := copy(nz,1,14+ipl) ;
        imt[ii] := copy(nz,15+ipl,ll-15-ipl+1) ;
       end else ims[ii] := nz ;
    end ;
    //ShowMessage(imt[ii])
  end ;

  rowh := DrawGrid1.DefaultRowHeight ;
  if rowh > 70  then  fsize := 24 else fsize := 14 ;
  if rowh > 70  then  fsizf := 36 else fsizf := 16 ;

  iz := arow*rowh + rowh div 3 ;
  if acol = 0 then
  begin
    iy := arow*rowh + rowh div 6 ;
    iy1 := arow*rowh + 2*rowh div 4 ;
    DrawGrid1.Canvas.font.Size := fsize ;

    stt := ims[arow] ;
    ix := (drawGrid1.ColWidths[0] - DrawGrid1.Canvas.Textwidth(stt)) div 2  ;
    DrawGrid1.Canvas.TextOut(ix,iy,stt) ;
    stt := imt[arow] ;
    ix := (drawGrid1.ColWidths[0] - DrawGrid1.Canvas.Textwidth(stt)) div 2  ;
    DrawGrid1.Canvas.TextOut(ix,iy1,stt) ;
    DrawGrid1.Canvas.font.Size := fsizf ;
    exit
  end;
  kl := Fzacetna.astanje[arow+1] ;
  if acol = 1 then
  begin
    case kl of
       1 : Drawgrid1.Canvas.Brush.Color := $0200FF00 ;
       2 : Drawgrid1.Canvas.Brush.Color := $0200FFFF ;
       3 : Drawgrid1.Canvas.Brush.Color := $020000FF ;
       9 : Drawgrid1.Canvas.Brush.Color := clSilver ;
    end;
    DrawGrid1.Canvas.FillRect(rect);
  end;
  if acol = 2 then
  begin
    ix := DrawGrid1.colwidths[0] + DrawGrid1.colwidths[1] + 10 ;
    iy := arow*rowh + rowh div 6 ;
    iy1 := arow*rowh + 2*rowh div 4 ;
    if kl < 5 then
    begin
      //tt := StrToTime('2:00:00') - time + Fosnova.acas[arow+1] ;
     // tt := frk/24 - time + Fzacetna.acas[arow+1] ;
      tt := jms[arow]/24/60 - time + Fzacetna.acas[arow+1] ;
      stt := TimeTostr(tt) ;
      kk := Length(stt) ;
      stt := copy(stt,1,kk-3) ;
      if kl = 3 then st1 := 'Meritev zamuja za ' ;
      if (kl = 1) or (kl =2)  then st1 := 'Do naslednje meritve' ;

      DrawGrid1.Canvas.font.Size := fsize ;
      ix := xpos(st1) ;
      DrawGrid1.Canvas.TextOut(ix,iy,st1) ;
      DrawGrid1.Canvas.font.Size := fsizf ;
      ix := xpos(stt) ;
      DrawGrid1.Canvas.TextOut(ix,iy1,stt) ;


    end else
    begin
      DrawGrid1.Canvas.font.Size := fsizf ;
      stt := 'Stroj ni aktiven' ;
      ix := xpos(stt) ;
      DrawGrid1.Canvas.TextOut(ix,iz,stt) ;
    end;
  end;
end;


procedure TFsemafor.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not adm then Action := TCloseAction.caNone;
end;

procedure TFsemafor.FormCreate(Sender: TObject);
begin
  ilos := 1 ;
end;

procedure TFsemafor.FormResize(Sender: TObject);
begin
 // SHowMessage('1') ;
end;

procedure TFsemafor.FormShow(Sender: TObject);
begin
 //  WindowState:=wsMaximized;

end;

Procedure TFsemafor.prikazi(admin:boolean;listStr : Tlist) ;
  var dln : integer ;
      mn,kk : integer ;
      lx1,lx2 : integer ;
begin
  mn := Screen.monitorCount ;
  button1.Visible := admin ;

  lista := ListStr ;
  dln := Lista.Count ;
  dln := Fpostaje.Getvrsta ;
  if dln < liststr.Count-1 then  ilos := (ilos +1) mod 2 ;

  if dln > 0 then
  begin
    drawgrid1.Rowcount := dln ;
    drawgrid1.DefaultRowHeight := (drawgrid1.height-20) div dln ;
  end;
  setborder(admin) ;
  show ;

 // ShowMessage(intTostr(Screen.Monitors[0].BoundsRect.left)) ;
 // ShowMessage(intTostr(Screen.Monitors[1].BoundsRect.left)) ;
// ShowMessage(intTostr(screen.BoundsRect.left)) ;
  if mn = 2 then
  begin
    lx1 := Screen.Monitors[0].BoundsRect.left ;
    lx2 := Screen.Monitors[1].BoundsRect.left ;
   // if lx1 < lx2 then kk := 1 else kk := 0 ;
    if lx1 = 0 then kk := 1 else kk := 0 ;

   // showmessage(intTostr(lx1)+'/' + intTostr(lx2)) ;
    top := Screen.Monitors[kk].BoundsRect.Top ;
    left := Screen.Monitors[kk].BoundsRect.left ;
    //ShowMessage(intTostr(left)) ;
    width := Screen.Monitors[kk].BoundsRect.width ;
    height := Screen.Monitors[kk].BoundsRect.height ;
  end else
  begin
    kk := 0 ;
    top := Screen.Monitors[0].BoundsRect.Top ;
    left := Screen.Monitors[0].BoundsRect.left ;
  end;
  drawgrid1.defaultcolwidth := (Screen.Monitors[kk].BoundsRect.width -10) div 3 ;
  if drawgrid1.DefaultColWidth < 400  then
  begin
     drawgrid1.ColWidths[0] := 400 ;
     drawgrid1.ColWidths[2] := 400 ;
     drawgrid1.ColWidths[1] := Screen.Monitors[kk].BoundsRect.width -800  ;
  end;
  if dln > 0 then
  begin
    drawgrid1.Rowcount := dln ;
    //showMessage(intTostr(Screen.Monitors[kk].BoundsRect.height)) ;
    drawgrid1.DefaultRowHeight := (Screen.Monitors[kk].BoundsRect.height-60) div dln ;
  end;
end;

Procedure Tfsemafor.setborder(admin : boolean) ;
begin
   adm := admin ;
   if admin then fsemafor.bordericons := [biSystemmenu,biMinimize,biMaximize,biHelp]
            else fsemafor.bordericons := [biSystemmenu,biHelp] ;
end;


procedure TFsemafor.Timer1Timer(Sender: TObject);
begin
  DrawGrid1.Repaint ;
end;

end.
