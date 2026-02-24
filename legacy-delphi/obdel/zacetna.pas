unit zacetna;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,Data.Win.ADODB,
  Data.DB, deklar, Vcl.Grids, Vcl.Samples.Spin, Vcl.Menus, ComObj,semafdata, System.strUtils,metode, VpisUkrep, ukrepi, VpisOpom,sqlmeritve,grafi,pomoc;

  const
    DODK = 11 ;
    MSTROJ = 20 ;
type
  TFzacetna = class(TForm)
    Panel1: TPanel;
    Label2: TLabel;
    List3: TListBox;
    list4: TListBox;
    Label3: TLabel;
    Panel2: TPanel;
    Panel3: TPanel;
    Karakti: TStringGrid;
    Label4: TLabel;
    list5: TListBox;
    attri: TStringGrid;
    SpinEdit1: TSpinEdit;
    Button2: TButton;
    SpinEdit2: TSpinEdit;
    Label5: TLabel;
    Label6: TLabel;
    Button1: TButton;
    Button3: TButton;
    MainMenu1: TMainMenu;
    Lokalnabaza1: TMenuItem;
    Linijekode1: TMenuItem;
    Kodaare1: TMenuItem;
    arekarakteristike1: TMenuItem;
    Button4: TButton;
    Button5: TButton;
    Meritve1: TMenuItem;
    Button7: TButton;
    Panel4: TPanel;
    Postaje1: TMenuItem;
    Button8: TButton;
    Timer1: TTimer;
    Button9: TButton;
    Postaje2: TMenuItem;
    Stroji2: TMenuItem;
    Kontrolniplani1: TMenuItem;
    Linijestrunice1: TMenuItem;
    list6: TListBox;
    Button11: TButton;
    Button10: TButton;
    Edit1: TEdit;
    Panel5: TPanel;
    Edit2: TEdit;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Edit3: TEdit;
    Button15: TButton;
    Edit4: TEdit;
    Button16: TButton;
    Merilnemetode1: TMenuItem;
    Ukrepi1: TMenuItem;
    Meritve: TMenuItem;
    Button17: TButton;
    Label1: TLabel;
    Panel6: TPanel;
    Edit5: TEdit;
    Label7: TLabel;
    Edit6: TEdit;
    Label8: TLabel;
    Button18: TButton;
    Button19: TButton;
    Edit7: TEdit;
    Label9: TLabel;
    DodIzbor: TListBox;
    Image1: TImage;
    Label10: TLabel;
    Label11: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure List3Click(Sender: TObject);
    procedure list4Click(Sender: TObject);
    procedure list5Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Linijekode1Click(Sender: TObject);
    procedure Kodaare1Click(Sender: TObject);
    procedure arekarakteristike1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Meritve1Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Postaje1Click(Sender: TObject);
    procedure Stroji1Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure KaraktiDblClick(Sender: TObject);
    procedure KaraktiDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure KaraktiClick(Sender: TObject);
    procedure Kontrolniplani1Click(Sender: TObject);
    procedure Linijestrunice1Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Merilnemetode1Click(Sender: TObject);
    procedure Ukrepi1Click(Sender: TObject);
    procedure MeritveClick(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Button19Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);

  private
    ListStr : Tlist ;
    nkar1,nkar2 : Integer ;
    stcl,stvp : integer ;
    srz : string ;
    orod : string ;

    pos : Integer ;
    frkMr : integer ;
    izbStr : integer ;
    strvkl : array[1..MSTROJ] of boolean ;
    zacIzm : array[1..3] of TdateTime ;
    stanje : integer ;
    predm : integer ;
    admin : boolean ;
    bitmap : TBitmap ;
    Procedure isciKoda ;
  //  procedure Pocisti1(list : Tlist) ;
    procedure BrisiTabelo ;
    function preveriData : boolean  ;
    procedure ZapisSAP ;
    Procedure nanovo ;
    Procedure lokalkoda ;
    function PreveriMer(jj,kk: integer) : boolean ;
    Procedure Obnovi ;
    function DolociSt(tx : TDateTime; diff,traj : integer) : integer ;
    Procedure fillkarakt(kd,srz : string);
    procedure ZapisSemafor ;
    Procedure setcheck(row : integer) ;
    Procedure IzborStr ;
    Procedure LokalnaBaza ;
    Procedure izborLinije(izbStr: integer) ;
    Procedure IzborKode(kd : string) ;
    Procedure StartNit ;
    procedure postaviListstr ;
    Procedure Getstat(listr : Tlist; var avr,std : single) ;
    Procedure deaktiviraj(odl : boolean) ;
    procedure menupravice ;
    Procedure setzero(Sender: TObject);
  public
    lokalb : boolean ;
    ListamaxMin : TstringList ;
    psb : boolean ;
    stkanal : integer ;
    stdec : integer ;
    acas : array[1..MSTROJ] of TdateTime ;
    astanje : array[1..MSTROJ] of integer ;
  end;

var
  Fzacetna: TFzacetna;

implementation

{$R *.dfm}

uses sap, ComPort, lokalBaza, lokalmeritve, postaje, stroji, sinapro, semafor,
  SqlKode, prekini, pass, dodatKod;



// prekini podatkov iz vage
procedure TFzacetna.Button10Click(Sender: TObject);
  var uk,rz : string ;
begin
   uk := edit1.Text ;
   rz := FComPort.preberi3(uk) ;
end;

// štart prenosa preko stopalke
procedure TFzacetna.Button11Click(Sender: TObject);
begin
  stkanal := spinedit1.value;
  stdec := spinedit2.value ;
  StartNit ;
end;

// prenos preko stoplake se iznaja v svoji niti.
Procedure Tfzacetna.StartNit ;
begin
  stopal := Tprekini.Create( True );
  stopal.FreeOnTerminate := True;
  stopal.Priority := tpLower ;
  stopal.Resume;
end;


procedure TFzacetna.Button12Click(Sender: TObject);
begin
  edit2.Text := 'CL21042'
end;

// prekini prenos preko stopalke
procedure TFzacetna.Button13Click(Sender: TObject);
  var cm : string ;
begin
  cm := karakti.Cells[6,1] ;
  if cm = '' then cm := 'COM3' else cm := 'COM' + cm ;
  FComPort.prekini(cm,true) ;
  button11.Enabled := true ;
  button5.Enabled := true ;
end;

// prekinitev zaporedjan meritev za doloèitev min im max.
procedure TFzacetna.Button14Click(Sender: TObject);
  var cm : string ;
begin
  psb := false ;
  cm := karakti.Cells[6,1] ;
  if cm = '' then cm := 'COM3' else cm := 'COM' + cm ;
  FcomPort.Prekini(cm,false) ;
end;

procedure TFzacetna.Button15Click(Sender: TObject);
  var cm : string ;
begin
  cm := karakti.Cells[6,1] ;
  if cm = '' then cm := 'COM3' else cm := 'COM' + cm ;
  FcomPort.pisi(cm) ;
end;


// dopolnitev liste kod
procedure TFzacetna.Button16Click(Sender: TObject);
  var ii,jj : integer ;
      ss,sx : string ;
      listkd : TstringList ;
begin
  ii := list4.Items.count ;
  if ii > 0 then ss := list4.Items[0] else ss := '' ;
  listkd := TstringList.Create ;
  Fsqlkode.GetlistaKod(ss,listkd) ;
  list4.items := Listkd ;
  listkd.free ;
end;

// izris grafov
procedure TFzacetna.Button17Click(Sender: TObject);
  var ii,jj : integer ;
      kd : string ;
      stkar : string ;
      listr : tlist ;
      nz : string ;
      img,stvz : integer ;
      sr,sp,zg : single ;
      avr,std : single ;
begin
  ii := list4.ItemIndex ;
  kd := list4.Items[ii] ;
  img := 1 ;
  for jj := 1 to karakti.RowCount -1 do
  begin
    // graf se izriše èe ima karaktr. oznako X
    if karakti.cells[7,jj] = 'X' then
    begin
      stkar := karakti.cells[0,jj] ;
      listr := tlist.Create ;
      FsqlMeritve.getlist(kd,stkar,listr);
      nz := karakti.cells[1,jj] ;
      sr := StrToFloat(karakti.cells[2,jj]) ;
      sp := StrToFloat(karakti.cells[3,jj]) ;
      zg := StrToFloat(karakti.cells[4,jj]) ;
      stvz := 2 ;
      if listr.Count > 0 then  // èe je kaj meritev
      begin
        FsqlMeritve.Getstat(listr,avr,std)  ; // izaèunam osnovne statistike
        fGrafi.Izris(nz,img,stvz,sr,sp,zg,avr,std,listr) ;
        inc(img) ;
      end;
      Cistigraf(listr) ;
    end;
  end;
  fgrafi.Show ;
end;


procedure TFzacetna.Button18Click(Sender: TObject);
begin
  srz := '790000050292' ;
  srz := '790000054916' ;
  Fsap.Datsarza(srz) ;
end;

// pridobitev (oziroma ukinitev) pravic
procedure TFzacetna.Button19Click(Sender: TObject);
  var bb : boolean ;
begin
  if not admin then
  begin
    bb := Fpassw.getpas ;
    if bb then
    begin
      admin := true ;
      button19.Caption := 'Odjava admin' ;
    end else showMessage('Geslo ni pravilno')
  end else
  begin
    admin := false ;
    button19.caption := 'Prijava admin'
  end;
  menupravice ;
  Fsemafor.setborder(admin);
end;

// doloèitev dostopa do menija
procedure TFzacetna.menupravice ;
begin
  lokalnabaza1.Enabled := admin ;
  postaje1.enabled := admin ;
  button3.Enabled := admin ;
  postaje2.enabled := admin ;
  stroji2.Enabled := admin ;
  merilnemetode1.enabled :=  admin ;
  ukrepi1.Enabled := admin ;
  kontrolniplani1.Enabled := admin ;
  meritve.enabled := admin ;
  button16.Visible := admin ;
end;

// izaèunar osnvovnih stat. karakteristik za podatke v listi
Procedure Tfzacetna.Getstat(listr : Tlist; var avr,std : single) ;
  var ii,nn : integer ;
      sum : single ;
      pp : ^rezultat ;
begin
  sum := 0 ;
  nn := listr.count ;
  for ii := 0 to nn-1 do
  begin
    pp := listr[ii] ;
    sum := sum + pp^.vrednost ;
  end;
  avr := sum/nn ;
  sum := 0 ;
  for ii := 0 to nn-1 do
  begin
    pp := listr[ii] ;
    sum := sum + sqr(pp^.vrednost-avr)  ;
  end;
  if nn > 1 then  std := sqrt(sum/(nn-1)) else std := 0 ;
end;


// izvedba prepisa v SAP-a
procedure TFzacetna.Button1Click(Sender: TObject);
 var bb : boolean ;
      i : integer ;
begin
  screen.Cursor := crHourGlass;
  ZapisSemafor ;   // posodobi podatke za semafor
  bb := Preveridata ;
  if bb then
  begin
    try
      ZapisSAP ;
     // nanovo
      brisitabelo ;
      obnovi
    except
    end;
  end;
  screen.Cursor := crDefault;
end;

// ob prepisu v SAP se posodobijo podatki za semafor
procedure TFzacetna.ZapisSemafor ;
  var kds : TstringList ;
      i,izb: Integer;
      pp : ^zapis ;
      idstr : integer ;
begin
  izb := izbStr+1 ;
  if izb > 0 then
  begin
    pp := ListStr[izbstr] ;
    idstr := pp^.ident ;
    astanje[izb] := 1 ;
    acas[izb] := time ;
    FsemafData.Zapis(pos,idstr) ;
  end;
end;

// preverjanje èe je podatek v toleranci.
function TFzacetna.PreveriMer(jj,kk: integer) : boolean ;
    var xx,sp,zg : single ;
 begin
   try
     xx := StrToFloat(karakti.Cells[kk +DODK,jj]) ;
     sp := StrToFloat(karakti.Cells[3,jj]) ;
     zg := StrToFloat(karakti.Cells[4,jj]) ;
     if (xx-sp > -0.0001) and (zg-xx > -0.0001) then result := true else result := false
   except
     result := false
   end;
end ;


// vpogled v bazo strojev
procedure TFzacetna.Stroji1Click(Sender: TObject);
begin
  pos := Fpostaje.Getpost ;
  Fstroji.pogled(admin,pos) ;
end;

// timer za posodobitev stanja semaforja
procedure TFzacetna.Timer1Timer(Sender: TObject);
begin
  if pos > 0 then Obnovi
end;

// vpogled v bazo ukrepov
procedure TFzacetna.Ukrepi1Click(Sender: TObject);
begin
  Fukrepi.prikaz ;
end;


// posodobitev stanja semaforja
Procedure TFzacetna.Obnovi ;
   var dat,t1,tt: TdateTime ;
       izm,ids,i,ii : Integer ;
       xx : single ;
       novaiz : boolean ;
       bc : boolean ;
       pp : ^zapis ;
       sx : string ;
begin
  // pridobim identifikator zadnje meritve
  FSemafdata.GetIzmDat(dat,izm) ;
  ids := FsemafData.PrevdatIzm(dat,izm,pos) ;
  tt := time ;

  xx := 24*60 ;
  novaiz := false ;
  for i := 1 to 3 do
  begin
    t1 :=  ZacIzm[i] - tt ;
    if abs(t1*xx) < 1.5 then novaiz := true
  end ;
  if not assigned(ListStr) then  exit ;

  // po vseh strojih
  for ii := 0 to liststr.Count-1 do
  begin
    i := ii +1 ;
    pp := liststr[ii] ;
    sx := intTostr(pp^.ident) ;
    if strvkl[i] then    // èe je stroj aktiven
    begin
      if novaiz then        // zaèetek izmene
      begin
        astanje[i] := 2;
       // acas[i] := tt - frkMr/24  ;
        acas[i] := tt - pp^.diff/24/60  ;
      end else
      begin
        t1 := 0 ;
        if ids <> 0 then t1 := FSemafData.GetzapisCas(ids,pos,sx) ;   // podateki o zadnji meritvi
        if t1 = 0 then  // èe ni podatkov o zadnji meritvi
        begin
          if acas[i] = 0 then
          begin
          //  acas[i] := ZacIzm[izm] - frkMr/24 ;
             acas[i] := ZacIzm[izm] - pp^.diff/24/60  ;
            astanje[i] := dolociSt(acas[i],pp^.diff,pp^.traj)
          end else astanje[i] := dolociSt(acas[i],pp^.diff,pp^.traj) ;
        end else
        begin
          acas[i] := t1  ;
          astanje[i] := dolociSt(acas[i],pp^.diff,pp^.traj)
        end;
      end;
    end else astanje[i] := 9
  end;
end;


// doloèi stanje meritev
function TFzacetna.DolociSt(tx : TDateTime; diff,traj : integer) : integer ;
  var tt : TDateTime ;
      dd,xx : single ;
      ist : integer ;
begin
   tt := time ;
   dd := tt - tx ;
   ist := 1;
  // if dd*24 > diff/60 then ist := 2 ;
  // if dd*24 > diff/60 + traj/60 then ist := 3 ;
   if dd*24 > (diff-traj)/60 then ist := 2 ;
   if dd*24 > diff/60  then ist := 3 ;
   result := ist ;
end;

// polje edit2 je vidno samo za obdelovalnico. Sprejema podatke iz roènega skeneraj
procedure TFzacetna.Edit2Change(Sender: TObject);
begin
  IzborStr ;
end;

// ob vpisu v polje edit2 - samo za obdelovalnico
Procedure TFzacetna.IzborStr ;
  var idnt : string ;
      lin : Integer ;
      struz : string ;
      ii : integer ;
      kd : string ;
begin
  idnt := edit2.text ;
  // razkrijem nekatere ukaze
  if idnt = '#' then deaktiviraj(true) ;

  if length(idnt) < 7 then  exit ;

  // interpretiram podatke roènega skenerja in štartam meritve preko nožne stopalke
  idnt[6] := '-' ;
  deaktiviraj(true) ;
  lokalnabaza ;
  FlokalBaza.Getstruz(idnt,lin,struz) ;
  list3.ItemIndex := lin-1 ;
  izbStr := List3.ItemIndex ;
  Izborlinije(lin-1) ;
  ii := list6.Items.IndexOf(struz) ;
  List6.ItemIndex := ii ;
  kd := List4.Items[0] ;
  IzborKode(kd) ;
  list4.ItemIndex := 0 ;
  if lokalb then
  begin
    stkanal := spinedit1.Value ;
    stdec := spinedit2.Value ;
    StartNit ;
  end;
end;

// priprava za zapis v SAP
procedure TFzacetna.ZapisSAP ;
   var ii,kk : integer ;
       j,jj,stkar,vzz: Integer;
       pv : ^karmer ;
       karlist : Tlist ;
       merl,odl : string ;
       dd : TdateTime ;
       evalList : Tlist ;
       px : ^evaluac ;
       vred : boolean ;
       nazivp : string ;
       opr,stk,kd : string ;
       slb,stnp,id,iddod : integer ;

begin
   if karakti.Cells[8,1] <> '' then
   begin
     id := StrToInt(karakti.Cells[8,1]) ;
     opr := FsqlKode.Getoper(id) ;
   end else opr := '0010' ;
   iddod := dodIzbor.ItemIndex ;
   if iddod >= 0 then nazivp := DodIzbor.items[iddod] else nazivp := 'Strojna' ;
 //  merl := ListBox1.Items[ListBox1.ItemIndex] ;    // merilec
   merl := label1.Caption ;
   karlist := Tlist.Create ;
   ii := 0 ;
   odl := 'A' ;
 //  stvz := 12 ;
   evalList := TList.Create ;
   for jj := 1 to nkar1 do
   begin
     new(px) ;
     px^.imekar := karakti.Cells[1,jj];
     px^.stkar := karakti.Cells[0,jj];
     px^.ev := 'A' ;
     px^.st := 0 ;

     for kk := 1 to stcl do
     begin
       new(pv) ;
       pv^.stevnp := 0 ;
       pv^.stkar := karakti.Cells[0,jj];
       pv^.stmer := ii+1 ;
       pv^.skupi := 'X' ;
       pv^.tip := '01';
       pv^.stevilvz := kk ;
       vred := preverimer(jj,kk-1) ;
       if  vred then
       begin
         pv^.eval := 'A'
       end else
       begin
         pv^.eval := 'R' ;
         px^.ev := 'R' ;
         px^.st := px^.st + 1 ;
       end ;
       pv^.merit :=  karakti.Cells[kk+DODK-1,jj] ;
       karlist.Add(pv) ;
       Inc(ii) ;
     end ;
   //  pv^.opom := 'OP ' + IntTostr(jj) ;
     pv^.stevnp := 1 ;  // stevnp se tu uporablja za oznaèitev konca vzorca
   //  if px^.ev = 'R' then  pv^.opom := FvpisUkrep.izbor(karakti.Cells[1,jj]) ;

     evalList.add(px) ;
   end ;

   for jj := 1 to nkar2 do
   begin
     slb := StrToInt(attri.cells[4,jj]);
     new(px) ;
     px^.imekar := attri.Cells[1,jj];
     if slb = 0 then px^.ev := 'A' else px^.ev := 'R';
     px^.stkar := attri.cells[0,jj];
     px^.st := slb ;
     for kk := 1 to stvp do
     begin
       new(pv) ;
       pv^.stkar := attri.cells[0,jj];
       pv^.stmer := ii+1 ;
       pv^.skupi := '' ;
       pv^.tip := '02';
       stnp := StrToInt(attri.cells[4,jj]) ;
       pv^.stevnp := stnp ;
      // pv^.opom := attri.cells[5,jj] ;
       if stnp > 0 then pv^.eval :=  'R'  else pv^.eval := 'A';
       inc(ii) ;
       karlist.Add(pv) ;
     end ;
     new(pv) ;
     evalList.add(px) ;
   end;

   FvpisOpom.Vpis(evalList) ;
   for jj := 0 to evalList.Count-1 do
   begin
     px := evalList[jj] ;
     if px^.op <> '' then
     begin
       stk := px^.stkar ;
       for ii := 0 to karlist.Count-1 do
       begin
         pv := karlist[ii] ;
         if (pv^.stkar = stk) and (pv^.tip = '01') and (pv^.stevnp = 1)  then  pv^.opom := px^.op ;
         if (pv^.stkar = stk) and (pv^.tip = '02') then pv^.opom := px^.op
       end;
     end;
   end;

   dd := now ;
   kd := list4.items[list4.ItemIndex] ;
   if karlist.Count > 0 then Fsap.zapis(srz,opr,nazivp,merl,odl,orod,dd,karlist,evalList)  ;
   if karlist.Count > 0 then Fsqlmeritve.zapis(kd,srz,karlist)  ;
   CistiListE(evallist) ;
   CistiList1(karList) ;
end;

// prenos enega podatka iz merilne naprave
procedure TFzacetna.Button2Click(Sender: TObject);
  var stk,row,col,std : Integer ;
      mer : single ;
      cm,mr : string ;
      ii,ll : Integer ;

begin
   row := Karakti.Row ;
   col := karakti.Col ;
   if lokalb then cm := karakti.Cells[6,row] else cm := Fpostaje.getcom;
   if cm = '' then cm := 'COM3' else cm := 'COM' + cm ;

   stk :=  spinEdit1.value ;
   if stk <= 8 then mer := FComPort.preberi(stk,cm)
               else mr := FcomPort.odpri(cm) ;

   std := spinedit2.Value ;
   if stk <= 8 then karakti.Cells[col,row] := FloatTostrF(mer,ffFixed,10,std) ;
   // podatek iz vage se posebej obravnava
   if stk = 9 then
   begin
     mr := trim(mr) ;
     ll := length(mr) ;
     ii := ll-2 ;
     while mr[ii] <> ' ' do ii := ii-1 ;
     mr := copy(mr,ii+1,ll-ii-2) ;
     mr := replaceStr(mr,'.',',') ;
     karakti.Cells[col,row] := mr ;
   end ;
   if stk = 10 then   // Posebnost ?
   begin
     ii := PosEx(#10,mr) ;
     if mr[1] <> 'S' then
     begin
       mr := copy(mr,ii+1,40) ;
       ii := PosEx(#10,mr) ;
     end ;
     mr := copy(mr,1,ii-1) ;
     ll := length(mr) ;
     ii := ll ;
     while not (mr[ii] in ['0'..'9']) do ii := ii-1 ;
     ll := ii ;
     while not (mr[ii] = ' ') do ii := ii-1 ;
     mr := copy(mr,ii+1,ll-ii) ;
     mr := replaceStr(mr,'.',',') ;
     karakti.Cells[col,row] := mr ;
   end;
end;


// zakljucek
procedure TFzacetna.Button3Click(Sender: TObject);
begin
  bitmap.free ;
  pocisti1(listStr) ;
  Application.Terminate ;
end;

// Ob ukatu Lokalna baza ( za obdelovalnico)
procedure TFzacetna.Button4Click(Sender: TObject);
begin
   lokalnabaza ;
end;

// branje podatkov iz lokane baze
Procedure Tfzacetna.LokalnaBaza ;
  var list : Tlist ;
      i : integer ;
      pp : ^zapis ;
begin
   lokalb := true ;
   button1.Enabled := false ;
   button5.Enabled := true ;
   pocisti1(liststr) ;
   listStr := Tlist.Create ;
   FlokalBaza.getlinije(listStr) ;
   list3.Items.Clear ;
   for i := 0 to liststr.count-1 do
   begin
     pp := liststr[i] ;
     list3.items.add(pp^.naziv) ;
   end;
end;

// prepis meritev v lokalno bazo
procedure TFzacetna.Button5Click(Sender: TObject);
  var idm : integer ;
      i,j,stv : Integer ;
      poz,eval,opo,oro : string ;
      xx : single ;
      bb : boolean ;
      nz,nazdod,krdod : string ;
      izbdod,id : integer ;
      pp : ^zapis ;
      dodat : single ;
      ids,ips : integer ;
begin
  pp := listStr[IzbStr] ;
  nz := trim(pp^.naziv) ;
  ips := system.pos('/',nz) ;
  nz := copy(nz,1,ips) ;
  id := pp^.ident ;
  izbdod := List6.itemIndex ;

  if izbdod >= 0 then
  begin
    nazdod := trim(List6.Items[izbdod]) ;
    krdod := FlokalBaza.GetDodKr(id,nazdod) ;
  end else krdod := '' ;
  oro := nz +  krdod ;
  if predm = 1 then idm := FlokalMeritve.ZapisSeznam(srz,oro,krdod)
               else idm := FlokalMeritve.Iscimer(srz,krdod) ;
  if idm = 0 then
  begin
    showmessage('Ne najdem meritve pred menjavo') ;
    exit ;
  end;
  for i := 1 to karakti.RowCount-1 do
  begin
    poz := karakti.Cells[0,i] ;

    for j := 1 to karakti.ColCount- DODK do
    begin
      xx := StrToFloat(karakti.Cells[j+DODK-1,i]) ;
      bb := PreveriMer(i,j-1) ;
      if bb then eval := 'A' else eval := 'R' ;
      ids := StrToint(karakti.Cells[8,i]) ;
      dodat := Flokalbaza.Getpreracun(ids) ;
      xx := xx + dodat ;
      FlokalMeritve.ZapisMer1(idm,j,poz,eval,xx) ;
    end;
  end;
  for i := 1 to attri.RowCount-1 do
  begin
    poz := attri.Cells[0,i] ;
    stv := StrToIntDef(attri.Cells[4,i],0) ;
    if stv = 0 then eval := 'A' else eval := 'R' ;
   // opo := attri.Cells[5,i] ;
    FlokalMeritve.ZapisMer2(idm,stv,poz,eval,opo) ;
  end;
  nanovo ;
end;

// kreiranje checkbox-ov v tabeli atributov
Procedure Tfzacetna.setcheck(row : integer) ;
begin
    with TCheckBox.create(self) do
    begin
      name := 'chk' + IntTostr(row) ;
      caption := '' ;
      Parent := panel4 ;
      left := attri.width - 720 ;
      width := 30 ;
      top := 25*row + 6 ;
      onClick := setzero ;
    end;
end;

Procedure Tfzacetna.setzero(Sender: TObject);
  var rw : integer ;
      nm : string ;
begin
  nm := TcheckBox(sender).name ;
  rw := StrToInt(copy(nm,4,1)) ;
//  rw := attri.Row ;
  attri.cells[4,rw] := '0' ;
end;

// Start operacije za prepis iz lokalne baze v SAP
procedure TFzacetna.Button7Click(Sender: TObject);
begin
  FLokalMeritve.LokalSap ;
  //ShowMessage('Prenos uspešno konèan') ;
end;

// Ali je ta ukaz še potreben
procedure TFzacetna.Button8Click(Sender: TObject);
  var ii : integer ;
      pp : ^zapis ;
begin
  lokalb := false ;
  button5.Enabled := false ;
  button1.Enabled := true ;
  pos := Fpostaje.Getpost ;
  if pos > 0 then
  begin
    FrkMr := 2 ;
    pocisti1(liststr) ;
    ListStr := tlist.Create ;
    Fstroji.GetStroji(pos,ListStr) ;
    list3.Items.Clear ;
    for ii := 0 to listStr.count-1 do
    begin
       pp := listStr[ii] ;
       list3.Items.add(pp^.naziv) ;
       acas[ii] := 0 ;
       strvkl[ii+1] := Fsinapro.PreveriStroj(pp^.ident) ;
    end;
  end ;
end;


// Procedura izdela listo strojev za trenutno izbrano postajo
procedure Tfzacetna.postaviListstr ;
 var ii : integer ;
      pp : ^zapis ;
      ident : integer ;
      listak : TstringList ;
      kd,kdd : string ;
      diff,traj : integer ;
begin
  pos := Fpostaje.Getpost ;
  if pos > 0 then
  begin
    //FrkMr := 2 ;
    pocisti1(liststr) ;
    ListStr := tlist.Create ;    // listastr je lista strojev
    Fstroji.GetStroji(pos,ListStr) ;
    list3.Items.Clear ;
    for ii := 0 to listStr.count-1 do
    begin
       pp := listStr[ii] ;
       ident := pp^.ident ;
       listak := TstringList.create ;
       Fsinapro.Getkoda1(ident,listak) ;
       if listak .count > 0then
       begin
         kd := Listak[0] ;
         kdd := replaceStr(kd,'-','') ;
         kdd := trim(kdd) ;
         listak.Free ;
         FsqlKode.getinterval(kdd,diff,traj) ;
         pp^.diff :=  diff ;
         pp^.traj :=  traj ;
       end;
       list3.Items.add(pp^.naziv) ;
       acas[ii] := 0 ;
       strvkl[ii+1] := Fsinapro.PreveriStroj(pp^.ident) ;   // preverim èe je stroj aktiven
    end;
  end ;
end;

// procedura odpre semafor
procedure TFzacetna.Button9Click(Sender: TObject);
begin
  if not assigned(liststr)  then  exit ;
  obnovi ;
  Fsemafor.frk := frkmr ;
  Fsemafor.prikazi(admin,listStr)  ;
end;


function TFzacetna.preveriData : boolean  ;
  var jj,kk : Integer ;
      xx : single ;
      bb : boolean ;
begin
  bb := true ;
  for jj  := 1 to nkar1 do
  begin
    if not bb  then break ;
    for kk := 1 to stcl do
    begin
      try
        xx :=  StrToFloat(karakti.Cells[kk+DODK-1,jj]) ;
      except
        //ShowMessage('Podatki o meritvah niso vredu') ;
        karakti.row := jj ;
        karakti.col := kk+DODK-1 ;
        ShowMessage('Podatki o meritvah niso vredu') ;
        karakti.SetFocus ;
        bb := false ;
        break
      end;
    end;
  end;
  if bb then
  begin
    for jj := 1 to nkar2 do
      if trim(attri.Cells[4,jj]) = '' then
      begin
        ShowMessage('Podatki o atrib. karakteristikah niso vpisani') ;
        bb := false ;
        break
      end;
  end;
  result := bb ;
end;


Procedure TFzacetna.lokalkoda ;
  var pp : ^zapis ;
      ident : integer ;
      lista : TstringList ;
      deln,kd : string ;
      jx,ll : integer ;
begin
   pp := Liststr[IzbStr] ;
   orod := pp^.naziv ;
   ident := pp^.ident ;
   lista := Tstringlist.Create ;
   FlokalBaza.getKode(ident,lista) ;
   list4.Items := lista ;
   Lista.free ;
end ;

procedure TFzacetna.Merilnemetode1Click(Sender: TObject);
begin
  Fmetode.prikaz(admin) ;
end;

procedure TFzacetna.Meritve1Click(Sender: TObject);
begin
  FLokalMeritve.prikaz ;
end;

procedure TFzacetna.MeritveClick(Sender: TObject);
begin
   FsqlMeritve.pregled(admin) ;
end;

Procedure TFzacetna.isciKoda ;
  var ii : integer ;
      pp : ^zapis ;
      ident : integer ;
      listak : TstringList ;
      I,ipx : Integer;
      kd,kdd,xpx : string ;
      imm : string ;
begin
   label1.Hide ;
   pp := Liststr[IzbStr] ;
   orod := pp^.naziv ;
   ident := pp^.ident ;
   imm := Fsinapro.Getdelavec(ident) ;
   if imm <> '' then
   begin
     label1.Visible := true ;
     label1.Caption := 'Delavec ' + imm ;
   end;
   listak := TstringList.create ;
   Fsinapro.Getkoda1(ident,listak) ;
   for I := 0 to listak.Count-1 do
   begin
     kd := Listak[i] ;
     kdd := replaceStr(kd,'-','') ;
     kdd := trim(kdd) ;
     ipx := system.pos('/',kdd) ;
     xpx := Copy(kdd,ipx+1,2) ;
    // if xpx = '00' then kdd := Copy(kdd,1,ipx-1) ;
     listak[i] := kdd ;
   end;
   list4.Items.Clear ;
   list4.items := Listak ;
   lIstak.free ;
end;



procedure TFzacetna.KaraktiClick(Sender: TObject);
  var row,kn : integer ;
      tx : string ;
begin
  row := karakti.Row ;
  tx := karakti.Cells[5,row] ;
  if length(tx) <= 2 then
  try
    kn := StrToInt(tx) ;
    spinEdit1.Value := kn ;
  except
  end ;
end;

procedure TFzacetna.KaraktiDblClick(Sender: TObject);
 var row : Integer ;
      ss : string ;
begin
//  if karakti.Col = DODK-1 then
  begin
    row := karakti.Row ;
    ss := Karakti.Cells[7,row] ;
    if ss = '' then Karakti.Cells[7,row] := 'X'
               else Karakti.Cells[7,row] := ''
  end;
end;

procedure TFzacetna.KaraktiDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
  var xx,x1,x2 : single ;
      c1,c2 : single  ;
      bx,bb : integer ;
begin
  bx := 0 ;
  try
    xx := strToFloat(karakti.Cells[aCol,aRow]) ;
    x1 := strToFloat(karakti.Cells[3,aRow]) ;
    x2 := strToFloat(karakti.Cells[4,aRow]) ;
    c1 := strToFloat(karakti.Cells[9,aRow]) ;
    c2 := strToFloat(karakti.Cells[10,aRow]) ;
    if (xx < x1) or (xx > x2) then bx := 1 ;
    if (bx = 0) and (abs(c1-c2) > 0.001) then
    begin
      if (xx < c1-3*c2) or (xx > c1+3*c2) then bx := 2 ;
    end ;
  except
    bx := 0
  end;
  if (acol >= DODK) and (aRow > 0) then bb := 1 else bb := 0 ;
  bx := bx*bb;
  if bx > 0 then
  with (karakti) do
  begin
   // if bx = 1 then Canvas.font.Color:=clRed else Canvas.font.Color:= clOlive ;
    if arow = 0 then Canvas.brush.Color:= karakti.fixedColor else
    begin
       //Canvas.brush.Color:=clWhite ;
      if bx = 1 then Canvas.brush.Color:=clRed else Canvas.brush.Color:= clYellow ;
    end;
    Canvas.FillRect(Rect);
    Canvas.TextRect(Rect,Rect.Left+3,Rect.Top+5,Cells[aCol,aRow]);
  end;
end;

procedure TFzacetna.Kodaare1Click(Sender: TObject);
begin
  FlokalBaza.KodPrikaz ;
end;

procedure TFzacetna.Kontrolniplani1Click(Sender: TObject);
begin
   FSqlKode.Pokazi(admin)  ;
end;

procedure TFzacetna.FormActivate(Sender: TObject);
  var i : integer ;
begin
  stanje := 1 ;
  panel1.Color := $02D0FFA0 ;
  //FillDelEnote ;
  if screen.Width <= 1280 then panel3.Width := 950 ;
 // button19.Visible := false ;
//  panel3.Width := 1000 ;
  panel2.Color := $02FFCCFF ;
  karakti.FixedCols := DODK ;
  karakti.Cells[0,0] := 'Pozicija' ;
  karakti.Cells[1,0] := 'Naziv' ;
  karakti.Cells[2,0] := 'Predpis' ;
  karakti.Cells[3,0] := 'Sp. meja' ;
  karakti.Cells[4,0] := 'Zg. meja' ;
  karakti.Cells[5,0] := 'Merilo' ;
  karakti.Cells[6,0] := 'COM' ;
  karakti.Cells[7,0] := 'Graf' ;
  karakti.Cells[8,0] := 'Preraèun' ;
  karakti.colwidths[1] := 190 ;
  karakti.colwidths[6] := 0 ;
  karakti.colwidths[7] := 40 ;
  karakti.colwidths[8] := 0 ;
  karakti.colwidths[9] := 0 ;
  karakti.colwidths[10] := 0 ;
  attri.Cells[0,0] := 'Pozicija' ;
  attri.Cells[1,0] := 'Naziv' ;
  attri.Cells[2,0] := 'Št. vzor.' ;
  attri.Cells[3,0] := 'Vsi dobri' ;
  attri.Cells[4,0] := 'Št. slabih' ;
//  attri.Cells[5,0] := 'Opombe' ;
  attri.colwidths[1] := 240 ;
//  attri.colwidths[5] := 460 ;

 // lokalb := Fpostaje.Getlokal ;
 lokalb := true ;
  if not lokalb then
  begin
    edit3.visible := false ;
    edit4.Visible := false ;
    button14.Visible := false ;
    button5.Visible := false ;
    edit2.Visible := false ;
    button4.Visible := false ;
    postaviListStr ;
    button3.Enabled := admin ;
    menupravice ;
  end else
  begin
    edit2.SetFocus ;
    button1.Enabled := false ;
    pos := 0 ;
    button16.Visible := false ;
    deaktiviraj(false) ;
  end;
  edit5.Brush.Color := clRed ;
  edit6.Brush.Color := clYellow ;
  panel6.Color := $02FFC0C0 ;
  //ReportMemoryLeaksOnShutdown := true ;
  ZacIzm[1] := StrToTime('6:00:00')  ;
  ZacIzm[2] := StrToTime('14:00:00') ;
  ZacIzm[3] := StrToTime('22:00:00') ;
end;

procedure TFzacetna.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Action := TCloseAction.caNone;
end;

procedure TFzacetna.FormCreate(Sender: TObject);
   var rect1 : trect ;
begin
   admin := true ;
   Image1.Canvas.rectangle(Image1.canvas.ClipRect) ;
   if admin  then button19.Caption := 'Odjava admin' else button19.Caption := 'Prijava admin' ;
   { try
    if fileexists('ego.bmp') then
    begin
     rect1.bottom := 68 ;
     rect1.Left := 2 ;
     rect1.Top := 2 ;
     rect1.right := 263 ;
     Bitmap := TBitmap.Create;
     Bitmap.LoadFromFile('ego.bmp');
     //Image1.Canvas.StretchDraw(Image1.canvas.ClipRect,bitmap) ;
      Image1.Canvas.StretchDraw(rect1,bitmap) ;
    end;
    if fileexists('eta.bmp') then
    begin
      rect1.Top := 70 ;
      rect1.bottom := 130 ;
      rect1.right := 200 ;
      Bitmap := TBitmap.Create;

      Bitmap.LoadFromFile('eta.bmp');
     //Image1.Canvas.StretchDraw(Image1.canvas.ClipRect,bitmap) ;
      Image1.Canvas.StretchDraw(rect1,bitmap) ;
    end;
  finally

    end;   }
end;

procedure TFzacetna.Linijekode1Click(Sender: TObject);
begin
  FlokalBaza.LinPrikaz ;
end;


procedure TFzacetna.Linijestrunice1Click(Sender: TObject);
begin
   FlokalBaza.StruzPrikaz ;
end;

// procedura ob izboru stroja
procedure TFzacetna.List3Click(Sender: TObject);

begin
  izbStr := List3.ItemIndex ;
  izborLinije(izbStr) ;
end;

// izbor stroja (linije)
Procedure Tfzacetna.izborLinije(izbStr: integer) ;
var pp : ^zapis ;
      ident : integer ;
      lista : TstringList ;
      deln,kd : string ;
      jx,ll : integer ;
begin
  label10.caption := '' ;
  list6.Visible := false ;
  if lokalb then
  begin
    pp := Liststr[IzbStr] ;
    orod := pp^.naziv ;
    ident := pp^.ident ;
    if ident < 4 then predm := 1 else predm := 2 ;

    lista := Tstringlist.Create ;
    FlokalBaza.GetDod(ident,lista) ;
    if lista.Count > 0  then
    begin
      list6.visible := true ;
      list6.Items := lista ;
    end  ;
    Lista.Free ;
    lista := Tstringlist.Create ;
    FlokalBaza.getKode(ident,lista) ;
    list4.Items := lista ;
    Lista.free ;
  end else IsciKoda ;
  List5.Items.Clear ;
  DodIzbor.visible := false ;
  brisiTabelo ;
end;


procedure TFzacetna.arekarakteristike1Click(Sender: TObject);
begin
  Flokalbaza.SarPrikaz ;
end;

procedure TFzacetna.BrisiTabelo ;
  var i,j : integer ;
      chk : string ;
      cmp : Tcomponent ;
begin
  for i := 1 to  karakti.rowcount-1 do
    for j := 0 to karakti.Colcount-1 do karakti.cells[j,i] := '' ;
  for i := 1 to  attri.rowcount-1 do
  begin
    for j := 0 to attri.Colcount-1 do attri.cells[j,i] := '' ;
    chk := 'chk' + IntTostr(i) ;
    cmp := findComponent(chk) ;
    Tcheckbox(cmp).Free ;
  end;
  edit3.Text := '' ;
  edit2.Text := '' ;
  edit4.Text := '' ;
  if lokalb then edit2.setfocus  ;
end;

procedure TFzacetna.list4Click(Sender: TObject);
  var kd : string ;

begin
  kd := List4.Items[list4.ItemIndex] ;
  IzborKode(kd) ;
  if lokalb then
  begin
    stkanal := Spinedit1.Value ;
    stdec := Spinedit2.Value ;
    startnit ;
  end;
end;

Procedure Tfzacetna.IzborKode(kd : string) ;
  var listsrz : TstringList ;
      listOro : TstringList ;
      ii,nn,kk : integer ;
      vredu : boolean ;
      datt : TdateTime ;
      naselkd : boolean ;
begin
  brisitabelo ;
  list5.Items.Clear ;
  list5.visible := false ;
  label4.Visible := false ;
  listsrz := TstringList.Create ;

  kd := StringReplace(kd,'-','',[]) ;
  kd := StringReplace(kd,'-','',[]) ;
  kd := StringReplace(kd,'-','',[]) ;
//  kd := '00055.600.38' ;
  if lokalb then Flokalbaza.getsarze(kd,listsrz) else
  begin
    listoro := TstringList.Create ;
    FDodatKod.Getlist(kd,Listoro) ;
    if listoro.Count > 0 then
    begin
      DodIzbor.items.clear ;
      dodIzbor.Visible := true ;
      dodIzbor.Items := listoro ;
    end;
    listoro.Free ;
    FsqlKode.getsarza(kd,naselkd,Listsrz) ;
    //showMessage(IntTostr(listsrz.Count)) ;
   // if listsrz.Count = 0 then Fsap.getKonsarza(kd,date-100,listsrz)   ;
  // preverjanje kontrolne sarže
    nn := listsrz.Count ;
    for ii := nn-1 downto 0 do
    begin
      srz := listsrz[ii] ;
      if not Fsap.preveriSar(srz)  then
      begin
        FsqlKode.MarkKoncan(kd,srz) ;
        listsrz.delete(ii) ;
      end ;
    end;
  end;

  nn := listsrz.Count ;
  if nn = 0 then
  begin
     datt := nizTodatum('01.01.2020') ;
     Fsap.getKonsarza(kd,datt,listsrz) ;
     kk := listsrz.Count ;
     if kk = 0 then
     begin
       vredu := false ;
       Showmessage('Napaka kontrolne sarže. Obvesti administratorja') ;
     end ;
     if kk = 1 then
     begin
       srz := listsrz[0] ;
       vredu := true ;
       label10.Caption := 'Kontrolna sarža ' + srz + ' ni registrirana'
     end;
     if kk > 1  then
     begin
       label4.Visible := true ;
       list5.Visible := true ;
       list5.Items := listsrz ;
       vredu := false
     end;
  end;

  if nn = 1  then
  begin
    srz := listsrz[0] ;
    vredu := true
  end;

  if nn > 1  then
  begin
     Showmessage('Napaka kontrolne sarže. Obvesti administratorja') ;
     vredu := false
  end ;

  if vredu  then
  begin
    FillKarakt(kd,srz);
  end;
  listsrz.Free ;

 { if listsrz.Count > 0 then
  begin
    if listsrz.Count  > 1 then
    begin
      label4.Visible := true ;
      list5.Visible := true ;
      list5.Items := listsrz ;
    end else
    begin
      srz := listsrz[0] ;
      if not lokalb then
      begin
        if not Fsap.preveriSar(srz)  then
        begin
          FsqlKode.MarkKoncan(kd,srz) ;
          listsrz.clear ;
          Fsap.getKonsarza(kd,date-100,listsrz) ;
          if listsrz.Count = 1 then  srz := listsrz[0]
            else
            begin
              Showmessage('Napaka kontrolne sarže. Obvesti administratorja') ;
              exit ;
            end;
        end ;
      end;
      FillKarakt(kd,srz);
    end;
  end else ShowMessage('Za to kodo ni odprte nobene kontrolne serije') ;
  listsrz.Free ; }
end;

Procedure TFzacetna.nanovo ;
  var i,j : Integer ;

begin
  for j := DODK+1 to karakti.ColCount-1 do karakti.Cells[j,0] := '' ;
  for i := 1  to Karakti.rowcount-1 do
    for j :=  0 to karakti.ColCount-1 do
      karakti.Cells[j,i] := '' ;
  for i := 1  to attri.rowcount-1 do
    for j :=  0 to attri.ColCount-1 do
    begin
      attri.Cells[j,i] := '' ;

    end;
  label10.Caption := '' ;
  karakti.repaint ;
  edit3.Text := '' ;
  edit2.Text := '' ;
  label1.Hide ;
  if lokalb then edit2.setfocus  ;
  {Image1.Canvas.FillRect(Image1.Canvas.Cliprect) ;
  Image2.Canvas.FillRect(Image2.Canvas.Cliprect) ;
  Image3.Canvas.FillRect(Image3.Canvas.Cliprect) ;
  Image4.Canvas.FillRect(Image4.Canvas.Cliprect) ; }
end;

procedure TFzacetna.list5Click(Sender: TObject);
   var kd : string ;
begin
  srz := List5.Items[list5.ItemIndex] ;
  brisitabelo ;
  kd := List4.Items[list4.ItemIndex] ;
  kd := StringReplace(kd,'-','',[]) ;
  kd := StringReplace(kd,'-','',[]) ;
  kd := StringReplace(kd,'-','',[]) ;
  FillKarakt(kd,srz) ;
end ;



Procedure Tfzacetna.fillkarakt(kd,srz : string);
var listkar1 : tlist ;
      listkar2 : tlist ;
      pp : ^karak ;
      pk : ^atrib ;
      ii : integer ;
      obstaja : boolean ;
      tx : string ;
      kn : integer ;

begin
  listkar1 := Tlist.create ;
  listkar2 := Tlist.create ;

  if lokalb then Flokalbaza.GetKar(predm,srz,stcl,stvp,listkar1,listkar2)
    else
    begin
      FSqlKode.Getplan(kd,srz,obstaja ,stcl,stvp,listkar1,listkar2) ;
      if not obstaja then Fsap.getkarakt(kd,srz,stcl,stvp,listkar1,listkar2) ;
    end;

  karakti.RowCount := listkar1.count+1 ;
  karakti.colcount := DODK + stcl ;
  nkar1 := listkar1.count ;
  nkar2 := listkar2.Count ;
  for ii := 0 to listkar1.count-1 do
  begin
    pp := listkar1[ii] ;
    karakti.Cells[0,ii+1] := pp^.poz ;
    karakti.Cells[1,ii+1] := pp^.naziv ;
    karakti.Cells[2,ii+1] := pp^.predpis ;
    karakti.Cells[3,ii+1] := pp^.spmeja ;
    karakti.Cells[4,ii+1] := pp^.zgmeja ;
    karakti.Cells[7,ii+1] := pp^.oznaka ;


    if pp^.stkan = 0  then karakti.Cells[5,ii+1] := pp^.metoda
       else  karakti.Cells[5,ii+1] := IntTostr(pp^.stkan) ;
    if pp^.com <> 0 then karakti.Cells[6,ii+1] := IntTostr(pp^.com)
      else  karakti.Cells[6,ii+1] := '' ;
    karakti.Cells[8,ii+1] := intToStr(pp^.id) ;
    karakti.Cells[9,ii+1] := FloatTostrF(pp^.avr,ffFixed,8,3) ;
    karakti.Cells[10,ii+1] := FloatTostrF(pp^.stand,ffFixed,8,3) ;
  end;
  for ii := 1 to stcl do karakti.Cells[DODK-1+ii,0] := 'Vzorec ' + intTostr(ii) ;

  attri.RowCount := listkar2.Count +1 ;
  for ii := 0 to listkar2.count-1 do
  begin
    pk := listkar2[ii] ;
    attri.Cells[0,ii+1] := pk^.poz ;
    attri.Cells[1,ii+1] := pk^.naziv ;
    attri.Cells[2,ii+1] := IntToStr(pk^.st_vzor) ;
    setcheck(ii+1) ;
  end;
  Fsap.Pocistikr(listkar1) ;
  Fsap.Pocistiat(listkar2) ;

  if karakti.RowCount > 1 then
  begin
    tx := karakti.Cells[5,1] ;
    if length(tx) <= 2 then
    try
      kn := StrToInt(tx) ;
      spinEdit1.Value := kn ;
    except
    end;
    karakti.Row := 1 ;
  end;
end;

{procedure TFzacetna.Pocisti1(list : Tlist) ;
  var i : integer ;
      pp : ^zapis ;
begin
  if assigned(list) then
  begin
    for i := 0 to (List.Count - 1) do
    begin
      pp := List[i];
      Dispose(pp);
    end;
    List.Free ;
  end;
end;    }

procedure TFzacetna.Postaje1Click(Sender: TObject);
begin
  Fpostaje.pregled(admin) ; ;
 // obnovi ;

  postaviListStr ;
end;


Procedure TFzacetna.deaktiviraj(odl : boolean)  ;
begin
  button4.enabled := odl;
  edit3.Enabled := odl ;
  edit4.Enabled := odl ;
  karakti.Enabled := odl  ;
  button14.Enabled := odl ;
  attri.Enabled := odl ;
  button2.Enabled := odl ;
  button11.Enabled := odl ;
  button13.Enabled := odl ;
  button7.Enabled := odl ;
  button9.Enabled := odl ;
  button17.Enabled := odl ;
  SpinEdit1.Enabled := odl ;
  SpinEdit2.Enabled := odl ;
end;

end.
