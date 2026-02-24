unit lokalBaza;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls, Vcl.StdCtrls, deklar;
const MM = 8 ;
type
  mers = record
     poz : string ;
     zap : integer ;
     rez : single ;
     naz : string ;
  end ;
  merarr = array[1..MM] of mers ;
  TFlokalBaza = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    ADOQuery1: TADOQuery;
    ADOQuery2: TADOQuery;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    procedure ADOQuery1AfterScroll(DataSet: TDataSet);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    op : integer ;
    procedure SqlLin ;
    procedure Sqlkod ;
    procedure SqlSar ;
    procedure SqlStz ;
    function GetIdsar(srz : string) : integer ;
    procedure SetConnect ;
  public
    Procedure LinPrikaz ;
    Procedure KodPrikaz ;
    Procedure SarPrikaz ;
    Procedure StruzPrikaz ;
    Procedure Getlinije(var list : TList)  ;
    procedure Getkode(idl : integer; var lista : TstringList) ;
    procedure Getdod(idl : integer; var lista : TstringList) ;
    Procedure getsarze(kd : string; var listsrz : TstringList) ;
    procedure getkar(predm: integer;srz : string;var stcl,stvp : integer; var listkar1,listkar2 : Tlist) ;
    procedure prenosSAP ;
    function Getstvz(srz,poz : string) : integer ;
    function GetDodKr(idlin: integer; nazdod: string) : string;
    Procedure Getstruz(idnt : string;  Var lin : integer; var struz : string) ;
    function Getpreracun(id : integer) : single ;
    procedure Getsab(srz : string ; var kd : string; var rezi :merarr) ;
  end;

var
  FlokalBaza: TFlokalBaza;

implementation

{$R *.dfm}

uses sap;

procedure TFlokalBaza.SqlLin ;
  var idl : integer ;
begin
  if not Adoquery1.isempty then
  begin
    idl := Adoquery1.fieldByName('idlin').value ;
    Adoquery2.sql.clear ;
    Adoquery2.sql.add('SELECT * from kode where idlin = :ID') ;
    Adoquery2.parameters[0].name := 'ID' ;
    Adoquery2.parameters[0].value := idl ;
    Adoquery2.Open ;
  end;
end ;

procedure TFlokalBaza.Sqlkod ;
  var idl : integer ;
begin
  if not Adoquery1.isempty then
  begin
    idl := Adoquery1.fieldByName('idkod').value ;
    Adoquery2.sql.clear ;
    Adoquery2.sql.add('SELECT * from konsar where idkod = :ID') ;
    Adoquery2.parameters[0].name := 'ID' ;
    Adoquery2.parameters[0].value := idl ;
    Adoquery2.Open ;
  end;
end ;

procedure TFlokalBaza.SqlSar ;
  var idl : integer ;
begin
  if not Adoquery1.isempty then
  begin
    idl := Adoquery1.fieldByName('idsar').value ;
    Adoquery2.sql.clear ;
    Adoquery2.sql.add('SELECT * from konplan where idsar = :ID') ;
    Adoquery2.parameters[0].name := 'ID' ;
    Adoquery2.parameters[0].value := idl ;
    Adoquery2.Open ;
  end;
end ;

procedure TFlokalBaza.SqlStz ;
  var idl : integer ;
begin
  if not Adoquery1.isempty then
  begin
    idl := Adoquery1.fieldByName('idlin').value ;
    Adoquery2.sql.clear ;
    Adoquery2.sql.add('SELECT * from dodlin where idlin = :ID') ;
    Adoquery2.parameters[0].name := 'ID' ;
    Adoquery2.parameters[0].value := idl ;
    Adoquery2.Open ;
  end;
end ;

procedure TFlokalBaza.ADOQuery1AfterScroll(DataSet: TDataSet);
begin
  case op of
    1 : SqlLin ;
    2 : SqlKod ;
    3 : SqlSar ;
    4 : SqlStz ;
  end;

end;

Procedure TFlokalBaza.LinPrikaz ;
begin
  setConnect ;
  op := 1 ;
  Adoquery1.sql.clear ;
  Adoquery1.sql.add('SELECT * from linije') ;
  Adoquery1.Open ;
  SqlLin ;
  ShowModal ;
  Adoquery1.close ;
  Adoquery2.close ;
end;

procedure TFlokalBaza.Button1Click(Sender: TObject);
  var kd : string ;
      dat : Tdatetime ;
      listsrz : TstringList ;
      i : integer ;
begin
  kd := Adoquery1.FieldByName('koda').Value ;
  dat := StrTodate('01.01.2015') ;
  listsrz := TstringList.Create ;
  Fsap.Getkonsarza(kd,dat,true,listsrz) ;
  //ShowMessage(IntTostr(listsrz.Count)) ;
  for i := 0 to listsrz.Count-1 do
  begin
    Adoquery2.Append ;
    Adoquery2.FieldByName('idkod').Value := Adoquery1.FieldByName('idkod').Value ;
    Adoquery2.FieldByName('koda').Value := Adoquery1.FieldByName('koda').Value ;
    Adoquery2.FieldByName('sarza').Value := listsrz[i] ;
    Adoquery2.Post ;
  end;
  listsrz.Free ;
end;

procedure TFlokalBaza.Button2Click(Sender: TObject);
  var srz : string ;
      listkar1 : tlist ;
      listkar2 : Tlist ;
      stcl,stvp,i : integer ;
      pp : ^karak ;
begin
  srz := Adoquery1.FieldByName('sarza').Value ; ;
  listkar1 := Tlist.create ;
  listkar2 := Tlist.create ;
  Fsap.getkarakt('',srz,listkar1,listkar2) ;
  //ShowMessage(intTostr(stvp)) ;
  for i := 0 to listkar1.Count-1 do
  begin
    pp := listkar1[i] ;
    Adoquery2.Append ;
    Adoquery2.FieldByName('idsar').Value := Adoquery1.FieldByName('idsar').Value ;
    Adoquery2.FieldByName('tip').Value := 1 ;
    Adoquery2.FieldByName('pozicija').Value := pp^.poz ;
    Adoquery2.FieldByName('naziv').Value := pp^.naziv ;
    Adoquery2.FieldByName('spmeja').Value := pp^.spmeja ;
    Adoquery2.FieldByName('zgmeja').Value := pp^.zgmeja ;
    Adoquery2.FieldByName('kanal').Value := pp^.metoda ;
    Adoquery2.FieldByName('predpis').Value := pp^.predpis ;
    Adoquery2.FieldByName('stvz').Value := pp^.stevVz ;
    Adoquery2.Post ;
  end ;
  for i := 0 to listkar2.Count-1 do
  begin
    pp := listkar2[i] ;
    Adoquery2.Append ;
    Adoquery2.FieldByName('idsar').Value := Adoquery1.FieldByName('idsar').Value ;
    Adoquery2.FieldByName('tip').Value := 2 ;
    Adoquery2.FieldByName('pozicija').Value := pp^.poz ;
    Adoquery2.FieldByName('naziv').Value := pp^.naziv ;
    Adoquery2.FieldByName('stvz').Value := pp^.stevVz ;
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
    pp := listkar2[i];
    Dispose(pp);
  end;
  listkar2.Free ;
end;


procedure TFlokalBaza.Button3Click(Sender: TObject);
  var ii : integer ;
begin
 ii := MessageDlg('Ali zares želiš izbrisati?',mtConfirmation,[mbYes, mbNo],0);
 if ii = 6 then
 begin
     if not Adoquery2.isempty then Adoquery2.delete else Adoquery1.delete ;
  end ;
end;

procedure TFlokalBaza.Button4Click(Sender: TObject);
begin
  Close ;
end;

procedure TFlokalBaza.FormActivate(Sender: TObject);
  var dir : string ;
begin
   dir := ExtractfilePath(application.ExeName) ;

   adoquery1.connectionString := 'FILE NAME=' + dir + 'obdel.udl';
   adoquery2.connectionString := 'FILE NAME=' + dir + 'obdel.udl';

end;


Procedure TFlokalBaza.KodPrikaz ;
begin
  op := 2 ;
  setConnect ;
  Adoquery1.sql.clear ;
  Adoquery1.sql.add('SELECT * from kode') ;
  Adoquery1.Open ;
  SqlKod ;
  ShowModal ;
  Adoquery1.close ;
  Adoquery2.close ;
end;

Procedure TFlokalBaza.SarPrikaz ;
begin
  width := 1900 ;
  op := 3 ;
  setConnect ;
  Adoquery1.sql.clear ;
  Adoquery1.sql.add('SELECT * from konsar') ;
  Adoquery1.Open ;
  SqlSar ;
  ShowModal ;
  Adoquery1.close ;
  Adoquery2.close ;
end;

procedure TFLokalbaza.Getsab(srz : string ; var kd : string; var rezi :merarr) ;
  var st,ii,kk : integer ;
begin
  op := 3 ;
  SetConnect ;
  Adoquery1.sql.clear ;
  Adoquery1.sql.add('SELECT * from konsar where sarza = :SAR') ;
  Adoquery1.parameters[0].name := 'DAR' ;
  Adoquery1.parameters[0].value := srz ;
  Adoquery1.Open ;
  SqlSar ;
  if not Adoquery1.isempty then
  begin
    kd := Adoquery1.fieldbyname('koda').value ;
    Adoquery2.first ;
    kk := 1 ;
    while (not Adoquery2.eof) and (kk <= MM) do
    begin
      st := Adoquery2.fieldByName('stvz').value ;
      for ii := 1 to st  do
      begin
        rezi[kk].poz := Adoquery2.fieldbyname('pozicija').value ;
        rezi[kk].naz := Adoquery2.fieldbyname('pozicija').value + '/' + IntTostr(ii)  ;
        rezi[kk].zap := ii ;
        rezi[kk].rez := 99 ;
        inc(kk) ;
      end;
      adoquery2.Next
    end;
  end else kd := '' ;
end;

Procedure TFlokalBaza.StruzPrikaz ;
begin
  op := 4 ;
  setConnect ;
  Adoquery1.sql.clear ;
  Adoquery1.sql.add('SELECT * from linije') ;
  Adoquery1.Open ;
  Sqlstz ;
  ShowModal ;
  Adoquery1.close ;
  Adoquery2.close ;
end;

Procedure TFlokalBaza.Getstruz(idnt : string;  Var lin : integer; var struz : string) ;
begin
  setConnect ;
  Adoquery2.sql.clear ;
  Adoquery2.sql.add('SELECT * from dodlin where identstruz = :ID') ;
  Adoquery2.parameters[0].name := 'ID' ;
  Adoquery2.parameters[0].value := idnt ;
  Adoquery2.Open ;
  if Adoquery2.isempty then  lin := 0
  else begin
     lin := Adoquery2.FieldByName('idlin').Value ;
     struz := Adoquery2.FieldByName('dodnaziv').Value ;
  end;

  Adoquery1.close ;
  Adoquery2.close ;
end;


procedure TFlokalBaza.SetConnect ;
  var dir : string ;
begin
  dir := ExtractfilePath(application.ExeName) ;
  adoquery1.connectionString := 'FILE NAME=' + dir + 'obdel.udl';
  adoquery2.connectionString := 'FILE NAME=' + dir + 'obdel.udl';
end;

Procedure TFlokalBaza.Getlinije(var list : Tlist)  ;
   var pp : ^zapis ;

begin
  setConnect ;
  op := 1 ;
  Adoquery1.sql.clear ;
  Adoquery1.sql.add('SELECT * from linije') ;
  Adoquery1.Open ;
  Adoquery1.first ;
  while not Adoquery1.eof do
  begin
    new(pp) ;
    pp^.naziv := adoquery1.fieldbyname('naziv').value ;
    pp^.ident := adoquery1.fieldbyname('idlin').value ;
    list.Add(pp) ;
    Adoquery1.Next ;
  end;
  Adoquery1.close ;
end ;

procedure TFlokalBaza.Getkode(idl : integer; var lista : TstringList) ;
begin
   op := 2 ;
   setConnect ;
   Adoquery1.sql.clear ;
  // Adoquery1.open ;
  // Adoquery1.Close ;
  Adoquery1.sql.add('SELECT idkod,idlin,koda from kode where idlin = :ID') ;
   Adoquery1.parameters[0].name := 'ID' ;
   Adoquery1.parameters[0].value := idl ;
   //Adoquery1.sql.add('SELECT * from kode') ;
   Adoquery1.Prepared := false ;
   Adoquery1.Open ;
   Adoquery1.first ;
   while not Adoquery1.eof do
   begin
     lista.Add(Adoquery1.fieldbyname('koda').value) ;
     Adoquery1.Next ;
  end;
  Adoquery1.close ;
end ;

procedure TFlokalBaza.Getdod(idl : integer; var lista : TstringList) ;
begin
   op := 4 ;
   setConnect ;
   Adoquery1.sql.clear ;
   Adoquery1.sql.add('SELECT * from linije where idlin = :ID') ;
   Adoquery1.parameters[0].name := 'ID' ;
   Adoquery1.parameters[0].value := idl ;
   Adoquery1.Open ;

   while not Adoquery2.eof do
   begin
     lista.Add(Adoquery2.fieldbyname('dodNaziv').value) ;
     Adoquery2.Next ;
  end;
  Adoquery2.close ;
  Adoquery1.close ;
end ;


function TFlokalBaza.GetDodKr(idlin: integer; nazdod: string) : string;
  var kr : string ;
begin
   op := 4 ;
   setConnect ;
   Adoquery1.sql.clear ;
   Adoquery1.sql.add('SELECT * from linije where idlin = :ID') ;
   Adoquery1.parameters[0].name := 'ID' ;
   Adoquery1.parameters[0].value := idlin ;
   Adoquery1.Open ;
   kr := '' ;
   while not Adoquery2.eof do
   begin
     if trim(adoquery2.fieldbyname('dodnaziv').value) = nazdod then
       kr :=  adoquery2.fieldbyname('dodkratki').value ;
     Adoquery2.Next ;
   end;
   result := trim(kr) ;
   Adoquery2.close ;
   Adoquery1.close ;
end;


Procedure TFlokalbaza.getsarze(kd : string; var listsrz : TstringList) ;
begin
   op := 2 ;
   setConnect ;
   Adoquery1.sql.clear ;
   Adoquery1.sql.add('SELECT * from konsar where koda = :ID') ;
   Adoquery1.parameters[0].name := 'ID' ;
   Adoquery1.parameters[0].value := kd ;
   Adoquery1.Open ;
   Adoquery1.first ;
   while not Adoquery1.eof do
   begin
     listsrz.Add(Adoquery1.fieldbyname('sarza').value) ;
     Adoquery1.Next ;
  end;
  Adoquery1.close ;
end;

function TFlokalbaza.GetIdsar(srz : string) : integer ;
begin
   setConnect ;
   Adoquery1.sql.clear ;
   Adoquery1.sql.add('SELECT * from konsar where sarza = :ID') ;
   Adoquery1.parameters[0].name := 'ID' ;
   Adoquery1.parameters[0].value := srz ;
   Adoquery1.Open ;
   if not Adoquery1.isempty then result := Adoquery1.FieldByName('idsar').Value  else result := 0 ;
   Adoquery1.Close ;
end;

function TfLokalbaza.Getpreracun(id : integer) : single ;
  var sx : string ;
begin
   setConnect ;
   op := 3 ;
   Adoquery1.sql.clear ;
   Adoquery1.sql.add('SELECT * from konplan where idplan = :ID') ;
   Adoquery1.parameters[0].name := 'ID' ;
   Adoquery1.parameters[0].value := id ;
   Adoquery1.Open  ;
   if adoquery1.isempty then result := 0
   else begin
     if adoquery1.fieldbyName('preracun').isnull then result := 0
     else  begin
       sx := adoquery1.fieldbyName('preracun').value ;
       if sx = 'X' then result := adoquery1.fieldbyName('predpis').value else result := 0
     end

   end;
end;

procedure TFlokalbaza.getkar(predm: integer;srz : string;var stcl,stvp : integer; var listkar1,listkar2 : Tlist) ;
  var tp : integer ;
      p1 : ^karak ;
      p2 : ^atrib ;
      idsar : integer ;
      bb : boolean ;
      svz : integer ;
      prc : string ;
      popr : single ;
begin
   setConnect ;
   op := 3 ;
   idsar := Getidsar(srz) ;
   Adoquery1.sql.clear ;
   Adoquery1.sql.add('SELECT * from konplan where idsar = :ID') ;
   Adoquery1.parameters[0].name := 'ID' ;
   Adoquery1.parameters[0].value := idsar ;
   Adoquery1.Open ;
   Adoquery1.first ;
   while not Adoquery1.eof do
   begin
     tp := Adoquery1.FieldByName('tip').Value ;
     if tp = 1 then
     begin

       svz := Adoquery1.FieldByName('stvz').Value ;
       bb := true ;
        // if (predm = 1) and (svz = 1) then  bb := false ;
       if svz = 1 then  bb := false ;
       if bb then
       begin
         if Adoquery1.FieldByName('preracun').isnull then prc := ''
            else prc := Adoquery1.FieldByName('preracun').Value ;
         if prc = 'X' then popr := Adoquery1.FieldByName('predpis').Value  else popr := 0 ;

         new(p1) ;
         p1^.poz := Adoquery1.FieldByName('pozicija').Value  ;
         p1^.naziv := Adoquery1.FieldByName('naziv').Value ;
         p1^.spmeja := FloatToStrF(Adoquery1.FieldByName('spmeja').Value - popr,ffFixed,8,2)  ;
         p1^.predpis := FloatToStrF(Adoquery1.FieldByName('predpis').Value - popr,ffFixed,8,2) ;
         p1^.zgmeja := FloatToStrF(Adoquery1.FieldByName('zgmeja').Value - popr,ffFixed,8,2)  ;
         p1^.metoda := Adoquery1.FieldByName('kanal').Value  ;
         //showMessage(inttostr(Adoquery1.FieldByName('stkan').value)) ;
         if Adoquery1.FieldByName('stkan').isnull then  p1^.stkan := 0 else
           p1^.stkan := Adoquery1.FieldByName('stkan').value ;
         if Adoquery1.FieldByName('com').isnull then  p1^.com := 0 else
           p1^.com := Adoquery1.FieldByName('com').value ;
           p1^.prer := prc ;
           p1^.id := Adoquery1.FieldByName('idplan').Value ;
         listkar1.Add(p1) ;
         stcl := 1 ;
       end;
     end else
     begin
       new(p2) ;
       p2^.poz := Adoquery1.FieldByName('pozicija').Value  ;
       p2^.naziv := Adoquery1.FieldByName('naziv').Value ;
       Listkar2.add(p2) ;
       stvp := Adoquery1.FieldByName('stvz').Value ;
     end;
     Adoquery1.Next ;
  end;
  //stvp := 1 ;
  Adoquery1.close ;
end;

procedure TFlokalbaza.prenosSAP ;
  var pp : ^karmer ;
      stkar : string ;
      ix,tip : Integer ;
      merit : single ;
begin
   setConnect ;
   Adoquery1.sql.clear ;
   Adoquery1.sql.add('SELECT * from konplan where idsar = :ID') ;
   Adoquery1.parameters[0].name := 'ID' ;
   Adoquery1.parameters[0].value := 1 ;
   Adoquery1.Open ;
   Adoquery1.first ;
   while not Adoquery1.eof do
   begin
      Adoquery2.sql.clear ;
      Adoquery2.sql.add('SELECT * from konplan where idsar = :ID') ;
      Adoquery2.parameters[0].name := 'ID' ;
      Adoquery2.parameters[0].value := 1 ;
      Adoquery2.Open ;
      Adoquery2.first ;
      ix := 1 ;
      while not Adoquery2.eof do
      begin
        stkar := Adoquery2.FieldByName('stkar').Value ;
        tip := Adoquery2.FieldByName('tip').Value ;
       // stvz := Adoquery2.FieldByName('stvz').Value ;
        merit := Adoquery2.FieldByName('meritev').Value ;
        new(pp) ;
        pp^.stkar := stkar ;
        pp^.stmer := ix ;
        pp^.eval :=  Adoquery2.FieldByName('eval').Value ;
        if tip = 1 then
        begin
          pp^.skupi := 'X' ;
          pp^.tip := '01' ;
          pp^.merit := FloatToStrF(merit,ffFixed,8,2) ;
        end;
        begin
          pp^.skupi := ''  ;
          pp^.tip := '02' ;
          pp^.opom := Adoquery2.FieldByName('opomba').Value ;
        end;
        inc(ix) ;
        Adoquery2.Next ;
      end;
      Adoquery1.Next ;
   end;

end;

function TFlokalBaza.Getstvz(srz,poz : string) : integer ;
  var npz : string ;
      st : integer ;
begin
  op := 3 ;
  setConnect ;
  Adoquery1.sql.clear ;
  Adoquery1.sql.add('SELECT * from konsar where sarza = :SAR') ;
  Adoquery1.parameters[0].value := srz ;
  Adoquery1.parameters[0].name := 'SAR' ;
  Adoquery1.Open ;
  SqlSar ;
  st := 0 ;
  Adoquery2.first ;
  while not Adoquery2.eof do
  begin
    npz := Adoquery2.fieldbyName('pozicija').value ;
    if poz = npz then
    begin
      st := Adoquery2.fieldbyName('stvz').value ;
      break
    end ;
    Adoquery2.Next ;
  end;
  result := st;
  Adoquery1.close ;
  Adoquery2.close ;
end;

end.
