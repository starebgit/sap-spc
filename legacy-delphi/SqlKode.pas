unit SqlKode;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls, sap, Vcl.StdCtrls, Izborsrz, VpisKode,metode,
  Vcl.Menus, pomoc;

type
  TFsqlKode = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    ADOQuery1: TADOQuery;
    ADOQuery2: TADOQuery;
    Button3: TButton;
    ADOQuery2idplan: TAutoIncField;
    ADOQuery2idsar: TSmallintField;
    ADOQuery2tip: TIntegerField;
    ADOQuery2pozicija: TStringField;
    ADOQuery2naziv: TStringField;
    ADOQuery2predpis: TFloatField;
    ADOQuery2spmeja: TFloatField;
    ADOQuery2zgmeja: TFloatField;
    ADOQuery2kanal: TStringField;
    ADOQuery2stvz: TWordField;
    ADOQuery2stkanal: TWordField;
    ADOQuery2com: TWordField;
    ADOQuery2oznaka: TStringField;
    ADOQuery2operacija: TStringField;
    Label1: TLabel;
    ADOQuery1ident: TSmallintField;
    ADOQuery1koda: TStringField;
    ADOQuery1sarza: TStringField;
    ADOQuery1razmik: TSmallintField;
    ADOQuery1idpost: TSmallintField;
    Label2: TLabel;
    ADOQuery3: TADOQuery;
    ADOQuery1koncan: TStringField;
    MainMenu1: TMainMenu;
    Urejanje1: TMenuItem;
    Novakoda1: TMenuItem;
    Prepiskode1: TMenuItem;
    Vpogled1: TMenuItem;
    Dodatki1: TMenuItem;
    Arhiv1: TMenuItem;
    Normalno1: TMenuItem;
    Spremembakanala1: TMenuItem;
    ADOQuery1merdiff: TSmallintField;
    ADOQuery1mertraj: TSmallintField;
    Briikodo1: TMenuItem;
    Urejanjekontplana1: TMenuItem;
    Prenoskontplana1: TMenuItem;
    Frekvencameritev1: TMenuItem;
    Briikarakteristiko1: TMenuItem;
    Label3: TLabel;
    Operacije1: TMenuItem;
    Histogram1: TMenuItem;
    Preveriaro1: TMenuItem;
    Briikontrolniplan1: TMenuItem;
    Button1: TButton;
    procedure ADOQuery1AfterScroll(DataSet: TDataSet);
    procedure Button3Click(Sender: TObject);
    procedure DBGrid2DblClick(Sender: TObject);
    procedure Novakoda1Click(Sender: TObject);
    procedure Prepiskode1Click(Sender: TObject);
    procedure Dodatki1Click(Sender: TObject);
    procedure Arhiv1Click(Sender: TObject);
    procedure Normalno1Click(Sender: TObject);
    procedure Spremembakanala1Click(Sender: TObject);
    procedure Briikodo1Click(Sender: TObject);
    procedure Prenoskontplana1Click(Sender: TObject);
    procedure Frekvencameritev1Click(Sender: TObject);
    procedure Briikarakteristiko1Click(Sender: TObject);
    procedure Histogram1Click(Sender: TObject);
    procedure Preveriaro1Click(Sender: TObject);
    procedure Briikontrolniplan1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    adm : boolean ;
    procedure SetConnect ;
    procedure SqlSar ;
    Procedure SetSql1 ;
  public
    procedure Pokazi(admin : boolean) ;
    procedure Getplan(bermer : integer;kd,srz : string; var obstaja : boolean; var stcl,stvp : integer; var listkar1,listkar2: Tlist) ;
    function PreveriKodo(kd : string) : boolean ;
    Function Getoper(id : integer) : string ;
    Procedure GetlistaKod(kd : string ; var listkd : TstringList) ;
    Procedure prenoskar(srz : string) ;
    Procedure zapis(kd,srz : string; frk,trj : integer)  ;
    Procedure MarkKoncan(kd,srz : string) ;
    Procedure GetInterval(kd : string ; var diff, traj,idp : integer) ;
    procedure vrniSarzo(kd: string; var Listsrz : TstringList) ;
    procedure Zapsar(kd,srz: string) ;
    function GetNaziv(srz,poz : string) : string ;
    Procedure getlista(var lista : TstringList) ;
  end;

var
  FsqlKode: TFsqlKode;

implementation

{$R *.dfm}
 uses SqlMeritve, deklar , defKanal, postaje, dodatKod, VpisFrek, rezultati,
  defAnaliza;

procedure TFsqlKode.ADOQuery1AfterScroll(DataSet: TDataSet);
begin
  Sqlsar
end;

// seznam bez omejitev (tudi neveljavne šarže)
procedure TFsqlKode.Arhiv1Click(Sender: TObject);
  var idp : integer ;
begin
  Adoquery1.Close ;
  idp := Fpostaje.Getpost ;
  setconnect ;
  Adoquery1.sql.clear ;
  Adoquery1.sql.add('SELECT * from konsar where (idpost = :IDP)  order by koda') ;
  Adoquery1.parameters[0].name := 'IDP' ;
  Adoquery1.parameters[0].value := idp ;
  Adoquery1.Open ;
end;

//  brisanje ene karakterisitke
procedure TFsqlKode.Briikarakteristiko1Click(Sender: TObject);
  var ii : Integer ;
begin
  ii := MessageDlg('Ali zares želiš izbrisati?',mtConfirmation,[mbYes, mbNo],0);
  if ii = 6 then Adoquery2.delete ;
end;

// brisanje kontrolnega plana in kode
procedure TFsqlKode.Briikodo1Click(Sender: TObject);
  var ii : integer ;
begin
  ii := MessageDlg('Ali zares želiš izbrisati?',mtConfirmation,[mbYes, mbNo],0);
  if ii = 6 then
  begin
    Adoquery2.First ;
    while not Adoquery2.eof do adoquery2.Delete ;
    Adoquery1.delete ;
  end;
end;

// Brisanje kontrolnega plana
procedure TFsqlKode.Briikontrolniplan1Click(Sender: TObject);
  var ii : integer ;
begin
  ii := MessageDlg('Ali zares želiš izbrisati celoten plan?',mtConfirmation,[mbYes, mbNo],0);
  if ii = 6 then
  begin
    Adoquery2.First ;
    while not Adoquery2.eof do adoquery2.Delete ;
  end;
end;

// lista vseh kod za merilno mesto
Procedure TFsqlKode.getlista(var lista : TstringList) ;
  var idp : integer ;
begin
  idp := Fpostaje.Getpost ;
  if not Adoquery1.active then
  begin
    setconnect ;
    Adoquery1.sql.clear ;
    Adoquery1.sql.add('SELECT * from konsar where (idpost = :IDP)  order by koda') ;
    Adoquery1.parameters[0].name := 'IDP' ;
    Adoquery1.parameters[0].value := idp ;
    Adoquery1.Open ;
  end;
  while not Adoquery1.eof do
  begin
    if trim(Adoquery1koncan.asstring) = '' then lista.Add(adoquery1koda.value) ;
    Adoquery1.Next ;
  end;
  Adoquery1.close ;
end;

// prenos kontrolnega plana iz SAP-a
Procedure TFsqlKode.prenoskar(srz : string) ;
   var listkar1 : tlist ;
      listkar2 : Tlist ;
      stcl,stvp,i : integer ;
      pp : ^karak ;
      pk : ^atrib ;
      kn : integer ;
begin
  if not adoquery2.active then
  begin
    setconnect ;
    Adoquery2.Open ;
  end;

  listkar1 := Tlist.create ;
  listkar2 := Tlist.create ;
  Fsap.getkarakt('',srz,listkar1,listkar2) ;
  for i := 0 to listkar1.Count-1 do   // variabilne karakteristike
  begin
    pp := listkar1[i] ;
    Adoquery2.Append ;
    Adoquery2.FieldByName('idsar').Value := Adoquery1.FieldByName('ident').Value ;
    Adoquery2.FieldByName('tip').Value := 1 ;
    Adoquery2.FieldByName('pozicija').Value := pp^.poz ;
    Adoquery2.FieldByName('naziv').Value := pp^.naziv ;
    Adoquery2.FieldByName('spmeja').Value := pp^.spmeja ;
    Adoquery2.FieldByName('zgmeja').Value := pp^.zgmeja ;
    if pp^.predpis = '' then Adoquery2.FieldByName('predpis').Value := 0
      else  Adoquery2.FieldByName('predpis').Value := pp^.predpis ;
    Adoquery2.FieldByName('kanal').Value := pp^.metoda ;
    kn := Fmetode.Getkanal(pp^.metoda) ;
    if kn <> 0 then Adoquery2.FieldByName('stkanal').Value := kn ;
    Adoquery2.FieldByName('operacija').Value := pp^.operac ;
    Adoquery2.FieldByName('stvz').Value := pp^.stevVz ;
    Adoquery2.Post ;
  end ;
  for i := 0 to listkar2.Count-1 do      // atributivne karakteristike
  begin
    pk := listkar2[i] ;
    Adoquery2.Append ;
    Adoquery2.FieldByName('idsar').Value := Adoquery1.FieldByName('ident').Value ;
    Adoquery2.FieldByName('tip').Value := 2 ;
    Adoquery2.FieldByName('pozicija').Value := pk^.poz ;
    Adoquery2.FieldByName('naziv').Value := pk^.naziv ;
    Adoquery2.FieldByName('stvz').Value := pk^.stevVz ;
    Adoquery2.FieldByName('operacija').Value := pk^.operac ;
    Adoquery2.Post ;
  end ;
  for i := 0 to (listkar1.Count - 1) do
  begin
    pp := listkar1[i];
    Dispose(pp);
  end;
  listkar1.Free ;
  for i := 0 to (listkar2.Count - 1) do
  begin
    pk := listkar2[i];
    Dispose(pk);
  end;
  listkar2.Free ;
end;

// štart prenos kontrolnega plana
procedure TFsqlKode.Prenoskontplana1Click(Sender: TObject);
  var srz : string ;
begin
  if adoquery2.isempty then
  begin
    srz := Adoquery1.FieldByName('sarza').Value ;
    Prenoskar(srz) ;
  end ;
end;

// nova šarža za izbrano kodo
procedure TFsqlKode.Prepiskode1Click(Sender: TObject);
  var kd : string ;
begin
  kd := adoquery1koda.Value ;
  FVpisKode.vpis(kd)
end;

// preveri veljavnost kontolne šarže
procedure TFsqlKode.Preveriaro1Click(Sender: TObject);
  var srz : string ;
begin
  srz := Adoquery1sarza.Value ;
  if Fsap.preverisar(srz) then  Showmessage('Šarža je aktivna') else Showmessage('Šarža ni aktivna') ;
end;

// zakljuèæek
procedure TFsqlKode.Button1Click(Sender: TObject);
begin
  Adoquery1.First ;
  while not Adoquery1.eof do
  begin
    Adoquery2.First ;
    while not Adoquery2.eof do
    begin
      Adoquery2.Edit ;
      if adoquery2tip.Value  = 1 then
      begin
        Adoquery2kanal.value  := 'MP03' ;
         Adoquery2stkanal.value  := 1 ;
      end else
      begin
         Adoquery2kanal.value  := '' ;
       //  Adoquery2stkanal.value  := 1 ;
      end;
      Adoquery2.Post ;
      Adoquery2.Next ;
    end;
    Adoquery1.Next ;

  end;

end;

procedure TFsqlKode.Button3Click(Sender: TObject);
begin
  Close ;
end;

// vpis oznake za graf
procedure TFsqlKode.DBGrid2DblClick(Sender: TObject);
  var cc : string ;
begin
   cc :=  Adoquery2oznaka.Value ;
   Adoquery2.Edit ;
   if trim(cc) = '' then Adoquery2oznaka.Value := 'X'
              else Adoquery2oznaka.Value := '' ;
   AdoQuery2.Post ;
end;

// vpogled v seznam dodatkov
procedure TFsqlKode.Dodatki1Click(Sender: TObject);
  var kd : string ;
begin
  kd := adoquery1koda.Value ;
  FdodatKod.Prikazi(kd) ;
end;

// vpis podatkov za semafor
procedure TFsqlKode.Frekvencameritev1Click(Sender: TObject);
  var mrFk,mrTr : integer ;
begin
 mrFk := 120 ;
 mrTr := 15 ;
 FVpisFrek.vpis(mrFk,mrTr) ;
 if mrfk = 0 then exit ;
 Adoquery1.First ;
 while not Adoquery1.eof do
  begin
    Adoquery1.Edit ;
    Adoquery1merdiff.Value := mrFk ;
    Adoquery1mertraj.value := mrTr ;
    Adoquery1.Post ;
    Adoquery1.Next ;
  end;
end;

// odpiranje leve tabele (konsar)
Procedure TFSqlKode.SetSql1 ;
 var idp : integer ;
begin
  idp := Fpostaje.Getpost ;
  setconnect ;
  Adoquery1.sql.clear ;
  //Adoquery1.sql.add('SELECT * from konsar where (idpost = :IDP)  order by koda') ;
  Adoquery1.sql.add('SELECT * from konsar where (idpost = :IDP) and (koncan <> ''Y'') order by koda') ;
  Adoquery1.parameters[0].name := 'IDP' ;
  Adoquery1.parameters[0].value := idp ;
  Adoquery1.Open ;
end;

// popravek št.kanala
procedure TFsqlKode.Spremembakanala1Click(Sender: TObject);
  var vl : integer ;
begin
   if not adm then exit ;
   if adoquery2.FieldByname('stkanal').isnull then vl := 1
       else vl := adoquery2.FieldByname('stkanal').Value ;
   vl := FDefkanal.Vpiskan(vl) ;
   if vl > 0 then
   begin
     Adoquery2.Edit ;
     Adoquery2.FieldByname('stkanal').Value := vl ;
     Adoquery2.Post ;
   end;
end;


// prikaz tabel
procedure TFSqlKode.Pokazi(admin : boolean) ;
begin
  width := 1500 ;
  setconnect ;
  adm := admin ;
  dbgrid1.ReadOnly := false ;
  dbgrid2.ReadOnly := false ;
  setsql1 ;
  label3.Caption := Fpostaje.GetImePost ;
  panel1.Color := $02DEDAC0 ;
  label1.Left := 1300 ;
  SqlSar ;
  ShowModal ;
  Adoquery1.close ;
  Adoquery2.close ;
end;

procedure TFSqlKode.SetConnect ;
  var dir : string ;
begin
  dir := ExtractfilePath(application.ExeName) ;
  if not adoquery1.Active then adoquery1.connectionString := 'FILE NAME=' + dir + 'strojna.udl';
  if not adoquery2.Active then adoquery2.connectionString := 'FILE NAME=' + dir + 'strojna.udl';
end;

// odpiranje leve tabele (konplan)
procedure TFSqlKode.SqlSar ;
  var idl : integer ;
begin
  if  Adoquery1.isempty then exit ;
  if not Adoquery1.fieldByName('ident').isnull then
  begin
    setconnect ;
    idl := Adoquery1.fieldByName('ident').value ;
    Adoquery2.sql.clear ;
    Adoquery2.sql.add('SELECT * from konplan where idsar = :ID') ;
    Adoquery2.parameters[0].name := 'ID' ;
    Adoquery2.parameters[0].value := idl ;
    Adoquery2.Open ;
  end
end ;

// prepis kontrolnega plana v dva niza podatkov
procedure TFSqlKode.Getplan(bermer : integer; kd,srz : string; var obstaja : boolean; var stcl,stvp : integer; var listkar1,listkar2: Tlist) ;
  var pp : ^karak ;
      pk : ^atrib ;
      listr : Tlist ;
      avr,std : single ;
      idp,ip1 : integer ;
begin
  setconnect ;
  idp := Fpostaje.Getpost ;
  setconnect ;
  Adoquery1.sql.clear ;
  Adoquery1.sql.add('SELECT * from konsar where (sarza = :SRZ) and (idpost = :IDP)') ;
  Adoquery1.parameters[0].name := 'SRZ' ;
  Adoquery1.parameters[0].value := srz ;
  Adoquery1.parameters[1].name := 'IDP' ;
  Adoquery1.parameters[1].value := idp ;
  Adoquery1.Open ;
  if not adoquery1.isempty then
  begin
    sqlsar ;
    while not Adoquery2.eof do    // po vseh karakteristikah
    begin
      if adoquery2.FieldByName('tip').value = 1 then
      begin
        new(pp) ;
        pp^.poz := adoquery2.FieldByName('pozicija').value ;
        pp^.naziv := adoquery2.FieldByName('naziv').value ;
        pp^.predpis := adoquery2.FieldByName('predpis').value ;
        pp^.spmeja := adoquery2.FieldByName('spmeja').value ;
        pp^.zgmeja := adoquery2.FieldByName('zgmeja').value ;
        pp^.metoda := adoquery2.FieldByName('kanal').value ;
        pp^.stkan := adoquery2.FieldByName('stkanal').asinteger ;
    //    if adoquery2.FieldByName('stkanal').isnull then pp^.stkan :=  0
     //     else pp^.stkan := adoquery2.FieldByName('stkanal').value  ;
        stcl := adoquery2.FieldByName('stvz').value ;
        if adoquery2.FieldByName('com').isnull then pp^.com :=  0
          else pp^.com := adoquery2.FieldByName('com').value  ;
        pp^.id :=  adoquery2.FieldByName('idplan').value ;
        if adoquery2.FieldByName('oznaka').isnull then  pp^.oznaka := '' else pp^.oznaka := adoquery2.FieldByName('oznaka').value ;
        if bermer = 0 then
        begin
          listr := tlist.Create ;
          FsqlMeritve.getlist(kd,pp^.poz,listr);
          FsqlMeritve.Getstat(listr,avr,std)  ;
          pp^.avr := avr ;
          pp^.stand := std ;
          Cistigraf(listr) ;
        end ;
        listkar1.Add(pp) ;
      end;
      if adoquery2.FieldByName('tip').value = 2 then
      begin
        stvp := adoquery2.FieldByName('stvz').value  ;
        new(pk) ;
        pk^.poz :=  adoquery2.FieldByName('pozicija').value ;
        pk^.naziv :=  adoquery2.FieldByName('naziv').value ;
        pk^.st_vzor :=  adoquery2.FieldByName('stvz').value ;
        listkar2.Add(pk) ;
      end;
      Adoquery2.Next ;
    end;
    obstaja := true ;
  end else obstaja := false;
  adoquery1.Close ;
end;

// procedura preveri èe ima doloèena koda veljavno kontrolno šaržo
function TFSqlKode.PreveriKodo(kd : string) : boolean ;
  var konc : string ;
      idp : integer ;
begin
  idp := Fpostaje.Getpost ;
  if not Adoquery1.Active  then
  begin
    setconnect ;
    Adoquery1.sql.clear ;
    Adoquery1.sql.add('SELECT * from konsar where (koda = :KD) and (idpost = :IDP) and (koncan <> ''Y'') and (koncan <> ''X'')') ;
    Adoquery1.parameters[0].name := 'KD' ;
    Adoquery1.parameters[0].value := kd ;
    Adoquery1.parameters[1].name := 'IDP' ;
    Adoquery1.parameters[1].value := idp ;
    Adoquery1.Open ;
  end;
  if adoquery1.IsEmpty  then result := false else result := true ;
  Adoquery1.close ;
end;

// Procedura za izvedbo zapisa kode in prenosa kontrolnega plana
procedure TFsqlKode.Zapsar(kd,srz: string) ;
  var frk,trj : integer;
begin
  frk := 120 ;
  trj := 15 ;
  setconnect ;
  setsql1 ;
  FSqlKode.Zapis(kd,srz,frk,trj) ;
  FsqlKode.Prenoskar(srz) ;
  Adoquery1.close ;
  Adoquery2.close ;
end;


// procedura vrne listo veljavnih kontrolnih šarž za doloèeno kodo
procedure TFsqlKode.vrniSarzo(kd: string; var Listsrz : TstringList) ;
 var konc : string ;
      idp : integer ;
      srz : string ;
begin
  setconnect ;
  idp := Fpostaje.Getpost ;
  Adoquery1.sql.clear ;
  Adoquery1.sql.add('SELECT * from konsar where (koda = :KD) and (idpost = :IDP)') ;
  Adoquery1.parameters[0].name := 'KD' ;
  Adoquery1.parameters[0].value := kd ;
  Adoquery1.parameters[1].name := 'IDP' ;
  Adoquery1.parameters[1].value := idp ;
  Adoquery1.Open ;

  while not Adoquery1.eof do
  begin
    konc := Adoquery1koncan.Value ;
    if not Adoquery1.fieldbyname('sarza').isnull then
    begin
      if (konc <> 'X') and (konc <> 'Y') then
      begin
        srz := Adoquery1sarza.value ;
        if Fsap.preveriSar(srz) then listsrz.Add(srz)
    {    else
        begin
          Adoquery1.edit ;
          adoquery1koncan.value := 'Y' ;
          adoquery1.post ;
        end;  }
      end;
    end;
    Adoquery1.Next ; ;
  end;
  Adoquery1.close ;
end;

// procedura za lansiranje izdelave histograma
procedure TFsqlKode.Histogram1Click(Sender: TObject);
  var srz,opr,poz : string ;
      listr : Tlist ;
      predp,stm,ztm,dodtol : single ;
      dat1,dat2 : TdateTime ;
      anl : analiza ;
begin
  anl.sarza := adoquery1.FieldbyName('sarza').value ;
  if adoquery2.FieldbyName('operacija').isnull then  anl.operac := '0010'
     else anl.operac := adoquery2.FieldbyName('operacija').value ;
  anl.pozic  := adoquery2.FieldbyName('pozicija').value ;
  anl.naziv  := adoquery2.FieldbyName('naziv').value ;
  anl.koda :=  adoquery1.FieldbyName('koda').value ;
  FDefAnaliza.defi(dat1,dat2) ;
  if dat1 < NizTodatum('01.01.2000') then exit ;
  listr := Tlist.Create ;
  screen.Cursor := crHourGlass ;
  anl.zacdat := dat1 ;
  anl.kondat := dat2 ;
  Fsap.getresult(anl,listr) ;
  anl.predpis := adoquery2predpis.value ;
  anl.spmeja := adoquery2spmeja.value ;
  anl.zgmeja := adoquery2zgmeja.value ;
  anl.dodattol := 0.02 ;
  Frezultati.Pripravi(anl) ;
  screen.Cursor := crDefault ;
  frezultati.prikazi(listr) ;
 // listr.Free ;
  cistigraf(listr) ;
end;

// funkcija vrne št. operacije za doloèen plan (karateristiko))
Function TFsqlKode.Getoper(id : integer) : string ;
begin
  setconnect ;
  Adoquery2.sql.clear ;
  Adoquery2.sql.add('SELECT * from konplan where idplan = :ID ') ;
  Adoquery2.parameters[0].name := 'ID' ;
  Adoquery2.parameters[0].value := id ;
  Adoquery2.Open ;

  if ADoquery2.FieldByName('operacija').IsNull then result := '0010'
             else result := Adoquery2.FieldByName('operacija').value ;
  Adoquery1.close ;
end;

// procedura vrne list kod kispadajo v isto skupino kot jev vhodni podatek
Procedure TFsqlkode.GetlistaKod(kd : string ; var listkd : TstringList) ;
  var kdd : string ;
      rz,rz1 : integer ;
begin
  setconnect ;
  Adoquery1.sql.clear ;
  Adoquery1.sql.add('SELECT * from konsar where koda = :KD ') ;
  Adoquery1.parameters[0].name := 'KD' ;
  Adoquery1.parameters[0].value := kd ;
  Adoquery1.Open ;
  if not adoquery1.isempty then
  begin
    rz := Adoquery1.fieldbyname('razmik').value ;
    adoquery1.Close ;
    Adoquery1.sql.clear ;
    Adoquery1.sql.add('SELECT * from konsar') ;
    Adoquery1.Open ;
    while not Adoquery1.eof do
    begin
      if not Adoquery1.fieldbyname('razmik').isnull then
      begin
      rz1 := Adoquery1.fieldbyname('razmik').value ;
      if rz1 = rz then     // èe je ista skupina
      begin
        kdd := trim(Adoquery1.fieldbyname('koda').value) ;
        listkd.add(kdd)
      end;
      end;
      Adoquery1.next ;
    end ;
  end;
  Adoquery1.close ;
end;

// zapis nove kode
Procedure TFsqlKode.zapis(kd,srz : string; frk,trj : integer)  ;
  var idp : integer ;
begin
  idp := Fpostaje.Getpost ;
  Adoquery1.append ;
  Adoquery1.fieldByName('koda').value := kd ;
  Adoquery1.fieldByName('sarza').value := srz ;
  Adoquery1.fieldByName('idpost').value := idp ;
  Adoquery1.fieldByName('merdiff').value := frk ;
  Adoquery1.fieldByName('mertraj').value := trj ;
  Adoquery1.fieldByName('koncan').value := '' ;
  Adoquery1.post ;
end;


Procedure TFsqlKode.MarkKoncan(kd,srz : string) ;
begin
  SetConnect ;
  adoquery1.SQL.Clear ;
  adoquery1.SQL.Add('UPDATE konsar SET koncan = ''X'' WHERE koda = :KD and sarza = :SRZ' ) ;
  Adoquery1.parameters[0].name := 'KD' ;
  Adoquery1.parameters[0].value := kd ;
  Adoquery1.parameters[1].name := 'SRZ' ;
  Adoquery1.parameters[1].value := srz ;
  Adoquery1.execsql ;
end;

procedure TFsqlKode.Normalno1Click(Sender: TObject);
begin
  setSql1 ;
end;

// vpis novekode
procedure TFsqlKode.Novakoda1Click(Sender: TObject);
begin
  if adm then FVpisKode.vpis('') ;
  sqlsar ;
end;

// procedura vrne podatke o intervalu meritev za dolèeno kodo. Popmembno za semafor.
Procedure TfSqlKode.GetInterval(kd : string ; var diff, traj,idp : integer) ;
  var dir : string ;
begin
  setConnect ;
 // idp := Fpostaje.Getpost ;
  dir := ExtractfilePath(application.ExeName) ;
  adoquery3.connectionString := 'FILE NAME=' + dir + 'strojna.udl';
  adoquery3.SQL.Clear ;
  Adoquery3.sql.add('SELECT * from konsar where (koda = :KD) and (idpost = :ID) and (koncan <> ''Y'')') ;
  Adoquery3.parameters[0].name := 'KD' ;
  Adoquery3.parameters[0].value := kd ;
  Adoquery3.parameters[1].name := 'ID' ;
  Adoquery3.parameters[1].value := idp ;
  try
    Adoquery3.open ;
  except
    diff := 120 ;
    traj := 15 ;
    pisilog(intTostr(idp) + ' Branje intervala') ;
    exit
  end;
  if Adoquery3.isempty then
  begin
    diff := 120 ;
    traj := 15
  end else
  begin
    diff := adoquery3.FieldByName('merdiff').value ;
    traj := adoquery3.FieldByName('mertraj').value ;
  end;
  Adoquery3.Close ;
end;

// funkcija vrne naziv karakteristike
function TfsqlKode.GetNaziv(srz,poz : string) : string ;
  var ss : string ;
begin
  setconnect ;
  Adoquery1.SQL.Clear ;
  adoquery1.SQL.Add('select * from konsar where sarza = :SRZ') ;
  Adoquery1.parameters[0].name := 'SRZ' ;
  Adoquery1.parameters[0].value := srz ;
  adoquery1.Open ;
  ss := '' ;
  if not adoquery1.isempty then
  begin
    SqlSar ;
    adoquery2.First ;
    while not adoquery2.eof do
    begin
      if adoquery2pozicija.value = poz  then ss := adoquery2naziv.value ;
      adoquery2.Next ;
    end;
  end;
  result := ss;
  adoquery1.Close ;
  adoquery2.Close ;
end;

end.
