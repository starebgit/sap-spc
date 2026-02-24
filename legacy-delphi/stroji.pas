unit stroji;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls, Vcl.StdCtrls, VpisStroj, deklar, Vcl.Menus, SqlKode, IzborSrz;

type
  TFstroji = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    ADOQuery1: TADOQuery;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    MainMenu1: TMainMenu;
    Urejanje1: TMenuItem;
    Vpisstroja1: TMenuItem;
    Izbriistroj1: TMenuItem;
    ADOQuery1zapored: TAutoIncField;
    ADOQuery1stPost: TIntegerField;
    ADOQuery1idstroja: TStringField;
    ADOQuery1sifstroja: TStringField;
    ADOQuery1naziv: TStringField;
    Button3: TButton;
    ADOQuery1koda: TStringField;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Izbriistroj1Click(Sender: TObject);
    procedure Vpisstroja1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    adm : boolean ;
    procedure SetConnect ;
  public
    Procedure Pogled(admin : boolean;pos : integer) ;
    Procedure GetStroji(pos : integer; var ListStr : tlist) ;
    procedure Getkode(ident : Integer; listak : TstringList) ;
  end;

var
  Fstroji: TFstroji;

implementation

{$R *.dfm}

uses postaje, sinapro;



procedure TFstroji.Button1Click(Sender: TObject);
  var ii,stpost : integer ;
      pp : ^zapis ;
      stv : integer ;
begin
  if not adm then  exit ;

  stv := Adoquery1.Recordcount ;
  if stv >= 20 then
  begin
    ShowMessage('Doseženo je maksimalno število strojev') ;
    exit ;
  end;
  FvpisStroj.listStroji := tlist.create ;
  FVpisStroj.Vpis ;
 // FvpisStroj.test ;
  stpost := Fpostaje.GetPost ;
   FvpisStroj.test ;
  for ii := 0 to FvpisStroj.listStroji.count-1 do
  begin
    pp := FvpisStroj.listStroji[ii] ;
    if pp^.izbran then
    begin
      Adoquery1.Append ;
      Adoquery1.fieldbyName('stPost').value := stpost  ;
      Adoquery1.fieldbyName('idStroja').value := pp^.ident ;
      Adoquery1.fieldbyName('naziv').value := pp^.naziv ;
      Adoquery1.Post ;
     // FvpisStroj.test ;
    end;
  end;
  Pocisti1(FvpisStroj.listStroji) ;
 // FvpisStroj.test ;
end;

procedure TFstroji.SetConnect ;
  var dir : string ;
begin
  dir := ExtractfilePath(application.ExeName) ;
  adoquery1.connectionString := 'FILE NAME=' + dir + 'strojna.udl';
end;

procedure TFstroji.Vpisstroja1Click(Sender: TObject);
  var ii,stpost : integer ;
      pp : ^zapis ;
      stv : integer ;
begin
  if not adm then  exit ;

  stv := Adoquery1.Recordcount ;
  if stv >= 20 then
  begin
    ShowMessage('Doseženo je maksimalno število strojev') ;
    exit ;
  end;
  FvpisStroj.listStroji := tlist.create ;
  FVpisStroj.Vpis ;
 // FvpisStroj.test ;
  stv := Adoquery1.Recordcount ;
  stpost := Fpostaje.GetPost ;
   FvpisStroj.test ;
  for ii := 0 to FvpisStroj.listStroji.count-1 do
  begin
    pp := FvpisStroj.listStroji[ii] ;
    if pp^.izbran then
    begin
      Adoquery1.Append ;
      Adoquery1.fieldbyName('stPost').value := stpost  ;
      Adoquery1.fieldbyName('idStroja').value := pp^.ident ;
      Adoquery1.fieldbyName('naziv').value := pp^.naziv ;
      Adoquery1.Post ;
     // FvpisStroj.test ;
    end;
  end;
  Pocisti1(FvpisStroj.listStroji) ;
end;

Procedure TFStroji.Pogled(admin : boolean;pos : integer) ;
begin
  setconnect ;
  adm := admin ;
  panel1.Color := $02DEDAC0 ;
  dbGrid1.ReadOnly := not admin ;
 // edit1.Text := Fpostaje.GetImePost ;
  label2.Caption := Fpostaje.GetImePost ;
  Adoquery1.sql.clear ;
 // Adoquery1.sql.add('SELECT * FROM stroji order by sifstroja') ;
   Adoquery1.sql.add('SELECT * FROM stroji where stPost = :POS order by sifstroja') ;
  Adoquery1.Parameters[0].Name := 'POS' ;
  Adoquery1.Parameters[0].value := pos ;
  Adoquery1.open ;
  ShowModal ;
  Adoquery1.close
end;


procedure TFstroji.Button2Click(Sender: TObject);
  var ii : integer ;
begin
  if not adm then exit ;
  ii := MessageDlg('Ali zares želiš izbrisati?',mtConfirmation,[mbYes, mbNo],0);
  if ii = 6 then
  begin
     Adoquery1.delete  ;
  end ;
end;

procedure TFstroji.Button3Click(Sender: TObject);
  var id,rz : integer ;
      dt,ds : TdateTime ;
      kd : string ;
      ListaKd : TstringList ;
begin
{  id :=  Adoquery1.fieldByname('idstroja').value ;
  dt := strTodate('01.03.2021') ;
  ds := strTodate('01.04.2021') ;
  kd := '--18.145.102/00' ;
  rz := Fsinapro.getKolic(kd,id,dt,ds) ;
  ShowMessage(intTostr(rz)) ;  }
  ListaKd := TstringList.Create ;
  FsqlKode.Getlista(listaKd) ;
  kd := FizborSrz.izbira(listaKd) ;
  adoquery1.Edit ;
  Adoquery1koda.Value := kd ;
  Adoquery1.Post ;
end;

Procedure TFstroji.GetStroji(pos : integer; var ListStr : tlist) ;
  var pp : ^zapis ;
begin
  if not adoquery1.active then
  begin
  setconnect ;
  Adoquery1.sql.clear ;
  Adoquery1.sql.add('SELECT * FROM stroji where stPost = :POS order by sifstroja') ;
  Adoquery1.Parameters[0].Name := 'POS' ;
  Adoquery1.Parameters[0].value := pos ;
  try
    Adoquery1.open ;
  except
    pisilog(IntTostr(pos) + ' Èitanje liste strojev') ;
    exit
  end;
  while not Adoquery1.eof do
  begin
    if Fsinapro.preveristroj(Adoquery1.FieldByName('idstroja').value) then
    begin
      new(pp) ;
      pp^.ident := Adoquery1.FieldByName('idstroja').Value ;
      pp^.naziv := Adoquery1.FieldByName('naziv').Value ;
      listStr.Add(pp) ;
    end;
    Adoquery1.next ;
  end;

  Adoquery1.close
  end;
end;

procedure TFstroji.Izbriistroj1Click(Sender: TObject);
  var ii : integer ;
begin
  if not adm then exit ;
  ii := MessageDlg('Ali zares želiš izbrisati?',mtConfirmation,[mbYes, mbNo],0);
  if ii = 6 then
  begin
     Adoquery1.delete  ;
  end ;
end;

procedure TFstroji.Getkode(ident : Integer; listak : TstringList) ;
begin
  setconnect ;
  Adoquery1.sql.clear ;
  Adoquery1.sql.add('SELECT * FROM stroji where idStroja = :POS order by sifstroja') ;
  Adoquery1.Parameters[0].Name := 'POS' ;
  Adoquery1.Parameters[0].value := ident ;
  adoquery1.Open ;

  while not Adoquery1.eof do
  begin
    if adoquery1koda.Value <> '' then listak.Add(adoquery1koda.Value) ;
    Adoquery1.Next ;
  end;
  Adoquery1.Close ;
end;

end.
