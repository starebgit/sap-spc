unit lokalmeritve;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls, sap, deklar, Vcl.StdCtrls, Vcl.Menus;

type
  TFlokalMeritve = class(TForm)
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
    MainMenu1: TMainMenu;
    Filter1: TMenuItem;
    Filternakontserijo1: TMenuItem;
    Filternaasdobo1: TMenuItem;
    Brezfiltra1: TMenuItem;
    procedure ADOQuery1AfterScroll(DataSet: TDataSet);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Filternakontserijo1Click(Sender: TObject);
    procedure Filternaasdobo1Click(Sender: TObject);
  private
    filtk : string ;
    filtS : string ;
    filtD : string ;
    procedure Setsql2 ;
    Procedure Setconnect ;
  public
    procedure prikaz ;
    function ZapisSeznam(srz,oro,krdod: string) : integer;
    function Iscimer(srz,krdod : string) : integer;
    procedure ZapisMer1(idm,j : Integer; poz,eval: string; xx : single) ;
    procedure ZapisMer2(idm,stv: integer; poz,eval,opo: string) ;
    Procedure LokalSAP ;

  end;

var
  FlokalMeritve: TFlokalMeritve;

implementation

{$R *.dfm}

uses lokalBaza, CasDoba;

procedure TFlokalMeritve.ADOQuery1AfterScroll(DataSet: TDataSet);
begin
  setsql2 ;
end;

procedure TFLokalmeritve.prikaz ;
begin
  Setconnect ;
  filtD := '' ;
  filtK := '' ;
  filtS := '' ;
  Adoquery1.SQL.Clear ;
  Adoquery1.SQL.Add('select * from seznamMer' ) ;
  Adoquery1.Open ;
  setsql2 ;
  ShowModal ;
  Adoquery1.Close ;
end;

procedure TFLokalmeritve.Setsql2 ;
  var idl : integer ;
begin
  if not Adoquery1.isempty then
  begin
    if not Adoquery1.fieldByName('idmer').isnull then
    begin
      idl := Adoquery1.fieldByName('idmer').value ;
      Adoquery2.sql.clear ;
      Adoquery2.sql.add('SELECT * from meritve where idmer = :ID order by poz,ident') ;
      Adoquery2.parameters[0].name := 'ID' ;
      Adoquery2.parameters[0].value := idl ;
      Adoquery2.Open ;
    end;
  end;
end ;

function TFLokalmeritve.ZapisSeznam(srz,oro,krdod: string) : integer;
begin
   Setconnect ;
   Adoquery1.sql.clear ;
   Adoquery1.sql.add('SELECT * from seznammer') ;
   Adoquery1.open ;
   Adoquery1.Append ;
   adoquery1.fieldbyname('cas').value  := now ;
   adoquery1.fieldbyname('prenos').value  := 0 ;
   adoquery1.fieldbyname('sarza').value  := srz ;
   adoquery1.fieldbyname('orodje').value  := oro ;
   adoquery1.fieldbyname('dodl').value  := krdod ;
   adoquery1.fieldbyname('zakljucen').value  := 0 ;
   Adoquery1.post ;
   result := AdoQuery1.fieldByName('idmer').value ;
   Adoquery1.Close ;
end;

procedure TFlokalMeritve.Button1Click(Sender: TObject);
  const MM = 8 ;
  type mers = record
     poz : string ;
     zap : integer ;
     rez : single ;
  end ;

  var ff : textfile ;
      cs,srz : string ;
      tx : string ;
      rezi : merarr ;
      kd : string ;
      dl : string ;
      poz : string ;
      ii,nn : integer ;
      xx : single ;
      knc : boolean ;
      ss : string ;
      zac : integer ;
begin
  AssignFile(ff, 'prenos.csv');
  rewrite(ff);
  rezi[1].poz := '0010' ;
  Adoquery1.First ;
  //writeln(ff,'Datum;Šarža;Koda;Stružnica') ;
  zac := 0 ;
  while not Adoquery1.eof do
  begin
    cs := DateTimeTostr(adoquery1.FieldByName('cas').Value) ;
    if not adoquery1.FieldByName('sarza').isnull then
    begin
      srz := adoquery1.FieldByName('sarza').Value ;
      if not adoquery1.FieldByName('dodl').isnull then
        dl := IntTostr(adoquery1.FieldByName('dodl').Value) else dl := '1'  ;
      FLokalbaza.Getsab(srz,kd,rezi) ;
      if zac = 0 then
      begin
        tx := 'Datum;Šarža;Koda;Stružnica' ;
        for ii := 1 to MM do
        begin
          tx := tx + ';' + rezi[ii].naz
        end;
        writeln(ff,tx) ;
      end;
      inc(zac) ;
      tx := cs + ';' + srz + ';' +  kd + ';' + dl ;
      adoquery2.First ;
      while not Adoquery2.Eof do
      begin
        poz := adoquery2.FieldByName('poz').Value ;
        if not adoquery2.FieldByName('vrednost').isnull then
            xx := adoquery2.FieldByName('vrednost').Value  else xx := 0 ;
        nn := 1 ;
        knc := false ;
        repeat
          for ii := 1 to MM do
          begin
            if (rezi[ii].poz = poz) and (rezi[ii].zap = nn) then
            begin
              if rezi[ii].rez = 99 then
              begin
                rezi[ii].rez := xx ;
                knc := true ;
              end;
            end
          end;
          inc(nn) ;
        until knc or (nn = 3);
        adoquery2.Next
      end;
      for ii := 1 to MM do
      begin
        if rezi[ii].rez = 99 then ss := '' else ss := FloatToStrF(rezi[ii].rez,ffFixed,8,2) ;
        tx := tx + ';' + ss ;
      end;
      writeln(ff,tx) ;
    end;
    Adoquery1.next ;
  end;
  CloseFile(ff);
end;

function TFLokalmeritve.Iscimer(srz,krdod : string) : integer;
  var bk : Tbookmark ;
      dt,dtt : single ;
begin
   Setconnect ;
   Adoquery1.sql.clear ;
   Adoquery1.sql.add('SELECT * from seznammer where (prenos = 0) and (zakljucen = 0) and (sarza = :SRZ) and (dodl = :DOD)') ;
   Adoquery1.parameters[0].name := 'SRZ' ;
   Adoquery1.parameters[0].value := srz ;
   Adoquery1.parameters[1].name := 'DOD' ;
   Adoquery1.parameters[1].value := krdod ;
   Adoquery1.open ;
   if not Adoquery1.isempty then
   begin
     adoquery1.First ;
     bk :=Adoquery1.GetBookmark ;
     dt := now - Adoquery1.FieldByName('cas').Value ;
     adoquery1.Next ;
     while not Adoquery1.eof do
     begin
        dtt := now - Adoquery1.FieldByName('cas').Value ;
        if dtt < dt  then
        begin
          dt := dtt ;
          bk := Adoquery1.GetBookmark ;
        end;
        adoquery1.Next ;
     end;
     Adoquery1.GotoBookmark(bk) ;
     result := Adoquery1.FieldByName('idmer').Value ;
     Adoquery1.Edit ;
     Adoquery1.FieldByName('zakljucen').Value := 1  ;
     Adoquery1.Post ;
   end else result := 0 ;
end;


procedure TFLokalmeritve.ZapisMer1(idm,j : Integer; poz,eval: string; xx : single) ;
begin
   Setconnect ;
   Adoquery2.sql.clear ;
   Adoquery2.sql.add('SELECT * from meritve') ;
   Adoquery2.open ;
   Adoquery2.Append ;
   adoquery2.fieldbyname('idmer').value  := idm ;
   adoquery2.fieldbyname('tip').value  := 1;
   adoquery2.fieldbyname('stv').value  := j;
   adoquery2.fieldbyname('poz').value  := poz;
   adoquery2.fieldbyname('vrednost').value  := xx;
   adoquery2.fieldbyname('eval').value  := eval;
   Adoquery2.post ;
   Adoquery2.Close ;
end;

procedure TFlokalMeritve.ZapisMer2(idm,stv: integer; poz,eval,opo: string) ;
begin
   Setconnect ;
   Adoquery2.sql.clear ;
   Adoquery2.sql.add('SELECT * from meritve') ;
   Adoquery2.open ;
   Adoquery2.Append ;
   adoquery2.fieldbyname('idmer').value  := idm ;
   adoquery2.fieldbyname('tip').value  := 2;
   adoquery2.fieldbyname('slabi').value  := stv;
   adoquery2.fieldbyname('poz').value  := poz;
   adoquery2.fieldbyname('opomba').value  := opo;
   adoquery2.fieldbyname('eval').value  := eval;
   Adoquery2.post ;
   Adoquery2.Close ;
end;


Procedure TflokalMeritve.Setconnect ;
  var dir : string ;
begin
   dir := ExtractfilePath(application.ExeName) ;

   adoquery1.connectionString := 'FILE NAME=' + dir + 'obdel.udl';
   adoquery2.connectionString := 'FILE NAME=' + dir + 'obdel.udl';
end;

Procedure TFlokalMeritve.LokalSAP ;
  var dd : TdateTime ;
      karlist : Tlist ;
      evalList : Tlist ;
      merl,nazivp : string ;
      srz, opr,orod : string ;
      pv : ^karmer ;
      px : ^evaluac ;
      ii,tip,slb : Integer ;
      npz,poz : string ;
      odl : string ;
      stnp : integer ;
      bb : boolean ;
      listopr : TstringList ;
begin
  Setconnect ;
  Adoquery1.SQL.Clear ;
  Adoquery1.SQL.Add('select * from seznamMer where prenos = 0' ) ;
  Adoquery1.Open ;
  setsql2 ;
  AdoQuery1.first ;
  odl := 'A' ;
  merl := '' ;
  while not Adoquery1.eof do
  begin
     dd := Adoquery1.FieldByName('cas').Value ;
     srz := Adoquery1.FieldByName('sarza').Value ;
     orod := Adoquery1.FieldByName('orodje').Value ;
     nazivp := orod ;
     listopr := TstringList.Create ;
     Fsap.BeriOperac(srz,listopr) ;
     opr := listopr[0] ;
     listopr.Free ;
     karlist := Tlist.Create ;
     evalList := TList.Create ;
     Adoquery2.first ;
     npz := '' ;
     ii := 1 ;
     while not Adoquery2.eof do
     begin
       new(pv) ;
       poz := Adoquery2.FieldByName('poz').Value ;
       if npz <> poz then
       begin
         stnp := FlokalBaza.getstvz(srz,poz) ;
         if npz <> '' then evalList.add(px) ;
         new(px) ;
         px^.ev := 'A' ;
         px^.st := 0 ;
         npz := poz ;
       end;
       pv^.stkar := poz ;
       tip := Adoquery2.FieldByName('tip').Value ;
       pv^.stmer := ii ;
       if tip = 1 then
       begin
         pv^.skupi := 'X' ;
         pv^.tip := '01';
         pv^.merit :=  Adoquery2.FieldByName('vrednost').Value ;
         pv^.eval := Adoquery2.FieldByName('eval').Value ;
         if pv^.eval = 'R' then
         begin
           px^.ev := 'R' ;
           px^.st := px^.st + 1 ;
         end;
       end else
       begin
         pv^.skupi := '' ;
         pv^.tip := '02';
         slb := Adoquery2.FieldByName('slabi').Value ;
         px^.stkar := Adoquery2.FieldByName('poz').Value ;
         px^.st  := slb ;
         if slb <> 0 then
         begin
           pv^.eval := 'R' ;
           px^.ev := 'R' ;

         end else  pv^.eval := 'A' ;
       end;
       karlist.Add(pv) ;
       Adoquery2.next ;
       inc(ii) ;
     end;
     evalList.add(px) ;
     bb := Fsap.zapis(srz,opr,nazivp,merl,odl,orod,dd,karlist,evalList)  ;
     if bb then
     begin
       Adoquery1.edit ;
       Adoquery1.FieldByName('prenos').Value := 1 ;
       ADoquery1.Post ;
     end;
     Adoquery1.Next ;
     CistiListE(evalList) ;
     CistiList1(karlist) ;
  end;
  if bb then showmessage('Prenos uspešno konèan') else Showmessage('Prenos ni bil izveden')

end;



procedure TFlokalMeritve.Button2Click(Sender: TObject);
  var ii : integer ;
begin
  ii := MessageDlg('Ali zares želiš izbrisati?',mtConfirmation,[mbYes, mbNo],0);
  if ii = 6 then
  begin
     if adoquery2.IsEmpty then Adoquery1.delete
                          else Adoquery2.delete  ;
  end ;
end;

procedure TFlokalMeritve.Filternaasdobo1Click(Sender: TObject);
  var dat1,dat2 : string ;
begin
  Adoquery1.Filtered := true ;
  FcasDoba.Vpis(dat1,dat2) ;
  filtD := '(cas > ''' + dat1 + ''') and (cas < ''' + dat2 + ''')' ;
  if filtk <> '' then Adoquery1.Filter := filtD + ' and ' + filtk
                 else Adoquery1.Filter := filtD ;
end;

procedure TFlokalMeritve.Filternakontserijo1Click(Sender: TObject);
 var sar : string ;
begin

  sar := Adoquery1.fieldByName('sarza').value ;
  filtk := 'sarza = ' + sar ;
  Adoquery1.filtered := true ;
  if filtd <> '' then Adoquery1.filter := filtk + ' and ' + filtD
                 else Adoquery1.filter := filtk ;
end;

end.
