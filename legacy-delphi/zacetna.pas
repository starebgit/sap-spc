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
    panel3: TPanel;
    Karakti: TStringGrid;
    attri: TStringGrid;
    Button2: TButton;
    Button1: TButton;
    Button3: TButton;
    MainMenu1: TMainMenu;
    Lokalnabaza1: TMenuItem;
    Linijekode1: TMenuItem;
    Kodaare1: TMenuItem;
    arekarakteristike1: TMenuItem;
    Meritve1: TMenuItem;
    Panel4: TPanel;
    Postaje1: TMenuItem;
    Button9: TButton;
    Postaje2: TMenuItem;
    Stroji2: TMenuItem;
    Kontrolniplani1: TMenuItem;
    Linijestrunice1: TMenuItem;
    Button11: TButton;
    Edit1: TEdit;
    Panel5: TPanel;
    Edit2: TEdit;
    Button13: TButton;
    Edit3: TEdit;
    Edit4: TEdit;
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
    Button19: TButton;
    Edit7: TEdit;
    Label9: TLabel;
    DodIzbor: TListBox;
    Image1: TImage;
    Label10: TLabel;
    Nastavitve1: TMenuItem;
    t1: TMenuItem;
    kanala1: TMenuItem;
    Operacije1: TMenuItem;
    Vaga1: TMenuItem;
    Button15: TButton;
    Panel7: TPanel;
    Panel8: TPanel;
    Label4: TLabel;
    Dodatnekode1: TMenuItem;
    Label5: TLabel;
    Panel9: TPanel;
    Panel10: TPanel;
    Label6: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Button12: TButton;
    Label14: TLabel;
    Timer1: TTimer;
    Info1: TMenuItem;
    Verzija1: TMenuItem;
    Verzije1: TMenuItem;
    Button10: TButton;
    Button16: TButton;
    ZapisD: TMenuItem;
    Merila2: TMenuItem;
    Prijava1: TMenuItem;
    Berimeritve1: TMenuItem;
    procedure FormActivate(Sender: TObject);
    procedure List3Click(Sender: TObject);
    procedure list4Click(Sender: TObject);
  //  procedure list5Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Linijekode1Click(Sender: TObject);
    procedure Kodaare1Click(Sender: TObject);
    procedure arekarakteristike1Click(Sender: TObject);
  //  procedure Button4Click(Sender: TObject);
   // procedure Button5Click(Sender: TObject);
    procedure Meritve1Click(Sender: TObject);
    procedure Postaje1Click(Sender: TObject);
    procedure Stroji1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure KaraktiDblClick(Sender: TObject);
    procedure KaraktiDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure KaraktiClick(Sender: TObject);
    procedure Kontrolniplani1Click(Sender: TObject);
    procedure Linijestrunice1Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    //procedure Edit2Change(Sender: TObject);
    procedure Button13Click(Sender: TObject);
   // procedure Button14Click(Sender: TObject);
    procedure Merilnemetode1Click(Sender: TObject);
    procedure Ukrepi1Click(Sender: TObject);
    procedure MeritveClick(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button19Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Vaga1Click(Sender: TObject);
    procedure Dodatnekode1Click(Sender: TObject);
    procedure attriDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure kanala1Click(Sender: TObject);
    procedure t1Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Verzija1Click(Sender: TObject);
    procedure KaraktiKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Verzije1Click(Sender: TObject);
   // procedure Button6Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
   // procedure ZapisDClick(Sender: TObject);
    //procedure Merila1Click(Sender: TObject);
    procedure Merila2Click(Sender: TObject);
    procedure Prijava1Click(Sender: TObject);
    procedure Berimeritve1Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);

  private

    nkar1,nkar2 : Integer ;
    stcl,stvp : integer ;
    srz : string ;
    imestr : string ;
    kd : string  ;
    pos : Integer ;
    frkMr : integer ;
    izbStr : integer ;
    nemer : boolean ;
    start : boolean ;
    strvkl : array[1..MSTROJ] of boolean ;
    zacIzm : array[1..3] of TdateTime ;
    stanje : integer ;
    predm : integer ;
    admin : boolean ;
    bitmap : TBitmap ;
    ponov : Integer ;
    bermer : integer ;
    Procedure isciKoda ;

  //  procedure Pocisti1(list : Tlist) ;
    procedure BrisiTabelo ;
    function preveriData : boolean  ;
    procedure ZapisSAP ;
 //   Procedure nanovo ;
    //Procedure lokalkoda ;
    Function UrediKodo(kd : string) : string ;
    function PreveriMer(jj,kk: integer) : boolean ;
    Procedure Obnovi ;
    function DolociSt(tx : TDateTime; diff,traj : integer) : integer ;
    Procedure fillkarakt ;
    procedure ZapisSemafor ;
    Procedure setcheck(row : integer) ;
   // Procedure LokalnaBaza ;
    Procedure izborLinije(izbStr: integer) ;
    Procedure IzborKode ;
    Procedure StartNit ;
    procedure postaviListstr ;
    Procedure Getstat(listr : Tlist; var avr,std : single) ;
    Procedure deaktiviraj(odl : boolean) ;
    procedure menupravice ;
    Procedure setzero(Sender: TObject);
  public
    ListStr : Tlist ;
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
  SqlKode, prekini, pass, dodatKod, legenda, Izborsarza, VpisStev, verzija,
  verzije, merila, PrijavaSAP, BeriMeritve;


// pregled meritev
procedure TFzacetna.Button10Click(Sender: TObject);
begin
  FsqlMeritve.pregled(admin) ;
end;


// štart prenosa preko stopalke
procedure TFzacetna.Button11Click(Sender: TObject);
begin
  nemer := false ;
  StartNit ;
end;


procedure TFzacetna.Button12Click(Sender: TObject);
begin
  Flegenda.prikaz(0) ;
end;


// prenos preko stoplake se izvaja v svoji niti.
Procedure Tfzacetna.StartNit ;
begin
  stopal := Tprekini.Create( True );
  stopal.FreeOnTerminate := True;
  stopal.Priority := tpLower ;
  stopal.Resume;
end;


// prekini prenos preko stopalke
procedure TFzacetna.Button13Click(Sender: TObject);
  var cm : string ;
begin
  cm := karakti.Cells[6,1] ;
  if cm = '' then cm := 'COM3' else cm := 'COM' + cm ;
  FComPort.prekini(cm,true) ;
  button11.Enabled := true ;
end;


procedure TFzacetna.Button16Click(Sender: TObject);
begin
  postaviListstr
end;


// izris grafov
procedure TFzacetna.Button17Click(Sender: TObject);
  var ii,jj : integer ;
      stkar : string ;
      listr : tlist ;
      nz : string ;
      img,stvz : integer ;
      sr,sp,zg : single ;
      avr,std : single ;
begin
  ii := list4.ItemIndex ;
 // kd := list4.Items[ii] ;
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
      button19.Caption := 'Odjava' ;
     //edit10.Text := 'admin' ;
      label13.Caption := 'Adminstrator'
    end else showMessage('Geslo ni pravilno')
  end else
  begin
    admin := false ;
   // edit10.Text := 'uporabnik' ;
    label13.Caption := 'Uporabnik' ;
    button19.caption := 'Prijava'
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
  //button16.Visible := admin ;
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


procedure TFzacetna.Image1Click(Sender: TObject);
begin

end;

// izvedba prepisa v SAP-a
procedure TFzacetna.Button1Click(Sender: TObject);
 var bb : boolean ;
      i : integer ;
begin
  nemer := true ;
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
        ss,s1 : string ;
 begin
   try
     ss := karakti.Cells[kk +DODK,jj] ;
     s1 := replacestr(ss,'.',',') ;
     xx := StrToFloat(s1) ;
     sp := StrToFloat(karakti.Cells[3,jj]) ;
     zg := StrToFloat(karakti.Cells[4,jj]) ;
     if (xx-sp > -0.0001) and (zg-xx > -0.0001) then result := true else result := false
   except
     result := false
   end;
end ;


// dostop do podatkov o SAP serverjih
procedure TFzacetna.Prijava1Click(Sender: TObject);
begin
  FprijavaSAP.prikaz ;
end;

// vpogled v bazo strojev
procedure TFzacetna.Stroji1Click(Sender: TObject);
begin
  Fstroji.pogled(admin,pos) ;
end;

procedure TFzacetna.t1Click(Sender: TObject);
begin
   stkanal := FvpisStev.Vpis('Vpis štev. kanala','Številka merila',stkanal)
end;

// timer za posodobitev stanja semaforja
procedure TFzacetna.Timer1Timer(Sender: TObject);
begin
  if ((ponov mod 10) = 1) and nemer then  PostaviListStr ;
  if (pos > 0) and nemer then Obnovi  ;
  inc(ponov) ;
end;

// vpogled v bazo ukrepov
procedure TFzacetna.Ukrepi1Click(Sender: TObject);
begin
  Fukrepi.prikaz ;
end;


procedure TFzacetna.Vaga1Click(Sender: TObject);
   var uk,rz : string ;
begin
   uk := edit1.Text ;
   rz := FComPort.preberi3(uk) ;
end;

procedure TFzacetna.Verzija1Click(Sender: TObject);
begin
  FVerzija.pokazi ;
end;

procedure TFzacetna.Verzije1Click(Sender: TObject);
begin
  Fverzije.pokazi
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
    try
      pp := liststr[ii] ;
      sx := intTostr(pp^.ident) ;
      if strvkl[i] then    // èe je stroj aktiven
      begin
        if novaiz then        // zaèetek izmene
        begin
          astanje[i] := 2;
          acas[i] := tt - pp^.diff/24/60  ;
        end else
        begin
          t1 := 0 ;
          if ids <> 0 then t1 := FSemafData.GetzapisCas(ids,pos,sx) ;   // podateki o zadnji meritvi
          if t1 = 0 then  // èe ni podatkov o zadnji meritvi
          begin
            if acas[i] = 0 then
            begin
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
    except
      pisiLog(intTostr(pos) + ' Ni liste strojev') ;
    end;
  end;
end;


// Procedura v izbirno polje za kode doda kode iste skupine kot je prav koda na listi.
procedure TFzacetna.Dodatnekode1Click(Sender: TObject);
   var ii,jj : integer ;
      ss,sx : string ;
      listkd : TstringList ;
begin
  if not dodatnekode1.Checked  then
  begin
    ii := list4.Items.count ;
    if ii > 0 then ss := list4.Items[0] else exit ;
    ss := urediKodo(ss) ;
    listkd := TstringList.Create ;
    Fsqlkode.GetlistaKod(ss,listkd) ;
    list4.items := Listkd ;
    listkd.free ;
  end else
    list4.items.clear ;
  dodatnekode1.Checked := not dodatnekode1.Checked ;
end;

// funkcija vrne stanje meritev (zelena,rumena,rdeèa)
function TFzacetna.DolociSt(tx : TDateTime; diff,traj : integer) : integer ;
  var tt : TDateTime ;
      dd,xx : single ;
      ist : integer ;
begin
   tt := time ;
   dd := tt - tx ;
   ist := 1;
   if dd*24 > (diff-traj)/60 then ist := 2 ;
   if dd*24 > diff/60  then ist := 3 ;
   result := ist ;
end;


procedure TFzacetna.kanala1Click(Sender: TObject);
begin
  stdec := FvpisStev.Vpis('Decimalke','Število decimalk',stdec)
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
       opr,stk : string ;
       slb,stnp,id,iddod : integer ;
       imekt : string ;
       orod,idstr : string ;
       pps : ^zapis ;

begin
   // pridobim št. operacije
   if karakti.Cells[8,1] <> '' then
   begin
     id := StrToInt(karakti.Cells[8,1]) ;
     opr := FsqlKode.Getoper(id) ;
   end else opr := '0010' ;

   // pridobim ime kontrolne toèke
   imekt := Fpostaje.Getimekt ;
   if imekt <> '' then nazivp := imekt else nazivp := imestr ;

   // preberem morebitno dodatno opredelitev
   iddod := dodIzbor.ItemIndex ;
   if iddod >= 0 then orod := DodIzbor.items[iddod] else orod := '' ;

   // merilec
   merl := label12.Caption ;
   karlist := Tlist.Create ;
   ii := 0 ;
   odl := 'A' ;
   evalList := TList.Create ;
   for jj := 1 to nkar1 do          // po vseh variabilnih karakteristikah
   begin
     new(px) ;
     px^.imekar := karakti.Cells[1,jj];
     px^.stkar := karakti.Cells[0,jj];
     px^.ev := 'A' ;
     px^.st := 0 ;

     for kk := 1 to stcl do         // po vse vzeh meritvah iste karakteristike
     begin
       new(pv) ;
       pv^.stevnp := 0 ;
       pv^.stkar := karakti.Cells[0,jj];
       pv^.imekar := karakti.Cells[1,jj];
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
       pv^.imekar := attri.cells[1,jj];
       pv^.stevilvz := kk ;
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
         if (pv^.stkar = stk) and (pv^.tip = '01') and (pv^.eval = 'R')  then  pv^.opom := px^.op ;
         if (pv^.stkar = stk) and (pv^.tip = '02') then pv^.opom := px^.op
       end;
     end;
   end;

   dd := now ;
  // kd := list4.items[list4.ItemIndex] + '/00';
   //  kd := list4.items[list4.ItemIndex] ;
   if karlist.Count > 0 then Fsap.zapis(srz,opr,nazivp,merl,odl,orod,dd,karlist,evalList)  ;
   pps := liststr[izbstr] ;
   idstr := IntTostr(pps^.ident) ;
   if karlist.Count > 0 then Fsqlmeritve.zapis(kd,srz,orod,idstr,merl,karlist)  ;
   CistiListE(evallist) ;
   CistiList1(karList) ;
end;

// prenos enega podatka iz merilne naprave
procedure TFzacetna.Button2Click(Sender: TObject);
  var row,col : Integer ;
      mer : single ;
      cm,mr : string ;
      ii,ll : Integer ;

begin
   nemer := false ;
   row := Karakti.Row ;
   col := karakti.Col ;
   if lokalb then cm := karakti.Cells[6,row] else cm := Fpostaje.getcom;
   if cm = '' then cm := 'COM3' else cm := 'COM' + cm ;

   if stkanal <= 8 then mer := FComPort.preberi(stkanal,cm)
                   else mr := FcomPort.odpri(cm) ;

   if stkanal <= 8 then karakti.Cells[col,row] := FloatTostrF(mer,ffFixed,10,stdec) ;
   // podatek iz vage se posebej obravnava
   if stkanal = 9 then
   begin
     mr := trim(mr) ;
     ll := length(mr) ;
     ii := ll-2 ;
     while mr[ii] <> ' ' do ii := ii-1 ;
     mr := copy(mr,ii+1,ll-ii-2) ;
     mr := replaceStr(mr,'.',',') ;
     karakti.Cells[col,row] := mr ;
   end ;
   if stkanal = 10 then   // Posebnost ?
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


// kreiranje checkbox-ov v tabeli atributov
Procedure Tfzacetna.setcheck(row : integer) ;
begin
    with TCheckBox.create(self) do
    begin
      name := 'chk' + IntTostr(row) ;
      caption := '' ;
      Parent := panel4 ;
      left := attri.colwidths[0] + attri.colwidths[1] + attri.colwidths[2] + 20 ;
      width := 30 ;
      top := 25*row + panel10.height + 5 ;
      color := clBtnFace ;
      onClick := setzero ;
      color := clWhite ;
      parentColor := true ;
    end;
end;


// postavitev 0 ob kliku na checkboc v tabeli atributov
Procedure Tfzacetna.setzero(Sender: TObject);
  var rw : integer ;
      nm : string ;
begin
  nm := TcheckBox(sender).name ;
  rw := StrToInt(copy(nm,4,1)) ;
  attri.cells[4,rw] := '0' ;
  TcheckBox(sender).color := clWhite ;
end;


// Procedura izdela listo strojev za trenutno izbrano postajo
procedure Tfzacetna.postaviListstr ;
 var ii : integer ;
      pp : ^zapis ;
      ident : integer ;
      listak : TstringList ;
      kdd,kd1 : string ;
      diff,traj : integer ;
begin
  if pos > 0 then
  begin
    pocisti1(liststr) ;
    ListStr := tlist.Create ;    // listastr je lista strojev
    Fstroji.GetStroji(pos,ListStr) ;
    list3.Items.Clear ;
    for ii := 0 to listStr.count-1 do
    begin
      try
        pp := listStr[ii] ;
        ident := pp^.ident ;
        listak := TstringList.create ;
        Fsinapro.Getkoda1(ident,listak) ;
        if listak.count > 0 then
        begin
          kd1 := Listak[0] ;
          kdd := replaceStr(kd,'-','') ;
          kdd := trim(kdd) ;
          listak.Free ;
          FsqlKode.getinterval(kdd,diff,traj,pos) ;
          pp^.diff :=  diff ;
          pp^.traj :=  traj ;
        end;
        list3.Items.add(pp^.naziv) ;
        acas[ii+1] := 0 ;
        strvkl[ii+1] := Fsinapro.PreveriStroj(pp^.ident) ;   // preverim èe je stroj aktiven
       except
         PisiLog('Problem z listo strojev') ;
       end;
     end;
  end ;
end;

// procedura odpre semafor
procedure TFzacetna.Button9Click(Sender: TObject);
begin
  if not assigned(liststr)  then  exit ;
  obnovi ;
  Fsemafor.frk := frkmr ;
  Fsemafor.prikazi(admin)  ;
end;


// pred zapisom v SAP se preveri èe so podatki v obeh tabelah primerni.
function TFzacetna.preveriData : boolean  ;
  var jj,kk : Integer ;
      xx : single ;
      bb : boolean ;
      ss,s1 : string ;
begin
  bb := true ;
  for jj  := 1 to nkar1 do
  begin
    if not bb  then break ;
    for kk := 1 to stcl do
    begin
      try
        ss := karakti.Cells[kk +DODK-1,jj] ;
        s1 := replacestr(ss,'.',',') ;
        xx :=  StrToFloat(s1) ;
      except
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


procedure TFzacetna.Merila2Click(Sender: TObject);
  var imep : string ;
begin
  imep := label11.Caption ;
  Fmerila.pokazi(admin,pos,imep) ;
end;

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

// Procedura se izvede po izboru stroja (linije). Definira nabor kod za izbirno polje kod
Procedure TFzacetna.isciKoda ;
  var ii : integer ;
      pp : ^zapis ;
      ident : integer ;
      listak : TstringList ;
      I,ipx : Integer;
      kdd,xpx : string ;
      imm : string ;

      naselKd : boolean ;
      kdp : integer ;
begin
   list4.Items.Clear ;
   pp := Liststr[IzbStr] ;
   imestr := pp^.naziv ;
   ident := pp^.ident ;
   imm := Fsinapro.Getdelavec(ident) ;
   if imm <> '' then  label12.Caption := imm else label12.Caption := '(ni prijave)' ;

   listak := TstringList.create ;
   kdp := FPostaje.GetIzbira ;
   case kdp  of
     0 : Fsinapro.Getkoda1(ident,listak) ;   // kodo išèem v sinapro bazi
     1 : FSqlKode.Getlista(listak) ;         // vse kode za to merilno mesto
     2 : Fstroji.Getkode(ident,listak) ;     // se (še) ne uporablja
   end;

   for i := 0 to listak.Count-1 do
   begin
     kd := trim(Listak[i]) ;
     if length(kd) = 18 then
     begin
      kd := KodaForm(kd,'/',false) ;
      while (kd[1] = '0') or (kd[1] = '.')  do kd := copy(kd,2,18) ;
     end;

    // ShowMessage(intTostr(length(kd))) ;
     kdd := replaceStr(kd,'-','') ;
     kdd := trim(kdd) ;
     //Showmessage(kd) ;
     naselKd := FsqlKode.PreveriKodo(kdd) ;
     if not naselKd then
     begin
       ipx := system.pos('/',kdd) ;
       xpx := Copy(kdd,ipx+1,2) ;
       if xpx = '01' then kdd := copy(kdd,1,ipx) + '00'
                     else kdd := copy(kdd,1,ipx) + '01' ;
       if not FsqlKode.PreveriKodo(kdd) then kdd := '' ;
       kd := kdd ;
     end ;
     if kd <> '' then list4.items.add(kd)

   end;
   if listak.Count = 0 then showmessage('Nisem našel kode') ;
   if (listak.count > 0) and (list4.items.count = 0) then showmessage('Koda ' + listak[0] + ' nima kontrolne serije') ;

   lIstak.free ;
end;


// Ob kliku v tabelo var. karakter. se redinira glabalni podatek stkanl (številka kanala)
procedure TFzacetna.KaraktiClick(Sender: TObject);
  var row,kn : integer ;
      tx : string ;
begin
  row := karakti.Row ;
  tx := karakti.Cells[5,row] ;
  if length(tx) <= 2 then
  try
    kn := StrToInt(tx) ;
    stkanal := kn
  except
  end ;
end;


// oznèevanje kakter. za izdelavo grafa
procedure TFzacetna.KaraktiDblClick(Sender: TObject);
 var row : Integer ;
      ss : string ;
begin
  row := karakti.Row ;
  ss := Karakti.Cells[7,row] ;
  if ss = '' then
  begin
      Karakti.Cells[7,row] := 'X' ;
      button17.Enabled := true ;
  end
     else Karakti.Cells[7,row] := ''
end;


// Izris tabele var. karakter. je nekoliko prirejen
// meritve ki so izven tolerance se ipišejo v rdeèem
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
    if arow = 0 then Canvas.brush.Color:= karakti.fixedColor else
    begin
      if bx = 1 then Canvas.brush.Color:=clRed else Canvas.brush.Color:= clYellow ;
    end;
    Canvas.FillRect(Rect);
    Canvas.TextRect(Rect,Rect.Left+3,Rect.Top+5,Cells[aCol,aRow]);
  end;
end;

// Uporaba tipke ENTER pomeni prehod v novo vrstico
procedure TFzacetna.KaraktiKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
   var row,col : integer ;
begin
  if ord(key) = 13 then
  begin
    row := karakti.Row ;
    col := karakti.col ;
    if row < nkar1 then karakti.row := row+1
    else
    begin
      karakti.row := 1 ;
      if col < DODK + stcl -1  then karakti.col := col +1
    end  ;
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

// zaèetna postavitev
procedure TFzacetna.FormActivate(Sender: TObject);
  var i : integer ;
begin
  ReportMemoryLeaksOnShutdown := true ;
  stanje := 1 ;
  stkanal := 1 ;
  stdec := 2 ;
  ponov := 1 ;
  bermer := 1 ;
  panel1.Color := $02DEDAC0 ;
  panel5.Color := $02DEDAC0 ;
  panel4.Color := clWhite;
  panel9.Color := $02666000 ;
  panel10.Color := $02666000 ;
  if admin  then label13.caption := 'Administrator' else label13.caption := 'Uporabnik' ;
  if screen.Width <= 1280 then panel3.Width := 920 ;
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
  attri.colwidths[1] := 240 ;

  lokalb := false ;
  edit3.visible := false ;
  edit4.Visible := false ;
  edit2.Visible := false ;
  button3.Enabled := admin ;
  pos := Fpostaje.Getpost ;
  label11.Caption := Fpostaje.GetImePost ;
  menupravice ;

  edit5.Brush.Color := clRed ;
  edit6.Brush.Color := clYellow ;
  panel6.Color := $02FFC0C0 ;

  ZacIzm[1] := StrToTime('6:00:00')  ;
  ZacIzm[2] := StrToTime('14:00:00') ;
  ZacIzm[3] := StrToTime('22:00:00') ;

  if start  then
  begin
    PostaviListStr ;
    obnovi ;
    Fsemafor.frk := frkmr ;
    Fsemafor.prikazi(admin)  ;
    start := false ;
  end;
end;

procedure TFzacetna.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Bitmap.Free ;

  if not admin then Action := TCloseAction.caNone;
end;


// zaèetna postavitev
procedure TFzacetna.FormCreate(Sender: TObject);
   var rect1 : trect ;
begin
   admin := true ;
   nemer := true ;
   start := true ;
   Image1.Canvas.rectangle(Image1.canvas.ClipRect) ;
   if admin then button19.Caption := 'Odjava' else button19.Caption := 'Prijava' ;
    try
      if fileexists('ego.bmp') then
      begin
        rect1.bottom := 120 ;
        rect1.Left := 15 ;
        rect1.Top := 70 ;
        rect1.right := 205 ;
        Bitmap := TBitmap.Create;
        Bitmap.LoadFromFile('ego.bmp');
        Image1.Canvas.StretchDraw(rect1,bitmap) ;
         Image1.Canvas.Font.Size := 14 ;
       Image1.Canvas.textOut(30,121,'ETA Cerkno, d.o.o.') ;
      end;
    finally

    end;
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
      deln : string ;
      jx,ll : integer ;
begin
  label10.caption := '' ;
  if lokalb then
  begin
    pp := Liststr[IzbStr] ;
    imestr := pp^.naziv ;
    ident := pp^.ident ;
    if ident < 4 then predm := 1 else predm := 2 ;

    lista := Tstringlist.Create ;
    FlokalBaza.GetDod(ident,lista) ;
    Lista.Free ;
    lista := Tstringlist.Create ;
    FlokalBaza.getKode(ident,lista) ;
    list4.Items := lista ;
    Lista.free ;
  end else IsciKoda ;
  DodIzbor.items.clear  ;
  DodIzbor.Visible := false ;
  label14.Visible := false ;
  button17.Enabled := false ;
  brisiTabelo ;
end;


procedure TFzacetna.arekarakteristike1Click(Sender: TObject);
begin
  Flokalbaza.SarPrikaz ;
end;


// Izris tabele atrib. karakter. je nekoliko prirejen - barvanje napak
procedure TFzacetna.attriDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
  var ix : integer ;
      bx : boolean ;
begin
 if (acol = 4) and (aRow > 0)  then
 begin
   ix := StrToIntDef(attri.cells[aCol,aRow],0);
   if ix = 0 then bx := false else bx := true
 end else bx := false ;
 with (attri) do
  begin
    if arow = 0 then Canvas.brush.Color:= karakti.fixedColor else
    begin
      if bx  then Canvas.brush.Color:=clRed else Canvas.brush.Color:= clWhite ;
    end;
    Canvas.FillRect(Rect);
    Canvas.TextRect(Rect,Rect.Left+3,Rect.Top+5,Cells[aCol,aRow]);
  end;
end;


// odloèitev o tem naj se prebere stare meritve
procedure TFzacetna.Berimeritve1Click(Sender: TObject);
  var ii : Integer ;
begin
   ii := FBeriMeritve.izbira(bermer) ;
   if ii <> 2 then BerMer := ii
end;


// brisanje vsebine obeh tabel
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
end;

// ob izboru kode
procedure TFzacetna.list4Click(Sender: TObject);
begin
 // kd := List4.Items[list4.ItemIndex] + '/00' ;
  kd := List4.Items[list4.ItemIndex]  ;
  IzborKode ;
end;

// popravilo kode izdelka
Function Tfzacetna.UrediKodo(kd : string) : string ;
begin
  kd := StringReplace(kd,'-','',[]) ;
  kd := StringReplace(kd,'-','',[]) ;
  kd := StringReplace(kd,'-','',[]) ;
  kd := StringReplace(kd,'-','',[]) ;
  result := trim(kd) ;
end;


// po izboru kode se izvede ta procedura
Procedure Tfzacetna.IzborKode ;
  var listsrz : TstringList ;
      listOro : TstringList ;
      ii,nn,kk : integer ;
      vredu : boolean ;
      datt : TdateTime ;
      naselkd : boolean ;
      mess : string ;
      ip1 : integer ;
begin
  brisitabelo ;
  listsrz := TstringList.Create ;
  kd := UrediKodo(kd) ;
  // preverim dodatne opredelitve
  listoro := TstringList.Create ;
  FDodatKod.Getlist(kd,Listoro) ;
  if listoro.Count > 0 then
  begin
      label14.Visible := true ;
      DodIzbor.items.clear ;
      dodIzbor.Visible := true ;
      dodIzbor.Items := listoro ;
  end;
  listoro.Free ;

  // Poišèem šaržo
  FsqlKode.vrniSarzo(kd,Listsrz) ;
  if listsrz.Count > 0 then       // šaržo sem našel
  begin
     srz := listsrz[0] ;
     vredu := true ;
  end else
  begin                 // šarže nisem našel
     datt := nizTodatum('01.01.2018') ;
     Fsap.getKonsarza(kd,datt,true,listsrz) ;    // zdaj šarže išèem v SAP-u
     if listsrz.Count = 1  then       // èe sem šaržo našel jo zapišem v bazo
     begin
       srz := listsrz[0] ;
       vredu := true ;
       FsqlKode.Zapsar(kd,srz) ;
       FsqlKode.Prenoskar(srz) ;
     end else
     begin
       mess := 'Izbrana koda nima kontrolne šarže' + Chr(13) + 'Prosim kontaktiraj administratorja programa' ;
       showMessage(mess) ;
       exit ;
     end;
  end;

  if vredu then FillKarakt;
  listsrz.Free ;
end;

// definicija obeh tabel s karakteristikami
Procedure Tfzacetna.fillkarakt ;
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

  // èitanje plana kontrole
  FSqlKode.Getplan(bermer,kd,srz,obstaja ,stcl,stvp,listkar1,listkar2) ;
  // èe plana kontroler ne najdem v sql bazi poskusim v SAP bazi
  if not obstaja then Fsap.getkarakt(kd,srz,listkar1,listkar2) ;

  karakti.RowCount := listkar1.count+1 ;
  karakti.colcount := DODK + stcl ;
  nkar1 := listkar1.count ;
  nkar2 := listkar2.Count ;
  for ii := 0 to listkar1.count-1 do    // variabilbne karakteristike
  begin
    pp := listkar1[ii] ;
    karakti.Cells[0,ii+1] := pp^.poz ;
    karakti.Cells[1,ii+1] := pp^.naziv ;
    karakti.Cells[2,ii+1] := pp^.predpis ;
    karakti.Cells[3,ii+1] := pp^.spmeja ;
    karakti.Cells[4,ii+1] := pp^.zgmeja ;
    karakti.Cells[7,ii+1] := pp^.oznaka ;
    if pp^.oznaka = 'X' then button17.enabled := true ;


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
  for ii := 0 to listkar2.count-1 do         // atributivne karakterisitke
  begin
    pk := listkar2[ii] ;
    attri.Cells[0,ii+1] := pk^.poz ;
    attri.Cells[1,ii+1] := pk^.naziv ;
    attri.Cells[2,ii+1] := IntToStr(pk^.st_vzor) ;
    setcheck(ii+1) ;
  end;
  Fsap.Pocistikr(listkar1) ;
  Fsap.Pocistiat(listkar2) ;

  // definiram globalno spremenljivko stkanal
  if karakti.RowCount > 1 then
  begin
    tx := karakti.Cells[5,1] ;
    if length(tx) <= 2 then
    try
      kn := StrToInt(tx) ;
      stkanal := kn
    except
    end;
    karakti.Row := 1 ;
  end;
end;

// pregled seznama merilnih mest
procedure TFzacetna.Postaje1Click(Sender: TObject);
begin
  Fpostaje.pregled(admin) ;
  pos := Fpostaje.Getpost ;
  ponov := 1 ;
end;


Procedure TFzacetna.deaktiviraj(odl : boolean)  ;
begin
  edit3.Enabled := odl ;
  edit4.Enabled := odl ;
  karakti.Enabled := odl  ;
  attri.Enabled := odl ;
  button2.Enabled := odl ;
  button11.Enabled := odl ;
  button13.Enabled := odl ;
  button9.Enabled := odl ;
  button17.Enabled := odl ;
end;

end.
