unit SemafData;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB,deklar;

type
  TFsemafdata = class(TForm)
    ADOQuery1: TADOQuery;
    ADOQuery2: TADOQuery;
  private
    procedure SetConnect ;
    function Tmlcas(premer : integer) : Tdatetime;
  public
    Procedure GetIzmDat(var dat : TdateTime; var izm : integer) ;
    function PrevdatIzm(dat : tdateTime; izm,stpost : Integer) : Integer ;
    function GetZapisCas(ids,stpost : integer; sx : string) : TdateTime;
    Procedure Zapis(stpost,izb : integer) ;
  end;

var
  Fsemafdata: TFsemafdata;

implementation

{$R *.dfm}


Procedure TFsemafData.GetIzmDat(var dat : TdateTime; var izm : integer) ;
  var  tt,t1,t2,t3 : Tdatetime ;
begin
  t1 := StrToTime('6:00:00') ;
  t2 := StrToTime('14:00:00') ;
  t3 := StrToTime('22:00:00') ;
  tt := time ;
  dat := date ;
  if tt < t1 then
  begin
    dat := dat - 1;
    izm := 3
  end;
  if (tt < t2) and (tt >= t1) then izm := 1 ;
  if (tt < t3) and (tt >= t2) then izm := 2 ;
  if tt >= t3 then izm := 3 ;
end;

procedure TFsemafData.SetConnect ;
  var dir : string ;
begin
  dir := ExtractfilePath(application.ExeName) ;
  adoquery1.connectionString := 'FILE NAME=' + dir + 'strojna.udl';
end;

function TFsemafData.PrevdatIzm(dat : tdateTime; izm,stpost : Integer) : Integer ;
  var lgtxt : string ;
begin
  try
    setconnect ;
    Adoquery1.Sql.Clear ;
    Adoquery1.Sql.Add('select * from GenDnevi where (datum =:DAT) and (izmena = :IZM) and (stpost = :STP)') ;
    Adoquery1.Parameters[0].name := 'DAT' ;
    Adoquery1.Parameters[0].value := dat ;
    Adoquery1.Parameters[1].name := 'IZM' ;
    Adoquery1.Parameters[1].value := izm ;
    Adoquery1.Parameters[2].name := 'STP' ;
    Adoquery1.Parameters[2].value := stpost ;
    adoquery1.open ;
    if adoquery1.isempty then result := 0
                         else result := Adoquery1.fieldBYName('ident').value ;
    Adoquery1.Close ;
  except
    lgtxt := IntTostr(stpost) + ' Branje ident zapisa semaforja' ;
    Pisilog(lgtxt) ;
    result := 0
  end;
end;

// funkcija vrne èas zadnje meritve
function TFsemafData.GetZapisCas(ids,stpost : integer; sx : string) : TdateTime;
  var tt : TdateTime ;
      lgtxt : string ;
begin
  if (sx = '408203500') or (sx = '408203600') then
  begin
    if sx = '408203500' then tt := Tmlcas(145) ;
    if sx = '408203600' then tt := Tmlcas(180) ;
    if tt < date  then result := 0  else result := tt ;
  end else
  begin
    try
      setconnect ;
      Adoquery1.Sql.Clear ;
      Adoquery1.Sql.Add('select * from GenCasovni where (IDENT =:ID) and (stroj = :ZG) and (stpost = :STP)  order by cas') ;
      Adoquery1.Parameters[0].name := 'ID' ;
      Adoquery1.Parameters[0].value := ids ;
      Adoquery1.Parameters[1].name := 'ZG' ;
      Adoquery1.Parameters[1].value := sx ;
      Adoquery1.Parameters[2].name := 'STP' ;
      Adoquery1.Parameters[2].value := stpost ;
      adoquery1.open ;
      if adoquery1.isempty then result := 0
      else begin
        Adoquery1.First ;
        while Not Adoquery1.Eof  do
        begin
          tt := StrToTime(Adoquery1.fieldBYName('cas').value)  ;
          Adoquery1.next ;
        end;
        result := tt ;
      end;
      Adoquery1.Close ;
    except
      lgtxt := IntTostr(stpost) + ' Zapis èasa meritve' ;
      Pisilog(lgtxt) ;
     result := Now ;
    end;
  end;
end;


function TFsemafdata.Tmlcas(premer : integer) : Tdatetime;
begin
  adoquery2.sql.clear ;
  Adoquery2.SQL.Add('select * from tmlmeritve where premer = :PRM order by èas DESC') ;
  Adoquery2.Parameters[0].Value := premer ;
  Adoquery2.Parameters[0].name := 'PRM' ;
  adoquery2.Open ;
  //Adoquery2.Last ;
  if not adoquery2.isempty then result := Adoquery2.FieldByName('èas').Value else result := date-1000 ;
  Adoquery2.Close ;
end;


Procedure TFsemafData.Zapis(stpost,izb : integer) ;
  var dat,tim,t1,t2,t3 : TdateTime ;
      izm ,ipr: integer ;
begin
  setconnect ;
  GetIzmdat(dat,izm) ;
  ipr := PrevdatIzm(dat,izm,stpost) ;
  if ipr = 0  then
  begin
    Adoquery1.Sql.Clear ;
    Adoquery1.Sql.Add('INSERT INTO Gendnevi(stpost,datum,izmena) VALUES(:STP, :DAT, :IZM)') ;
    AdoQuery1.Parameters[0].Name := 'STP' ;
    AdoQuery1.Parameters[0].value := stpost ;
    AdoQuery1.Parameters[1].Name := 'DAT' ;
    AdoQuery1.Parameters[1].value := dat ;
    AdoQuery1.Parameters[2].Name := 'IZM' ;
    AdoQuery1.Parameters[2].value := izm ;
    AdoQuery1.ExecSQL ;
    ipr := PrevdatIzm(dat,izm,stpost) ;
  end;

  Adoquery1.Sql.Clear ;
  Adoquery1.Sql.Add('INSERT INTO Gencasovni(stpost,ident,stroj,cas) VALUES(:STP, :ID, :ZG, :CS)') ;
  AdoQuery1.Parameters[0].Name := 'STP' ;
  AdoQuery1.Parameters[0].value := stpost ;
  AdoQuery1.Parameters[1].Name := 'ID' ;
  AdoQuery1.Parameters[1].value := ipr ;
  AdoQuery1.Parameters[2].Name := 'ZG' ;
  AdoQuery1.Parameters[2].value := izb ;
  AdoQuery1.Parameters[3].Name := 'CS' ;
  AdoQuery1.Parameters[3].value := time ;
  AdoQuery1.ExecSQL ;
end;

end.
