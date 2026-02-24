unit metode;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls, Vcl.StdCtrls, VpisMetoda, postaje, Vcl.Menus;

type
  TFmetode = class(TForm)
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
    Vpismetode1: TMenuItem;
    Briimetode1: TMenuItem;
    ADOQuery1idmet: TAutoIncField;
    ADOQuery1idpost: TIntegerField;
    ADOQuery1metoda: TStringField;
    ADOQuery1kanal: TWordField;
    ADOQuery1opis: TStringField;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Vpismetode1Click(Sender: TObject);
    procedure Briimetode1Click(Sender: TObject);
  private
    adm : boolean ;
    procedure SetConnect ;
  public
    Procedure prikaz(admin : boolean)  ;
    procedure Zapis(idp,kan: integer; mp,op : string )  ;
    function Getkanal(mp : string) : Integer;
  end;

var
  Fmetode: TFmetode;

implementation

{$R *.dfm}

procedure TFmetode.Briimetode1Click(Sender: TObject);
var ii : integer ;
begin
  if not adm then exit ;
  ii := MessageDlg('Ali zares želiš izbrisati?',mtConfirmation,[mbYes, mbNo],0);
  if ii = 6 then  Adoquery1.delete ;
end;

procedure TFmetode.Button1Click(Sender: TObject);
begin
  if adm then   FVpismetoda.vpis ;
end;

Procedure TFmetode.prikaz(admin : boolean) ;
  var idp : integer ;
begin
  adm := admin ;
  setconnect ;
  idp := Fpostaje.Getpost ;
  dbgrid1.ReadOnly := not admin ;
  //edit1.Text := Fpostaje.GetImePost ;
  panel1.Color := $02DEDAC0 ;
  label2.Caption :=  Fpostaje.GetImePost ;
  Adoquery1.sql.clear ;
  //Adoquery1.sql.add('SELECT * FROM metode ') ;
  Adoquery1.sql.add('SELECT * FROM metode where idpost = :POS') ;
  Adoquery1.Parameters[0].Name := 'POS' ;
  Adoquery1.Parameters[0].value := idp ;
  Adoquery1.open ;
  ShowModal ;
end;

procedure TFmetode.SetConnect ;
  var dir : string ;
begin
  dir := ExtractfilePath(application.ExeName) ;
  adoquery1.connectionString := 'FILE NAME=' + dir + 'strojna.udl';
end;

procedure TFmetode.Vpismetode1Click(Sender: TObject);
begin
  if adm then   FVpismetoda.vpis ;
end;

procedure TFMetode.Zapis(idp,kan: integer; mp,op : string )  ;
begin
  Adoquery1.append ;
  adoquery1.fieldbyname('idpost').value := idp;
  adoquery1.fieldbyname('metoda').value := mp;
  adoquery1.fieldbyname('kanal').value := kan;
   adoquery1.fieldbyname('opis').value := op;
  Adoquery1.post ;

end;

procedure TFmetode.Button2Click(Sender: TObject);
  var ii : integer ;
begin
  if not adm then exit ;
  ii := MessageDlg('Ali zares želiš izbrisati?',mtConfirmation,[mbYes, mbNo],0);
  if ii = 6 then  Adoquery1.delete ;
end;

function TFmetode.Getkanal(mp : string) : Integer;
  var idp : integer ;
begin
  setconnect ;
  idp := Fpostaje.Getpost ;
  Adoquery1.sql.clear ;
  Adoquery1.sql.add('SELECT * FROM metode where (idpost = :IDP) and (metoda = :MTD)') ;
  Adoquery1.Parameters[0].Value := idp ;
  Adoquery1.Parameters[0].name := 'IDP' ;
  Adoquery1.Parameters[1].Value := mp ;
  Adoquery1.Parameters[1].name := 'MTD' ;
  Adoquery1.open ;
  if Adoquery1.isempty then result := 0 else result := adoquery1.fieldbyname('kanal').value ;
  Adoquery1.close ;
end;


end.
