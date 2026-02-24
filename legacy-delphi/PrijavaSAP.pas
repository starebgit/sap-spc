
unit PrijavaSAP;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Data.DB, Data.Win.ADODB,
  Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls,deklar;

type
  TFprijavaSAP = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    ADOQuery1: TADOQuery;
    ADOQuery1ident: TAutoIncField;
    ADOQuery1uporab: TStringField;
    ADOQuery1sistem: TStringField;
    ADOQuery1client: TStringField;
    ADOQuery1streznik: TStringField;
    ADOQuery1sysnnum: TSmallintField;
    ADOQuery1pass: TStringField;
    ADOQuery1jezik: TStringField;
    ADOQuery1glavni: TStringField;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    izbor : integer ;
  public
    Procedure prikaz ;
    Procedure GetPrijava(var prija : Tprijava) ;
    Procedure GetNew(var prija : Tprijava) ;
  end;

var
  FprijavaSAP: TFprijavaSAP;

implementation

{$R *.dfm}

uses VpisPrijava;

procedure TFprijavaSAP.Button1Click(Sender: TObject);
  var sistem,cli,applic,upo,ges,jezik : string ;
      sisnum : Integer ;
      def : boolean ;
      prija : Tprijava ;
begin
  FVpisprijava.Vpis(prija) ;
  if prija.sistem <> '' then
  begin
    Adoquery1.Append ;
    Adoquery1uporab.value := prija.upo ;
    Adoquery1sistem.value := prija.sistem ;
    Adoquery1client.value := prija.cli ;
    Adoquery1streznik.value := prija.applic ;
    Adoquery1pass.value := prija.ges ;
    Adoquery1jezik.value := prija.jezik ;
    Adoquery1sysnnum.value := prija.sisnum ;
    if prija.def then Adoquery1glavni.value := 'X' ;
    Adoquery1.Post ;
  end;

end;

procedure TFprijavaSAP.Button2Click(Sender: TObject);
begin
  izbor := Adoquery1ident.Value ;
  if izbor = 0  then label1.caption := 'Izbrani Default'
                else label1.caption := 'Izbrani : Št. ' + IntTostr(izbor) ;
end;

procedure TFprijavaSAP.FormActivate(Sender: TObject);
begin
  izbor := 0 ;
end;

procedure TFprijavaSAP.FormCreate(Sender: TObject);
 var dir : string ;
begin
   dir := ExtractFilePath(application.ExeName) + '\SapVpis.udl';
   Adoquery1.ConnectionString := 'FILE NAME=' + dir ;
end;

Procedure TFPrijavaSAP.prikaz ;
begin
  if izbor = 0  then label1.caption := 'Izbrani Default'
                else label1.caption := 'Izbrani : Št. ' + IntTostr(izbor) ;
  Adoquery1.sql.clear ;
  Adoquery1.sql.add('select * from prijava') ;
  Adoquery1.open ;
  ShowModal ;
  Adoquery1.close ;
end;


Procedure TFPrijavaSAP.GetPrijava(var prija : Tprijava) ;
begin
  if izbor = 0  then
  begin
    Adoquery1.sql.clear ;
    Adoquery1.sql.add('select * from prijava where glavni = ''X''') ;
    Adoquery1.Open ;
  end else
  begin
    Adoquery1.sql.clear ;
    Adoquery1.sql.add('select * from prijava where ident = :ID') ;
    Adoquery1.parameters[0].name := 'ID' ;
    Adoquery1.parameters[0].value := izbor;
    Adoquery1.open ;
  end;
  if not Adoquery1.isempty then
  begin
    with prija do
    begin
      upo := Adoquery1uporab.value  ;
      sistem := Adoquery1sistem.value  ;
      cli :=  Adoquery1client.value  ;
      applic := Adoquery1streznik.value  ;
      ges := Adoquery1pass.value  ;
      jezik := Adoquery1jezik.value  ;
      sisnum :=  Adoquery1sysnnum.value  ;
      if Adoquery1glavni.value = 'X' then def := true else def := false ;
    end;
  end;
  adoquery1.Close ;
end;

Procedure TFPrijavaSAP.GetNew(var prija : Tprijava) ;
begin
  Adoquery1.sql.clear ;
  Adoquery1.sql.add('select * from prijava where glavni = ''N''') ;
  Adoquery1.Open ;

  if not Adoquery1.isempty then
  begin
    with prija do
    begin
      upo := Adoquery1uporab.value  ;
      sistem := Adoquery1sistem.value  ;
      cli :=  Adoquery1client.value  ;
      applic := Adoquery1streznik.value  ;
      ges := Adoquery1pass.value  ;
      jezik := Adoquery1jezik.value  ;
      sisnum :=  Adoquery1sysnnum.value  ;
      if Adoquery1glavni.value = 'X' then def := true else def := false ;
    end;
  end;
  adoquery1.Close ;
end;


end.
