unit verzije;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TFverzije = class(TForm)
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
    ADOQuery1idver: TAutoIncField;
    ADOQuery1imever: TStringField;
    ADOQuery2idnov: TAutoIncField;
    ADOQuery2idver: TIntegerField;
    ADOQuery2novost: TStringField;
    procedure ADOQuery1AfterScroll(DataSet: TDataSet);
    procedure Button1Click(Sender: TObject);
  private
    procedure Sql1 ;
  public
    Procedure pokazi ;
  end;

var
  Fverzije: TFverzije;

implementation

{$R *.dfm}

uses pass;

procedure TFverzije.Sql1 ;
  var idl : integer ;
begin
  if  Adoquery1.isempty then exit ;
   if not Adoquery1.fieldByName('idver').isnull then
  begin
    idl := Adoquery1.fieldByName('idver').value ;
    Adoquery2.sql.clear ;
    Adoquery2.sql.add('SELECT * from novosti where idver = :ID') ;
 // Adoquery2.sql.add('SELECT * from novosti ') ;
    Adoquery2.parameters[0].name := 'ID' ;
    Adoquery2.parameters[0].value := idl ;
    Adoquery2.Open ;
  end else
  begin
    //Adoquery2.sql.clear ;
   // Adoquery2.sql.add('SELECT * from konplan') ;
   // Adoquery2.Open ;
  end
end ;


procedure TFverzije.ADOQuery1AfterScroll(DataSet: TDataSet);
begin
  Sql1
end;

procedure TFverzije.Button1Click(Sender: TObject);
  var bb : boolean ;
begin
  bb := Fpassw.getpas ;
  if bb then
  begin
    DbGrid1.readonly := false ;
    DbGrid2.readonly := false ;
    adoquery1idver.visible := true ;
    adoquery2idnov.Visible := true ;
    adoquery2idver.visible := true ;
  end;
end;

Procedure TFverzije.pokazi ;
begin
  DbGrid1.readonly := true ;
  DbGrid2.readonly := true ;
  adoquery1.sql.clear ;
  Adoquery1.sql.add('select * from verzije') ;
  Adoquery1.open ;
  Sql1 ;
  ShowModal ;
end;

end.
