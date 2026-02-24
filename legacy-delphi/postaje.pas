unit postaje;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Data.DB, Data.Win.ADODB,
  Vcl.Grids, Vcl.DBGrids, pomoc, Vcl.StdCtrls, VpisStroj, Vcl.Menus;

type
  TFpostaje = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    ADOQuery1: TADOQuery;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Label2: TLabel;
    Button4: TButton;
    ADOQuery1stPost: TAutoIncField;
    ADOQuery1imerac: TStringField;
    ADOQuery1com: TWordField;
    ADOQuery1opis: TStringField;
    ADOQuery1lokal: TWordField;
    Label3: TLabel;
    Label4: TLabel;
    ADOQuery1imekon: TStringField;
    Label1: TLabel;
    MainMenu1: TMainMenu;
    Urejanje1: TMenuItem;
    Vpismerilnegamesta1: TMenuItem;
    Briimerilnomesto1: TMenuItem;
    ADOQuery1postkoda: TStringField;
    ADOQuery1stevrsta: TWordField;
    ADOQuery1izbiraKd: TWordField;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Vpismerilnegamesta1Click(Sender: TObject);
    procedure Briimerilnomesto1Click(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
  private
    procedure SetConnect ;
  public
    izbor : string ;
    adm : boolean ;
    Procedure pregled(admin : boolean) ;
    Function Getpost : integer ;
    Function getcom : string ;
    Function getlokal : boolean ;
    Function GetImePost : string ;
    Function getimekt : string ;
    Function Gettex : string ;
    Function getvrsta : integer ;
    Function Getizbira : integer ;
  end;

var
  Fpostaje: TFpostaje;

implementation

{$R *.dfm}
  uses zacetna ;

procedure TFpostaje.Briimerilnomesto1Click(Sender: TObject);
  var ii : integer ;
begin
 if not adm then  exit ;
 ii := MessageDlg('Ali zares želiš izbrisati?',mtConfirmation,[mbYes, mbNo],0);
 if ii = 6 then  Adoquery1.delete ;
end;

procedure TFpostaje.Button1Click(Sender: TObject);
  var imerac : string ;
begin
  imerac := CompIme  ;
  Adoquery1.Append ;
  Adoquery1.FieldByName('imerac').Value := imerac ;
  Adoquery1.append ;
end;

Procedure TFPostaje.pregled(admin : boolean) ;
begin
  adm := admin ;
  setconnect ;
  panel1.Color := $02DEDAC0 ;
  label3.Caption := 'lokal = 0 - podatki na lokalnem raèunalniku' ;
  label4.Caption := 'lokal = 1 - podatki na serverju tsSpica' ;
  //panel1.Color := $02C00C0FF ;
 // if izbor = '' then label1.caption := CompIme else label1.caption := GetImePost  ;
  label1.caption := GetImePost  ;
  DBGrid1.readonly := not admin ;
  Adoquery1.sql.clear ;
  Adoquery1.sql.add('SELECT * FROM postaje order by postkoda') ;
  Adoquery1.open ;
  ShowModal ;
end;

procedure TFpostaje.SetConnect ;
  var dir : string ;
begin
  dir := ExtractfilePath(application.ExeName) ;
  adoquery1.connectionString := 'FILE NAME=' + dir + 'strojna.udl';
 // adoquery1.connectionString := 'FILE NAME=' + dir + 'obdel.udl';
 // adoquery2.connectionString := 'FILE NAME=' + dir + 'obdel.udl';
end;

procedure TFpostaje.Vpismerilnegamesta1Click(Sender: TObject);
  var imerac : string ;
begin
  imerac := CompIme  ;
  Adoquery1.Append ;
  Adoquery1.FieldByName('imerac').Value := imerac ;
  Adoquery1.post ;
end;

Function TFpostaje.GetImePost : string ;
    var imerac : string ;
begin
  setconnect ;
  if izbor = '' then imerac := CompIme else imerac := izbor  ;
  // imerac := 'ESI19029' ;
  //imerac := 'ESI19046' ;
  Adoquery1.sql.clear ;
   FvpisStroj.test ;
  Adoquery1.sql.add('SELECT * FROM postaje where imerac = :IME') ;
  AdoQuery1.Parameters[0].Name := 'IME' ;
  AdoQuery1.Parameters[0].value := imerac ;
  Adoquery1.open ;

  if AdoQuery1.isempty then result := '(ni prijave)'
    else result := Adoquery1.fieldByName('opis').value ;
  Adoquery1.close ;
end;

Function TFPostaje.Getpost : integer ;
  var imerac : string ;
begin
  setconnect ;
  if izbor = '' then imerac := CompIme else imerac := izbor  ;
  Adoquery1.sql.clear ;
  FvpisStroj.test ;
  Adoquery1.sql.add('SELECT * FROM postaje where imerac = :IME') ;
  AdoQuery1.Parameters[0].Name := 'IME' ;
  AdoQuery1.Parameters[0].value := imerac ;
  Adoquery1.open ;

  if AdoQuery1.isempty then result := 0
    else result := Adoquery1.fieldByName('stpost').value ;
  Adoquery1.close ;
end;

Function TFPostaje.Gettex : string ;
  var imerac : string ;
begin
  setconnect ;
  if izbor = '' then imerac := CompIme else imerac := izbor  ;
  // imerac := 'ESI19029' ;
  //imerac := 'ESI19046' ;
  Adoquery1.sql.clear ;
  Adoquery1.sql.add('SELECT * FROM postaje where imerac = :IME') ;
  AdoQuery1.Parameters[0].Name := 'IME' ;
  AdoQuery1.Parameters[0].value := imerac ;
  Adoquery1.open ;

  if AdoQuery1.isempty then result := ''
    else result := Adoquery1.fieldByName('postkoda').asstring ;
  Adoquery1.close ;
end;

procedure TFpostaje.Button2Click(Sender: TObject);
  var ii : integer ;
begin
 if not adm then  exit ;
 ii := MessageDlg('Ali zares želiš izbrisati?',mtConfirmation,[mbYes, mbNo],0);
 if ii = 6 then  Adoquery1.delete ;
end;

procedure TFpostaje.Button3Click(Sender: TObject);
begin
  if adm  then
  begin
    izbor := trim(Adoquery1.FieldByName('imerac').Value) ;
    label1.caption := Adoquery1.FieldByName('opis').Value ;
  end;
  Fzacetna.label11.caption := Adoquery1.FieldByName('opis').Value
end;

procedure TFpostaje.Button4Click(Sender: TObject);
begin
  Close
end;

procedure TFpostaje.DBGrid1CellClick(Column: TColumn);
begin
    izbor := trim(Adoquery1.FieldByName('imerac').asstring) ;
    label1.caption := Adoquery1.FieldByName('opis').asstring ;

  Fzacetna.label11.caption := Adoquery1.FieldByName('opis').asstring
end;

procedure TFpostaje.FormActivate(Sender: TObject);
begin
  izbor := '' ;
end;

Function TFpostaje.getcom : string ;
  var imerac : string ;
      cm : string ;
begin
  setconnect ;
  if izbor = '' then imerac := CompIme else imerac := izbor;

  Adoquery1.sql.clear ;
  Adoquery1.sql.add('SELECT * FROM postaje where imerac = :IME') ;
  AdoQuery1.Parameters[0].Name := 'IME' ;
  AdoQuery1.Parameters[0].value := imerac ;
  Adoquery1.open ;

  if AdoQuery1.isempty then result := ''
     else result := IntTostr(Adoquery1.fieldByName('com').value) ;
  Adoquery1.close ;
end;

Function TFpostaje.Getizbira : integer ;
  var imerac : string ;
      cm : string ;
begin
  setconnect ;
  if izbor = '' then imerac := CompIme else imerac := izbor;

  Adoquery1.sql.clear ;
  Adoquery1.sql.add('SELECT * FROM postaje where imerac = :IME') ;
  AdoQuery1.Parameters[0].Name := 'IME' ;
  AdoQuery1.Parameters[0].value := imerac ;
  Adoquery1.open ;

  if AdoQuery1.isempty then result := 0
     else result := Adoquery1.fieldByName('IzbiraKd').value ;
  Adoquery1.close ;
end;


Function TFpostaje.getlokal : boolean ;
  var imerac : string ;
      cm : string ;
begin
  setconnect ;
  if izbor = '' then imerac := CompIme else imerac := izbor;
  //imerac := 'ESI19029' ;
 //imerac := 'ESI19046' ;
  Adoquery1.sql.clear ;
  Adoquery1.sql.add('SELECT * FROM postaje where imerac = :IME') ;
  AdoQuery1.Parameters[0].Name := 'IME' ;
  AdoQuery1.Parameters[0].value := imerac ;
  try
    Adoquery1.open ;

    if AdoQuery1.isempty then result := false
       else result := (Adoquery1.FieldByName('lokal').Value = 0) ;
    Adoquery1.close ;
  except
     result := true ;
  end;
end;

Function TFpostaje.getimekt : string ;
  var imerac : string ;
      cm : string ;
begin
  setconnect ;
  if izbor = '' then imerac := CompIme else imerac := izbor;

  Adoquery1.sql.clear ;
  Adoquery1.sql.add('SELECT * FROM postaje where imerac = :IME') ;
  AdoQuery1.Parameters[0].Name := 'IME' ;
  AdoQuery1.Parameters[0].value := imerac ;
  Adoquery1.open ;

  if AdoQuery1.isempty then result := ''
  else
    begin if Adoquery1.fieldByName('imekon').isnull then result := ''
          else
            result := Adoquery1.fieldByName('imekon').value ;
    end;
  Adoquery1.close ;
end;

Function TFpostaje.getvrsta : integer ;
  var imerac : string ;
      cm : string ;
begin
  setconnect ;
  if izbor = '' then imerac := CompIme else imerac := izbor;

  Adoquery1.sql.clear ;
  Adoquery1.sql.add('SELECT * FROM postaje where imerac = :IME') ;
  AdoQuery1.Parameters[0].Name := 'IME' ;
  AdoQuery1.Parameters[0].value := imerac ;
  Adoquery1.open ;

  if AdoQuery1.isempty then result := 6
    else result := Adoquery1.fieldByName('stevrsta').value ;

  Adoquery1.close ;
end;


end.
