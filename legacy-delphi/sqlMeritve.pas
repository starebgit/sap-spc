unit sqlMeritve;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls,sap, postaje, grafi, Vcl.StdCtrls,pass,deklar,System.strUtils;

type
  TFSqlMeritve = class(TForm)
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
    Label1: TLabel;
    Label2: TLabel;
    ADOQuery1idmer: TAutoIncField;
    ADOQuery1idpost: TIntegerField;
    ADOQuery1datum: TDateTimeField;
    ADOQuery1koda: TStringField;
    ADOQuery1sarza: TStringField;
    ADOQuery1dodatno: TStringField;
    ADOQuery2idkarm: TAutoIncField;
    ADOQuery2idmer: TIntegerField;
    ADOQuery2karakt: TStringField;
    ADOQuery2zapvz: TSmallintField;
    ADOQuery2vrednost: TFloatField;
    Button3: TButton;
    ADOQuery1idstroj: TStringField;
    ADOQuery1orodja: TStringField;
    ADOQuery2ukrep: TStringField;
    ADOQuery2slabi: TSmallintField;
    Button4: TButton;
    ADOQuery2naziv: TStringField;
    Button5: TButton;
    ADOQuery1merilec: TStringField;
    procedure ADOQuery1AfterScroll(DataSet: TDataSet);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    adm : boolean ;
    procedure SetConnect ;
    procedure Sqlkar ;
  public
    Procedure Zapis(koda,srz,orod,idstr,merl : string; karlist : Tlist) ;
    Procedure pregled(admin : boolean) ;
    procedure getlist(kd,stkar : string; listr: Tlist);
    Procedure Getstat(listr : Tlist; var avr,std : single) ;
  end;

var
  FSqlMeritve: TFSqlMeritve;

implementation

{$R *.dfm}

uses DefFilter, SqlKode;

//uses pass;

procedure TFSqlMeritve.SetConnect ;
  var dir : string ;
begin
  dir := ExtractfilePath(application.ExeName) ;
  adoquery1.connectionString := 'FILE NAME=' + dir + 'strojna.udl';
  adoquery2.connectionString := 'FILE NAME=' + dir + 'strojna.udl';
end;


procedure TFSqlMeritve.Sqlkar ;
  var idl : integer ;
begin
 // if not Adoquery1.isempty then
   if not Adoquery1.fieldByName('idmer').isnull then
  begin
    idl := Adoquery1.fieldByName('idmer').value ;
    Adoquery2.sql.clear ;
    Adoquery2.sql.add('SELECT * from karmer where idmer = :ID') ;
    Adoquery2.parameters[0].name := 'ID' ;
    Adoquery2.parameters[0].value := idl ;
    Adoquery2.Open ;
  end;
end ;

procedure TFSqlMeritve.ADOQuery1AfterScroll(DataSet: TDataSet);
begin
  sqlkar ;
end;

Procedure TFSqlmeritve.pregled(admin : boolean) ;
  var idp : integer ;
begin
  width := 1700 ;
  adm := admin ;
  SetConnect ;
  idp := Fpostaje.Getpost ;
  dbgrid1.ReadOnly := not admin ;
  dbgrid2.ReadOnly := not admin ;
  label2.Caption := Fpostaje.GetImePost ;
  panel1.Color := $02DEDAC0 ;
  Adoquery1.SQL.Clear ;
  adoquery1.SQL.Add('select * from glavmer where idpost = :IDP order by datum') ;
  Adoquery1.Parameters[0].Name := 'IDP' ;
  Adoquery1.Parameters[0].value := idp ;
  adoquery1.Open ;
  adoquery1.filtered := false ;
  button3.Caption := 'Filter' ;
  adoquery1.Last ;
  sqlkar ;
  showModal ;
  Adoquery1.close ;
  Adoquery2.close ;
end;

Procedure TFSqlmeritve.Zapis(koda,srz,orod,idstr,merl : string; karlist : Tlist) ;
  var id,ii : integer ;
      pp : ^karmer ;
      ss,s1 : string ;
begin
  SetConnect ;
  Adoquery1.SQL.Clear ;
  adoquery1.SQL.Add('select * from glavmer') ;
  adoquery1.Open ;
  sqlkar ;
  Adoquery1.append ;
  Adoquery1.fieldByname('idpost').value := Fpostaje.Getpost  ;
  Adoquery1.fieldbyname('koda').value := koda ;
  Adoquery1.fieldbyname('sarza').value := srz ;
  Adoquery1.fieldbyname('idstroj').value := idstr ;
  Adoquery1.fieldbyname('merilec').value := merl ;
  Adoquery1.fieldbyname('orodja').value := orod ;
  Adoquery1.fieldbyname('datum').value := now ;
  Adoquery1.post ;
  id := Adoquery1.FieldByName('idmer').Value ;
  for ii := 0 to karlist.Count-1 do
  begin
     pp := karlist[ii] ;
     if (pp^.skupi = 'X') or (pp^.stevilvz = 1) then
     begin
       adoquery2.Append ;
       adoquery2.FieldByName('idmer').Value := id ;
       adoquery2.FieldByName('karakt').Value := pp^.stkar  ;
       adoquery2.FieldByName('naziv').Value := pp^.imekar  ;
       adoquery2.FieldByName('ukrep').Value := pp^.opom  ;
       if pp^.skupi = 'X' then
       begin
         ss := pp^.merit ;
         s1 := replacestr(ss,'.',',') ;
         adoquery2.FieldByName('vrednost').Value := StrToFloat(s1) ;
         adoquery2.FieldByName('zapvz').Value := pp^.stevilvz  ;
       //  adoquery2.FieldByName('slabi').Value := pp^.stevnp  ;
       end else
       begin
         adoquery2.FieldByName('zapvz').Value := pp^.stevilvz  ;
         adoquery2.FieldByName('slabi').Value := pp^.stevnp  ;

       end ;
       adoquery2.Post ;
     end;

  end;
  adoquery1.Close ;
end;

Procedure Tfsqlmeritve.Getstat(listr : Tlist; var avr,std : single) ;
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
  if nn > 0 then avr := sum/nn else avr := 0 ;
  sum := 0 ;
  for ii := 0 to nn-1 do
  begin
    pp := listr[ii] ;
    sum := sum + sqr(pp^.vrednost-avr)  ;
  end;
  if nn > 1 then  std := sqrt(sum/(nn-1)) else std := 0 ;
end;




procedure TFSqlMeritve.Button1Click(Sender: TObject);
  var bb : boolean ;
begin
  bb := Fpassw.getpas ;
  if bb then
  begin
    DbGrid1.readOnly := false ;
    DbGrid2.readOnly := false ;
  end else ShowMessage('Geslo ni pravilno') ;

end;

procedure TFSqlMeritve.Button2Click(Sender: TObject);
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

procedure TFSqlMeritve.Button3Click(Sender: TObject);
  var dat1,dat2,kd  : string ;
      filt,srz : string ;
      dt1,dt2 : TdateTime ;
begin
  if not adoquery1.filtered  then
  begin
    kd := adoquery1.FieldByName('koda').Value ;
    srz := adoquery1.FieldByName('sarza').Value ;
    FdefFilter.vpis(dt1,dt2,kd,srz) ;
    Adoquery1.Filtered := true ;
    dat1 := DateTostr(dt1) ;
    dat2 := DateTostr(dt2) ; ;
    filt := '(datum >= ''' + dat1 + ''') and (datum < ''' + dat2 + ''')' ;
    if kd <> '' then filt := filt + ' and (koda = ' + kd + ')' ;
    if srz <> '' then filt := filt + ' and (sarza = ' + srz + ')' ;
    Adoquery1.Filter := filt ;
    adoquery1.Filtered := true ;
    button3.Caption := 'Brez filtra' ;
  end else
  begin
    adoquery1.Filtered := false ;
    button3.Caption := 'Filter' ;
    adoquery1.Last ;
  end;
end;

procedure TFSqlMeritve.Button4Click(Sender: TObject);
  var idp : integer ;
begin
  Fpostaje.pregled(adm) ;
  idp := Fpostaje.Getpost ;
  dbgrid1.ReadOnly := not adm ;
  dbgrid2.ReadOnly := not adm ;
  label2.Caption := Fpostaje.GetImePost ;
  panel1.Color := $02DEDAC0 ;
  adoquery1.close ;
  Adoquery1.SQL.Clear ;
  adoquery1.SQL.Add('select * from glavmer where idpost = :IDP order by datum') ;
  Adoquery1.Parameters[0].Name := 'IDP' ;
  Adoquery1.Parameters[0].value := idp ;
  adoquery1.Open ;
  adoquery1.filtered := false ;
  adoquery1.Last ;
end;

procedure TFSqlMeritve.Button5Click(Sender: TObject);
  var srz,nz,poz : string ;
      ii : integer ;
begin
  Adoquery1.First ;
 // for ii := 1 to 5 do

  while not Adoquery1.Eof do
  begin
    srz := Adoquery1sarza.Value ;
    adoquery2.First ;
    while not adoquery2.eof do
    begin
      nz := trim(Adoquery2naziv.value) ;
      if nz = '' then
      begin
        poz := Adoquery2karakt.Value ;
        nz := FsqlKode.GetNaziv(srz,poz) ;
        Adoquery2.edit ;
        Adoquery2naziv.Value := nz ;
        Adoquery2.Post ;
      end;
      adoquery2.next
    end;
    adoquery1.next
  end;
end;

procedure TFsqlMeritve.getlist(kd,stkar : string; listr: Tlist);
  var sm : single ;
      stk : string ;
      nn,kk : integer ;
      pp : ^rezultat ;
begin
  SetConnect ;
  Adoquery1.SQL.Clear ;
  adoquery1.SQL.Add('select * from glavmer where koda = :KD order by datum') ;
  Adoquery1.Parameters[0].Name := 'KD' ;
  Adoquery1.Parameters[0].value := kd ;
  Adoquery1.Open ;
  adoquery1.last ;
  Adoquery1.MoveBy(-30) ;
  sqlkar ;
  kk := 1 ;
  while not Adoquery1.eof do
  begin
    Adoquery2.First ;
    sm := 0 ;
    nn := 0 ;
    while not adoquery2.Eof do
    begin
      try
        stk := Adoquery2.FieldByName('karakt').Value ;
        if stk = stkar then
        begin
          sm := sm + Adoquery2.FieldByName('vrednost').Value ;
          inc(nn) ;
        end;
      except

      end;
      Adoquery2.Next ;
    end;
    if nn > 0 then
    begin
      new(pp) ;
      pp^.vrednost := sm/nn ;
      pp^.vzorec := kk ;
      inc(kk) ;
      pp^.dd := Adoquery1.FieldByName('datum').Value ;
      listr.Add(pp) ;
    end;
    Adoquery1.Next ;
  end;
  Adoquery2.Close ;
  Adoquery1.Close ;
end;


end.
