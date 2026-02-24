unit sinapro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB, deklar, comObj,pomoc;

type
  TFsinapro = class(TForm)
    ADOQuery1: TADOQuery;
    ADOQuery2: TADOQuery;
  private
    { Private declarations }
  public
    procedure getenote(var listEnote : tlist) ;
    procedure getDelavnice(ident : Integer;var listSkup : tlist) ;
    procedure GetStroji(ident : Integer;var listStroji : tlist) ;
    procedure Getkoda1(ident: integer; var listak : TstringList) ;
    Function PreveriStroj(idstr: integer) : boolean ;
    function Getdelavec(ident: integer) : string ;
  end;

var
  Fsinapro: TFsinapro;

implementation

{$R *.dfm}

// lista delovnih enot - uporablja se pri vpisu strojev
procedure TFSinapro.getenote(var listEnote : tlist) ;
  var pp : ^zapis ;
begin
  AdoQuery1.SQL.Clear ;
  AdoQuery1.sql.Add('Select * from t_pod_orgenota') ;
   try
      AdoQuery1.Open ;
   except
       on E: Exception do ShowMessage(E.Message) ;
   end;

   if adoQuery1.eof then ShowMessage('ne morem odperti') ;
   while Not AdoQuery1.Eof  do
   begin
     new(pp) ;
     pp^.ident := 1;
     pp^.naziv :=  '1EEEE'  ;
     pp^.ident := Adoquery1.FieldByName('st_orgenota_id').value ;
     pp^.naziv := Adoquery1.FieldByName('naz_orgenota').value  ;
     ListEnote.Add(pp) ;
     AdoQuery1.Next ;
   end;
   Adoquery1.Close ;
end ;


// lista delavnic za dolèeno delovno enoto - uporablja se pri vpisu strojev
procedure TFSinapro.getDelavnice(ident : Integer;var listSkup : tlist) ;
  var pp : ^zapis ;
begin
  AdoQuery1.SQL.Clear ;
  AdoQuery1.sql.Add('Select * from t_pod_delavnica where (st_OrgEnota_ID = :ID) and (st_podjetje_ID = ''1060'')') ;
  AdoQuery1.Parameters[0].value := ident ;
  AdoQuery1.Parameters[0].name := 'ID' ;
  AdoQuery1.Open ;
  Adoquery1.First ;
  while Not AdoQuery1.Eof  do
  begin
     new(pp) ;
     pp^.ident := Adoquery1.FieldByName('st_delavnica_id').value ;
     pp^.naziv := Adoquery1.FieldByName('naz_delavnica').value  ;
     ListSkup.Add(pp) ;
     AdoQuery1.Next ;
   end;
   Adoquery1.Close ;
end ;


// lista strojev za doèeèno delavnico  - uporablja se pri vpisu strojev
procedure TFSinapro.GetStroji(ident : Integer;var listStroji : tlist) ;
  var pp : ^zapis ;
      str : int64 ;
begin
   AdoQuery1.SQL.Clear ;
   AdoQuery1.sql.Add('Select * from t_pod_stroj where (st_delavnica_ID = :ID) and (st_podjetje_ID = ''1060'')') ;
   AdoQuery1.Parameters[0].value := ident ;
   AdoQuery1.Parameters[0].name := 'ID' ;
   AdoQuery1.Open ;
   Adoquery1.First ;
   while Not AdoQuery1.Eof  do
   begin
     str := Adoquery1.FieldByName('st_stroj_ID').value ;
     AdoQuery2.SQL.Clear ;
     AdoQuery2.sql.Add('Select * from t_del_stanjestroj (where st_stroj_ID  = :ST) and (st_podjetje_ID = ''1060'')') ;
     AdoQuery2.Parameters[0].value := str ;
     AdoQuery2.Parameters[0].name := 'ST' ;
     AdoQuery2.Open ;
     new(pp) ;
     pp^.izbran := false ;
     pp^.ident := str ;
     pp^.naziv := Adoquery1.FieldByName('naz_stroja').value  ;
     ListStroji.Add(pp) ;
     adoquery2.Close ;
     AdoQuery1.Next ;
   end;
   Adoquery1.Close ;
end;


// pridobim listo kod, ki se trenutno izdeluje na dooèenem stroju (praviloma je ena sama)
procedure TFsinapro.Getkoda1(ident: integer; var listak : TstringList) ;
  var deln,kd : string ;
      ii,ll,jx : Integer ;
      lista : TstringList ;
      csl,str : string ;
begin
   AdoQuery1.SQL.Clear ;
   AdoQuery1.sql.Add('Select * from t_del_stanjestroj where (st_stroj_ID = :ID) and (cas_zacetek >= :DAT) and (st_podjetje_ID = ''1060'')') ;
   AdoQuery1.Parameters[0].value := ident ;
   AdoQuery1.Parameters[0].name := 'ID' ;
   AdoQuery1.Parameters[1].value := date-3 ;
   AdoQuery1.Parameters[1].name := 'DAT' ;
   try
     AdoQuery1.Open ;
   except
     pisiLog('branje kod iz sinaproja') ;
     exit ;
   end;
   if not Adoquery1.IsEmpty then
   begin
     str := Adoquery1.FieldByName('t_delstanjestroj_ID').Value ;
     adoquery1.Close ;
     AdoQuery2.SQL.Clear ;
     AdoQuery2.sql.Add('Select * from t_del_stanjeoperacija where t_delstanjestroj_ID = :OP') ;
     AdoQuery2.Parameters[0].value := str ;
     AdoQuery2.Parameters[0].name := 'OP' ;
     Adoquery2.open ;
     if not Adoquery2.IsEmpty then
     begin
        csl := Adoquery2.FieldByName('st_caslist_ID').Value ;
        adoquery1.SQL.Clear ;
        AdoQuery1.sql.Add('Select * from t_pod_caslistvsi where st_caslist_ID = :CS') ;
        AdoQuery1.Parameters[0].value := csl ;
        AdoQuery1.Parameters[0].name := 'CS' ;
        AdoQuery1.Open ;
        deln := Adoquery1.FieldByName('st_delnal_id').Value ;
        Adoquery1.Close ;

        adoquery1.SQL.Clear ;
        AdoQuery1.sql.Add('Select * from t_pod_delnalog where st_delnal_ID = :ID') ;
        AdoQuery1.Parameters[0].value := deln ;
        AdoQuery1.Parameters[0].name := 'ID' ;
        AdoQuery1.Open ;
        kd := Adoquery1.FieldByName('st_izdelek_id').Value ;
        Adoquery1.Close ;

        AdoQuery1.SQL.Clear ;
        AdoQuery1.sql.Add('Select * from t_pod_izdelek where st_izdelek_ID = :ID') ;
        AdoQuery1.Parameters[0].value := kd ;
        AdoQuery1.Parameters[0].name := 'ID' ;
        AdoQuery1.Open ;
        kd := Adoquery1.FieldByName('klasifikacija').Value ;
        Adoquery1.Close ;
        if listak.Indexof(kd) < 0 then listak.Add(kd)
     end;
   end;
end ;


// preberem delavca ki je trenutno prijavljen na doloèenem stroju
function TFsinapro.Getdelavec(ident: integer) : string ;
  var deln,kd : string ;
      ii,ll,jx : Integer ;
      lista : TstringList ;
      csl,str : string ;
begin
   AdoQuery1.SQL.Clear ;
   AdoQuery1.sql.Add('Select * from t_del_stanjestroj where (st_stroj_ID = :ID) and (cas_zacetek >= :DAT) and (st_podjetje_ID = ''1060'')') ;
   AdoQuery1.Parameters[0].value := ident ;
   AdoQuery1.Parameters[0].name := 'ID' ;
   AdoQuery1.Parameters[1].value := date-3 ;
   AdoQuery1.Parameters[1].name := 'DAT' ;
   AdoQuery1.Open ;
   if not Adoquery1.IsEmpty then
   begin
     str := Adoquery1.FieldByName('t_delstanjestroj_ID').Value ;
     adoquery1.Close ;
     AdoQuery2.SQL.Clear ;
     AdoQuery2.sql.Add('Select * from t_del_stanjedelavec where (t_delstanjestroj_ID = :OP) and (st_podjetje_ID = ''1060'')') ;
     AdoQuery2.Parameters[0].value := str ;
     AdoQuery2.Parameters[0].name := 'OP' ;
     Adoquery2.open ;
     if not Adoquery2.IsEmpty then
     begin
        csl := Adoquery2.FieldByName('st_delavec_ID').Value ;
        adoquery2.Close ;
        Adoquery2.SQL.Clear ;
        Adoquery2.SQL.Add('select * from t_pod_delavec where st_delavec_ID = :ID') ;
        AdoQuery2.Parameters[0].value := csl ;
        AdoQuery2.Parameters[0].name := 'ID' ;
        Adoquery2.open ;
        if not Adoquery2.IsEmpty then
          result := Adoquery2.FieldByName('naz_ime').Value + ' ' + Adoquery2.FieldByName('naz_priimek').Value
        else result := '' ;
     end else result := '' ;
     Adoquery2.Close ;
   end else result := '';
   Adoquery1.Close ;
end;

// preverim èe je doloèeni stroj trenutno aktiven
Function TFsinapro.PreveriStroj(idstr: integer) : boolean ;
begin
   Adoquery1.sql.clear ;
   Adoquery1.sql.add('select * from  t_del_stanjestroj where (st_stroj_ID  = :ZG) and (st_podjetje_ID = ''1060'')') ;
   Adoquery1.Parameters[0].name := 'ZG' ;
   Adoquery1.Parameters[0].value := idstr ;
   try
     Adoquery1.open ;
   except
     result := false ;
     exit ;
   end;
   if adoquery1.FieldByName('cas_zacetek').isnull then result := false
   else
   begin
      if adoquery1.FieldByName('cas_zast_zacetek').isnull then result := true else result := false ;
   end ;
   Adoquery1.Close ;
end;


end.
