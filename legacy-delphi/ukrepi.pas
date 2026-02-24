unit ukrepi;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB, Vcl.Grids,postaje,
  Vcl.DBGrids, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Menus;

type
  TFukrepi = class(TForm)
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
    Vpisukrepa1: TMenuItem;
    Briiukrep1: TMenuItem;
    ADOQuery1idukr: TAutoIncField;
    ADOQuery1idpost: TIntegerField;
    ADOQuery1ukrep: TStringField;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Vpisukrepa1Click(Sender: TObject);
    procedure Briiukrep1Click(Sender: TObject);
  private
    procedure SetConnect ;
  public
    Procedure prikaz ;
    procedure Getukrepi(var listuk : TstringList);
  end;

var
  Fukrepi: TFukrepi;

implementation

{$R *.dfm}

Procedure TFukrepi.prikaz ;
  var idp : integer ;
begin
  setconnect ;
  idp := Fpostaje.Getpost ;
  //edit1.Text := Fpostaje.GetImePost ;
  panel1.Color := $02DEDAC0 ;
  label2.Caption := Fpostaje.GetImePost ;
  Adoquery1.sql.clear ;
  Adoquery1.sql.add('SELECT * FROM ukrepi where idpost = :IDP') ;
  Adoquery1.Parameters[0].Value := idp ;
  Adoquery1.Parameters[0].name := 'IDP' ;
  Adoquery1.open ;
  ShowModal ;
end;

procedure TFukrepi.SetConnect ;
  var dir : string ;
begin
  dir := ExtractfilePath(application.ExeName) ;
  adoquery1.connectionString := 'FILE NAME=' + dir + 'strojna.udl';
end;

procedure TFukrepi.Vpisukrepa1Click(Sender: TObject);
 var ii : integer ;
begin
  ii := Fpostaje.Getpost ;
  Adoquery1.Append ;
  Adoquery1.FieldByName('idpost').Value := ii ;
  Adoquery1.Post ;
end;

procedure TFukrepi.Briiukrep1Click(Sender: TObject);
  var ii : integer ;
begin
  ii := MessageDlg('Ali zares želiš izbrisati?',mtConfirmation,[mbYes, mbNo],0);
  if ii = 6 then  Adoquery1.delete ;
end;

procedure TFukrepi.Button1Click(Sender: TObject);
  var ii : integer ;
begin
  ii := Fpostaje.Getpost ;
  Adoquery1.Append ;
  Adoquery1.FieldByName('idpost').Value := ii ;
  Adoquery1.Post ;
end;

procedure TFukrepi.Button2Click(Sender: TObject);
  var ii : integer ;
begin
  ii := MessageDlg('Ali zares želiš izbrisati?',mtConfirmation,[mbYes, mbNo],0);
  if ii = 6 then  Adoquery1.delete ;
end;

procedure TFukrepi.Getukrepi(var listuk : TstringList);
  var idp : integer ;
begin
  setconnect ;
  idp := Fpostaje.Getpost ;
  Adoquery1.sql.clear ;
  Adoquery1.sql.add('SELECT * FROM ukrepi where idpost = :IDP') ;
  Adoquery1.Parameters[0].Value := idp ;
  Adoquery1.Parameters[0].name := 'IDP' ;
  Adoquery1.open ;
  Adoquery1.first ;
  while not Adoquery1.eof do
  begin
    listuk.Add(adoquery1.fieldbyname('ukrep').value) ;
    Adoquery1.Next ;
  end;
  Adoquery1.close ;
end;

end.
