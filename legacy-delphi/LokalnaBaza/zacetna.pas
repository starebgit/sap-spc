unit zacetna;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,Data.Win.ADODB,
  Data.DB, deklar, Vcl.Grids, Vcl.Samples.Spin, Vcl.Menus, ComObj,semafdata, System.strUtils;

  const
    DODK = 9 ;
    MSTROJ = 30 ;
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
    Button6: TButton;
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
    CheckBox1: TCheckBox;
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
    procedure Button6Click(Sender: TObject);
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
    procedure CheckBox1Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);

  private
    ListStr : Tlist ;
    nkar1,nkar2 : Integer ;
    stcl,stvp : integer ;
    srz : string ;
    orod : string ;

    pos : Integer ;
    frkMr : integer ;
    izbStr : integer ;
    strvkl : array[1..3] of boolean ;
    zacIzm : array[1..3] of TdateTime ;
    stanje : integer ;
    predm : integer ;
    Procedure isciKoda ;
  //  procedure Pocisti1(list : Tlist) ;
    procedure BrisiTabelo ;
    function preveriData : boolean  ;
    procedure ZapisSAP ;
    Procedure nanovo ;
    Procedure lokalkoda ;
    function PreveriMer(jj,kk: integer) : boolean ;
    Procedure Obnovi ;
    function DolociSt(tx : TDateTime) : integer ;
    Procedure fillkarakt(srz : string);
    procedure ZapisSemafor ;
    Procedure setcheck(row : integer) ;
    Procedure IzborStr ;
    Procedure LokalnaBaza ;
    Procedure izborLinije(izbStr: integer) ;
    Procedure IzborKode(kd : string) ;
    Procedure StartNit ;
  public
    lokalb : boolean ;
    ListamaxMin : TstringList ;
    psb : boolean ;
    acas : array[1..MSTROJ] of TdateTime ;
    astanje : array[1..MSTROJ] of integer ;
  end;

var
  Fzacetna: TFzacetna;

implementation

{$R *.dfm}

uses sap, ComPort, lokalBaza, lokalmeritve, postaje, stroji, sinapro, semafor,
  SqlKode, prekini;




procedure TFzacetna.Button10Click(Sender: TObject);
  var uk,rz : string ;
begin
   uk := edit1.Text ;
   rz := FComPort.preberi3(uk) ;
  // edit1.Text := rz ;
end;

procedure TFzacetna.Button11Click(Sender: TObject);
var stk,row,col,std,rw,stm: Integer ;
     mtd,cm : string ;
     listk : Tlist ;
     pp : ^Merkanal ;
     ii : integer ;
begin

  StartNit ;



 {  row := Karakti.Row ;
   col := karakti.Col ;
   cm := karakti.Cells[6,row] ;
   if cm = '' then cm := 'COM3' else cm := 'COM' + cm ;
   std := spinedit2.Value ;
   stk := spinEdit1.value ;
   mtd := Karakti.Cells[5,row] ;
   if mtd = '' then exit ;

   rw := row ;
   stm := 1 ;
   listk := Tlist.Create ;
   while rw < karakti.RowCount-1 do
   begin
     inc(rw) ;
     if mtd <> Karakti.Cells[5,rw]  then
     begin
       new(pp) ;
       pp^.kanal := stk ;
       pp^.stmeritev := stm ;
       listk.add(pp) ;
       stm := 0
     end;
     mtd := Karakti.Cells[5,rw] ;
     stk := StrToInt(mtd) ;
     inc(stm) ;
   end;
   new(pp) ;
   pp^.kanal := stk ;
   pp^.stmeritev := stm ;
   listk.add(pp) ;

   Button11.visible := false ;
   FComPort.preberi2(row,col,std,cm,listk) ;
   for ii := 0 to (listk.Count - 1) do
   begin
        pp := listk[ii];
        Dispose(pp);
   end;
   listk.Free ;
  Button11.visible := true ;   }
end;

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

procedure TFzacetna.Button13Click(Sender: TObject);
  var cm : string ;
begin
  cm := karakti.Cells[6,1] ;
  if cm = '' then cm := 'COM3' else cm := 'COM' + cm ;
  FComPort.prekini(cm,true) ;
  button11.Enabled := true ;
end;

procedure TFzacetna.Button14Click(Sender: TObject);
  var cm : string ;
begin
  psb := false ;
  cm := karakti.Cells[6,1] ;
  if cm = '' then cm := 'COM3' else cm := 'COM' + cm ;
  FcomPort.Prekini(cm,false) ;
 // button14.Visible := false ;
 // Karakti.row := Karakti.row + 2 ;
end;

procedure TFzacetna.Button15Click(Sender: TObject);
  var cm : string ;
begin
  cm := karakti.Cells[6,1] ;
  if cm = '' then cm := 'COM3' else cm := 'COM' + cm ;
  FcomPort.pisi(cm) ;
end;

procedure TFzacetna.Button1Click(Sender: TObject);
 var bb : boolean ;
      i : integer ;
begin
  screen.Cursor := crHourGlass;
  // for i := 1 to MSTROJ do strvkl[i] := Fsinapro.PreveriStroj(i) ;
  // ZapisSemafor ;
  ZapisSemafor ;
  bb := Preveridata ;
  if bb then
  begin
    try
      ZapisSAP ;
     // nanovo
      brisitabelo ;
    except
    end;
  end;
  screen.Cursor := crDefault;
end;


procedure TFzacetna.ZapisSemafor ;
  var kds : TstringList ;
      i,izb: Integer;
      pp : ^zapis ;
      idstr : integer ;
begin
  izb := izbStr+1 ;
  if izbstr > 0 then
  begin
    pp := ListStr[izbstr] ;
    idstr := pp^.ident ;
    astanje[izb] := 1 ;
    acas[izb] := time ;
    FsemafData.Zapis(pos,idstr) ;
  end;
end;

function TFzacetna.PreveriMer(jj,kk: integer) : boolean ;
    var xx,sp,zg : single ;
 begin
   try

     xx := StrToFloat(karakti.Cells[kk +DODK,jj]) ;
     sp := StrToFloat(karakti.Cells[2,jj]) ;
     zg := StrToFloat(karakti.Cells[3,jj]) ;
     if (xx-sp > -0.0001) and (zg-xx > -0.0001) then result := true else result := false
   except
     result := false
   end;
 end ;

procedure TFzacetna.Stroji1Click(Sender: TObject);
begin
  pos := Fpostaje.Getpost ;
  Fstroji.pogled(pos) ;
end;

procedure TFzacetna.Timer1Timer(Sender: TObject);
begin
  if pos > 0 then Obnovi
end;

Procedure TFzacetna.Obnovi ;
   var dat,t1,tt: TdateTime ;
       izm,ids,i : Integer ;
       xx : single ;
       novaiz : boolean ;
       bc : boolean ;
begin
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

  for i := 1 to MSTROJ do
  begin
    if strvkl[i] then
    begin
      if novaiz then
      begin
        astanje[i] := 2;
        acas[i] := tt - frkMr/24  ;
      end else
      begin
        t1 := 0 ;
        if ids <> 0 then t1 := FSemafData.GetzapisCas(ids,i,pos) ;
        if t1 = 0 then
        begin
          if acas[i] = 0 then
          begin
             acas[i] := ZacIzm[izm] - frkMr/24 ;
            {case izm of
              1 : acas[i] := strToTime('04:00:00')  ;
              2 : acas[i] := strToTime('12:00:00')  ;
              3 : acas[i] := strToTime('20:00:00')  ;
            end;  }
            astanje[i] := dolociSt(acas[i])
          end else astanje[i] := dolociSt(acas[i]) ;
        end else
        begin
          acas[i] := t1  ;
          astanje[i] := dolociSt(acas[i])
        end;
      end;
    end else astanje[i] := 9
  end;
end;

function TFzacetna.DolociSt(tx : TDateTime) : integer ;
  var tt : TDateTime ;
      dd,xx : single ;
      ist : integer ;
begin
   tt := time ;
   dd := tt - tx ;
   ist := 1;
   if dd*24 > frkMr then ist := 2 ;
   if dd*24 > FrkMr + 0.5 then ist := 3 ;
   result := ist ;
end;

procedure TFzacetna.Edit2Change(Sender: TObject);
begin
  IzborStr ;
end;


Procedure TFzacetna.IzborStr ;
  var idnt : string ;
      lin : Integer ;
      struz : string ;
      ii : integer ;
      kd : string ;
begin

   idnt := edit2.text ;
   if length(idnt) < 7 then  exit ;
   idnt[6] := '-' ;
   //Showmessage(idnt) ;
   lokalnabaza ;
  FlokalBaza.Getstruz(idnt,lin,struz) ;
  list3.ItemIndex := lin-1 ;
  Izborlinije(lin-1) ;
  ii := list6.Items.IndexOf(struz) ;
  List6.ItemIndex := ii ;
  kd := List4.Items[0] ;
  IzborKode(kd) ;
  list4.ItemIndex := 0 ;
  StartNit ;
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
       opr : string ;
       slb,stnp,id : integer ;

  {procedure  cistiList1 ;
    var i : integer ;
  begin
    if assigned(karlist) then
    begin
      for i := 0 to (karlist.Count - 1) do
      begin
        pv := karlist[i];
        Dispose(pv);
      end;
      karlist.Free ;
    end;
  end;

  procedure  cistiListE ;
    var i : integer ;
  begin
    if assigned(evallist) then
    begin
      for i := 0 to (evallist.Count - 1) do
      begin
        px := evallist[i];
        Dispose(px);
      end;
      evallist.Free ;
    end;
  end;  }

begin
  // vzz := StrToInt(karakti.Cells[3,1]) ;

 //  opr := Fsap.BeriOperac(srz)  ;
   id := StrToInt(karakti.Cells[8,1]) ;
   opr := FsqlKode.Getoper(id) ;
   nazivp := 'Strojna' ;
 //  merl := ListBox1.Items[ListBox1.ItemIndex] ;    // merilec
   karlist := Tlist.Create ;
   ii := 0 ;
   odl := 'A' ;
 //  stvz := 12 ;
   evalList := TList.Create ;
   for jj := 1 to nkar1 do
   begin
     new(px) ;
     px^.ev := 'A' ;
     px^.st := 0 ;

     for kk := 1 to stcl do
     begin
       new(pv) ;
       pv^.stkar := karakti.Cells[0,jj];
       pv^.stmer := ii+1 ;
       pv^.skupi := 'X' ;
       pv^.tip := '01';
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
     evalList.add(px) ;
   end ;

   for jj := 1 to nkar2 do
   begin
     slb := StrToInt(attri.cells[2,jj]);
     new(px) ;
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
       stnp := StrToInt(attri.cells[2,jj]) ;
       pv^.stevnp := stnp ;
       if stnp > 0 then pv^.eval :=  'R'  else pv^.eval := 'A';
       inc(ii) ;
       karlist.Add(pv) ;
     end ;
     new(pv) ;

     evalList.add(px) ;
   end;

   dd := now ;
   if karlist.Count > 0 then Fsap.zapis(srz,opr,nazivp,merl,odl,orod,dd,karlist,evalList)  ;
//   label5.Caption := IntToStr(stvz) ;
   CistiListE(evallist) ;
   CistiList1(karList) ;
  // merex := false ;
end;

procedure TFzacetna.Button2Click(Sender: TObject);
  var stk,row,col,std : Integer ;
      mer : single ;
      cm,mr : string ;
      ii,ll : Integer ;

begin
   row := Karakti.Row ;
   col := karakti.Col ;
   cm := karakti.Cells[6,row] ;
   if cm = '' then cm := 'COM3' else cm := 'COM' + cm ;
   //showMessage(cm) ;
   stk :=  spinEdit1.value ;
   if stk <= 8 then mer := FComPort.preberi(stk,cm)
               else mr := FcomPort.odpri(cm) ;

   std := spinedit2.Value ;
   if stk <= 8 then karakti.Cells[col,row] := FloatTostrF(mer,ffFixed,10,std) ;
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
   if stk = 10 then
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

procedure TFzacetna.Button3Click(Sender: TObject);
begin
  pocisti1(listStr) ;
  Application.Terminate ;
end;

procedure TFzacetna.Button4Click(Sender: TObject);
begin
   lokalnabaza ;
end;

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
      ids : integer ;
begin
  pp := listStr[IzbStr] ;
  nz := trim(pp^.naziv) ;
  id := pp^.ident ;
  izbdod := List6.itemIndex ;

  if izbdod >= 0 then
  begin
    nazdod := trim(List6.Items[izbdod]) ;
    krdod := FlokalBaza.GetDodKr(id,nazdod) ;
  end else krdod := '' ;
  oro := nz + '/' + krdod ;
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
    stv := StrToIntDef(attri.Cells[2,i],0) ;
    if stv = 0 then eval := 'A' else eval := 'R' ;
    opo := attri.Cells[3,i] ;
    FlokalMeritve.ZapisMer2(idm,stv,poz,eval,opo) ;
  end;
  nanovo ;
end;


procedure TFzacetna.Button6Click(Sender: TObject);
  var excel : variant ;
      i,j,row : Integer ;
begin
 { excel := GetActiveOLEObject('Excel.application');
  for i := 1 to 7 do
    for j := 1 to 10 do
    begin
      karakti.Cells[j+DODK-1,i] := excel.cells[i,j]
    end;     }
    row := 2 ;
    with TCheckBox.create(self) do
    begin
      name := 'chk' + IntTostr(row) ;
      caption := '' ;
      Parent := panel4 ;
      left := attri.width - 60 ;
      width := 30 ;
      top := 24*row + 6 ;
      onClick := CheckBox1Click
    end;
end;


Procedure Tfzacetna.setcheck(row : integer) ;
begin
    with TCheckBox.create(self) do
    begin
      name := 'chk' + IntTostr(row) ;
      caption := '' ;
      Parent := panel4 ;
      left := attri.width - 60 ;
      width := 30 ;
      top := 24*row + 6 ;
      onClick := CheckBox1Click
    end;
end;


procedure TFzacetna.Button7Click(Sender: TObject);
begin
  FLokalMeritve.LokalSap ;
  //ShowMessage('Prenos uspešno konèan') ;
end;

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
       strvkl[ii] := Fsinapro.PreveriStroj(pp^.ident) ;
    end;
  end ;
end;

procedure TFzacetna.Button9Click(Sender: TObject);
begin
  Fsemafor.prikazi(listStr)  ;
end;

procedure TFzacetna.CheckBox1Click(Sender: TObject);
  var rw : Integer ;
      nm : string ;
begin
  //showmESSAGE(TcheckBox(SENDER).NAME) ;
  nm := TcheckBox(sender).name ;
  rw := StrToInt(copy(nm,4,1)) ;
  //rw := attri.Row ;
  attri.cells[2,rw] := '0' ;
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
      if trim(attri.Cells[2,jj]) = '' then
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

procedure TFzacetna.Meritve1Click(Sender: TObject);
begin
  FLokalMeritve.prikaz ;
end;

Procedure TFzacetna.isciKoda ;
  var ii : integer ;
      pp : ^zapis ;
      ident : integer ;
      listak : TstringList ;
      I,ipx: Integer;
      kd,kdd : string ;
begin
   pp := Liststr[IzbStr] ;
   orod := pp^.naziv ;
   ident := pp^.ident ;
   listak := TstringList.create ;
   Fsinapro.Getkoda(ident,listak) ;
   for I := 0 to listak.Count-1 do
   begin
     kd := Listak[i] ;
     kdd := replaceStr(kd,'-','') ;
     kdd := trim(kdd) ;
     ipx := system.pos('/',kdd) ;
     kdd := Copy(kdd,1,ipx-1) ;
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
    ss := Karakti.Cells[DODK-1,row] ;
    if ss = '' then Karakti.Cells[DODK-1,row] := 'X'
               else Karakti.Cells[DODK-1,row] := ''
  end;
end;

procedure TFzacetna.KaraktiDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
  var bb,b1 : boolean ;
      xx,x1,x2 : single ;
begin
  try
    xx := strToFloat(karakti.Cells[aCol,aRow]) ;
    x1 := strToFloat(karakti.Cells[3,aRow]) ;
    x2 := strToFloat(karakti.Cells[4,aRow]) ;
    if (x1 <= xx) and (x2 >= xx) then b1 := false else b1 := true ;
  except
    b1 := false
  end;
  if (acol >= DODK) and (aRow > 0) then bb := true else bb := false ;
  bb := bb and b1 ;
  if bb then
  with (karakti) do
  begin
    Canvas.font.Color:=clRed;
    if arow = 0 then Canvas.brush.Color:= karakti.fixedColor else Canvas.brush.Color:=clWhite ;
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
   FSqlKode.Pokazi ;
end;

procedure TFzacetna.FormActivate(Sender: TObject);
  var i : integer ;
begin
  stanje := 1 ;
  //FillDelEnote ;
  if screen.Width <= 1280 then panel3.Width := 950 ;
//  panel3.Width := 1000 ;
  panel2.Color := $02FFCCFF ;
  karakti.FixedCols := DODK ;
  karakti.Cells[0,0] := 'Pozicija' ;
  karakti.Cells[1,0] := 'Naziv' ;
  karakti.Cells[2,0] := 'Predpis' ;
  karakti.Cells[3,0] := 'Sp. meja' ;
  karakti.Cells[4,0] := 'Zg. meja' ;
  karakti.Cells[5,0] := 'Metoda' ;
  karakti.Cells[6,0] := 'COM' ;
  karakti.Cells[7,0] := 'Oznaka' ;
  karakti.Cells[8,0] := 'Preraèun' ;
  karakti.colwidths[1] := 190 ;
  karakti.colwidths[8] := 0 ;
  attri.Cells[0,0] := 'Pozicija' ;
  attri.Cells[1,0] := 'Naziv' ;
  attri.Cells[2,0] := 'Slabi' ;
  attri.Cells[3,0] := 'Opombe' ;
  attri.colwidths[1] := 240 ;
  attri.colwidths[3] := 260 ;

  lokalb := false ;
  if not lokalb then
  begin
    edit3.visible := false ;
    edit4.Visible := false ;
    button14.Visible := false ;
    button5.Visible := false ;
    edit2.Visible := false ;
  end else edit2.SetFocus ;
  pos := 0 ;
  //ReportMemoryLeaksOnShutdown := true ;
  ZacIzm[1] := StrToTime('6:00:00')  ;
  ZacIzm[2] := StrToTime('14:00:00') ;
  ZacIzm[3] := StrToTime('22:00:00') ;

end;

procedure TFzacetna.Linijekode1Click(Sender: TObject);
begin
  FlokalBaza.LinPrikaz ;
end;


procedure TFzacetna.Linijestrunice1Click(Sender: TObject);
begin
   FlokalBaza.StruzPrikaz ;
end;

procedure TFzacetna.List3Click(Sender: TObject);

begin
  izbStr := List3.ItemIndex ;
  izborLinije(izbStr) ;

end;


Procedure Tfzacetna.izborLinije(izbStr: integer) ;
var pp : ^zapis ;
      ident : integer ;
      lista : TstringList ;
      deln,kd : string ;
      jx,ll : integer ;
begin
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
   // lokalKoda
  end else IsciKoda ;
  List5.Items.Clear ;
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
  startnit ;
end;

Procedure Tfzacetna.IzborKode(kd : string) ;
  var listsrz : TstringList ;
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
    FsqlKode.getsarza(kd,Listsrz) ;
    //showMessage(IntTostr(listsrz.Count)) ;
    if listsrz.Count = 0 then Fsap.getKonsarza(kd,date-100,listsrz)   ;
  end;

  if listsrz.Count > 0 then
  begin
    if listsrz.Count  > 1 then
    begin
      label4.Visible := true ;
      list5.Visible := true ;
      list5.Items := listsrz ;
    end else
    begin
      srz := listsrz[0] ;
      FillKarakt(srz);
    end;
  end else ShowMessage('Za to kodo ni odprte nobene kontrolne serije') ;
  listsrz.Free ;
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
  karakti.repaint ;
  edit3.Text := '' ;
  {Image1.Canvas.FillRect(Image1.Canvas.Cliprect) ;
  Image2.Canvas.FillRect(Image2.Canvas.Cliprect) ;
  Image3.Canvas.FillRect(Image3.Canvas.Cliprect) ;
  Image4.Canvas.FillRect(Image4.Canvas.Cliprect) ; }
end;

procedure TFzacetna.list5Click(Sender: TObject);

begin
  srz := List5.Items[list5.ItemIndex] ;
  brisitabelo ;
  FillKarakt(srz) ;
end ;

Procedure Tfzacetna.fillkarakt(srz : string);
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
      FSqlKode.Getplan(srz,obstaja ,stcl,stvp,listkar1,listkar2) ;
      if not obstaja then Fsap.getkarakt(srz,stcl,stvp,listkar1,listkar2) ;
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


    if pp^.stkan = 0  then karakti.Cells[5,ii+1] := pp^.metoda
       else  karakti.Cells[5,ii+1] := IntTostr(pp^.stkan) ;
    if pp^.com <> 0 then karakti.Cells[6,ii+1] := IntTostr(pp^.com)
      else  karakti.Cells[6,ii+1] := '' ;
    karakti.Cells[8,ii+1] := intToStr(pp^.id) ;
  end;
  for ii := 1 to stcl do karakti.Cells[DODK-1+ii,0] := 'Meritev ' + intTostr(ii) ;

  attri.RowCount := listkar2.Count +1 ;
  for ii := 0 to listkar2.count-1 do
  begin
    pk := listkar2[ii] ;
    attri.Cells[0,ii+1] := pk^.poz ;
    attri.Cells[1,ii+1] := pk^.naziv ;
    setcheck(ii+1) ;
  end;
  Fsap.Pocistikr(listkar1) ;
  Fsap.Pocistiat(listkar2) ;

  tx := karakti.Cells[5,1] ;
  if length(tx) <= 2 then
  try
    kn := StrToInt(tx) ;
    spinEdit1.Value := kn ;
  except
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
  Fpostaje.pregled ;
end;

end.
