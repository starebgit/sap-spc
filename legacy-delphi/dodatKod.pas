unit dodatKod;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Data.DB, Data.Win.ADODB,
  Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, comObj,pomoc;

type
  TFDodatKod = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    ADOQuery1: TADOQuery;
    ADOQuery1zaopored: TAutoIncField;
    ADOQuery1naziv: TStringField;
    Button1: TButton;
    ADOQuery1koda: TStringField;
    Button2: TButton;
    Button3: TButton;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    kdd : string ;
    dir : string ;
  public
    procedure  Prikazi(kd: string) ;
    procedure Getlist(kd : string; var Listoro : TstringList) ;
  end;

var
  FDodatKod: TFDodatKod;

implementation

{$R *.dfm}

uses VpisDod;
procedure  TFdodatKod.Prikazi(kd: string) ;
begin
  dir := ExtractfilePath(application.ExeName) ;
  adoquery1.connectionString := 'FILE NAME=' + dir + 'strojna.udl';
  kdd := kd ;
  label1.Caption := 'Koda = ' + kd ;
  Adoquery1.sql.clear ;
  Adoquery1.sql.add('select * from dodatkod where koda = :KD') ;
 // Adoquery1.sql.add('select * from dodatkod') ;
  Adoquery1.parameters[0].name := 'KD' ;
  Adoquery1.parameters[0].value := kd;
  Adoquery1.open ;
  ShowModal ;
  Adoquery1.close ;
end;

procedure TFDodatKod.Button1Click(Sender: TObject);
  var nz : string ;
begin
  nz := FvpisDod.vpis ;
  if nz <> '' then
  begin
    Adoquery1.append ;
    adoquery1koda.Value := kdd ;
    adoquery1naziv.Value := nz ;
    Adoquery1.Post ;
  end;
end;

procedure TFDodatKod.Button2Click(Sender: TObject);
  var excel : variant ;
      rw,cl : integer ;
begin
  excel := GetActiveOLEObject(Excelapp);
 // rw := excel.selection.row ;
  //cl := excel.selection.col ;
  adoquery1.FieldByName('naziv').Value := excel.activeCell.value ;
end;

procedure TFDodatKod.Button3Click(Sender: TObject);
  var ii : integer ;
begin
  ii := MessageDlg('Ali zares želiš izbrisati?',mtConfirmation,[mbYes, mbNo],0);
  if ii = 6 then Adoquery1.delete ;
end;

procedure TFDodatKod.Getlist(kd : string; var Listoro : TstringList) ;
begin
  dir := ExtractfilePath(application.ExeName) ;
  adoquery1.connectionString := 'FILE NAME=' + dir + 'strojna.udl';
  Adoquery1.sql.clear ;
  Adoquery1.sql.add('select * from dodatkod where koda = :KD') ;
  Adoquery1.parameters[0].name := 'KD' ;
  Adoquery1.parameters[0].value := kd;
  Adoquery1.open ;
  if not Adoquery1.isempty then
  begin
    while not Adoquery1.eof do
    begin
      listoro.add(Adoquery1naziv.value) ;
      Adoquery1.Next
    end;
  end;
  Adoquery1.close ;
end;

end.
