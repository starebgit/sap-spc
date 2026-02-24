unit merila;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TFmerila = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    ADOQuery1: TADOQuery;
    Button1: TButton;
    Button2: TButton;
    ADOQuery1idmerila: TAutoIncField;
    ADOQuery1red: TWordField;
    ADOQuery1idpost: TWordField;
    ADOQuery1stevilka: TStringField;
    ADOQuery1naziv: TStringField;
    ADOQuery1opis: TStringField;
    Label1: TLabel;
    Button3: TButton;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    idp : integer ;
    ipos : integer ;
    Procedure doSql ;
  public
    Procedure pokazi(adm : boolean; pos : integer; imep : string) ;
  end;

var
  Fmerila: TFmerila;

implementation

{$R *.dfm}

uses Vpismerila;


procedure TFmerila.Button1Click(Sender: TObject);
  var red : integer ;
      stev,naziv,opis : string ;
begin
  Adoquery1.Last ;
  red := adoquery1.fieldByName('red').asinteger ;
  FvpisMerila.vpis(red,stev,naziv,opis) ;
  if red > 0  then
  begin
    Adoquery1.append ;
    Adoquery1.fieldByname('idpost').value := idp ;
    Adoquery1.fieldByname('red').value := red ;
    Adoquery1.fieldByname('stevilka').value := stev ;
    Adoquery1.fieldByname('naziv').value := naziv ;
    Adoquery1.fieldByname('opis').value := opis ;
    Adoquery1.post ;
  end;
end;

procedure TFmerila.Button2Click(Sender: TObject);
begin
  Close ;
end;

procedure TFmerila.Button3Click(Sender: TObject);
  var ii :Integer ;
begin
  ii := MessageDlg('Ali zares želiš izbrisati?',mtConfirmation,[mbYes, mbNo],0);
  if ii = 6 then Adoquery1.delete ;
end;

procedure TFmerila.Button4Click(Sender: TObject);
begin
  Adoquery1.post ;
  DoSql
end;

Procedure TFmerila.doSql ;
begin
  Adoquery1.SQL.Clear ;
  Adoquery1.SQL.Add('select * from merila where idpost = :POS order by red') ;
  Adoquery1.Parameters[0].Name := 'POS' ;
  Adoquery1.Parameters[0].value := ipos ;
  Adoquery1.Open ;
end;


Procedure TFMerila.pokazi(adm : boolean; pos : integer; imep : string) ;
begin
  ipos := pos ;
 // showMessage(IntTostr(pos)) ;
  dbgrid1.readonly := not adm ;
  button1.visible := adm ;
  button3.visible := adm ;
  //label1.FontColor  := clBlue ;
  label1.Caption := 'Seznam meril za merilno mesto: ' + imep ;
  idp := pos ;
  panel1.Color := $02DEDAC0 ;
  DoSql ;
  ShowModal ;
end;

end.
